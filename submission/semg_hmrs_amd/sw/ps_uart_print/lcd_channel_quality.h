/* LCD diagnostics for electrode adjustment: one button checks all channels
 * over the same captured window and the results appear together. Results
 * persist until the next check: no time-based wipe, no periodic refresh and
 * no wall-clock text, so a rebuild always reproduces the presented frame. */
#ifndef LCD_CHANNEL_QUALITY_H
#define LCD_CHANNEL_QUALITY_H
static u32 lcd_quality_progress(void)
{
    u32 ch,n=0u;
    for(ch=0u;ch<8u;ch++)if(cq_check_done>>ch&1u)n++;
    return n;
}
static const char *lcd_quality_status(u32 ch)
{
    channel_quality_t *q=&channel_quality[ch];
    if(cq_check_state)return "检查中…";
    if(!cq_result_ok[ch])return cq_check_count?"无数据":"未检查";
    if(q->clipped)return "输出近满量程";
    if(q->rms<2)return "近乎平线，检查";
    if(q->line10>=100u)return "残余工频偏高";
    if(q->cf10>100u)return "尖峰偏多";
    if(q->noise10>100u)return "低频异常，检查接触";
    if(q->motion_score<80u)return "伪影偏多";
    if(q->grade>=CQ_GRADE_C)return "质量偏低，检查波形";
    return q->grade==CQ_GRADE_B?"良好":"优良";
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
    if(cq_check_state) {
        dst[0]=0;lcd_quality_append(dst,48,"…");return;
    }
    if(!cq_result_ok[ch]) {
        dst[0]=0;lcd_quality_append(dst,48,"-- / 未检查");return;
    }
    if(!detail) {
        lcd_analysis_label(value,sizeof value,"",q->total_score,"");
        dst[0]=0;lcd_quality_append(dst,48,value);lcd_quality_append(dst,48,"分 / " );
        lcd_quality_append(dst,48,lcd_quality_grade(q->grade));
    } else {
        lcd_analysis_label(dst,48,"分",q->distribution_score,"");lcd_quality_append(dst,48," 工");
        lcd_analysis_label(value,sizeof value,"",q->mains_score,"");lcd_quality_append(dst,48,value);
        lcd_quality_append(dst,48," 伪");lcd_analysis_label(value,sizeof value,"",q->motion_score,"");lcd_quality_append(dst,48,value);
        lcd_quality_append(dst,48," 接");lcd_analysis_label(value,sizeof value,"",q->contact_score,"");lcd_quality_append(dst,48,value);
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
    if(lcd_analysis_hit(x,y,LCD_X(412),LCD_Y(532),LCD_X(200),LCD_Y(44))) {
        /* Presses while a check runs are consumed, not queued. */
        if(cq_request_check(gt_stamp()))lcd_analysis_changed();
        return 1;
    }
    return 0;
}
static void lcd_quality_render(void)
{
    u32 ch;
    channel_quality_t *q=&channel_quality[lcd_analysis_focus];
    char text[48];
    ui_label(LCD_X(28),LCD_Y(102),LCD_X(260),2,238,243,250,"通道评分");
    ui_label(LCD_X(294),LCD_Y(106),LCD_X(510),1,140,153,170,"一键全通道 / 同窗齐评 / 结果齐发");
    ui_button(LCD_X(825),LCD_Y(96),LCD_X(170),LCD_Y(38),"波形分析",0);
    for(ch=0;ch<8;ch++) {
        channel_quality_t *c=&channel_quality[ch];
        i32 bx=LCD_X(28)+(i32)(ch/4u)*LCD_X(500);
        i32 by=LCD_Y(148)+(i32)(ch%4u)*LCD_Y(72);
        u32 available=!cq_check_state && cq_result_ok[ch];
        u32 warn=available && c->grade>=CQ_GRADE_B;
        p_round_rect(bx,by,LCD_X(470),LCD_Y(64),LCD_S(7),
                     ch==lcd_analysis_focus?45:30,ch==lcd_analysis_focus?66:42,ch==lcd_analysis_focus?84:58);
        lcd_analysis_label(text,sizeof text,"CH",ch+1u,"");
        ui_label(bx+LCD_X(12),by+LCD_Y(6),LCD_X(70),2,238,243,250,text);
        lcd_quality_score_text(text,ch,0u);
        {static const u8 grades[5][3]={{25,120,111},{162,137,24},{190,120,24},{190,58,58},{140,153,170}};
         u32 g=available && c->grade<=CQ_GRADE_D?c->grade:4u;
         ui_label(bx+LCD_X(90),by+LCD_Y(4),LCD_X(125),2,grades[g][0],grades[g][1],grades[g][2],text);}
        ui_label(bx+LCD_X(220),by+LCD_Y(9),LCD_X(240),1,
                 warn?255:available?89:140,warn?183:available?220:153,warn?90:available?170:170,lcd_quality_status(ch));
        if(available) {
            lcd_analysis_label(text,sizeof text,"RMS ",c->rms,"");
            ui_label(bx+LCD_X(12),by+LCD_Y(38),LCD_X(215),1,238,243,250,text);
            cq_decimal(text,c->line10,"工频 ","%");
            ui_label(bx+LCD_X(238),by+LCD_Y(38),LCD_X(225),1,140,153,170,text);
        } else ui_label(bx+LCD_X(12),by+LCD_Y(37),LCD_X(440),1,140,153,170,
                        cq_check_state?"正在采集与分析":"点击下方按钮开始检查");
        ui_button_press_border(bx,by,LCD_X(470),LCD_Y(64));
    }
    {u32 focus_ok=!cq_check_state && cq_result_ok[lcd_analysis_focus];
     p_round_rect(LCD_X(28),LCD_Y(443),LCD_X(968),LCD_Y(79),LCD_S(7),25,34,48);
     lcd_analysis_label(text,sizeof text,"当前 CH",lcd_analysis_focus+1u,"");
     ui_label(LCD_X(42),LCD_Y(452),LCD_X(210),1,89,190,220,text);
     cq_decimal(text,q->cf10,"峰值因子 ","");
     ui_label(LCD_X(250),LCD_Y(452),LCD_X(260),1,140,153,170,focus_ok?text:"峰值因子 --");
     cq_decimal(text,q->noise10,"低频 ","%");
     ui_label(LCD_X(540),LCD_Y(452),LCD_X(330),1,140,153,170,focus_ok?text:"低频 --");
     {static const char *const labels[]={"分布 ","工频 ","伪影 ","接触 "};
      u32 scores[4]={q->distribution_score,q->mains_score,q->motion_score,q->contact_score},i;
      for(i=0;i<4;i++) {
          lcd_analysis_label(text,sizeof text,labels[i],scores[i],"");
          ui_label(LCD_X(42)+(i32)i*LCD_X(235),LCD_Y(487),LCD_X(230),1,230,202,70,
                   focus_ok?text:"--");
      }}}
    ui_button(LCD_X(28),LCD_Y(532),LCD_X(180),LCD_Y(44),"通道波形",0);
    ui_button(LCD_X(220),LCD_Y(532),LCD_X(180),LCD_Y(44),"通道频谱",0);
    if(cq_check_state) {
        lcd_analysis_label(text,sizeof text,"正在检查 ",lcd_quality_progress()," / 8 路");
        ui_button(LCD_X(412),LCD_Y(532),LCD_X(200),LCD_Y(44),text,1);
        ui_label(LCD_X(630),LCD_Y(532),LCD_X(360),1,89,190,220,text);
    } else {
        ui_button(LCD_X(412),LCD_Y(532),LCD_X(200),LCD_Y(44),"全通道检查",0);
        if(!cq_check_count)
            ui_label(LCD_X(630),LCD_Y(532),LCD_X(360),1,140,153,170,"未检查");
        else {
            u32 any=0u;
            for(ch=0u;ch<8u;ch++)any|=cq_result_ok[ch];
            ui_label(LCD_X(630),LCD_Y(532),LCD_X(360),1,140,153,170,
                     any?"检查完成，调整电极后可复查":"无实时数据，请确认监测模式");
        }
    }
}
#endif

