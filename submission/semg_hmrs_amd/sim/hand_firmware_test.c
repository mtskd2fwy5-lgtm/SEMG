#define PL_CONTROL_ENABLE 1
#define CONTROL_REFERENCE_NO_MAIN 1
#include <math.h>
#include "control_policy_reference.c"
/* Drive real six-axis input through the Q24 model and production consumer.
 * Direct calls to the old PS twist routine would not test the migrated path. */
static void hand_imu_sample(double degrees,int gyro_y,unsigned *seq)
{
    double a=degrees*3.141592653589793/180.0;
    int ax=(int)round(-sin(a)*16384.0),az=(int)round(-cos(a)*16384.0);
    time_ticks+=10u*GT_TICKS_PER_MS-3333u;
    lcd_imu_ingest(((u32)ax&65535u)<<16,((u32)az&65535u)<<16,
                   ((u32)gyro_y&65535u)<<16,0x80000000u|((++*seq&127u)<<24));
}
static void test_rotation_attitude(void)
{
    int i;unsigned seq=0;
    lcd_imu_reset();assert(!imu_hand_rotation_valid);
    for(i=0;i<101;i++)hand_imu_sample(0,0,&seq);
    assert(mpu_zero_valid && imu_hand_rotation_valid);
    for(i=2;i<=260;i+=2) {
        hand_imu_sample(i,-6560,&seq);
        assert(imu_hand_rotation_valid);
        assert(abs(imu_hand_rotation_deg-(i>225?225:i))<=2);
    }
    for(i=258;i>=0;i-=2) {
        hand_imu_sample(i,6560,&seq);
        assert(abs(imu_hand_rotation_deg-(i>225?225:i))<=2);
    }
    for(i=2;i<=90;i+=2) {
        hand_imu_sample(-i,6560,&seq);
        assert(abs(imu_hand_rotation_deg+(i>45?45:i))<=2);
    }
    lcd_imu_reset();assert(!imu_hand_rotation_valid && !imu_hand_rotation_seen);
    puts("TEST_PASS PL attitude consumer: six-axis twist unwrap, -45/+225 limits, reset");
}
static void ack_tick(uint32_t now)
{
    hand_status_reg=0x48010000u|((hand_command_reg>>31)<<23);
    hand_tick(now,1u,0,1u);
}
static void finish_queue(uint32_t now)
{
    uint32_t i;for(i=0;i<200u;i++) {
        ack_tick(now+i);
        if(!hand_inflight && hand_qread==hand_qwrite && !hand_stop_pending)break;
    }
    assert(!hand_inflight && hand_qread==hand_qwrite && !hand_stop_pending);
}
static void render_hand(uint32_t panel,uint32_t view)
{
    uint32_t i;char path[160];FILE *f;
    lcd_w=panel?1024:800;lcd_h=panel?600:480;
    fb_bpl=(u32)lcd_w*3;fb_bytes=fb_bpl*(u32)lcd_h;
    lcd_clip_top=0;lcd_clip_bottom=lcd_h;dl_fb_now=fb[0];dl_mode=0;
    hand_view_mode=view;lcd_hand_view=1u;ui_preview_cls=-1;
    lcd_render_pose(0u,0u,0u,0u,1u);
    sprintf(path,"report/hand_simultaneous_home_20261025/hand_%d_%u_axis%u.ppm",lcd_w,view,hand_axis);
    f=fopen(path,"wb");assert(f);fprintf(f,"P6\n%d %d\n255\n",lcd_w,lcd_h);
    for(i=0;i<fb_bytes;i+=3){fputc(fb[0][i+2],f);fputc(fb[0][i+1],f);fputc(fb[0][i],f);}fclose(f);
}
static void contact(uint32_t x,uint32_t y,uint32_t down)
{
    fake_reg=0x80000000u|(down?0x40000000u:0u)|(x<<12)|y;
    touch_tick();
}
static void tap(uint32_t x,uint32_t y)
{contact(x,y,0u);contact(x,y,1u);}
static void test_live_slider(uint32_t panel)
{
    uint32_t now=20000u+panel*10000u,word,presses,saved,i;
    time_ticks=now*GT_TICKS_PER_MS;rehab_clock_seen=0u;rehab_clock_ms=now;
    rehab_clock_remainder=0u;g_mode=MODE_MONITOR;
    lcd_w=panel?1024:800;lcd_h=panel?600:480;
    ui_open_page(UI_HAND);finish_queue(now);hand_view_mode=0u;hand_axis=1u;
    /* The actual touch path captures a drag. Moves coalesce while the STOP
     * word is awaiting ACK, without changing that word or growing a queue. */
    tap(LCD_X(52)+LCD_X(920)/2,LCD_Y(328));
    assert(hand_slider_drag && hand_run==1u && hand_pulse==1500u);
    hand_status_reg=0x48010000u|((hand_command_reg>>31)<<23);
    hand_tick(now+1u,1u,0,1u);word=hand_command_reg;presses=touch_press_cnt;
    assert((word&0x7fffffffu)==0u && hand_inflight);
    contact(LCD_X(52),LCD_Y(328),1u);assert(hand_pulse==500u);
    contact(LCD_X(972),LCD_Y(328),1u);assert(hand_pulse==2500u);
    hand_tick(now+2u,1u,0,1u);
    assert(hand_command_reg==word && hand_manual_pending && hand_qread==hand_qwrite);
    assert(touch_press_cnt==presses);
    ack_tick(now+3u);
    assert(((hand_command_reg>>27)&15u)==5u &&
           ((hand_command_reg>>24)&7u)==1u && (hand_command_reg&65535u)==2500u);
    assert(!hand_manual_pending);word=hand_command_reg;
    contact(0u,LCD_Y(328),1u);assert(hand_pulse==500u && hand_manual_pending);
    contact((u32)LCD_W-1u,LCD_Y(328),1u);assert(hand_pulse==2500u);
    assert(hand_command_reg==word);ack_tick(now+4u);finish_queue(now+5u);
    /* A stationary held finger renews only the host deadline; the existing
     * PL watchdog receives heartbeats, not an unbounded list of targets. */
    saved=hand_test_until;time_ticks+=100u*GT_TICKS_PER_MS;
    contact(LCD_X(972),LCD_Y(328),1u);
    assert(hand_test_until>saved && !hand_manual_pending);
    ack_tick(now+100u);assert(((hand_command_reg>>27)&15u)==7u);
    contact(LCD_X(972),LCD_Y(328),0u);
    assert(!hand_run && !hand_slider_drag && !hand_manual_pending);
    finish_queue(now+101u);assert((hand_command_reg&0x7fffffffu)==0u);
    /* Fine adjustment drives immediately. A held button acts once. */
    hand_pulse=1500u;tap(LCD_X(800),LCD_Y(370));
    assert(hand_pulse==1550u && hand_run==1u && !hand_slider_drag);
    for(i=0;i<20u;i++)contact(LCD_X(800),LCD_Y(370),1u);
    assert(hand_pulse==1550u);finish_queue(now+150u);
    assert((hand_command_reg&65535u)==1550u);
    tap(LCD_X(375),LCD_Y(260));
    assert(hand_axis==2u && !hand_run && hand_stop_pending && !hand_manual_pending);
    finish_queue(now+160u);
    /* Loss of contact, invalid coordinates, page navigation and explicit
     * STOP all cancel capture and the latest unsent target. */
    tap(LCD_X(52)+LCD_X(920)/2,LCD_Y(328));fake_reg=0u;touch_tick();
    assert(!hand_slider_drag && !hand_run);finish_queue(now+170u);
    tap(LCD_X(52)+LCD_X(920)/2,LCD_Y(328));
    contact((uint32_t)LCD_W,LCD_Y(328),1u);
    assert(!hand_slider_drag && !hand_run);finish_queue(now+180u);
    tap(LCD_X(52)+LCD_X(920)/2,LCD_Y(328));ui_open_page(UI_SETTINGS);
    assert(!hand_slider_drag && !hand_run);finish_queue(now+190u);
    ui_open_page(UI_HAND);finish_queue(now+200u);
    tap(LCD_X(52)+LCD_X(920)/2,LCD_Y(328));tap(LCD_X(900),LCD_Y(130));
    assert(!hand_slider_drag && !hand_run);finish_queue(now+210u);
    /* A fault also releases capture, so a held contact cannot restart it. */
    tap(LCD_X(52)+LCD_X(920)/2,LCD_Y(328));finish_queue(now+220u);
    hand_status_reg=0x48010000u|((hand_command_reg>>31)<<23)|(1u<<21);
    hand_tick(now+221u,1u,0,1u);
    assert(!hand_run && !hand_slider_drag && !hand_manual_pending);
    contact(LCD_X(700),LCD_Y(328),1u);assert(!hand_run);
    hand_stop();finish_queue(now+230u);
    /* Record a limit while that axis is moving: upload begins with STOP. */
    for(i=0u;i<6u;i++){hand_profile.low[i]=500u;hand_profile.high[i]=2500u;}
    hand_profile.cal_mask=4095u;hand_profile.row_mask=7u;
    hand_axis=2u;hand_pulse=1200u;hand_test(rehab_milliseconds());
    tap(LCD_X(450),LCD_Y(440));
    assert(!hand_run && hand_profile.low[2]==1200u && !hand_profile.row_mask);
    finish_queue(now+240u);
    hand_pulse=1800u;hand_test(rehab_milliseconds());
    tap(LCD_X(800),LCD_Y(440));
    assert(!hand_run && hand_profile.high[2]==1800u);finish_queue(now+260u);
    /* Mapping edits preview the selected finger within calibrated travel;
     * the saved target stays unchanged until Record explicitly commits it. */
    hand_view_mode=1u;hand_axis=1u;hand_row=0u;
    hand_profile.low[1]=1000u;hand_profile.high[1]=2000u;
    saved=hand_profile.pose[0][1];
    tap(LCD_X(972),LCD_Y(328));
    assert(hand_pulse==2000u && hand_run==1u && hand_manual_pending);
    assert(hand_profile.pose[0][1]==saved);
    finish_queue(now+270u);
    assert(((hand_command_reg>>27)&15u)==5u &&
           ((hand_command_reg>>24)&7u)==1u && (hand_command_reg&65535u)==2000u);
    contact(LCD_X(972),LCD_Y(328),0u);
    assert(!hand_run && !hand_slider_drag);finish_queue(now+280u);
    tap(LCD_X(100),LCD_Y(370));assert(hand_pulse==1950u && hand_run==1u);
    assert(hand_profile.pose[0][1]==saved);
    tap(LCD_X(100),LCD_Y(440));
    assert(hand_profile.pose[0][1]==1950u && !hand_run && !hand_manual_pending);
    finish_queue(now+290u);
    tap(LCD_X(52),LCD_Y(328));assert(hand_pulse==1000u && hand_run==1u);
    contact(LCD_X(52),LCD_Y(328),0u);finish_queue(now+300u);
    hand_profile.cal_mask=4094u;word=hand_command_reg;
    tap(LCD_X(972),LCD_Y(328));
    assert(!hand_run && !hand_manual_pending && hand_command_reg==word && hand_pulse==1000u);
    contact(LCD_X(972),LCD_Y(328),0u);hand_profile.cal_mask=4095u;
    hand_row=8u;saved=hdc.hand_pose[5][1];
    tap(LCD_X(52)+LCD_X(920)/2,LCD_Y(328));
    assert(hand_pulse==1500u && hand_run==1u && hdc.hand_pose[5][1]==saved);
    contact(LCD_X(52)+LCD_X(920)/2,LCD_Y(328),0u);finish_queue(now+305u);
    tap(LCD_X(100),LCD_Y(440));
    assert(hdc.hand_pose[5][1]==1500u && !hdc.hand_mapped[5] && !hand_run);
    finish_queue(now+310u);
    tap(LCD_X(800),LCD_Y(370));assert(hand_run==1u);
    tap(LCD_X(600),LCD_Y(195));
    assert(hand_row==9u && !hand_run && !hand_manual_pending);finish_queue(now+320u);
    /* A zero-width calibrated range is a fixed target, never division by zero. */
    hand_profile.low[1]=hand_profile.high[1]=1500u;
    tap(LCD_X(972),LCD_Y(328));assert(hand_pulse==1500u && hand_run==1u);
    render_hand(panel,1u);contact(LCD_X(972),LCD_Y(328),0u);finish_queue(now+330u);
    hand_profile.low[1]=500u;hand_profile.high[1]=2500u;hand_row=0u;
    hand_view_mode=0u;hand_axis=1u;hand_pulse=1500u;
    ui_feedback_active=0u;
    puts("TEST_PASS LIVE SLIDER: touch drag/release, ACK/coalescing, axis isolation, fine step/no-repeat, heartbeat, cancel/fault, limit upload, live base/custom mapping with calibrated clamp and explicit save, zero-width range");
}
static uint32_t home_pl_mode;
static void home_tick(uint32_t now)
{
    uint32_t op=(hand_command_reg>>27)&15u;
    if(hand_inflight) {
        if(op==0u)home_pl_mode=0u;
        if(op==5u || op==15u)home_pl_mode=1u;
    }
    hand_status_reg=0x48010002u|((hand_command_reg>>31)<<23)|(home_pl_mode<<19)|
        (home_pl_mode?((1u<<18)|1u):0u);
    /* Home is independent of EMG, MPU and being on the hand-control page. */
    hand_tick(now,0u,200,0u);
}
static void store_home_profile(uint32_t slot,uint32_t generation,uint32_t offset)
{
    uint32_t i;hand_profile_init();hand_profile.generation=generation;
    hand_profile.cal_mask=4095u;hand_profile.row_mask=1u;
    for(i=0u;i<6u;i++) {
        hand_profile.low[i]=500u;hand_profile.high[i]=2500u;
        hand_profile.pose[0][i]=1200u+i*100u+offset;
    }
    hand_profile.crc=hand_crc(&hand_profile);assert(hand_profile_valid(&hand_profile));
    assert(!sd_hand_write(slot,&hand_profile,sizeof hand_profile));
}
static void test_boot_home(void)
{
    uint32_t now,i,seen,started,word,limit,k;HandProfile p;
    hand_stop();finish_queue(50000u);home_pl_mode=0u;
    hand_bank_fail=0u;
    hand_bank_size[0]=hand_bank_size[1]=0u;
    hand_boot_init();assert(hand_home_state==HAND_HOME_SKIPPED && !hand_run);
    finish_queue(50010u);
    store_home_profile(0u,1u,0u);store_home_profile(1u,2u,20u);
    /* Corrupt newest bank falls back to the older valid saved profile. */
    hand_banks[1][36]^=1u;hand_boot_init();
    assert(hand_home_state==HAND_HOME_WAIT && hand_profile.generation==1u);
    hand_stop();finish_queue(50020u);store_home_profile(1u,2u,20u);
    /* Stage six independent targets, commit once, hold without subsequent
     * STOPs or recognition/MPU targets. Second run crosses the ms wrap. */
    for(i=0u;i<2u;i++) {
        hand_boot_init();assert(hand_home_state==HAND_HOME_WAIT && hand_profile.generation==2u);
        home_pl_mode=0u;seen=started=0u;now=i?0xfffffe00u:51000u;
        for(limit=0u;limit<3000u;limit+=10u) {
            word=hand_command_reg;home_tick(now+limit);
            if(word!=hand_command_reg) {
                uint32_t op=(hand_command_reg>>27)&15u,axis=(hand_command_reg>>16)&7u;
                assert(op!=5u && op!=6u && op!=9u && op!=11u);
                if(op==14u) {
                    assert(!home_pl_mode && !started && seen<6u && axis==seen);
                    assert((hand_command_reg&65535u)==(axis?1220u+axis*100u:833u));
                    seen++;
                }
                if(op==15u){assert(seen==6u && !started);started++;}
                if(started)assert(op==15u || op==7u);
            }
            if(hand_home_state==HAND_HOME_DONE)break;
        }
        assert(limit<3000u && seen==6u && started==1u && hand_run==1u && home_pl_mode==1u);
        assert(hand_busy());word=hand_command_reg;
        hand_axis=4u;hand_pulse=2000u;hand_test(now+limit);
        assert(hand_command_reg==word && !hand_manual_pending);
        for(k=limit+10u;k<limit+3010u;k+=10u) {
            word=hand_command_reg;home_tick(now+k);
            assert(hand_home_state==HAND_HOME_DONE && hand_run==1u && home_pl_mode==1u);
            if(word!=hand_command_reg)assert(((hand_command_reg>>27)&15u)==7u);
        }
        hand_stop();for(k=0u;k<100u;k++)home_tick(now+limit+3020u+k);
        assert(hand_home_state==HAND_HOME_CANCELED && !hand_run && !home_pl_mode);
    }
    /* Loading a saved profile manually does not arm another boot sequence. */
    hand_storage_apply(1u);finish_queue(61000u);
    assert(hand_home_state==HAND_HOME_CANCELED && !hand_run);
    hand_boot_init();home_pl_mode=0u;
    for(i=0u;i<100u && hand_home_state!=HAND_HOME_DRIVE;i++)home_tick(62000u+i);
    assert(hand_home_state==HAND_HOME_DRIVE);
    ui_menu_open=1u;tap(LCD_X(920),LCD_Y(55));
    for(i=0u;i<100u;i++)home_tick(62100u+i);
    assert(hand_home_state==HAND_HOME_CANCELED && !hand_run && !home_pl_mode);
    hand_boot_init();home_pl_mode=0u;
    for(i=0u;i<100u && hand_home_state!=HAND_HOME_DRIVE;i++)home_tick(62500u+i);
    assert(hand_home_state==HAND_HOME_DRIVE && hand_inflight);
    hand_status_reg=0x48010000u|(((hand_command_reg>>31)^1u)<<23);
    hand_tick(hand_sent_ms+101u,0u,0,0u);
    assert(hand_home_state==HAND_HOME_CANCELED && hand_link_error==3u && !hand_run);
    for(i=0u;i<100u;i++)home_tick(62700u+i);
    /* Fault while holding must stop, not re-stage or overwrite any target. */
    hand_boot_init();home_pl_mode=0u;
    for(i=0u;i<100u && hand_home_state!=HAND_HOME_DRIVE;i++)home_tick(63000u+i);
    assert(hand_home_state==HAND_HOME_DRIVE);
    hand_status_reg=0x48410000u|((hand_command_reg>>31)<<23)|(1u<<19);
    hand_tick(hand_home_until,0u,0,0u);
    assert(hand_home_state==HAND_HOME_CANCELED && !hand_run);
    home_pl_mode=0u;for(i=0u;i<100u;i++)home_tick(64500u+i);
    /* A legacy PL has no atomic-home capability; do not send unknown ops. */
    hand_boot_init();
    for(i=0u;i<100u && hand_qread!=hand_qwrite;i++)home_tick(64600u+i);
    hand_status_reg=0x48010000u|((hand_command_reg>>31)<<23);
    hand_tick(64710u,0u,0,0u);
    assert(hand_home_state==HAND_HOME_CANCELED && hand_link_error==4u && !hand_run);
    for(i=0u;i<100u;i++)home_tick(64720u+i);
    /* Losing the group-enable status after a valid commit never rearms it. */
    hand_boot_init();home_pl_mode=0u;
    for(i=0u;i<150u && hand_home_state!=HAND_HOME_DRIVE;i++)home_tick(64830u+i);
    home_pl_mode=0u;hand_inflight=0u;
    hand_status_reg=0x48010002u|((hand_command_reg>>31)<<23);
    hand_tick(64990u,0u,0,0u);
    assert(hand_home_state==HAND_HOME_CANCELED && !hand_run);
    for(i=0u;i<100u;i++)home_tick(65000u+i);
    /* Missing full calibration, missing rest map and out-of-range palm zero
     * each refuse homing before emitting any manual target. */
    memcpy(&p,hand_banks[1],sizeof p);
    for(i=0u;i<3u;i++) {
        HandProfile bad=p;
        if(i==0u)bad.cal_mask=4094u;
        if(i==1u)bad.row_mask=0u;
        if(i==2u)bad.low[0]=900u;
        bad.crc=hand_crc(&bad);
        if(i==0u)assert(!hand_profile_valid(&bad));
        else assert(hand_profile_valid(&bad));
        hand_bank_size[0]=0u;assert(!sd_hand_write(1u,&bad,sizeof bad));
        hand_boot_init();assert(hand_home_state==HAND_HOME_SKIPPED && !hand_run);
        finish_queue(66000u+i*100u);assert((hand_command_reg&0x7fffffffu)==0u);
    }
    hand_home_state=HAND_HOME_IDLE;
    puts("TEST_PASS BOOT HOME: SD latest-valid/CRC fallback, saved rest + exact 833us zero, six disabled stages/one atomic commit/continuous hold, no synthetic classifier/MPU or later target overwrite, time wrap, no repeat, header STOP/ACK timeout/fault cancel, legacy PL and lost group refusal, invalid configuration refusal");
}
static void test_hdc_continuous_link(void)
{
    uint32_t d,k,mode=0u,host_ms=0u,rot_ms=0u,target_ms=0u,mask=0u;
    uint32_t staged[6]={0u},committed[6]={0u},commits=0u,ack;
    uint32_t now=20000u,last_seq_ms=now;uint16_t seq=65496u;
    hand_stop();finish_queue(now-10u);hand_home_state=HAND_HOME_IDLE;
    ack=hand_command_reg>>31;
    assert(hdc_begin(&hdc,2u));hdc.stage=HDC_DONE;
    for(k=0u;k<2u;k++) {
        hdc.fit_n[k]=HDC_FIT_WINDOWS;hdc.val_n[k]=HDC_VAL_WINDOWS;
        hdc.hdc_cm[k][k]=HDC_VAL_WINDOWS;
    }
    for(k=0u;k<6u;k++) {
        hand_profile.low[k]=500u;hand_profile.high[k]=2500u;
        hdc.hand_pose[0][k]=1400u;hdc.hand_pose[1][k]=1800u;
    }
    hand_profile.cal_mask=4095u;hdc.hand_mapped[0]=1u;
    hand_hdc_reset();
    for(k=0u;k<3u;k++)
        hand_hdc_observe(now-75u+k*25u,(uint16_t)(seq-120u+k*40u),0u,1u);
    hand_rotation_valid=1u;hand_auto_hdc();assert(hand_run==3u);
    for(d=0u;d<=3500u;d+=5u) {
        now=20000u+d;
        /* ACK the actual production driver's previously issued word. Model
         * all three independent PL leases and atomic five-finger commits. */
        if(hand_inflight && now-hand_sent_ms>=15u) {
            uint32_t op=(hand_command_reg>>27)&15u,axis=(hand_command_reg>>16)&7u;
            ack=hand_command_reg>>31;
            if(op==0u){mode=0u;mask=0u;}
            if(op==7u)host_ms=now;
            if(op==9u)rot_ms=now;
            if(op==12u){staged[axis]=hand_command_reg&65535u;mask|=1u<<axis;}
            if(op==13u) {
                assert(mask==62u);
                memcpy(committed,staged,sizeof committed);
                mask=0u;target_ms=now;commits++;
            }
            if(op==11u){assert(commits);mode=3u;host_ms=now;}
        }
        if(d==2000u)hdc.hand_mapped[1]=1u;
        if(d%25u==0u) {
            uint32_t cls=d<1250u || d>=2800u?0u:1u;
            uint32_t evidence=d>=200u && d<1250u?2u:1u;
            if(d==1000u)seq=(uint16_t)(seq+40u); /* skipped feature window */
            hand_hdc_observe(now,seq,cls,evidence);
            seq=(uint16_t)(seq+40u);last_seq_ms=now;
        }
        hand_status_reg=0x48010000u|(mode<<19)|(ack<<23);
        hand_tick(now,1u,0,1u);
        assert(hand_run==3u);
        if(mode==3u) {
            assert(now-host_ms<250u && now-rot_ms<250u && now-target_ms<250u);
            for(k=1u;k<6u;k++)assert(committed[k]==committed[1]);
            if(d>=1400u && d<2000u)assert(committed[1]==1400u);
            if(d>=2200u && d<2800u)assert(committed[1]==1800u);
            /* At a deliberately slow 15ms per mailbox command, the old
             * five-axis transaction must finish before the new one commits. */
            if(d>=3150u)assert(committed[1]==1400u);
        }
    }
    assert(commits>10u);
    /* No fresh HDC packets: the user enable is revoked, never auto-rearmed. */
    hand_status_reg=0x48010000u|(3u<<19)|((hand_command_reg>>31)<<23);
    hand_tick(last_seq_ms+251u,1u,0,1u);
    assert(!hand_run);
    finish_queue(last_seq_ms+252u);
    hdc.hand_mapped[1]=1u;hand_rotation_valid=1u;
    for(k=0u;k<3u;k++,seq=(uint16_t)(seq+40u))
        hand_hdc_observe(last_seq_ms+300u+k*25u,seq,0u,1u);
    assert(hand_hdc_valid && !hand_run);
    printf("TEST_PASS HDC continuous link: 3.5s production ACK/leases (15ms ACK latency), %u target commits, ambiguity and sequence skip hold, unmapped hold, mapped atomic switches, dropout stops without rearm\n",commits);
}
static void test_hdc_stability(void)
{
    uint32_t i,now=10000u;uint16_t seq=65496u;
    static const uint32_t cls[]={39u,38u,39u,39u};
    hand_run=0u;hand_hdc_reset();
    /* A single wrong class no longer restarts all evidence. Full-width IDs,
     * sequence wrap and time wrap must behave like the real feature stream. */
    for(i=0u;i<4u;i++,now+=25u,seq=(uint16_t)(seq+40u)) {
        hand_hdc_observe(now,seq,cls[i],1u);
        assert(hand_hdc_valid==(i==3u));
    }
    assert(hand_hdc_class==39u);
    hand_hdc_observe(now,seq,38u,2u);now+=25u;seq=(uint16_t)(seq+40u);
    assert(hand_hdc_valid && hand_hdc_class==39u);
    hand_hdc_observe(now,seq,39u,1u);now+=25u;seq=(uint16_t)(seq+40u);
    assert(hand_hdc_valid && hand_hdc_class==39u);
    /* Three fresh strong windows still switch a genuine new gesture. */
    for(i=0u;i<3u;i++,now+=25u,seq=(uint16_t)(seq+40u))
        hand_hdc_observe(now,seq,38u,1u);
    assert(hand_hdc_valid && hand_hdc_class==38u);
    /* Continuous but ambiguous HDC windows keep the last accepted gesture
     * linked; only a stale stream or hard-invalid data may stop the output. */
    hand_run=3u;
    for(i=0u;i<40u;i++,now+=25u,seq=(uint16_t)(seq+40u)) {
        hand_hdc_observe(now,seq,38u,2u);
        assert(hand_run==3u);
    }
    assert(!hand_hdc_valid);
    hand_run=0u;
    /* Startup abstentions and 3:3 alternating predictions never confirm. */
    hand_hdc_reset();
    for(i=0u;i<40u;i++,now+=25u,seq=(uint16_t)(seq+40u)) {
        hand_hdc_observe(now,seq,5u+i%2u,1u);assert(!hand_hdc_valid);
    }
    hand_hdc_reset();
    for(i=0u;i<20u;i++,now+=25u,seq=(uint16_t)(seq+40u)) {
        hand_hdc_observe(now,seq,5u,2u);assert(!hand_hdc_valid);
    }
    /* A weak window and an isolated error can be tolerated during acquisition. */
    hand_hdc_reset();
    for(i=0u;i<5u;i++,now+=25u,seq=(uint16_t)(seq+40u)) {
        hand_hdc_observe(now,seq,i==3u?6u:5u,i==1u?2u:1u);
        assert(hand_hdc_valid==(i==4u));
    }
    /* The removed fixed relax class no longer has a stricter rule: class 0 is
       an ordinary custom gesture and confirms with the same 3-of-6 vote. */
    hand_hdc_reset();
    for(i=0u;i<5u;i++,now+=25u,seq=(uint16_t)(seq+40u)) {
        hand_hdc_observe(now,seq,0u,i==2u?2u:1u);
        assert(hand_hdc_valid==(i>=3u));
    }
    assert(hand_hdc_class==0u);
    /* Invalid data (including excessive clipping/model loss) remains hard STOP. */
    hand_run=3u;hand_hdc_observe(now,seq,0u,0u);
    assert(!hand_hdc_valid && !hand_run && hand_stop_pending);
    hand_stop_pending=0u;hand_hdc_reset();
    now=0xffffffc0u;
    for(i=0u;i<3u;i++,now+=25u,seq=(uint16_t)(seq+40u))
        hand_hdc_observe(now,seq,39u,1u);
    assert(hand_hdc_valid && hand_hdc_class==39u);
    hand_hdc_observe(now+251u,seq,39u,1u);assert(!hand_hdc_valid);
    /* Wall-clock bound applies even when the packet sequence stays consecutive. */
    hand_hdc_reset();now=20000u;
    for(i=0u;i<3u;i++,now+=25u,seq=(uint16_t)(seq+40u))
        hand_hdc_observe(now,seq,39u,1u);
    hand_run=3u;hand_hdc_observe(now+225u,seq,39u,2u);
    assert(!hand_hdc_valid && hand_run==3u);
    hand_run=0u;hand_hdc_reset();
    /* Sub-percent positive margins can confirm, with stronger persistence.
     * Exact ties retain evidence2 and never count as qualified votes. */
    for(i=0u;i<8u;i++,now+=25u,seq=(uint16_t)(seq+40u)) {
        hand_hdc_observe(now,seq,39u,3u);assert(hand_hdc_valid==(i>=5u));
    }
    assert(hand_hdc_class==39u);
    hand_hdc_reset();
    for(i=0u;i<32u;i++,now+=25u,seq=(uint16_t)(seq+40u)) {
        hand_hdc_observe(now,seq,38u+i%2u,3u);assert(!hand_hdc_valid);
    }
    hand_hdc_reset();
    puts("TEST_PASS HDC precise stability: six-of-eight weak votes, alternating weak ambiguity rejected, exact ties abstain");
    puts("TEST_PASS HDC stability: isolated error/abstention, rival hysteresis, 75ms clean transition, 250ms decision expiry with link retained, uniform custom-class debounce, full class IDs, sequence/time wrap, hard invalidation");
}

int main(void)
{
    uint32_t i,j,panel,word;HandProfile previous;
    test_rotation_attitude();
    test_hdc_stability();
    g_mode=MODE_MONITOR;
    hand_profile_init();assert(hand_profile.cal_mask==0 && hand_profile.row_mask==0);
    hand_profile.crc=hand_crc(&hand_profile);assert(hand_profile_valid(&hand_profile));
    hand_profile.pose[0][0]++;assert(!hand_profile_valid(&hand_profile));hand_profile_init();
    hand_status_reg=0x48010000u;hand_tick(0,1,0,1u);assert(hand_inflight);
    word=hand_command_reg;hand_enqueue(6,0,0,0);
    hand_tick(1,1,0,1u);assert(hand_command_reg==word && hand_inflight);
    hand_stop();ack_tick(2);assert((hand_command_reg&0x7fffffffu)==0u);
    finish_queue(3);assert(hand_qread==hand_qwrite && !hand_run);
    hand_axis=2;hand_pulse=1200;hand_test(200);finish_queue(201);
    assert(hand_run==1);
    hand_tick(1250,1,0,1u);assert(!hand_run);finish_queue(1251);
    hand_test(1400);ack_tick(1401);hand_tick(1402,0,0,1u);ack_tick(1403);finish_queue(1404);assert(!hand_run);
    // An ACK timeout must discard a late queued enable, never resurrect it.
    hand_enqueue(6,0,0,0);hand_tick(1700,1,0,1u);word=hand_command_reg;
    hand_status_reg=(hand_status_reg&~(1u<<23))|((!(word>>31))<<23);
    hand_tick(1802,1,0,1u);assert(hand_link_error==3 && hand_qread==hand_qwrite && hand_stop_pending);
    finish_queue(1803);
    hand_enqueue(6,0,0,0);hand_status_reg=0u;hand_tick(1900,1,0,1u);
    assert(hand_link_error==1 && hand_qread==hand_qwrite && !hand_run);
    finish_queue(1901);
    hand_test(0xffffff00u);finish_queue(0xffffff01u);
    ack_tick(0x100u);assert(hand_run==1u);
    ack_tick(0x400u);assert(hand_run==0u);finish_queue(0x401u);
    for(i=0;i<6;i++){hand_profile.low[i]=900;hand_profile.high[i]=2100;}
    hand_profile.cal_mask=4095;
    for(j=0;j<8;j++)for(i=0;i<6;i++)hand_profile.pose[j][i]=1500;
    hand_profile.row_mask=31;hand_upload();finish_queue(2000);
    assert(hand_profile.row_mask==7u); /* Ignore legacy wrist mappings. */
    hand_storage_apply(2);assert(!hand_io_error && hand_bank_size[0]==sizeof hand_profile);
    previous=hand_profile;hand_profile.pose[0][0]=1600;hand_storage_apply(2);
    assert(!hand_io_error && hand_bank_size[1]==sizeof hand_profile);
    hand_banks[1][36]^=1;hand_storage_apply(1);assert(!hand_io_error);
    assert(hand_profile.pose[0][0]==previous.pose[0][0]);finish_queue(2300);
    hand_bank_fail=1;hand_profile.pose[0][0]=1700;hand_storage_apply(2);assert(hand_io_error);
    hand_storage_apply(1);assert(!hand_io_error && hand_profile.pose[0][0]==1500);finish_queue(2500);
    hand_rotation_valid=0;hand_auto();assert(!hand_run);
    hand_tick(3000,1,0,1);hand_auto();assert(hand_run==2u);
    assert(((hand_queue[hand_qwrite-2]>>27)&15u)==9u);
    assert(((hand_queue[hand_qwrite-1]>>27)&15u)==6u);
    finish_queue(3001);
    hand_profile.low[0]=500u;hand_profile.high[0]=2500u;
    for(i=0;i<7u;i++) {
        static const int32_t degrees[]={-500,-45,0,90,180,225,500};
        static const uint32_t pulses[]={500,500,833,1500,2167,2500,2500};
        uint32_t now=3300u+i*30u;
        hand_status_reg=0x48010000u|((hand_command_reg>>31)<<23);
        hand_lease_ms=now;hand_rotation_sent_ms=now-20u;
        hand_rotation_sent=0xffffffffu;
        hand_tick(now,1,degrees[i],1);
        assert(((hand_command_reg>>27)&15u)==9u && (hand_command_reg&65535u)==pulses[i]);
    }
    hand_profile.low[0]=900u;hand_profile.high[0]=2100u;
    hand_status_reg=0x48010000u|((hand_command_reg>>31)<<23);
    hand_lease_ms=3490u;hand_rotation_sent_ms=3400u;hand_rotation_sent=0xffffffffu;
    hand_tick(3490u,1,225,1);assert((hand_command_reg&65535u)==2100u);
    // Loss of calibration/link cancels even a queued automatic enable.
    hand_status_reg=0x48010000u|((hand_command_reg>>31)<<23);
    hand_tick(3500,1,0,0);assert(!hand_run && hand_qread==hand_qwrite);
    assert((hand_command_reg&0x7fffffffu)==0u);finish_queue(3501);
    // A validated frozen model is required; the bridge never uses UI targets.
    // A one-class library has no rival (PL margin is 0), so it is refused
    // explicitly instead of silently waiting for a stable gesture.
    assert(hdc_begin(&hdc,1u));hdc.stage=HDC_DONE;
    hdc.fit_n[0]=120u;hdc.val_n[0]=80u;hdc.hdc_cm[0][0]=80u;
    assert(!hdc_hand_model_ready());
    assert(hdc_begin(&hdc,8u));hdc.stage=HDC_VALIDATE;
    assert(!hdc_hand_model_ready());hdc.stage=HDC_DONE;
    for(i=0;i<8u;i++){hdc.fit_n[i]=120u;hdc.val_n[i]=80u;hdc.hdc_cm[i][i]=80u;}
    assert(hdc_hand_model_ready());hdc.hdc_cm[5][5]=63u;assert(!hdc_hand_model_ready());
    hdc.hdc_cm[5][5]=64u;assert(hdc_hand_model_ready());
    hand_hdc_reset();
    for(i=0;i<3u;i++)hand_hdc_observe(3600u+i*25u,(uint16_t)(i*40u),5u,1u);
    assert(hand_hdc_valid && hand_hdc_class==5u);
    hand_rotation_valid=1u;hand_auto_hdc();assert(!hand_run);
    for(i=1u;i<6u;i++)hdc.hand_pose[5][i]=1550u;
    hdc.hand_mapped[5]=1u;hand_auto_hdc();assert(hand_run==3u);
    assert(((hand_queue[hand_qwrite-2]>>27)&15u)==13u && ((hand_queue[hand_qwrite-1]>>27)&15u)==11u);
    assert((hand_queue[hand_qwrite-1]&65535u)==1u);
    for(i=0u;i<5u;i++)assert(((hand_queue[hand_qwrite-7u+i]>>27)&15u)==12u);
    finish_queue(3660);
    assert(hand_run==3u && hand_hdc_sent_generation==hand_hdc_generation);
    hand_stop();finish_queue(3700);
    hand_hdc_observe(3700u,120u,6u,1u);assert(hand_hdc_class==5u);
    hand_hdc_observe(3725u,160u,6u,1u);assert(hand_hdc_class==5u);
    hand_hdc_observe(3750u,200u,6u,1u);assert(hand_hdc_class==6u);
    hand_hdc_observe(3775u,240u,7u,0u);assert(!hand_hdc_valid);
    for(i=0;i<3u;i++)hand_hdc_observe(3800u+i*25u,(uint16_t)(i*40u),7u,1u);
    hand_run=3u;hand_hdc_observe(3900u,400u,7u,1u);assert(hand_run==3u && !hand_hdc_valid);
    hand_stop();
    finish_queue(3901);
    assert(hand_next_row(2u)==3u && hand_next_row(5u)==6u && hand_next_row(6u)==7u && hand_next_row(10u)==0u);
    /* High IDs are targets rather than truncated 3-bit rows. */
    assert(hdc_reserve(&hdc,40u));hdc.classes=40u;hdc.stage=HDC_DONE;
    for(i=8u;i<40u;i++){hdc.fit_n[i]=120u;hdc.val_n[i]=80u;hdc.hdc_cm[i][i]=80u;}
    for(i=1u;i<6u;i++)hdc.hand_pose[39][i]=1750u;
    hdc.hand_mapped[39]=1u;assert(hdc_hand_model_ready());
    hand_hdc_reset();
    for(i=0u;i<3u;i++)hand_hdc_observe(4000u+i*25u,(uint16_t)(i*40u),39u,1u);
    hand_rotation_valid=1u;hand_auto_hdc();assert(hand_run==3u);
    for(i=0u;i<5u;i++)assert((hand_queue[hand_qwrite-7u+i]&65535u)==1750u);
    finish_queue(4060u);
    for(i=0u;i<3u;i++)hand_hdc_observe(4100u+i*25u,(uint16_t)(120u+i*40u),38u,1u);
    ack_tick(4160u);assert(hand_run==3u && hand_hdc_valid && hand_hdc_class==38u);
    assert(hand_hdc_target_class==39u); /* Unmapped new class holds safe target. */
    hand_stop();finish_queue(4161u);hand_auto_hdc();assert(!hand_run);
    hdc.fit_n[35]=0u;assert(!hand_row_available(38u));
    assert(hand_next_row(37u)==39u && hand_next_row(39u)==40u && hand_next_row(42u)==0u);
    /* The first custom class follows the same 3-of-6 rule as every other. */
    hand_hdc_reset();
    for(i=0;i<3u;i++)hand_hdc_observe(4200u+i*25u,(uint16_t)(480u+i*40u),0u,1u);
    assert(hand_hdc_valid && hand_hdc_class==0u);hand_hdc_reset();
    puts("TEST_PASS hand bridge: one-class library refused, uniform 3-of-6 stability for every custom class");
    hdc.classes=8u;
    for(panel=0;panel<2;panel++) {
        test_live_slider(panel);
        time_ticks=GT_TICKS_PER_MS*2600u;
        rehab_clock_seen=0u;rehab_clock_ms=2600u;rehab_clock_remainder=0u;
        for(i=0u;i<6u;i++) {
            hand_axis=i;
            render_hand(panel,0);
            if(i)render_hand(panel,1);
        }
        hand_view_mode=0;lcd_hand_view=0;lcd_settings_view=1;
        ui_touch_press(LCD_X(820),LCD_Y(115));assert(lcd_hand_view);finish_queue(2700);
        ui_touch_press(LCD_X(370),LCD_Y(260));assert(hand_axis==2);
        hand_pulse=1500;ui_touch_press(LCD_X(780),LCD_Y(370));assert(hand_pulse==1550);
        ui_touch_press(LCD_X(80),LCD_Y(440));assert(hand_run==1);finish_queue(2800);
        ui_menu_open=1;ui_touch_press(LCD_X(900),LCD_Y(55));
        assert(!hand_run && hand_stop_pending);finish_queue(2900);
        ui_menu_open=0;hand_view_mode=1;hand_axis=1;hand_row=0;
        ui_touch_press(LCD_X(80),LCD_Y(260));assert(hand_axis==1u);
        for(i=0;i<6u;i++) {
            static const uint32_t rows[]={1,2,3,4,5,6};
            ui_touch_press(LCD_X(600),LCD_Y(195));assert(hand_row==rows[i]);
        }
        hand_source_hdc=0;
        ui_touch_press(LCD_X(80),LCD_Y(490));assert(hand_source_hdc);
        ui_touch_press(LCD_X(80),LCD_Y(490));assert(!hand_source_hdc);
    }
    test_hdc_continuous_link();
    test_boot_home();
    puts("TEST_PASS hand firmware: ACK, STOP priority, manual expiry, CRC recovery, MPU quaternion/range/loss, validated HDC/queue/debounce, live mapping, boot homing, both panels");
    return 0;
}

