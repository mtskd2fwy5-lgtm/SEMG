#ifndef LCD_HAND_H
#define LCD_HAND_H
static const char *const hand_axis_names[]={"MPU旋转","拇指","食指","中指","无名指","小指"};
static uint32_t hand_row_available(uint32_t row)
{
    return row<3u || (row>=5u && row<hdc.classes &&
        hdc.fit_n[row]==HDC_FIT_WINDOWS && hdc.stage>=HDC_VALIDATE);
}
static uint32_t *hand_row_pose(uint32_t row)
{return row<3u?hand_profile.pose[row]:hdc.hand_pose[row];}
static uint32_t hand_mapping_pulse(uint32_t row,uint32_t axis)
{
    uint32_t p=hand_row_pose(row)[axis],low=500u,high=2500u;
    if(hand_profile.cal_mask==4095u) {
        low=hand_profile.low[axis];high=hand_profile.high[axis];
    }
    if(p>=low && p<=high)return p;
    /* Present an editable starting point, but save only after confirmation. */
    return hand_profile.cal_mask==4095u?
        (hand_profile.low[axis]+hand_profile.high[axis])/2u:1500u;
}
static uint32_t hand_row_mapped(uint32_t row)
{
    if(!hand_row_available(row))return 0u;
    return row<3u?((hand_profile.row_mask>>row)&1u):hdc.hand_mapped[row];
}
static void hand_row_enable(uint32_t row,uint32_t enable)
{
    if(!hand_row_available(row))return;
    if(row<3u) {
        if(enable)hand_profile.row_mask|=1u<<row;
        else hand_profile.row_mask&=~(1u<<row);
    } else hdc.hand_mapped[row]=enable;
}
static void hand_invalidate_mappings(void)
{
    u32 c;hand_profile.row_mask=0u;hand_hdc_pose_valid=0u;
    for(c=5u;c<hdc.classes;c++)hdc.hand_mapped[c]=0u;
}
static uint32_t hand_next_row(uint32_t row)
{
    uint32_t c;if(row<2u)return row+1u;
    for(c=row<5u?5u:row+1u;c<hdc.classes;c++)if(hand_row_available(c))return c;
    return 0u;
}
static uint32_t hand_hdc_get_pose(uint32_t cls,uint32_t pose[6])
{
    uint32_t i,*target;
    if(cls==3u || cls==4u) {
        if(hand_hdc_pose_valid){memcpy(pose,hand_hdc_pose,sizeof hand_hdc_pose);return 1u;}
        cls=0u;
    }
    if(!hand_row_mapped(cls))return 0u;
    target=hand_row_pose(cls);
    for(i=1u;i<6u;i++)
        if(target[i]<hand_profile.low[i] || target[i]>hand_profile.high[i])return 0u;
    memcpy(pose,target,6u*sizeof(uint32_t));
    memcpy(hand_hdc_pose,pose,sizeof hand_hdc_pose);hand_hdc_pose_valid=1u;return 1u;
}
static void lcd_hand_open(void)
{
    hdc_interrupt(&hdc);hand_hdc_reset();hand_stop();
    ui_open_page(UI_HAND);
    if(!hand_profile.magic)hand_profile_init();
    if(!hand_row_available(hand_row))hand_row=0u;
    if(hand_view_mode && !hand_axis)hand_axis=1u;
    ui_generation++;lcd_input_status_changed();
}
static void hand_storage_apply(uint32_t action)
{
    HandProfile a,b,c;uint32_t va,vb,slot;
    if(!action)return;
    if(sd_record_active()){hand_io_error=0x301u;return;}
    va=sd_hand_read(0u,&a,sizeof a)==0u && hand_profile_valid(&a);
    vb=sd_hand_read(1u,&b,sizeof b)==0u && hand_profile_valid(&b);
    if(action==1u) {
        if(!va && !vb){hand_io_error=0x401u;return;}
        hand_profile=(!vb || (va && (int32_t)(a.generation-b.generation)>0))?a:b;
        /* A loaded profile may have different travel limits. Custom mappings
         * belong to the RAM library and must be reconfirmed against them. */
        {uint32_t k;for(k=5u;k<hdc.classes;k++)hdc.hand_mapped[k]=0u;}
        hand_hdc_pose_valid=0u;
        hand_upload();hand_io_error=0u;
    } else {
        c=hand_profile;
        if(va || vb) {
            uint32_t latest=(!vb || (va && (int32_t)(a.generation-b.generation)>0))?0u:1u;
            c.generation=(latest?b.generation:a.generation)+1u;slot=latest^1u;
        } else {c.generation=1u;slot=0u;}
        c.crc=hand_crc(&c);
        if(!hand_profile_valid(&c)){hand_io_error=0x402u;return;}
        hand_io_error=sd_hand_write(slot,&c,sizeof c);
        if(!hand_io_error) {
            HandProfile check;
            if(sd_hand_read(slot,&check,sizeof check)!=0u || memcmp(&check,&c,sizeof c)!=0)
                hand_io_error=0x403u;
            else hand_profile=c;
        }
    }
    ui_generation++;lcd_input_status_changed();
}
static void hand_boot_init(void)
{
    hand_profile_init();
#if PL_CONTROL_ENABLE
    hand_storage_apply(1u);
    if(hand_io_error) {
        hand_stop();hand_home_state=HAND_HOME_SKIPPED;
    } else hand_home_request();
#else
    hand_home_state=HAND_HOME_SKIPPED;
#endif
    ui_generation++;lcd_input_status_changed();
}
static void lcd_hand_adjust(u32 pulse)
{
    u32 old=hand_pulse,old_run=hand_run;
    if(g_mode!=MODE_MONITOR)return;
    if(hand_view_mode) {
        if(hand_axis<1u || hand_axis>5u || hand_profile.cal_mask!=4095u)return;
        if(pulse<hand_profile.low[hand_axis])pulse=hand_profile.low[hand_axis];
        if(pulse>hand_profile.high[hand_axis])pulse=hand_profile.high[hand_axis];
    }
    hand_pulse=pulse<500u?500u:pulse>2500u?2500u:pulse;
    hand_test(rehab_milliseconds());
    if(old!=hand_pulse || old_run!=hand_run) {
        ui_generation++;lcd_input_status_changed();
    }
}
static void lcd_hand_slider(u32 x)
{
    i32 position=(i32)x-LCD_X(52),width=LCD_X(920);
    u32 low=500u,high=2500u;
    if(hand_view_mode) {
        if(hand_axis<1u || hand_axis>5u || hand_profile.cal_mask!=4095u)return;
        low=hand_profile.low[hand_axis];high=hand_profile.high[hand_axis];
    }
    if(position<0)position=0;
    if(position>width)position=width;
    lcd_hand_adjust(low+((u32)position*(high-low)+(u32)width/2u)/(u32)width);
}
static void lcd_hand_contact(u32 x,u32 y,u32 down)
{
    (void)y;
    if(!hand_slider_drag)return;
    if(!down || !lcd_hand_view || ui_menu_open || g_mode!=MODE_MONITOR) {
        hand_slider_drag=0u;
        if(hand_run==1u)hand_stop();
        return;
    }
    lcd_hand_slider(x);
}
static void lcd_hand_touch(u32 x,u32 y)
{
    u32 i;
    if(lcd_wave_hit(x,y,LCD_X(790),LCD_Y(110),LCD_X(205),LCD_Y(48))) {
        hand_stop();return;
    }
    /* Navigation always cancels single-axis tests before changing a target. */
    for(i=0;i<2u;i++)if(lcd_wave_hit(x,y,LCD_X(28)+(i32)i*LCD_X(248),LCD_Y(175),LCD_X(235),LCD_Y(48))) {
        hand_stop();hand_view_mode=i;if(i && hand_axis==0u)hand_axis=1u;
        hand_pulse=i?hand_mapping_pulse(hand_row,hand_axis):1500u;
        goto changed;
    }
    for(i=0;i<6u;i++)if(lcd_wave_hit(x,y,LCD_X(28)+(i32)i*LCD_X(162),LCD_Y(237),LCD_X(151),LCD_Y(48))) {
        if(hand_run>=2u || (hand_run!=1u && hand_busy()))return;
        if(hand_view_mode && i==0u)continue;
        if(hand_run==1u)hand_stop();
        hand_axis=i;
        hand_pulse=hand_view_mode?hand_mapping_pulse(hand_row,i):1500u;
        goto changed;
    }
    if(hand_run>=2u || (hand_run!=1u && hand_busy()))return;
    if(hand_view_mode && lcd_wave_hit(x,y,LCD_X(535),LCD_Y(175),LCD_X(220),LCD_Y(48))) {
        if(hand_run==1u)hand_stop();
        hand_row=hand_next_row(hand_row);hand_pulse=hand_mapping_pulse(hand_row,hand_axis);goto changed;
    }
    if(hand_view_mode && lcd_wave_hit(x,y,LCD_X(790),LCD_Y(175),LCD_X(205),LCD_Y(48))) {
        hand_row_enable(hand_row,0u);hand_upload();goto changed;
    }
    if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(310),LCD_X(968),LCD_Y(36))) {
        if(g_mode!=MODE_MONITOR)return;
        hand_slider_drag=1u;lcd_hand_slider(x);goto changed;
    }
    for(i=0;i<4u;i++)if(lcd_wave_hit(x,y,LCD_X(28)+(i32)i*LCD_X(242),LCD_Y(350),LCD_X(225),LCD_Y(48))) {
        static const i32 delta[]={-50,-10,10,50};i32 p=(i32)hand_pulse+delta[i];
        lcd_hand_adjust((u32)(p<500?500:p>2500?2500:p));goto changed;
    }
    if(!hand_view_mode) {
        if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(420),LCD_X(300),LCD_Y(48))) {
            hand_test(rehab_milliseconds());goto changed;
        }
        if(lcd_wave_hit(x,y,LCD_X(350),LCD_Y(420),LCD_X(300),LCD_Y(48))) {
            if((hand_profile.cal_mask&(64u<<hand_axis)) && hand_pulse>hand_profile.high[hand_axis])return;
            hand_profile.low[hand_axis]=hand_pulse;hand_profile.cal_mask|=1u<<hand_axis;
            if(hand_axis==0u && (hand_profile.cal_mask&(64u<<hand_axis))) {
                u32 mid=(hand_profile.low[0]+hand_profile.high[0])/2u,j;
                for(j=0;j<8u;j++)hand_profile.pose[j][0]=mid;
            }
            hand_invalidate_mappings();hand_upload();goto changed;
        }
        if(lcd_wave_hit(x,y,LCD_X(675),LCD_Y(420),LCD_X(320),LCD_Y(48))) {
            if((hand_profile.cal_mask&(1u<<hand_axis)) && hand_pulse<hand_profile.low[hand_axis])return;
            hand_profile.high[hand_axis]=hand_pulse;hand_profile.cal_mask|=64u<<hand_axis;
            if(hand_axis==0u && (hand_profile.cal_mask&(1u<<hand_axis))) {
                u32 mid=(hand_profile.low[0]+hand_profile.high[0])/2u,j;
                for(j=0;j<8u;j++)hand_profile.pose[j][0]=mid;
            }
            hand_invalidate_mappings();hand_upload();goto changed;
        }
    } else {
        if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(420),LCD_X(300),LCD_Y(48))) {
            if(hand_profile.cal_mask!=4095u || hand_pulse<hand_profile.low[hand_axis] || hand_pulse>hand_profile.high[hand_axis])return;
            if(hand_run==1u)hand_stop();
            hand_row_pose(hand_row)[hand_axis]=hand_pulse;
            hand_row_enable(hand_row,0u);goto changed;
        }
        if(lcd_wave_hit(x,y,LCD_X(350),LCD_Y(420),LCD_X(300),LCD_Y(48))) {
            if(hand_profile.cal_mask!=4095u)return;
            for(i=1;i<6u;i++)if(hand_row_pose(hand_row)[i]<hand_profile.low[i] || hand_row_pose(hand_row)[i]>hand_profile.high[i])return;
            hand_row_enable(hand_row,1u);hand_upload();goto changed;
        }
        if(lcd_wave_hit(x,y,LCD_X(675),LCD_Y(420),LCD_X(320),LCD_Y(48))) {
            if(pl_control_ready()) {
                if(hand_source_hdc) {
                    if(hdc_hand_model_ready() && hdc_available())
                        hand_auto_hdc();
                } else hand_auto();
            }
            goto changed;
        }
    }
    if(hand_busy())return;
    if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(478),LCD_X(300),LCD_Y(34))) {
        ui_recognition_source(!hand_source_hdc);goto changed;
    }
    if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(522),LCD_X(300),LCD_Y(54)))hand_storage_action=1u;
    else if(lcd_wave_hit(x,y,LCD_X(350),LCD_Y(522),LCD_X(300),LCD_Y(54)))hand_storage_action=2u;
    else if(lcd_wave_hit(x,y,LCD_X(675),LCD_Y(522),LCD_X(320),LCD_Y(54))) {ui_open_page(UI_SETTINGS);}
changed:ui_generation++;lcd_input_status_changed();
}
static void lcd_hand_render(void)
{
    char s[96],a[96];u32 i,mode=(hand_status_word>>19)&3u;
    ui_label(LCD_X(28),LCD_Y(112),LCD_X(740),2,31,49,58,"机械手 / MPU 左45度 右225度");
    ui_button(LCD_X(790),LCD_Y(110),LCD_X(205),LCD_Y(48),"停止输出",hand_busy());
    ui_button(LCD_X(28),LCD_Y(175),LCD_X(235),LCD_Y(48),"逐轴标定",!hand_view_mode);
    ui_button(LCD_X(276),LCD_Y(175),LCD_X(235),LCD_Y(48),"动作映射",hand_view_mode);
    if(hand_view_mode) {
        ui_button(LCD_X(535),LCD_Y(175),LCD_X(220),LCD_Y(48),hdc_name(hand_row),1u);
        ui_button(LCD_X(790),LCD_Y(175),LCD_X(205),LCD_Y(48),"禁用此类",!hand_row_mapped(hand_row));
    } else ui_label(LCD_X(535),LCD_Y(188),LCD_X(460),1,25,120,111,
                   hand_run==1u?"当前轴驱动中":"调整后同步驱动");
    for(i=0;i<6u;i++)ui_button(LCD_X(28)+(i32)i*LCD_X(162),LCD_Y(237),LCD_X(151),LCD_Y(48),hand_axis_names[i],hand_axis==i);
    lcd_analysis_label(a,sizeof a,"PWM ",hand_pulse,hand_view_mode?" us / 已存 ":" us");
    if(hand_view_mode)lcd_analysis_label(s,sizeof s,a,hand_row_pose(hand_row)[hand_axis],"");
    else memcpy(s,a,sizeof s);
    ui_label(LCD_X(28),LCD_Y(288),LCD_X(500),1,31,49,58,s);
    lcd_analysis_label(a,sizeof a,"下限 ",hand_profile.low[hand_axis]," / 上限 ");
    lcd_analysis_label(s,sizeof s,a,hand_profile.high[hand_axis]," us");
    ui_label(LCD_X(540),LCD_Y(288),LCD_X(450),1,70,95,110,s);
    {
        i32 left=LCD_X(52),width=LCD_X(920),cy=LCD_Y(328);
        u32 low=500u,high=2500u,pulse;
        i32 position;
        if(hand_view_mode && hand_profile.cal_mask==4095u) {
            low=hand_profile.low[hand_axis];high=hand_profile.high[hand_axis];
        }
        pulse=hand_pulse<low?low:hand_pulse>high?high:hand_pulse;
        position=high>low?(i32)((pulse-low)*(u32)width/(high-low)):width/2;
        p_round_rect(left,cy-LCD_Y(3),width,LCD_Y(6),LCD_S(3),211,222,222);
        if(position)p_rect(left,cy-LCD_Y(3),position,LCD_Y(6),25,120,111);
        p_disc((lcd_point){left+position,cy},LCD_S(12),25,120,111);
        p_disc((lcd_point){left+position,cy},LCD_S(5),255,255,255);
    }
    for(i=0;i<4u;i++) {
        static const char *const steps[]={"-50 us","-10 us","+10 us","+50 us"};
        ui_button(LCD_X(28)+(i32)i*LCD_X(242),LCD_Y(350),LCD_X(225),LCD_Y(48),steps[i],0u);
    }
    ui_button(LCD_X(28),LCD_Y(420),LCD_X(300),LCD_Y(48),hand_view_mode?"记录本轴目标":"驱动当前轴 1 秒",hand_run==1u);
    ui_button(LCD_X(350),LCD_Y(420),LCD_X(300),LCD_Y(48),hand_view_mode?"确认五指映射":"记录脉宽下限",hand_view_mode?hand_row_mapped(hand_row):((hand_profile.cal_mask>>hand_axis)&1u));
    ui_button(LCD_X(675),LCD_Y(420),LCD_X(320),LCD_Y(48),hand_view_mode?(hand_source_hdc?"启用 HDC 联动":"启用 PL 联动"):"记录脉宽上限",hand_view_mode?(mode>=2u):((hand_profile.cal_mask>>(hand_axis+6u))&1u));
    lcd_analysis_label(s,sizeof s,mode==3u?"HDC CAL:":mode==2u?"PL CAL:":mode==1u?"TEST CAL:":"OFF CAL:",hand_profile.cal_mask," MAP:");
    lcd_analysis_label(a,sizeof a,s,hand_profile.row_mask," LINK:");
    lcd_analysis_label(s,sizeof s,a,hand_link_error," IO:");
    lcd_analysis_label(a,sizeof a,s,hand_io_error,(hand_status_word&0x600000u)?" FAULT":"");
    ui_button(LCD_X(28),LCD_Y(478),LCD_X(300),LCD_Y(34),hand_source_hdc?"来源 HDC / 点击切换":"来源 PL / 点击切换",hand_source_hdc);
    ui_label(LCD_X(350),LCD_Y(483),LCD_X(645),1,70,95,110,
             !hand_view_mode?"滑块粗调 / 按钮微调":
             !hand_rotation_valid?"等待 MPU 校准 / 有效数据":
             hand_source_hdc && !hdc_hand_model_ready()?"HDC 未完成验证 / 各类需达 80%":
             hand_profile.cal_mask!=4095u?"请先完成六路脉宽标定":
             hand_source_hdc && !hand_hdc_valid?"等待稳定 HDC 手势":
             hand_source_hdc && hand_hdc_class!=3u && hand_hdc_class!=4u && !hand_row_mapped(hand_hdc_class)?"当前手势未映射 / 仅识别":
             !hand_source_hdc && (hand_profile.row_mask&7u)!=7u?"请完成放松/张手/握拳映射":a);
    ui_button(LCD_X(28),LCD_Y(522),LCD_X(300),LCD_Y(54),"读取 SD 标定",0u);
    ui_button(LCD_X(350),LCD_Y(522),LCD_X(300),LCD_Y(54),"保存 SD 标定",0u);
    ui_button(LCD_X(675),LCD_Y(522),LCD_X(320),LCD_Y(54),"返回设置",0u);
}
#endif
