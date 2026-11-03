/* Test production scheduling with the existing deterministic MMIO/clock model. */
#define PL_CONTROL_ENABLE 1
#define CONTROL_REFERENCE_NO_MAIN 1
#include "control_policy_reference.c"

static u32 exhaust_budget(u32 stamp)
{
    u32 i,before=cq_background_calls;
    for(i=0;i<1000u;i++)cq_background_tick(stamp);
    assert(cq_background_calls>before);
    before=cq_background_calls;
    for(i=0;i<100u;i++)cq_background_tick(stamp);
    assert(cq_background_calls==before);
    return before;
}

int main(void)
{
    u32 i,a,ch,stamp=0xffff0000u;
    /* Pending data alone no longer starts background FFT work. */
    for(i=0;i<CQ_N;i++)cq_ingest((i&1u)?30u:(u32)-30,0x50000000u|i,stamp);
    assert(cq_pending[0].ready);
    time_ticks=stamp;ui_menu_open=0u;lcd_data_view=0u;cq_budget_t=stamp;
    a=cq_background_calls;
    for(i=0;i<100u;i++)cq_background_tick(stamp);
    assert(cq_background_calls==a);
    /* One press restarts capture from the press and discards the frozen
     * window; the fresh check window runs the worker under 2.5 ms per 5 ms. */
    assert(cq_request_check(stamp));
    assert(!cq_pending[0].ready && channel_quality[0].n==0u);
    for(i=0;i<CQ_N;i++)cq_ingest((i&1u)?30u:(u32)-30,0x50000000u|(4000u+i),stamp);
    assert(cq_pending[0].ready);
    a=exhaust_budget(stamp);
    assert(cq_budget_used>=2500u*(GT_TICKS_PER_MS/1000u));
    assert(cq_budget_used<2500u*(GT_TICKS_PER_MS/1000u)+3334u);
    /* One renewed opportunity drains a budget-bounded burst of worker
     * chunks instead of a single call: the idle poll loop reaches this
     * point far fewer times per second than the worker needs chunks, so a
     * whole check must fit inside these bursts. Same-stamp calls that
     * follow the burst advance nothing until the quota renews. */
    stamp+=5u*GT_TICKS_PER_MS;time_ticks=stamp;a=cq_background_calls;
    cq_background_tick(stamp);
    assert(cq_background_calls>a+1u);
    assert(cq_background_calls-a<=256u);
    a=cq_background_calls;
    for(i=0;i<100u;i++)cq_background_tick(stamp);
    assert(cq_background_calls==a);
    /* The check finishes, commits all eight channels in one step and the
     * worker goes idle again; channels without a stream show no data. */
    for(i=0u;cq_check_state&&i<20000u;i++) {
        u32 k;
        stamp+=5u*GT_TICKS_PER_MS;time_ticks=stamp;
        for(k=0u;k<260u;k++)cq_background_tick(stamp);
    }
    assert(!cq_check_state && cq_check_count==1u);
    assert(cq_result_ok[0] && channel_quality[0].valid);
    for(i=1u;i<8u;i++)assert(!cq_result_ok[i]);
    a=cq_background_calls;
    for(i=0;i<100u;i++)cq_background_tick(stamp);
    assert(cq_background_calls==a);
    /* Eight live channels inside one budgeted check: every window drains
     * through the bursts and all eight results commit together. */
    assert(cq_request_check(stamp));
    for(i=0;i<CQ_N;i++)for(ch=0u;ch<8u;ch++)
        cq_ingest((i&1u)?30u:(u32)-30,0x50000000u|(ch<<24)|(8000u+i),stamp);
    for(i=0u;cq_check_state&&i<20000u;i++) {
        u32 k;
        stamp+=5u*GT_TICKS_PER_MS;time_ticks=stamp;
        for(k=0u;k<260u;k++)cq_background_tick(stamp);
    }
    assert(!cq_check_state && cq_check_count==2u);
    for(i=0u;i<8u;i++)assert(cq_result_ok[i] && channel_quality[i].valid);
    a=cq_background_calls;
    for(i=0;i<100u;i++)cq_background_tick(stamp);
    assert(cq_background_calls==a);
    /* Observed scanout changes give content FPS, not requests or redraw count. */
    lcd_rate_seen=0u;lcd_rate_changes=0u;lcd_content_fps10=0u;stamp=0xffff0000u;
    lcd_rate_tick(stamp,0u);
    for(i=1u;i<=20u;i++)lcd_rate_tick(stamp+i*50u*GT_TICKS_PER_MS,i%3u);
    assert(lcd_content_fps10==200u);
    lcd_rate_tick(stamp+2000u*GT_TICKS_PER_MS,2u);assert(lcd_content_fps10==0u);
    lcd_rate_tick(stamp+2500u*GT_TICKS_PER_MS,31u);assert(lcd_rate_actual==2u);
    /* Keepalive acknowledgements must not bypass the LCD refresh throttle. */
    hand_status_reg=0x48010000u;control_status_reg=0x504c0000u;
    pl_control_tick();ui_dirty=lcd_pending=0u;
    hand_status_reg^=1u<<23;pl_control_tick();assert(!ui_dirty && !lcd_pending);
    hand_status_reg|=1u<<21;pl_control_tick();assert(ui_dirty);
    puts("TEST_PASS UI budget: idle-between-checks, press-triggered 2.5ms quota/renewal, budget-bounded burst draining, single commit, eight-channel burst completion, observed scanout FPS and static zero");
    return 0;
}

