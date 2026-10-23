/* Behavioral requirements exercised against the real hardware-free engine. */
#include <assert.h>
#include <stdio.h>
#include "../sw/ps_uart_print/rehab_training.h"
static rehab_training_t r;
static uint32_t time_ms,seq;
static void observe(uint32_t accepted,uint32_t candidate,uint32_t support,uint32_t gate)
{
    time_ms+=25u;seq=(seq+40u)&65535u;
    rehab_observe(&r,time_ms,seq,accepted,candidate,support,gate,1u);
}
static void rest_to_cue(void)
{
    unsigned n=0;
    while((r.state==RH_CALIBRATE || r.state==RH_RELAX || r.state==RH_RECOVER) && n++<200)
        observe(0u,0u,80u,1u);
    assert(n<200);
}
static void hold_success(void)
{
    unsigned n=0;uint32_t target=r.target,before=r.successes;
    while((r.state==RH_CUE || r.state==RH_HOLD) && n++<240)
        observe(target,target,80u,0u);
    assert(n<240 && r.successes==before+1u);
}
int main(void)
{
    unsigned n;uint32_t before;
    rehab_start(&r,0,2,3,1000,1000,0u);
    rest_to_cue();assert(r.state==RH_CUE && r.target==2u);
    /* Wrong and insufficient evidence cannot complete a target. */
    for(n=0;n<30;n++)observe(2u,1u,90u,0u);
    for(n=0;n<30;n++)observe(2u,2u,49u,0u);
    assert(!r.segment_ms && !r.attempted);
    for(n=0;n<30;n++)observe(2u,2u,90u,0u);
    assert(r.segment_ms>0 && r.segment_ms<1000u);
    observe(1u,1u,90u,0u);assert(r.breaks==1u && !r.segment_ms);
    hold_success();assert(r.trials[0].breaks==1u && r.trials[0].response_ms>0u);
    /* No held UI pose or no new observations can release rest. */
    for(n=0;n<60;n++)observe(2u,2u,90u,0u);
    assert(r.state==RH_RECOVER);
    rest_to_cue();hold_success();rest_to_cue();hold_success();rest_to_cue();
    assert(r.state==RH_DONE && r.attempted==3 && r.successes==3 && !r.aborted);
    /* Four-action sequence and repetition limits. */
    rehab_start(&r,1,4,2,1000,1000,time_ms);
    for(n=0;n<8;n++) {rest_to_cue();assert(r.target==n%4+1);hold_success();}
    rest_to_cue();assert(r.state==RH_DONE && r.successes==8);
    /* Stream loss pauses, never completes held target. */
    rehab_start(&r,0,1,1,1000,1000,time_ms);rest_to_cue();
    observe(1,1,80,0);time_ms+=251u;rehab_tick(&r,time_ms,1);
    assert(r.state==RH_PAUSED && r.reason==RH_REASON_DATA && !r.attempted);
    before=r.elapsed_ms;time_ms+=100000u;rehab_tick(&r,time_ms,1);assert(r.elapsed_ms==before);
    rehab_resume(&r,time_ms);rest_to_cue();assert(!r.segment_ms);hold_success();rest_to_cue();
    assert(r.state==RH_DONE && r.elapsed_ms<20000u);
    /* Sequence loss, duplicates and long scheduling stalls reset the hold. */
    rehab_start(&r,0,1,1,1000,1000,time_ms);rest_to_cue();
    for(n=0;n<25;n++)observe(1,1,80,0);
    before=r.segment_ms;rehab_observe(&r,time_ms+1,seq,1,1,80,0,1);assert(r.segment_ms==before);
    seq+=40u;observe(1,1,80,0);assert(r.segment_ms==0u);
    time_ms+=100u;observe(1,1,80,0);assert(!r.segment_ms);
    before=r.segment_ms;time_ms+=25u;observe(1,1,80,0);
    assert(r.segment_ms-before==25u); /* a 50ms scheduling delay earns one hop */
    hold_success();rest_to_cue();assert(r.state==RH_DONE);
    /* Target timeout fails once, then requires continuous recovery. */
    rehab_start(&r,0,3,1,1000,1000,time_ms);rest_to_cue();
    for(n=0;n<450 && r.state!=RH_RECOVER;n++)observe(2,2,90,0);
    assert(r.state==RH_RECOVER && r.failures==1u && !r.successes && r.attempted==1);
    rest_to_cue();assert(r.state==RH_DONE);
    rehab_start(&r,0,1,1,1000,1000,time_ms);rehab_tick(&r,time_ms+10000,0);
    assert(r.state==RH_PAUSED && r.reason==RH_REASON_CAL);
    rehab_finish(&r,time_ms+20000,1);assert(r.state==RH_DONE && r.aborted);
    /* Engine milliseconds wrap without a falsely completed hold. */
    time_ms=0xfffff000u;rehab_start(&r,0,1,1,1000,1000,time_ms);
    rest_to_cue();hold_success();rest_to_cue();assert(r.state==RH_DONE);
    rehab_start(&r,1,99,99,99999,99999,time_ms);
    assert(r.total==40 && r.action==1 && r.hold_ms==5000 && r.rest_ms==10000);
    puts("TEST_PASS REHAB: single/combined tasks, continuous hold/rest, candidate evidence, timeout, stale data, pause, sequence gaps, duplicate, clock wrap, settings bounds.");
    return 0;
}
