/* SPDX-License-Identifier: Apache-2.0
 * Shared three-buffer ownership for two independent VDMA readers.
 * HPD never gates the reader; unplugging a monitor cannot stall LCD updates.
 * On an error/timeout, retain ownership until MM2S reset actually completes.
 */
#ifndef HDMI_MIRROR_H
#define HDMI_MIRROR_H
#ifndef HDMI_MIRROR_ENABLE
#if defined(__arm__)
#define HDMI_MIRROR_ENABLE 1
#else
#define HDMI_MIRROR_ENABLE 0
#endif
#endif
#if HDMI_MIRROR_ENABLE
#define HDMI_REG(o) MMIO32(0x43010000u+(o))
#define HDMI_STATUS MMIO32(0x41280000u)
#define HDMI_RUN MMIO32(0x41280008u)
static u32 hdmi_active,hdmi_stopping,hdmi_watch_t,hdmi_watch_frame;
static u32 hdmi_failed;
static void hdmi_stop(void)
{
    if (!hdmi_active || hdmi_stopping) return;
    HDMI_REG(0)=VDMA_DMACR_RESET;
    hdmi_stopping=1u;
}
static void hdmi_service(u32 now)
{
    u32 actual,status;
    if (!hdmi_active) return;
    if (hdmi_stopping) {
        if (!(HDMI_REG(0)&VDMA_DMACR_RESET) && (HDMI_REG(4)&VDMA_DMASR_HALTED)) {
            HDMI_RUN=0u;hdmi_active=hdmi_stopping=0u;
        }
        return;
    }
    actual=VDMA_PARK_CURRENT(HDMI_REG(0x28));status=HDMI_STATUS;
    if (actual==lcd_front_index || actual!=hdmi_watch_frame) {
        hdmi_watch_t=now;hdmi_watch_frame=actual;
    }
    if ((HDMI_REG(4)&0x00000ff0u) || (status&0x20u) ||
        (actual!=lcd_front_index && now-hdmi_watch_t>250u*GT_TICKS_PER_MS)) {
        hdmi_failed=1u;hdmi_stop();
    }
}
static u32 hdmi_owns(u32 index)
{
    u32 park,actual;
    if(!hdmi_active) return 0u;
    park=HDMI_REG(0x28);actual=VDMA_PARK_CURRENT(park);
    return actual>=3u || (park&31u)>=3u || index==actual || index==(park&31u);
}
static u32 hdmi_settled(void)
{
    return !hdmi_active || (!hdmi_stopping && VDMA_PARK_CURRENT(HDMI_REG(0x28))==lcd_front_index);
}
static void hdmi_present(u32 index)
{
    if (hdmi_active && !hdmi_stopping) HDMI_REG(0x28)=(HDMI_REG(0x28)&~31u)|index;
}
static void hdmi_init(void)
{
    u32 spins;
    /* Failed reset must retain the previous reader's buffer ownership. */
    if(hdmi_active) hdmi_stopping=1u;
    HDMI_RUN=0u;HDMI_REG(0)=VDMA_DMACR_RESET;
    for(spins=0;spins<1000000u;spins++)
        if (!(HDMI_REG(0)&VDMA_DMACR_RESET) && (HDMI_REG(4)&VDMA_DMASR_HALTED)) break;
    if(spins==1000000u) {
        hdmi_failed=1u;
        if(g_mode==MODE_MONITOR) uart_puts("[HDMI] DMA reset timeout\n");
        return;
    }
    HDMI_REG(0x54)=FB_BPL;HDMI_REG(0x58)=FB_BPL;
    HDMI_REG(0x5c)=FB_BASE;HDMI_REG(0x60)=FB_BASE+FB_BYTES;
    HDMI_REG(0x64)=FB_BASE+2u*FB_BYTES;
    HDMI_REG(0x28)=lcd_front_index;
    hdmi_watch_frame=lcd_front_index;hdmi_watch_t=gt_stamp();
    hdmi_stopping=hdmi_failed=0u;hdmi_active=1u;
    HDMI_RUN=1u;HDMI_REG(0)=VDMA_DMACR_RS;
    HDMI_REG(0x50)=(u32)LCD_H; /* VSIZE last, same contract as LCD. */
    if(g_mode==MODE_MONITOR) {
        u32 saved_tx=g_tx_data;g_tx_data=1u;
        uprintf("[HDMI] 1280x720p60 src=%ux%u status=%x\n",(u32)LCD_W,(u32)LCD_H,HDMI_STATUS,0u);
        g_tx_data=saved_tx;
    }
}
#else
static void hdmi_service(u32 now) {(void)now;}
static u32 hdmi_owns(u32 i) {(void)i;return 0u;}
static u32 hdmi_settled(void) {return 1u;}
static void hdmi_present(u32 i) {(void)i;}
static void hdmi_stop(void) {}
static void hdmi_init(void) {}
#endif
#endif
