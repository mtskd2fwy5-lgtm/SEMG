#define PL_CONTROL_ENABLE 1
#define CONTROL_REFERENCE_NO_MAIN 1
#include "control_policy_reference.c"
static u32 accepted_word(u32 epoch,u32 shift,u32 cls,u32 conf,u32 candidate,u32 cc)
{return(epoch<<28)|(shift<<24)|(1u<<23)|(2u<<21)|(cc<<14)|(candidate<<11)|(conf<<3)|cls;}
static void preview(void)
{
    u32 panel,i;char path[160];FILE *file;
    for(panel=0;panel<2u;panel++) {
        lcd_w=panel?1024:800;lcd_h=panel?600:480;
        fb_bpl=(u32)lcd_w*3u;fb_bytes=fb_bpl*(u32)lcd_h;
        lcd_clip_top=0;lcd_clip_bottom=lcd_h;dl_fb_now=fb[0];dl_mode=0;
        pl_control_initialized=1u;pl_control_inflight=pl_control_queued=0;
        pl_control_word=0x504c0006u;ui_preview_cls=-1;
        adc_config_word=0xc0ec0101u;
        lcd_draw_tilt=lcd_draw_shift=0;lcd_hand_snapshot();
        assert(strcmp(pl_control_status_label(0u),"等待数据")==0);
        lcd_render_pose(0u,0u,0u,1u,1u);
        sprintf(path,"report/pl_control_20261023/status_%d.ppm",lcd_w);
        file=fopen(path,"wb");assert(file);
        fprintf(file,"P6\n%d %d\n255\n",lcd_w,lcd_h);
        for(i=0;i<fb_bytes;i+=3u){fputc(fb[0][i+2],file);fputc(fb[0][i+1],file);fputc(fb[0][i],file);}
        fclose(file);
    }
}
int main(void)
{
    u32 command,word,chars;
    parsed_total=16u;g_mode=MODE_MONITOR;
    control_status_reg=0x504c0004u;
    cal_start();pl_control_tick();command=control_command_reg;
    assert(pl_control_inflight && (command&8u) && !pl_control_ready());
    /* An ACK without the matching bundled epoch must not release the request. */
    control_status_reg=0x504c8002u;pl_control_tick();assert(pl_control_inflight);
    control_status_reg=0x504c8002u|(pl_control_epoch<<8);pl_control_tick();
    assert(pl_control_ready() && cal_stage==2u);
    word=accepted_word(pl_control_epoch,0u,2u,91u,2u,91u);
    /* PS gate deliberately says rest. PL word must still act immediately. */
    for(command=0;command<8;command++){cal_thr[command]=0xffffffffu;feat_mav[command]=0;}
    assert(rest_gate());parse_packet(word,(3u<<28)|(6u<<20)|40u);
    assert(pose_active_cls==2u && pose_active_conf==91u && res_rows==1u);
    assert(!pose_pending_count);
    /* Raw argmax packets must never bypass the accepted decision word. */
    parse_packet(1u,(3u<<28)|(5u<<20)|80u);assert(pose_active_cls==2u && res_rows==1u);
    /* Reject old epoch and invalid payloads. */
    pl_control_result(80u,word^(1u<<28));assert(pose_active_cls==2u);
    pl_control_request(3u,0u);pl_control_tick();assert(pl_control_inflight);
    pl_control_result(80u,word);assert(pose_active_cls==2u && res_rows==1u);
    control_status_reg=0x504c0002u|(pl_control_epoch<<8)|(3u<<4);pl_control_tick();
    assert(pl_control_ready());
    word=accepted_word(pl_control_epoch,3u,1u,80u,1u,80u);
    pl_control_result(120u,word);assert(pose_active_cls==1u && res_rows==2u);
    g_mode=MODE_RECORD;chars=uart_char_count;memset(buffer,0,sizeof buffer);
    buffer[0]=accepted_word(pl_control_epoch,3u,3u,90u,3u,90u);
    buffer[1]=(3u<<28)|(6u<<20)|160u;
    record_buffer(buffer);
    assert(pose_active_cls==3u && uart_char_count==chars && res_rows==2u);
    g_mode=MODE_MONITOR;
    control_status_reg|=4u;pl_control_tick();assert(!pl_control_ready() && pose_active_conf==0u);
    pl_control_result(160u,word);assert(res_rows==2u);
    /* Requests arriving while one command is in flight are coalesced, but a
       requested reset must be preserved until it is actually transmitted. */
    pl_control_request(1u,0u);pl_control_tick();command=control_command_reg;
    pl_control_request(4u,1u);pl_control_tick();assert(control_command_reg==command);
    control_status_reg=0x504c0002u|(pl_control_toggle<<15)|(pl_control_epoch<<8)|(1u<<4);
    pl_control_tick();assert((control_command_reg&15u)==12u && pl_control_inflight);
    /* New grip feedback consumes the authoritative PL action plus an exact
       feature-sequence join, rather than scoring a stale display value. */
    control_status_reg=0x504c0002u|(pl_control_toggle<<15)|(pl_control_epoch<<8)|(4u<<4);
    pl_control_tick();assert(pl_control_ready());g_mode=MODE_MONITOR;
    {
        u32 now=rehab_milliseconds(),i,features[8];
        for(i=0u;i<8u;i++)features[i]=(u32)((uint64_t)synergy_w_q15[i][1]*40000u/32768u);
        synergy_feedback_reset(&synergy_feedback);synergy_seq_seen=0u;
        rehab_start(&rehab,0u,2u,1u,1000u,1000u,now);
        rehab.state=RH_CUE;rehab.seen=1u;rehab.sequence=960u;rehab.last_observation=now;
        time_ticks+=25u*GT_TICKS_PER_MS;
        synergy_on_window(features,1000u);
        rehab.effort_enabled=1u;rehab.effort_reference=synergy_feedback.smooth[1];
        word=accepted_word(pl_control_epoch,4u,2u,90u,2u,90u);
        pl_control_result(1000u,word);assert(rehab.matching && rehab.effort_valid);
        time_ticks+=25u*GT_TICKS_PER_MS;
        pl_control_result(1040u,word);assert(!rehab.matching && !rehab.effort_valid);
    }
    puts("TEST_PASS PL firmware mailbox/epoch/authority/no-double-filter/stale/binary-silence/grip-feature-join");
    /* HDC learns user targets from the same feature telemetry. It cannot
       overwrite accepted PL output, request a mapping or change SD labels. */
    {
        u32 i,features[40]={0},saved_pose=pose_active_cls,saved_rows=res_rows;
        u32 saved_command=control_command_reg,saved_label=lcd_action_label;
        rehab.state=RH_IDLE;lcd_hdc_open();hdc_begin(&hdc,6u);
        assert(hdc_available());
        assert(hdc_arm(&hdc,5u));
        for(i=0;i<80u;i++) {
            time_ticks+=25u*GT_TICKS_PER_MS;features[2]=1000u;
            hdc_on_window(features,(u16)(i*40u));
        }
        assert(hdc.fit_n[5]==40u && !hdc.armed);
        assert(pose_active_cls==saved_pose && res_rows==saved_rows);
        assert(control_command_reg==saved_command && lcd_action_label==saved_label);
        assert(hdc_arm(&hdc,5u));pl_control_inflight=1u;hdc_service();
        assert(!hdc.armed && hdc.interruptions==1u);pl_control_inflight=0u;
        lcd_hdc_view=0u;
    }
    puts("TEST_PASS HDC PL firmware: custom-slot learning consumes features, PL output/mailbox/manual labels unchanged, unready interrupts trial");
    /* Navigation and backend changes must cancel queued mechanical motion,
       even before the periodic hand lease service gets another turn. */
    hand_run=2u;hand_qwrite=2u;hand_qread=0u;hand_stop_pending=0u;
    lcd_hand_view=1u;ui_open_page(UI_REHAB);
    assert(!hand_run && hand_qread==hand_qwrite && hand_stop_pending);
    hand_run=2u;hand_stop_pending=0u;hand_qwrite=3u;
    fake_reg=UART_SR_TXEMPTY;mode_set(MODE_RECORD);
    assert(!hand_run && hand_stop_pending && !hand_qwrite);
    fake_reg=UART_SR_TXEMPTY;mode_set(MODE_MONITOR);
    puts("TEST_PASS PL NAV: immediate hand stop on route/backend change, queue canceled, no implicit restart");
    preview();
    return 0;
}
