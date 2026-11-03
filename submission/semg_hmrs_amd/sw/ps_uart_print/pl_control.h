#ifndef EMG_PL_CONTROL_H
#define EMG_PL_CONTROL_H
/* This MMIO block exists only in the matching PL_CONTROL bitstream. Never
 * probe it from legacy firmware: an unmapped AXI read can stop the CPU. */
#ifndef PL_CONTROL_ENABLE
#define PL_CONTROL_ENABLE 0
#endif
#if PL_CONTROL_ENABLE
#define PL_CONTROL_COMMAND MMIO32(0x41240000u)
#define PL_CONTROL_STATUS  MMIO32(0x41240008u)
static u32 pl_control_initialized,pl_control_queued,pl_control_inflight;
static u32 pl_control_want_shift,pl_control_want_reset,pl_control_sent_shift;
static u32 pl_control_toggle,pl_control_epoch,pl_control_word;
static u32 pl_control_packets,pl_control_rejected;
static void pl_control_request(u32 shift,u32 reset)
{
    pl_control_want_shift=shift<6u?shift:0u;
    pl_control_want_reset|=reset!=0u;
    pl_control_queued=1u;
}
static void pl_control_mailbox_tick(void)
{
    u32 w=PL_CONTROL_STATUS;
    pl_control_word=w;
    if((w>>16)!=0x504cu)return;
    if(!pl_control_initialized) {
        pl_control_toggle=PL_CONTROL_COMMAND>>31;
        pl_control_epoch=(w>>8)&15u;
        pl_control_initialized=1u;
    }
    if(pl_control_inflight && ((w>>15)&1u)==pl_control_toggle &&
       ((w>>8)&15u)==pl_control_epoch && ((w>>4)&7u)==pl_control_sent_shift)
        pl_control_inflight=0u;
    if(pl_control_queued && !pl_control_inflight) {
        pl_control_epoch=(pl_control_epoch+1u)&15u;
        pl_control_toggle^=1u;
        pl_control_sent_shift=pl_control_want_shift;
        PL_CONTROL_COMMAND=(pl_control_toggle<<31)|(pl_control_epoch<<4)|
                           (pl_control_want_reset<<3)|pl_control_sent_shift;
        pl_control_want_reset=0u;pl_control_queued=0u;pl_control_inflight=1u;
    }
}
static u32 pl_control_ready(void)
{
    return pl_control_initialized && !pl_control_inflight && !pl_control_queued &&
           (pl_control_word>>16)==0x504cu && !(pl_control_word&12u) &&
           (pl_control_word&3u)==2u;
}
static u32 pl_control_accept(u32 word)
{
    if(!pl_control_ready() || !(word&(1u<<23)) || (word&(1u<<27)) ||
       (word>>28)!=pl_control_epoch || ((word>>24)&7u)!=pl_control_sent_shift ||
       ((word>>21)&3u)!=2u || (word&7u)>=5u || ((word>>11)&7u)>=5u ||
       ((word>>3)&127u)>100u || ((word>>14)&127u)>100u) {
        pl_control_rejected++;return 0u;
    }
    pl_control_packets++;return 1u;
}
#else
static void pl_control_request(u32 shift,u32 reset) {(void)shift;(void)reset;}
static u32 pl_control_ready(void) {return 1u;}
#endif
#endif

