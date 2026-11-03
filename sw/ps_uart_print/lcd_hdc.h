#ifndef LCD_HDC_H
#define LCD_HDC_H
/* Frozen, independently validated HDC can be explicitly selected for hand
 * control; normal monitoring still uses the PL classifier. Every learned
 * class is a user-defined custom gesture; there are no fixed base classes. */
static const char *hdc_name(u32 cls)
{
    static char text[48];
    lcd_analysis_label(text,sizeof text,"自定义",cls+1u,"");return text;
}
static const char *hdc_key(u32 cls)
{
    static char text[48];
    lcd_analysis_label(text,sizeof text,"custom",cls+1u,"");return text;
}
static u32 hdc_page,hdc_model_view;
static void lcd_hdc_models_render(void);
static void lcd_hdc_models_touch(u32 x,u32 y);
static u32 hdc_custom=1u,hdc_refresh_ms,hdc_save_error,hdc_saved;
static u32 hdc_max_ticks,hdc_build_max_ticks;
static char hdc_report_name[13];
static u32 hdc_hand_model_ready(void)
{
    u32 c;
    /* A one-class library has no rival class: the PL reports margin 0 for it,
     * so no confident intent decision (gesture vs rest) is possible. The live
     * bridges require at least two learned custom gestures. */
    if(hdc.stage!=HDC_DONE || hdc.classes<2u || !hdc.storage)return 0u;
    for(c=0;c<hdc.classes;c++)
        if(hdc.val_n[c]!=HDC_VAL_WINDOWS || hdc.hdc_cm[c][c]*100u<hdc.val_n[c]*80u)return 0u;
    return 1u;
}

static void lcd_hdc_open(void)
{
    hdc_interrupt(&hdc);hdc_model_view=0u;
    ui_open_page(UI_HDC);
}

static u32 hdc_available(void)
{
    /* Keep frozen prediction alive even if one class fails validation, so
     * every page can explain that failure. Output qualification stays below. */
    return (lcd_hdc_view || ((lcd_hand_view || (hand_source_hdc && ui_page_owner()==UI_MONITOR)) &&
        hdc.stage==HDC_DONE && hdc.storage && hdc.classes>=2u)) &&
        !ui_menu_open && g_mode==MODE_MONITOR &&
        cal_stage==2u && pl_control_ready() && !sd_record_active() &&
        (!rehab_running(&rehab) || rehab.state==RH_PAUSED);
}

static const char *hdc_status_label(void)
{
    u32 c;
    static char reason[48];
    if(hdc.accelerator_error)return "HDC运算异常";
    if(hdc.classes<2u)return "至少学习2类";
    if(hdc.stage!=HDC_DONE)return "请完成独立验证";
    for(c=0u;c<hdc.classes;c++)
        if(hdc.val_n[c]!=HDC_VAL_WINDOWS || hdc.hdc_cm[c][c]*100u<hdc.val_n[c]*80u)
            {lcd_analysis_label(reason,sizeof reason,"自定义",c+1u,"未通过");return reason;}
    if(!hdc_available())return "HDC当前暂停";
    if(!hdc.latest_valid || rehab_milliseconds()-hdc.last_ms>250u)return "等待有效数据";
    if(hdc.clip>1u)return "用力超学习范围";
    if(hand_hdc_valid)return "稳定识别";
    if(hdc.margin_bp<25u)return "手势分数接近";
    return "正在确认手势";
}

static void hdc_gap_label(char *text,u32 size,u32 bp)
{
    lcd_analysis_percent_bp(text,size,"分数间隔 ",bp);
}

static void hdc_service(void)
{
    u32 now=rehab_milliseconds();
    u32 old_hand_valid=hand_hdc_valid;
    if(!hdc_available())hdc_interrupt(&hdc);
    if(hdc.latest_valid && now-hdc.last_ms>250u)hdc_interrupt(&hdc);
    if(hdc.armed && now-hdc.last_ms>250u)hdc_interrupt(&hdc);
    if(!hdc_hand_model_ready() || !hdc.latest_valid || !hdc_available() ||
       now-hdc.last_ms>250u)hand_hdc_reset();
    if((lcd_hand_view || hand_source_hdc) && old_hand_valid!=hand_hdc_valid)lcd_input_status_changed();
    if(hdc.stage==HDC_BUILD && hdc_available()) {
        u32 before=gt_stamp(),dt;
        hdc_build_step(&hdc);dt=gt_stamp()-before;
        if(dt>hdc_build_max_ticks)hdc_build_max_ticks=dt;
        acquisition_service();
    }
    if(lcd_hdc_view && now-hdc_refresh_ms>=100u) {
        hdc_refresh_ms=now;lcd_pending=1u;
    }
}

static void hdc_on_window(const u32 features[40],u16 seq)
{
    u32 before,dt,k,old_hand_valid=hand_hdc_valid,old_hand_class=hand_hdc_class; uint32_t mav[8];
    if(hdc.stage==HDC_IDLE || hdc.stage==HDC_BUILD)return;
    if(!hdc_available()){hdc_interrupt(&hdc);hand_hdc_reset();return;}
    before=gt_stamp();
    for(k=0u;k<8u;k++)mav[k]=features[k];
    hdc_window(&hdc,mav,seq,rehab_milliseconds());
    /* Out-of-range effort is a live abstention: suppress the displayed
     * candidate immediately, retain only the enabled link's last safe pose. */
    if(hdc.latest_valid && hdc.clip>1u)hand_hdc_history_reset();
    hand_hdc_observe(rehab_milliseconds(),seq,hdc.latest,
        !hdc_hand_model_ready() || !hdc.latest_valid?0u:
        hdc.clip>1u?2u:
        hdc.margin_bp>=100u?1u:hdc.margin_bp>=25u?3u:2u);
    if((lcd_hand_view || hand_source_hdc) && old_hand_valid!=hand_hdc_valid)lcd_input_status_changed();
    if(hand_hdc_valid && hand_hdc_class==hdc.latest)virtual_hdc_margin=hdc.margin_bp;
    if(hand_source_hdc && ui_page_owner()==UI_MONITOR &&
       (old_hand_class!=hand_hdc_class || hdc.latest_valid))lcd_pending=1u;
    dt=gt_stamp()-before;if(dt>hdc_max_ticks)hdc_max_ticks=dt;
    acquisition_service();
}

static void lcd_hdc_touch(u32 x,u32 y)
{
    u32 i;
    if(hdc_model_view){lcd_hdc_models_touch(x,y);return;}
    if(lcd_wave_hit(x,y,LCD_X(834),LCD_Y(524),LCD_X(154),LCD_Y(54))) {
        if(!hdc.armed && hdc.stage!=HDC_BUILD){hdc_model_view=1u;ui_hdc_model=1u;}
        ui_generation++;lcd_input_status_changed();return;
    }
    if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(524),LCD_X(150),LCD_Y(54))) {
        ui_open_page(UI_SETTINGS);return;
    }
    if(lcd_wave_hit(x,y,LCD_X(194),LCD_Y(524),LCD_X(240),LCD_Y(54))) {
        if(hdc_available()) {
            hand_hdc_reset();hdc_begin(&hdc,hdc_custom);hdc_page=0u;
            hdc.last_ms=rehab_milliseconds();
            hdc_save_error=hdc_saved=hdc_max_ticks=hdc_build_max_ticks=0u;
            hdc_report_name[0]=0;
        }
        ui_generation++;lcd_input_status_changed();return;
    }
    if(lcd_wave_hit(x,y,LCD_X(450),LCD_Y(524),LCD_X(200),LCD_Y(54))) {
        if(hdc_available() && !hand_busy()) {
            hand_hdc_reset();
            if(hdc.stage==HDC_IDLE)hdc_begin(&hdc,0u);
            if(hdc_append(&hdc)) {
                hdc_custom=hdc.classes;hdc_page=(hdc.classes-1u)/8u;
                hdc_save_error=hdc_saved=0u;
            }
        }
        ui_generation++;lcd_input_status_changed();return;
    }
    if(lcd_wave_hit(x,y,LCD_X(790),LCD_Y(108),LCD_X(205),LCD_Y(38))) {
        if(hdc_available() && !hand_busy()) {hand_hdc_reset();hdc_validate_again(&hdc);}
        ui_generation++;lcd_input_status_changed();return;
    }
    if(lcd_wave_hit(x,y,LCD_X(650),LCD_Y(155),LCD_X(160),LCD_Y(35))) {
        if(hdc_page)hdc_page--;
        ui_generation++;lcd_input_status_changed();return;
    }
    if(lcd_wave_hit(x,y,LCD_X(825),LCD_Y(155),LCD_X(170),LCD_Y(35))) {
        if((hdc_page+1u)*8u<hdc.classes)hdc_page++;
        ui_generation++;lcd_input_status_changed();return;
    }
    if(lcd_wave_hit(x,y,LCD_X(668),LCD_Y(524),LCD_X(154),LCD_Y(54))) {
        if(hdc.stage==HDC_DONE && !sd_record_active())ui_hdc_save=1u;
        return;
    }
    if(!hdc_available())return;
    for(i=hdc_page*8u;i<hdc.classes && i<(hdc_page+1u)*8u;i++) {
        u32 slot=i%8u;
        i32 bx=LCD_X(28)+(i32)(slot%4u)*LCD_X(245);
        i32 by=LCD_Y(slot<4u?220:300),bw=LCD_X(230);
        if(lcd_wave_hit(x,y,bx,by,bw,LCD_Y(44))) {
            if(hdc_arm(&hdc,i))hdc.last_ms=rehab_milliseconds();
            ui_generation++;lcd_input_status_changed();return;
        }
    }
}

static void lcd_hdc_render(void)
{
    static const char *const stages[]={"未开始","学习采样","建立原型","独立验证","已完成 / 实时识别"};
    char text[96];u32 i;
    if(hdc_model_view){lcd_hdc_models_render();return;}
    p_rect(0,LCD_Y(92),LCD_W,LCD_H-LCD_Y(92),248,250,250);
    ui_label(LCD_X(28),LCD_Y(105),LCD_X(590),2,31,49,58,"HDC 板上自学习 / 自定义手势");
    ui_label(LCD_X(28),LCD_Y(150),LCD_X(600),1,25,120,111,
        hdc.accelerator_error?"PL 运算异常 / 重新开始学习":stages[hdc.stage<=HDC_DONE?hdc.stage:0u]);
    ui_button(LCD_X(790),LCD_Y(108),LCD_X(205),LCD_Y(38),"重测模型",0u);
    ui_button(LCD_X(650),LCD_Y(155),LCD_X(160),LCD_Y(35),"上一页",0u);
    ui_button(LCD_X(825),LCD_Y(155),LCD_X(170),LCD_Y(35),"下一页",0u);
    lcd_analysis_label(text,sizeof text,"页 ",hdc_page+1u," / ");
    {char page_text[96];lcd_analysis_label(page_text,sizeof page_text,text,
        hdc.classes?(hdc.classes+7u)/8u:1u,"");
     ui_label(LCD_X(650),LCD_Y(196),LCD_X(345),1,94,112,119,page_text);}
    ui_label(LCD_X(28),LCD_Y(177),LCD_X(600),1,94,112,119,"选类别采样：学习3次，独立验证2次");
    if(!hdc_available()) {
        ui_label(LCD_X(28),LCD_Y(196),LCD_X(600),1,162,101,24,
                 "需监测就绪 / 停止录制和训练");
    } else if(hdc.armed) {
        lcd_analysis_label(text,sizeof text,hdc.guard?"准备剩余窗 ":"当前采样窗 ",hdc.guard?hdc.guard:hdc.n,hdc.guard?" / 40":" / 40");
        ui_label(LCD_X(28),LCD_Y(196),LCD_X(600),1,25,120,111,text);
    } else {
        ui_label(LCD_X(28),LCD_Y(196),LCD_X(600),1,94,112,119,
                 hdc.stage==HDC_BUILD?"正在建立原型 / 完成后另做验证":
                 hdc.stage==HDC_DONE?(hdc.classes<2u?"先新增1个手势 / 至少2类才能联动":"先保存结果 / 再重新佩戴复测"):
                 "每次采完先放松 / 再重复动作");
    }
    for(i=hdc_page*8u;i<hdc.classes && i<(hdc_page+1u)*8u;i++) {
        u32 slot=i%8u;
        i32 bx=LCD_X(28)+(i32)(slot%4u)*LCD_X(245);
        i32 by=LCD_Y(slot<4u?220:300),bw=LCD_X(230);
        u32 n=hdc.stage<=HDC_BUILD?hdc.fit_n[i]:hdc.val_n[i];
        ui_button(bx,by,bw,LCD_Y(44),hdc_name(i),hdc.armed&&hdc.target==i);
        if(hdc.stage==HDC_DONE)
            lcd_analysis_label(text,sizeof text,"正确率 ",hdc.val_n[i]?hdc.hdc_cm[i][i]*100u/hdc.val_n[i]:0u,"%");
        else lcd_analysis_label(text,sizeof text,"",n/40u,hdc.stage<=HDC_BUILD?" / 3 次":" / 2 次");
        ui_label(bx,by+LCD_Y(49),bw,1,94,112,119,text);
    }
    p_rect(LCD_X(28),LCD_Y(379),LCD_X(968),LCD_Y(66),239,245,245);
    ui_label(LCD_X(42),LCD_Y(388),LCD_X(350),2,25,120,111,
             hdc.stage==HDC_DONE?
                 (hand_hdc_valid?hdc_name(hand_hdc_class):hdc_status_label()):
                 (hdc.latest_valid?hdc_name(hdc.latest):"HDC 等待有效模型 / 数据"));
    hdc_gap_label(text,sizeof text,hdc.latest_valid?hdc.margin_bp:0u);
    ui_label(LCD_X(410),LCD_Y(391),LCD_X(560),1,94,112,119,text);
    ui_label(LCD_X(42),LCD_Y(420),LCD_X(370),1,94,112,119,
             hdc.latest_valid?hdc_name(hdc.latest_centroid):"质心等待数据");
    ui_label(LCD_X(410),LCD_Y(420),LCD_X(560),1,94,112,119,"上行HDC / 下行质心 / 仅对照");
    lcd_analysis_label(text,sizeof text,"HDC全类 ",hdc_accuracy(hdc.hdc_cm,hdc.classes),"%");
    ui_label(LCD_X(28),LCD_Y(456),LCD_X(270),1,31,49,58,text);
    lcd_analysis_label(text,sizeof text,"质心全类 ",hdc_accuracy(hdc.centroid_cm,hdc.classes),"%");
    ui_label(LCD_X(310),LCD_Y(456),LCD_X(285),1,31,49,58,text);
    lcd_analysis_label(text,sizeof text,"中断 ",hdc.interruptions,"");
    ui_label(LCD_X(28),LCD_Y(488),LCD_X(200),1,94,112,119,text);
    lcd_analysis_label(text,sizeof text,"单窗峰值 ",hdc_max_ticks/(GT_TICKS_PER_MS/1000u)," us");
    ui_label(LCD_X(230),LCD_Y(488),LCD_X(350),1,94,112,119,text);
    if(hdc.storage_error)memcpy(text,"内存不足，已有手势保留",sizeof "内存不足，已有手势保留");
    else if(hdc_save_error)lcd_analysis_label(text,sizeof text,"保存错误 ",hdc_save_error,"");
    else if(hdc_saved){memcpy(text,hdc_report_name,sizeof hdc_report_name);}
    else lcd_analysis_label(text,sizeof text,"量化超范围 ",hdc.clip," / 8");
    ui_label(LCD_X(620),LCD_Y(488),LCD_X(370),1,162,101,24,text);
    ui_button(LCD_X(28),LCD_Y(524),LCD_X(150),LCD_Y(54),"返回",0u);
    ui_button(LCD_X(194),LCD_Y(524),LCD_X(240),LCD_Y(54),"开始 / 清空重学",0u);
    ui_button(LCD_X(450),LCD_Y(524),LCD_X(200),LCD_Y(54),"新增手势",0u);
    ui_button(LCD_X(668),LCD_Y(524),LCD_X(154),LCD_Y(54),"导出结果",hdc_saved);
    ui_button(LCD_X(834),LCD_Y(524),LCD_X(154),LCD_Y(54),"模型库",0u);
}

static void hdc_save_report(void)
{
    u32 c,p,all=0u;
    if(hdc.stage!=HDC_DONE)return;
    /* Reuse the bounded existing CSV builder; independent filename prefix. */
    rehab_csv_n=rehab_csv_overflow=0u;
    rehab_csv_text("kind,target,prediction,count,key,value\r\n");
    rehab_csv_text("meta,,,,firmware," BUILD_TAG "\r\n");
    rehab_csv_text(hdc.levels==32u?"meta,,,,algorithm,ordered_hdc_D2048_Q32_seed7_int16_sum\r\n":
        "meta,,,,algorithm,ordered_hdc_D2048_Q16_seed7_int16_sum\r\n");
    rehab_csv_text("meta,,,,model_storage,SD_snapshot_explicit_save_load\r\n");
    rehab_csv_text("meta,,,,label_definition,user_confirmed_custom_gesture_not_model_prediction\r\n");
    for(c=0;c<hdc.classes;c++) {
        for(p=0;p<hdc.classes;p++) {
            if(hdc.hdc_cm[c][p]) {rehab_csv_text("hdc,");rehab_csv_text(hdc_key(c));rehab_csv_text(",");
            rehab_csv_text(hdc_key(p));rehab_csv_text(",");rehab_csv_number(hdc.hdc_cm[c][p]);rehab_csv_text(",,\r\n");}
            if(hdc.centroid_cm[c][p]) {rehab_csv_text("centroid,");rehab_csv_text(hdc_key(c));rehab_csv_text(",");
            rehab_csv_text(hdc_key(p));rehab_csv_text(",");rehab_csv_number(hdc.centroid_cm[c][p]);rehab_csv_text(",,\r\n");}
        }
        all+=hdc.val_n[c];
    }
    /* Same builder supports six-column metadata via explicit fields. */
#define HDC_META(key,value) do {rehab_csv_text("meta,,,," key ",");rehab_csv_number(value);rehab_csv_text("\r\n");} while(0)
    HDC_META("classes",hdc.classes);HDC_META("validation_windows",all);
    HDC_META("hdc_all_accuracy_pct",hdc_accuracy(hdc.hdc_cm,hdc.classes));
    HDC_META("centroid_all_accuracy_pct",hdc_accuracy(hdc.centroid_cm,hdc.classes));
    HDC_META("fit_windows_per_class",HDC_FIT_WINDOWS);
    HDC_META("validation_windows_per_class",HDC_VAL_WINDOWS);
    HDC_META("guard_windows_per_trial",HDC_GUARD_WINDOWS);
    HDC_META("mean_score_gap_pct_not_probability",all?hdc.margin_sum/all:0u);
    HDC_META("interruptions",hdc.interruptions);
    HDC_META("clipped_channel_values",hdc.clip_values);HDC_META("validation_channel_values",hdc.validation_values);
    HDC_META("saturated_dimension_updates",hdc.saturated);
    HDC_META("max_window_us",hdc_max_ticks/(GT_TICKS_PER_MS/1000u));
    HDC_META("max_build_step_us",hdc_build_max_ticks/(GT_TICKS_PER_MS/1000u));
    HDC_META("feature_gap_counter",feature_gap_cnt);
    for(c=0;c<8u;c++){rehab_csv_text("scale,");rehab_csv_number(c+1u);rehab_csv_text(",,,MAV_sum,");rehab_csv_number(hdc.scale[c]);rehab_csv_text("\r\n");}
#undef HDC_META
    hdc_save_error=rehab_csv_overflow?0x305u:sd_hdc_save(rehab_csv,rehab_csv_n,hdc_report_name);
    hdc_saved=hdc_save_error==0u;ui_generation++;lcd_input_status_changed();
}
#endif
