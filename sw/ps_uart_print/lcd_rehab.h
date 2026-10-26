/* Training UI uses the existing touch dispatcher, stable-pose observations and
 * coalesced renderer. All time is accumulated from GT deltas, including wrap. */
#ifndef LCD_REHAB_H
#define LCD_REHAB_H
static const u32 rehab_reps[]={3u,5u,10u};
static const u32 rehab_holds[]={1000u,2000u,3000u,5000u};
static const u32 rehab_rests[]={2000u,3000u,5000u};
static u32 rehab_clock_seen,rehab_clock_last,rehab_clock_remainder,rehab_clock_ms;
static u32 rehab_refresh_ms,rehab_save_error,rehab_autosave=1u;
static char rehab_report_name[13];
static u32 rehab_setup_stage,rehab_contact_checked,rehab_comfort_checked,rehab_group_rest_sel;
static const u32 rehab_group_rests[]={15000u,30000u,60000u};

static u32 rehab_prepared(void)
{
    return lcd_rehab_view && !ui_menu_open && rehab_setup_stage &&
        rehab_contact_checked && rehab_comfort_checked &&
        g_mode==MODE_MONITOR && !sd_record_active() && cal_stage==2u && pl_control_ready();
}

static u32 rehab_milliseconds(void)
{
    u32 ticks=gt_stamp(),delta;
    if(!rehab_clock_seen) {rehab_clock_seen=1u;rehab_clock_last=ticks;return rehab_clock_ms;}
    delta=ticks-rehab_clock_last;rehab_clock_last=ticks;
    rehab_clock_ms+=delta/GT_TICKS_PER_MS;
    rehab_clock_remainder+=delta%GT_TICKS_PER_MS;
    if(rehab_clock_remainder>=GT_TICKS_PER_MS) {
        rehab_clock_ms++;rehab_clock_remainder-=GT_TICKS_PER_MS;
    }
    return rehab_clock_ms;
}

static void lcd_rehab_open(void)
{
    ui_open_page(UI_REHAB);
}

static void rehab_service(void)
{
    u32 now=rehab_milliseconds();
    synergy_feedback_tick(&synergy_feedback,now);
    if((synergy_feedback.capture==1u || synergy_feedback.capture==2u) &&
       (!lcd_rehab_view || ui_menu_open || g_mode!=MODE_MONITOR))
        synergy_feedback.capture=4u;
    if((!lcd_rehab_view || ui_menu_open) && rehab_running(&rehab))
        rehab_pause(&rehab,RH_REASON_USER,now);
    rehab_tick(&rehab,now,cal_stage==2u && g_mode==MODE_MONITOR && pl_control_ready());
    if(rehab.state==RH_DONE && !rehab.save_state && rehab_autosave) {
        rehab.save_state=1u;ui_rehab_action=4u;
    }
    if(lcd_rehab_view && (rehab.changed || now-rehab_refresh_ms>=100u)) {
        rehab_refresh_ms=now;rehab.changed=0u;lcd_pending=1u;
    }
}

/* CSV builder is bounded; numeric fields do not need libc printf on ARM. */
static char rehab_csv[16384];
static u32 rehab_csv_n,rehab_csv_overflow;
static void rehab_csv_text(const char *s)
{
    while(*s) {
        if(rehab_csv_n>=sizeof rehab_csv-1u) {rehab_csv_overflow=1u;return;}
        rehab_csv[rehab_csv_n++]=*s++;
    }
    rehab_csv[rehab_csv_n]=0;
}
static void rehab_csv_number(u32 v)
{
    char digits[11];u32 n=0u;
    do {digits[n++]=(char)('0'+v%10u);v/=10u;}while(v);
    while(n) {char s[2];s[0]=digits[--n];s[1]=0;rehab_csv_text(s);}
}
static void rehab_csv_meta(const char *key,u32 value)
{
    rehab_csv_text("meta,,,,,,,,,");rehab_csv_text(key);rehab_csv_text(",");
    rehab_csv_number(value);rehab_csv_text("\r\n");
}

static void rehab_save_report(void)
{
    u32 i;
    if(rehab.state!=RH_DONE)return;
    rehab_csv_n=rehab_csv_overflow=0u;
    rehab_csv_text("kind,index,target,success,response_ms,hold_ms,breaks,duration_ms,reserved,key,value\r\n");
    rehab_csv_text("meta,,,,,,,,,firmware," BUILD_TAG "\r\n");
    rehab_csv_text("meta,,,,,,,,,model,nn_int8_board_multiwear\r\n");
    rehab_csv_text(rehab.effort_enabled?
        "meta,,,,,,,,,response_definition,cue_to_supported_pose_and_grip_band\r\n":
        "meta,,,,,,,,,response_definition,cue_to_first_supported_stable_pose\r\n");
    rehab_csv_text("meta,,,,,,,,,result_definition,recognizer_task_completion_not_clinical_assessment\r\n");
    rehab_csv_meta("combination",rehab.combination);
    rehab_csv_meta("single_action",rehab.action);
    rehab_csv_meta("repetitions",rehab.repetitions);
    rehab_csv_meta("planned",rehab.total);rehab_csv_meta("attempted",rehab.attempted);
    rehab_csv_meta("successes",rehab.successes);rehab_csv_meta("timeouts",rehab.failures);
    rehab_csv_meta("aborted",rehab.aborted);rehab_csv_meta("active_elapsed_ms",rehab.elapsed_ms);
    rehab_csv_meta("hold_required_ms",rehab.hold_ms);rehab_csv_meta("rest_required_ms",rehab.rest_ms);
    rehab_csv_text("meta,,,,,,,,,use_scope,research_healthy_volunteers\r\n");
    rehab_csv_meta("group_every_trials",rehab.group_every);
    rehab_csv_meta("group_rest_ms",rehab.group_rest_ms);
    rehab_csv_meta("group_breaks",rehab.groups_completed);rehab_csv_meta("pause_count",rehab.pause_count);
    rehab_csv_meta("contact_review_confirmed",rehab_contact_checked);
    rehab_csv_meta("comfort_confirmed",rehab_comfort_checked);
    rehab_csv_meta("support_threshold",REHAB_SUPPORT_MIN);
    rehab_csv_meta("grip_effort_enabled",rehab.effort_enabled);
    rehab_csv_meta("grip_reference_c2_q8",rehab.effort_reference);
    rehab_csv_meta("grip_lower_percent",80u);rehab_csv_meta("grip_upper_percent",120u);
    rehab_csv_meta("grip_windows",rehab.effort_samples);
    rehab_csv_meta("grip_supported_in_band_windows",rehab.effort_in_band);
    rehab_csv_text("meta,,,,,,,,,grip_definition,relative_emg_c2_not_force\r\n");
    for(i=0u;i<8u;i++) {
        char key[]="rest_mav_ch1";key[11]=(char)('1'+i);rehab_csv_meta(key,cal_base[i]);
    }
    for(i=0u;i<rehab.attempted;i++) {
        const rehab_trial_t *t=&rehab.trials[i];
        rehab_csv_text("trial,");rehab_csv_number(i+1u);rehab_csv_text(",");
        rehab_csv_number(t->target);rehab_csv_text(",");rehab_csv_number(t->success);rehab_csv_text(",");
        rehab_csv_number(t->response_ms);rehab_csv_text(",");rehab_csv_number(t->hold_ms);rehab_csv_text(",");
        rehab_csv_number(t->breaks);rehab_csv_text(",");rehab_csv_number(t->duration_ms);
        rehab_csv_text(",,,\r\n");
    }
    rehab_save_error=rehab_csv_overflow?0x305u:
        sd_training_save(rehab_csv,rehab_csv_n,rehab_report_name);
    rehab.save_state=rehab_save_error?3u:2u;rehab.changed=1u;
}

/* Runs outside the DMA parser, like the existing SD/menu actions. A training
 * task never changes waveform labels: its cues are not ground-truth labels. */
static void rehab_apply_action(u32 action)
{
    u32 now=rehab_milliseconds();
    if(action==1u && !rehab_running(&rehab)) {
        if(rehab.state!=RH_IDLE || !rehab_prepared())return;
        if(synergy_feedback.capture==1u || synergy_feedback.capture==2u)return;
        if(rehab_effort_enabled && (rehab_combo || rehab_action==2u) && !synergy_feedback.reference)return;
        rehab_start(&rehab,rehab_combo,rehab_action,rehab_reps[rehab_reps_sel],
                    rehab_holds[rehab_hold_sel],rehab_rests[rehab_rest_sel],now);
        rehab.effort_enabled=rehab_effort_enabled && (rehab_combo || rehab_action==2u);
        rehab.effort_reference=synergy_feedback.reference;
        rehab.group_every=rehab_combo?4u:3u;
        rehab.group_rest_ms=rehab_group_rests[rehab_group_rest_sel];
        hand_stop();hdc_interrupt(&hdc);
        rehab_report_name[0]=0;rehab_save_error=0u;cal_start();
    } else if(action==2u) {
        if(!lcd_rehab_view || ui_menu_open)return;
        if(rehab.state==RH_PAUSED) {
            if(g_mode!=MODE_MONITOR || sd_record_active())return;
            rehab_resume(&rehab,now);cal_start();
        } else rehab_pause(&rehab,RH_REASON_USER,now);
    } else if(action==3u)rehab_finish(&rehab,now,1u);
    else if(action==4u)rehab_save_report();
    else if(action==6u && lcd_rehab_view && !ui_menu_open)rehab_continue_group(&rehab,now);
    else if(action==5u && lcd_rehab_view && !ui_menu_open && rehab.state==RH_IDLE && g_mode==MODE_MONITOR && !sd_record_active())
        synergy_feedback_capture(&synergy_feedback,now);
    ui_generation++;lcd_input_status_changed();
}

static void lcd_rehab_touch(u32 x,u32 y)
{
    u32 i;
    if(rehab_running(&rehab)) {
        if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(516),LCD_X(300),LCD_Y(62)))
            ui_rehab_action=rehab.state==RH_GROUP_REST?6u:2u;
        else if(lcd_wave_hit(x,y,LCD_X(356),LCD_Y(516),LCD_X(300),LCD_Y(62)))ui_rehab_action=3u;
        return;
    }
    if(rehab.state==RH_DONE) {
        if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(516),LCD_X(300),LCD_Y(62))) {
            rehab.state=RH_IDLE;rehab_setup_stage=rehab_contact_checked=rehab_comfort_checked=0u;
            rehab.changed=1u;ui_generation++;lcd_input_status_changed();
        } else if(lcd_wave_hit(x,y,LCD_X(356),LCD_Y(516),LCD_X(300),LCD_Y(62)) && rehab.save_state!=2u)
            ui_rehab_action=4u;
        return;
    }
    if(rehab_setup_stage) {
        if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(205),LCD_X(968),LCD_Y(58))) {
            rehab_contact_checked=!rehab_contact_checked;goto changed;
        }
        if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(279),LCD_X(968),LCD_Y(58))) {
            rehab_comfort_checked=!rehab_comfort_checked;goto changed;
        }
        for(i=0u;i<3u;i++)if(lcd_wave_hit(x,y,LCD_X(230)+(i32)i*LCD_X(250),LCD_Y(383),LCD_X(224),LCD_Y(54))) {
            rehab_group_rest_sel=i;goto changed;
        }
        if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(516),LCD_X(300),LCD_Y(62)))ui_rehab_action=1u;
        else if(lcd_wave_hit(x,y,LCD_X(356),LCD_Y(516),LCD_X(300),LCD_Y(62))) {rehab_setup_stage=0u;goto changed;}
        else if(lcd_wave_hit(x,y,LCD_X(690),LCD_Y(516),LCD_X(306),LCD_Y(62)))ui_action=3u;
        return;
    }
    if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(474),LCD_X(240),LCD_Y(34))) {
        rehab_effort_enabled=!rehab_effort_enabled;goto changed;
    }
    if(lcd_wave_hit(x,y,LCD_X(280),LCD_Y(474),LCD_X(210),LCD_Y(34))) {
        ui_rehab_action=5u;return;
    }
    for(i=0u;i<2u;i++)
        if(lcd_wave_hit(x,y,LCD_X(230)+(i32)i*LCD_X(370),LCD_Y(146),LCD_X(340),LCD_Y(54))) {
            rehab_combo=i;goto changed;
        }
    for(i=0u;i<4u;i++)
        if(lcd_wave_hit(x,y,LCD_X(230)+(i32)i*LCD_X(190),LCD_Y(212),LCD_X(174),LCD_Y(50))) {
            rehab_action=i+1u;goto changed;
        }
    for(i=0u;i<3u;i++) {
        if(lcd_wave_hit(x,y,LCD_X(230)+(i32)i*LCD_X(250),LCD_Y(278),LCD_X(224),LCD_Y(50))) {
            rehab_reps_sel=i;goto changed;
        }
        if(lcd_wave_hit(x,y,LCD_X(230)+(i32)i*LCD_X(250),LCD_Y(410),LCD_X(224),LCD_Y(50))) {
            rehab_rest_sel=i;goto changed;
        }
    }
    for(i=0u;i<4u;i++)
        if(lcd_wave_hit(x,y,LCD_X(230)+(i32)i*LCD_X(190),LCD_Y(344),LCD_X(174),LCD_Y(50))) {
            rehab_hold_sel=i;goto changed;
        }
    if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(516),LCD_X(300),LCD_Y(62))) {
        rehab_setup_stage=1u;rehab_contact_checked=rehab_comfort_checked=0u;goto changed;
    }
    else if(lcd_wave_hit(x,y,LCD_X(690),LCD_Y(516),LCD_X(306),LCD_Y(62))) {
        rehab_autosave=!rehab_autosave;goto changed;
    }
    return;
changed:
    ui_generation++;lcd_input_status_changed();
}

static void rehab_metric(i32 x,i32 y,i32 w,const char *prefix,u32 n,const char *suffix)
{
    char label[48];lcd_analysis_label(label,sizeof label,prefix,n,suffix);
    ui_label(LCD_X(x),LCD_Y(y),LCD_X(w),2,31,49,58,label);
}

static void rehab_on_result(u32 seq,u32 accepted,u32 candidate,u32 support,u32 gated,u32 calibrated)
{
    u32 now=rehab_milliseconds();
    rehab.effort_valid=synergy_feedback_find(&synergy_feedback,seq,now,&rehab.effort_c2);
    rehab_observe(&rehab,now,seq,accepted,candidate,support,gated,calibrated);
}
static void lcd_rehab_render(void)
{
    static const char *const phases[]={"训练设置","静息校准","请放松","请做目标动作","保持动作","请放松休息","训练已暂停","训练结果"};
    static const char *const reasons[]={"","手动暂停","数据中断 / 检查连接","请重新完成静息校准","未检测到持续放松"};
    static const char *const rep_names[]={"3 次","5 次","10 次"};
    static const char *const hold_names[]={"1 秒","2 秒","3 秒","5 秒"};
    static const char *const rest_names[]={"2 秒","3 秒","5 秒"};
    u32 i,state=rehab.state;
    ui_label(LCD_X(28),LCD_Y(105),LCD_X(600),2,31,49,58,"康复训练 / 动作与保持");
    ui_label(LCD_X(680),LCD_Y(108),LCD_X(316),1,94,112,119,"按舒适幅度完成动作");
    if(state==RH_IDLE) {
        if(rehab_setup_stage) {
            static const char *const group_names[]={"15 秒","30 秒","60 秒"};
            ui_label(LCD_X(28),LCD_Y(157),LCD_X(968),2,25,120,111,"第二步 / 训练前检查");
            ui_button(LCD_X(28),LCD_Y(205),LCD_X(968),LCD_Y(58),
                rehab_contact_checked?"已确认电极接触与通道波形":"检查通道后，确认电极接触",rehab_contact_checked);
            ui_button(LCD_X(28),LCD_Y(279),LCD_X(968),LCD_Y(58),
                rehab_comfort_checked?"已确认姿势舒适、无不适":"确认姿势舒适，无疼痛不适",rehab_comfort_checked);
            ui_label(LCD_X(28),LCD_Y(353),LCD_X(968),1,94,112,119,
                rehab_combo?"每轮四动作后组间休息":"每三次动作后组间休息");
            ui_label(LCD_X(28),LCD_Y(397),LCD_X(190),2,94,112,119,"组间休息");
            for(i=0u;i<3u;i++)ui_button(LCD_X(230)+(i32)i*LCD_X(250),LCD_Y(383),LCD_X(224),LCD_Y(54),group_names[i],rehab_group_rest_sel==i);
            ui_label(LCD_X(28),LCD_Y(457),LCD_X(968),1,162,101,24,
                sd_record_active()?"请先停止SD波形记录":g_mode!=MODE_MONITOR?"请从首页选择监测模式":
                !pl_control_ready()?"等待PL识别就绪":cal_stage!=2u?"请保持放松，完成静息校准":
                !rehab_contact_checked || !rehab_comfort_checked?"完成以上两项确认后开始":"准备就绪 / 开始后再次静息校准");
            ui_label(LCD_X(28),LCD_Y(484),LCD_X(968),1,94,112,119,"舒适幅度；不适时暂停");
            ui_button(LCD_X(28),LCD_Y(516),LCD_X(300),LCD_Y(62),"开始训练",rehab_prepared());
            ui_button(LCD_X(356),LCD_Y(516),LCD_X(300),LCD_Y(62),"返回计划",0u);
            ui_button(LCD_X(690),LCD_Y(516),LCD_X(306),LCD_Y(62),"重新静息校准",0u);
            return;
        }
        static const char *const titles[]={"训练模式","目标动作","重复次数","保持时间","休息时间"};
        for(i=0u;i<5u;i++)ui_label(LCD_X(28),LCD_Y(160)+(i32)i*LCD_Y(66),LCD_X(190),2,94,112,119,
                                 i==2u && rehab_combo?"每动作次数":titles[i]);
        ui_button(LCD_X(230),LCD_Y(146),LCD_X(340),LCD_Y(50),"单动作训练",!rehab_combo);
        ui_button(LCD_X(600),LCD_Y(146),LCD_X(340),LCD_Y(50),"四动作组合",rehab_combo);
        for(i=0u;i<4u;i++) {
            ui_button(LCD_X(230)+(i32)i*LCD_X(190),LCD_Y(212),LCD_X(174),LCD_Y(50),lcd_pose_names[i+1u],rehab_combo || rehab_action==i+1u);
            ui_button(LCD_X(230)+(i32)i*LCD_X(190),LCD_Y(344),LCD_X(174),LCD_Y(50),hold_names[i],rehab_hold_sel==i);
        }
        for(i=0u;i<3u;i++) {
            ui_button(LCD_X(230)+(i32)i*LCD_X(250),LCD_Y(278),LCD_X(224),LCD_Y(50),rep_names[i],rehab_reps_sel==i);
            ui_button(LCD_X(230)+(i32)i*LCD_X(250),LCD_Y(410),LCD_X(224),LCD_Y(50),rest_names[i],rehab_rest_sel==i);
        }
        ui_button(LCD_X(28),LCD_Y(474),LCD_X(240),LCD_Y(34),
                  rehab_effort_enabled?"握拳活动范围 开":"握拳活动范围 关",rehab_effort_enabled);
        ui_button(LCD_X(280),LCD_Y(474),LCD_X(210),LCD_Y(34),"采舒适参考",0u);
        {
            char label[64];const char *text=label;
            if(synergy_feedback.capture==1u || synergy_feedback.capture==2u)
                lcd_analysis_label(label,sizeof label,"舒适抓握 / ",
                    (synergy_feedback.settle+synergy_feedback.capture_count)*100u/140u,"%");
            else if(synergy_feedback.capture==4u)
                text="参考未完成 / 请重采";
            else if(synergy_feedback.reference)
                lcd_analysis_label(label,sizeof label,"C2参考 ",(synergy_feedback.reference+128u)>>8," / 80%-120%");
            else text="请先舒适抓握采参考";
            ui_label(LCD_X(510),LCD_Y(480),LCD_X(480),1,94,112,119,text);
        }
        ui_button(LCD_X(28),LCD_Y(516),LCD_X(300),LCD_Y(62),"下一步 / 检查",0u);
        ui_label(LCD_X(350),LCD_Y(531),LCD_X(330),1,94,112,119,
                 sd_record_active()?"请先停止波形记录":g_mode!=MODE_MONITOR?"请切换监测模式":
                 rehab_effort_enabled && (rehab_combo || rehab_action==2u) && !synergy_feedback.reference?
                 "强度训练需先采参考":"第一步 / 设置训练计划");
        ui_button(LCD_X(690),LCD_Y(516),LCD_X(306),LCD_Y(62),rehab_autosave?"SD自动保存 开":"SD自动保存 关",rehab_autosave);
        return;
    }
    if(state==RH_DONE) {
        u32 sum=0u,count=0u,breaks=0u;
        ui_label(LCD_X(28),LCD_Y(150),LCD_X(900),3,25,120,111,rehab.aborted?"训练已结束":"本次训练完成");
        rehab_metric(28,207,460,"成功 ",rehab.successes," 次");
        rehab_metric(520,207,470,"超时 ",rehab.failures," 次");
        rehab_metric(28,253,460,"计划完成率 ",rehab.total?100u*rehab.successes/rehab.total:0u,"%");
        rehab_metric(520,253,470,"已评估 ",rehab.attempted," 次");
        for(i=0u;i<rehab.attempted;i++) {
            const rehab_trial_t *t=&rehab.trials[i];
            if(t->success && t->response_ms){sum+=t->response_ms;count++;}breaks+=t->breaks;
        }
        rehab_metric(28,299,460,"平均识别响应 ",count?sum/count:0u," ms");
        rehab_metric(520,299,470,"保持中断 ",breaks," 次");
        for(i=1u;i<=4u;i++) {
            u32 j,ok=0u,all=0u;char label[48];
            for(j=0u;j<rehab.attempted;j++)if(rehab.trials[j].target==i){all++;ok+=rehab.trials[j].success;}
            ui_label(LCD_X(28)+(i32)(i-1u)*LCD_X(246),LCD_Y(365),LCD_X(226),2,25,120,111,lcd_pose_names[i]);
            lcd_analysis_label(label,sizeof label,"成功 ",ok," / ");
            {char tail[16];u32 n=0u,j=0u;lcd_analysis_label(tail,sizeof tail,"",all,"");
             while(label[n])n++;
             while(tail[j] && n+1u<sizeof label)label[n++]=tail[j++];
             label[n]=0;}
            ui_label(LCD_X(28)+(i32)(i-1u)*LCD_X(246),LCD_Y(403),LCD_X(226),2,31,49,58,label);
        }
        ui_label(LCD_X(28),LCD_Y(456),LCD_X(968),1,94,112,119,"完成率为识别结果；响应时间含算法延迟");
        if(rehab.effort_enabled)ui_label(LCD_X(28),LCD_Y(484),LCD_X(968),1,94,112,119,"握拳目标：舒适参考的 80%-120%");
        ui_button(LCD_X(28),LCD_Y(516),LCD_X(300),LCD_Y(62),"返回训练设置",0u);
        ui_button(LCD_X(356),LCD_Y(516),LCD_X(300),LCD_Y(62),rehab.save_state==2u?"结果已保存":"保存 / 重试",rehab.save_state==2u);
        if(rehab.save_state==2u)ui_label(LCD_X(690),LCD_Y(535),LCD_X(306),2,25,120,111,rehab_report_name);
        else if(rehab.save_state==3u)rehab_metric(690,535,306,"SD错误 ",rehab_save_error,"");
        return;
    }
    if(state==RH_GROUP_REST) {
        u32 elapsed=rehab.now-rehab.phase_at;
        u32 remaining=elapsed>=rehab.group_rest_ms?0u:(rehab.group_rest_ms-elapsed+999u)/1000u;
        ui_label(LCD_X(28),LCD_Y(172),LCD_X(968),3,25,120,111,"组间休息 / 请放松");
        rehab_metric(28,250,968,"剩余休息 ",remaining," 秒");
        rehab_metric(28,310,968,"已完成任务 ",rehab.attempted," 次");
        ui_label(LCD_X(28),LCD_Y(385),LCD_X(968),2,31,49,58,"休息后，确认舒适再继续");
        ui_label(LCD_X(28),LCD_Y(452),LCD_X(968),1,94,112,119,"休息结束后点击继续");
        ui_button(LCD_X(28),LCD_Y(516),LCD_X(300),LCD_Y(62),remaining?"休息中":"我已准备好 / 继续",!remaining);
        ui_button(LCD_X(356),LCD_Y(516),LCD_X(300),LCD_Y(62),"结束并查看结果",0u);
        return;
    }
    if(rehab.effort_enabled && rehab.target==2u && (state==RH_CUE || state==RH_HOLD)) {
        char label[64];u32 pct=rehab.effort_reference?
            (u32)((uint64_t)rehab.effort_c2*100u/rehab.effort_reference):0u;
        lcd_analysis_label(label,sizeof label,"相对活动 ",pct,"% / 目标 80%-120%");
        ui_label(LCD_X(28),LCD_Y(477),LCD_X(670),1,94,112,119,label);
        ui_label(LCD_X(710),LCD_Y(477),LCD_X(286),1,25,120,111,
            !rehab.effort_valid?"等待同窗数据":
            (uint64_t)rehab.effort_c2*100u<(uint64_t)rehab.effort_reference*80u?"活动不足":
            (uint64_t)rehab.effort_c2*100u>(uint64_t)rehab.effort_reference*120u?"活动偏高":"目标范围内");
    }
    p_round_rect(LCD_X(28),LCD_Y(145),LCD_X(968),LCD_Y(110),LCD_S(8),239,246,245);
    ui_label(LCD_X(48),LCD_Y(158),LCD_X(910),2,25,120,111,phases[state]);
    ui_label(LCD_X(48),LCD_Y(204),LCD_X(910),2,31,49,58,
             state==RH_PAUSED?reasons[rehab.reason]:state==RH_CALIBRATE?"保持放松 / 等待校准完成":
             state==RH_RELAX || state==RH_RECOVER?"连续放松后自动继续":"保持目标动作 / 中断重新计时");
    ui_label(LCD_X(28),LCD_Y(284),LCD_X(220),2,94,112,119,"目标动作");
    ui_label(LCD_X(250),LCD_Y(276),LCD_X(230),3,25,120,111,
             state==RH_CUE || state==RH_HOLD?lcd_pose_names[rehab.target]:"放松");
    ui_label(LCD_X(520),LCD_Y(284),LCD_X(210),2,94,112,119,"当前识别");
    ui_label(LCD_X(750),LCD_Y(276),LCD_X(246),3,31,49,58,lcd_pose_names[pose_active_cls<5u?pose_active_cls:0u]);
    rehab_metric(28,340,460,"已评估 ",rehab.attempted," 次");
    rehab_metric(520,340,470,"本次目标 ",rehab.total," 次");
    {
        u32 required=(state==RH_RELAX || state==RH_RECOVER)?rehab.rest_ms:rehab.hold_ms;
        u32 progress=rehab.segment_ms>required?required:rehab.segment_ms;
        p_round_rect(LCD_X(28),LCD_Y(394),LCD_X(968),LCD_Y(22),LCD_S(6),220,232,231);
        if(progress)p_rect(LCD_X(28),LCD_Y(394),(i32)((uint64_t)LCD_X(968)*progress/required),LCD_Y(22),57,155,145);
        if(state==RH_CALIBRATE || state==RH_PAUSED) {
            ui_label(LCD_X(28),LCD_Y(440),LCD_X(460),2,31,49,58,"请保持放松");
            ui_label(LCD_X(520),LCD_Y(440),LCD_X(470),2,31,49,58,"校准完成后继续");
        } else {
            rehab_metric(28,440,460,"连续保持 ",progress," ms");
            rehab_metric(520,440,470,"本段要求 ",required," ms");
        }
    }
    ui_button(LCD_X(28),LCD_Y(516),LCD_X(300),LCD_Y(62),state==RH_PAUSED?"重新校准并继续":"暂停训练",state==RH_PAUSED);
    ui_button(LCD_X(356),LCD_Y(516),LCD_X(300),LCD_Y(62),"结束并查看结果",0u);
    ui_label(LCD_X(690),LCD_Y(535),LCD_X(306),1,94,112,119,"不适时请暂停训练");
}
#endif
