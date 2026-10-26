/* Settings reuse the waveform controls and the coalesced frame scheduler.
 * Values apply immediately in RAM. They are reset on power-up. */
#ifndef LCD_SETTINGS_H
#define LCD_SETTINGS_H
static const char *const ui_pages[]={"手势","波形","数据","频谱","SD卡"};
static const u32 ui_refresh_choices[]={20u,50u,100u};

static void lcd_settings_touch(u32 x,u32 y)
{
    u32 i;
    if(lcd_wave_hit(x,y,LCD_X(500),LCD_Y(98),LCD_X(220),LCD_Y(40))) {lcd_virtual_open();return;}
    if(lcd_wave_hit(x,y,LCD_X(750),LCD_Y(98),LCD_X(245),LCD_Y(40))) {lcd_hand_open();return;}
    if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(522),LCD_X(300),LCD_Y(54))) {
        lcd_selfcal_open();return;
    }
    if(lcd_wave_hit(x,y,LCD_X(350),LCD_Y(522),LCD_X(320),LCD_Y(54))) {
        lcd_hdc_open();return;
    }
    for(i=0u;i<5u;i++)
        if(lcd_wave_hit(x,y,LCD_X(28)+(i32)i*LCD_X(198),LCD_Y(145),LCD_X(180),LCD_Y(52))) {
            ui_open_page(i);return;
        }
    for(i=0u;i<3u;i++) {
        i32 bx=LCD_X(410)+(i32)i*LCD_X(190);
        if(lcd_wave_hit(x,y,bx,LCD_Y(224),LCD_X(176),LCD_Y(54))) ui_refresh_ms=ui_refresh_choices[i];
        else if(lcd_wave_hit(x,y,bx,LCD_Y(368),LCD_X(176),LCD_Y(54))) wave_time_sel=i;
        else continue;
        ui_generation++;lcd_input_status_changed();return;
    }
    if(lcd_wave_hit(x,y,LCD_X(410),LCD_Y(296),LCD_X(270),LCD_Y(54))) ui_grid_enabled=!ui_grid_enabled;
    else if(lcd_wave_hit(x,y,LCD_X(700),LCD_Y(296),LCD_X(270),LCD_Y(54))) lcd_wave_select(wave_channel,!wave_notch);
    else if(lcd_wave_hit(x,y,LCD_X(410),LCD_Y(440),LCD_X(270),LCD_Y(54))) wave_dc_auto=!wave_dc_auto;
    else if(lcd_wave_hit(x,y,LCD_X(700),LCD_Y(440),LCD_X(270),LCD_Y(54))) wave_scale_sel=0u;
    else if(lcd_wave_hit(x,y,LCD_X(700),LCD_Y(522),LCD_X(270),LCD_Y(54))) {
        ui_refresh_ms=20u;ui_grid_enabled=1u;wave_time_sel=1u;
        wave_dc_auto=1u;wave_scale_sel=0u;lcd_wave_select(wave_channel,1u);
    } else return;
    ui_generation++;lcd_input_status_changed();
}

static void lcd_settings_render(void)
{
    static const char *const row_title[]={"刷新间隔","网格与信号源","波形时长","零点与量程"};
    static const char *const row_help[]={"仅影响显示","仅用于波形","保留全部采样","仅影响显示"};
    static const char *const refresh[]={"20 ms","50 ms","100 ms"};
    static const char *const times[]={"50 ms","100 ms","200 ms"};
    u32 i;
    ui_label(LCD_X(28),LCD_Y(106),LCD_X(450),2,31,49,58,"显示与设备设置");
    ui_button(LCD_X(500),LCD_Y(98),LCD_X(220),LCD_Y(40),"虚拟手映射",0u);
    ui_button(LCD_X(750),LCD_Y(98),LCD_X(245),LCD_Y(40),"机械手",0u);
    for(i=0;i<5u;i++)
        ui_button(LCD_X(28)+(i32)i*LCD_X(198),LCD_Y(145),LCD_X(180),LCD_Y(52),ui_pages[i],0u);
    for(i=0;i<4u;i++) {
        i32 y=LCD_Y(216)+(i32)i*LCD_Y(72);
        p_rect(LCD_X(28),y,LCD_X(968),LCD_Y(64),25,34,48);
        ui_label(LCD_X(44),y+LCD_Y(10),LCD_X(345),2,224,233,243,row_title[i]);
        ui_label(LCD_X(44),y+LCD_Y(39),LCD_X(345),1,140,153,170,row_help[i]);
    }
    for(i=0;i<3u;i++) {
        i32 bx=LCD_X(410)+(i32)i*LCD_X(190);
        ui_button(bx,LCD_Y(224),LCD_X(176),LCD_Y(54),refresh[i],ui_refresh_ms==ui_refresh_choices[i]);
        ui_button(bx,LCD_Y(368),LCD_X(176),LCD_Y(54),times[i],wave_time_sel==i);
    }
    ui_button(LCD_X(410),LCD_Y(296),LCD_X(270),LCD_Y(54),ui_grid_enabled?"网格开":"网格关",ui_grid_enabled);
    ui_button(LCD_X(700),LCD_Y(296),LCD_X(270),LCD_Y(54),wave_notch?"全处理":"原始",wave_notch);
    ui_button(LCD_X(410),LCD_Y(440),LCD_X(270),LCD_Y(54),wave_dc_auto?"自动居中":"零点居中",wave_dc_auto);
    ui_button(LCD_X(700),LCD_Y(440),LCD_X(270),LCD_Y(54),"自动量程",!wave_scale_sel);
    ui_button(LCD_X(28),LCD_Y(522),LCD_X(300),LCD_Y(54),"佩戴适配",0u);
    ui_button(LCD_X(350),LCD_Y(522),LCD_X(320),LCD_Y(54),"HDC 自学习",0u);
    ui_button(LCD_X(700),LCD_Y(522),LCD_X(270),LCD_Y(54),"恢复默认",0u);
}
#endif
