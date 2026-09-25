/*
 * PS-side UART printout of the PL EMG data stream (bare metal, Zynq-7000).
 *
 * Hardware assumptions (from design_1 BD / PS7 config):
 *   - UART0 routed to MIO 14/15, ref clock 100 MHz (PCW_ACT_UART
 *     value after build/enable_ps_uart.tcl), 115200-8N1.
 *   - AXI DMA 0 (S2MM only, direct register mode, no scatter-gather)
 *     at GP0 base 0x40400000, fed by emg_pl_export's 64-bit AXI-Stream.
 *   - DMA writes go through S_AXI_HP0 into DDR (0x0..0x1FFFFFFF).
 *   - PS UART, DMA and DDR are initialized by ps7_init (run by XSCT
 *     before this ELF is downloaded); this app never enables caches,
 *     so CPU reads of the DMA buffers are coherent by construction.
 *
 * Stream packet format (64-bit word, see src/rtl/emg_data_path.v):
 *   63:60 type   1=raw  2=feature  3=result  4=fatigue (ids 8/9)
 *   59:56 channel
 *   55:52 feature/result id (raw: 0)
 *   51:48 reserved
 *   47:32 sequence
 *   31:0  payload (raw: 24-bit signed sample)
 * In DDR (little endian) the first u32 holds tdata[31:0] (payload) and
 * the second u32 holds tdata[63:32] (header).
 *
 * Data rates: raw 8 ch x 4 kSPS = 32000 pkt/s, features 40 windows/s x
 * 8 ch x 5 ids = 1600 pkt/s, fatigue 2 windows/s x 2 ids = 4 pkt/s
 * -> ~33.6k packets/s (~270 KB/s), far beyond
 * a 115200-baud line, so the steady-state printout is decimated: full
 * decode of the first packets, then a status line per ~0.5 s.
 *
 * Modes (runtime-switchable, no rebuild): send 'r' on the UART to toggle
 * between
 *   monitor mode (115200): text rows [CAL]/F/R/T/[STAT] as described below
 *   record  mode (2 Mbaud, CH340C-capable): raw binary frames for dataset
 *     capture - AA 55 | seq u16 LE | 8 x int24 LE (ch0..ch7) = 28 B/frame,
 *     one frame per complete 8-channel sample group.  Companion PC tool
 *     tools/record_uart.py (labels + contract CSV; its 'r' command toggles
 *     back).  No text is printed in record mode to keep the frame stream
 *     clean; switching modes reconfigures the baud rate and restarts DMA,
 *     and returning to monitor mode reruns the rest calibration.
 *
 * Build: see build.bat (Vivado's arm-none-eabi GCC, freestanding).
 * Run:   see run_xsct.tcl.
 */
#include <string.h>
#include <stdint.h>

typedef unsigned int  u32;
typedef int           i32;
typedef unsigned short u16;

/* ---- UART0 (Cadence UARTPS) ------------------------------------------ */

#define UART_BASE       0xE0000000u
#define UART_CR         (*(volatile u32 *)(UART_BASE + 0x00))
#define UART_MR         (*(volatile u32 *)(UART_BASE + 0x04))
#define UART_BAUDGEN    (*(volatile u32 *)(UART_BASE + 0x18))
#define UART_SR         (*(volatile u32 *)(UART_BASE + 0x2C))
#define UART_FIFO       (*(volatile u32 *)(UART_BASE + 0x30))  /* TX/RX FIFO, 0x30 not 0x38 */
#define UART_BAUDDIV    (*(volatile u32 *)(UART_BASE + 0x34))

#define UART_REF_CLK_HZ 100000000u   /* PCW_ACT_UART_PERIPHERAL_FREQMHZ */

/* Cadence UARTPS register bit fields (fsbl_uartps.h / xuartps_hw.h) */
#define UART_CR_TXDIS   0x00000020u
#define UART_CR_TXEN    0x00000010u
#define UART_CR_RXDIS   0x00000008u
#define UART_CR_RXEN    0x00000004u
#define UART_CR_TXRST   0x00000002u
#define UART_CR_RXRST   0x00000001u
#define UART_MR_8N1     0x00000020u  /* charlen8(0) | parity_none(0x20) | stop1(0) */
#define UART_SR_TXFULL  0x00000010u
#define UART_SR_TXEMPTY 0x00000008u
#define UART_SR_RXEMPTY 0x00000002u  /* 1 = RX FIFO empty */

/* Runtime mode: 0 = monitor (115200, text rows), 1 = record (2 Mbaud,
 * binary RAWREC frames).  Toggled by the 'r' UART command, see mode_set. */
#define MODE_MONITOR    0
#define MODE_RECORD     1
#define MON_BAUDGEN     62         /* 100e6/(62*14) = 115207 bps */
#define MON_BAUDDIV     13
#define REC_BAUDGEN     5          /* 100e6/(5*10) = 2.0 Mbaud exact */
#define REC_BAUDDIV     9

static u32 g_mode = MODE_MONITOR;

static void uart_reconfig(u32 baudgen, u32 bauddiv)
{
    while (!(UART_SR & UART_SR_TXEMPTY))   /* drain pending TX at old baud */
        ;
    UART_CR = UART_CR_TXDIS | UART_CR_RXDIS;
    UART_CR = UART_CR_TXRST | UART_CR_RXRST;   /* also clears both FIFOs */
    UART_MR = UART_MR_8N1;           /* 8 data bits, no parity, 1 stop */
    /* baud = clk / (BAUDGEN * (BAUDDIV+1)); one divider serves TX and RX */
    UART_BAUDGEN = baudgen;
    UART_BAUDDIV = bauddiv;
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
                    uart_puts((const char *)(uintptr_t)v);
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
#define S2MM_DA         (*(volatile u32 *)(AXIDMA_BASE + 0x48))
#define S2MM_LENGTH     (*(volatile u32 *)(AXIDMA_BASE + 0x58))

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
        if (++spins == 400000000u) {              /* ~ a few seconds */
            if (g_mode == MODE_MONITOR)           /* keep record TX clean */
                uart_puts("[DMA] no PL data yet - check ADS1299/DRDY\n");
        }
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
static int dma_active;                 /* which half-buffer DMA is filling */

static const char *const feat_names[5] = {
    "MAV", "WL", "ENERGY", "ZC", "SSC"
};

static u32 raw_cnt, feat_cnt, res_cnt, fat_cnt, other_cnt;
static u32 raw_latest[8];
static u32 feat_mav[8];                /* latest MAV per channel */
static u32 feat_vals[5][8];            /* [feature id][channel] of current window */
static u32 feat_win_cnt;               /* packets accumulated for current window */
static u32 res_logits[5];              /* INT32 logits of the current window */
static u32 res_cls;                    /* argmax class of the current window */
static u32 res_rows;                   /* result rows printed */
static u32 feat_rows;                  /* feature windows seen (print gate) */
static u32 fat_num2, fat_mdf;          /* id 8: window counter, mean MDF bin */
static u32 fat_level, fat_full, fat_energy;   /* id 9 fields */
static u32 parsed_total;
static u32 next_report;

/* Emit one CSV line per feature window in the training feature order
 * (tools/train_baseline.py make_windows): MAV ch0..7, WL ch0..7,
 * Energy ch0..7, ZC ch0..7, SSC ch0..7 -> exactly the 40 model inputs.
 * Printed for every 2nd window (~200-460 B x 20 rows/s, ~80% of a
 * 115200-baud line); windows are 100 ms with a 25 ms hop. */
static void print_feature_row(void)
{
    u32 id, ch;
    uart_putc('F');
    for (id = 0; id < 5; id++) {
        for (ch = 0; ch < 8; ch++) {
            uart_putc(',');
            print_dec(feat_vals[id][ch]);
        }
    }
    uart_puts("\r\n");
}

/* One line per inference window: 'R s=<seq> c=<class>', plus the raw
 * INT32 logits every 4th window.  The PL INT8 MLP emits six result
 * packets per window (ids 0..4 = logits, 5 = argmax class), all carrying
 * the sequence of the window-start feature packet.  Amortised ~28
 * bytes/window next to the ~460-byte F-rows stays within the 115200-baud
 * budget (~85% line utilisation). */

/* ---- Rest calibration / rest gate --------------------------------------- *
 * The NN misfires on rest (typically as fist) once electrodes are mounted.
 * PS-side fix: after boot (or after the 'c' command) drop ~2 s of windows,
 * then average CAL_WINDOWS per-channel MAVs into a rest baseline m0[ch]
 * and set the action threshold thr[ch] = max(3*m0[ch], CAL_FLOOR).
 * Later windows whose 8 MAVs all stay below thr[] are re-classified to
 * rest before the R row goes out (flagged g=1). PL stays untouched. */
#define CAL_DISCARD_WIN 80u    /* ~2 s of windows dropped (40 win/s) */
#define CAL_WINDOWS     16u    /* windows averaged into the baseline */
#define CAL_FLOOR       1000u  /* only binds for stuck-at-zero channels */

static u32 cal_stage;          /* 0=discard 1=collect 2=active */
static u32 cal_discard, cal_n;
static u32 cal_sum[8];
static u32 cal_base[8];        /* per-channel rest MAV baseline m0[ch] */
static u32 cal_thr[8];         /* per-channel action threshold */
static u32 gated_rows;         /* R rows re-classified by the gate */

static void cal_start(void)
{
    u32 ch;
    cal_stage = 0;
    cal_discard = 0;
    cal_n = 0;
    for (ch = 0; ch < 8; ch++)
        cal_sum[ch] = 0;
    uart_puts("[CAL] calibrating - stay relaxed (~2.4 s)\n");
}

/* Called once per completed feature window (MAVs of that window are in
 * feat_mav[] at this point). */
static void cal_on_window(void)
{
    u32 ch;
    if (cal_stage == 0u) {
        if (++cal_discard >= CAL_DISCARD_WIN) {
            cal_stage = 1u;
            cal_n = 0;
            for (ch = 0; ch < 8; ch++)
                cal_sum[ch] = 0;
        }
    } else if (cal_stage == 1u) {
        for (ch = 0; ch < 8; ch++)
            cal_sum[ch] += feat_mav[ch];
        if (++cal_n >= CAL_WINDOWS) {
            for (ch = 0; ch < 8; ch++) {
                cal_base[ch] = cal_sum[ch] >> 4;      /* / CAL_WINDOWS */
                cal_thr[ch] = 3u * cal_base[ch];
                if (cal_thr[ch] < CAL_FLOOR)
                    cal_thr[ch] = CAL_FLOOR;
            }
            cal_stage = 2u;
            uart_puts("[CAL] baseline MAV:");
            for (ch = 0; ch < 8; ch++) {
                uart_putc(' ');
                print_dec(cal_base[ch]);
            }
            uart_puts("\n[CAL] ready, thr = 3x:");
            for (ch = 0; ch < 8; ch++) {
                uart_putc(' ');
                print_dec(cal_thr[ch]);
            }
            uart_puts("\n");
        }
    }
}

/* 1 when every channel of the current window sits below its threshold. */
static u32 rest_gate(void)
{
    u32 ch;
    for (ch = 0; ch < 8; ch++)
        if (feat_mav[ch] >= cal_thr[ch])
            return 0;
    return 1;
}

/* Indicative R-row confidence, p = top1*100 / (sum|logits|+1): a fixed-
 * point stand-in for softmax (no exp on this freestanding build). */
static u32 logit_conf(void)
{
    u32 i, sum = 0;
    i32 v, top = (i32)res_logits[0];
    for (i = 0; i < 5; i++) {
        v = (i32)res_logits[i];
        sum += (v < 0) ? (u32)(-v) : (u32)v;
        if (v > top)
            top = v;
    }
    if (top <= 0)
        return 0;
    return ((u32)top * 100u) / (sum + 1u);
}

/* One line per inference window: 'R s=<seq> c=<class> p=<conf>[ g=1]',
 * plus the raw INT32 logits every 4th window.  The PL INT8 MLP emits six
 * result packets per window (ids 0..4 = logits, 5 = argmax class), all
 * carrying the sequence of the window-start feature packet.  p is the
 * indicative confidence (see logit_conf); g=1 marks a non-rest decision
 * re-classified to rest by the MAV gate.  Amortised ~40 bytes/window
 * next to the ~460-byte F-rows stays within the 115200-baud budget. */
static void print_result_row(u32 seq)
{
    u32 gated = 0;
    if (cal_stage == 2u && res_cls != 0u && rest_gate()) {
        res_cls = 0;                   /* window is at rest after all */
        gated = 1;
        gated_rows++;
    }
    uart_putc('R');
    uprintf(" s=%u c=%u", seq, res_cls, 0, 0);
    uprintf(" p=%u", logit_conf(), 0, 0, 0);
    if (gated)
        uart_puts(" g=1");
    if ((res_rows & 3u) == 0u) {
        uart_puts(" | L");
        uprintf(" %d %d", res_logits[0], res_logits[1], 0, 0);
        uprintf(" %d %d", res_logits[2], res_logits[3], 0, 0);
        uprintf(" %d", res_logits[4], 0, 0, 0);
    }
    uart_puts("\r\n");
    res_rows++;
}

/* One line per fatigue window (id 8+9 pair, ~2/s): 'T s=<seq> lv=<0..2>
 * mdf=<mean MDF bin> n2=<window counter> full=<hist filled> e=<energy>'.
 * lv comes from the 16-point MDF-history slope regression:
 * 0=NORM 1=MILD 2=FATIG.  ~55 B/row -> negligible next to the F/R rows. */
static void print_fatigue_row(u32 seq)
{
    static const char *const lv_names[3] = { "NORM", "MILD", "FATIG" };
    uart_putc('T');
    uprintf(" s=%u lv=%u", seq, fat_level, 0, 0);
    uprintf(" mdf=%u n2=%u", fat_mdf, fat_num2, 0, 0);
    uprintf(" full=%u e=%u", fat_full, fat_energy, 0, 0);
    if (fat_level < 3u)
        uprintf(" %s", (u32)(uintptr_t)lv_names[fat_level], 0, 0, 0);
    uart_puts("\r\n");
}

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
        if (ch < 8 && id < 5) {
            feat_vals[id][ch] = payload;
            if (id == 0)
                feat_mav[ch] = payload;   /* keep MAV for STAT line */
            if (++feat_win_cnt == 40u) {  /* one full window: 8 ch x 5 feats */
                feat_win_cnt = 0;
                cal_on_window();          /* rest-calibration window sink */
                if ((feat_rows++ & 1u) == 0u)   /* every 2nd window */
                    print_feature_row();
            }
        }
        feat_cnt++;
        break;
    case 3:                            /* PL INT8 MLP result */
        if (id < 5u)
            res_logits[id] = payload;
        else if (id == 5u) {
            res_cls = payload;
            if (cal_stage == 2u)       /* R rows muted until calibrated */
                print_result_row(seq);
        }
        res_cnt++;
        break;
    case 4:                            /* fatigue monitor result (id 8/9) */
        if (id == 8u) {
            fat_num2 = payload >> 16;          /* window counter */
            fat_mdf  = payload & 0xFFFFu;      /* mean MDF bin index */
        } else if (id == 9u) {
            fat_level  = payload >> 30;        /* 0=norm 1=mild 2=fatigued */
            fat_full   = (payload >> 29) & 1u; /* MDF history filled */
            fat_energy = payload & 0x7FFFFFu;  /* grand_total >> 23 */
            print_fatigue_row(seq);
        }
        fat_cnt++;
        break;
    default:
        other_cnt++;
        return;                        /* don't count as packet */
    }

    if (parsed_total < 16u) {
        /* verbose decode of the first packets */
        uart_puts((type == 1) ? "RAW " : (type == 2) ? "FEAT"
                              : (type == 4) ? "FAT " : "RES ");
        uprintf(" ch=%u", ch, 0, 0, 0);
        if (type == 2)
            uprintf(" %s", (u32)(uintptr_t)(id < 5 ? feat_names[id] : "?"), 0, 0, 0);
        if (type == 3 || type == 4)
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
        uart_puts(" fat=");
        print_dec(fat_cnt);
        uart_puts(" gate=");
        print_dec(gated_rows);
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

/*void *memcpy(void *dst, const void *src, u32 n)
{
    unsigned char *d = dst;
    const unsigned char *s = src;
    while (n--)
        *d++ = *s++;
    return dst;
}
*/

/*void *memset(void *dst, int v, u32 n)
{
    unsigned char *d = dst;
    while (n--)
        *d++ = (unsigned char)v;
    return dst;
}
*/

/* ---- Record mode (dataset capture) -------------------------------------- *
 * 2 Mbaud raw binary stream.  Frame = AA 55 | seq u16 LE | 8 x int24 LE
 * (ch0..ch7).  One frame per complete 8-channel group; the PL raw packets
 * arrive channel-interleaved, so we accumulate rec_slot[ch] and emit when
 * all 8 are present.  No text output while recording (except the one-shot
 * banner emitted by mode_set) so the frame stream stays parseable. */

static u32 rec_slot[8];
static u32 rec_acc, rec_seq;

static void rec_put24(i32 v)
{
    u32 u = (u32)v & 0xFFFFFFu;
    uart_putc((char)(u & 0xFFu));
    uart_putc((char)((u >> 8) & 0xFFu));
    uart_putc((char)((u >> 16) & 0xFFu));
}

static void record_buffer(volatile u32 *buf)
{
    u32 w;
    for (w = 0; w < BUF_PACKETS; w++) {
        u32 hdr = buf[2 * w + 1];
        u32 pay = buf[2 * w];
        u32 ch;
        if ((hdr >> 28) != 1u)
            continue;
        ch = (hdr >> 24) & 7u;
        rec_slot[ch] = ((i32)(pay << 8)) >> 8;
        rec_acc |= 1u << ch;
        if (rec_acc == 0xFFu) {
            uart_putc((char)0xAA);
            uart_putc((char)0x55);
            uart_putc((char)(rec_seq & 0xFFu));
            uart_putc((char)((rec_seq >> 8) & 0xFFu));
            for (ch = 0; ch < 8; ch++)
                rec_put24((i32)rec_slot[ch]);
            rec_acc = 0;
            rec_seq++;
        }
    }
}

/* ---- Mode switching + main ---------------------------------------------- */

/* Switch monitor <-> record at runtime: reconfigure the UART baud, reset
 * DMA and restart the mode-specific state.  Returning to monitor reruns
 * the rest calibration (electrode state may have changed meanwhile). */
static void mode_set(u32 mode)
{
    g_mode = mode;
    rec_acc = 0;
    if (mode == MODE_RECORD) {
        uart_reconfig(REC_BAUDGEN, REC_BAUDDIV);
        uart_puts("RAWREC1 8ch24b\n");  /* PC syncs on AA 55 frames after */
    } else {
        uart_reconfig(MON_BAUDGEN, MON_BAUDDIV);
        uart_puts("\n[MODE] monitor 115200-8N1, recalibrating ('r' = record)\n");
    }
    dma_init();
    dma_active = 0;
    dma_arm((u32)(uintptr_t)dma_buf[0], BUF_BYTES);
    if (mode == MODE_MONITOR)
        cal_start();
}

/* Non-blocking RX poll; single-char commands: 'c' = recalibrate rest
 * (monitor mode only), 'r' = toggle monitor/record mode (any mode). */
static void uart_poll_rx(void)
{
    while (!(UART_SR & UART_SR_RXEMPTY)) {
        u32 c = UART_FIFO & 0xFFu;
        if (c == 'r') {
            mode_set((g_mode == MODE_RECORD) ? MODE_MONITOR : MODE_RECORD);
        } else if (c == 'c' && g_mode == MODE_MONITOR) {
            uart_puts("[CAL] 'c' received, restart\n");
            cal_start();
        }
    }
}

int main(void)
{
    u32 err;

    uart_reconfig(MON_BAUDGEN, MON_BAUDDIV);
    uart_puts("\n=== sEMG hand-motion PL stream monitor ===\n");
    uart_puts("UART0(MIO14/15) 115200-8N1, AXI DMA @ 0x40400000 (S2MM polling)\n");
    uart_puts("commands: 'c' = recalibrate rest, 'r' = toggle record mode\n");
    uart_puts("  (record mode: 2 Mbaud RAWREC frames, run tools/record_uart.py)\n");
    uart_puts("packet: type/ch/id/seq/payload; 1=raw 2=feature 3=result 4=fatigue\n");
    uart_puts("F-rows: one CSV line per 100ms window = 40 model inputs\n");
    uart_puts("  (MAV*8, WL*8, Energy*8, ZC*8, SSC*8; feed to tools/realtime_inference.py)\n");
    uart_puts("R-rows: one per window from the PL INT8 MLP:\n");
    uart_puts("  'R s=<seq> c=<class> p=<conf>[ g=1]' (+ logits every 4th window)\n");
    uart_puts("  (p = indicative confidence; g=1 = MAV gate re-classified to rest)\n");
    uart_puts("T-rows: one per 512ms fatigue window: 'T s=.. lv=.. mdf=.. n2=..'\n");
    uart_puts("  (lv: 0=NORM 1=MILD 2=FATIG from the 16-point MDF-slope regression)\n");
    uart_puts("rest calibration: ~2.4 s after boot, [CAL] lines report baselines/thr\n");
    uart_puts("expected: ~32000 raw/s, ~1600 feature/s (40 windows/s)\n");
    uart_puts("  -> 20 F-rows/s (every 2nd window) + 40 R-rows/s\n\n");

    cal_start();
    dma_init();
    dma_arm((u32)(uintptr_t)dma_buf[0], BUF_BYTES);

    for (;;) {
        uart_poll_rx();
        err = dma_wait();
        if (err) {
            if (g_mode == MODE_MONITOR)    /* keep record TX clean */
                uprintf("[DMA] error status 0x%x, resetting\n", err, 0, 0, 0);
            dma_init();
        }
        /* re-arm first so the PL stream keeps draining into the other
         * buffer while this one is parsed or recorded */
        dma_active ^= 1;
        dma_arm((u32)(uintptr_t)dma_buf[dma_active], BUF_BYTES);
        if (g_mode == MODE_RECORD)
            record_buffer(dma_buf[dma_active ^ 1]);
        else
            parse_buffer(dma_buf[dma_active ^ 1]);
    }
    return 0;                          /* not reached */
}
