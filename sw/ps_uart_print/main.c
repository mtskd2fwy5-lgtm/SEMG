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
 * decode of the first packets, then a status line per ~0.5 s.  Monitor
 * text flows through a RAM TX ring drained from the dma_wait idle spin,
 * so printing never stalls the parse loop (no DMA-window overruns, no
 * seq gaps) and R/P/T data rows stream with debug off.
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
typedef unsigned char u8;

#include "pose_contract.h"

#define BUILD_TAG "20261010_SLICED"
/* 2026-10-10 fix v2: span-fill cut one redraw to ~295 ms, but uncached DDR
 * stores (~0.29 us/pixel) put every runtime redraw past the 128 ms raw-FIFO
 * window, so the parse path still wedged at each pose flip.  Redraws are now
 * DEFERRED: a pose flip only builds a draw list; the list is executed in
 * time-budgeted slices from the dma_wait idle spin (same philosophy as the
 * TX ring: idle-time work, parse never waits).  VDMA parks to the freshly
 * painted buffer only when the list completes. */
#define LCD_ENABLE 1

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
static u32 g_uart_debug;
static u32 g_tx_data;   /* 1 while emitting renderer data rows (R/P/T/F):
                         * bypasses the debug gate so hosts get data without
                         * enabling diagnostic text. */

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

/* ---- TX text ring ------------------------------------------------------- *
 * Monitor-mode text (data rows + diagnostics) is enqueued into a RAM ring
 * and drained to the UART FIFO at every opportunity (the dma_wait idle
 * spin).  Printing therefore never blocks parse_buffer: the ~30 ms DMA
 * buffer window stays safe even when a [STAT] block (~26 ms of line time)
 * or a PoseFrame row is emitted mid-parse - the root cause of the old
 * seq-gap packet loss.  Steady-state demand (~25% of the 115200-baud
 * line) drains fully every buffer; sustained overload ('f' feature rows
 * on) drops newest bytes and counts them in tx_drop_cnt, reported as
 * txdrop= in [STAT].  Record mode bypasses the ring: its binary frames
 * keep the proven direct-FIFO path. */
#define TX_RING_SZ 4096u                /* power of two */
#define TX_RING_MASK (TX_RING_SZ - 1u)
static char tx_ring[TX_RING_SZ];
static u32 tx_head, tx_tail;            /* producer / consumer index */
static u32 tx_drop_cnt;                 /* chars dropped on ring overflow */

/* Non-blocking drain: move ring bytes into the TX FIFO while it has room.
 * Called from the dma_wait spin, so the line stays busy during the ~28 ms
 * per buffer the CPU would otherwise waste polling for IOC. */
static void pump_tx(void)
{
    while (tx_tail != tx_head && !(UART_SR & UART_SR_TXFULL)) {
        UART_FIFO = (u32)(unsigned char)tx_ring[tx_tail];
        tx_tail = (tx_tail + 1u) & TX_RING_MASK;
    }
}

static void tx_enqueue(char c)
{
    u32 next = (tx_head + 1u) & TX_RING_MASK;
    if (next == tx_tail) {              /* ring full: drop, keep counting */
        tx_drop_cnt++;
        return;
    }
    tx_ring[tx_head] = c;
    tx_head = next;
}

static void tx_ring_reset(void)
{
    tx_tail = tx_head;                  /* drop pending text (mode switch) */
}

/* Diag text passes the debug gate; renderer data rows set g_tx_data to
 * bypass it (R/P/T must stream with debug off).  Monitor bytes are queued
 * into the TX ring so parse never blocks on the line; record mode writes
 * binary frames straight to the FIFO as before. */
static void uart_putc(char c)
{
    if (g_mode == MODE_MONITOR) {
        if (!g_tx_data && !g_uart_debug)
            return;
        tx_enqueue(c);
    } else {
        while (UART_SR & UART_SR_TXFULL)
            ;
        UART_FIFO = (u32)(unsigned char)c;
    }
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

/* Signed variant for 24-bit raw samples (never INT32_MIN, safe to negate). */
static void print_dec_s(i32 v)
{
    if (v < 0) {
        uart_putc('-');
        v = -v;
    }
    print_dec((u32)v);
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

/* The main loop normally polls RX between completed DMA batches.  Keep a
 * forward declaration so a stalled/no-input DMA wait can still accept the
 * bring-up commands ('d', 'f', 'r') and report the missing PL stream. */
static void uart_poll_rx(void);
static u32 gt_stamp(void);         /* defined below; used by dma_wait */
static void lcd_slice_tick(u32 win_t0);   /* deferred redraw, see LCD block */

/* Returns 0 on IOC, else the sticky error bits. */
static u32 dma_wait(void)
{
    u32 spins = 0;
    u32 t_idle = gt_stamp();       /* window start: slice budget anchor */
    for (;;) {
        u32 sr;
        pump_tx();                       /* drain TX ring during idle poll */
        lcd_slice_tick(t_idle);          /* paint redraw slices in idle time */
        sr = S2MM_DMASR;
        if (sr & DMASR_ERROR_MASK) {
            S2MM_DMASR = sr & DMASR_ERROR_MASK;   /* ack errors */
            return sr & DMASR_ERROR_MASK;
        }
        if (sr & DMASR_IOC) {
            S2MM_DMASR = DMASR_IOC;               /* ack completion */
            return 0;
        }
        if (++spins >= 1000000u) {               /* keep RX responsive without PL data */
            uart_poll_rx();
            if (g_mode == MODE_MONITOR)
                uart_puts("[DMA] no PL data yet - check ADS1299/DRDY\n");
            spins = 0;
        }
    }
}

/* ---- Stall detector (ARM global timer @ CPU/2 = 333.33 MHz) ------------- *
 * Measures the wall time of each DMA window (nominal 30.26 ms).  A window
 * that takes much longer means the PS stalled (pump starved -> serial
 * "卡顿") or the PL stream itself stopped (packets lost -> gaps jump).
 * Both symptoms of one event; this quantifies them on the board. */
/* Zynq-7000 global timer map (UG585 / bsp xtime_l.c): +0x00 counter lower,
 * +0x04 counter upper, +0x08 control (enable = write 1).  The previous
 * revision had control/counter-lower swapped: the "enable" write landed on
 * the counter and gt_stamp() read the control register, so gt_stamp()
 * returned a constant - stall_cnt, tlast and rv2 tago were pinned at 0
 * while real multi-second stalls went unreported. */
#define GT_BASE        0xF8F00200u
#define GT_CNT_LO      (*(volatile u32 *)(GT_BASE))
#define GT_CNT_HI      (*(volatile u32 *)(GT_BASE + 0x04))
#define GT_CNTRL       (*(volatile u32 *)(GT_BASE + 0x08))
#define GT_TICKS_PER_MS 333333u
#define STALL_TH       (45u * GT_TICKS_PER_MS)  /* 1.5x nominal window */

static u32 stall_cnt;

/* Gap forensics.  2026-10-09 board evidence: per-STAT-window exactly 8 gap
 * packets (1 group, all 8 channels) with maxjump=65409=-127 (u16) - seq
 * went BACKWARD, so this is not packet loss but a seq-field artifact.
 * Reverse events (jump>=0x8000) snapshot the raw prev/cur seq for hex
 * inspection; forward events stay the classic loss counters. */
static u32 gap_now;             /* forward-loss gap packets since [STAT] */
static u32 gap_max_jump;        /* worst forward per-channel seq jump */
static u32 gap_last_t;          /* gt_stamp() at most recent gap packet */
static u32 gap_rv_cnt;          /* reverse (backward seq) packet count */
static u32 gap_rv_prev;         /* seq before the jump (u16 as u32) */
static u32 gap_rv_cur;          /* seq after the jump */
static u32 gap_rv_ch;           /* channel of the reverse event */
static u32 gap_rv_t;            /* gt_stamp() at the reverse event */

/* Result-lane forensics: NN result packets (type 3 id 5) are one per 10 ms
 * window, so consecutive seq values step by 40 frames.  A freeze in the PL
 * feature/NN chain while the ADC keeps running shows up here as a forward
 * jump of 40*k - R rows visibly jump, but nothing counted it before. */
static u16 res_last_seq;
static u8  res_seq_seen;
static u32 res_gap_cnt;         /* anomalous forward steps since boot */
static u32 res_max_jump;        /* worst forward jump in frames */

static void gt_init(void)
{
    GT_CNTRL = 0u;                              /* disable while setting up */
    GT_CNTRL = 1u;                              /* enable, prescaler off */
}

static u32 gt_stamp(void)
{
    u32 hi, lo;
    do {
        hi = GT_CNT_HI;
        lo = GT_CNT_LO;
    } while (hi != GT_CNT_HI);                  /* latch-consistent low word */
    return lo;                                  /* wraps every 12.9 s: u32 diff is still valid */
}

/* ---- RGB LCD display path (vh-3) ---------------------------------------- *
 * DDR -> axi_vdma_0 (MM2S only, RGB888, 3 frame stores) -> v_axi4s_vid_out_0
 * -> LCD pins.  v_tc_0 free-runs 1024x600 @ 50 MHz from the GEN_* timing
 * parameters baked into the IP, so no VTC setup is needed at runtime.
 *
 * Register map (address report of build/scripts/add_lcd_vdma.tcl):
 *   axi_vdma_0 0x43000000, v_tc_0 0x43C00000 (untouched),
 *   backlight GPIO 0x41200000 (axi_gpio_0 all-outputs: bit 0 = lcd_bl).
 *
 * Framebuffers: 3 x 1024*600*3 B = 5.3 MB at 0x18000000 - inside the
 * S_AXI_HP0 DDR window (0x0..0x1FFFFFFF), above the app (0x10000000)
 * and the EMG ping-pong buffers (0x11000000), well inside the 1 GB DDR.
 * DDR bytes per pixel are B,G,R (VDMA 24-bit little-endian stream,
 * tdata[23:16]=R - see board/constraints/hz_zynq_lcd.xdc), so byte 0 of
 * each pixel is B.  3072 B/line keeps the 64-bit AXI reads aligned.
 *
 * MM2S direct register mode: reset -> HSIZE/STRIDE/start addresses ->
 * VSIZE (arms the channel) -> RS=1; the channel then circulates the 3
 * frame stores continuously.  No caches are enabled, so the CPU stores
 * above are already visible to the VDMA - no flush needed. */

/* 2026-10-10 A/B stall ladder: LCD_ENABLE selects the LCD-path slice under
 * test - 0 = fully out, 1 = full virtual hand, 2 = VDMA-only (no redraws).
 * Full-LCD reference source: main_with_lcd_20261010.c.bak nearby. */
#define VDMA_BASE       0x43000000u
#define VDMA_DMACR      (*(volatile u32 *)(VDMA_BASE + 0x00))
#define VDMA_DMASR      (*(volatile u32 *)(VDMA_BASE + 0x04))
#define VDMA_FRMSTORE   (*(volatile u32 *)(VDMA_BASE + 0x18))
#define VDMA_PARKPTR    (*(volatile u32 *)(VDMA_BASE + 0x28))
#define VDMA_VSIZE      (*(volatile u32 *)(VDMA_BASE + 0x50))
#define VDMA_HSIZE      (*(volatile u32 *)(VDMA_BASE + 0x54))
#define VDMA_STRIDE     (*(volatile u32 *)(VDMA_BASE + 0x58))
#define VDMA_START(n)   (*(volatile u32 *)(VDMA_BASE + 0x5C + 4u * (n)))

#define GPIO_BL         (*(volatile u32 *)0x41200000u)

#define LCD_W           1024
#define LCD_H           600
#define FB_BPL          (LCD_W * 3)             /* 3072 bytes per line */
#define FB_WPL          (FB_BPL / 4)            /* 768 words per line */
#define FB_BYTES        (FB_BPL * LCD_H)        /* 0x1C2000 */
#define FB_BASE         0x18000000u

#define VDMA_DMACR_RESET  0x00000004u
#define VDMA_DMACR_RS     0x00000001u
#define VDMA_DMACR_PARK   0x00000002u
#define VDMA_DMASR_HALTED 0x00000001u

typedef struct {
    i32 x;
    i32 y;
} lcd_point;

static const char *const lcd_pose_names[5] = {
    "REST", "OPEN", "FIST", "FLEX", "EXT"
};
static const char *const lcd_fat_names[4] = {
    "NORM", "MILD", "FATIG", "LEVEL3"
};

/* 5x7 bitmap font. Each byte is one column, bit 0 is the top pixel. */
static const u8 lcd_font[37][5] = {
    {0x3E,0x51,0x49,0x45,0x3E}, {0x00,0x42,0x7F,0x40,0x00},
    {0x62,0x51,0x49,0x49,0x46}, {0x22,0x41,0x49,0x49,0x36},
    {0x18,0x14,0x12,0x7F,0x10}, {0x2F,0x49,0x49,0x49,0x31},
    {0x3E,0x49,0x49,0x49,0x32}, {0x01,0x71,0x09,0x05,0x03},
    {0x36,0x49,0x49,0x49,0x36}, {0x26,0x49,0x49,0x49,0x3E},
    {0x7E,0x11,0x11,0x11,0x7E}, {0x7F,0x49,0x49,0x49,0x36},
    {0x3E,0x41,0x41,0x41,0x22}, {0x7F,0x41,0x41,0x22,0x1C},
    {0x7F,0x49,0x49,0x49,0x41}, {0x7F,0x09,0x09,0x09,0x01},
    {0x3E,0x41,0x49,0x49,0x7A}, {0x7F,0x08,0x08,0x08,0x7F},
    {0x00,0x41,0x7F,0x41,0x00}, {0x20,0x40,0x41,0x3F,0x01},
    {0x7F,0x08,0x14,0x22,0x41}, {0x7F,0x40,0x40,0x40,0x40},
    {0x7F,0x02,0x0C,0x02,0x7F}, {0x7F,0x04,0x08,0x10,0x7F},
    {0x3E,0x41,0x41,0x41,0x3E}, {0x7F,0x09,0x09,0x09,0x06},
    {0x3E,0x41,0x51,0x21,0x5E}, {0x7F,0x09,0x19,0x29,0x46},
    {0x46,0x49,0x49,0x49,0x31}, {0x01,0x01,0x7F,0x01,0x01},
    {0x3F,0x40,0x40,0x40,0x3F}, {0x1F,0x20,0x40,0x20,0x1F},
    {0x7F,0x20,0x18,0x20,0x7F}, {0x63,0x14,0x08,0x14,0x63},
    {0x07,0x08,0x70,0x08,0x07}, {0x61,0x51,0x49,0x45,0x43},
    {0x08,0x08,0x08,0x08,0x08},
};

static i32 lcd_sin_q12(i32 degrees)
{
    static const i32 q15[7] = { 0, 1059, 2048, 2896, 3547, 3951, 4096 };
    i32 d = degrees % 360;
    i32 sign = 1;
    i32 a, index, rem, value;

    if (d < 0)
        d += 360;
    if (d <= 90)
        a = d;
    else if (d <= 180)
        a = 180 - d;
    else if (d <= 270) {
        a = d - 180;
        sign = -1;
    } else {
        a = 360 - d;
        sign = -1;
    }
    index = a / 15;
    rem = a % 15;
    if (index >= 6)
        value = 4096;
    else
        value = q15[index] +
                (q15[index + 1] - q15[index]) * rem / 15;
    return sign < 0 ? -value : value;
}

static i32 lcd_cos_q12(i32 degrees)
{
    return lcd_sin_q12(degrees + 90);
}

/* Span-fill primitives (2026-10-10 stall fix).  The old renderer wrote every
 * pixel through lcd_pixel: three unchecked byte stores per pixel, ~1.4M
 * pixels per redraw, all uncached into DDR inside the parse path -> ~1.34 s
 * wedge per pose transition (measured lcd last=4016ms for the three boot
 * frames), which backed up the S2MM mux and overflowed the raw FIFO.  These
 * primitives write whole horizontal spans as u32 BGR-pattern words instead:
 * same pixels, ~4x fewer stores, contiguous rows. */

static void lcd_fill_row(volatile u8 *fb, i32 y, i32 x0, i32 x1,
                         u8 r, u8 g, u8 b)
{
    volatile u8 *row, *p, *end;
    u32 k, w;
    if (y < 0 || y >= LCD_H || x0 > x1)
        return;
    if (x0 < 0)
        x0 = 0;
    if (x1 >= LCD_W)
        x1 = LCD_W - 1;
    if (x0 > x1)
        return;
    row = fb + (u32)y * FB_BPL;
    p = row + (u32)x0 * 3u;
    end = row + ((u32)x1 + 1u) * 3u;
    /* Byte offset of p inside the row mod 3 = color phase (p[0]=b,p[1]=g,
     * p[2]=r).  Fill unaligned head bytes, then u32 pattern words, then
     * tail bytes. */
    while (p < end && ((uintptr_t)p & 3u) != 0u) {
        k = (u32)(p - row) % 3u;
        *p++ = (k == 0u) ? b : (k == 1u) ? g : r;
    }
    k = (u32)(p - row) % 3u;    /* p <= end here; valid either way */
    while (p + 4 <= end) {
        if (k == 0u)      w = (u32)b | (u32)g << 8 | (u32)r << 16 | (u32)b << 24;
        else if (k == 1u) w = (u32)g | (u32)r << 8 | (u32)b << 16 | (u32)g << 24;
        else              w = (u32)r | (u32)b << 8 | (u32)g << 16 | (u32)r << 24;
        *(volatile u32 *)p = w;
        p += 4;
        k = (k + 1u) % 3u;      /* +4 bytes advances the phase by one color */
    }
    while (p < end) {
        k = (u32)(p - row) % 3u;
        *p++ = (k == 0u) ? b : (k == 1u) ? g : r;
    }
}

static void lcd_fill_col(volatile u8 *fb, i32 x, i32 y0, i32 y1,
                         u8 r, u8 g, u8 b)
{
    volatile u8 *p;
    i32 y;
    if (x < 0 || x >= LCD_W)
        return;
    if (y0 < 0)
        y0 = 0;
    if (y1 >= LCD_H)
        y1 = LCD_H - 1;
    if (y0 > y1)
        return;
    p = fb + (u32)y0 * FB_BPL + (u32)x * 3u;
    for (y = y0; y <= y1; y++) {
        p[0] = b;
        p[1] = g;
        p[2] = r;
        p += FB_BPL;
    }
}

static void lcd_fill_rect(volatile u8 *fb, i32 x, i32 y, i32 w, i32 h,
                          u8 r, u8 g, u8 b)
{
    i32 yy;
    if (x < 0) {
        w += x;
        x = 0;
    }
    if (y < 0) {
        h += y;
        y = 0;
    }
    if (x + w > LCD_W)
        w = LCD_W - x;
    if (y + h > LCD_H)
        h = LCD_H - y;
    if (w <= 0 || h <= 0)
        return;
    for (yy = y; yy < y + h; yy++)
        lcd_fill_row(fb, yy, x, x + w - 1, r, g, b);
}

static void lcd_disc(volatile u8 *fb, lcd_point c, i32 radius,
                     u8 r, u8 g, u8 b)
{
    i32 y, dx;
    i32 rr = radius * radius;
    for (y = -radius; y <= radius; y++) {
        dx = radius;                    /* largest dx with dx*dx <= rr-y*y */
        while (dx > 0 && dx * dx > rr - y * y)
            dx--;
        lcd_fill_row(fb, c.y + y, c.x - dx, c.x + dx, r, g, b);
    }
}

static i32 lcd_abs(i32 value)
{
    return value < 0 ? -value : value;
}

/* Capsule (thick round-ended segment) drawn as one span per scanline along
 * the dominant axis, replacing the old Bresenham walk that stamped a full
 * disc at every point (160-point wrist at r=43 alone was ~1.2M byte stores).
 * half = radius * (n + m/2) / n compensates the span width for limb slope;
 * the two end discs round the caps exactly like the old per-point stamping. */
static void lcd_limb(volatile u8 *fb, lcd_point a, lcd_point b, i32 radius,
                     u8 r, u8 g, u8 blue)
{
    i32 n, m, half, i, c;
    if (radius <= 0)
        return;
    if (a.x == b.x && a.y == b.y) {
        lcd_disc(fb, a, radius, r, g, blue);
        return;
    }
    if (lcd_abs(b.y - a.y) >= lcd_abs(b.x - a.x)) {   /* y-dominant: row spans */
        if (a.y > b.y) {
            lcd_point t = a;
            a = b;
            b = t;
        }
        n = b.y - a.y;
        m = b.x - a.x;
        half = radius * (n + lcd_abs(m) / 2) / n;
        for (i = a.y; i <= b.y; i++) {
            c = a.x + (m * (i - a.y) + n / 2) / n;
            lcd_fill_row(fb, i, c - half, c + half, r, g, blue);
        }
        lcd_disc(fb, a, radius, r, g, blue);
        lcd_disc(fb, b, radius, r, g, blue);
    } else {                                         /* x-dominant: col spans */
        if (a.x > b.x) {
            lcd_point t = a;
            a = b;
            b = t;
        }
        n = b.x - a.x;
        m = b.y - a.y;
        half = radius * (n + lcd_abs(m) / 2) / n;
        for (i = a.x; i <= b.x; i++) {
            c = a.y + (m * (i - a.x) + n / 2) / n;
            lcd_fill_col(fb, i, c - half, c + half, r, g, blue);
        }
        lcd_disc(fb, a, radius, r, g, blue);
        lcd_disc(fb, b, radius, r, g, blue);
    }
}

static const u8 *lcd_glyph(char ch)
{
    static const char alphabet[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-";
    int i;
    for (i = 0; alphabet[i]; i++)
        if (alphabet[i] == ch)
            return lcd_font[i];
    return (const u8 *)0;
}

static void lcd_text(volatile u8 *fb, i32 x, i32 y, i32 scale,
                     u8 r, u8 g, u8 b, const char *text)
{
    const u8 *glyph;
    int col, row;
    while (*text) {
        glyph = lcd_glyph(*text++);
        if (glyph) {
            for (col = 0; col < 5; col++)
                for (row = 0; row < 7; row++)
                    if (glyph[col] & (1u << row))
                        lcd_fill_rect(fb, x + col * scale, y + row * scale,
                                      scale, scale, r, g, b);
        }
        x += 6 * scale;
    }
}

/* ---- Deferred redraw (2026-10-10 stall fix v2) -------------------------- *
 * A pose flip no longer renders inline (that wedged the parse path: ~0.29 us
 * per uncached DDR pixel means even the span-fill redraw outruns the 128 ms
 * raw-FIFO window).  lcd_render_pose now runs in one of two modes:
 *   dl_mode 0 (boot): draws directly into dl_fb_now - three full framestores
 *     are painted before the PL stream starts, where blocking is harmless.
 *   dl_mode 1 (runtime flip): pushes draw-list entries only.  dma_wait's
 *     idle spin drains the list through lcd_slice_tick() with a ~12 ms
 *     budget per DMA window; the VDMA park pointer flips only when the list
 *     completes, so a partially painted buffer is never displayed.  Worst
 *     single entry is a ~24k-pixel fill band (~7 ms), keeping the per-window
 *     CPU overhead far inside the 128 ms FIFO margin. */
#define LCD_DL_MAX 128
#define LCD_SLICE_MS 12u

typedef struct {
    u32 op;                 /* 0 rect, 1 disc, 2 limb, 3 text */
    i32 v0, v1, v2, v3, v4; /* rect x,y,w,h | disc x,y,r | limb x0,y0,x1,y1,r
                             * | text x,y,scale */
    u32 rgb;
    const char *str;
} lcd_dl_t;

static lcd_dl_t dl[LCD_DL_MAX];
static u32 dl_len, dl_i, dl_busy, dl_trunc;
static u32 dl_back;                    /* framestore being painted */
static u32 dl_t_req;                   /* flip request time (lag probe) */
static volatile u8 *dl_fb;             /* list execution target */
static volatile u8 *dl_fb_now;         /* direct-draw target (boot path) */
static u32 dl_mode;

/* redraw probe + framestore ring index (shared with lcd_show_state below) */
static u32 lcd_front_index;
static u32 lcd_redraw_cnt;
static u32 lcd_redraw_last_ms;
static u32 lcd_redraw_max_ms;

#define DL_RGB(r, g, b) (((u32)(r) << 16) | ((u32)(g) << 8) | (u32)(b))

static void dl_push(u32 op, i32 v0, i32 v1, i32 v2, i32 v3, i32 v4,
                    u32 rgb, const char *str)
{
    lcd_dl_t *e;
    if (dl_len >= LCD_DL_MAX) {
        dl_trunc = 1u;                 /* list full: drop the rest */
        return;
    }
    e = &dl[dl_len++];
    e->op = op;
    e->v0 = v0; e->v1 = v1; e->v2 = v2; e->v3 = v3; e->v4 = v4;
    e->rgb = rgb;
    e->str = str;
}

static void p_rect(i32 x, i32 y, i32 w, i32 h, u8 r, u8 g, u8 b)
{
    if (!dl_mode) {
        lcd_fill_rect(dl_fb_now, x, y, w, h, r, g, b);
        return;
    }
    /* Split big fills into <=~24k-pixel bands so one entry stays <= ~7 ms. */
    while (h > 0) {
        i32 step = 24000 / (w > 0 ? w : 1);
        if (step < 8)
            step = 8;
        if (step > h)
            step = h;
        dl_push(0, x, y, w, step, 0, DL_RGB(r, g, b), (const char *)0);
        y += step;
        h -= step;
    }
}

static void p_disc(lcd_point c, i32 radius, u8 r, u8 g, u8 b)
{
    if (!dl_mode) {
        lcd_disc(dl_fb_now, c, radius, r, g, b);
        return;
    }
    dl_push(1, c.x, c.y, radius, 0, 0, DL_RGB(r, g, b), (const char *)0);
}

static void p_limb(lcd_point a, lcd_point b, i32 radius, u8 r, u8 g, u8 blue)
{
    if (!dl_mode) {
        lcd_limb(dl_fb_now, a, b, radius, r, g, blue);
        return;
    }
    dl_push(2, a.x, a.y, b.x, b.y, radius, DL_RGB(r, g, blue),
            (const char *)0);
}

static void p_text(i32 x, i32 y, i32 scale, u8 r, u8 g, u8 b,
                   const char *text)
{
    if (!dl_mode) {
        lcd_text(dl_fb_now, x, y, scale, r, g, b, text);
        return;
    }
    dl_push(3, x, y, scale, 0, 0, DL_RGB(r, g, b), text);
}

static void p_round_rect(i32 x, i32 y, i32 w, i32 h, i32 radius,
                         u8 r, u8 g, u8 b)
{
    p_rect(x + radius, y, w - 2 * radius, h, r, g, b);
    p_rect(x, y + radius, w, h - 2 * radius, r, g, b);
    p_disc((lcd_point){x + radius, y + radius}, radius, r, g, b);
    p_disc((lcd_point){x + w - radius - 1, y + radius}, radius, r, g, b);
    p_disc((lcd_point){x + radius, y + h - radius - 1}, radius, r, g, b);
    p_disc((lcd_point){x + w - radius - 1, y + h - radius - 1},
           radius, r, g, b);
}

static void lcd_slice_tick(u32 win_t0)
{
    u32 deadline;
    if (!dl_busy)
        return;
    deadline = win_t0 + LCD_SLICE_MS * GT_TICKS_PER_MS;
    while (dl_i < dl_len && gt_stamp() < deadline) {
        const lcd_dl_t *e = &dl[dl_i++];
        u8 cr = (u8)(e->rgb >> 16), cg = (u8)(e->rgb >> 8), cb = (u8)e->rgb;
        switch (e->op) {
        case 0:
            lcd_fill_rect(dl_fb, e->v0, e->v1, e->v2, e->v3, cr, cg, cb);
            break;
        case 1: {
            lcd_point c;
            c.x = e->v0;
            c.y = e->v1;
            lcd_disc(dl_fb, c, e->v2, cr, cg, cb);
            break;
        }
        case 2: {
            lcd_point a, b;
            a.x = e->v0;
            a.y = e->v1;
            b.x = e->v2;
            b.y = e->v3;
            lcd_limb(dl_fb, a, b, e->v4, cr, cg, cb);
            break;
        }
        default:
            lcd_text(dl_fb, e->v0, e->v1, e->v2, cr, cg, cb, e->str);
            break;
        }
    }
    if (dl_i < dl_len)
        return;                        /* budget spent, continue next window */
    dl_busy = 0;
    if (!dl_trunc) {                   /* incomplete list: keep old frame */
        VDMA_PARKPTR = dl_back & 0x1Fu;
        lcd_front_index = dl_back;
    }
    lcd_redraw_last_ms = (gt_stamp() - dl_t_req) / GT_TICKS_PER_MS;
    if (lcd_redraw_last_ms > lcd_redraw_max_ms)
        lcd_redraw_max_ms = lcd_redraw_last_ms;
}

static lcd_point lcd_rotate(lcd_point p, lcd_point center, i32 degrees)
{
    i32 dx = p.x - center.x;
    i32 dy = p.y - center.y;
    i32 sn = lcd_sin_q12(degrees);
    i32 cs = lcd_cos_q12(degrees);
    lcd_point out;
    out.x = center.x + (cs * dx - sn * dy) / 4096;
    out.y = center.y + (sn * dx + cs * dy) / 4096;
    return out;
}

static lcd_point lcd_advance(lcd_point p, i32 degrees, i32 length)
{
    p.x += lcd_sin_q12(degrees) * length / 4096;
    p.y -= lcd_cos_q12(degrees) * length / 4096;
    return p;
}

static void lcd_draw_hand(u32 cls, u32 fatigue)
{
    static const i32 base_x[4] = { 420, 480, 540, 600 };
    static const i32 base_y[4] = { 338, 322, 318, 330 };
    static const i32 len1[4] = { 86, 102, 98, 82 };
    static const i32 len2[4] = { 60, 70, 68, 54 };
    static const i32 len3[4] = { 42, 48, 46, 36 };
    static const u8 skin[3] = { 224, 164, 108 };
    static const u8 skin_hi[3] = { 247, 194, 135 };
    static const u8 arm[3] = { 67, 77, 96 };
    static const u8 band[4][3] = {
        { 84, 96, 116 }, { 230, 202, 70 }, { 230, 86, 86 }, { 190, 70, 190 }
    };
    lcd_point center = { 512, 420 };
    i32 wrist = pose_table[cls][0];
    i32 i;

    p_limb(lcd_rotate((lcd_point){512, 570}, center, wrist),
           lcd_rotate((lcd_point){512, 410}, center, wrist),
           43, arm[0], arm[1], arm[2]);
    p_limb(lcd_rotate((lcd_point){512, 505}, center, wrist),
           lcd_rotate((lcd_point){512, 465}, center, wrist),
           48, band[fatigue < 4u ? fatigue : 3u][0],
           band[fatigue < 4u ? fatigue : 3u][1],
           band[fatigue < 4u ? fatigue : 3u][2]);
    p_round_rect(386, 258, 252, 190, 52,
                 skin[0], skin[1], skin[2]);
    p_round_rect(410, 290, 204, 112, 30,
                 skin_hi[0], skin_hi[1], skin_hi[2]);

    for (i = 0; i < 4; i++) {
        i32 off = 2 + i * 4;
        i32 a1 = pose_table[cls][off] + pose_table[cls][off + 1];
        i32 a2 = a1 + pose_table[cls][off + 2];
        i32 a3 = a2 + pose_table[cls][off + 3];
        lcd_point p0 = { base_x[i], base_y[i] };
        lcd_point p1 = lcd_advance(p0, a1, len1[i]);
        lcd_point p2 = lcd_advance(p1, a2, len2[i]);
        lcd_point p3 = lcd_advance(p2, a3, len3[i]);
        p0 = lcd_rotate(p0, center, wrist);
        p1 = lcd_rotate(p1, center, wrist);
        p2 = lcd_rotate(p2, center, wrist);
        p3 = lcd_rotate(p3, center, wrist);
        p_limb(p0, p1, 20, skin[0], skin[1], skin[2]);
        p_limb(p1, p2, 16, skin_hi[0], skin_hi[1], skin_hi[2]);
        p_limb(p2, p3, 12, skin[0], skin[1], skin[2]);
        p_disc(p1, 17, skin_hi[0], skin_hi[1], skin_hi[2]);
        p_disc(p2, 13, skin[0], skin[1], skin[2]);
    }

    {
        i32 a1 = pose_table[cls][19];
        i32 a2 = a1 + pose_table[cls][20];
        i32 a3 = a2 + pose_table[cls][21];
        lcd_point p0 = { 402, 405 };
        lcd_point p1 = lcd_advance(p0, a1, 42);
        lcd_point p2 = lcd_advance(p1, a2, 52);
        lcd_point p3 = lcd_advance(p2, a3, 38);
        p0 = lcd_rotate(p0, center, wrist);
        p1 = lcd_rotate(p1, center, wrist);
        p2 = lcd_rotate(p2, center, wrist);
        p3 = lcd_rotate(p3, center, wrist);
        p_limb(p0, p1, 21, skin[0], skin[1], skin[2]);
        p_limb(p1, p2, 17, skin_hi[0], skin_hi[1], skin_hi[2]);
        p_limb(p2, p3, 13, skin[0], skin[1], skin[2]);
    }
}

static void lcd_render_pose(u32 cls, u32 conf, u32 fatigue, u32 gated,
                            u32 full)
{
    static const u8 bg[3] = { 18, 24, 34 };
    static const u8 white[3] = { 238, 243, 250 };
    static const u8 muted[3] = { 140, 153, 170 };
    static const u8 active[3] = { 89, 190, 220 };
    static const u8 fatigue_color[4][3] = {
        { 84, 96, 116 }, { 230, 202, 70 }, { 230, 86, 86 }, { 190, 70, 190 }
    };
    u32 i;
    u32 safe_cls = cls < POSE_MODEL_CLASSES ? cls : 0u;
    u32 safe_fat = fatigue < 4u ? fatigue : 3u;

    if (full)
        p_rect(0, 0, LCD_W, LCD_H, bg[0], bg[1], bg[2]);
    else {
        p_rect(0, 0, LCD_W, 92, bg[0], bg[1], bg[2]);
        p_rect(250, 100, 550, 430, bg[0], bg[1], bg[2]);
        p_rect(0, 530, LCD_W, 70, bg[0], bg[1], bg[2]);
    }
    p_rect(0, 0, LCD_W, 92, 28, 37, 51);
    p_text(28, 18, 4, white[0], white[1], white[2], "S-EMG HAND");
    p_text(28, 57, 3, active[0], active[1], active[2],
           lcd_pose_names[safe_cls]);
    p_text(730, 57, 3, fatigue_color[safe_fat][0],
           fatigue_color[safe_fat][1], fatigue_color[safe_fat][2],
           lcd_fat_names[safe_fat]);
    p_rect(730, 22, 220, 16, 55, 66, 82);
    p_rect(730, 22, (i32)((conf > 100u ? 100u : conf) * 2u),
           16, active[0], active[1], active[2]);
    if (gated)
        p_text(875, 18, 3, 255, 120, 90, "GATE");

    for (i = 0; i < POSE_MODEL_CLASSES; i++) {
        u8 r = i == safe_cls ? active[0] : muted[0] / 2;
        u8 g = i == safe_cls ? active[1] : muted[1] / 2;
        u8 b = i == safe_cls ? active[2] : muted[2] / 2;
        p_round_rect(24 + (i32)i * 190, 535, 160, 40, 8, r, g, b);
        p_text(42 + (i32)i * 190, 546, 2,
               i == safe_cls ? bg[0] : muted[0],
               i == safe_cls ? bg[1] : muted[1],
               i == safe_cls ? bg[2] : muted[2],
               lcd_pose_names[i]);
    }
    lcd_draw_hand(safe_cls, safe_fat);
}

static u32 lcd_state_cls;
static u32 lcd_state_conf;
static u32 lcd_state_fatigue;
static u32 lcd_state_gated;
static u32 lcd_state_valid;
static u32 lcd_stream_started;

/* Redraw probe (2026-10-10 stall case, v2 semantics): a pose flip only
 * BUILDS a draw list here; the list is painted in ~12 ms slices from the
 * dma_wait idle spin (see lcd_slice_tick), so the parse path never blocks on
 * rendering.  n = flips requested; last/max = request->completion lag of the
 * newest finished frame (NOT CPU blocking time - blocking is gone by
 * construction; [STALL] and serial continuity are the blocking evidence).
 * The probe variables themselves live in the deferred-redraw block above. */
static u32 lcd_frozen;                 /* mode 2: VDMA runs, redraws locked out */

static void lcd_show_state(u32 cls, u32 conf, u32 fatigue, u32 gated)
{
    if (LCD_ENABLE == 0u)
        return;                     /* A/B test build: no redraws at all */
    if (lcd_frozen)
        return;                     /* mode 2: VDMA-only, runtime redraws out */
    if (lcd_state_valid && cls == lcd_state_cls && conf == lcd_state_conf &&
        fatigue == lcd_state_fatigue && gated == lcd_state_gated)
        return;
    lcd_state_cls = cls;
    lcd_state_conf = conf;
    lcd_state_fatigue = fatigue;
    lcd_state_gated = gated;
    lcd_state_valid = 1u;
    lcd_redraw_cnt++;
    if (!lcd_stream_started) {
        u32 i;
        dl_mode = 0;                /* boot: paint all three framestores now,
                                     * before the PL stream exists (the ~0.9 s
                                     * boot wedge is pre-stream, no FIFO risk) */
        for (i = 0; i < 3; i++) {
            dl_fb_now = (volatile u8 *)(FB_BASE + i * FB_BYTES);
            lcd_render_pose(cls, conf, fatigue, gated, 1u);
        }
        return;
    }
    /* Runtime flip: build the deferred draw list for the back buffer.  A
     * flip arriving mid-paint rebuilds the same buffer; bg bands cover every
     * region the list can touch, so the restart is self-erasing. */
    if (!dl_busy)
        dl_back = (lcd_front_index + 1u) % 3u;
    dl_len = 0;
    dl_i = 0;
    dl_trunc = 0;
    dl_mode = 1;
    lcd_render_pose(cls, conf, fatigue, gated, 0u);
    dl_mode = 0;
    dl_fb = (volatile u8 *)(FB_BASE + dl_back * FB_BYTES);
    dl_t_req = gt_stamp();
    dl_busy = 1u;
}

/* Runtime VDMA gate ('l' command): the LCD MM2S continuously reads
 * ~150 MB/s from DDR on the same HP0 port the EMG S2MM uses.  Toggling it
 * off while watching [STAT] gaps is the A/B test for DDR-arbitration loss
 * on the PL raw path. */
static u32 lcd_stream_on;

static void lcd_enable(u32 on)
{
    if (LCD_ENABLE == 0u)
        return;                     /* build has no LCD: 'l' is inert */
    if (on)
        VDMA_DMACR = VDMA_DMACR_RS | VDMA_DMACR_PARK;
    else
        VDMA_DMACR = 0u;                        /* halt MM2S, free DDR */
    lcd_stream_on = on;
}

static void lcd_init(void)
{
    u32 spins = 0;

    if (LCD_ENABLE == 0u)
        return;                     /* A/B test build: VDMA + backlight stay off */
    lcd_show_state(0, 0, 0, 0);
    GPIO_BL = 1;                                /* backlight on */

    VDMA_DMACR = VDMA_DMACR_RESET;              /* soft-reset MM2S */
    while (!(VDMA_DMASR & VDMA_DMASR_HALTED))
        if (++spins > 1000000u)
            break;                              /* never halted: say so */
    VDMA_HSIZE    = FB_BPL;
    VDMA_STRIDE   = FB_BPL;                     /* packed frames */
    VDMA_START(0) = FB_BASE;
    VDMA_START(1) = FB_BASE + FB_BYTES;
    VDMA_START(2) = FB_BASE + 2u * FB_BYTES;
    VDMA_PARKPTR  = 0;
    VDMA_VSIZE    = LCD_H;                      /* arms the channel */
    VDMA_DMACR    = VDMA_DMACR_RS | VDMA_DMACR_PARK;
                                                /* run: safe parked frame */
    lcd_stream_started = 1u;
    lcd_stream_on = 1u;
    lcd_frozen = (LCD_ENABLE == 2u);   /* mode 2: boot frame stays, redraws out */

    for (spins = 0; spins < 1000u; spins++)     /* let RS propagate */
        ;
    uprintf("[LCD] virtual-hand fstores=%u dmasr=%x\n",
            VDMA_FRMSTORE & 0xFFu, VDMA_DMASR, 0, 0);
}

/* ---- Packet parsing ---------------------------------------------------- */

#define BUF_PACKETS 1024                /* 1024 x 8-byte packets; matches TLAST */
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
static u32 raw_absmax[8];            /* max |raw| per channel (forensics) */
static u32 raw_outlier[8];           /* raw samples with |v| > 20000 */
static u32 feat_mav[8];                /* latest MAV per channel */
static u32 feat_vals[5][8];            /* [feature id][channel] of current window */
static u32 feat_win_cnt;               /* packets accumulated for current window */
static u32 res_logits[5];              /* INT32 logits of the current window */
static u32 res_cls;                    /* argmax class of the current window */
static u32 res_rows;                   /* result rows printed */
static u32 pose_rows;                  /* versioned PoseFrame rows printed */
static u32 feat_rows;                  /* feature windows seen (print gate) */
static i32 fat_num2;                   /* id 8: signed MDF slope numerator */
static u32 fat_mdf;                    /* id 8: mean MDF bin */
static u32 fat_level, fat_full, fat_energy;   /* id 9 fields */
static u32 parsed_total;
static u32 next_report;
static u32 raw_gap_cnt, feature_gap_cnt;
static u16 raw_last_seq[8];
static u8 raw_seen[8];
static u16 feature_last_seq;
static u8 feature_seq_seen;
static u8 feature_synced;
static u32 pose_active_cls;
static u32 pose_active_conf;
static u32 pose_active_gated;
static u32 pose_pending_cls;
static u32 pose_pending_count;
static u32 feature_stream;              /* off by default for standalone mode */

/* Emit one CSV line per feature window in the training feature order
 * (tools/train_baseline.py make_windows): MAV ch0..7, WL ch0..7,
 * Energy ch0..7, ZC ch0..7, SSC ch0..7 -> exactly the 40 model inputs.
 * Printed for every 2nd window (~200-460 B x 20 rows/s, ~80% of a
 * 115200-baud line); windows are 100 ms with a 25 ms hop. */
static void print_feature_row(void)
{
    u32 id, ch;
    g_tx_data = 1u;
    uart_putc('F');
    for (id = 0; id < 5; id++) {
        for (ch = 0; ch < 8; ch++) {
            uart_putc(',');
            print_dec(feat_vals[id][ch]);
        }
    }
    uart_puts("\r\n");
    g_tx_data = 0u;
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

static void print_pose_value(const char *name, i32 value)
{
    uprintf(" %s=%d", (u32)(uintptr_t)name, (u32)value, 0, 0);
}

/* Versioned pose output. R remains the compatibility line for old hosts. */
static void print_pose_frame(u32 seq, u32 cls, u32 conf, u32 gated)
{
    u32 i;
    if (cls >= POSE_MODEL_CLASSES || gated || conf < POSE_MIN_CONF)
        cls = 0u;
    uart_putc('P');
    uprintf(" v=1 s=%u schema=%u gid=%u q=%u",
            seq, POSE_SCHEMA_V2, cls, conf);
    uprintf(" mask=0x%x phase=0", POSE_VALID_MASK, 0, 0, 0);
    for (i = 0; i < 22u; i++)
        print_pose_value(pose_field_names[i], pose_table[cls][i]);
    uart_puts("\r\n");
    pose_rows++;
}

static void pose_accept(u32 seq, u32 cls, u32 conf, u32 gated)
{
    pose_active_cls = cls;
    pose_active_conf = conf;
    pose_active_gated = gated;
    pose_pending_count = 0;
    print_pose_frame(seq, pose_active_cls, conf, gated);
    lcd_show_state(pose_active_cls, pose_active_conf, fat_level,
                   pose_active_gated);
}

static void pose_observe(u32 seq, u32 cls, u32 conf, u32 gated)
{
    if (cls >= POSE_MODEL_CLASSES || gated || conf < POSE_MIN_CONF)
        cls = 0u;

    if (cls == pose_active_cls) {
        if (pose_active_gated != gated) {
            pose_active_conf = conf;
            pose_active_gated = gated;
            lcd_show_state(pose_active_cls, pose_active_conf, fat_level,
                           pose_active_gated);
        }
        pose_pending_count = 0;
        return;
    }

    if (cls == 0u && (gated || conf < POSE_MIN_CONF)) {
        pose_accept(seq, cls, conf, gated);
        return;
    }

    if (cls == pose_pending_cls) {
        pose_pending_count++;
    } else {
        pose_pending_cls = cls;
        pose_pending_count = 1u;
    }
    if (pose_pending_count >= POSE_CONFIRM_WINDOWS)
        pose_accept(seq, cls, conf, gated);
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
    g_tx_data = 1u;                    /* R (+ nested P) rows: data, not diag */
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
    pose_observe(seq, res_cls, logit_conf(), gated);
    g_tx_data = 0u;                    /* keep set: nested P row above */
    res_rows++;
}

/* One line per fatigue window (id 8+9 pair, ~2/s): 'T s=<seq> lv=<0..3>
 * mdf=<mean MDF bin> n2=<signed slope numerator> full=<hist filled> e=<energy>'.
 * lv comes from the 16-point MDF-history slope regression:
 * 0=NORM 1=MILD 2=FATIG, 3=RTL-defined fourth state. */
static void print_fatigue_row(u32 seq)
{
    static const char *const lv_names[4] = {
        "NORM", "MILD", "FATIG", "LEVEL3"
    };
    g_tx_data = 1u;
    uart_putc('T');
    uprintf(" s=%u lv=%u", seq, fat_level, 0, 0);
    uprintf(" mdf=%u n2=%d", fat_mdf, (u32)fat_num2, 0, 0);
    uprintf(" full=%u e=%u", fat_full, fat_energy, 0, 0);
    if (fat_level < 4u)
        uprintf(" %s", (u32)(uintptr_t)lv_names[fat_level], 0, 0, 0);
    uart_puts("\r\n");
    g_tx_data = 0u;
    lcd_show_state(pose_active_cls, pose_active_conf, fat_level,
                   pose_active_gated);
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
            u32 av = (v < 0) ? (u32)(-v) : (u32)v;
            raw_latest[ch] = (u32)v;
            if (av > raw_absmax[ch])
                raw_absmax[ch] = av;
            if (av > 20000u)
                raw_outlier[ch]++;
            if (raw_seen[ch] &&
                (u16)(seq - (u32)raw_last_seq[ch]) != (u16)1) {
                u32 jump = (u32)(u16)(seq - (u32)raw_last_seq[ch]);
                raw_gap_cnt++;
                if (jump >= 0x8000u) {          /* seq went BACKWARD */
                    gap_rv_cnt++;
                    gap_rv_prev = (u32)raw_last_seq[ch];
                    gap_rv_cur = (u32)(u16)seq;
                    gap_rv_ch = ch;
                    gap_rv_t = gt_stamp();
                } else {
                    gap_now++;
                    if (jump > gap_max_jump)
                        gap_max_jump = jump;
                }
                gap_last_t = gt_stamp();
            }
            raw_last_seq[ch] = (u16)seq;
            raw_seen[ch] = 1;
        }
        raw_cnt++;
        break;
    case 2:                            /* window feature */
        if (ch < 8 && id < 5) {
            u8 is_window_start = (ch == 0u && id == 0u);
            u32 expected_index;

            if (feature_seq_seen &&
                (u16)(seq - (u32)feature_last_seq) != (u16)1) {
                feature_gap_cnt++;
                feature_synced = 0;
                feat_win_cnt = 0;
            }
            feature_last_seq = (u16)seq;
            feature_seq_seen = 1;

            if (is_window_start) {
                feature_synced = 1;
                feat_win_cnt = 0;
            } else if (!feature_synced) {
                feat_cnt++;
                break;
            }

            expected_index = feat_win_cnt;
            if (ch != expected_index / 5u || id != expected_index % 5u) {
                feature_gap_cnt++;
                feature_synced = 0;
                feat_win_cnt = 0;
                feat_cnt++;
                break;
            }

            feat_vals[id][ch] = payload;
            if (id == 0)
                feat_mav[ch] = payload;   /* keep MAV for STAT line */
            if (++feat_win_cnt == 40u) {  /* one full window: 8 ch x 5 feats */
                feat_win_cnt = 0;
                cal_on_window();          /* rest-calibration window sink */
                if (feature_stream && (feat_rows++ & 1u) == 0u)
                    print_feature_row();
                else
                    feat_rows++;
            }
        }
        feat_cnt++;
        break;
    case 3:                            /* PL INT8 MLP result */
        if (id < 5u)
            res_logits[id] = payload;
        else if (id == 5u) {
            if (res_seq_seen) {
                u32 rjump = (u32)(u16)(seq - (u32)res_last_seq);
                if (rjump != 40u && rjump < 0x8000u) {
                    res_gap_cnt++;
                    if (rjump > res_max_jump)
                        res_max_jump = rjump;
                }
            }
            res_last_seq = (u16)seq;
            res_seq_seen = 1;
            res_cls = payload;
            if (cal_stage == 2u)       /* R rows muted until calibrated */
                print_result_row(seq);
        }
        res_cnt++;
        break;
    case 4:                            /* fatigue monitor result (id 8/9) */
        if (id == 8u) {
            fat_num2 = (i32)(payload & 0xFFFF0000u) >> 16;
            fat_mdf  = payload & 0xFFFFu;      /* mean MDF bin index */
        } else if (id == 9u) {
            fat_level  = payload >> 30;        /* RTL-defined 0..3 */
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
            print_dec_s((i32)raw_latest[ch]);
        }
        uprintf("\n[STAT] gaps raw=%u feature=%u txdrop=%u stall=%u\n",
                raw_gap_cnt, feature_gap_cnt, tx_drop_cnt, stall_cnt);
        uprintf("[STAT] gapd fwd=%u maxjump=%u tlast=%ums\n",
                gap_now, gap_max_jump,
                (gt_stamp() - gap_last_t) / GT_TICKS_PER_MS, 0);
        uprintf("[STAT] resd fwd=%u maxjump=%u\n",
                res_gap_cnt, res_max_jump, 0, 0);
        uprintf("[STAT] lcd n=%u last=%ums max=%ums\n",
                lcd_redraw_cnt, lcd_redraw_last_ms, lcd_redraw_max_ms, 0);
        uprintf("[STAT] rv cnt=%u prev=0x%x cur=0x%x\n",
                gap_rv_cnt, gap_rv_prev, gap_rv_cur, 0);
        uprintf("[STAT] rv2 ch=%u tago=%ums\n",
                gap_rv_ch, (gt_stamp() - gap_rv_t) / GT_TICKS_PER_MS, 0, 0);
        gap_now = 0;
        uart_puts("[STAT] rmax:");
        for (ch = 0; ch < 8; ch++) {
            uart_putc(' ');
            print_dec(raw_absmax[ch]);
        }
        uart_puts("\n[STAT] rout:");
        for (ch = 0; ch < 8; ch++) {
            uart_putc(' ');
            print_dec(raw_outlier[ch]);
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
static u16 rec_slot_seq[8];
static u32 rec_acc;

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
        {
            u16 seq = (u16)(hdr & 0xFFFFu);

            /* A repeated channel with a new sequence means that an input
             * frame was lost or reordered. Drop the partial frame instead
             * of mixing samples from different acquisition instants. */
            if ((rec_acc & (1u << ch)) && rec_slot_seq[ch] != seq)
                rec_acc = 0;
            rec_slot_seq[ch] = seq;
        }
        rec_slot[ch] = ((i32)(pay << 8)) >> 8;
        rec_acc |= 1u << ch;
        if (rec_acc == 0xFFu) {
            u16 frame_seq = rec_slot_seq[0];
            u32 frame_ok = 1u;

            for (ch = 0; ch < 8; ch++) {
                if (rec_slot_seq[ch] != frame_seq)
                    frame_ok = 0u;
            }
            if (frame_ok) {
                uart_putc((char)0xAA);
                uart_putc((char)0x55);
                uart_putc((char)(frame_seq & 0xFFu));
                uart_putc((char)((frame_seq >> 8) & 0xFFu));
                for (ch = 0; ch < 8; ch++)
                    rec_put24((i32)rec_slot[ch]);
            }
            rec_acc = 0;
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
    tx_ring_reset();                   /* drop stale monitor text */
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

/* Non-blocking RX poll; 'c' recalibrates rest, 'd' toggles debug text,
 * 'f' toggles the optional feature CSV stream, and 'r' toggles
 * monitor/record mode. */
static void uart_poll_rx(void)
{
    while (!(UART_SR & UART_SR_RXEMPTY)) {
        u32 c = UART_FIFO & 0xFFu;
        if (c == 'r') {
            mode_set((g_mode == MODE_RECORD) ? MODE_MONITOR : MODE_RECORD);
        } else if (c == 'c' && g_mode == MODE_MONITOR) {
            uart_puts("[CAL] 'c' received, restart\n");
            cal_start();
        } else if ((c == 'd' || c == 'D') && g_mode == MODE_MONITOR) {
            /* Toggle verbose monitor output. Enable before printing the ON
             * acknowledgement; print OFF before muting subsequent rows. */
            if (g_uart_debug) {
                uart_puts("[UART] debug OFF\n");
                g_uart_debug = 0u;
            } else {
                g_uart_debug = 1u;
                uart_puts("[UART] debug ON ");
                uart_puts(BUILD_TAG);
                uprintf(" LCD_ENABLE=%u\n", LCD_ENABLE, 0, 0, 0);
            }
        } else if (c == 'f' && g_mode == MODE_MONITOR) {
            feature_stream = !feature_stream;
            uart_puts(feature_stream ? "[UART] F rows ON\n"
                                     : "[UART] F rows OFF\n");
        } else if (c == 'l' && g_mode == MODE_MONITOR) {
            lcd_enable(!lcd_stream_on);
            uart_puts(lcd_stream_on ? "[LCD] ON\n"
                                    : "[LCD] OFF (DDR freed for EMG test)\n");
        }
    }
}

int main(void)
{
    u32 err;

    /* Standalone boot is quiet by default.  Send 'd' on UART0 when bring-up
     * diagnostics are needed; banners, verbose decode, [STAT]/[CAL]/[DMA]
     * text passes uart_putc's debug gate, while R/P/T data rows stream
     * regardless (they enqueue into the TX ring, never blocking parse). */
    g_uart_debug = 0u;
    uart_reconfig(MON_BAUDGEN, MON_BAUDDIV);
    uart_puts("\n=== sEMG hand-motion PL stream monitor ===\n");
    uart_puts("UART0(MIO14/15) 115200-8N1, AXI DMA @ 0x40400000 (S2MM polling)\n");
    uart_puts("commands: 'c' = recalibrate, 'd' = diag text, 'f' = F rows,\n");
    uart_puts("          'l' = LCD on/off, 'r' = record\n");
    uart_puts("  (record mode: 2 Mbaud RAWREC frames, run tools/record_uart.py)\n");
    uart_puts("packet: type/ch/id/seq/payload; 1=raw 2=feature 3=result 4=fatigue\n");
    uart_puts("F-rows: one CSV line per 100ms window = 40 model inputs\n");
    uart_puts("  (MAV*8, WL*8, Energy*8, ZC*8, SSC*8; feed to tools/realtime_inference.py)\n");
    uart_puts("R-rows: one per window from the PL INT8 MLP:\n");
    uart_puts("  'R s=<seq> c=<class> p=<conf>[ g=1]' (+ logits every 4th window)\n");
    uart_puts("  (p = indicative confidence; g=1 = MAV gate re-classified to rest)\n");
    uart_puts("P-rows: versioned PoseFrame v=1 schema=2 (22 pose values)\n");
    uart_puts("  (P after 2 stable windows; LCD runs locally without a PC)\n");
    uart_puts("T-rows: one per 512ms fatigue window: 'T s=.. lv=.. mdf=.. n2=..'\n");
    uart_puts("  (lv: 0=NORM 1=MILD 2=FATIG 3=LEVEL3 from MDF slope)\n");
    uart_puts("rest calibration: ~2.4 s after boot, [CAL] lines report baselines/thr\n");
    uart_puts("expected: ~32000 raw/s, ~1600 feature/s (40 windows/s)\n");
    uart_puts("  -> R/P/T rows stream always (renderer feed, debug off ok);\n");
    uart_puts("     'd' adds [STAT]/verbose diag, 'f' adds F rows (~80% line)\n\n");

    gt_init();                /* before lcd_init: the boot triple-render is
                               * measured too (first lcd= row sanity check) */
    lcd_init();               /* local virtual hand + VDMA MM2S + backlight */
    g_uart_debug = 0u;                 /* steady state is LCD-local */
    cal_start();
    dma_init();
    dma_arm((u32)(uintptr_t)dma_buf[0], BUF_BYTES);

    {
        u32 t_prev = gt_stamp();
        for (;;) {
            u32 t0, dt;
            uart_poll_rx();
            t0 = gt_stamp();
            err = dma_wait();
            dt = t0 - t_prev;
            t_prev = t0;
            if (dt > STALL_TH) {
                stall_cnt++;
                if (g_mode == MODE_MONITOR)    /* keep record TX clean */
                    uprintf("\n[STALL] window took %u ms\n",
                            dt / GT_TICKS_PER_MS, 0, 0, 0);
            }
            if (err) {
                if (g_mode == MODE_MONITOR)    /* keep record TX clean */
                    uprintf("[DMA] error status 0x%x, resetting\n", err, 0, 0, 0);
                dma_init();
            }
            /* re-arm first so the PS stream keeps draining into the other
             * buffer while this one is parsed or recorded */
            dma_active ^= 1;
            dma_arm((u32)(uintptr_t)dma_buf[dma_active], BUF_BYTES);
            if (g_mode == MODE_RECORD)
                record_buffer(dma_buf[dma_active ^ 1]);
            else
                parse_buffer(dma_buf[dma_active ^ 1]);
        }
    }
    return 0;                          /* not reached */
}
