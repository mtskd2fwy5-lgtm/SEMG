#include <assert.h>
#include <stdio.h>
#include "../sw/ps_uart_print/synergy_feedback.h"
#include "../sw/ps_uart_print/rehab_training.h"
int main(void)
{
    synergy_feedback_t s;rehab_training_t r;
    uint32_t v[3]={25600u,25600u,0u},seq=65520u,now=0u,i,c,previous;
    uint64_t raw_variation=0u,smooth_variation=0u;
    synergy_feedback_reset(&s);
    synergy_feedback_step(&s,v,seq,now);assert(s.smooth[1]==v[1]);
    previous=s.smooth[1];
    for(i=0u;i<80u;i++) {
        v[1]=(i&1u)?30720u:20480u;seq=(seq+40u)&65535u;now+=25u;
        synergy_feedback_step(&s,v,seq,now);
        if(i>20u) {raw_variation+=10240u;smooth_variation+=s.smooth[1]>previous?s.smooth[1]-previous:previous-s.smooth[1];}
        previous=s.smooth[1];
    }
    assert(smooth_variation*8u<raw_variation);
    assert(v[1]==30720u); /* caller's raw input untouched */
    assert(synergy_feedback_find(&s,seq,now,&c) && c==s.smooth[1]);
    assert(!synergy_feedback_find(&s,seq+40u,now,&c));
    assert(!synergy_feedback_find(&s,seq,now+76u,&c));
    v[1]=51200u;seq+=80u;now+=25u;synergy_feedback_step(&s,v,seq,now);
    assert(s.smooth[1]==51200u && s.count==1u); /* no bridge across gap */
    synergy_feedback_capture(&s,now);
    for(i=0;i<140u;i++){now+=25u;seq=(seq+40u)&65535u;synergy_feedback_step(&s,v,seq,now);}
    assert(s.capture==3u && s.reference==51200u);
    synergy_feedback_capture(&s,now);synergy_feedback_tick(&s,now+76u);
    assert(s.capture==4u && !s.reference);
    synergy_feedback_reset(&s);synergy_feedback_capture(&s,0u);
    synergy_feedback_tick(&s,5001u);assert(s.capture==4u);
    synergy_feedback_reset(&s);synergy_feedback_capture(&s,0u);
    for(i=0;i<140u;i++){v[1]=0u;synergy_feedback_step(&s,v,i*40u,i*25u);}
    assert(s.capture==4u && !s.reference);
    synergy_feedback_reset(&s);now=0xfffff000u;synergy_feedback_capture(&s,now);
    for(i=0;i<140u;i++){v[1]=0x7fffffffu;synergy_feedback_step(&s,v,i*40u,now+i*25u);}
    assert(s.capture==3u && s.reference==0x7fffffffu);
    /* Grip score requires fresh, same-window effort AND supported pose. */
    rehab_start(&r,0u,2u,1u,1000u,1000u,0u);
    r.state=RH_CUE;r.seen=1u;r.cue_at=0u;r.effort_enabled=1u;r.effort_reference=25600u;
    for(i=1;i<60u;i++) {
        r.effort_valid=0u;r.effort_c2=25600u;
        rehab_observe(&r,i*25u,i*40u,2u,2u,80u,0u,1u);
    }
    assert(!r.segment_ms && !r.attempted);
    for(;i<100u;i++) {
        r.effort_valid=1u;r.effort_c2=17919u;
        rehab_observe(&r,i*25u,i*40u,2u,2u,80u,0u,1u);
    }
    assert(!r.segment_ms);
    for(;i<120u;i++) {
        r.effort_c2=25600u;rehab_observe(&r,i*25u,i*40u,2u,1u,80u,0u,1u);
    }
    assert(!r.segment_ms); /* intensity cannot bypass action */
    for(;i<130u;i++) {
        r.effort_c2=17920u;rehab_observe(&r,i*25u,i*40u,2u,2u,80u,0u,1u);
    }
    assert(r.segment_ms>0u);
    r.effort_c2=33281u;rehab_observe(&r,i*25u,i*40u,2u,2u,80u,0u,1u);i++;
    assert(!r.segment_ms && r.breaks==1u);
    for(;r.state!=RH_RECOVER && i<200u;i++) {
        r.effort_c2=33280u;rehab_observe(&r,i*25u,i*40u,2u,2u,80u,0u,1u);
    }
    assert(r.successes==1u && r.effort_in_band>40u);
    rehab_start(&r,0u,1u,1u,1000u,1000u,0u);r.state=RH_CUE;r.seen=1u;r.effort_enabled=1u;
    for(i=1u;i<45u;i++)rehab_observe(&r,i*25u,i*40u,1u,1u,80u,0u,1u);
    assert(r.successes==1u); /* open hand unaffected */
    puts("TEST_PASS grip feedback: attenuation/raw preservation/gap/wrap/reference/timeout/range/pose/freshness");
    return 0;
}
