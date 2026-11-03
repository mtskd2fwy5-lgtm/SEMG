#ifndef EMG_SYNERGY_FEEDBACK_H
#define EMG_SYNERGY_FEEDBACK_H
#include <stdint.h>
#include <string.h>
/* 25 ms feature hops. EMA alpha=1/8: tau~187 ms, 90% step~450 ms.
 * Raw solver coefficients are never modified. Reference is mean raw C2 Q8,
 * not MVC or force. Capture: 0.5 s settling then 3 s contiguous evidence. */
#define SYNERGY_FEEDBACK_SLOTS 8u
typedef struct {
    uint32_t smooth[3], seen, last_ms, last_seq, write;
    uint32_t seq[8], stamp[8], c2[8], count;
    uint32_t capture, capture_count, settle, reference, capture_at;
    uint64_t sum;
} synergy_feedback_t;

static void synergy_feedback_reset(synergy_feedback_t *s)
{ memset(s,0,sizeof *s); }

static void synergy_feedback_capture(synergy_feedback_t *s,uint32_t now)
{
    s->reference=0u;s->capture=1u;s->capture_count=s->settle=0u;s->sum=0u;
    s->capture_at=now;
}

static void synergy_feedback_tick(synergy_feedback_t *s,uint32_t now)
{
    if((s->capture==1u || s->capture==2u) &&
       ((s->seen && now-s->last_ms>75u) || now-s->capture_at>5000u))
        s->capture=4u;
}

/* Solver uses firmware u32 = unsigned int (ARM uint32_t may be unsigned long). */
static void synergy_feedback_step(synergy_feedback_t *s,const unsigned int raw[3],
                                  uint32_t seq,uint32_t now)
{
    uint32_t i,continuous=s->seen && (uint16_t)(seq-s->last_seq)==40u && now-s->last_ms<=75u;
    if(s->seen && (uint16_t)(seq-s->last_seq)==0u)return;
    if(!continuous) {
        s->count=s->write=0u;
        if(s->seen && (s->capture==1u || s->capture==2u))s->capture=4u;
    }
    for(i=0u;i<3u;i++) {
        int64_t delta=(int64_t)raw[i]-s->smooth[i];
        s->smooth[i]=continuous?(uint32_t)((int64_t)s->smooth[i]+delta/8):raw[i];
    }
    s->seen=1u;s->last_seq=(uint16_t)seq;s->last_ms=now;
    s->seq[s->write]=(uint16_t)seq;s->stamp[s->write]=now;s->c2[s->write]=s->smooth[1];
    s->write=(s->write+1u)%SYNERGY_FEEDBACK_SLOTS;
    if(s->count<SYNERGY_FEEDBACK_SLOTS)s->count++;
    if(s->capture==1u) {
        if(++s->settle>=20u)s->capture=2u;
    } else if(s->capture==2u) {
        s->sum+=raw[1];
        if(++s->capture_count>=120u) {
            s->reference=(uint32_t)((s->sum+60u)/120u);
            s->capture=s->reference>=256u?3u:4u;
            if(s->capture==4u)s->reference=0u;
        }
    }
}

/* Join by feature window sequence, never reuse a held previous-window value. */
static uint32_t synergy_feedback_find(const synergy_feedback_t *s,uint32_t seq,
                                      uint32_t now,uint32_t *c2)
{
    uint32_t i;
    for(i=0u;i<s->count;i++)if(s->seq[i]==(uint16_t)seq && now-s->stamp[i]<=75u) {
        *c2=s->c2[i];return 1u;
    }
    return 0u;
}
#endif

