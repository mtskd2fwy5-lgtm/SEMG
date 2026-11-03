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
 *     before this ELF is downloaded); APP/framebuffer use L1 caching; EMG DMA remains noncacheable
 *     (display_memory.S), so CPU DMA reads remain coherent.
 *
 * Stream packet format (64-bit word, see src/rtl/emg_data_path.v):
 *   63:60 type   1=raw  2=feature  3=result  4=fatigue/spectrum (ids 8..15)
 *   59:56 channel
 *   55:52 feature/result id (raw: 0)
 *   51:48 reserved
 *   47:32 sequence
 *   31:0  payload (raw: 24-bit signed sample)
 * In DDR (little endian) the first u32 holds tdata[31:0] (payload) and
 * the second u32 holds tdata[63:32] (header).
 *
 * Data rates: raw and notch each 8 ch x 4 kSPS = 32000 pkt/s, features
 * 40 windows/s x 8 ch x 5 ids = 1600 pkt/s, NN = 240 pkt/s, fatigue/spectrum =
 * 16 pkt/s: total 65856 pkt/s (526848 B/s). A 1024-word DMA buffer spans
 * about 15.55 ms. This is far beyond
 * a 115200-baud line, so the steady-state printout is decimated: full
 * decode of the first packets, then a status line per ~0.5 s.  Monitor
 * text flows through a RAM TX ring drained from the dma_wait idle spin,
 * so printing never stalls the parse loop (no DMA-window overruns, no
 * seq gaps) and R/P/T data rows stream with debug off.
 *
 * Modes (runtime-switchable, no rebuild): send 'r' on the UART to toggle
 * between
 *   monitor mode (115200): text rows [CAL]/F/R/T/[STAT] as described below
 *   record  mode (2 Mbaud, CH340C-capable): one selected waveform source,
 *     notch50 by default ('n'), original ADC with 'u'. AA 58 = processed,
 *     AA 55 = raw; then seq u16 LE | 8 x int24 LE (ch0..ch7) = 28 B/frame,
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
#include "nn_confidence.h"
#define SD_CAPTURE_LABEL_UI 1
#include "sd_record.h"
#include "rehab_training.h"
#include "selfcal.h"
#include "synergy_nmf.h"
#include "synergy_feedback.h"
#include "channel_quality.h"
#include "hdc_learning.h"

#ifndef PL_CONTROL_ENABLE
#define PL_CONTROL_ENABLE 0
#endif
#if PL_CONTROL_ENABLE
#define BUILD_TAG "20261103_HAND_CONTROL_HDMI_MIRROR_V31"
#else
#define BUILD_TAG "20261024_HDC_DISPLAY_V1"
#endif
#define GT_TICKS_PER_MS 333333u

#ifdef LCD_HOST_TEST
extern volatile u32 *lcd_test_mmio(u32 address);
extern volatile u8 *lcd_test_fb(u32 index);
extern u32 lcd_test_clock(void);
#define MMIO32(a) (*lcd_test_mmio(a))
#else
#define MMIO32(a) (*(volatile u32 *)(a))
#endif

extern void display_memory_clean(uintptr_t address, u32 bytes);
#include "pl_control.h"
#include "hand_control.h"
static void lcd_memory_barrier(void)
{
#if defined(__arm__)
    __asm__ volatile("dsb sy" ::: "memory");
#endif
}
/* Latest input coalesces into a pending scene. Immutable draw lists execute
 * in idle-time slices with EMG completion checked between primitives.
 * Cached spans are cleaned to DDR before requesting VDMA frame-boundary
 * presentation; actual scanout and the previous park request stay protected. */
#define LCD_ENABLE 1

/* ---- UART0 (Cadence UARTPS) ------------------------------------------ */

#define UART_BASE       0xE0000000u
#define UART_CR         MMIO32(UART_BASE + 0x00)
#define UART_MR         MMIO32(UART_BASE + 0x04)
#define UART_BAUDGEN    MMIO32(UART_BASE + 0x18)
#define UART_SR         MMIO32(UART_BASE + 0x2C)
#define UART_FIFO       MMIO32(UART_BASE + 0x30)  /* TX/RX FIFO, 0x30 not 0x38 */
#define UART_BAUDDIV    MMIO32(UART_BASE + 0x34)

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
/* Recording source only. Recognition uses the PL notch path; the LCD
 * waveform page has its own source selector, independent of recording. */
static u32 rec_notch = 1u;
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
 * spin).  Printing therefore never blocks parse_buffer: the ~15.55 ms DMA
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
 * Called from the dma_wait spin, so the line stays busy during the DMA wait
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
#ifdef UART_CAPTURE_TEST
    extern void uart_test_putc(char);
    uart_test_putc(c);
    return;
#endif
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
#define S2MM_DMACR      MMIO32(AXIDMA_BASE + 0x30)
#define S2MM_DMASR      MMIO32(AXIDMA_BASE + 0x34)
#define S2MM_DA         MMIO32(AXIDMA_BASE + 0x48)
#define S2MM_LENGTH     MMIO32(AXIDMA_BASE + 0x58)

#define DMACR_RUN       0x00000001u
#define DMACR_RESET     0x00000004u
#define DMASR_HALTED    0x00000001u
#define DMASR_ERROR_MASK 0x000007F0u  /* IntErr/SlvErr/DecErr/SG errors */
#define DMASR_IOC       0x00001000u
#define BUF_PACKETS 1024
#define BUF_BYTES (BUF_PACKETS * 8)
#define DMA_SLOTS 128u
#define DMA_QUEUE_FULL 0x40000000u
extern unsigned char __dma_buf[];
static u32 dma_head, dma_tail, dma_running, dma_fault;
static u8 dma_labels[DMA_SLOTS];
static u32 lcd_action_label, sd_parse_label;
static u32 lcd_sd_label_page;
static volatile u32 *dma_buffer(u32 index)
{ return (volatile u32 *)(__dma_buf + (index & (DMA_SLOTS-1u))*BUF_BYTES); }

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

/* SD polling/FFT may queue DMA completions, but never recursively parse.
 * The tail stays owned by the parser until explicitly released. */
void acquisition_service(void)
{
    u32 sr;
    if (!dma_running || dma_fault) return;
    sr=S2MM_DMASR;
    if (sr & DMASR_ERROR_MASK) { dma_fault=sr & DMASR_ERROR_MASK; return; }
    if (!(sr & DMASR_IOC)) return;
    S2MM_DMASR=DMASR_IOC;
    dma_head++;
    if (dma_head-dma_tail >= DMA_SLOTS) {
        dma_fault=DMA_QUEUE_FULL; return;
    }
    dma_labels[dma_head & (DMA_SLOTS-1u)]=(u8)lcd_action_label;
    dma_arm((u32)(uintptr_t)dma_buffer(dma_head),BUF_BYTES);
}

static void dma_restart(void)
{
    dma_running=0u;
    dma_init();
    dma_head=dma_tail=dma_fault=0u;
    dma_labels[0]=(u8)lcd_action_label;
    dma_arm((u32)(uintptr_t)dma_buffer(0u),BUF_BYTES);
    dma_running=1u;
}

/* The main loop normally polls RX between completed DMA batches.  Keep a
 * forward declaration so a stalled/no-input DMA wait can still accept the
 * bring-up commands ('d', 'f', 'r') and report the missing PL stream. */
static void uart_poll_rx(void);
static u32 gt_stamp(void);         /* defined below; used by dma_wait */
static void lcd_analysis_changed(void);
static void lcd_slice_tick(u32 win_t0);   /* deferred redraw, see LCD block */
static void touch_tick(void);             /* GT911 poll, defined in LCD block */
static void ui_touch_press(u32 x, u32 y); /* on-screen menu hit-test */
static void lcd_hand_contact(u32 x,u32 y,u32 down);
static void lcd_virtual_contact(u32 x,u32 y,u32 down);
static void ui_feedback_tick(void);
static void mpu_tick(void);               /* MPU6050 tilt poll, see below */
static void adc_status_tick(void);
static void pl_control_tick(void);
static void ui_apply_action(void);
static u32 ui_action;                     /* applied outside DMA completion */
static u32 ui_sd_action;
static u32 ui_rehab_action;
static u32 ui_hdc_save,ui_hdc_model;
static void hdc_model_apply(u32 action);
static void hdc_service(void);
static void hdc_on_window(const u32 features[40],u16 seq);
static void hdc_save_report(void);
static void rehab_service(void);
static void sd_pair_reset(void);
static void cq_background_tick(u32 now);
#define DMA_WAIT_UI 0x80000000u
static void lcd_show_state(u32 cls, u32 conf, u32 fatigue, u32 gated,
                           i32 tilt, i32 shift);
                                  /* redraw if the state key moved */

/* Returns 0 on IOC, else the sticky error bits. */
static u32 dma_wait(void)
{
    u32 spins = 0;
    u32 t_service = gt_stamp();
    for (;;) {
        pump_tx();                       /* drain TX ring during idle poll */
        touch_tick();                    /* GT911 word poll + C-row edges */
        mpu_tick();                      /* MPU6050 tilt word + M rows */
        adc_status_tick();               /* also works when ADC verification failed */
        pl_control_tick();
        rehab_service();
        hdc_service();
        if (ui_action || ui_sd_action || ui_rehab_action || ui_hdc_save || ui_hdc_model || hand_storage_action)
            return DMA_WAIT_UI;
        acquisition_service();
        if (dma_fault) return dma_fault;
        if (dma_head!=dma_tail) return 0u;
        /* Display/input/control get first use of idle time. Diagnostic FFTs
         * consume a wall-clock quota, not eight chunks on every poll. */
        lcd_slice_tick(gt_stamp());       /* bounded work, independent of TLAST */
        acquisition_service();
        if(dma_fault)return dma_fault;
        if(dma_head!=dma_tail)return 0u;
        cq_background_tick(gt_stamp());
        acquisition_service();
        if(dma_fault)return dma_fault;
        if(dma_head!=dma_tail)return 0u;
        if (gt_stamp() - t_service >= 5u * GT_TICKS_PER_MS) {
            uart_poll_rx();
            t_service = gt_stamp();
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
#define GT_CNT_LO      MMIO32(GT_BASE)
#define GT_CNT_HI      MMIO32(GT_BASE + 0x04)
#define GT_CNTRL       MMIO32(GT_BASE + 0x08)
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
#ifdef LCD_HOST_TEST
    return lcd_test_clock();
#else
    u32 hi, lo;
    do {
        hi = GT_CNT_HI;
        lo = GT_CNT_LO;
    } while (hi != GT_CNT_HI);                  /* latch-consistent low word */
    return lo;                                  /* wraps every 12.9 s: u32 diff is still valid */
#endif
}

#include "pl_learning.h"

void usleep(unsigned long microseconds)
{
#ifndef LCD_HOST_TEST
    while (microseconds) {
        u32 chunk=microseconds>1000u?1000u:(u32)microseconds;
        u32 start=gt_stamp();
        while ((u32)(gt_stamp()-start)<chunk*333u) acquisition_service();
        microseconds-=chunk;
    }
#else
    (void)microseconds;
#endif
}

/* ---- RGB LCD display path (vh-3) ---------------------------------------- *
 * DDR -> axi_vdma_0 (MM2S only, RGB888, 3 frame stores) -> v_axi4s_vid_out_0
 * -> LCD pins.  v_tc_0 free-runs the panel timing (set via
 *    build/scripts/set_lcd_panel.tcl <4384|7016>) from the GEN_* config
 * parameters baked into the IP, so no VTC setup is needed at runtime.
 *
 * Register map (address report of build/scripts/add_lcd_vdma.tcl):
 *   axi_vdma_0 0x43000000, v_tc_0 0x43C00000 (untouched),
 *   backlight GPIO 0x41200000 (axi_gpio_0 all-outputs: bit 0 = lcd_bl).
 *
 * Framebuffers: 3 frame stores at 0x18000000 - inside the S_AXI_HP0 DDR
 * window (0x0..0x1FFFFFFF), above the app (0x10000000) and the EMG
 * ping-pong buffers (0x11000000), well inside the 1 GB DDR.  Store size is
 * panel-derived: 1024*600*3 = 1.8 MB (ATK-7016) or 800*480*3 = 1.1 MB
 * (ATK-4384) per frame.
 * DDR bytes per pixel are B,G,R (VDMA 24-bit little-endian stream,
 * tdata[23:16]=R - see board/constraints/hz_zynq_lcd.xdc), so byte 0 of
 * each pixel is B.  Bytes-per-line stays a multiple of 8 on both panels
 * (3072 B/line 7016, 2400 B/line 4384) for 64-bit AXI read alignment.
 *
 * MM2S direct register mode: reset -> HSIZE/STRIDE/start addresses ->
 * VSIZE (arms the channel) -> RS=1; PARKPTR selects a completed frame
 * for scanout. Framebuffer L1 cache lines are cleaned to DDR, followed by
 * a barrier, before the requested park index changes. */

/* 2026-10-10 A/B stall ladder: LCD_ENABLE selects the LCD-path slice under
 * test - 0 = fully out, 1 = full virtual hand, 2 = VDMA-only (no redraws).
 * Full-LCD reference source: main_with_lcd_20261010.c.bak nearby. */
#define VDMA_BASE       0x43000000u
#define VDMA_DMACR      MMIO32(VDMA_BASE + 0x00)
#define VDMA_DMASR      MMIO32(VDMA_BASE + 0x04)
#define VDMA_PARKPTR    MMIO32(VDMA_BASE + 0x28)
#define VDMA_VSIZE      MMIO32(VDMA_BASE + 0x50)
#define VDMA_HSIZE      MMIO32(VDMA_BASE + 0x54)
#define VDMA_STRIDE     MMIO32(VDMA_BASE + 0x58)
#define VDMA_START(n)   MMIO32(VDMA_BASE + 0x5C + 4u * (n))

#define GPIO_BL         MMIO32(0x41200000u)
#define GPIO_ID         MMIO32(0x41200008u)  /* axi_gpio_0 ch2 */

/* Panel auto-detect: the PL (lcd_panel_adapter_0) tri-states the RGB pins
 * while DE is idle, samples the panel ID bits (B7/G7/R7) once at boot -
 * the ATK official 21_lcd_rgb_char scheme - latches lcd_id[15:0] and picks
 * the pixel clock (MMCM 50M -> {50, 31.25} MHz + BUFGMUX) and the video
 * timing itself.  v_tc_0 is gone; the PS never touches SLCR/VTC.
 * Here the PS only reads the latched id to size the framebuffer/VDMA and
 * scale the 1024x600 design-space layout.  Unknown id falls back to the
 * ATK-4384 800x480 panel on BOTH sides (PL default + PS fallback). */
static i32 lcd_w = 800;                 /* runtime panel width   */
static i32 lcd_h = 480;                 /* runtime panel height  */
static u32 fb_bpl = 800u * 3u;          /* bytes per frame line  */
static u32 fb_bytes = 800u * 3u * 480u; /* one frame store       */

/* Layout transform: every drawing coordinate below is authored in the
 * 1024x600 (ATK-7016) design space and mapped at run time, so both
 * panels share one set of literals.  LCD_X/LCD_Y map positions, LCD_S
 * maps lengths/radii uniformly (y-proportional).  All three are identity
 * for the 1024x600 panel. */
#define LCD_W           lcd_w
#define LCD_H           lcd_h
#define LCD_X(v)        ((v) * LCD_W / 1024)
#define LCD_Y(v)        ((v) * LCD_H / 600)
#define LCD_S(v)        ((v) * LCD_H / 600)

#define FB_BPL          fb_bpl
#define FB_BYTES        fb_bytes
#define FB_BASE         0x18000000u

#define VDMA_DMACR_RESET  0x00000004u
#define VDMA_DMACR_RS     0x00000001u
/* CR bit1 (TAIL_EN) selects circular frame-store rotation, NOT park: the
 * driver (xaxivdma_channel.c) sets it only for EnableCircularBuf and clears
 * it in park mode.  PARKPTR steering requires bit1=0, so the channel runs
 * with RS only - no genlock (XCI c_mm2s_genlock_mode=0), no rotation. */
#define VDMA_DMASR_HALTED 0x00000001u
#define VDMA_PARK_READREF 0x0000001Fu /* PARKPTR[4:0]: read-park frame */
#define VDMA_PARK_CURRENT(w) (((w) >> 16) & 0x1fu)

static volatile u8 *lcd_framebuffer(u32 index)
{
#ifdef LCD_HOST_TEST
    return lcd_test_fb(index);
#else
    return (volatile u8 *)(uintptr_t)(FB_BASE + index * FB_BYTES);
#endif
}

/* ---- GT911 capacitive touch (PL-packed word via axi_gpio_1) ----------- *
 * touch_gt911_0 runs the whole GT911 protocol in the PL (reset sequencing,
 * 0x5D/0x14 address probe, 200 kHz I2C polling of 0x814E/0x814F) and
 * exposes one 32-bit latch word on the GPIO:
 *   [31] link_valid  [30] down  [29:24] roll  [23:12] x  [11:0] y
 * x/y are panel-native pixels (GT911 config resolution == panel native ==
 * the framebuffer size the PS derived from the panel id, so no scaling).
 * The word updates in the 50 MHz domain while this runs on the 100 MHz AXI
 * clock: double-read + compare detects a torn word, retry next spin.
 * 'C x=.. y=.. dn=..' rows go out on press/release edges plus throttled
 * moves (TOUCH_ROW_MIN_MS); [STAT] carries the counters. */
#define TOUCH_GPIO      MMIO32(0x41210000u)  /* axi_gpio_1 ch1 */
// Existing GPIO channel 2: done/ok/error/bad address + actual C3/P/N bytes.
#define ADC_CONFIG_GPIO MMIO32(0x41210008u)
static u32 adc_config_word;
static const char *adc_config_label(void)
{
    if (!(adc_config_word & 0x80000000u)) return "ADC配置等待";
    if ((adc_config_word & 0x60000000u) != 0x40000000u) return "ADC配置错误";
    return "ADC配置正常";
}
#define TOUCH_TW_VALID(w) ((w) >> 31)
#define TOUCH_TW_DOWN(w)  (((w) >> 30) & 1u)
#define TOUCH_TW_X(w)     (((w) >> 12) & 0xFFFu)
#define TOUCH_TW_Y(w)     ((w) & 0xFFFu)
#define TOUCH_ROW_MIN_MS  100u   /* throttle between move C-rows */

static u32 touch_seen;          /* link_valid observed at least once */
static u32 touch_dn;            /* last emitted contact state */
static u32 touch_x, touch_y;    /* last contact position (LCD pixels) */
static u32 touch_press_cnt;     /* [STAT] press edges since boot */
static u32 touch_rel_cnt;       /* [STAT] release edges since boot */
static u32 touch_last_row_t;    /* gt_stamp of the last C-row */
static u32 touch_word_raw,touch_bad_xy,touch_bad_word;
static void lcd_input_status_changed(void);

static void touch_tick(void)
{
    u32 w = TOUCH_GPIO;
    u32 x, y, dn;
    if (w != TOUCH_GPIO)            /* torn/mid-update: retry next spin */
        return;
    touch_word_raw=w;
    if (!TOUCH_TW_VALID(w)) {
        u32 changed=touch_seen || touch_dn;
        touch_seen = 0u;
        touch_dn = 0u;
        lcd_hand_contact(0u,0u,0u);lcd_virtual_contact(0u,0u,0u);
        if(changed)lcd_input_status_changed();
        return;
    }
    if(!touch_seen) {touch_seen=1u;lcd_input_status_changed();}
    touch_seen = 1u;
    x = TOUCH_TW_X(w);
    y = TOUCH_TW_Y(w);
    if (x >= (u32)LCD_W || y >= (u32)LCD_H) {
        if(w!=touch_bad_word) {touch_bad_xy++;touch_bad_word=w;}
        lcd_hand_contact(0u,0u,0u);lcd_virtual_contact(0u,0u,0u);
        return;                    /* bad packet must not click an edge button */
    }
    dn = TOUCH_TW_DOWN(w);
    if (dn && !touch_dn) {
        touch_press_cnt++;
        ui_touch_press(x, y);           /* feed the on-screen mode menu */
    } else if (!dn && touch_dn)
        touch_rel_cnt++;
    lcd_hand_contact(x,y,dn);lcd_virtual_contact(x,y,dn);

    if(dn!=touch_dn)lcd_input_status_changed();

    if (dn != touch_dn ||
        (dn && (x != touch_x || y != touch_y) &&
         (gt_stamp() - touch_last_row_t) >=
             (u32)(TOUCH_ROW_MIN_MS * GT_TICKS_PER_MS))) {
        touch_last_row_t = gt_stamp();
        if (g_mode == MODE_MONITOR) {
            g_tx_data = 1u;
            uprintf("C x=%u y=%u dn=%u\n", x, y, dn, 0);
            g_tx_data = 0u;
        }
    }
    touch_dn = dn;
    touch_x = x;
    touch_y = y;
}

/* ---- MPU6050 forearm tilt (PL-packed word via axi_gpio_2) ---- *
 * mpu6050_tilt_0 runs the whole protocol in the PL (wake config,
 * 0x68/0x69 probe, 100 Hz 14-byte burst reads, CORDIC complementary
 * filter) and exposes one 32-bit latch word:
 *   [31] link_valid  [30:24] seq  [23:12] pitch s12  [11:0] roll s12
 * (pitch/roll in 0.1 deg units).  Double-read + compare detects a torn
 * word.  'M p=.. r=..' rows go out throttled (MPU_ROW_MIN_MS, ~5 Hz);
 * [STAT] carries the link state. */
#define MPU_GPIO      MMIO32(0x41220000u)  /* axi_gpio_2 ch1 */
#define MPU_MOTION_A  MMIO32(0x41220008u)  /* ax,ay */
#define MPU_MOTION_B  MMIO32(0x41230000u)  /* az,gx */
#define MPU_MOTION_C  MMIO32(0x41230008u)  /* gy,gz */
#define MPU_TW_VALID(w) ((w) >> 31)
/* s12 two's-complement slices: v^0x800-0x800 sign-extends without UB. */
#define MPU_TW_PITCH(w) ((i32)((((w) >> 12) & 0xFFFu) ^ 0x800u) - 0x800u)
#define MPU_TW_ROLL(w)  ((i32)(((w) & 0xFFFu) ^ 0x800u) - 0x800u)
#define MPU_ROW_MIN_MS  200u   /* ~5 Hz M-row throttle */

/* Legacy tilt keys / fallback angles. The six-axis quaternion matrix owns
 * the live 3D transform and uses fixed world up. Zero capture requires 100
 * consecutive still samples ('z' re-samples); motion restarts the window.
 * Sensor units below are 0.1 degree, with X->little finger, Y->elbow. */
#define MPU_TILT_AXIS       1    /* Y toward elbow: pitch is pronation */
#define MPU_TILT_SIGN       (-1) /* left hand, Y points elbow */
#define MPU_TILT_SHIFT_SIGN (-1) /* X points little-finger side */
#define MPU_TILT_GAIN       10   /* ten 0.1-degree units = one screen degree */
#define MPU_TILT_DEADBAND   10   /* +/- 1 degree, removed continuously */
#define MPU_TILT_MAX        160  /* allow palm/back/side views */
#define MPU_SHIFT_MAX       65   /* forearm elevation clamp in degrees */
#define MPU_ZERO_SAMPLES    100  /* zero-pose window: ~1 s at 100 Hz */

static u32 mpu_seen;            /* link_valid observed at least once */
static u32 mpu_last_word, mpu_word_seen;
static u32 mpu_last_row_t;      /* gt_stamp of the last M-row */
static u32 mpu_last_sample_t;
static i32 mpu_pitch, mpu_roll; /* 0.1 deg */

static i32 mpu_zero_r, mpu_zero_p;  /* sampled zero pose (0.1 deg) */
static u32 mpu_zero_valid;
static u32 mpu_zero_cnt;
static i32 mpu_zero_acc_r, mpu_zero_acc_p;
static i32 mpu_tilt_q;          /* forearm longitudinal rotation, degrees */
static i32 mpu_shift_q;         /* forearm elevation, degrees (legacy name) */
static u32 lcd_state_cls;       /* redraw key, shared with lcd_show_state */
static u32 lcd_state_conf;
static u32 lcd_state_fatigue;
static u32 lcd_state_fatigue_ready;
static u32 fat_level, fat_full, fat_energy;   /* id 9: trend/assessment ready/energy */
static u32 lcd_state_gated;
static i32 lcd_state_tilt;
static i32 lcd_state_shift;
static u32 lcd_state_valid;
static i32 lcd_imu_matrix[9]={-4096,0,0,0,4096,0,0,0,-4096};
static u32 lcd_imu_valid, lcd_imu_generation, lcd_state_imu_generation;
#ifdef LCD_HOST_TEST
static void lcd_imu_ingest(u32 a,u32 b,u32 c,u32 word);
#endif
static void lcd_imu_reset(void);
static void lcd_imu_poll(void);
static u32 lcd_wave_view;
static u32 lcd_data_view;
static u32 lcd_spectrum_view;
static u32 lcd_synergy_view;
static u32 lcd_sd_view;
static u32 lcd_settings_view;
static u32 lcd_rehab_view;
static u32 lcd_selfcal_view;
static u32 lcd_hdc_view;
static u32 lcd_hand_view,lcd_virtual_view;
static u32 hand_source_hdc,virtual_hdc_margin;
static u32 virtual_frame_cls=UINT32_MAX,virtual_frame_mapped,virtual_frame_ready,virtual_frame_margin;
static u32 lcd_wave_hit(u32 x,u32 y,i32 bx,i32 by,i32 bw,i32 bh);
static void lcd_virtual_open(void);
static void lcd_virtual_render(void);
static void lcd_virtual_touch(u32 x,u32 y);
static void lcd_virtual_sample(void);
static u32 virtual_live_class(void);
static u32 virtual_live_mapped(u32 cls);
static const char *hdc_name(u32 cls);
static u32 hdc_hand_model_ready(void);
static const char *hdc_status_label(void);
static void lcd_hand_open(void);
static void lcd_hand_render(void);
static void lcd_hand_touch(u32 x,u32 y);
static hdc_learning_t hdc;
static void lcd_hdc_open(void);
static void lcd_hdc_render(void);
static void lcd_hdc_touch(u32 x,u32 y);
static selfcal_state_t selfcal;
static u16 selfcal_latest_seq;
static u16 feature_window_start_seq;
static u32 cal_stage;
static synergy_nmf_state_t synergy_nmf;
static synergy_feedback_t synergy_feedback;
static u32 rehab_effort_enabled;
#define SYNERGY_HISTORY_N 100u /* one point / 100 ms, 10 s visible */
static u8 synergy_history[SYNERGY_HISTORY_N][SYNERGY_N];
static u32 synergy_history_write,synergy_history_count,synergy_history_hop;
static u32 synergy_last_t,synergy_seq_seen;
static u32 synergy_stale_reported;
static u16 synergy_last_seq;
static void synergy_on_window(const u32 e[8],u16 seq);
static rehab_training_t rehab;
static u32 rehab_combo,rehab_action=1u,rehab_reps_sel=1u,rehab_hold_sel=1u,rehab_rest_sel;
static void lcd_rehab_render(void);
static void lcd_rehab_touch(u32 x,u32 y);
static void lcd_rehab_open(void);
static void lcd_selfcal_open(void);
static void lcd_selfcal_render(void);
static void lcd_selfcal_touch(u32 x,u32 y);
static void rehab_apply_action(u32 action);
static u32 ui_refresh_ms=20u, ui_grid_enabled=1u;
static void lcd_settings_render(void);
static void lcd_settings_touch(u32 x,u32 y);
static u32 sd_pair_dropped;
static u32 lcd_analysis_focus;
static u32 lcd_quality_view=1u;
static void lcd_wave_toggle(void);
static u32 lcd_wave_touch(u32 x, u32 y);
static void lcd_analysis_toggle(void);
static void lcd_spectrum_toggle(void);
static void lcd_main_view_toggle(void);
static u32 lcd_analysis_touch(u32 x, u32 y);
static u32 lcd_spectrum_touch(u32 x, u32 y);
static void lcd_sd_render(void);
static void lcd_analysis_changed(void);
static void lcd_analysis_render(void);
static void lcd_synergy_render(void);
static void lcd_spectrum_render(void);
static void lcd_analysis_label(char *dst,u32 cap,const char *prefix,
                               u32 value,const char *suffix);
static void lcd_analysis_percent_bp(char *dst,u32 cap,const char *prefix,u32 bp);

/* Touch menu dispatches the existing monitor/record and calibration paths.
 * Actions run in the main loop, outside the active DMA wait/parse call. */
#define UI_MODE_N 5

static u32 ui_menu_open;        /* overlay currently shown */
static u32 ui_mode_sel;         /* last menu action */
static u32 ui_dirty;            /* menu state moved: next repaint is full */
static u32 ui_generation;
static u32 ui_feedback_active,ui_feedback_x,ui_feedback_y,ui_feedback_t,ui_feedback_owner;
static u32 ui_feedback_presented,ui_feedback_serial,dl_feedback_serial;
/* Forward declaration: feature packets can request a coalesced LCD refresh
 * before the draw-list scheduler is declared below. */
static u32 lcd_pending;
static i32 ui_preview_cls = -1; /* bottom pose buttons: local preview */
static char ui_mode_label[32] = "模式:监测";
static const char *const ui_mode_names[UI_MODE_N] = {
    "监测", "记录", "校准", "MPU校准", "SD记录"
};
static void lcd_input_status_changed(void)
{
    ui_dirty=1u;
    if(lcd_state_valid)
        lcd_show_state(lcd_state_cls,lcd_state_conf,lcd_state_fatigue,lcd_state_gated,
                       lcd_state_tilt,lcd_state_shift);
}

static void lcd_analysis_changed(void)
{
    /* Feature packets arrive faster than the LCD can repaint. Coalesce them
     * into the normal 20 ms frame scheduler instead of rebuilding a frame for
     * every packet. */
    if ((lcd_data_view || lcd_spectrum_view || lcd_synergy_view) && !ui_menu_open)
        lcd_pending = 1u;
}

/* Diagnostics are on-demand: the FFT worker only runs while a button-
 * triggered check is in flight, then with up to 2.5 ms per 5 ms while the
 * page content is static. One idle opportunity drains a budget-bounded
 * burst of small chunks: the poll loop that reaches this runs far fewer
 * times per second than the worker needs chunks, so a single 32-step chunk
 * per opportunity could not drain eight windows inside the check timeout
 * (the V23 continuous mode was already opportunity-limited, not
 * quota-limited). The wall-clock quota, not the chunk count, bounds each
 * burst; the burst also stops as soon as no window remains ready. */
static u32 cq_budget_t,cq_budget_used,cq_background_calls,cq_chunk_max_ticks;
static void cq_background_tick(u32 now)
{
    u32 start,dt;
    if(cq_check_tick(now))lcd_analysis_changed();
    if(!cq_check_state)return;
    if(now-cq_budget_t>=5u*GT_TICKS_PER_MS) {
        cq_budget_t=now;cq_budget_used=0u;
    }
    if(cq_budget_used>=2500u*(GT_TICKS_PER_MS/1000u))return;
    start=gt_stamp();
    do {
        if(cq_service())lcd_analysis_changed();
        cq_background_calls++;
        dt=gt_stamp()-start;
    } while(cq_work_pending() &&
            cq_budget_used+dt<2500u*(GT_TICKS_PER_MS/1000u));
    cq_budget_used+=dt;
    if(dt>cq_chunk_max_ticks)cq_chunk_max_ticks=dt;
}

/* One route owns page flags and task exit hooks. Page changes preserve an SD
 * recording; changing the acquisition backend remains an explicit action. */
enum { UI_MONITOR,UI_WAVE,UI_DATA,UI_SPECTRUM,UI_SD,UI_SYNERGY,
       UI_REHAB,UI_SETTINGS,UI_HDC,UI_HAND,UI_SELFCAL,UI_VIRTUAL,UI_PAGE_COUNT };
static u32 rehab_milliseconds(void);
static u32 ui_page_owner(void)
{
    return ui_menu_open?UI_PAGE_COUNT:
        lcd_virtual_view?UI_VIRTUAL:lcd_hand_view?UI_HAND:lcd_hdc_view?UI_HDC:lcd_selfcal_view?UI_SELFCAL:
        lcd_settings_view?UI_SETTINGS:lcd_rehab_view?UI_REHAB:lcd_sd_view?UI_SD:
        lcd_data_view?UI_DATA:lcd_wave_view?UI_WAVE:lcd_spectrum_view?UI_SPECTRUM:
        lcd_synergy_view?UI_SYNERGY:UI_MONITOR;
}
static void ui_feedback_tick(void)
{
    if(ui_feedback_active && ui_feedback_presented &&
       gt_stamp()-ui_feedback_t>=100u*GT_TICKS_PER_MS) {
        ui_feedback_active=0u;ui_generation++;lcd_pending=1u;lcd_input_status_changed();
    }
}
static void ui_open_page(u32 page)
{
    if(page>=UI_PAGE_COUNT)return;
    if(page!=UI_REHAB) {
        rehab_pause(&rehab,RH_REASON_USER,rehab_milliseconds());
        if(ui_rehab_action!=3u && ui_rehab_action!=4u)ui_rehab_action=0u;
        if(synergy_feedback.capture==1u || synergy_feedback.capture==2u)
            synergy_feedback.capture=4u;
    }
    if(page!=UI_HDC){hdc_interrupt(&hdc);ui_hdc_model=0u;ui_hdc_save=0u;}
    if(page!=UI_SELFCAL && (selfcal.state==1u || selfcal.state==2u))selfcal_reset(&selfcal);
    /* Pending starts belong to the page on which they were requested. */
    if(page!=UI_SD && ui_sd_action==1u)ui_sd_action=0u;
    ui_action=0u;
    if(lcd_hand_view || hand_busy())hand_stop();
    lcd_wave_view=page==UI_WAVE;lcd_data_view=page==UI_DATA;
    lcd_spectrum_view=page==UI_SPECTRUM;lcd_sd_view=page==UI_SD;
    lcd_synergy_view=page==UI_SYNERGY;lcd_rehab_view=page==UI_REHAB;
    lcd_settings_view=page==UI_SETTINGS;lcd_hdc_view=page==UI_HDC;
    lcd_hand_view=page==UI_HAND;lcd_selfcal_view=page==UI_SELFCAL;
    lcd_virtual_view=page==UI_VIRTUAL;lcd_virtual_contact(0u,0u,0u);
    ui_menu_open=0u;ui_preview_cls=-1;ui_generation++;lcd_input_status_changed();
}

/* One source for virtual and physical following; selecting never arms PWM. */
static void ui_recognition_source(u32 use_hdc)
{
    if(hand_busy())hand_stop();
    hand_hdc_reset();hdc_interrupt(&hdc);
    hand_source_hdc=use_hdc?1u:0u;virtual_hdc_margin=0u;ui_preview_cls=-1;
    ui_generation++;lcd_pending=1u;lcd_input_status_changed();
}

static void ui_home_open(void)
{
    ui_open_page(UI_MONITOR);
    ui_menu_open=1u;ui_generation++;lcd_input_status_changed();
}

static void lcd_analysis_toggle(void)
{
    ui_open_page(lcd_data_view?UI_MONITOR:UI_DATA);
}

static void lcd_spectrum_toggle(void)
{
    ui_open_page(lcd_spectrum_view?UI_MONITOR:UI_SPECTRUM);
}

static void lcd_main_view_toggle(void)
{
    if(ui_menu_open)ui_open_page(UI_MONITOR);
    else if(lcd_virtual_view || lcd_hand_view || lcd_hdc_view || lcd_selfcal_view)ui_open_page(UI_SETTINGS);
    else ui_home_open();
}

static void adc_status_tick(void)
{
    u32 word=ADC_CONFIG_GPIO;
    if(word!=ADC_CONFIG_GPIO || word==adc_config_word) return;
    adc_config_word=word;
    lcd_input_status_changed();
}

static void ui_set_mode_label(u32 sel)
{
    static const char pfx[] = "模式:";
    const char *name = ui_mode_names[sel==1u ? 1u : 0u];
    u32 i, j = 0;
    for (i = 0; pfx[i] != '\0' && j < sizeof ui_mode_label - 1u; i++)
        ui_mode_label[j++] = pfx[i];
    for (i = 0; name[i] != '\0' && j < sizeof ui_mode_label - 1u; i++)
        ui_mode_label[j++] = name[i];
    ui_mode_label[j] = '\0';
}

/* [MENU] rows: monitor mode only, bypassing the debug gate like the touch
 * C-rows - the record stream must stay binary-clean. */
static void ui_menu_row(const char *fmt, u32 n)
{
    if (g_mode != MODE_MONITOR)
        return;
    g_tx_data = 1u;
    uprintf(fmt, n, 0, 0, 0);
    g_tx_data = 0u;
}

/* Press-edge hook from touch_tick.  Menu open: pick an entry (and close)
 * or tap anywhere else to dismiss.  Menu closed: only the header button
 * opens it. */
static void ui_touch_press(u32 x, u32 y)
{
    i32 px = (i32)x, py = (i32)y;
    i32 bx, by, bw, bh;
    u32 i;

    ui_feedback_x=x;ui_feedback_y=y;ui_feedback_t=gt_stamp();
    ui_feedback_owner=ui_page_owner();ui_feedback_active=1u;
    ui_feedback_presented=0u;ui_feedback_serial++;
    ui_generation++;lcd_pending=1u;lcd_input_status_changed();
    if (hand_busy() && px>=LCD_X(875) && px<LCD_X(1008) && py>=LCD_Y(30) && py<LCD_Y(82)) {
        hand_stop();ui_menu_open=0u;ui_generation++;lcd_input_status_changed();return;
    }
    if(py>=LCD_Y(30) && py<LCD_Y(82)) {
        if(px>=LCD_X(330) && px<LCD_X(480)) {ui_home_open();return;}
        if(px>=LCD_X(520) && px<LCD_X(690)) {lcd_main_view_toggle();return;}
        if(px>=LCD_X(700) && px<LCD_X(850)) {lcd_rehab_open();return;}
        if(px>=LCD_X(875) && px<LCD_X(1008)) {
            ui_open_page(lcd_settings_view?UI_MONITOR:UI_SETTINGS);return;
        }
    }
    if(ui_menu_open) {
        static const u32 routes[]={UI_MONITOR,UI_REHAB,UI_DATA,UI_WAVE,UI_SPECTRUM,
                                   UI_SYNERGY,UI_SD,UI_HDC,UI_HAND};
        for(i=0u;i<9u;i++) {
            bx=LCD_X(28)+(i32)(i%3u)*LCD_X(330);
            by=LCD_Y(148)+(i32)(i/3u)*LCD_Y(98);
            if(px>=bx && px<bx+LCD_X(308) && py>=by && py<by+LCD_Y(78)) {
                if(routes[i]==UI_HAND)lcd_hand_open();
                else if(routes[i]==UI_HDC)lcd_hdc_open();
                else if(routes[i]==UI_REHAB)lcd_rehab_open();
                else {if(routes[i]==UI_DATA)lcd_quality_view=1u;ui_open_page(routes[i]);}
                return;
            }
        }
        for(i=0u;i<4u;i++) {
            bx=LCD_X(28)+(i32)i*LCD_X(246);
            if(px>=bx && px<bx+LCD_X(230) && py>=LCD_Y(486) && py<LCD_Y(538)) {
                ui_open_page(UI_MONITOR);ui_action=i+1u;return;
            }
        }
        return;
    }
    if (lcd_virtual_view) { lcd_virtual_touch(x,y); return; }
    if (lcd_hand_view) { lcd_hand_touch(x,y); return; }
    if (lcd_settings_view) { lcd_settings_touch(x,y); return; }
    if (lcd_hdc_view) { lcd_hdc_touch(x,y); return; }
    if (lcd_selfcal_view) { lcd_selfcal_touch(x,y); return; }
    if (lcd_rehab_view) { lcd_rehab_touch(x,y); return; }
    if (lcd_sd_view) {
        if (px>=LCD_X(740) && px<LCD_X(990) &&
            py>=LCD_Y(515) && py<LCD_Y(578)) {
            lcd_action_label=SD_ACTION_NONE;
            ui_generation++; lcd_input_status_changed(); return;
        }
        if (px>=LCD_X(332) && px<LCD_X(692) &&
            py>=LCD_Y(238) && py<LCD_Y(314)) {
            ui_sd_action=sd_record_active()?2u:1u;
            return;
        }
        for (i=0u;i<SD_LABEL_PAGES;i++) {
            bx=LCD_X(512)+(i32)i*LCD_X(161);
            if (px>=bx && px<bx+LCD_X(152) && py>=LCD_Y(328) && py<LCD_Y(364)) {
                lcd_sd_label_page=i;
                ui_generation++; lcd_input_status_changed(); return;
            }
        }
        for (i=0u;i<SD_LABELS_PER_PAGE;i++) {
            u32 action=lcd_sd_label_page*SD_LABELS_PER_PAGE+i+1u;
            if (action>SD_ACTION_COUNT) continue;
            bx=LCD_X(22)+(i32)i*LCD_X(196);
            by=LCD_Y(370); bw=LCD_X(180); bh=LCD_Y(62);
            if (px>=bx && px<bx+bw && py>=by && py<by+bh) {
                lcd_action_label=action;
                ui_generation++;
                lcd_input_status_changed();
                return;
            }
        }
        return;
    }
    if (lcd_data_view) {
        lcd_analysis_touch(x, y);
        return;
    }
    if (lcd_synergy_view) return;
    if (lcd_spectrum_view) {
        lcd_spectrum_touch(x,y);
        return;
    }
    if (lcd_wave_view) {
        lcd_wave_touch(x, y);
        return;
    }
    if(lcd_wave_hit(x,y,LCD_X(300),LCD_Y(99),LCD_X(220),LCD_Y(36))) {
        ui_recognition_source(!hand_source_hdc);return;
    }
    if(lcd_wave_hit(x,y,LCD_X(540),LCD_Y(99),LCD_X(210),LCD_Y(36))) {
        lcd_virtual_open();return;
    }
    for (i = 0; i < POSE_MODEL_CLASSES; i++) {
        bx = LCD_X(24) + (i32)i * LCD_X(190);
        by = LCD_Y(535); bw = LCD_X(160); bh = LCD_Y(40);
        if (px >= bx && px < bx + bw && py >= by && py < by + bh) {
            ui_preview_cls = ui_preview_cls == (i32)i ? -1 : (i32)i;
            ui_dirty = 1u;
            ui_generation++;
            ui_menu_row("[MENU] preview=%u\n", (u32)ui_preview_cls);
            lcd_show_state(lcd_state_cls, lcd_state_conf,
                           lcd_state_fatigue, lcd_state_gated,
                           lcd_state_tilt, lcd_state_shift);
            return;
        }
    }
}

/* Symmetric continuous deadband and nearest-degree rounding. */
static i32 mpu_tilt_fold(i32 raw, i32 maxdeg)
{
    i32 deg;
    if (raw < MPU_TILT_DEADBAND && raw > -MPU_TILT_DEADBAND)
        return 0;                       /* level arm: no offset */
    raw += raw >= 0 ? -MPU_TILT_DEADBAND : MPU_TILT_DEADBAND;
    deg = (raw + (raw >= 0 ? MPU_TILT_GAIN / 2 : -MPU_TILT_GAIN / 2)) /
          MPU_TILT_GAIN;
    if (deg > maxdeg)
        deg = maxdeg;
    if (deg < -maxdeg)
        deg = -maxdeg;
    return deg;
}

static void mpu_tilt_update(void)
{
    i32 deg, shf;
    if (!mpu_zero_valid) {
        deg = 0;                        /* zero-pose sampling in progress */
        shf = 0;
    } else {
        i32 rot_raw = MPU_TILT_SIGN *
            (MPU_TILT_AXIS ? mpu_pitch - mpu_zero_p : mpu_roll - mpu_zero_r);
        i32 shf_raw = MPU_TILT_SHIFT_SIGN *
            (MPU_TILT_AXIS ? mpu_roll - mpu_zero_r : mpu_pitch - mpu_zero_p);
        deg = mpu_tilt_fold(rot_raw, MPU_TILT_MAX);
        shf = mpu_tilt_fold(shf_raw, MPU_SHIFT_MAX);
    }
    if (deg == mpu_tilt_q && shf == mpu_shift_q)
        return;
    mpu_tilt_q = deg;
    mpu_shift_q = shf;
    if (lcd_state_valid)                /* retrigger with the cached state */
        lcd_show_state(lcd_state_cls, lcd_state_conf,
                       lcd_state_fatigue, lcd_state_gated,
                       mpu_tilt_q, mpu_shift_q);
}

static void mpu_tick(void)
{
#if defined(IMU_REFERENCE_TEST) || defined(IMU_SENSOR_MODEL_TEST)
    u32 w = MPU_GPIO;
    u32 a=MPU_MOTION_A,b=MPU_MOTION_B,c=MPU_MOTION_C;
    i32 p, r;
    if (w != MPU_GPIO)          /* torn/mid-update: retry next spin */
        return;
    if (!MPU_TW_VALID(w)) {
        if(mpu_seen) {
            lcd_imu_reset();
        }
        mpu_seen = 0u;
        mpu_word_seen = 0u;
        return;
    }
    mpu_seen = 1u;
    if (mpu_word_seen && w == mpu_last_word)
        return;                    /* zero capture counts sensor samples */
    mpu_word_seen = 1u;
    mpu_last_word = w;
    mpu_last_sample_t = gt_stamp();
    p = MPU_TW_PITCH(w);
    r = MPU_TW_ROLL(w);
    mpu_pitch = p;
    mpu_roll = r;
    lcd_imu_ingest(a,b,c,w);
    /* IMU owns zero capture; detected motion restarts the stable window. */
    mpu_tilt_update();          /* forearm tilt -> elbow transform + redraw */
    if(lcd_state_valid && lcd_state_imu_generation!=lcd_imu_generation)
        lcd_show_state(lcd_state_cls,lcd_state_conf,lcd_state_fatigue,lcd_state_gated,
                       mpu_tilt_q,mpu_shift_q);
    if (g_mode == MODE_MONITOR && (gt_stamp() - mpu_last_row_t) >=
        (u32)(MPU_ROW_MIN_MS * GT_TICKS_PER_MS)) {
        mpu_last_row_t = gt_stamp();
        g_tx_data = 1u;         /* data row: bypass the debug gate */
        uprintf("M p=%d r=%d\n", (u32)p, (u32)r, 0, 0);
        g_tx_data = 0u;
    }
#else
    lcd_imu_poll();
#endif
}

typedef struct {
    i32 x;
    i32 y;
} lcd_point;

/* UI strings are UTF-8 and use native-size Source Han Sans glyphs. */
static const char *const lcd_pose_names[5] = {
    "静止", "张开", "握拳", "腕屈", "腕伸"
};
static const char *const lcd_fat_names[4] = {
    "正常", "轻度", "疲劳", "重度"
};

#include "lcd_font_zh.h"

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

static i32 lcd_clip_top, lcd_clip_bottom = 600;

static void lcd_fill_row(volatile u8 *fb, i32 y, i32 x0, i32 x1,
                         u8 r, u8 g, u8 b)
{
    volatile u8 *row, *p, *end;
    u32 k, w;
    if (y < lcd_clip_top || y >= lcd_clip_bottom || y < 0 || y >= LCD_H || x0 > x1)
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
    if (y0 < lcd_clip_top) y0 = lcd_clip_top;
    if (y0 < 0) y0 = 0;
    if (y1 >= lcd_clip_bottom) y1 = lcd_clip_bottom - 1;
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

static const u8 *lcd_zh_glyph(u16 cp)
{
    u32 lo=0u,hi=(u32)LCD_ZH_N;
    while(lo<hi) {
        u32 mid=lo+(hi-lo)/2u;
        if(lcd_zh[mid].cp==cp) return lcd_zh[mid].g;
        if(lcd_zh[mid].cp<cp) lo=mid+1u;
        else hi=mid;
    }
    return (const u8 *)0;
}

/* Native CJK sizes: avoid enlarging a 16px bitmap on the small LCD. */
static i32 lcd_cjk_size(i32 scale)
{
    return scale <= 1 ? 16 : scale == 2 ? (LCD_W <= 800 ? 20 : 24) : 32;
}

static u32 lcd_font_index(i32 scale)
{
    return scale<=1?0u:scale==2?(LCD_W<=800?1u:2u):3u;
}

static i32 lcd_text_baseline(i32 scale)
{
    return lcd_font_metrics[lcd_font_index(scale)].baseline;
}

static i32 lcd_line_height(i32 scale)
{
    return lcd_font_metrics[lcd_font_index(scale)].height;
}

static void lcd_coverage_pixel(volatile u8 *fb,i32 x,i32 y,u32 alpha,
                               u8 r,u8 g,u8 b)
{
    volatile u8 *p;
    if(!alpha || x<0 || x>=LCD_W || y<0 || y>=LCD_H ||
       y<lcd_clip_top || y>=lcd_clip_bottom) return;
    p=fb+(u32)y*FB_BPL+(u32)x*3u;
    p[0]=(u8)(((u32)b*alpha+(u32)p[0]*(15u-alpha)+7u)/15u);
    p[1]=(u8)(((u32)g*alpha+(u32)p[1]*(15u-alpha)+7u)/15u);
    p[2]=(u8)(((u32)r*alpha+(u32)p[2]*(15u-alpha)+7u)/15u);
}

/* Shared UTF-8 decoder keeps fitting and raster advances identical. */
static u32 lcd_utf8_char(const char *text,u16 *cp)
{
    u8 c=(u8)text[0];
    if(c<128u) { *cp=c;return 1u; }
    if((c&0xe0u)==0xc0u && text[1] && ((u8)text[1]&0xc0u)==0x80u) {
        *cp=(u16)(((c&31u)<<6)|((u8)text[1]&63u));return 2u;
    }
    if((c&0xf0u)==0xe0u && text[1] && text[2] &&
       ((u8)text[1]&0xc0u)==0x80u && ((u8)text[2]&0xc0u)==0x80u) {
        *cp=(u16)(((c&15u)<<12)|(((u8)text[1]&63u)<<6)|((u8)text[2]&63u));return 3u;
    }
    *cp=0;return 1u;
}

static i32 lcd_char_advance(u16 cp,i32 scale)
{
    return cp<128u?6*(scale==1?2:scale):lcd_cjk_size(scale)+1;
}

static void lcd_text(volatile u8 *fb, i32 x, i32 y, i32 scale,
                     u8 r, u8 g, u8 b, const char *text)
{
    u32 index=lcd_font_index(scale);
    i32 size=lcd_font_metrics[index].size,row,col;
    i32 height=lcd_font_metrics[index].height;
    i32 offset=lcd_font_metrics[index].offset;
    while(*text) {
        u16 cp;
        const u8 *glyph;
        text+=lcd_utf8_char(text,&cp);
        glyph=lcd_zh_glyph(cp);
        if(glyph) {
            glyph+=offset;
            for(row=0;row<height;row++) for(col=0;col<size;col++) {
                u8 packed=glyph[(row*size+col)/2];
                u32 alpha=(col&1)?packed&15u:packed>>4;
                lcd_coverage_pixel(fb,x+col,y+row,alpha,r,g,b);
            }
        }
        x+=lcd_char_advance(cp,scale);
    }
}

/* Finish each immutable frame; newer input replaces only the pending state.
 * A third buffer excludes BOTH actual scanout and the requested park frame.
 * Cache cleaning and raster work are bounded; unsigned time differences
 * handle the ARM timer rollover and keep working without EMG/TLAST.
 */
#define LCD_DL_MAX 1536
#define LCD_SLICE_MS 2u

typedef struct {
    u32 op;
    i32 v0, v1, v2, v3, v4, v5, v6, v7, v8;
    u32 rgb;
    const char *str;
    char text[48];
} lcd_dl_t;

static lcd_dl_t dl[LCD_DL_MAX];
static u32 dl_len, dl_i, dl_busy, dl_trunc;
static u32 dl_back, lcd_front_index;
static u32 dl_t_req, dl_clean_y;
static volatile u8 *dl_fb, *dl_fb_now;
static u32 dl_mode, lcd_last_build_t;
static u32 lcd_stream_started, lcd_frozen, lcd_stream_on;
static u32 lcd_redraw_cnt, lcd_redraw_last_ms, lcd_redraw_max_ms;
static u32 lcd_present_cnt, lcd_coalesced_cnt, lcd_overflow_cnt;
/* Content updates observed in VDMA scanout, not the panel's fixed refresh. */
static u32 lcd_rate_seen,lcd_rate_t,lcd_rate_actual,lcd_rate_changes,lcd_content_fps10;
static void lcd_rate_tick(u32 now,u32 actual)
{
    u32 dt;
    if(actual>=3u)return;
    if(!lcd_rate_seen) {
        lcd_rate_seen=1u;lcd_rate_t=now;lcd_rate_actual=actual;return;
    }
    if(actual!=lcd_rate_actual){lcd_rate_actual=actual;lcd_rate_changes++;}
    dt=now-lcd_rate_t;
    if(dt>=1000u*GT_TICKS_PER_MS) {
        lcd_content_fps10=(u32)((uint64_t)lcd_rate_changes*10000u*GT_TICKS_PER_MS/dt);
        lcd_rate_changes=0u;lcd_rate_t=now;
    }
}
static u32 lcd_buffer_ui[3], lcd_buffer_valid[3];
static u32 dl_ui_generation;
static i32 lcd_draw_tilt, lcd_draw_shift;
static void lcd_begin_pending(void);

#define DL_RGB(r, g, b) (((u32)(r) << 16) | ((u32)(g) << 8) | (u32)(b))

static void dl_push(u32 op, i32 v0, i32 v1, i32 v2, i32 v3, i32 v4,
                    u32 rgb, const char *str)
{
    lcd_dl_t *e;
    if (dl_len >= LCD_DL_MAX) {
        dl_trunc = 1u;
        return;
    }

    e = &dl[dl_len++];
    e->op = op;
    e->v0 = v0; e->v1 = v1; e->v2 = v2; e->v3 = v3; e->v4 = v4;
    e->rgb = rgb;
    e->str = (const char *)0;
    if (str) {
        u32 j;
        for (j = 0; j < sizeof e->text - 1u && str[j]; j++)
            e->text[j] = str[j];
        e->text[j] = '\0';
        e->str = e->text;
    }
}

/* Translate the original dark palette at the raster boundary so every page,
 * including the draw-list path, shares the selected white visual theme. */
static void lcd_theme_color(u8 *r, u8 *g, u8 *b)
{
    u32 c=((u32)*r<<16)|((u32)*g<<8)|*b;
    switch(c) {
    case 0x080A10: case 0x121822: case 0x1C2533: case 0x1E2838:
        *r=255;*g=255;*b=255;break;
    case 0x161E2D: case 0x192230:
        *r=243;*g=247;*b=247;break;
    case 0x253346: case 0x2A3748:
        *r=232;*g=239;*b=239;break;
    case 0x1E2A3A: case 0x0B111A:
        *r=243;*g=247;*b=247;break;
    case 0x2D4254:
        *r=227;*g=242;*b=239;break;
    case 0x101824: case 0x232F3E:
        *r=225;*g=234;*b=236;break;
    case 0x465C6E:
        *r=170;*g=191;*b=195;break;
    case 0x37495E: case 0x46546A:
        *r=211;*g=222;*b=222;break;
    case 0x8C99AA:
        *r=94;*g=112;*b=119;break;
    case 0xE0E9F3: case 0xEEF3FA:
        *r=31;*g=49;*b=58;break;
    case 0x59BEDC: case 0x4BACC6:
    case 0x59DCAA:
        *r=25;*g=120;*b=111;break;
    case 0xE6CA46: case 0xFFB46E:
        *r=162;*g=101;*b=24;break;
    case 0xFF785A: case 0xE65656:
        *r=190;*g=58;*b=58;break;
    default: break;
    }
}

static void p_rect(i32 x, i32 y, i32 w, i32 h, u8 r, u8 g, u8 b)
{
    lcd_theme_color(&r,&g,&b);
    if (!dl_mode) {
        lcd_fill_rect(dl_fb_now, x, y, w, h, r, g, b);
        return;
    }
    /* Split big fills into <=6000-pixel bands to keep input/DMA polling responsive. */
    while (h > 0) {
        i32 step = 6000 / (w > 0 ? w : 1);
        if (step < 1)
            step = 1;
        if (step > h)
            step = h;
        dl_push(0, x, y, w, step, 0, DL_RGB(r, g, b), (const char *)0);
        y += step;
        h -= step;
    }
}

static void p_disc(lcd_point c, i32 radius, u8 r, u8 g, u8 b)
{
    lcd_theme_color(&r,&g,&b);
    if (!dl_mode) {
        lcd_disc(dl_fb_now, c, radius, r, g, b);
        return;
    }
    dl_push(1, c.x, c.y, radius, 0, 0, DL_RGB(r, g, b), (const char *)0);
}

static void p_text(i32 x, i32 y, i32 scale, u8 r, u8 g, u8 b,
                   const char *text)
{
    lcd_theme_color(&r,&g,&b);
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

static void lcd_quad(volatile u8 *fb, const lcd_dl_t *e,
                     u8 r, u8 g, u8 b)
{
    i32 xs[4] = {e->v0, e->v2, e->v4, e->v6};
    i32 ys[4] = {e->v1, e->v3, e->v5, e->v7};
    i32 y, lo = ys[0], hi = ys[0], i;
    for (i = 1; i < 4; i++) {
        if (ys[i] < lo) lo = ys[i];
        if (ys[i] > hi) hi = ys[i];
    }
    if (lo < lcd_clip_top) lo = lcd_clip_top;
    if (hi >= lcd_clip_bottom) hi = lcd_clip_bottom - 1;
    for (y = lo; y <= hi; y++) {
        i32 left = LCD_W, right = -1;
        for (i = 0; i < 4; i++) {
            i32 j = (i + 1) & 3, x;
            if (ys[i] == ys[j]) {
                if (y != ys[i]) continue;
                x = xs[i];
                if (x < left) left = x;
                if (x > right) right = x;
                x = xs[j];
            } else {
                if (y < (ys[i] < ys[j] ? ys[i] : ys[j]) ||
                    y > (ys[i] > ys[j] ? ys[i] : ys[j])) continue;
                x = xs[i] + (xs[j] - xs[i]) * (y - ys[i]) / (ys[j] - ys[i]);
            }
            if (x < left) left = x;
            if (x > right) right = x;
        }
        if (left <= right) lcd_fill_row(fb, y, left, right, r, g, b);
    }
}

#include "lcd_hand_3d.h"
#ifdef IMU_REFERENCE_TEST
#include "../../sim/imu_float_reference.h"
#else
#include "lcd_imu_3d.h"
#endif
#include "lcd_ui.h"
#include "lcd_waveform.h"
#include "lcd_settings.h"

#include "hdmi_mirror.h"

static void lcd_slice_tick(u32 t0)
{
    hdmi_service(t0);
    if (LCD_ENABLE != 1u || lcd_frozen) return;
    if(lcd_stream_started && lcd_stream_on)
        lcd_rate_tick(t0,VDMA_PARK_CURRENT(VDMA_PARKPTR));
    ui_feedback_tick();
    lcd_wave_tick();
    if(lcd_synergy_view && synergy_nmf.valid && !synergy_stale_reported &&
       gt_stamp()-synergy_last_t>500u*GT_TICKS_PER_MS) {
        synergy_stale_reported=1u;lcd_pending=1u;
    }
    if (!dl_busy) lcd_begin_pending();
    if (!dl_busy) return;
    while (dl_i < dl_len && gt_stamp() - t0 < LCD_SLICE_MS * GT_TICKS_PER_MS) {
        const lcd_dl_t *e = &dl[dl_i++];
        u8 r=(u8)(e->rgb >> 16), g=(u8)(e->rgb >> 8), b=(u8)e->rgb;
        switch (e->op) {
        case 0: lcd_fill_rect(dl_fb,e->v0,e->v1,e->v2,e->v3,r,g,b); break;
        case 1: lcd_disc(dl_fb,(lcd_point){e->v0,e->v1},e->v2,r,g,b); break;
        case 2: lcd_limb(dl_fb,(lcd_point){e->v0,e->v1},
                        (lcd_point){e->v2,e->v3},e->v4,r,g,b); break;
        case 3: lcd_text(dl_fb,e->v0,e->v1,e->v2,r,g,b,e->str); break;
        case 4: lcd_quad(dl_fb,e,r,g,b); break;
        case 5: lcd_clip_top=e->v0; lcd_clip_bottom=e->v1; break;
        case 6: lcd_depth_triangle(dl_fb,e,r,g,b); break;
        case 7: lcd_depth_clear(e->v0,e->v1); break;
        case 8: lcd_wave_line(dl_fb,e->v0,e->v1,e->v2,e->v3,r,g,b); break;
        }
        pump_tx();
        /* Return as soon as a completed EMG batch needs to be re-armed. */
        if (S2MM_DMASR & (DMASR_IOC | DMASR_ERROR_MASK)) return;
    }
    if (dl_i < dl_len) return;
    while (dl_clean_y < (u32)LCD_H &&
           gt_stamp() - t0 < LCD_SLICE_MS * GT_TICKS_PER_MS) {
        u32 rows = (u32)LCD_H - dl_clean_y;
        if (rows > 4u) rows = 4u;
        display_memory_clean((uintptr_t)dl_fb + dl_clean_y * FB_BPL, rows * FB_BPL);
        dl_clean_y += rows;
        if (S2MM_DMASR & (DMASR_IOC | DMASR_ERROR_MASK)) return;
    }
    if (dl_clean_y < (u32)LCD_H) return;
    if (VDMA_PARK_CURRENT(VDMA_PARKPTR) != lcd_front_index && lcd_stream_on)
        return;                    /* let the previous request enter scanout */
    if (!hdmi_settled()) return;
    lcd_memory_barrier();
    VDMA_PARKPTR = (VDMA_PARKPTR & ~VDMA_PARK_READREF) | dl_back;
    hdmi_present(dl_back);
    lcd_front_index = dl_back;       /* requested, actual scanout is in [20:16] */
    lcd_buffer_ui[dl_back] = dl_ui_generation;
    lcd_buffer_valid[dl_back] = 1u;
    lcd_present_cnt++;
    /* Start the visual dwell only after this tap reaches a presented frame.
     * A completed older frame must not consume a newer tap's feedback. */
    if(ui_feedback_active && !ui_feedback_presented &&
       dl_feedback_serial==ui_feedback_serial) {
        ui_feedback_presented=1u;ui_feedback_t=gt_stamp();
    }
    dl_busy = 0u;
    if(lcd_animation_busy && !lcd_wave_view && !lcd_data_view && !lcd_spectrum_view && !lcd_synergy_view && !lcd_sd_view && !lcd_settings_view && !lcd_rehab_view && !lcd_selfcal_view && !lcd_hdc_view && !lcd_hand_view) lcd_pending=1u;
    lcd_redraw_last_ms = (gt_stamp() - dl_t_req) / GT_TICKS_PER_MS;
    if (lcd_redraw_last_ms > lcd_redraw_max_ms) lcd_redraw_max_ms=lcd_redraw_last_ms;
}

/* Mode menu replaces the scene with a centered panel. Each entry dispatches
 * an existing mode/calibration action; buffer generations ensure a full
 * repaint when the overlay opens or closes. */
#include "lcd_home.h"

static void lcd_sd_render(void)
{
    static const u8 cyan[3]={89,190,220}, green[3]={89,220,170};
    static const u8 warn[3]={230,202,70}, white[3]={238,243,250};
    static const u8 muted[3]={140,153,170};
    char label[48];
    u32 i, active=(u32)sd_record_active(), error=(u32)sd_record_error();
    p_rect(0,LCD_Y(92),LCD_W,LCD_H-LCD_Y(92),18,24,34);
    ui_label(LCD_X(36),LCD_Y(112),LCD_X(320),2,white[0],white[1],white[2],"SD卡记录");
    ui_label(LCD_X(380),LCD_Y(120),LCD_X(610),1,muted[0],muted[1],muted[2],"断电前请停止并保存");
    p_rect(LCD_X(28),LCD_Y(155),LCD_X(968),LCD_Y(56),25,34,48);
    p_text(LCD_X(36),LCD_Y(174),2,muted[0],muted[1],muted[2],
           error?"SD错误":active?"正在记录":
           sd_record_ready()?"SD就绪":"等待开始");
    p_text(LCD_X(600),LCD_Y(174),1,
           error?warn[0]:(active?green[0]:cyan[0]),
           error?warn[1]:(active?green[1]:cyan[1]),
           error?warn[2]:(active?green[2]:cyan[2]),
           error?"检查存储卡":"原始 + 全处理");
    ui_button(LCD_X(332),LCD_Y(238),LCD_X(360),LCD_Y(76),active?"停止并保存":"开始记录",active);
    ui_label(LCD_X(36),LCD_Y(338),LCD_X(460),2,muted[0],muted[1],muted[2],"动作标签 / 后续采样");
    if(lcd_sd_label_page>=SD_LABEL_PAGES)lcd_sd_label_page=0u;
    for(i=0u;i<SD_LABEL_PAGES;i++)
        ui_button(LCD_X(512)+(i32)i*LCD_X(161),LCD_Y(328),LCD_X(152),LCD_Y(36),
                  sd_label_page_names[i],i==lcd_sd_label_page);
    for(i=0u;i<SD_LABELS_PER_PAGE;i++) {
        u32 action=lcd_sd_label_page*SD_LABELS_PER_PAGE+i+1u;
        i32 bx=LCD_X(22)+(i32)i*LCD_X(196);
        if(action<=SD_ACTION_COUNT)
            ui_button(bx,LCD_Y(370),LCD_X(180),LCD_Y(62),sd_action_names_zh[action],action==lcd_action_label);
    }
    p_rect(LCD_X(28),LCD_Y(452),LCD_X(968),LCD_Y(59),25,34,48);
    lcd_analysis_label(label,sizeof label,"帧数 ",sd_record_frames(),"");
    ui_label(LCD_X(36),LCD_Y(462),LCD_X(420),2,white[0],white[1],white[2],label);
    ui_label(LCD_X(36),LCD_Y(487),LCD_X(420),2,cyan[0],cyan[1],cyan[2],sd_record_filename());
    lcd_analysis_label(label,sizeof label,"配对丢失 ",sd_pair_dropped,"");
    ui_label(LCD_X(500),LCD_Y(462),LCD_X(480),2,sd_pair_dropped?warn[0]:muted[0],
             sd_pair_dropped?warn[1]:muted[1],sd_pair_dropped?warn[2]:muted[2],label);
    if (error) {
        lcd_analysis_label(label,sizeof label,"错误 ",error,"");
        ui_label(LCD_X(500),LCD_Y(487),LCD_X(480),2,warn[0],warn[1],warn[2],label);
    }
    ui_label(LCD_X(36),LCD_Y(532),LCD_X(160),2,muted[0],muted[1],muted[2],"当前标签");
    ui_label(LCD_X(205),LCD_Y(532),LCD_X(510),2,cyan[0],cyan[1],cyan[2],
             sd_action_names_zh[lcd_action_label<=SD_ACTION_COUNT?lcd_action_label:0u]);
    ui_button(LCD_X(740),LCD_Y(515),LCD_X(250),LCD_Y(63),"清除标签",lcd_action_label==0u);
}

static void lcd_selfcal_open(void)
{
    ui_open_page(UI_SELFCAL);
}

static void lcd_selfcal_touch(u32 x,u32 y)
{
    u32 i;
    if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(516),LCD_X(300),LCD_Y(62))) {
        if(selfcal.state==1u || selfcal.state==2u)selfcal_reset(&selfcal);
        ui_open_page(UI_SETTINGS);return;
    }
    if(lcd_wave_hit(x,y,LCD_X(356),LCD_Y(516),LCD_X(300),LCD_Y(62))) {
        if(g_mode==MODE_MONITOR && cal_stage==2u && !sd_record_active()) {
            selfcal_begin(&selfcal);
            pl_control_request(0u,0u);
        }
        ui_generation++;lcd_input_status_changed();return;
    }
    if(selfcal.state!=1u && selfcal.state!=2u)return;
    for(i=0u;i<5u;i++) {
        i32 bx=LCD_X(28)+(i32)i*LCD_X(196);
        if(lcd_wave_hit(x,y,bx,LCD_Y(278),LCD_X(180),LCD_Y(62))) {
            if(selfcal_arm(&selfcal,i)) {
                ui_generation++;lcd_input_status_changed();
            }
            return;
        }
    }
}

static void lcd_selfcal_render(void)
{
    static const u8 white[3]={31,49,58},muted[3]={94,112,119};
    static const u8 good[3]={25,120,111},warn[3]={162,101,24};
    static const char *const stage_name[]={"未开始","适配采样","独立验证","已完成"};
    static const char *const shift_name[]={"原模型","偏移 1 格","偏移 2 格","偏移 3 格","偏移 4 格","偏移 5 格"};
    char label[48];u32 i,total=0u,base=0u,adapt=0u;
    p_rect(0,LCD_Y(92),LCD_W,LCD_H-LCD_Y(92),248,250,250);
    ui_label(LCD_X(36),LCD_Y(108),LCD_X(600),2,white[0],white[1],white[2],"佩戴自校准 / 环向通道偏移");
    ui_label(LCD_X(650),LCD_Y(112),LCD_X(330),1,muted[0],muted[1],muted[2],
             g_mode==MODE_MONITOR?stage_name[selfcal.state<4u?selfcal.state:0u]:"请先进入监测模式");
    p_rect(LCD_X(28),LCD_Y(153),LCD_X(968),LCD_Y(94),239,245,245);
    ui_label(LCD_X(46),LCD_Y(166),LCD_X(930),1,muted[0],muted[1],muted[2],
             "环顺序 CH4→CH1→CH2→CH3→CH5→CH6；CH7/8 保持不变。");
    ui_label(LCD_X(46),LCD_Y(194),LCD_X(930),1,muted[0],muted[1],muted[2],
             "按类别后保持动作约 1 秒；完成适配段后，再按同样顺序做独立验证段。");
    ui_label(LCD_X(36),LCD_Y(254),LCD_X(500),2,white[0],white[1],white[2],
             selfcal.state==1u?"适配段：选择当前真实动作":
             selfcal.state==2u?"验证段：按提示重复动作":
             selfcal.state==3u?"验证结果":"每次佩戴重新评估，不修改原模型权重");
    for(i=0u;i<5u;i++) {
        i32 bx=LCD_X(28)+(i32)i*LCD_X(196);
        u32 n=selfcal.state==1u?selfcal.fit_n[i]:selfcal.val_n[i];
        ui_button(bx,LCD_Y(278),LCD_X(180),LCD_Y(62),lcd_pose_names[i],selfcal.armed&&selfcal.target==i);
        lcd_analysis_label(label,sizeof label,"",n," / 40 窗");
        ui_label(bx,LCD_Y(348),LCD_X(180),1,muted[0],muted[1],muted[2],label);
    }
    if(selfcal.state==3u) {
        for(i=0u;i<5u;i++) {
            total+=selfcal.val_n[i];base+=selfcal.val_ok[0][i];
            adapt+=selfcal.val_ok[selfcal.chosen_shift][i];
            lcd_analysis_label(label,sizeof label,"",selfcal.val_ok[selfcal.chosen_shift][i]," 命中");
            ui_label(LCD_X(28)+(i32)i*LCD_X(196),LCD_Y(390),LCD_X(180),1,muted[0],muted[1],muted[2],label);
        }
        lcd_analysis_label(label,sizeof label,"原模型验证 ",total?base*100u/total:0u,"%");
        ui_label(LCD_X(42),LCD_Y(438),LCD_X(300),1,muted[0],muted[1],muted[2],label);
        lcd_analysis_label(label,sizeof label,"适配候选 ",total?adapt*100u/total:0u,"%");
        ui_label(LCD_X(350),LCD_Y(438),LCD_X(300),1,selfcal.accepted?good[0]:warn[0],selfcal.accepted?good[1]:warn[1],selfcal.accepted?good[2]:warn[2],label);
        ui_label(LCD_X(650),LCD_Y(438),LCD_X(330),1,selfcal.accepted?good[0]:warn[0],selfcal.accepted?good[1]:warn[1],selfcal.accepted?good[2]:warn[2],
                 selfcal.accepted?shift_name[selfcal.applied_shift]:"未通过验证，保留原模型");
    } else {
        ui_label(LCD_X(36),LCD_Y(408),LCD_X(940),1,muted[0],muted[1],muted[2],
                 selfcal.armed?"保持所选动作；采样期间请勿切换动作。":
                 selfcal.state==1u||selfcal.state==2u?"下一步：选择动作并保持，直到计数达到 40。":
                 "流程需包含放松、张手、握拳、屈腕、伸腕。当前校准只比较 6 种离散环向平移。");
    }
    ui_button(LCD_X(28),LCD_Y(516),LCD_X(300),LCD_Y(62),"返回",0u);
    ui_button(LCD_X(356),LCD_Y(516),LCD_X(300),LCD_Y(62),
              selfcal.state==1u||selfcal.state==2u?"重新开始校准":"开始 / 重做校准",
              selfcal.state==1u||selfcal.state==2u);
    ui_label(LCD_X(690),LCD_Y(535),LCD_X(306),1,muted[0],muted[1],muted[2],
             selfcal.state==3u?(selfcal.accepted?"本次上电有效；重启需重校":"验证未通过；原模型有效"):
             "仅验证通过后临时启用");
}

static const char *pl_control_status_label(u32 gated)
{
#if PL_CONTROL_ENABLE
    if(!pl_control_initialized)return "等待决策";
    if(pl_control_inflight || pl_control_queued)return "配置确认";
    if(pl_control_word&8u)return "决策异常";
    if((pl_control_word&3u)!=2u)return "静息校准";
    if(pl_control_word&4u)return "等待数据";
#endif
    return gated?"门控开启":"门控关闭";
}

/* White clinical dashboard: preserve the existing camera, page routing and
 * touch rectangles. Side summaries are painted after the hand so rotated
 * geometry cannot cover text or controls. */
static void lcd_render_pose_content(u32 cls, u32 conf, u32 fatigue, u32 gated,
                            u32 full)
{
    char label[48];
    u32 i, safe_cls=cls<POSE_MODEL_CLASSES?cls:0u;
    u32 safe_fat=fatigue<4u?fatigue:3u;
    u32 display_cls=ui_preview_cls>=0?(u32)ui_preview_cls:hand_source_hdc?virtual_frame_cls:safe_cls;
    u32 adc_ok=(adc_config_word&0xe0000000u)==0xc0000000u;
    static const u8 fat_colors[4][3]={{25,120,111},{162,101,24},{190,58,58},{148,57,131}};
    (void)full;
    if(ui_menu_open) { ui_draw_menu();return; }
    if(ui_preview_cls>=0) { safe_cls=(u32)ui_preview_cls;conf=100u;gated=0u; }
    p_rect(0,0,LCD_W,LCD_H,255,255,255);
    p_rect(0,LCD_Y(90),LCD_W,LCD_Y(2),211,222,222);
    ui_label(LCD_X(28),LCD_Y(12),LCD_X(410),2,31,49,58,"自学习肌电意图解码康复训练系统");
    ui_label(LCD_X(28),LCD_Y(56),LCD_X(280),1,94,112,119,
        lcd_virtual_view?"虚拟手映射":lcd_rehab_view?"康复训练":lcd_hand_view?"机械手控制":lcd_hdc_view?"手势自学习":
        lcd_selfcal_view?"佩戴适配":lcd_settings_view?"显示与设备设置":lcd_sd_view?"SD记录标注":
        lcd_data_view?"通道与数据":lcd_wave_view?"波形示波":lcd_spectrum_view?"频谱分析":
        lcd_synergy_view?"肌肉协同":"实时监测");
    ui_draw_header();
    if(lcd_virtual_view) { lcd_virtual_render();return; }
    if(lcd_hand_view) { lcd_hand_render();return; }
    if(lcd_settings_view) { lcd_settings_render();return; }
    if(lcd_hdc_view) { lcd_hdc_render();return; }
    if(lcd_selfcal_view) { lcd_selfcal_render();return; }
    if(lcd_rehab_view) { lcd_rehab_render();return; }
    if(lcd_sd_view) { lcd_sd_render();return; }
    if(lcd_data_view) { lcd_analysis_render();return; }
    if(lcd_spectrum_view) { lcd_spectrum_render();return; }
    if(lcd_synergy_view) { lcd_synergy_render();return; }
    if(lcd_wave_view) { lcd_wave_render();return; }

    /* The source is shared with physical mapping, but PWM is armed separately. */
    if(hand_source_hdc && ui_preview_cls<0)conf=display_cls==UINT32_MAX?0u:virtual_frame_margin/100u;
    ui_button(LCD_X(300),LCD_Y(99),LCD_X(220),LCD_Y(36),hand_source_hdc?"来源 HDC":"来源 MLP",hand_source_hdc);
    ui_button(LCD_X(540),LCD_Y(99),LCD_X(210),LCD_Y(36),"虚拟手映射",0u);
    if(dl_mode) dl_push(5,LCD_Y(140),LCD_Y(515),0,0,0,0,0);
    else { lcd_clip_top=LCD_Y(140);lcd_clip_bottom=LCD_Y(515); }
    lcd_draw_hand(safe_cls,safe_fat);
    if(dl_mode) dl_push(5,0,LCD_H,0,0,0,0,0);
    else { lcd_clip_top=0;lcd_clip_bottom=LCD_H; }

    /* Quiet side surfaces, large result, and directly labeled status rows. */
    p_round_rect(LCD_X(22),LCD_Y(140),LCD_X(242),LCD_Y(375),LCD_S(10),243,247,247);
    p_round_rect(LCD_X(770),LCD_Y(140),LCD_X(232),LCD_Y(375),LCD_S(10),243,247,247);
    ui_label(LCD_X(42),LCD_Y(162),LCD_X(202),1,94,112,119,"当前手势");
    ui_label(LCD_X(42),LCD_Y(205),LCD_X(202),3,31,49,58,display_cls==UINT32_MAX?"等待识别":
        hand_source_hdc && ui_preview_cls<0?hdc_name(display_cls):lcd_pose_names[safe_cls]);
    ui_label(LCD_X(42),LCD_Y(276),LCD_X(202),1,94,112,119,hand_source_hdc && ui_preview_cls<0?"分离裕量":"置信度");
    if(hand_source_hdc && ui_preview_cls<0) {
        u32 bp=display_cls==UINT32_MAX?0u:virtual_frame_margin;
        lcd_analysis_percent_bp(label,sizeof label,"",bp);
    } else lcd_analysis_label(label,sizeof label,"",conf>100u?100u:conf,"%");
    ui_label(LCD_X(42),LCD_Y(307),LCD_X(202),3,31,49,58,label);
    p_rect(LCD_X(42),LCD_Y(352),LCD_X(202),LCD_Y(7),211,222,222);
    if(conf) p_rect(LCD_X(42),LCD_Y(352),(i32)((conf>100u?100u:conf)*LCD_X(202)/100u),LCD_Y(7),57,155,145);
    ui_label(LCD_X(42),LCD_Y(386),LCD_X(202),1,94,112,119,"疲劳状态");
    ui_label(LCD_X(42),LCD_Y(418),LCD_X(202),2,
             fat_full?fat_colors[safe_fat][0]:94,
             fat_full?fat_colors[safe_fat][1]:112,
             fat_full?fat_colors[safe_fat][2]:119,
             fat_full?lcd_fat_names[safe_fat]:"待评估");
    ui_label(LCD_X(42),LCD_Y(480),LCD_X(202),1,94,112,119,ui_mode_label);

    ui_label(LCD_X(790),LCD_Y(162),LCD_X(192),1,94,112,119,"设备状态");
    ui_label(LCD_X(790),LCD_Y(202),LCD_X(192),1,94,112,119,"信号采集");
    ui_label(LCD_X(790),LCD_Y(229),LCD_X(192),1,adc_ok?25:162,adc_ok?120:101,adc_ok?111:24,adc_config_label());
    p_rect(LCD_X(790),LCD_Y(264),LCD_X(192),1,211,222,222);
    ui_label(LCD_X(790),LCD_Y(286),LCD_X(192),1,94,112,119,"姿态跟踪");
    ui_label(LCD_X(790),LCD_Y(313),LCD_X(192),1,(mpu_zero_valid||lcd_imu_valid)?25:162,
             (mpu_zero_valid||lcd_imu_valid)?120:101,(mpu_zero_valid||lcd_imu_valid)?111:24,
             mpu_zero_valid?"MPU已校准":lcd_imu_valid?"MPU跟踪中":"等待MPU");
    p_rect(LCD_X(790),LCD_Y(348),LCD_X(192),1,211,222,222);
    ui_label(LCD_X(790),LCD_Y(370),LCD_X(192),1,94,112,119,"触摸连接");
    ui_label(LCD_X(790),LCD_Y(397),LCD_X(192),1,touch_seen?25:162,touch_seen?120:101,touch_seen?111:24,
             touch_seen?"触摸已连接":"等待触摸");
    p_rect(LCD_X(790),LCD_Y(432),LCD_X(192),1,211,222,222);
    ui_label(LCD_X(790),LCD_Y(454),LCD_X(192),1,94,112,119,PL_CONTROL_ENABLE?"识别状态":"静息门控");
    ui_label(LCD_X(790),LCD_Y(481),LCD_X(192),1,31,49,58,ui_preview_cls>=0?"动作预览":hand_source_hdc?
        !virtual_frame_ready || display_cls==UINT32_MAX?hdc_status_label():
        !virtual_frame_mapped?"虚拟姿态未映射":"HDC识别跟随":pl_control_status_label(gated));

    p_rect(0,LCD_Y(526),LCD_W,1,232,239,239);
    for(i=0;i<POSE_MODEL_CLASSES;i++)
        ui_button(LCD_X(24)+(i32)i*LCD_X(190),LCD_Y(535),LCD_X(160),LCD_Y(40),lcd_pose_names[i],i==display_cls);
}

static void lcd_render_pose(u32 cls,u32 conf,u32 fatigue,u32 gated,u32 full)
{
    lcd_render_pose_content(cls,conf,fatigue,gated,full);
    /* Navigation can replace a button immediately. Preserve a short contact
     * ring on the destination frame as acknowledgement of that tap. */
    if(ui_feedback_active && ui_feedback_owner!=ui_page_owner()) {
        lcd_point p={(i32)ui_feedback_x,(i32)ui_feedback_y};
        p_disc(p,LCD_S(7),38,204,164);p_disc(p,LCD_S(3),255,255,255);
    }
}

/* n counts state updates; last/max measure draw-list build to presentation
 * request, including scheduling and waiting for the preceding park request.
 * These are runtime diagnostics, not measured display latency or frame rate.
 * Raster work uses a fresh 2 ms budget per call (see lcd_slice_tick). */

static void lcd_begin_pending(void)
{
    u32 i, full, actual = VDMA_PARK_CURRENT(VDMA_PARKPTR);
    if (!lcd_pending || dl_busy || !lcd_stream_started || !lcd_stream_on) return;
    if (!ui_dirty && gt_stamp() - lcd_last_build_t < ui_refresh_ms * GT_TICKS_PER_MS)
        return;
    if (actual >= 3u) return;       /* unknown scanout ownership: do not paint */
    for (i=0; i<3u; i++)
        if (i != actual && i != lcd_front_index && !hdmi_owns(i)) break;
    if (i == 3u) return;
    dl_back=i;
    full=!lcd_buffer_valid[i] || lcd_buffer_ui[i] != ui_generation;
    dl_ui_generation=ui_generation;
    dl_feedback_serial=ui_feedback_serial;
    lcd_draw_tilt=lcd_state_tilt; lcd_draw_shift=lcd_state_shift;
    if (!lcd_wave_view && !lcd_data_view && !lcd_spectrum_view && !lcd_synergy_view && !lcd_sd_view && !lcd_settings_view && !lcd_rehab_view && !lcd_selfcal_view && !lcd_hdc_view && !lcd_hand_view) {
        lcd_virtual_sample();
        lcd_hand_snapshot();
    }
    dl_len=dl_i=dl_trunc=dl_clean_y=0u;
    dl_fb=lcd_framebuffer(i);
    dl_t_req=lcd_last_build_t=gt_stamp();
    dl_mode=1u;
    lcd_render_pose(lcd_state_cls,lcd_state_conf,lcd_state_fatigue,lcd_state_gated,full);
    dl_mode=0u;
    lcd_pending=ui_dirty=0u;
    if (dl_trunc) {
        lcd_overflow_cnt++;
        lcd_buffer_valid[i]=0u;
        lcd_pending=ui_dirty=1u;
        return;                    /* an incomplete list is never presented */
    }
    dl_busy=1u;
}

static void lcd_show_state(u32 cls, u32 conf, u32 fatigue, u32 gated,
                           i32 tilt, i32 shift)
{
    u32 i;
    if (LCD_ENABLE == 0u || lcd_frozen) return;
    if (!ui_dirty && lcd_state_valid && cls==lcd_state_cls && conf==lcd_state_conf &&
        fatigue==lcd_state_fatigue && fat_full==lcd_state_fatigue_ready && gated==lcd_state_gated &&
        tilt==lcd_state_tilt && shift==lcd_state_shift &&
        lcd_state_imu_generation==lcd_imu_generation) return;
    lcd_state_cls=cls; lcd_state_conf=conf; lcd_state_fatigue=fatigue;
    lcd_state_fatigue_ready=fat_full;
    lcd_state_gated=gated; lcd_state_tilt=tilt; lcd_state_shift=shift;
    lcd_state_imu_generation=lcd_imu_generation;
    lcd_state_valid=1u;
    lcd_redraw_cnt++;
    if (!lcd_stream_started) {
        lcd_draw_tilt=tilt; lcd_draw_shift=shift;
        if (!lcd_wave_view && !lcd_data_view && !lcd_spectrum_view && !lcd_synergy_view && !lcd_sd_view && !lcd_settings_view && !lcd_rehab_view && !lcd_selfcal_view && !lcd_hdc_view && !lcd_hand_view) {
            lcd_virtual_sample();
            lcd_hand_snapshot();
        }
        for (i=0; i<3u; i++) {
            dl_fb_now=lcd_framebuffer(i);
            lcd_render_pose(cls,conf,fatigue,gated,1u);
            display_memory_clean((uintptr_t)dl_fb_now,FB_BYTES);
            lcd_buffer_ui[i]=ui_generation; lcd_buffer_valid[i]=1u;
        }
        return;
    }
    if (lcd_pending) lcd_coalesced_cnt++;
    lcd_pending=1u;
}

/* Runtime VDMA gate ('l' command): the LCD MM2S continuously reads
 * ~150 MB/s from DDR on the same HP0 port the EMG S2MM uses.  Toggling it
 * off while watching [STAT] gaps is the A/B test for DDR-arbitration loss
 * on the PL raw path. */
static void lcd_enable(u32 on)
{
    if (LCD_ENABLE == 0u)
        return;                     /* build has no LCD: 'l' is inert */
    if (on) {
        u32 spins = 0;
        while (!(VDMA_DMASR & VDMA_DMASR_HALTED))    /* wait graceful stop */
            if (++spins > 1000000u)
                break;
        VDMA_DMACR = VDMA_DMACR_RS;                   /* park mode: RS only */
        VDMA_VSIZE = (u32)LCD_H;                      /* VSIZE last: re-arms
                                                       * channel (a bare RS write
                                                       * never restarts a halted
                                                       * channel) */
        hdmi_init();
    } else {
        hdmi_stop();
        VDMA_DMACR = 0u;                        /* halt MM2S, free DDR */
    }
    lcd_stream_on = on;
}

/* Read the PL-latched panel id (axi_gpio_0 channel 2) and size the
 * framebuffer.  The PL already selected the pixel clock + timing from the
 * same id; this only mirrors the choice into the drawing/VDMA side. */
static void lcd_panel_detect(void)
{
    u32 id = 0u;
    u32 wait;

    /* The PL samples the panel ID after MMCM lock and a 20 ms settle
     * interval.  Do not size the framebuffer from the reset value read
     * during that window. */
    for (wait = 0; wait < 2000000u; wait++) {
        id = GPIO_ID;
        if (id == 0x4384u || id == 0x7016u)
            break;
    }

    if (id == 0x7016u) {
        lcd_w = 1024;
        lcd_h = 600;
    } else {
        lcd_w = 800;                    /* 0x4384 or unknown: PL default */
        lcd_h = 480;
        id = (id == 0x4384u) ? id : 0u;
    }
    fb_bpl   = (u32)lcd_w * 3u;
    fb_bytes = fb_bpl * (u32)lcd_h;
    g_tx_data = 1u;             /* boot diag: print even in quiet mode */
    uprintf("[LCD] id=0x%x panel=%ux%u\n", id, (u32)lcd_w, (u32)lcd_h, 0);
    g_tx_data = 0u;
}

static void lcd_init(void)
{
    u32 spins = 0;

    if (LCD_ENABLE == 0u)
        return;                     /* A/B test build: VDMA + backlight stay off */
    lcd_panel_detect();
    lcd_show_state(0, 0, 0, 0, mpu_tilt_q, mpu_shift_q);
    GPIO_BL = 1;                                /* backlight on */

    VDMA_DMACR = VDMA_DMACR_RESET;              /* soft-reset MM2S */
    while (!(VDMA_DMASR & VDMA_DMASR_HALTED))
        if (++spins > 1000000u)
            break;                              /* never halted: say so */
    /* FRMSTORE write removed (fix-16): v6.3 FRMSTORE is a read-only config
     * echo - always reads 0 here; Tail/Park mode reloads the frame number
     * from PARKPTR at every fsync, so frame-store counting is unused. */
    VDMA_HSIZE    = FB_BPL;
    VDMA_STRIDE   = FB_BPL;                     /* packed frames */
    VDMA_START(0) = FB_BASE;
    VDMA_START(1) = FB_BASE + FB_BYTES;
    VDMA_START(2) = FB_BASE + 2u * FB_BYTES;
    VDMA_PARKPTR  = 0;                          /* display frame 0 (boot art) */
    VDMA_DMACR    = VDMA_DMACR_RS;             /* park mode: RS only, bit1=0
                                                 * (TAIL_EN would select circular
                                                 * rotation and void PARKPTR) */
    VDMA_VSIZE    = LCD_H;                      /* VSIZE LAST: arms the channel
                                                 * (xaxivdma_channel.c: CR|=RS then
                                                 * "Update vsize to start the channel";
                                                 * reverse order never leaves FSM
                                                 * idle - white-screen root cause) */
    lcd_stream_started = 1u;
    lcd_stream_on = 1u;
    hdmi_init();
    lcd_frozen = (LCD_ENABLE == 2u);   /* mode 2: boot frame stays, redraws out */

    for (spins = 0; spins < 1000u; spins++)     /* let RS propagate */
        ;
    g_tx_data = 1u;             /* boot diag: print even in quiet mode */
    uprintf("[LCD] virtual-hand parkptr=%u dmasr=%x\n",
            VDMA_PARKPTR & 0x1Fu, VDMA_DMASR, 0, 0);
    g_tx_data = 0u;
}

/* ---- Packet parsing ---------------------------------------------------- */


static const char *const feat_names[5] = {
    "MAV", "WL", "ENERGY", "ZC", "SSC"
};

static u32 raw_cnt, feat_cnt, res_cnt, fat_cnt, other_cnt;
static u32 raw_latest[8];
#define SD_PAIR_SLOTS 64u
typedef struct {
    u16 seq;
    u8 valid, raw_mask, notch_mask, action, complete;
    i32 raw[8], notch[8];
} sd_pair_slot_t;
static sd_pair_slot_t sd_pair[SD_PAIR_SLOTS];
static u32 sd_refresh_t;
static void sd_pair_reset(void)
{
    u32 i;
    for (i=0u;i<SD_PAIR_SLOTS;i++) sd_pair[i].valid=0u;
}

static void sd_pair_packet(u32 payload,u32 hdr)
{
    u32 type=hdr>>28, ch=(hdr>>24)&15u;
    u16 seq=(u16)hdr;
    sd_pair_slot_t *s;
    if (!sd_record_active() || ch>=8u || ((hdr>>16)&255u)!=0u ||
        (type!=1u && type!=5u)) return;
    s=&sd_pair[seq&(SD_PAIR_SLOTS-1u)];
    if (!s->valid || s->seq!=seq) {
        if (s->valid && (s->raw_mask!=0xFFu || s->notch_mask!=0xFFu))
            sd_pair_dropped++;
        s->seq=seq;
        s->valid=1u;
        s->raw_mask=s->notch_mask=0u;
        s->action=(u8)(dma_running?sd_parse_label:lcd_action_label); s->complete=0u;
    }
    if (s->complete) return;
    if (type==1u) {
        s->raw[ch]=(i32)(payload<<8)>>8;
        s->raw_mask|=(u8)(1u<<ch);
    } else {
        s->notch[ch]=(i32)(payload<<8)>>8;
        s->notch_mask|=(u8)(1u<<ch);
    }
    if (s->raw_mask==0xFFu && s->notch_mask==0xFFu) {
        if (!sd_record_append(seq,s->action,s->raw,s->notch))
            sd_pair_dropped++;
        if (!sd_record_active()) { ui_generation++; lcd_pending=1u; }
        s->complete=1u;
        if (lcd_sd_view && gt_stamp()-sd_refresh_t>=200u*GT_TICKS_PER_MS) {
            sd_refresh_t=gt_stamp(); lcd_pending=1u;
        }
    }
}
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
#define SPEC_BAND_COUNT 30u
#define SPEC_LEVEL_MAX  31u
static u32 spec_band[SPEC_BAND_COUNT]; /* ids 10..14: 30 log-power bands */
static u32 pl_spec_peak_bin;           /* id 15: PL aggregate metric */
static u32 spec_peak_power;
static u32 spec_peak_bin;              /* selected channel PS FFT */
static u32 spec_valid;
/* The LCD scope uses a PS-side FFT of the selected final processed channel. */
#define SPEC_FFT_N 2048u
#define SPEC_BIN_FIRST 11u
#define SPEC_BIN_LAST 230u
#define SPEC_BIN_COUNT (SPEC_BIN_LAST - SPEC_BIN_FIRST + 1u)
static u8 spec_nonzero[SPEC_BIN_COUNT];
static u32 spec_has_signal, spec_frame_t;
static i32 spec_samples[SPEC_FFT_N];
static i32 spec_fft_re[SPEC_FFT_N], spec_fft_im[SPEC_FFT_N];
static u16 spec_bin_log[SPEC_BIN_COUNT];
static u32 spec_sample_count, spec_sample_write, spec_sample_seq_valid;
static u16 spec_sample_seq;
static u32 spec_max_level, spec_saturated;
static u32 spec_update_count, spec_fft_busy;
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
static u32 pose_uncertain_count;
static u32 pose_observe_seen;
static u16 pose_observe_seq;
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
 * rest before the R row goes out (flagged g=1). In the PL-control build,
 * this PS baseline is a telemetry mirror for display/reporting only. */
#define CAL_DISCARD_WIN 80u    /* ~2 s of windows dropped (40 win/s) */
#define CAL_WINDOWS     16u    /* windows averaged into the baseline */
#define CAL_FLOOR       1000u  /* only binds for stuck-at-zero channels */

/* 0=discard 1=collect 2=active */
static u32 cal_discard, cal_n;
static u32 cal_baseline_stage;
static u32 cal_sum[8];
static u32 cal_base[8];        /* per-channel rest MAV baseline m0[ch] */
static u32 cal_thr[8];         /* per-channel action threshold */
static u32 gated_rows;         /* R rows re-classified by the gate */

static void cal_start(void)
{
    u32 ch;
    hdc_interrupt(&hdc);
    pose_pending_count = pose_uncertain_count = pose_observe_seen = 0u;
    pose_active_cls = pose_active_conf = pose_active_gated = 0u;
    cal_stage = 0;
    cal_baseline_stage = 0;
    cal_discard = 0;
    cal_n = 0;
    for (ch = 0; ch < 8; ch++)
        cal_sum[ch] = 0;
    pl_control_request(selfcal.state==3u?selfcal.applied_shift:0u,1u);
    uart_puts("[CAL] calibrating - stay relaxed (~2.4 s)\n");
}

/* Called once per completed feature window (MAVs of that window are in
 * feat_mav[] at this point). */
static void cal_on_window(void)
{
    u32 ch;
    u32 stage=PL_CONTROL_ENABLE?cal_baseline_stage:cal_stage;
    if (stage == 0u) {
        if (++cal_discard >= CAL_DISCARD_WIN) {
            stage = 1u;
            cal_n = 0;
            for (ch = 0; ch < 8; ch++)
                cal_sum[ch] = 0;
        }
    } else if (stage == 1u) {
        for (ch = 0; ch < 8; ch++)
            cal_sum[ch] += feat_mav[ch];
        if (++cal_n >= CAL_WINDOWS) {
            for (ch = 0; ch < 8; ch++) {
                cal_base[ch] = cal_sum[ch] >> 4;      /* / CAL_WINDOWS */
                cal_thr[ch] = 3u * cal_base[ch];
                if (cal_thr[ch] < CAL_FLOOR)
                    cal_thr[ch] = CAL_FLOOR;
            }
            stage = 2u;
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
    cal_baseline_stage=stage;
    if(!PL_CONTROL_ENABLE)cal_stage=stage;
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

#include "lcd_rehab.h"

/* ---- LCD live data analysis ------------------------------------------ */

static void lcd_analysis_label(char *dst, u32 cap, const char *prefix,
                               u32 value, const char *suffix)
{
    char digits[11];
    u32 n = 0u, i, v = value;
    if (!cap) return;
    while (*prefix && n + 1u < cap) dst[n++] = *prefix++;
    i = 0u;
    do {
        digits[i] = (char)('0' + v % 10u);
        v /= 10u;
        i++;
    } while (v && i < sizeof digits);
    while (i && n + 1u < cap) dst[n++] = digits[--i];
    while (*suffix && n + 1u < cap) dst[n++] = *suffix++;
    dst[n] = '\0';
}

static void lcd_analysis_percent_bp(char *dst,u32 cap,const char *prefix,u32 bp)
{
    char fraction[16];u32 n=0u,i=0u;
    if(!cap)return;
    lcd_analysis_label(dst,cap,prefix,bp/100u,".");
    lcd_analysis_label(fraction,sizeof fraction,bp%100u<10u?"0":"",bp%100u,"%");
    while(n+1u<cap && dst[n])n++;
    while(fraction[i] && n+1u<cap)dst[n++]=fraction[i++];
    dst[n]=0;
}

static void lcd_analysis_label_signed(char *dst, u32 cap, const char *prefix,
                                      i32 value, const char *suffix)
{
    u32 n = 0u;
    if (!cap) return;
    while (*prefix && n + 1u < cap) dst[n++] = *prefix++;
    if (value < 0 && n + 1u < cap) {
        dst[n++] = '-';
        value = (i32)(0u - (u32)value);
    }
    {
        char digits[11];
        u32 i = 0u, v = (u32)value;
        do {
            digits[i++] = (char)('0' + v % 10u);
            v /= 10u;
        } while (v && i < sizeof digits);
        while (i && n + 1u < cap) dst[n++] = digits[--i];
    }
    while (*suffix && n + 1u < cap) dst[n++] = *suffix++;
    dst[n] = '\0';
}

static u32 lcd_analysis_percent(u32 value, u32 denom)
{
    uint64_t scaled;
    if (!denom) return 0u;
    scaled = ((uint64_t)value * 100u) / denom;
    return scaled > 100u ? 100u : (u32)scaled;
}

static u32 lcd_analysis_hit(u32 x, u32 y, i32 bx, i32 by, i32 bw, i32 bh)
{
    return (i32)x >= bx && (i32)x < bx + bw &&
           (i32)y >= by && (i32)y < by + bh;
}

#include "lcd_channel_quality.h"
#include "lcd_hdc.h"
#include "lcd_hand.h"
#include "lcd_virtual.h"
#include "lcd_hdc_models.h"

static u32 lcd_analysis_touch(u32 x, u32 y)
{
    if (lcd_quality_view) return lcd_quality_touch(x,y);
    if (lcd_analysis_hit(x,y,LCD_X(825),LCD_Y(96),LCD_X(170),LCD_Y(38))) {
        lcd_quality_view=1u;lcd_analysis_changed();return 1u;
    }
    u32 ch;
    for (ch = 0u; ch < 8u; ch++) {
        i32 col = (i32)(ch / 4u), row = (i32)(ch % 4u);
        i32 bx = LCD_X(28) + col * LCD_X(500);
        i32 by = LCD_Y(130) + row * LCD_Y(78);
        if (lcd_analysis_hit(x, y, bx, by, LCD_X(470), LCD_Y(64))) {
            if (lcd_analysis_focus!=ch) {
                spec_sample_count=spec_sample_write=spec_sample_seq_valid=0u;
                spec_valid=0u;
            }
            lcd_analysis_focus = ch;
            lcd_analysis_changed();
            return 1u;
        }
    }
    return 0u;
}

static void lcd_analysis_render(void)
{
    if (lcd_quality_view) {lcd_quality_render();return;}
    static const u8 white[3] = {238,243,250};
    static const u8 muted[3] = {140,153,170};
    static const u8 cyan[3] = {89,190,220};
    static const u8 green[3] = {89,220,170};
    static const u8 warn[3] = {230,202,70};
    static const u8 bad[3] = {255,120,90};
    char label[48];
    u32 ch, max_mav = 1u, outliers = 0u;
    i32 heading_baseline=LCD_Y(102)+lcd_text_baseline(2);
    const char *quality;

    for (ch = 0u; ch < 8u; ch++) {
        if (feat_mav[ch] > max_mav) max_mav = feat_mav[ch];
        outliers += raw_outlier[ch];
    }
    quality = !feat_rows ? "等待数据" :
              (raw_gap_cnt || feature_gap_cnt || outliers) ? "数据需检查" : "数据正常";

    ui_label_baseline(LCD_X(28),heading_baseline,LCD_X(290),2,white[0],white[1],white[2],
           "肌电分析");
    ui_label_baseline(LCD_X(330),heading_baseline,LCD_X(350),1,muted[0],muted[1],muted[2],
           "实时MAV / 8通道");
    ui_button(LCD_X(825),LCD_Y(96),LCD_X(170),LCD_Y(38),"通道检查",0u);

    for (ch = 0u; ch < 8u; ch++) {
        i32 col = (i32)(ch / 4u), row = (i32)(ch % 4u);
        i32 bx = LCD_X(28) + col * LCD_X(500);
        i32 by = LCD_Y(130) + row * LCD_Y(78);
        u32 threshold = (cal_stage == 2u && cal_thr[ch]) ?
                        cal_thr[ch] : max_mav;
        u32 pct = lcd_analysis_percent(feat_mav[ch], threshold);
        u32 active_ch = cal_stage == 2u && feat_mav[ch] >= cal_thr[ch];
        u8 br = active_ch ? warn[0] : cyan[0];
        u8 bg = active_ch ? warn[1] : cyan[1];
        u8 bb = active_ch ? warn[2] : cyan[2];

        p_round_rect(bx, by, LCD_X(470), LCD_Y(64), LCD_S(7),
                     ch == lcd_analysis_focus ? 45 : 30,
                     ch == lcd_analysis_focus ? 66 : 42,
                     ch == lcd_analysis_focus ? 84 : 58);
        lcd_analysis_label(label, sizeof label, "通道", ch + 1u, "");
        p_text(bx + LCD_X(14), by + LCD_Y(9), 2, white[0], white[1], white[2],
               label);
        p_rect(bx + LCD_X(86), by + LCD_Y(15), LCD_X(218), LCD_Y(14),
               16, 24, 36);
        if (pct)
            p_rect(bx + LCD_X(86), by + LCD_Y(15),
                   (i32)((uint64_t)LCD_X(218) * pct / 100u), LCD_Y(14),
                   br, bg, bb);
        lcd_analysis_label(label, sizeof label, "", feat_mav[ch], "");
        ui_label(bx+LCD_X(320),by+LCD_Y(9),LCD_X(140),2,white[0],white[1],white[2],label);
        lcd_analysis_label_signed(label, sizeof label, "原始 ",
                                  (i32)raw_latest[ch], "");
        ui_label(bx+LCD_X(14),by+LCD_Y(40),LCD_X(200),2,muted[0],muted[1],muted[2],label);
        lcd_analysis_label(label, sizeof label, "阈值 ", threshold, "");
        ui_label(bx+LCD_X(216),by+LCD_Y(40),LCD_X(160),2,muted[0],muted[1],muted[2],label);
        lcd_analysis_label(label, sizeof label, " ", pct, "%");
        ui_label(bx+LCD_X(376),by+LCD_Y(40),LCD_X(84),2,br,bg,bb,label);
        ui_button_press_border(bx,by,LCD_X(470),LCD_Y(64));
    }

    p_rect(LCD_X(28),LCD_Y(454),LCD_X(968),LCD_Y(115),25,34,48);
    ui_label_baseline(LCD_X(44),LCD_Y(466)+lcd_text_baseline(2),LCD_X(140),1,cyan[0],cyan[1],cyan[2],
             lcd_pose_names[lcd_state_cls<POSE_MODEL_CLASSES?lcd_state_cls:0u]);
        lcd_analysis_label(label,sizeof label,"置信度 ",lcd_state_conf,"%");
    ui_label(LCD_X(200),LCD_Y(466),LCD_X(190),2,muted[0],muted[1],muted[2],label);
    ui_label(LCD_X(420),LCD_Y(466),LCD_X(220),2,muted[0],muted[1],muted[2],lcd_state_gated?"门控已启":"门控关闭");
    lcd_analysis_label(label,sizeof label,"MDF ",(fat_mdf*4000u+1024u)/2048u," Hz");
    ui_label(LCD_X(690),LCD_Y(466),LCD_X(290),2,muted[0],muted[1],muted[2],label);
    lcd_analysis_label(label,sizeof label,"原始缺帧 ",raw_gap_cnt,"");
    ui_label(LCD_X(44),LCD_Y(503),LCD_X(350),2,warn[0],warn[1],warn[2],label);
    lcd_analysis_label(label,sizeof label,"特征缺帧 ",feature_gap_cnt,"");
    ui_label(LCD_X(420),LCD_Y(503),LCD_X(230),2,muted[0],muted[1],muted[2],label);
    {
        u32 quality_ok = feat_rows && !raw_gap_cnt && !feature_gap_cnt && !outliers;
        u32 quality_wait = !feat_rows;
        const u8 *quality_color = quality_ok ? green : quality_wait ? muted : warn;
        ui_label(LCD_X(690),LCD_Y(503),LCD_X(290),2,
                 quality_color[0],quality_color[1],quality_color[2],quality);
    }
    lcd_analysis_label(label,sizeof label,"异常值 ",outliers,"");
    ui_label(LCD_X(44),LCD_Y(538),LCD_X(350),2,muted[0],muted[1],muted[2],label);
    if(fat_full)lcd_analysis_label(label,sizeof label,"疲劳等级 ",fat_level,"");
    ui_label(LCD_X(420),LCD_Y(538),LCD_X(230),2,fat_full&&fat_level>=2u?bad[0]:green[0],
             fat_full&&fat_level>=2u?bad[1]:green[1],fat_full&&fat_level>=2u?bad[2]:green[2],fat_full?label:"疲劳待评估");
    ui_label(LCD_X(690),LCD_Y(538),LCD_X(290),2,muted[0],muted[1],muted[2],fat_full?"疲劳分析就绪":"保持动作分析");
}

static void synergy_on_window(const u32 e[8],u16 seq)
{
    u32 j,now=gt_stamp();
    if(synergy_seq_seen && ((u16)(seq-synergy_last_seq)!=40u ||
       now-synergy_last_t>500u*GT_TICKS_PER_MS)) {
        synergy_nmf_reset(&synergy_nmf);
        synergy_history_write=synergy_history_count=synergy_history_hop=0u;
    }
    synergy_seq_seen=1u;synergy_last_seq=seq;synergy_last_t=now;synergy_stale_reported=0u;
    synergy_nmf_step(&synergy_nmf,e);
    if(!synergy_nmf.valid)return;
    synergy_feedback_step(&synergy_feedback,synergy_nmf.c,seq,rehab_milliseconds());
    if(++synergy_history_hop>=4u) {
        synergy_history_hop=0u;
        for(j=0u;j<SYNERGY_N;j++)
            synergy_history[synergy_history_write][j]=(u8)(
                (uint64_t)synergy_feedback.smooth[j]*100u/synergy_display_ref[j]>100u?100u:
                (uint64_t)synergy_feedback.smooth[j]*100u/synergy_display_ref[j]);
        synergy_history_write=(synergy_history_write+1u)%SYNERGY_HISTORY_N;
        if(synergy_history_count<SYNERGY_HISTORY_N)synergy_history_count++;
    }
}

static void lcd_synergy_render(void)
{
    static const u8 white[3]={31,49,58}, muted[3]={94,112,119};
    static const u8 col[SYNERGY_N][3]={{36,139,168},{214,139,48},{117,105,184}};
    static const char *const names[SYNERGY_N]={"协同 1","协同 2","协同 3"};
    char label[64];u32 j,i;
    u32 stale=!synergy_nmf.valid || gt_stamp()-synergy_last_t>500u*GT_TICKS_PER_MS;
    p_rect(0,LCD_Y(92),LCD_W,LCD_H-LCD_Y(92),248,250,250);
    ui_label(LCD_X(36),LCD_Y(108),LCD_X(500),2,white[0],white[1],white[2],"肌电协同活动");
    ui_label(LCD_X(530),LCD_Y(112),LCD_X(450),1,muted[0],muted[1],muted[2],
             stale?"等待监测数据 / 历史保留":"活动条与趋势平滑 / 原始 C 保留");
    lcd_analysis_label(label,sizeof label,"近似偏差 ",synergy_nmf.residual_percent,"%");
    ui_label(LCD_X(74),LCD_Y(345),LCD_X(300),1,muted[0],muted[1],muted[2],label);
    ui_label(LCD_X(490),LCD_Y(345),LCD_X(460),1,muted[0],muted[1],muted[2],"偏差高表示基底近似不足");
    for(j=0u;j<SYNERGY_N;j++) {
        u32 pct=(u32)((uint64_t)synergy_feedback.smooth[j]*100u/synergy_display_ref[j]);
        if(pct>100u)pct=100u;
        i32 by=LCD_Y(158)+(i32)j*LCD_Y(62);
        p_round_rect(LCD_X(54),by,LCD_X(900),LCD_Y(54),LCD_S(8),255,255,255);
        ui_label(LCD_X(76),by+LCD_Y(12),LCD_X(140),2,white[0],white[1],white[2],names[j]);
        p_rect(LCD_X(220),by+LCD_Y(18),LCD_X(400),LCD_Y(18),230,235,237);
        if(synergy_nmf.valid && pct)
            p_round_rect(LCD_X(220),by+LCD_Y(18),
                         (i32)((uint64_t)LCD_X(400)*pct/100u),LCD_Y(18),
                         LCD_S(5),col[j][0],col[j][1],col[j][2]);
        lcd_analysis_label(label,sizeof label,"C=",synergy_nmf.valid?(synergy_nmf.c[j]+128u)>>8:0u,"");
        ui_label(LCD_X(638),by+LCD_Y(5),LCD_X(300),1,white[0],white[1],white[2],label);
        lcd_analysis_label(label,sizeof label,"平滑 ",(synergy_feedback.smooth[j]+128u)>>8,
                           synergy_feedback.smooth[j]>synergy_display_ref[j]?" 超参考":"");
        ui_label(LCD_X(638),by+LCD_Y(29),LCD_X(310),1,muted[0],muted[1],muted[2],label);
    }
    p_rect(LCD_X(82),LCD_Y(378),LCD_X(842),LCD_Y(108),255,255,255);
    for(i=0u;i<3u;i++)p_rect(LCD_X(82),LCD_Y(378)+(i32)i*LCD_Y(54),LCD_X(842),LCD_S(1),215,224,227);
    for(j=0u;j<SYNERGY_N;j++)for(i=1u;i<synergy_history_count;i++) {
        u32 oldest=(synergy_history_write+SYNERGY_HISTORY_N-synergy_history_count)%SYNERGY_HISTORY_N;
        u32 a=(oldest+i-1u)%SYNERGY_HISTORY_N,b=(oldest+i)%SYNERGY_HISTORY_N;
        i32 x0=LCD_X(82)+(i32)(SYNERGY_HISTORY_N-synergy_history_count+i-1u)*LCD_X(842)/99;
        i32 x1=LCD_X(82)+(i32)(SYNERGY_HISTORY_N-synergy_history_count+i)*LCD_X(842)/99;
        i32 y0=LCD_Y(486)-(i32)synergy_history[a][j]*LCD_Y(108)/100;
        i32 y1=LCD_Y(486)-(i32)synergy_history[b][j]*LCD_Y(108)/100;
        if(dl_mode)dl_push(8,x0,y0,x1,y1,0,DL_RGB(col[j][0],col[j][1],col[j][2]),(const char *)0);
        else lcd_wave_line(dl_fb_now,x0,y0,x1,y1,col[j][0],col[j][1],col[j][2]);
    }
    ui_label(LCD_X(82),LCD_Y(493),LCD_X(400),1,muted[0],muted[1],muted[2],"最近 10 s / 平滑活动趋势");
    ui_label(LCD_X(560),LCD_Y(493),LCD_X(390),1,muted[0],muted[1],muted[2],"超参考时到顶 / 数值保留");
    ui_label(LCD_X(74),LCD_Y(534),LCD_X(390),1,muted[0],muted[1],muted[2],"参考 EMG008/009");
    ui_label(LCD_X(530),LCD_Y(534),LCD_X(440),1,muted[0],muted[1],muted[2],"C 为相对系数，不代表力量");
    ui_label(LCD_X(74),LCD_Y(563),LCD_X(390),1,muted[0],muted[1],muted[2],"换佩戴需验证 / MLP 识别");
    ui_label(LCD_X(530),LCD_Y(563),LCD_X(440),1,muted[0],muted[1],muted[2],"顶部切换：数据 / 频谱 / 协同");
}

static void spec_sincos_q15(u32 phase, i32 *co, i32 *si)
{
    static const short atan_turn_q16[15] = {
        8192,4836,2555,1297,651,326,163,81,41,20,10,5,3,1,1
    };
    i32 z=(i32)(phase & 0xFFFFu), x=19898, y=0, csign=1;
    u32 i;
    if (z > 32768) z -= 65536;
    if (z > 16384) { z=32768-z; csign=-1; }
    else if (z < -16384) { z=-32768-z; csign=-1; }
    for (i=0u;i<15u;i++) {
        i32 xs=x, ys=y;
        if (z >= 0) {
            x=xs-(ys>>i); y=ys+(xs>>i); z-=atan_turn_q16[i];
        } else {
            x=xs+(ys>>i); y=ys-(xs>>i); z+=atan_turn_q16[i];
        }
    }
    *co=x*csign; *si=y;
}

static u16 spec_log2_power_q8(u32 value)
{
    u32 exponent=0u, i, original=value, frac=0u;
    uint64_t x;
    if (!value) return 0u;
    while (value >= 2u) { value >>= 1; exponent++; }
    x=(uint64_t)original << (31u-exponent);
    for (i=0u;i<8u;i++) {
        x=(x*x)>>31;
        if (x >= ((uint64_t)2u<<31)) {
            x >>= 1;
            frac |= 1u << (7u-i);
        }
    }
    return (u16)((exponent << 8) | frac);
}

static void lcd_spectrum_fft(void)
{
    i32 mean=0, peak=0, wc, ws, wr, wi;
    i32 left=0;
    u32 i,j,len,shift=0u, max_log=0u, max_power=0u;
    if (spec_fft_busy) return;
    spec_fft_busy=1u;
    {
        int64_t signed_sum=0;
        for (i=0u;i<SPEC_FFT_N;i++) signed_sum+=spec_samples[i];
        mean=(i32)(signed_sum/(i32)SPEC_FFT_N);
    }
    for (i=0u;i<SPEC_FFT_N;i++) {
        i32 centered=spec_samples[i]-mean;
        i32 a=centered<0 ? -centered : centered;
        if (a>peak) peak=a;
    }
    while ((peak>>shift)>16383 && shift<15u) shift++;
    if (peak) while (((u32)peak<<left)<8192u) left++;

    /* Direct Hann coefficients avoid fixed-point oscillator drift. Scale
     * small inputs up before the /2 FFT stages to retain small signals. */
    for (i=0u;i<SPEC_FFT_N;i++) {
        i32 centered=((spec_samples[i]-mean)*(1<<left))>>shift;
        i32 co,si,hann;
        spec_sincos_q15((i*65536u)/(SPEC_FFT_N-1u),&co,&si);
        if (co>32767) co=32767;
        if (co< -32767) co=-32767;
        hann=(32767-co)/2;
        spec_fft_re[i]=(centered*hann)>>15;
        spec_fft_im[i]=0;
        if (!(i&63u)) acquisition_service();
    }

    /* In-place radix-2 DIT. The input is bit-reversed, and every stage is
     * divided by two so all intermediate values stay inside signed Q15. */
    j=0u;
    for (i=1u;i<SPEC_FFT_N;i++) {
        u32 bit=SPEC_FFT_N>>1;
        while (j&bit) { j^=bit; bit>>=1; }
        j^=bit;
        if (i<j) {
            i32 t=spec_fft_re[i]; spec_fft_re[i]=spec_fft_re[j]; spec_fft_re[j]=t;
            t=spec_fft_im[i]; spec_fft_im[i]=spec_fft_im[j]; spec_fft_im[j]=t;
        }
    }
    for (len=2u;len<=SPEC_FFT_N;len<<=1) {
        u32 half=len>>1, step=65536u/len;
        spec_sincos_q15(step,&wc,&ws);
        for (i=0u;i<SPEC_FFT_N;i+=len) {
            wr=32767; wi=0;
            for (j=0u;j<half;j++) {
                u32 a=i+j,b=a+half;
                i32 br=spec_fft_re[b],bi=spec_fft_im[b];
                i32 tr=(i32)(((int64_t)wr*br-(int64_t)wi*bi)>>15);
                i32 ti=(i32)(((int64_t)wr*bi+(int64_t)wi*br)>>15);
                i32 ar=spec_fft_re[a],ai=spec_fft_im[a];
                spec_fft_re[a]=(ar+tr)>>1; spec_fft_im[a]=(ai+ti)>>1;
                spec_fft_re[b]=(ar-tr)>>1; spec_fft_im[b]=(ai-ti)>>1;
                if (!(j&63u)) acquisition_service();
                {
                    i32 next_wr=(i32)(((int64_t)wr*wc-(int64_t)wi*ws)>>15);
                    wi=(i32)(((int64_t)wi*wc+(int64_t)wr*ws)>>15);
                    wr=next_wr;
                }
            }
        }
    }
    for (i=0u;i<SPEC_BIN_COUNT;i++) {
        u32 bin=SPEC_BIN_FIRST+i;
        int64_t re=spec_fft_re[bin], im=spec_fft_im[bin];
        u32 power=(u32)(re*re+im*im);
        u32 logp=spec_log2_power_q8(power);
        spec_bin_log[i]=(u16)logp;
        spec_nonzero[i]=(u8)(power!=0u);
        if (power>max_power) { max_power=power; spec_peak_bin=bin; }
        if (logp>max_log) max_log=logp;
    }
    spec_max_level=max_log;
    spec_has_signal=max_power!=0u;
    if (!spec_has_signal) spec_peak_bin=0u;
    spec_valid=1u;
    spec_frame_t=gt_stamp();
    spec_update_count++;
    spec_fft_busy=0u;
    lcd_analysis_changed();
}

static void lcd_spectrum_ingest(u32 payload,u32 hdr)
{
    u32 ch=(hdr>>24)&15u, type=hdr>>28;
    u16 seq=(u16)hdr;
    u32 delta;
    if(type==5u && ch<8u && ((hdr>>16)&255u)==0u) {
        if(cq_ingest(payload,hdr,gt_stamp())) lcd_analysis_changed();
    }
    if (type!=5u || ch!=lcd_analysis_focus || ((hdr>>16)&255u)!=0u)
        return;
    if (spec_sample_seq_valid) {
        delta=(u16)(seq-spec_sample_seq);
        if (!delta) return;
        if (delta!=1u) {
            spec_sample_count=0u;
            spec_sample_write=0u;
            spec_valid=0u;
        }
    }
    spec_sample_seq=seq;
    spec_sample_seq_valid=1u;
    spec_samples[spec_sample_write]=(i32)(payload<<8)>>8;
    spec_sample_write=(spec_sample_write+1u)&(SPEC_FFT_N-1u);
    if (spec_sample_count<SPEC_FFT_N) spec_sample_count++;
    if (spec_sample_count==SPEC_FFT_N && spec_sample_write==0u) {
        /* A transform runs on each complete, non-overlapping 512 ms frame. */
        lcd_spectrum_fft();
    }
}

static u32 lcd_spectrum_touch(u32 x,u32 y)
{
    u32 ch;
    if ((i32)y < LCD_Y(530) || (i32)y >= LCD_Y(582)) return 0u;
    for (ch=0u;ch<8u;ch++) {
        i32 bx=LCD_X(28)+(i32)ch*LCD_X(122);
        if ((i32)x>=bx && (i32)x<bx+LCD_X(112)) {
            if (lcd_analysis_focus!=ch) {
                lcd_analysis_focus=ch;
                spec_sample_count=spec_sample_write=spec_sample_seq_valid=0u;
                spec_valid=0u;
                lcd_analysis_changed();
            }
            return 1u;
        }
    }
    return 0u;
}

/* The PL also emits compact logarithmic bands for the fatigue dashboard. */
static void lcd_spectrum_render(void)
{
    static const u8 white[3] = {238,243,250};
    static const u8 muted[3] = {140,153,170};
    static const u8 cyan[3] = {89,190,220};
    static const u8 green[3] = {89,220,170};
    static const u8 warn[3] = {230,202,70};
    char label[48];
    u32 i, max_level = 0u, hz;
    i32 chart_x = LCD_X(64), chart_y = LCD_Y(164);
    i32 chart_w = LCD_X(880), chart_h = LCD_Y(270);
    i32 plot_top = chart_y + LCD_Y(10);
    i32 plot_bottom = chart_y + chart_h - LCD_Y(7);
    i32 plot_h = plot_bottom - plot_top;
    u32 display_bins;
    i32 heading_baseline=LCD_Y(102)+lcd_text_baseline(2);
    i32 detail_baseline=LCD_Y(470)+lcd_text_baseline(2);
    i32 source_baseline=LCD_Y(505)+lcd_text_baseline(2);

    display_bins=SPEC_BIN_COUNT;

    ui_label_baseline(LCD_X(28),heading_baseline,LCD_X(220),2,white[0],white[1],white[2],
           "频谱分析");
    ui_label_baseline(LCD_X(260),heading_baseline,LCD_X(430),1,muted[0],muted[1],muted[2],
           "通道FFT / 2048点 / 4000 SPS");
    ui_label_baseline(LCD_X(700),heading_baseline,LCD_X(296),1,
           spec_valid ? green[0] : warn[0],
           spec_valid ? green[1] : warn[1],
           spec_valid ? green[2] : warn[2],
           spec_valid ? (spec_has_signal?"实时512 ms":"无有效信号") : "等待FFT");

    for (i=0u;i<SPEC_BIN_COUNT;i++)
        if (spec_bin_log[i]>max_level) max_level=spec_bin_log[i];
    spec_max_level=max_level;
    spec_saturated=0u;
    p_rect(chart_x, chart_y, chart_w, chart_h, 22, 30, 45);
    p_text(LCD_X(10),LCD_Y(145),2,muted[0],muted[1],muted[2],"dB");
    /* Normalize each frame to its strongest bin over a 60 dB display range. */
    for (i = 0u; i <= 4u; i++) {
        i32 db=-(i32)i*15;
        i32 gy=plot_bottom-(i32)((uint64_t)(4u-i)*plot_h*9u/40u);
        if(ui_grid_enabled || i==4u) p_rect(chart_x, gy, chart_w, LCD_Y(i == 0u ? 2u : 1u),
               i == 4u ? 70 : 42, i == 4u ? 84 : 55,
               i == 4u ? 106 : 70);
        lcd_analysis_label(label,sizeof label,db?"-":"",(u32)(-db),"");
        p_text(chart_x-LCD_X(8)-ui_text_width(label,2), gy-lcd_line_height(2)/2, 2,
               muted[0], muted[1], muted[2], label);
    }
    for (i=0u;i<display_bins;i++) {
        i32 bx=chart_x+(i32)((uint64_t)chart_w*i/display_bins);
        i32 bw=(i32)((uint64_t)chart_w*(i+1u)/display_bins)-
               (i32)((uint64_t)chart_w*i/display_bins)-1;
        if (bw<1) bw=1;
        u32 level=0u;
        if (spec_valid && spec_nonzero[i] && max_level>spec_bin_log[i] &&
            max_level-spec_bin_log[i] < 20u*256u)
            level=20u*256u-(max_level-spec_bin_log[i]);
        else if (spec_valid && spec_nonzero[i] && max_level==spec_bin_log[i]) level=20u*256u;
        {
            i32 bh=(i32)((uint64_t)level*plot_h*9u/(200u*256u));
            if (bh<1 && level) bh=1;
            if (bh)
                p_rect(bx,plot_bottom-bh,bw,bh,cyan[0],cyan[1],cyan[2]);
        }
    }
    p_text(chart_x, chart_y + chart_h + LCD_Y(12), 1,
           muted[0], muted[1], muted[2], "20");
    p_text(chart_x + (i32)((uint64_t)chart_w * 80u / 430u),
           chart_y + chart_h + LCD_Y(12), 1,
           muted[0], muted[1], muted[2], "100");
    p_text(chart_x + (i32)((uint64_t)chart_w * 180u / 430u),
           chart_y + chart_h + LCD_Y(12), 1,
           muted[0], muted[1], muted[2], "200");
    p_text(chart_x + (i32)((uint64_t)chart_w * 280u / 430u),
           chart_y + chart_h + LCD_Y(12), 1,
           muted[0], muted[1], muted[2], "300");
    p_text(chart_x + (i32)((uint64_t)chart_w * 380u / 430u),
           chart_y + chart_h + LCD_Y(12), 1,
           muted[0], muted[1], muted[2], "400");

    hz = (spec_peak_bin * 4000u + 1024u) / 2048u;
    lcd_analysis_label(label, sizeof label, "峰值 ", hz, " Hz");
    ui_label_baseline(LCD_X(28),detail_baseline,LCD_X(220),1,cyan[0],cyan[1],cyan[2],label);
    lcd_analysis_label(label, sizeof label, "全通道MDF ",
                       (fat_mdf * 4000u + 1024u) / 2048u, " Hz");
    ui_label(LCD_X(260),LCD_Y(470),LCD_X(340),2,muted[0],muted[1],muted[2],label);
    lcd_analysis_label(label,sizeof label,"通道",lcd_analysis_focus+1u,"");
    ui_label(LCD_X(620),LCD_Y(505),LCD_X(140),2,green[0],green[1],green[2],label);
    ui_label_baseline(LCD_X(650),detail_baseline,LCD_X(346),1,
           spec_valid ? green[0] : warn[0],
           spec_valid ? green[1] : warn[1],
           spec_valid ? green[2] : warn[2],
           spec_valid ? "自动 60 dB" : "等待 512 ms");
    ui_label_baseline(LCD_X(28),source_baseline,LCD_X(550),1,muted[0],muted[1],muted[2],
           "220频段 / 20-450 Hz");
    ui_label_baseline(LCD_X(760),source_baseline,LCD_X(236),1,muted[0],muted[1],muted[2],
           "全处理");
    for (i=0u;i<8u;i++) {
        i32 bx=LCD_X(28)+(i32)i*LCD_X(122);
        lcd_analysis_label(label,sizeof label,"通道",i+1u,"");
        ui_button(bx,LCD_Y(535),LCD_X(112),LCD_Y(42),label,i==lcd_analysis_focus);
    }
}

/* Model-scaled softmax via Q20 exp lookup. This score is not probability-
 * calibrated. Subtracting the maximum also makes it invariant to logit offset. */
static u32 logit_conf_for(u32 cls)
{
    u32 i, sum = 0u, selected = 0u;
    i32 v, top = (i32)res_logits[0];
    if (cls >= POSE_MODEL_CLASSES) return 0u;
    for (i = 0; i < 5; i++) {
        v = (i32)res_logits[i];
        if (v > top) top = v;
    }
    for (i = 0; i < 5; i++) {
        uint64_t gap = (uint64_t)((int64_t)top - (i32)res_logits[i]);
        uint64_t bin = (gap * NN_CONF_SCALE_Q24 + (1u << 23)) >> 24;
        u32 e = bin <= 256u ? nn_conf_exp[(u32)bin] : 0u;
        sum += e;
        if (i == cls) selected = e;
    }
    return selected * 100u / sum; /* maximum contributes 1<<20, sum != 0 */
}

static u32 logit_conf(void)
{
    u32 i, best = 0u;
    for (i = 1u; i < POSE_MODEL_CLASSES; i++)
        if ((i32)res_logits[i] > (i32)res_logits[best]) best = i;
    return logit_conf_for(best);
}

static void print_pose_value(const char *name, i32 value)
{
    uart_putc(' ');
    uart_puts(name);
    uprintf("=%d", (u32)value, 0, 0, 0);
}

/* Versioned pose output. R remains the compatibility line for old hosts. */
static void print_pose_frame(u32 seq, u32 cls, u32 conf, u32 gated)
{
    u32 i;
    if (cls >= POSE_MODEL_CLASSES)
        cls = 0u;
    uart_putc('P');
    uprintf(" v=1 s=%u schema=%u gid=%u q=%u",
            seq, POSE_SCHEMA_V2, cls, conf);
    uprintf(" mask=0x%x phase=0 stable=1", POSE_VALID_MASK, 0, 0, 0);
    (void)gated; /* cls has already passed the state policy; never gate twice */
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
    pose_uncertain_count = 0;
    print_pose_frame(seq, pose_active_cls, conf, gated);
    lcd_show_state(pose_active_cls, pose_active_conf, fat_level,
                   pose_active_gated, mpu_tilt_q, mpu_shift_q);
}

static void pose_observe(u32 seq, u32 cls, u32 conf, u32 gated)
{
    u32 required = POSE_CONFIRM_WINDOWS;
    u32 target = cls;
    u32 valid = cls < POSE_MODEL_CLASSES;
    if (pose_observe_seen && (u16)(seq - pose_observe_seq) != 40u)
        pose_pending_count = pose_uncertain_count = 0u;
    pose_observe_seq = (u16)seq;
    pose_observe_seen = 1u;

    if (gated) { target = 0u; valid = 1u; }
    else if (cls == 0u) valid = conf >= POSE_HOLD_CONF;
    else if (cls == pose_active_cls) valid = valid && conf >= POSE_HOLD_CONF;
    else valid = valid && conf >= POSE_MIN_CONF;

    if (!valid) {
        pose_pending_count = 0;
        if (++pose_uncertain_count >= POSE_UNCERTAIN_WINDOWS) {
            pose_uncertain_count = POSE_UNCERTAIN_WINDOWS;
            if (pose_active_cls != 0u)
                pose_accept(seq, 0u, logit_conf_for(0u), gated);
        }
    } else {
        if (target == pose_active_cls)
            pose_pending_count = pose_uncertain_count = 0u;
        else {
            if (pose_uncertain_count < POSE_UNCERTAIN_WINDOWS)
                pose_uncertain_count++;
            if (target == 0u) required = POSE_REST_WINDOWS;
            if (target == pose_pending_cls) pose_pending_count++;
            else { pose_pending_cls = target; pose_pending_count = 1u; }
            if (pose_pending_count >= required)
                pose_accept(seq, target, logit_conf_for(target), gated);
            else if (pose_uncertain_count >= POSE_UNCERTAIN_WINDOWS && pose_active_cls != 0u)
                pose_accept(seq, 0u, logit_conf_for(0u), gated);
        }
    }
    /* Refresh support for the displayed class, even when the pose is held. */
    pose_active_conf = logit_conf_for(pose_active_cls);
    pose_active_gated = gated;
    lcd_show_state(pose_active_cls, pose_active_conf, fat_level,
                   pose_active_gated, mpu_tilt_q, mpu_shift_q);
}

/* One line per inference window: 'R s=<seq> c=<class> p=<conf>[ g=1]',
 * plus the raw INT32 logits every 4th window.  The PL INT8 MLP emits six
 * result packets per window (ids 0..4 = logits, 5 = argmax class), all
 * carrying the sequence of the window-start feature packet.  p is the
 * uncalibrated softmax score (see logit_conf); g=1 marks a non-rest decision
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
    rehab_on_result(seq,pose_active_cls,res_cls,
                  logit_conf_for(res_cls<5u?res_cls:0u),gated,cal_stage==2u);
    g_tx_data = 0u;                    /* keep set: nested P row above */
    res_rows++;
}

/* The PL accepted word is authoritative: do not apply PS confidence/gating
 * or a second temporal filter. Old firmware keeps the original path. */
static void pl_control_tick(void)
{
    u32 old_hand=hand_status_word,old_home=hand_home_state,old_step=hand_home_step;
    hand_tick(rehab_milliseconds(),lcd_hand_view && !ui_menu_open && g_mode==MODE_MONITOR,
              imu_hand_rotation_deg,mpu_seen && mpu_zero_valid && imu_hand_rotation_valid &&
              (gt_stamp()-mpu_last_sample_t)<(100u*GT_TICKS_PER_MS));
    /* Transport ACK toggles on keepalives; it is not a visible state change. */
    if(((old_hand^hand_status_word)&~(1u<<23)) || old_home!=hand_home_state || old_step!=hand_home_step)
        lcd_input_status_changed();
#if PL_CONTROL_ENABLE
    u32 previous_ready=pl_control_ready();
    u32 previous_word=pl_control_word;
    pl_control_mailbox_tick();
    if(previous_word!=pl_control_word)lcd_input_status_changed();
    if(pl_control_initialized && !pl_control_inflight && !pl_control_queued)
        cal_stage=pl_control_word&3u;
    if(previous_ready && !pl_control_ready()) {
        pose_active_conf=0u;pose_active_gated=1u;
        lcd_show_state(pose_active_cls,0u,fat_level,1u,mpu_tilt_q,mpu_shift_q);
    }
#endif
}

static void pl_control_result(u32 seq,u32 word)
{
#if PL_CONTROL_ENABLE
    u32 previous=pose_active_cls;
    pl_control_tick();
    if(!pl_control_accept(word))return;
    pose_active_cls=word&7u;pose_active_conf=(word>>3)&127u;
    pose_active_gated=(word>>10)&1u;
    res_cls=(word>>11)&7u;cal_stage=(word>>21)&3u;
    {
        uint32_t c2=0u;
        u32 now=rehab_milliseconds();
        u32 valid=synergy_feedback_find(&synergy_feedback,seq,now,&c2) &&
            synergy_nmf.valid && cal_stage==2u &&
            g_mode==MODE_MONITOR && pl_control_ready();
        if(hand_grip_capturing && synergy_feedback.capture>=2u &&
           synergy_feedback.capture<=3u &&
           (!valid || pose_active_gated || pose_active_cls!=2u || res_cls!=2u)) {
            synergy_feedback.capture=4u;synergy_feedback.reference=0u;
        }
        if(hand_grip_capturing && synergy_feedback.capture==3u)hand_grip_capturing=0u;
        hand_grip_observe(now,(u16)seq,c2,synergy_feedback.reference,
                          !pose_active_gated && res_cls==2u?pose_active_cls:0u,valid);
    }
    if(pose_active_gated)gated_rows++;
    if(g_mode==MODE_MONITOR) {
        g_tx_data=1u;
        uart_putc('R');uprintf(" s=%u c=%u p=%u",seq,res_cls,(word>>14)&127u,0u);
        if(pose_active_gated)uart_puts(" g=1");
        uart_puts("\r\n");
        if(previous!=pose_active_cls)
            print_pose_frame(seq,pose_active_cls,pose_active_conf,pose_active_gated);
        g_tx_data=0u;res_rows++;
    }
    lcd_show_state(pose_active_cls,pose_active_conf,fat_level,pose_active_gated,mpu_tilt_q,mpu_shift_q);
    rehab_on_result(seq,pose_active_cls,res_cls,
                  (word>>14)&127u,pose_active_gated,cal_stage==2u && g_mode==MODE_MONITOR);
#else
    (void)seq;(void)word;
#endif
}

/* One line per fatigue window (id 8+9 pair, ~2/s): 'T s=<seq> lv=<0..3>
 * mdf=<mean MDF bin> n2=<signed slope numerator> full=<hist filled> e=<energy>'.
 * lv is confirmed relative MDF decline within one active bout;
 * n2 remains the 16-point trend diagnostic, not the severity classifier.
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
                   pose_active_gated, mpu_tilt_q, mpu_shift_q);
}

static void print_spectrum_row(u32 seq)
{
    u32 i;
    g_tx_data = 1u;
    uart_putc('S');
    uprintf(" s=%u peak_bin=%u peak_hz=%u", seq, pl_spec_peak_bin,
            (pl_spec_peak_bin * 4000u + 1024u) / 2048u, 0);
    uprintf(" mdf_hz=%u", (fat_mdf * 4000u + 1024u) / 2048u, 0, 0, 0);
    uart_puts(" levels=");
    for (i = 0u; i < 30u; i++) {
        if (i) uart_putc(',');
        print_dec(spec_band[i]);
    }
    uart_puts("\r\n");
    g_tx_data = 0u;
}

static void parse_packet(u32 payload, u32 hdr)
{
    u32 type = hdr >> 28;
    u32 ch   = (hdr >> 24) & 0xFu;
    u32 id   = (hdr >> 20) & 0xFu;
    u32 seq  = hdr & 0xFFFFu;

    switch (type) {
    case 1:                            /* raw sample, 24-bit signed */
        lcd_wave_ingest(payload, hdr);
        sd_pair_packet(payload,hdr);
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
                feature_window_start_seq = (u16)seq;
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
                u32 selfcal_features[40],si;
                feat_win_cnt = 0;
                cal_on_window();          /* rest-calibration window sink */
                for(si=0u;si<40u;si++)
                    selfcal_features[si]=feat_vals[si/8u][si%8u];
                synergy_on_window(feat_mav,feature_window_start_seq);
                hdc_on_window(selfcal_features,feature_window_start_seq);
                if(!PL_CONTROL_ENABLE || selfcal.state!=3u) {
                    if(selfcal_window(&selfcal,selfcal_features)==2u)
                        pl_control_request(selfcal.applied_shift,0u);
                }
                selfcal_latest_seq=feature_window_start_seq;
                if(lcd_selfcal_view)lcd_pending=1u;
                lcd_analysis_changed();   /* refresh live MAV/quality page */
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
            if(!PL_CONTROL_ENABLE && selfcal.state==3u && selfcal.latest_valid &&
               selfcal_latest_seq==(u16)seq) {
                u32 k,best=0u;
                for(k=0u;k<5u;k++)res_logits[k]=selfcal.latest_logits[k];
                for(k=1u;k<5u;k++)
                    if((i32)res_logits[k]>(i32)res_logits[best])best=k;
                res_cls=best;
            }
            if (!PL_CONTROL_ENABLE && cal_stage == 2u)
                print_result_row(seq);
        } else if(id==6u)pl_control_result(seq,payload);
        res_cnt++;
        break;
    case 4:                            /* fatigue + spectrum result (id 8..15) */
        if (id == 8u) {
            fat_num2 = (i32)(payload & 0xFFFF0000u) >> 16;
            fat_mdf  = payload & 0xFFFFu;      /* mean MDF bin index */
        } else if (id == 9u) {
            fat_level  = payload >> 30;        /* RTL-defined 0..3 */
            fat_full   = (payload >> 29) & 1u; /* MDF history filled */
            fat_energy = payload & 0x7FFFFFu;  /* grand_total >> 23 */
            print_fatigue_row(seq);
        } else if (id >= 10u && id <= 14u) {
            u32 packet = id - 10u;
            u32 j;
            for (j = 0u; j < 6u; j++)
                spec_band[packet * 6u + j] = (payload >> (j * 5u)) & 0x1Fu;
        } else if (id == 15u) {
            pl_spec_peak_bin = payload >> 21;
            spec_peak_power = payload & 0x1FFFFFu;
            print_spectrum_row(seq);
            lcd_analysis_changed();
        }
        fat_cnt++;
        break;
    case 5:                            /* notch waveform: separate from raw diagnostics */
        lcd_wave_ingest(payload, hdr);
        lcd_spectrum_ingest(payload, hdr);
        sd_pair_packet(payload,hdr);
        return;
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
        uprintf("[STAT] lcd done=%u pending=%u merged=%u overflow=%u\n",
                lcd_present_cnt,lcd_pending,lcd_coalesced_cnt,lcd_overflow_cnt);
        uprintf("[STAT] lcd content_fps10=%u quality_calls=%u chunk_max_us=%u quota_us=%u\n",
                lcd_content_fps10,cq_background_calls,cq_chunk_max_ticks/(GT_TICKS_PER_MS/1000u),
                cq_check_state?2500u:0u);
        uprintf("[STAT] touch ok=%u dn=%u press=%u rel=%u\n",
                touch_seen, touch_dn, touch_press_cnt, touch_rel_cnt);
        uprintf("[STAT] mpu ok=%u p=%d r=%d\n",
                mpu_seen, (u32)mpu_pitch, (u32)mpu_roll, 0);
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
    for (w = 0; w < BUF_PACKETS; w++) {
        if ((w & 63u)==0u) { acquisition_service(); touch_tick(); mpu_tick(); }
        parse_packet(buf[2 * w], buf[2 * w + 1]);  /* payload, header */
    }
}

/* ---- Minimal runtime bits (freestanding, no libc) ---------------------- */

#ifndef LCD_HOST_TEST
void *memcpy(void *dst, const void *src, size_t n)
{
    unsigned char *d = dst;
    const unsigned char *s = src;
    while (n--)
        *d++ = *s++;
    return dst;
}

void *memset(void *dst, int v, size_t n)
{
    unsigned char *d = dst;
    while (n--)
        *d++ = (unsigned char)v;
    return dst;
}

int memcmp(const void *left,const void *right,size_t n)
{
    const unsigned char *a=(const unsigned char *)left;
    const unsigned char *b=(const unsigned char *)right;
    while (n--) { if (*a!=*b) return *a<*b ? -1 : 1; a++; b++; }
    return 0;
}

char *strchr(const char *s,int c)
{
    while (*s) { if ((unsigned char)*s==(unsigned char)c) return (char *)s; s++; }
    return c==0 ? (char *)s : (char *)0;
}
#endif

/* ---- Record mode (dataset capture) -------------------------------------- *
 * 2 Mbaud binary stream. Raw = AA 55, processed = AA 58, then seq u16 LE
 * and 8 x int24 LE. The per-frame marker verifies the actual PL source.
 * (ch0..ch7).  One frame per complete 8-channel group; the PL raw packets
 * arrive channel-interleaved, so we accumulate rec_slot[ch] and emit when
 * all 8 are present.  No text output while recording (except the one-shot
 * banner emitted by mode_set) so the frame stream stays parseable. */

static u32 rec_slot[8];
static u16 rec_slot_seq[8];
static u16 rec_frame_seq;
static u32 rec_acc;

static void record_select(u32 notch)
{
    rec_notch = notch != 0u;
    rec_acc = 0u;                      /* never mix sources in a partial frame */
}

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
        if ((w & 63u)==0u) { acquisition_service(); touch_tick(); mpu_tick(); }
        u32 hdr = buf[2 * w + 1];
        u32 pay = buf[2 * w];
        u32 ch;
        lcd_wave_ingest(pay, hdr);      /* independent of the recording source */
        if(PL_CONTROL_ENABLE && (hdr>>28)==3u && ((hdr>>20)&15u)==6u)
            pl_control_result(hdr&65535u,pay);
        lcd_spectrum_ingest(pay,hdr);
        sd_pair_packet(pay,hdr);
        if ((hdr >> 28) != (rec_notch ? 5u : 1u))
            continue;
        ch = (hdr >> 24) & 15u;
        if (ch >= 8u || ((hdr >> 16) & 0xffu) != 0u)
            continue;
        {
            u16 seq = (u16)(hdr & 0xFFFFu);

            /* Any sequence change starts a new acquisition instant. Waiting
             * for a repeated channel could consume the first half of a good
             * frame in a stale partial frame after loss or a source switch. */
            if (rec_acc != 0u && rec_frame_seq != seq)
                rec_acc = 0;
            rec_frame_seq = seq;
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
                uart_putc((char)(rec_notch ? 0x58 : 0x55));
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

/* Switch monitor <-> record at runtime: reconfigure the UART baud and
 * restart the mode-specific state without resetting acquisition. Returning to monitor reruns
 * the rest calibration (electrode state may have changed meanwhile). */
static void mode_set(u32 mode)
{
    hand_stop();
    if(selfcal.state==1u || selfcal.state==2u)selfcal_reset(&selfcal);
    hdc_interrupt(&hdc);
    rehab_pause(&rehab,RH_REASON_DATA,rehab_milliseconds());
    synergy_feedback_reset(&synergy_feedback);rehab_effort_enabled=0u;
    /* Baud changes reset the stream. Finish an SD session before doing so. */
    if (sd_record_active()) sd_record_stop();
    sd_pair_reset();
    g_mode = mode;
    ui_mode_sel = mode == MODE_RECORD ? 1u : 0u;
    ui_set_mode_label(ui_mode_sel);
    ui_preview_cls = -1;
    ui_dirty = 1u;
    ui_generation++;
    lcd_show_state(lcd_state_cls,lcd_state_conf,lcd_state_fatigue,lcd_state_gated,
                   lcd_state_tilt,lcd_state_shift);
    tx_ring_reset();                   /* drop stale monitor text */
    rec_acc = 0;
    if (mode == MODE_RECORD) {
        uart_reconfig(REC_BAUDGEN, REC_BAUDDIV);
        uart_puts(rec_notch ? "EMGREC2 8ch24b fs=4000 notchQ=10 combBW=1 hp=20 lp=215\n"
                            : "RAWREC1 8ch24b\n");
    } else {
        uart_reconfig(MON_BAUDGEN, MON_BAUDDIV);
        uart_puts("\n[MODE] monitor 115200-8N1, recalibrating ('r' = record)\n");
    }
    if (mode == MODE_MONITOR)
        cal_start();
}

static void mpu_zero_start(void)
{
    lcd_imu_reset();
}

static void ui_apply_action(void)
{
    u32 action=ui_action;
    u32 hdc_model_pending=ui_hdc_model;
    ui_hdc_model=0u;
    u32 hdc_save_pending=ui_hdc_save;
    ui_hdc_save=0u;
    u32 sd_action=ui_sd_action;
    u32 rehab_action_pending=ui_rehab_action;
    ui_action=0u;
    ui_sd_action=0u;
    ui_rehab_action=0u;
    if (action==1u || action==2u) {
        u32 mode=action==2u ? MODE_RECORD : MODE_MONITOR;
        if (mode != g_mode) mode_set(mode);
    } else if (action==3u) {
        hand_stop();hdc_interrupt(&hdc);
        rehab_pause(&rehab,RH_REASON_CAL,rehab_milliseconds());
        if (g_mode != MODE_MONITOR) mode_set(MODE_MONITOR);
        else cal_start();
    } else if (action==4u) mpu_zero_start();
    if (sd_action) {
        if (sd_action==1u && lcd_sd_view && !ui_menu_open) {
            hand_stop();hdc_interrupt(&hdc);
            rehab_pause(&rehab,RH_REASON_USER,rehab_milliseconds());
            sd_pair_dropped=0u;
            sd_pair_reset();
            /* Keep the live DMA/FIFO pointers continuous across file creation. */
            sd_record_start();
        } else if(sd_action==2u) {
            sd_record_stop();
            sd_pair_reset();
        }
        ui_generation++;
        lcd_pending=1u;
        lcd_input_status_changed();
    }
    if(rehab_action_pending)rehab_apply_action(rehab_action_pending);
    if(hdc_save_pending && !action && !sd_action && !rehab_action_pending)hdc_save_report();
    if(hdc_model_pending && !action && !sd_action && !rehab_action_pending)hdc_model_apply(hdc_model_pending);
    if(hand_storage_action) {
        u32 ha=hand_storage_action;hand_storage_action=0u;hand_storage_apply(ha);
    }
}

/* Non-blocking RX poll; 'c' recalibrates rest, 'd' toggles debug text,
 * 'f' toggles the optional feature CSV stream, and 'r' toggles
 * monitor/record mode. 'z' captures MPU zero; 't' prints raw touch state;
 * 'i' prints IMU calibration, bias, gaps and clipping. 'b' prints ADC RREG.
 * 'w' toggles the LCD hand/wave page, 'a' toggles the LCD DATA page, 's'
 * toggles the LCD spectrum page, and '1'..'8' select its waveform channel. */
static void uart_poll_rx(void)
{
    while (!(UART_SR & UART_SR_RXEMPTY)) {
        u32 c = UART_FIFO & 0xFFu;
        if (c == 'n' || c == 'u') {
            record_select(c == 'n');   /* at either baud, no text in binary stream */
        } else if (c == 'r') {
            ui_action = (g_mode == MODE_RECORD) ? 1u : 2u;
            return;
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
        } else if (c == 'h' && g_mode == MODE_MONITOR) {
            lcd_hdc_open();
        } else if (c == 'w' && g_mode == MODE_MONITOR) {
            lcd_wave_toggle();
        } else if (c == 'a' && g_mode == MODE_MONITOR) {
            lcd_analysis_toggle();
        } else if (c == 's' && g_mode == MODE_MONITOR) {
            lcd_spectrum_toggle();
        } else if (c >= '1' && c <= '8' && g_mode == MODE_MONITOR) {
            lcd_wave_select(c - '1', wave_notch);
        } else if (c == 'f' && g_mode == MODE_MONITOR) {
            feature_stream = !feature_stream;
            uart_puts(feature_stream ? "[UART] F rows ON\n"
                                     : "[UART] F rows OFF\n");
        } else if (c == 'l' && g_mode == MODE_MONITOR) {
            lcd_enable(!lcd_stream_on);
            uart_puts(lcd_stream_on ? "[LCD] ON\n"
                                    : "[LCD] OFF (DDR freed for EMG test)\n");
        } else if (c == 'z' && g_mode == MODE_MONITOR) {
            mpu_zero_start();
            uart_puts("[MPU] current-pose zero: hold forearm still for ~1 s\n");
        } else if (c == 'i' && g_mode == MODE_MONITOR) {
            g_tx_data=1u;
            uart_puts("[IMU] fw=");uart_puts(BUILD_TAG);uart_puts("\n");
            uprintf("[IMU] zero=%u samples=%u still=%u gaps=%u\n",
                    mpu_zero_valid,mpu_zero_cnt,imu_stationary,imu_gap_count);
            uprintf("[IMU] bias_mdps x=%d y=%d z=%d clip=%u\n",
                    (u32)(i32)(imu_bias[0]*1000.0f/IMU_GYRO_LSB_DPS),
                    (u32)(i32)(imu_bias[1]*1000.0f/IMU_GYRO_LSB_DPS),
                    (u32)(i32)(imu_bias[2]*1000.0f/IMU_GYRO_LSB_DPS),imu_clip_count);
            uprintf("[IMU] track=%u seq=%u accepted=%u generation=%u\n",
                    lcd_imu_valid,imu_last_seq,imu_sample_count,lcd_imu_generation);
            uprintf("[IMU] zero_restart=%u reason=0x%x dt_ms=%u age_ms=%u\n",
                    imu_zero_restarts,imu_zero_reason,imu_last_dt_ms,
                    imu_time_valid ? (gt_stamp()-imu_last_t)/GT_TICKS_PER_MS : 0u);
            uprintf("[IMU] acc_lsb x=%d y=%d z=%d\n",
                    (u32)imu_last_acc[0],(u32)imu_last_acc[1],(u32)imu_last_acc[2],0);
            uprintf("[IMU] gyro_lsb x=%d y=%d z=%d\n",
                    (u32)imu_previous_raw[0],(u32)imu_previous_raw[1],(u32)imu_previous_raw[2],0);
            g_tx_data=0u;
        } else if (c == 'b' && g_mode == MODE_MONITOR) {
            adc_status_tick();
            g_tx_data=1u;
            uart_puts("[ADC] fw=");uart_puts(BUILD_TAG);uart_puts(" ");
            uart_puts(adc_config_label());uart_puts("\n");
            uprintf("[ADC] done=%u ok=%u error=%u bad_addr=0x%x\n",
                    adc_config_word>>31,(adc_config_word>>30)&1u,
                    (adc_config_word>>29)&1u,(adc_config_word>>24)&31u);
            uprintf("[ADC] actual CONFIG3=0x%x BIAS_P=0x%x BIAS_N=0x%x word=0x%x\n",
                    (adc_config_word>>16)&255u,(adc_config_word>>8)&255u,
                    adc_config_word&255u,adc_config_word);
            uart_puts("[ADC] expected CONFIG3&FE=EC P=01 N=01; CHn=40 gain=8 fs=4000\n");
#if PL_CONTROL_ENABLE
            pl_control_tick();
            uprintf("[PLCTRL] word=0x%x epoch=%u shift=%u pending=%u\n",pl_control_word,
                    pl_control_epoch,pl_control_sent_shift,pl_control_inflight||pl_control_queued);
            uprintf("[PLCTRL] accepted=%u rejected=%u ready=%u stage=%u\n",pl_control_packets,
                    pl_control_rejected,pl_control_ready(),cal_stage);
#if PL_LEARNING_ENABLE
            uprintf("[PLLEARN] status=0x%x jobs=%u failures=%u max_us=%u\n",
                    pl_learning_status,pl_learning_jobs,pl_learning_failures,pl_learning_max_ticks/333u);
#endif
#endif
            g_tx_data=0u;
        } else if (c == 't' && g_mode == MODE_MONITOR) {
            g_tx_data=1u;
            uprintf("[TOUCH] word=0x%x link=%u down=%u badxy=%u\n",
                    touch_word_raw,touch_seen,touch_dn,touch_bad_xy);
            uprintf("[TOUCH] x=%u y=%u press=%u rel=%u\n",
                    touch_x,touch_y,touch_press_cnt,touch_rel_cnt);
            g_tx_data=0u;
        }
    }
}

int main(void)
{
    u32 err;

    synergy_nmf_reset(&synergy_nmf);

    /* Standalone boot is quiet by default.  Send 'd' on UART0 when bring-up
     * diagnostics are needed; banners, verbose decode, [STAT]/[CAL]/[DMA]
     * text passes uart_putc's debug gate, while R/P/T data rows stream
     * regardless (they enqueue into the TX ring, never blocking parse). */
    g_uart_debug = 0u;
    uart_reconfig(MON_BAUDGEN, MON_BAUDDIV);
    uart_puts("\n=== sEMG hand-motion PL stream monitor ===\n");
    uart_puts("UART0(MIO14/15) 115200-8N1, AXI DMA @ 0x40400000 (S2MM polling)\n");
    uart_puts("commands: 'c' = recalibrate, 'd' = diag text, 'f' = F rows,\n");
    uart_puts("          'l' = LCD on/off, 'r' = record, 'z' = MPU zero,\n");
    uart_puts("          't' = raw touch state, 'i' = IMU state, 'n'/'u' = notch/raw recording\n");
    uart_puts("          'w' = LCD hand/wave page, '1'..'8' = LCD waveform channel\n");
    uart_puts("          'b' = ADS1299 register readback, PL_KEY0 = reset/write/read retry\n");
    uart_puts("  (record mode: 2 Mbaud, default processed; run tools/record_uart.py)\n");
    uart_puts("packet: type/ch/id/seq/payload; 1=raw 2=feature 3=result 4=fatigue 5=processed\n");
    uart_puts("F-rows: one CSV line per 100ms window = 40 model inputs\n");
    uart_puts("  (MAV*8, WL*8, Energy*8, ZC*8, SSC*8; feed to tools/realtime_inference.py)\n");
    uart_puts("R-rows: one per window from the PL INT8 MLP:\n");
    uart_puts("  'R s=<seq> c=<class> p=<conf>[ g=1]' (+ logits every 4th window)\n");
    uart_puts("  (p = uncalibrated softmax score; g=1 = MAV rest evidence)\n");
    uart_puts("P-rows: versioned PoseFrame v=1 schema=2 (22 pose values)\n");
    uart_puts("  (P stable=1: action confirm 3 windows, rest 6, ambiguous hold <=8)\n");
    uart_puts("T-rows: one per 512ms fatigue window: 'T s=.. lv=.. mdf=.. n2=..'\n");
    uart_puts("  (lv: 0=NORM 1=MILD 2=FATIG 3=LEVEL3 from MDF slope)\n");
    uart_puts("C-rows: GT911 touch 'C x=.. y=.. dn=..' (edges + 100ms moves)\n");
    uart_puts("rest calibration: ~2.4 s after boot, [CAL] lines report baselines/thr\n");
    uart_puts("expected: ~32000 raw/s, ~1600 feature/s (40 windows/s)\n");
    uart_puts("  -> R/P/T rows stream always (renderer feed, debug off ok);\n");
    uart_puts("     'd' adds [STAT]/verbose diag, 'f' adds F rows (~80% line)\n\n");

    gt_init();                /* before lcd_init: the boot triple-render is
                               * measured too (first lcd= row sanity check) */
    ui_menu_open=1u;           /* predictable entry point with visible STOP */
    lcd_init();               /* local virtual hand + VDMA MM2S + backlight */
    g_uart_debug = 0u;                 /* steady state is LCD-local */
    cal_start();
    hand_boot_init();          /* one boot-only, saved-profile homing attempt */
    dma_restart();

    {
        u32 t_prev = gt_stamp();
        for (;;) {
            u32 t0, dt;
            uart_poll_rx();
            ui_apply_action();
            t0 = gt_stamp();
            err = dma_wait();
            if (err==DMA_WAIT_UI) { ui_apply_action(); t_prev=gt_stamp(); continue; }
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
                if (sd_record_active()) sd_record_abort(0x200u);
                sd_pair_reset();
                dma_restart();
                continue;
            }
            sd_parse_label=dma_labels[dma_tail & (DMA_SLOTS-1u)];
            if (g_mode == MODE_RECORD)
                record_buffer(dma_buffer(dma_tail));
            else
                parse_buffer(dma_buffer(dma_tail));
            dma_tail++;
        }
    }
    return 0;                          /* not reached */
}

