/* Common LCD text sizing and controls. Coordinates are physical pixels.
 * Both fitting and rasterization use native Source Han Sans glyph metrics. */
#ifndef LCD_UI_H
#define LCD_UI_H
static i32 ui_text_width(const char *text,i32 scale)
{
    i32 width=0;
    while(*text) {
        u16 cp;
        text+=lcd_utf8_char(text,&cp);
        width+=lcd_char_advance(cp,scale);
    }
    return width;
}

static i32 ui_text_height(const char *text,i32 scale)
{
    (void)text;
    return lcd_line_height(scale);
}

/* Truncate at character boundaries instead of painting into adjacent cards.
 * Returns the complete displayed width, including an explicit ellipsis. */
static i32 ui_fit_label(char out[48],const char *text,i32 width,i32 scale)
{
    i32 used=0;u32 n=0,bytes,total=0;
    while(text[total]) total++;
    i32 clipped=ui_text_width(text,scale)>width || total>47u;
    i32 available=width-(clipped?ui_text_width("...",scale):0);
    if(available<0) { out[0]=0;return 0; }
    while(*text) {
        i32 advance;
        u16 cp;
        bytes=lcd_utf8_char(text,&cp);
        if(n+bytes>(clipped?44u:47u)) break;
        advance=lcd_char_advance(cp,scale);
        if(used+advance>available) break;
        while(bytes--) out[n++]=*text++;
        used+=advance;
    }
    if(*text && clipped) { out[n++]='.';out[n++]='.';out[n++]='.';used+=ui_text_width("...",scale); }
    out[n]=0;return used;
}

static void ui_label(i32 x,i32 y,i32 w,i32 scale,u8 r,u8 g,u8 b,const char *text)
{
    char fitted[48];
    ui_fit_label(fitted,text,w,scale);
    p_text(x,y,scale,r,g,b,fitted);
}

/* Use one physical baseline when a row contains different font sizes. */
static void ui_label_baseline(i32 x,i32 baseline,i32 w,i32 scale,
                              u8 r,u8 g,u8 b,const char *text)
{
    ui_label(x,baseline-lcd_text_baseline(scale),w,scale,r,g,b,text);
}

static u32 ui_button_pressed(i32 x,i32 y,i32 w,i32 h)
{
    return ui_feedback_active && (y<LCD_Y(92) || ui_feedback_owner==ui_page_owner()) &&
        (i32)ui_feedback_x>=x && (i32)ui_feedback_x<x+w &&
        (i32)ui_feedback_y>=y && (i32)ui_feedback_y<y+h;
}
static void ui_button_press_border(i32 x,i32 y,i32 w,i32 h)
{
    i32 t=LCD_S(3);
    if(!ui_button_pressed(x,y,w,h))return;
    p_rect(x,y,w,t,38,204,164);p_rect(x,y+h-t,w,t,38,204,164);
    p_rect(x,y,t,h,38,204,164);p_rect(x+w-t,y,t,h,38,204,164);
}
static void ui_button(i32 x,i32 y,i32 w,i32 h,const char *text,u32 selected)
{
    char fitted[48];i32 scale=2,width;u32 pressed=ui_button_pressed(x,y,w,h);
    width=ui_fit_label(fitted,text,w-LCD_X(20),scale);
    p_round_rect(x,y,w,h,LCD_S(7),pressed?164:selected?126:239,
        pressed?245:selected?210:244,pressed?212:selected?195:244);
    p_text(x+(w-width)/2,y+(h-ui_text_height(fitted,scale))/2,scale,
           selected?18:31,selected?75:49,selected?67:58,fitted);
    if(selected) p_rect(x+LCD_X(12),y+h-LCD_Y(5),w-LCD_X(24),LCD_Y(2),25,120,111);
    ui_button_press_border(x,y,w,h);
}

#endif
