#ifndef LCD_HOME_H
#define LCD_HOME_H
/* Header labels and destinations stay fixed on every page. */
static void ui_draw_header(void)
{
    ui_button(LCD_X(440),LCD_Y(30),LCD_X(125),LCD_Y(52),"首页",ui_menu_open);
    ui_button(LCD_X(575),LCD_Y(30),LCD_X(140),LCD_Y(52),"返回",0u);
    ui_button(LCD_X(725),LCD_Y(30),LCD_X(140),LCD_Y(52),"训练",lcd_rehab_view);
    ui_button(LCD_X(875),LCD_Y(30),LCD_X(133),LCD_Y(52),hand_busy()?"停止":"设置",lcd_settings_view);
}

static void ui_draw_menu(void)
{
    static const char *const names[]={"实时监测","康复训练","通道检查","波形示波","频谱分析",
        "肌肉协同","SD记录标注","手势自学习","机械手控制"};
    static const char *const hints[]={"识别与姿态","计划与结果","调整电极接触","原始 / 全处理","频率与干扰",
        "相对肌肉活动","原始与处理波形","自定义手势","标定与映射"};
    static const char *const actions[]={"监测模式","串口记录","静息校准","MPU归零"};
    u32 i;
    p_rect(0,0,LCD_W,LCD_H,255,255,255);
    ui_label(LCD_X(28),LCD_Y(12),LCD_X(410),2,31,49,58,"自学习肌电意图解码康复训练系统");
    ui_label(LCD_X(28),LCD_Y(56),LCD_X(280),1,94,112,119,
        hand_home_state==HAND_HOME_WAIT || hand_home_state==HAND_HOME_DRIVE?"机械手复位中":
        hand_home_state==HAND_HOME_DONE?"复位目标保持中":
        hand_home_state==HAND_HOME_SKIPPED?"未复位 / 请检查标定":
        hand_home_state==HAND_HOME_CANCELED?"机械手复位已中断":"功能导航");
    ui_draw_header();
    p_rect(0,LCD_Y(90),LCD_W,LCD_Y(2),211,222,222);
    ui_label(LCD_X(28),LCD_Y(108),LCD_X(480),1,94,112,119,"信号分析");
    ui_label(LCD_X(520),LCD_Y(108),LCD_X(476),1,94,112,119,"训练与设备");
    for(i=0u;i<9u;i++) {
        i32 x=LCD_X(28)+(i32)(i%3u)*LCD_X(330);
        i32 y=LCD_Y(148)+(i32)(i/3u)*LCD_Y(98);
        p_round_rect(x,y,LCD_X(308),LCD_Y(78),LCD_S(7),i==1u?126:239,i==1u?210:244,i==1u?195:244);
        ui_label(x+LCD_X(16),y+LCD_Y(14),LCD_X(276),2,31,49,58,names[i]);
        ui_label(x+LCD_X(16),y+LCD_Y(48),LCD_X(276),1,94,112,119,hints[i]);
        ui_button_press_border(x,y,LCD_X(308),LCD_Y(78));
    }
    ui_label(LCD_X(28),LCD_Y(448),LCD_X(620),1,31,49,58,ui_mode_label);
    ui_label(LCD_X(660),LCD_Y(448),LCD_X(336),1,sd_record_active()?190:94,
        sd_record_active()?58:112,sd_record_active()?58:119,
        sd_record_active()?"SD记录中":"SD空闲");
    for(i=0u;i<4u;i++)ui_button(LCD_X(28)+(i32)i*LCD_X(246),LCD_Y(486),
        LCD_X(230),LCD_Y(52),actions[i],0u);
    ui_label(LCD_X(28),LCD_Y(558),LCD_X(968),1,94,112,119,"监测 / 记录 / 静息校准 / MPU归零可在此切换");
}
#endif

