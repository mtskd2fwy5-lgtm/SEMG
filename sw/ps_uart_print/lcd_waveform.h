/* Single-channel signed sample scope. Included by main.c after the LCD
 * primitives. This is a display-only branch: no rectification, MAV/RMS,
 * extra signal filtering, or changes to the recorder/recognition inputs.
 * All 4 kSPS samples of the selected channel/source enter a small ring.
 * A frame copies its samples into line commands before raster work starts.
 */
#ifndef LCD_WAVEFORM_H
#define LCD_WAVEFORM_H

#define WAVE_RING_SIZE 1024u
#define WAVE_RING_MASK (WAVE_RING_SIZE - 1u)
#define WAVE_SNAPSHOT_SIZE 800u         /* 200 ms at 4 kSPS */
#define WAVE_STALE_MS 250u

static i32 wave_ring[WAVE_RING_SIZE];
static u16 wave_seq[WAVE_RING_SIZE];
static u32 wave_write, wave_count, wave_channel, wave_notch = 1u;
static u32 wave_missing, wave_restarts, wave_last_t, wave_stale;
static u32 wave_paused, wave_time_sel = 1u, wave_scale_sel, wave_dc_auto = 1u;
static const u32 wave_times_ms[] = {50u, 100u, 200u};
static const i32 wave_scales[] = {0,100,500,2000,10000,50000,200000,1000000,10000000};
static i32 wave_snapshot[WAVE_SNAPSHOT_SIZE];
static u16 wave_age[WAVE_SNAPSHOT_SIZE];
static u32 wave_snapshot_count, wave_snapshot_missing, wave_snapshot_restarts;
static u32 wave_snapshot_valid;
/* Last rendered display metrics; also used by the host regression. */
static i32 wave_center, wave_span;
static u32 wave_visible, wave_clipped, wave_adc_clipped, wave_segments;

static void lcd_wave_changed(void)
{
    ui_generation++;
    lcd_input_status_changed();
}

static void lcd_wave_toggle(void)
{
    lcd_rehab_view=0u;
    lcd_settings_view=0u;
    lcd_synergy_view=0u;
    lcd_wave_view = !lcd_wave_view;
    ui_preview_cls = -1;
    lcd_wave_changed();
}

static void lcd_wave_select(u32 channel, u32 notch)
{
    if (channel >= 8u) return;
    wave_channel = channel;
    wave_notch = notch != 0u;
    wave_write = wave_count = wave_missing = wave_restarts = wave_stale = 0u;
    wave_snapshot_count = wave_snapshot_valid = wave_paused = 0u;
    lcd_wave_changed();
}

static void lcd_wave_ingest(u32 payload, u32 hdr)
{
    u32 type = hdr >> 28, delta;
    u16 seq = (u16)hdr;
    if (type != (wave_notch ? 5u : 1u) ||
        ((hdr >> 24) & 15u) != wave_channel || ((hdr >> 16) & 255u) != 0u)
        return;
    if (wave_count) {
        delta = (u16)(seq - wave_seq[(wave_write - 1u) & WAVE_RING_MASK]);
        if (!delta) return;             /* duplicate sample is not new time */
        if (delta >= 0x8000u) {
            wave_count = wave_write = 0u; /* restart: never join different epochs */
            wave_restarts++;
        } else if (delta > 1u) wave_missing += delta - 1u;
    }
    wave_ring[wave_write] = (i32)(payload << 8) >> 8;
    wave_seq[wave_write] = seq;
    wave_write = (wave_write + 1u) & WAVE_RING_MASK;
    if (wave_count < WAVE_RING_SIZE) wave_count++;
    wave_last_t = gt_stamp();
    wave_stale = 0u;
    if (lcd_wave_view && !wave_paused && !ui_menu_open) lcd_pending = 1u;
}

static void lcd_wave_tick(void)
{
    if (!lcd_wave_view || ui_menu_open || wave_paused || !wave_count || wave_stale)
        return;
    if (gt_stamp() - wave_last_t >= WAVE_STALE_MS * GT_TICKS_PER_MS) {
        wave_stale = 1u;
        lcd_pending = 1u;
    }
}

/* Freeze the last 200 ms, including timestamps, so timebase, DC display
 * and vertical range can still be changed while the live ring keeps filling. */
static void lcd_wave_snapshot(void)
{
    u32 i, n = 0u;
    u16 newest = wave_count ? wave_seq[(wave_write - 1u) & WAVE_RING_MASK] : 0u;
    for (i = 0; i < wave_count && n < WAVE_SNAPSHOT_SIZE; i++) {
        u32 index = (wave_write - 1u - i) & WAVE_RING_MASK;
        u16 age = (u16)(newest - wave_seq[index]);
        if (age >= WAVE_SNAPSHOT_SIZE) break;
        wave_snapshot[n] = wave_ring[index];
        wave_age[n++] = age;
    }
    wave_snapshot_count = n;
    wave_snapshot_missing = wave_missing;
    wave_snapshot_restarts = wave_restarts;
    wave_snapshot_valid = 1u;
}

static u32 lcd_wave_hit(u32 x, u32 y, i32 bx, i32 by, i32 bw, i32 bh)
{
    return (i32)x >= bx && (i32)x < bx + bw &&
           (i32)y >= by && (i32)y < by + bh;
}

static u32 lcd_wave_touch(u32 x, u32 y)
{
    u32 i;
    for (i = 0; i < 8u; i++)
        if (lcd_wave_hit(x,y,LCD_X(28)+(i32)i*LCD_X(122),LCD_Y(535),
                         LCD_X(112),LCD_Y(44))) {
            if (i != wave_channel) lcd_wave_select(i,wave_notch);
            return 1u;
        }
    for (i = 0; i < 5u; i++)
        if (lcd_wave_hit(x,y,LCD_X(28)+(i32)i*LCD_X(198),LCD_Y(148),
                         LCD_X(180),LCD_Y(44))) {
            if (i == 0u) { lcd_wave_select(wave_channel,!wave_notch); return 1u; }
            if (i == 1u) wave_time_sel = (wave_time_sel + 1u) % 3u;
            if (i == 2u) wave_scale_sel = (wave_scale_sel + 1u) %
                (sizeof wave_scales / sizeof wave_scales[0]);
            if (i == 3u) wave_dc_auto = !wave_dc_auto;
            if (i == 4u) {
                if (!wave_paused) lcd_wave_snapshot();
                wave_paused = !wave_paused;
            }
            lcd_wave_changed();
            return 1u;
        }
    return 0u;
}

/* ASCII label builder: freestanding firmware has no snprintf. */
static void lcd_wave_label(char *dst, const char *prefix, i32 value, const char *suffix)
{
    char digits[12]; u32 n = 0u, v;
    while (*prefix) *dst++ = *prefix++;
    if (value < 0) { *dst++ = '-'; v = 0u - (u32)value; }
    else v = (u32)value;
    do { digits[n++] = (char)('0' + v % 10u); v /= 10u; } while (v);
    while (n) *dst++ = digits[--n];
    while (*suffix) *dst++ = *suffix++;
    *dst = '\0';
}

static void lcd_wave_button(i32 x, i32 y, i32 w, const char *label, u32 selected)
{
    ui_button(x,y,w,LCD_Y(44),label,selected);
}

/* Thin bounded Bresenham segments, one draw command per adjacent pair of
 * samples. Even a maximum-height segment is at most one plot-height walk. */
static void lcd_wave_line(volatile u8 *fb,i32 x0,i32 y0,i32 x1,i32 y1,u8 r,u8 g,u8 b)
{
    i32 dx=lcd_abs(x1-x0),sx=x0<x1?1:-1;
    i32 dy=-lcd_abs(y1-y0),sy=y0<y1?1:-1,err=dx+dy;
    for (;;) {
        i32 twice=2*err;
        lcd_fill_row(fb,y0,x0,x0,r,g,b);
        if (x0==x1 && y0==y1) break;
        if (twice>=dy) {err+=dy;x0+=sx;}
        if (twice<=dx) {err+=dx;y0+=sy;}
    }
}

static void lcd_wave_segment(i32 x0,i32 y0,i32 x1,i32 y1)
{
    if (dl_mode) dl_push(8,x0,y0,x1,y1,0,DL_RGB(25,120,111),(const char *)0);
    else lcd_wave_line(dl_fb_now,x0,y0,x1,y1,25,120,111);
}

static i32 lcd_wave_y(i32 value,i32 top,i32 height)
{
    i32 relative=value-wave_center;
    if (relative>wave_span) {relative=wave_span;wave_clipped=1u;}
    if (relative<-wave_span) {relative=-wave_span;wave_clipped=1u;}
    return top+height/2-(i32)((int64_t)relative*(height/2)/wave_span);
}

/* Tick labels stay within the left gutter at full ADC range. The exact
 * counts remain in the Y +/- readout above the plot. */
static void lcd_wave_axis(char label[48],i32 value)
{
    i32 magnitude=lcd_abs(value);
    if(magnitude>=1000000 && magnitude%1000000==0)
        lcd_wave_label(label,"",value/1000000,"M");
    else if(magnitude>=1000 && magnitude%1000==0)
        lcd_wave_label(label,"",value/1000,"K");
    else lcd_wave_label(label,"",value,"");
}

static void lcd_wave_render(void)
{
    char label[48];
    i32 left=LCD_X(82),top=LCD_Y(232),width=LCD_X(980)-left;
    i32 height=LCD_Y(492)-top,peak=0;
    u32 i,window=wave_times_ms[wave_time_sel]*4u,n=0u;
    int64_t sum=0;
    if (!wave_paused || !wave_snapshot_valid) lcd_wave_snapshot();
    while (n<wave_snapshot_count && wave_age[n]<window) sum+=wave_snapshot[n++];
    wave_visible=n;
    wave_center=wave_dc_auto && n ? (i32)(sum/(i32)n) : 0;
    for (i=0;i<n;i++) {
        i32 a=lcd_abs(wave_snapshot[i]-wave_center);
        if (a>peak) peak=a;
    }
    wave_span=wave_scales[wave_scale_sel];
    if (!wave_span) {
        i32 base=10,needed=peak+peak/4;
        while (base<needed && base<100000000) base*=10;
        wave_span=base/5>=needed && base>=50 ? base/5 :
                  base/2>=needed ? base/2 : base;
        if (wave_span<10) wave_span=10;
    }
    lcd_wave_label(label,"通道",(i32)wave_channel+1,"");
    p_text(LCD_X(28),LCD_Y(104),2,89,220,170,label);
    p_text(LCD_X(180),LCD_Y(104),2,140,153,170,"采样率 4000 Hz");
    p_text(LCD_X(430),LCD_Y(104),2,238,243,250,
           wave_paused ? "已暂停" : !wave_count ? "等待数据" : wave_stale ? "信号中断" : "实时波形");
    lcd_wave_label(label,"缺样 ",(i32)wave_snapshot_missing," 点");
    ui_label(LCD_X(680),LCD_Y(98),LCD_X(320),2,255,180,110,label);
    lcd_wave_label(label,"重启 ",(i32)wave_snapshot_restarts," 次");
    ui_label(LCD_X(680),LCD_Y(122),LCD_X(320),2,140,153,170,label);
    for (i=0;i<5u;i++) {
        const char *text=label;
        if (i==0u) text=wave_notch ? "全处理" : "原始";
        if (i==1u) lcd_wave_label(label,"",(i32)wave_times_ms[wave_time_sel]," ms");
        if (i==2u) {
            if (!wave_scale_sel) text="自动量程";
            else lcd_wave_label(label,"Y ",wave_scales[wave_scale_sel],"");
        }
        if (i==3u) text=wave_dc_auto ? "自动居中" : "零点居中";
        if (i==4u) text=wave_paused ? "继续" : "暂停";
        lcd_wave_button(LCD_X(28)+(i32)i*LCD_X(198),LCD_Y(148),LCD_X(180),text,
                        i==4u && wave_paused);
    }
    lcd_wave_label(label,"均值 ",wave_center,"");
    ui_label(left,LCD_Y(208),LCD_X(400),2,140,153,170,label);
    lcd_wave_label(label,"幅值±",wave_span,"");
    ui_label(LCD_X(550),LCD_Y(208),LCD_X(265),2,140,153,170,label);
    p_rect(left,top,width,height+1,11,17,26);
    for (i=0;ui_grid_enabled && i<=10u;i++)
        p_rect(left+(i32)i*(width-1)/10,top,1,height+1,35,47,62);
    for (i=0;ui_grid_enabled && i<=4u;i++)
        p_rect(left,top+(i32)i*height/4,width,1,i==2u?70:35,i==2u?92:47,i==2u?110:62);
    lcd_wave_axis(label,wave_span);
    p_text(left-LCD_X(8)-ui_text_width(label,2),top,2,140,153,170,label);
    p_text(left-LCD_X(8)-ui_text_width("0",2),top+height/2-lcd_line_height(2)/2,2,140,153,170,"0");
    lcd_wave_axis(label,-wave_span);
    p_text(left-LCD_X(8)-ui_text_width(label,2),top+height-lcd_line_height(2),2,140,153,170,label);
    lcd_wave_label(label,"-",(i32)wave_times_ms[wave_time_sel]," ms");
    p_text(left,LCD_Y(506),1,140,153,170,label);
    lcd_wave_label(label,"-",(i32)wave_times_ms[wave_time_sel]/2," ms");
    p_text(left+(width-ui_text_width(label,1))/2,LCD_Y(506),1,140,153,170,label);
    p_text(left+width-ui_text_width("0 ms",1),LCD_Y(506),1,140,153,170,"0 ms");
    wave_clipped=wave_adc_clipped=wave_segments=0u;
    for (i=0;i<n;i++) {
        /* Keep display clipping separate from a real 24-bit ADC rail hit.
         * Manual Y range can clip a perfectly valid sample; only values at
         * the converter rails are reported as ADC CLIP. */
        if (wave_snapshot[i] >= 8387000 || wave_snapshot[i] <= -8387000)
            wave_adc_clipped=1u;
        i32 x=left+width-1-(i32)wave_age[i]*(width-1)/(i32)(window-1u);
        i32 y=lcd_wave_y(wave_snapshot[i],top,height);
        if (i+1u<n && wave_age[i+1u]==wave_age[i]+1u) {
            i32 px=left+width-1-(i32)wave_age[i+1u]*(width-1)/(i32)(window-1u);
            lcd_wave_segment(px,lcd_wave_y(wave_snapshot[i+1u],top,height),x,y);
            wave_segments++;
        } else lcd_wave_segment(x,y,x,y);
    }
    if (wave_adc_clipped || wave_clipped)
        ui_label(LCD_X(820),LCD_Y(208),LCD_X(180),2,255,120,90,wave_adc_clipped?"ADC过载":"显示截幅");
    for (i=0;i<8u;i++) {
        lcd_wave_label(label,"通道",(i32)i+1,"");
        lcd_wave_button(LCD_X(28)+(i32)i*LCD_X(122),LCD_Y(535),LCD_X(112),label,
                        i==wave_channel);
    }
}

#endif
