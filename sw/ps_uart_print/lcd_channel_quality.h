/* LCD diagnostics for electrode adjustment, using final processed samples. */
#ifndef LCD_CHANNEL_QUALITY_H
#define LCD_CHANNEL_QUALITY_H
static u32 cq_ui_t,cq_ref_start;
static u32 cq_stale_mask=255u;
static u32 lcd_quality_stale(u32 ch,u32 now)
{
    channel_quality_t *q=&channel_quality[ch];
    return !q->seen || now-q->last_t>CQ_STALE_TICKS;
}
static void lcd_quality_tick(u32 now)
{
    u32 ch,mask=0;
    if(now-cq_ui_t<500u*GT_TICKS_PER_MS)return;
    cq_ui_t=now;
    for(ch=0;ch<8;ch++)if(lcd_quality_stale(ch,now))mask|=1u<<ch;
    if(cq_reference && (mask || now-cq_ref_start>6000u*GT_TICKS_PER_MS)) {
        cq_reference=0;cq_ref_failed=1;lcd_analysis_changed();
    }
    if(mask!=cq_stale_mask){cq_stale_mask=mask;lcd_analysis_changed();}
}
static const char *lcd_quality_status(u32 ch,u32 now)
{
    channel_quality_t *q=&channel_quality[ch];
    if(lcd_quality_stale(ch,now))return "无新数据";
    if(!q->valid)return "等待完整窗口";
    if(q->clipped)return "处理波形近满量程";
    if(q->rms<2)return "近乎平线，检查";
    if(q->line10>=100u)return "残余工频偏高";
    if(q->cf10>100u)return "尖峰，检查接触";
    if(q->base && q->rms>q->base*3u)return "噪声或活动上升";
    if(q->base && q->rms*4u<q->base)return "幅度下降，检查";
    if(cq_reference)return "放松，参考采集中";
    return q->base?"与参考接近":"请先采集静息参考";
}
static const char *lcd_quality_grade(u32 grade)
{
    static const char *const names[]={"A","B","C","D","--"};
    return names[grade<=CQ_GRADE_D?grade:CQ_GRADE_UNKNOWN];
}
static void lcd_quality_append(char *dst,u32 cap,const char *src)
{
    u32 n=0u;
    if(!cap)return;
    while(n+1u<cap && dst[n])n++;
    while(n+1u<cap && *src)dst[n++]=*src++;
    dst[n]=0;
}
static void lcd_quality_score_text(char dst[48],u32 ch,u32 detail)
{
    channel_quality_t *q=&channel_quality[ch];char value[12];
    if(!q->valid || lcd_quality_stale(ch,gt_stamp()) || q->grade==CQ_GRADE_UNKNOWN) {
        dst[0]=0;lcd_quality_append(dst,48,"-- / 未评分");return;
    }
    if(!detail) {
        lcd_analysis_label(value,sizeof value,"",q->total_score,"");
        dst[0]=0;lcd_quality_append(dst,48,value);lcd_quality_append(dst,48,"分 / " );
        lcd_quality_append(dst,48,lcd_quality_grade(q->grade));
        if(q->grade_cap>(u32)(q->total_score>=80u?CQ_GRADE_A:q->total_score>=60u?CQ_GRADE_B:q->total_score>=40u?CQ_GRADE_C:CQ_GRADE_D))lcd_quality_append(dst,48,"封顶");
    } else {
        lcd_analysis_label(dst,48,"幅",q->activity_score,"");lcd_quality_append(dst,48," 工");
        lcd_analysis_label(value,sizeof value,"",q->mains_score,"");lcd_quality_append(dst,48,value);
        lcd_quality_append(dst,48," 尖");lcd_analysis_label(value,sizeof value,"",q->spike_score,"");lcd_quality_append(dst,48,value);
        lcd_quality_append(dst,48," 顶");lcd_analysis_label(value,sizeof value,"",q->rail_score,"");lcd_quality_append(dst,48,value);
    }
}
static void cq_decimal(char *dst,u32 value,const char *prefix,const char *suffix)
{
    u32 n=0;
    lcd_analysis_label(dst,48,prefix,value/10u,"");
    while(dst[n] && n<40u)n++;
    dst[n++]='.';dst[n++]=(char)('0'+value%10u);dst[n]=0;
    while(*suffix && n<47u)dst[n++]=*suffix++;
    dst[n]=0;
}
static u32 lcd_quality_touch(u32 x,u32 y)
{
    u32 ch;
    if(lcd_analysis_hit(x,y,LCD_X(825),LCD_Y(96),LCD_X(170),LCD_Y(38))) {
        lcd_quality_view=0;lcd_analysis_changed();return 1;
    }
    if(lcd_analysis_hit(x,y,LCD_X(535),LCD_Y(96),LCD_X(275),LCD_Y(38))) {
        if(cq_reference){cq_reference=0;cq_ref_failed=1;}
        else {cq_start_reference();cq_ref_start=gt_stamp();}
        lcd_analysis_changed();return 1;
    }
    for(ch=0;ch<8;ch++) {
        i32 bx=LCD_X(28)+(i32)(ch/4u)*LCD_X(500);
        i32 by=LCD_Y(148)+(i32)(ch%4u)*LCD_Y(72);
        if(lcd_analysis_hit(x,y,bx,by,LCD_X(470),LCD_Y(64))) {
            if(ch!=lcd_analysis_focus) {
                spec_sample_count=spec_sample_write=spec_sample_seq_valid=spec_valid=0;
            }
            lcd_analysis_focus=ch;lcd_analysis_changed();return 1;
        }
    }
    if(lcd_analysis_hit(x,y,LCD_X(28),LCD_Y(532),LCD_X(180),LCD_Y(44))) {
        lcd_wave_select(lcd_analysis_focus,1);ui_open_page(UI_WAVE);return 1;
    }
    if(lcd_analysis_hit(x,y,LCD_X(220),LCD_Y(532),LCD_X(180),LCD_Y(44))) {
        lcd_spectrum_toggle();return 1;
    }
    return 0;
}
static void lcd_quality_render(void)
{
    u32 ch,now=gt_stamp(),progress=3;
    channel_quality_t *q=&channel_quality[lcd_analysis_focus];
    char text[48];
    ui_label(LCD_X(28),LCD_Y(102),LCD_X(260),2,238,243,250,"通道评分");
    ui_label(LCD_X(294),LCD_Y(106),LCD_X(232),1,140,153,170,"放松时采集参考");
    ui_button(LCD_X(535),LCD_Y(96),LCD_X(275),LCD_Y(38),
              cq_reference?"取消参考采集":"放松采参考 3s",cq_reference);
    ui_button(LCD_X(825),LCD_Y(96),LCD_X(170),LCD_Y(38),"波形分析",0);
    for(ch=0;ch<8;ch++) {
        channel_quality_t *c=&channel_quality[ch];
        i32 bx=LCD_X(28)+(i32)(ch/4u)*LCD_X(500);
        i32 by=LCD_Y(148)+(i32)(ch%4u)*LCD_Y(72);
        u32 available=c->valid && !lcd_quality_stale(ch,now);
        u32 warn=available && (c->clipped || c->rms<2 || c->line10>=100 ||
                 c->cf10>100 || (c->base && (c->rms>c->base*3u || c->rms*4u<c->base)));
        if(c->base_n<progress)progress=c->base_n;
        p_round_rect(bx,by,LCD_X(470),LCD_Y(64),LCD_S(7),
                     ch==lcd_analysis_focus?45:30,ch==lcd_analysis_focus?66:42,ch==lcd_analysis_focus?84:58);
        lcd_analysis_label(text,sizeof text,"CH",ch+1u,"");
        ui_label(bx+LCD_X(12),by+LCD_Y(6),LCD_X(70),2,238,243,250,text);
        lcd_quality_score_text(text,ch,0u);
        {static const u8 grades[5][3]={{25,120,111},{162,137,24},{190,120,24},{190,58,58},{140,153,170}};
         u32 g=c->grade<=CQ_GRADE_D?c->grade:4u;
         ui_label(bx+LCD_X(90),by+LCD_Y(4),LCD_X(125),2,grades[g][0],grades[g][1],grades[g][2],text);}
        lcd_quality_score_text(text,ch,1u);
        ui_label(bx+LCD_X(220),by+LCD_Y(9),LCD_X(240),1,
                 warn?255:available?89:140,warn?183:available?220:153,warn?90:available?170:170,text);
        if(available) {
            lcd_analysis_label(text,sizeof text,"RMS ",c->rms,"");
            ui_label(bx+LCD_X(12),by+LCD_Y(38),LCD_X(215),1,238,243,250,text);
            cq_decimal(text,c->line10,"50Hz族 ","%");
            ui_label(bx+LCD_X(238),by+LCD_Y(38),LCD_X(225),1,140,153,170,text);
        } else ui_label(bx+LCD_X(12),by+LCD_Y(37),LCD_X(440),1,140,153,170,"等待实时信号");
        ui_button_press_border(bx,by,LCD_X(470),LCD_Y(64));
    }
    p_round_rect(LCD_X(28),LCD_Y(443),LCD_X(968),LCD_Y(79),LCD_S(7),25,34,48);
    lcd_analysis_label(text,sizeof text,"当前 CH",lcd_analysis_focus+1u,"");
    ui_label(LCD_X(42),LCD_Y(452),LCD_X(210),1,89,190,220,text);
    cq_decimal(text,q->cf10,"峰值因子 ","");
    ui_label(LCD_X(250),LCD_Y(452),LCD_X(260),1,140,153,170,q->valid?text:"峰值因子 --");
    lcd_analysis_label(text,sizeof text,"静息参考 ",q->base,"");
    ui_label(LCD_X(540),LCD_Y(452),LCD_X(330),1,140,153,170,q->base?text:"静息参考 --");
    if(cq_reference) {
        lcd_analysis_label(text,sizeof text,"请放松，参考 ",progress," / 3秒");
        ui_label(LCD_X(42),LCD_Y(487),LCD_X(800),1,230,202,70,text);
    } else ui_label(LCD_X(42),LCD_Y(487),LCD_X(900),1,
                   cq_ref_failed?255:140,cq_ref_failed?120:153,cq_ref_failed?90:170,
                   cq_ref_failed?"参考未完成：保持放松后重试":q->base?"分数用于同次佩戴比较；动作时幅值会变化":"先保持放松，采集3秒参考");
    ui_button(LCD_X(28),LCD_Y(532),LCD_X(180),LCD_Y(44),"通道波形",0);
    ui_button(LCD_X(220),LCD_Y(532),LCD_X(180),LCD_Y(44),"通道频谱",0);
    ui_label(LCD_X(422),LCD_Y(532),LCD_X(570),1,140,153,170,"幅=静息偏差  工=干扰  尖=尖峰  顶=饱和");
}
#endif
