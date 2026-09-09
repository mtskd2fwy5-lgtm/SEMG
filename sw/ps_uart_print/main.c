/*
 * PS-side UART printout of the PL EMG data stream (bare metal, Zynq-7000).
 *
 * Hardware assumptions (from design_1 BD / PS7 config):
 *   - UART1 routed to MIO 48/49, ref clock 100 MHz (PCW_ACT_UART
 *     value after build/enable_ps_uart.tcl), 115200-8N1.
 *   - AXI DMA 0 (S2MM only, direct register mode, no scatter-gather)
 *     at GP0 base 0x40400000, fed by emg_pl_export's 64-bit AXI-Stream.
 *   - DMA writes go through S_AXI_HP0 into DDR (0x0..0x1FFFFFFF).
 *   - PS UART, DMA and DDR are initialized by ps7_init (run by XSCT
 *     before this ELF is downloaded); this app never enables caches,
 *     so CPU reads of the DMA buffers are coherent by construction.
 *
 * Stream packet format (64-bit word, see src/rtl/emg_data_path.v):
 *   63:60 type   1=raw  2=feature  3=result
 *   59:56 channel
 *   55:52 feature/result id (raw: 0)
 *   51:48 reserved
 *   47:32 sequence
 *   31:0  payload (raw: 24-bit signed sample)
 * In DDR (little endian) the first u32 holds tdata[31:0] (payload) and
 * the second u32 holds tdata[63:32] (header).
 *
 * Data rates: raw 8 ch x 1 kSPS = 8000 pkt/s, features 20 windows/s x
 * 8 ch x 5 ids = 800 pkt/s -> ~8.8k packets/s (~70 KB/s), far beyond a
 * 115200-baud line, so the steady-state printout is decimated: full
 * decode of the first packets, then a status line per ~0.5 s.
 *
 * Build: see build.bat (Vivado's arm-none-eabi GCC, freestanding).
 * Run:   see run_xsct.tcl.
 */

typedef unsigned int  u32;
typedef int           i32;
typedef unsigned short u16;

/* ---- UART1 (Cadence UARTPS) ------------------------------------------ */

#define UART1_BASE      0xE0001000u
#define UART_CR         (*(volatile u32 *)(UART1_BASE + 0x00))
#define UART_MR         (*(volatile u32 *)(UART1_BASE + 0x04))
#define UART_BAUDGEN    (*(volatile u32 *)(UART1_BASE + 0x18))
#define UART_SR         (*(volatile u32 *)(UART1_BASE + 0x2C))
#define UART_BAUDDIV    (*(volatile u32 *)(UART1_BASE + 0x34))
#define UART_FIFO       (*(volatile u32 *)(UART1_BASE + 0x38))

#define UART_REF_CLK_HZ 100000000u   /* PCW_ACT_UART_PERIPHERAL_FREQMHZ */
#define UART_BAUDRATE   115200u

#define UART_CR_TXRST   0x00000020u
#define UART_CR_RXRST   0x00000040u
#define UART_CR_TXEN    0x00000010u
#define UART_CR_RXEN    0x00000004u
#define UART_CR_TXDIS   0x00000008u
#define UART_CR_RXDIS   0x00000002u
#define UART_SR_TXFULL  0x00000004u

static void uart_init(void)
{
    UART_CR = UART_CR_TXDIS | UART_CR_RXDIS;
    UART_CR = UART_CR_TXRST | UART_CR_RXRST;
    UART_MR = 0x26;                  /* 8 data bits, no parity, 1 stop */
    UART_BAUDGEN = 54;               /* CD = 100 MHz/(115200*16) = 54.25 */
    UART_BAUDDIV = 16;               /* BD = 0.25*64 = 16 -> 115207 bps  */
    UART_CR = UART_CR_TXEN | UART_CR_RXEN;
}

static void uart_putc(char c)
{
    while (UART_SR & UART_SR_TXFULL)
        ;
    UART_FIFO = (u32)(unsigned char)c;
}

static void uart_puts(const char *s)
{
    while (*s) {
        if (*s == '\n')
            uart_putc('\r');
        uart_putc(*s++);
    }
}

/* Minimal printf: %d %u %x %s %c, field widths ignored. */
static void print_dec(u32 v)
{
    char buf[11];
    int i = 10;
    buf[i] = '\0';
    if (!v) {
        uart_putc('0');
        return;
    }
    while (v && i) {
        buf[--i] = (char)('0' + (v % 10u));
        v /= 10u;
    }
    uart_puts(&buf[i]);
}

static void print_hex(u32 v)
{
    static const char h[] = "0123456789abcdef";
    int shift;
    uart_puts("0x");
    for (shift = 28; shift >= 0; shift -= 4)
        uart_putc(h[(v >> shift) & 0xFu]);
}

static void uprintf(const char *fmt, u32 a, u32 b, u32 c, u32 d)
{
    /* Four arguments keep the call sites short; extra args are unused. */
    u32 args[4];
    args[0] = a; args[1] = b; args[2] = c; args[3] = d;
    {
        const char *p = fmt;
        int ai = 0;
        while (*p) {
            if (*p == '%' && p[1]) {
                u32 v = (ai < 4) ? args[ai++] : 0;
                switch (p[1]) {
                case 'd':
                    if ((i32)v < 0) { uart_putc('-'); v = (u32)(-(i32)v); }
                    print_dec(v);
                    break;
                case 'u':
                    print_dec(v);
                    break;
                case 'x':
                    print_hex(v);
                    break;
                case 's':
                    uart_puts((const char *)v);
                    break;
                case 'c':
                    uart_putc((char)v);
                    break;
                default:
                    uart_putc('%');
                    uart_putc(p[1]);
                    break;
                }
                p += 2;
            } else {
                uart_putc(*p++);
            }
        }
    }
}

/* ---- AXI DMA (S2MM, direct register mode) ----------------------------- */

#define AXIDMA_BASE     0x40400000u
#define S2MM_DMACR      (*(volatile u32 *)(AXIDMA_BASE + 0x30))
#define S2MM_DMASR      (*(volatile u32 *)(AXIDMA_BASE + 0x34))
#define S2MM_DA         (*(volatile u32 *)(AXIDMA_BASE + 0x38))
#define S2MM_LENGTH     (*(volatile u32 *)(AXIDMA_BASE + 0x48))

#define DMACR_RUN       0x00000001u
#define DMACR_RESET     0x00000004u
#define DMASR_HALTED    0x00000001u
#define DMASR_ERROR_MASK 0x000007F0u  /* IntErr/SlvErr/DecErr/SG errors */
#define DMASR_IOC       0x00001000u

static void dma_init(void)
{
    S2MM_DMACR = DMACR_RESET;
    while (!(S2MM_DMASR & DMASR_HALTED))
        ;
    S2MM_DMACR = DMACR_RUN;          /* no IRQ: polling on IOC */
}

static void dma_arm(u32 addr, u32 bytes)
{
    S2MM_DA = addr;
    S2MM_LENGTH = bytes;             /* write starts the transfer */
}

/* Returns 0 on IOC, else the sticky error bits. */
static u32 dma_wait(void)
{
    u32 spins = 0;
    for (;;) {
        u32 sr = S2MM_DMASR;
        if (sr & DMASR_ERROR_MASK) {
            S2MM_DMASR = sr & DMASR_ERROR_MASK;   /* ack errors */
            return sr & DMASR_ERROR_MASK;
        }
        if (sr & DMASR_IOC) {
            S2MM_DMASR = DMASR_IOC;               /* ack completion */
            return 0;
        }
        if (++spins == 400000000u)                /* ~ a few seconds */
            uart_puts("[DMA] no PL data yet - check ADS1299/DRDY\n");
    }
}

/* ---- Packet parsing ---------------------------------------------------- */

#define BUF_PACKETS 512                 /* 512 x 8-byte packets */
#define BUF_BYTES   (BUF_PACKETS * 8)

extern unsigned char __dma_buf[];      /* linker-placed, NOLOAD @ 0x11000000 */
static volatile u32 *const dma_buf[2] = {
    (volatile u32 *)__dma_buf,
    (volatile u32 *)(__dma_buf + BUF_BYTES),
};

static const char *const feat_names[5] = {
    "MAV", "WL", "ENERGY", "ZC", "SSC"
};

static u32 raw_cnt, feat_cnt, res_cnt, other_cnt;
static u32 raw_latest[8];
static u32 feat_mav[8];                /* latest MAV per channel */
static u32 parsed_total;
static u32 next_report;

static void parse_packet(u32 payload, u32 hdr)
{
    u32 type = hdr >> 28;
    u32 ch   = (hdr >> 24) & 0xFu;
    u32 id   = (hdr >> 20) & 0xFu;
    u32 seq  = hdr & 0xFFFFu;

    switch (type) {
    case 1:                            /* raw sample, 24-bit signed */
        if (ch < 8) {
            i32 v = (i32)(payload << 8) >> 8;
            raw_latest[ch] = (u32)v;
        }
        raw_cnt++;
        break;
    case 2:                            /* window feature */
        if (ch < 8) {
            if (id == 0)
                feat_mav[ch] = payload;   /* MAV = id 0 */
        }
        feat_cnt++;
        break;
    case 3:                            /* classifier result (future NN) */
        res_cnt++;
        break;
    default:
        other_cnt++;
        return;                        /* don't count as packet */
    }

    if (parsed_total < 16u) {
        /* verbose decode of the first packets */
        uart_puts((type == 1) ? "RAW " : (type == 2) ? "FEAT" : "RES ");
        uprintf(" ch=%u", ch, 0, 0, 0);
        if (type == 2)
            uprintf(" %s", (u32)(id < 5 ? feat_names[id] : "?"), 0, 0, 0);
        if (type == 3)
            uprintf(" id=%u", id, 0, 0, 0);
        uprintf(" seq=%u payload=%d (0x%x)\n", seq, payload, payload, 0);
    } else if (parsed_total >= next_report) {
        next_report = parsed_total + 8192u;
        uart_puts("[STAT] raw=");
        print_dec(raw_cnt);
        uart_puts(" feat=");
        print_dec(feat_cnt);
        uart_puts(" res=");
        print_dec(res_cnt);
        uart_puts(" | MAV:");
        for (ch = 0; ch < 8; ch++) {
            uart_putc(' ');
            print_dec(feat_mav[ch]);
        }
        uart_puts("\n[STAT] raw:");
        for (ch = 0; ch < 8; ch++) {
            uart_putc(' ');
            print_dec(raw_latest[ch]);
        }
        uart_puts("\n");
    }
    parsed_total++;
}

static void parse_buffer(volatile u32 *buf)
{
    u32 w;
    for (w = 0; w < BUF_PACKETS; w++)
        parse_packet(buf[2 * w], buf[2 * w + 1]);  /* payload, header */
}

/* ---- Minimal runtime bits (freestanding, no libc) ---------------------- */

void *memcpy(void *dst, const void *src, u32 n)
{
    unsigned char *d = dst;
    const unsigned char *s = src;
    while (n--)
        *d++ = *s++;
    return dst;
}

void *memset(void *dst, int v, u32 n)
{
    unsigned char *d = dst;
    while (n--)
        *d++ = (unsigned char)v;
    return dst;
}

/* ---- Main -------------------------------------------------------------- */

int main(void)
{
    int active = 0;
    u32 err;

    uart_init();
    uart_puts("\n=== sEMG hand-motion PL stream monitor ===\n");
    uart_puts("UART1 115200-8N1, AXI DMA @ 0x40400000 (S2MM polling)\n");
    uart_puts("packet: type/ch/id/seq/payload; 1=raw 2=feature 3=result\n");
    uart_puts("expected: ~8000 raw/s, ~800 feature/s\n\n");

    dma_init();
    dma_arm((u32)dma_buf[active], BUF_BYTES);

    for (;;) {
        err = dma_wait();
        if (err) {
            uprintf("[DMA] error status 0x%x, resetting\n", err, 0, 0, 0);
            dma_init();
        }
        /* re-arm first so the PL stream keeps draining into the other
         * buffer while this one is parsed and printed */
        active ^= 1;
        dma_arm((u32)dma_buf[active], BUF_BYTES);
        parse_buffer(dma_buf[active ^ 1]);
    }
    return 0;                          /* not reached */
}
