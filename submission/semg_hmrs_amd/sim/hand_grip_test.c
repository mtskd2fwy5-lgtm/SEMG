#define PL_CONTROL_ENABLE 1
#define CONTROL_REFERENCE_NO_MAIN 1
#include "control_policy_reference.c"

static void drain(uint32_t now)
{
    uint32_t i;
    for(i=0u;i<100u;i++) {
        hand_status_reg=0x48010000u|((hand_command_reg>>31)<<23);
        hand_tick(now,1u,0,1u);
        if(!hand_inflight && !hand_stop_pending && hand_qread==hand_qwrite)return;
    }
    assert(0 && "mailbox did not drain");
}
static void setup(void)
{
    uint32_t i;
    hand_stop();drain(0u);hand_profile_init();hand_profile.cal_mask=4095u;
    hand_profile.row_mask=5u;
    for(i=0u;i<6u;i++) {
        hand_profile.low[i]=500u;hand_profile.high[i]=2500u;
        hand_profile.pose[0][i]=i==1u?1800u:1000u;
        hand_profile.pose[2][i]=i==1u?1000u:2000u;
    }
    hand_grip_seen=hand_grip_valid=hand_grip_capturing=0u;
    hand_rotation_valid=1u;hand_home_state=HAND_HOME_IDLE;
    hand_grip_sent_generation=hand_grip_generation=0u;
}
static void render(uint32_t panel)
{
    char name[100];FILE *f;uint32_t i;
    lcd_w=panel?1024:800;lcd_h=panel?600:480;
    fb_bpl=(u32)lcd_w*3u;fb_bytes=fb_bpl*(u32)lcd_h;
    lcd_clip_top=0;lcd_clip_bottom=lcd_h;dl_fb_now=fb[0];dl_mode=0;
    lcd_render_pose(2u,90u,0u,0u,1u);
    sprintf(name,"report/grip_control_20261031/grip_%d.ppm",lcd_w);
    f=fopen(name,"wb");assert(f);fprintf(f,"P6\n%d %d\n255\n",lcd_w,lcd_h);
    for(i=0u;i<fb_bytes;i+=3u) {
        fputc(fb[0][i+2u],f);fputc(fb[0][i+1u],f);fputc(fb[0][i],f);
    }
    fclose(f);
}
int main(void)
{
    uint32_t i,old,now=1000u,seq=65520u,panel;
    setup();hand_auto_grip(now);assert(!hand_run);
    hand_grip_observe(now,(uint16_t)seq,14080u,25600u,2u,1u);
    assert(hand_grip_valid && hand_grip_percent==50u);
    assert(hand_grip_pulse(1u,50u)==1400u && hand_grip_pulse(2u,50u)==1500u);
    hand_auto_grip(now);assert(hand_run==4u);
    assert((hand_queue[hand_qwrite-1u]&65535u)==1u);
    for(i=1u;i<6u;i++)assert((hand_queue[hand_qwrite-8u+i]&65535u)==hand_grip_pulse(i,50u));
    drain(now);assert(((hand_command_reg>>27)&15u)==11u);
    for(i=0u;i<3u;i++) {
        now+=25u;seq=(seq+40u)&65535u;
        hand_grip_observe(now,(uint16_t)seq,i?0x7fffffffu:2560u,25600u,2u,1u);
        drain(now);
    }
    assert(hand_grip_percent==100u);
    old=hand_grip_ms;hand_grip_observe(now+20u,(uint16_t)seq,0u,25600u,0u,1u);
    assert(hand_grip_ms==old && hand_grip_percent==100u);
    now+=25u;seq=(seq+40u)&65535u;
    hand_grip_observe(now,(uint16_t)seq,25600u,25600u,0u,1u);
    assert(!hand_grip_percent);drain(now);
    /* A missing same-window coefficient cancels a partially queued update. */
    now+=25u;seq=(seq+40u)&65535u;
    hand_grip_observe(now,(uint16_t)seq,25600u,25600u,2u,0u);
    assert(!hand_run && hand_stop_pending && hand_qread==hand_qwrite);drain(now);
    hand_grip_observe(now+25u,(uint16_t)(seq+40u),25600u,25600u,2u,1u);
    hand_auto_grip(now+25u);assert(hand_run==4u);drain(now+25u);
    drain(now+101u);assert(!hand_run); /* duplicate packets cannot renew lease */
    setup();hand_grip_observe(100u,0u,25600u,25600u,2u,1u);
    hand_auto_grip(100u);assert(hand_run==4u);
    hand_grip_observe(125u,80u,25600u,25600u,2u,1u);
    assert(!hand_run && !hand_grip_valid);drain(125u);
    setup();hand_grip_observe(100u,0u,25600u,0u,2u,1u);
    hand_auto_grip(100u);assert(!hand_run);
    setup();hand_grip_observe(100u,0u,25600u,25600u,2u,1u);
    hand_profile.row_mask=1u;hand_auto_grip(100u);assert(!hand_run);
    hand_profile.row_mask=5u;hand_profile.pose[2][1]=2600u;
    hand_auto_grip(100u);assert(!hand_run);
    hand_profile.pose[2][1]=1000u;hand_rotation_valid=0u;
    hand_auto_grip(100u);assert(!hand_run);
    hand_rotation_valid=1u;hand_grip_capturing=1u;
    hand_auto_grip(100u);assert(!hand_run);
    setup();hand_grip_observe(0xfffffff0u,65520u,14080u,25600u,2u,1u);
    hand_grip_observe(9u,24u,14080u,25600u,2u,1u);
    assert(hand_grip_valid && hand_grip_percent==50u);
    puts("TEST_PASS synergy grip: signed finger interpolation, clamp/deadband, atomic target, missing/duplicate/gap/wrap, freshness, reference/mapping/MPU guards");
    /* Use production result consumer and same-window join, not UI targets. */
    setup();g_mode=MODE_MONITOR;cal_stage=2u;synergy_nmf.valid=1u;
    control_status_reg=0x504c0002u;pl_control_initialized=1u;
    pl_control_inflight=pl_control_queued=0u;pl_control_epoch=0u;pl_control_sent_shift=0u;
    time_ticks=1000u*GT_TICKS_PER_MS;rehab_clock_seen=0u;rehab_clock_ms=1000u;
    synergy_feedback_reset(&synergy_feedback);synergy_feedback.reference=25600u;
    {unsigned int raw[3]={0u,14080u,0u};
     synergy_feedback_step(&synergy_feedback,raw,0u,1000u);}
    pl_control_result(0u,(1u<<23)|(2u<<21)|(2u<<11)|(90u<<14)|(90u<<3)|2u);
    assert(hand_grip_valid && hand_grip_percent==50u);
    /* Real rest gate opens the fingers without disabling future grip updates. */
    {unsigned int raw[3]={0u,14080u,0u};
     synergy_feedback_step(&synergy_feedback,raw,40u,1025u);}
    time_ticks=1025u*GT_TICKS_PER_MS;
    pl_control_result(40u,(1u<<23)|(2u<<21)|(1u<<10)|(90u<<14)|(90u<<3));
    assert(hand_grip_valid && !hand_grip_percent);
    /* Every captured window, including the final one, needs action evidence. */
    hand_grip_capturing=1u;synergy_feedback.capture=3u;
    synergy_feedback.reference=25600u;
    time_ticks=1050u*GT_TICKS_PER_MS;
    {unsigned int raw[3]={0u,14080u,0u};
     synergy_feedback_step(&synergy_feedback,raw,80u,1050u);}
    pl_control_result(80u,(1u<<23)|(2u<<21)|(1u<<11)|(90u<<14)|(90u<<3)|2u);
    assert(!synergy_feedback.reference && synergy_feedback.capture==4u);
    for(panel=0u;panel<2u;panel++) {
        setup();g_mode=MODE_MONITOR;cal_stage=2u;
        pl_control_word=0x504c0002u;pl_control_initialized=1u;
        pl_control_inflight=pl_control_queued=0u;
        time_ticks=2000u*GT_TICKS_PER_MS;rehab_clock_seen=0u;rehab_clock_ms=2000u;
        ui_open_page(UI_HAND);drain(2000u);hand_view_mode=0u;
        lcd_w=panel?1024:800;lcd_h=panel?600:480;
        lcd_hand_touch(LCD_X(600),LCD_Y(195));assert(hand_view_mode==2u);
        synergy_feedback_reset(&synergy_feedback);
        drain(2000u);lcd_hand_touch(LCD_X(100),LCD_Y(440));
        assert(hand_grip_capturing && synergy_feedback.capture==1u && !hand_run);
        rehab_service();assert(synergy_feedback.capture==1u);
        drain(2000u);
        synergy_feedback.reference=25600u;synergy_feedback.capture=3u;
        synergy_feedback.last_ms=rehab_milliseconds();
        rehab_service();assert(hand_grip_capturing);
        now=rehab_milliseconds();synergy_nmf.valid=1u;
        mpu_seen=mpu_zero_valid=imu_hand_rotation_valid=1u;
        mpu_last_sample_t=time_ticks;
        {unsigned int raw[3]={0u,14080u,0u};
         synergy_feedback_step(&synergy_feedback,raw,0u,now);}
        pl_control_result(0u,(1u<<23)|(2u<<21)|(2u<<11)|(90u<<14)|(90u<<3)|2u);
        assert(!hand_grip_capturing && synergy_feedback.capture==3u);
        lcd_hand_touch(LCD_X(450),LCD_Y(440));assert(hand_run==4u);
        render(panel);
        ui_open_page(UI_SETTINGS);assert(!hand_run && hand_stop_pending);
        drain(now);
        ui_open_page(UI_HAND);drain(now);hand_view_mode=2u;
        lcd_hand_touch(LCD_X(100),LCD_Y(440));assert(hand_grip_capturing);
        lcd_hand_touch(LCD_X(800),LCD_Y(440));
        assert(!hand_grip_capturing && synergy_feedback.capture==4u);
        hand_grip_capturing=1u;synergy_feedback.capture=3u;
        synergy_feedback.reference=25600u;synergy_feedback.last_ms=0u;
        rehab_service();assert(!synergy_feedback.reference && synergy_feedback.capture==4u);
    }
    puts("TEST_PASS synergy grip UI: real PL result join, gated release, capture/service, explicit enable, navigation STOP, 800/1024 render");
    return 0;
}

