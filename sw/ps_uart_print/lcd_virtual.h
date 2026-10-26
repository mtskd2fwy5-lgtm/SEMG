#ifndef LCD_VIRTUAL_H
#define LCD_VIRTUAL_H
/* Virtual joint degrees are deliberately independent of servo pulse widths.
 * The library has the same RAM lifetime and transactional growth as HDC. */
static u32 virtual_row=5u,virtual_group,virtual_joint,virtual_preset;
static u32 virtual_drag,virtual_dirty;
static i32 virtual_draft[22];
static const char *const virtual_groups[]={"手腕","拇指","食指","中指","无名指","小指"};
static const u32 virtual_offsets[]={0u,18u,2u,6u,10u,14u};
static const char *const virtual_joints[]={"根部屈曲","侧向展开","中间关节","末端关节"};
static u32 virtual_row_available(u32 c)
{
    return c>=5u && c<hdc.classes && hdc.fit_n[c]==HDC_FIT_WINDOWS &&
        hdc.stage>=HDC_VALIDATE;
}
static u32 virtual_live_class(void)
{
    if(!hdc_hand_model_ready() || !hdc_available() || !hdc.latest_valid || !hand_hdc_valid ||
       rehab_milliseconds()-hand_hdc_ms>250u)return UINT32_MAX;
    return hand_hdc_class<hdc.classes?hand_hdc_class:UINT32_MAX;
}
static u32 virtual_live_mapped(u32 cls)
{
    return cls<5u || (virtual_row_available(cls) && hdc.virtual_mapped[cls]);
}
static void lcd_virtual_sample(void)
{
    u32 cls,i;i32 target[22];
    virtual_frame_cls=virtual_live_class();
    virtual_frame_mapped=virtual_live_mapped(virtual_frame_cls);
    virtual_frame_ready=hdc_hand_model_ready();virtual_frame_margin=virtual_hdc_margin;
    if(lcd_virtual_view) {
        lcd_pose_sample_target(UINT32_MAX-1u,virtual_draft);return;
    }
    if(ui_preview_cls>=0) {lcd_pose_sample((u32)ui_preview_cls);return;}
    if(!hand_source_hdc) {lcd_pose_sample(lcd_state_cls);return;}
    cls=virtual_frame_cls;
    if(cls<5u)lcd_pose_sample(cls);
    else if(virtual_live_mapped(cls)) {
        for(i=0u;i<22u;i++)target[i]=(i32)hdc.virtual_pose[cls][i];
        lcd_pose_sample_target(cls,target);
    }
    else lcd_pose_sample(0u); /* Explicit waiting/unmapped label, neutral pose. */
}
static u32 virtual_index(void)
{return virtual_offsets[virtual_group]+virtual_joint;}
static i32 virtual_low(u32 index)
{
    if(index==0u)return -70;
    if(index==1u)return -30;
    if(index==19u)return -100;
    if(index<18u && (index-2u)%4u==1u)return -30;
    return 0;
}
static i32 virtual_high(u32 index)
{
    if(index==0u)return 70;
    if(index==1u || index==19u || (index<18u && (index-2u)%4u==1u))return 30;
    return 100;
}
static void virtual_load(u32 cls)
{
    u32 i;
    virtual_row=cls;virtual_dirty=virtual_drag=0u;
    for(i=0u;i<22u;i++)virtual_draft[i]=virtual_row_available(cls) && hdc.virtual_mapped[cls]?
        (i32)hdc.virtual_pose[cls][i]:pose_table[0][i];
}
static u32 virtual_next(u32 reverse)
{
    u32 c;
    if(reverse) {
        for(c=virtual_row;c>5u;)if(virtual_row_available(--c))return c;
        for(c=hdc.classes;c>5u;)if(virtual_row_available(--c))return c;
    } else {
        for(c=virtual_row+1u;c<hdc.classes;c++)if(virtual_row_available(c))return c;
        for(c=5u;c<hdc.classes;c++)if(virtual_row_available(c))return c;
    }
    return 5u;
}
static void lcd_virtual_open(void)
{
    u32 c;
    /* Load before navigation can synchronously draw the destination. */
    if(!virtual_row_available(virtual_row)) {
        virtual_row=5u;
        for(c=5u;c<hdc.classes;c++)if(virtual_row_available(c)){virtual_row=c;break;}
    }
    virtual_load(virtual_row);ui_open_page(UI_VIRTUAL);
}
static void virtual_adjust(i32 value)
{
    u32 index=virtual_index();
    if(!virtual_row_available(virtual_row))return;
    if(value<virtual_low(index))value=virtual_low(index);
    if(value>virtual_high(index))value=virtual_high(index);
    if(value==virtual_draft[index])return;
    virtual_draft[index]=value;virtual_dirty=1u;
    ui_generation++;lcd_pending=1u;lcd_input_status_changed();
}
static void virtual_slider(u32 x)
{
    i32 n=(i32)x-LCD_X(330),w=LCD_X(620),lo=virtual_low(virtual_index());
    if(n<0)n=0;
    if(n>w)n=w;
    virtual_adjust(lo+(n*(virtual_high(virtual_index())-lo)+w/2)/w);
}
static void lcd_virtual_contact(u32 x,u32 y,u32 down)
{
    (void)y;
    if(!virtual_drag)return;
    if(!down || !lcd_virtual_view || ui_menu_open) {virtual_drag=0u;return;}
    virtual_slider(x);
}
static void lcd_virtual_touch(u32 x,u32 y)
{
    u32 i;
    if(!virtual_row_available(virtual_row)) {
        if(lcd_wave_hit(x,y,LCD_X(340),LCD_Y(520),LCD_X(340),LCD_Y(54)))lcd_hdc_open();
        return;
    }
    if(lcd_wave_hit(x,y,LCD_X(300),LCD_Y(100),LCD_X(64),LCD_Y(42)))virtual_load(virtual_next(1u));
    else if(lcd_wave_hit(x,y,LCD_X(665),LCD_Y(100),LCD_X(64),LCD_Y(42)))virtual_load(virtual_next(0u));
    else if(lcd_wave_hit(x,y,LCD_X(750),LCD_Y(100),LCD_X(115),LCD_Y(42))) {
        for(i=0u;i<22u;i++)hdc.virtual_pose[virtual_row][i]=(int32_t)virtual_draft[i];
        hdc.virtual_mapped[virtual_row]=1u;virtual_dirty=0u;
    } else if(lcd_wave_hit(x,y,LCD_X(880),LCD_Y(100),LCD_X(115),LCD_Y(42))) {
        hdc.virtual_mapped[virtual_row]=0u;virtual_load(virtual_row);
    } else if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(146),LCD_X(245),LCD_Y(40))) {
        virtual_preset=(virtual_preset+1u)%5u;
        memcpy(virtual_draft,pose_table[virtual_preset],sizeof virtual_draft);virtual_dirty=1u;
    } else if(lcd_wave_hit(x,y,LCD_X(310),LCD_Y(475),LCD_X(660),LCD_Y(42))) {
        virtual_drag=1u;virtual_slider(x);
    } else if(lcd_wave_hit(x,y,LCD_X(330),LCD_Y(530),LCD_X(140),LCD_Y(44)))virtual_adjust(virtual_draft[virtual_index()]-1);
    else if(lcd_wave_hit(x,y,LCD_X(810),LCD_Y(530),LCD_X(140),LCD_Y(44)))virtual_adjust(virtual_draft[virtual_index()]+1);
    else {
        for(i=0u;i<6u;i++)if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(200)+(i32)i*LCD_Y(47),LCD_X(245),LCD_Y(39))) {
            virtual_group=i;if(!i && virtual_joint>1u)virtual_joint=0u;break;
        }
        for(i=0u;i<(virtual_group?4u:2u);i++)
            if(lcd_wave_hit(x,y,LCD_X(770),LCD_Y(205)+(i32)i*LCD_Y(49),LCD_X(225),LCD_Y(40)))virtual_joint=i;
    }
    ui_generation++;lcd_pending=1u;lcd_input_status_changed();
}
static void lcd_virtual_render(void)
{
    u32 i,index=virtual_index();i32 lo=virtual_low(index),hi=virtual_high(index);
    char label[64];
    ui_label(LCD_X(28),LCD_Y(108),LCD_X(245),2,31,49,58,"虚拟关节姿态");
    if(!virtual_row_available(virtual_row)) {
        ui_label(LCD_X(240),LCD_Y(270),LCD_X(600),2,94,112,119,"先完成自定义手势学习");
        ui_button(LCD_X(340),LCD_Y(520),LCD_X(340),LCD_Y(54),"HDC 自学习",0u);return;
    }
    ui_button(LCD_X(300),LCD_Y(100),LCD_X(64),LCD_Y(42),"<",0u);
    ui_label(LCD_X(380),LCD_Y(110),LCD_X(270),2,31,49,58,hdc_name(virtual_row));
    ui_button(LCD_X(665),LCD_Y(100),LCD_X(64),LCD_Y(42),">",0u);
    ui_button(LCD_X(750),LCD_Y(100),LCD_X(115),LCD_Y(42),"保存",hdc.virtual_mapped[virtual_row] && !virtual_dirty);
    ui_button(LCD_X(880),LCD_Y(100),LCD_X(115),LCD_Y(42),"清除",0u);
    if(dl_mode)dl_push(5,LCD_Y(190),LCD_Y(470),0,0,0,0,0);
    else {lcd_clip_top=LCD_Y(190);lcd_clip_bottom=LCD_Y(470);}
    lcd_draw_hand(0u,0u);
    if(dl_mode)dl_push(5,0,LCD_H,0,0,0,0,0);
    else {lcd_clip_top=0;lcd_clip_bottom=LCD_H;}
    p_round_rect(LCD_X(22),LCD_Y(190),LCD_X(260),LCD_Y(300),LCD_S(8),243,247,247);
    p_round_rect(LCD_X(760),LCD_Y(190),LCD_X(242),LCD_Y(280),LCD_S(8),243,247,247);
    ui_button(LCD_X(28),LCD_Y(146),LCD_X(245),LCD_Y(40),lcd_pose_names[virtual_preset],0u);
    ui_label(LCD_X(310),LCD_Y(156),LCD_X(670),1,94,112,119,
        virtual_dirty?"预览 / 未保存":hdc.virtual_mapped[virtual_row]?"已映射 / 本次上电有效":"未映射 / 调整后保存");
    for(i=0u;i<6u;i++)ui_button(LCD_X(28),LCD_Y(200)+(i32)i*LCD_Y(47),LCD_X(245),LCD_Y(39),virtual_groups[i],i==virtual_group);
    for(i=0u;i<(virtual_group?4u:2u);i++)
        ui_button(LCD_X(770),LCD_Y(205)+(i32)i*LCD_Y(49),LCD_X(225),LCD_Y(40),
            virtual_group?virtual_joints[i]:i?"侧向偏转":"屈伸",i==virtual_joint);
    lcd_analysis_label(label,sizeof label,virtual_draft[index]<0?"-":"",
        (u32)hand_abs(virtual_draft[index])," deg");
    ui_label(LCD_X(780),LCD_Y(412),LCD_X(205),2,31,49,58,label);
    p_round_rect(LCD_X(330),LCD_Y(492),LCD_X(620),LCD_Y(8),LCD_S(4),211,222,222);
    {lcd_point knob={LCD_X(330)+(virtual_draft[index]-lo)*LCD_X(620)/(hi-lo),LCD_Y(496)};
     p_disc(knob,LCD_S(12),38,170,145);}
    ui_button(LCD_X(330),LCD_Y(530),LCD_X(140),LCD_Y(44),"- 1",0u);
    ui_label(LCD_X(490),LCD_Y(543),LCD_X(300),1,94,112,119,"虚拟预览");
    ui_button(LCD_X(810),LCD_Y(530),LCD_X(140),LCD_Y(44),"+ 1",0u);
}
#endif
