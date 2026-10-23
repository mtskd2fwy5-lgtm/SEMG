/* LCD software 3D renderer. Bone dimensions/outline reuse virtual_hand.py.
 * Model coordinates: x across palm, y wrist->fingers, z toward palm.
 * Left hand mirrors the template geometry. Eye camera remains fixed.
 * Q12 transforms, perspective inverse-depth and a shared depth buffer
 * provide real occlusion; only the free framebuffer is ever rasterized.
 */
#define LCD_HAND_LEFT 1
typedef struct { i32 x,y,z; } hand_v3;
typedef struct { i32 x,y,d; } hand_screen;
static u16 lcd_depth[1024u*600u];
static i32 lcd_draw_matrix[9] = {-4096,0,0,0,4096,0,0,0,-4096};
static i32 lcd_draw_angles[22];
static i32 lcd_pose_cur[22], lcd_pose_from[22];
static u32 lcd_pose_cls, lcd_pose_t0, lcd_pose_initialized, lcd_animation_busy;

static i32 hand_abs(i32 v) { return v<0 ? -v : v; }
static hand_v3 hand_add(hand_v3 a,hand_v3 b)
{ return (hand_v3){a.x+b.x,a.y+b.y,a.z+b.z}; }
static hand_v3 hand_sub(hand_v3 a,hand_v3 b)
{ return (hand_v3){a.x-b.x,a.y-b.y,a.z-b.z}; }
static hand_v3 hand_scale(hand_v3 a,i32 n,i32 d)
{ return (hand_v3){a.x*n/d,a.y*n/d,a.z*n/d}; }
static hand_v3 hand_cross(hand_v3 a,hand_v3 b)
{ return (hand_v3){a.y*b.z-a.z*b.y,a.z*b.x-a.x*b.z,a.x*b.y-a.y*b.x}; }
static u32 hand_sqrt(u32 n)
{
    u32 bit=1u<<30, out=0;
    while(bit>n) bit>>=2;
    while(bit) {
        if(n>=out+bit) { n-=out+bit; out=(out>>1)+bit; }
        else out>>=1;
        bit>>=2;
    }
    return out;
}
static hand_v3 hand_unit(hand_v3 a)
{
    u32 n;
    while(hand_abs(a.x)>16384 || hand_abs(a.y)>16384 || hand_abs(a.z)>16384)
        a=hand_scale(a,1,2);
    n=hand_sqrt((u32)(a.x*a.x+a.y*a.y+a.z*a.z));
    return n ? hand_scale(a,4096,(i32)n) : (hand_v3){0,4096,0};
}
static hand_v3 hand_rx(hand_v3 p,i32 angle)
{
    i32 c=lcd_cos_q12(angle), s=lcd_sin_q12(angle);
    return (hand_v3){p.x,(p.y*c-p.z*s)/4096,(p.y*s+p.z*c)/4096};
}
static hand_v3 hand_ry(hand_v3 p,i32 angle)
{
    i32 c=lcd_cos_q12(angle), s=lcd_sin_q12(angle);
    return (hand_v3){(p.x*c+p.z*s)/4096,p.y,(-p.x*s+p.z*c)/4096};
}
static hand_v3 hand_rz(hand_v3 p,i32 angle)
{
    i32 c=lcd_cos_q12(angle), s=lcd_sin_q12(angle);
    return (hand_v3){(p.x*c-p.y*s)/4096,(p.x*s+p.y*c)/4096,p.z};
}
static hand_v3 hand_camera(hand_v3 p,u32 is_hand)
{
    hand_v3 q;
    i32 c=lcd_cos_q12(50),s=lcd_sin_q12(50);
    if(LCD_HAND_LEFT) p.x=-p.x;
    if(is_hand) {
        /* wf>0 is flexion toward the palm (+model z); extension is wf<0.
         * Rotate locally before the forearm attitude so pronation never
         * swaps the anatomical meaning. The wrist remains the pivot. */
        p=hand_rx(p,lcd_draw_angles[0]);
        p=hand_rz(p,(LCD_HAND_LEFT ? -1 : 1)*lcd_draw_angles[1]);
    }
    p.y+=174;                     /* rotate complete arm about elbow */
    q.x=(lcd_draw_matrix[0]*p.x+lcd_draw_matrix[1]*p.y+lcd_draw_matrix[2]*p.z)/4096;
    q.y=(lcd_draw_matrix[3]*p.x+lcd_draw_matrix[4]*p.y+lcd_draw_matrix[5]*p.z)/4096;
    q.z=(lcd_draw_matrix[6]*p.x+lcd_draw_matrix[7]*p.y+lcd_draw_matrix[8]*p.z)/4096;
    /* Eye looks down at an arm extending forward. Positive normal points
     * away from the eye; palm/back visibility comes from geometry rotation. */
    return (hand_v3){q.x,-260+(s*q.y-c*q.z)/4096,800+(c*q.y+s*q.z)/4096};
}
static hand_screen hand_project(hand_v3 p)
{
    /* Conservative camera distance keeps this whole model past near=180. */
    if(p.z<180) p.z=180;
    return (hand_screen){LCD_X(512)+p.x*LCD_X(1000)/p.z,
                        LCD_Y(270)-p.y*LCD_Y(1000)/p.z,6000000/p.z};
}
static void lcd_depth_clear(i32 y,i32 rows)
{
    i32 end=y+rows,x;
    if(y<0) y=0;
    if(end>LCD_H) end=LCD_H;
    for(;y<end;y++) for(x=0;x<LCD_W;x++) lcd_depth[y*LCD_W+x]=0;
}
static void lcd_depth_triangle(volatile u8 *fb,const lcd_dl_t *e,u8 r,u8 g,u8 b)
{
    i32 x[3]={e->v0,e->v3,e->v6},y[3]={e->v1,e->v4,e->v7};
    i32 d[3]={e->v8,e->v2,e->v5};
    i32 lo=y[0],hi=y[0],k,yy;
    for(k=1;k<3;k++) { if(y[k]<lo)lo=y[k]; if(y[k]>hi)hi=y[k]; }
    if(lo<lcd_clip_top)lo=lcd_clip_top;
    if(hi>=lcd_clip_bottom)hi=lcd_clip_bottom-1;
    if(lo<0)lo=0;
    if(hi>=LCD_H)hi=LCD_H-1;
    for(yy=lo;yy<=hi;yy++) {
        i32 lx=0,rx=0,ld=0,rd=0,hits=0,xx,run=-1,depth_q,step_q;
        for(k=0;k<3;k++) {
            i32 j=(k+1)%3,ey=y[j]-y[k],ex,ed;
            /* Half-open edges avoid double coverage at shared vertices. */
            if(!ey || yy<(y[k]<y[j]?y[k]:y[j]) || yy>=(y[k]>y[j]?y[k]:y[j])) continue;
            ex=x[k]+(x[j]-x[k])*(yy-y[k])/ey;
            ed=d[k]+(d[j]-d[k])*(yy-y[k])/ey;
            if(!hits || ex<lx) { lx=ex;ld=ed; }
            if(!hits || ex>rx) { rx=ex;rd=ed; }
            hits++;
        }
        if(hits<2 || rx<0 || lx>=LCD_W) continue;
        /* Cortex-A9 has no integer divide instruction. Interpolate Q12
         * inverse depth once per row, then step it using additions. */
        xx=lx<0?0:lx;
        step_q=rx!=lx ? (rd-ld)*4096/(rx-lx) : 0;
        depth_q=ld*4096+step_q*(xx-lx);
        for(;xx<=rx && xx<LCD_W;xx++,depth_q+=step_q) {
            i32 depth=depth_q>>12;
            u16 *z=&lcd_depth[yy*LCD_W+xx];
            if(depth>=(i32)*z) { *z=(u16)depth; if(run<0)run=xx; }
            else if(run>=0) { lcd_fill_row(fb,yy,run,xx-1,r,g,b);run=-1; }
        }
        if(run>=0) lcd_fill_row(fb,yy,run,xx-1,r,g,b);
    }
}
static void hand_triangle(hand_v3 a,hand_v3 b,hand_v3 c,u32 hand,u32 color)
{
    lcd_dl_t e={0};
    hand_screen pa,pb,pc;
    hand_v3 n;
    i32 light,den;
    u8 r=(u8)(color>>16),g=(u8)(color>>8),blue=(u8)color;
    a=hand_camera(a,hand);b=hand_camera(b,hand);c=hand_camera(c,hand);
    n=hand_cross(hand_sub(b,a),hand_sub(c,a));
    den=hand_abs(n.x)+hand_abs(n.y)+hand_abs(n.z);
    /* Broad, soft light for skin; keep enough directional shading to read
     * the finger joints against the white dashboard without an orange cast. */
    light=den ? (hand?76:68)+(hand?24:32)*hand_abs(-n.x+2*n.y-n.z)/(2*den) : 85;
    r=(u8)(r*light/100);g=(u8)(g*light/100);blue=(u8)(blue*light/100);
    pa=hand_project(a);pb=hand_project(b);pc=hand_project(c);
    e.op=6;e.rgb=DL_RGB(r,g,blue);
    e.v0=pa.x;e.v1=pa.y;e.v2=pb.d;
    e.v3=pb.x;e.v4=pb.y;e.v5=pc.d;
    e.v6=pc.x;e.v7=pc.y;e.v8=pa.d;e.str=0;
    if(dl_mode) {
        if(dl_len<LCD_DL_MAX) dl[dl_len++]=e;
        else dl_trunc=1u;
    } else lcd_depth_triangle(dl_fb_now,&e,r,g,blue);
}
static void hand_face(hand_v3 a,hand_v3 b,hand_v3 c,hand_v3 d,u32 hand,u32 rgb)
{ hand_triangle(a,b,c,hand,rgb);hand_triangle(a,c,d,hand,rgb); }
static void hand_tube(const hand_v3 *points,const i32 *radii,i32 count,u32 hand,u32 rgb)
{
    hand_v3 rings[7][8];
    i32 i,j;
    for(i=0;i<count;i++) {
        hand_v3 t,u,v;
        if(i==0)t=hand_sub(points[1],points[0]);
        else if(i==count-1)t=hand_sub(points[i],points[i-1]);
        else t=hand_sub(points[i+1],points[i-1]);
        t=hand_unit(t);
        /* Stable transverse reference as fingers bend through 180 degrees. */
        u=hand_unit(hand_cross(t,(hand_v3){4096,0,0}));
        v=hand_scale(hand_cross(t,u),1,4096);
        for(j=0;j<8;j++) {
            i32 cs=lcd_cos_q12(j*45),sn=lcd_sin_q12(j*45);
            hand_v3 off={(u.x*cs+v.x*sn)/4096,(u.y*cs+v.y*sn)/4096,(u.z*cs+v.z*sn)/4096};
            rings[i][j]=hand_add(points[i],hand_scale(off,radii[i],4096));
        }
    }
    for(i=0;i<count-1;i++)for(j=0;j<8;j++)
        hand_face(rings[i][j],rings[i][(j+1)%8],rings[i+1][(j+1)%8],rings[i+1][j],hand,rgb);
    for(j=0;j<8;j++) {
        hand_triangle(points[0],rings[0][(j+1)%8],rings[0][j],hand,rgb);
        hand_triangle(points[count-1],rings[count-1][j],rings[count-1][(j+1)%8],hand,rgb);
    }
}
static hand_v3 hand_digit_step(hand_v3 p,i32 spread,i32 flex,i32 length)
{
    i32 cf=lcd_cos_q12(flex),sf=lcd_sin_q12(flex);
    return hand_add(p,(hand_v3){length*lcd_sin_q12(spread)*cf/16777216,
                               length*lcd_cos_q12(spread)*cf/16777216,length*sf/4096});
}
static void lcd_draw_hand(u32 cls,u32 fatigue)
{
    static const i32 outline[12][2]={{-36,0},{-48,8},{-60,35},{-66,82},{-58,100},{-30,98},
                                   {0,96},{30,98},{58,100},{66,82},{60,35},{48,8}};
    static const i32 fx[4]={-43,-14,15,43},fy[4]={94,100,98,90};
    static const i32 l1[4]={43,48,45,37},l2[4]={31,34,32,26},l3[4]={22,25,23,19};
    /* Warm neutral skin and a muted teal sleeve echo the clinical palette.
     * Fatigue still has a separate colored wrist band, never tinted skin. */
    static const u32 skin=0xd6b5a3,palm=0xe6c7b7,sleeve=0x526e73;
    static const u32 bands[4]={0x65988f,0xe6ca46,0xe65656,0xbe46be};
    hand_v3 p[7];i32 rad[7],i,j;
    (void)cls;
    /* Depth clear shares the renderer's slicing and DMA-priority behavior. */
    for(i=0;i<LCD_H;i+=4) {
        if(dl_mode)dl_push(7,i,4,0,0,0,0,0);
        else lcd_depth_clear(i,4);
    }
    p[0]=(hand_v3){0,-174,0};p[1]=(hand_v3){0,-85,0};p[2]=(hand_v3){0,-4,0};
    rad[0]=31;rad[1]=33;rad[2]=35;hand_tube(p,rad,3,0,sleeve);
    p[0]=(hand_v3){0,-45,0};p[1]=(hand_v3){0,-8,0};
    rad[0]=35;rad[1]=36;hand_tube(p,rad,2,0,bands[fatigue<4u?fatigue:3u]);
    for(i=0;i<12;i++) {
        j=(i+1)%12;
        hand_v3 a={outline[i][0],outline[i][1],-14},b={outline[j][0],outline[j][1],-14};
        hand_v3 c={b.x,b.y,14},d={a.x,a.y,14};
        hand_face(a,b,c,d,1,skin);
        hand_triangle((hand_v3){0,60,-16},b,a,1,skin);
        hand_triangle((hand_v3){0,60,16},d,c,1,palm);
    }
    for(i=0;i<4;i++) {
        i32 off=2+i*4,spread=lcd_draw_angles[off+1];
        i32 a1=lcd_draw_angles[off],a2=a1+lcd_draw_angles[off+2];
        i32 a3=a2+(55*lcd_draw_angles[off+2]+45*lcd_draw_angles[off+3])/100;
        hand_v3 b={fx[i],fy[i],-8},j1=hand_digit_step(b,spread,a1,l1[i]);
        hand_v3 j2=hand_digit_step(j1,spread,a2,l2[i]),tip=hand_digit_step(j2,spread,a3,l3[i]);
        p[0]=b;p[1]=hand_scale(hand_add(b,j1),1,2);p[2]=j1;
        p[3]=hand_scale(hand_add(j1,j2),1,2);p[4]=j2;p[5]=tip;
        rad[0]=i==3?12:14;rad[1]=rad[0]+1;rad[2]=12;rad[3]=11;rad[4]=9;rad[5]=6;
        hand_tube(p,rad,6,1,skin);
    }
    /* CMC opposition bends in 3D; thumb wraps over the flexed fingers. */
    { i32 cmc=lcd_draw_angles[18],abd=lcd_draw_angles[19],mcp=lcd_draw_angles[20],ip=lcd_draw_angles[21];
      i32 oppose=(mcp+ip)*100/140,plane2=abd+(90-abd)*oppose/100;
      p[0]=(hand_v3){-46,26,-6};
      p[1]=hand_digit_step(p[0],abd,cmc*60/100,26);
      p[2]=hand_digit_step(p[1],plane2,(cmc*40+mcp*60)/100,32);
      p[3]=hand_digit_step(p[2],plane2+(105-plane2)*ip/80,(cmc*25+mcp*40+ip*35)/100,24);
      rad[0]=17;rad[1]=16;rad[2]=13;rad[3]=8;hand_tube(p,rad,4,1,skin);
    }
}
static void lcd_pose_sample(u32 cls)
{
    u32 i,t=gt_stamp(),elapsed=(t-lcd_pose_t0)/GT_TICKS_PER_MS;
    if(cls>=POSE_MODEL_CLASSES)cls=0;
    if(!lcd_pose_initialized) {
        lcd_pose_initialized=1; lcd_pose_cls=cls;
        for(i=0;i<22;i++)lcd_pose_cur[i]=lcd_pose_from[i]=pose_table[cls][i]*256;
        lcd_pose_t0=t;lcd_animation_busy=0;
    } else if(lcd_animation_busy) {
        if(elapsed>POSE_SMOOTH_MS)elapsed=POSE_SMOOTH_MS;
        for(i=0;i<22;i++)lcd_pose_cur[i]=lcd_pose_from[i]+
            (pose_table[lcd_pose_cls][i]*256-lcd_pose_from[i])*(i32)elapsed/(i32)POSE_SMOOTH_MS;
        if(elapsed==POSE_SMOOTH_MS)lcd_animation_busy=0;
    }
    if(cls!=lcd_pose_cls) {
        for(i=0;i<22;i++)lcd_pose_from[i]=lcd_pose_cur[i];
        lcd_pose_t0=t;lcd_pose_cls=cls;lcd_animation_busy=1;
    }
    for(i=0;i<22;i++) {
        i32 v=lcd_pose_cur[i];
        lcd_draw_angles[i]=(v+(v>=0?128:-128))/256;
    }
}
static void lcd_hand_snapshot(void)
{
    i32 i;
    if(lcd_imu_valid) {
        for(i=0;i<9;i++)lcd_draw_matrix[i]=lcd_imu_matrix[i];
    } else {
        /* Palm-up home = Ry(180). Apply elevation in fixed world axes
         * after pronation, so flipping never reverses the lift direction. */
        for(i=0;i<3;i++) {
            hand_v3 p={i==0?4096:0,i==1?4096:0,i==2?4096:0};
            p=hand_rx(hand_ry(p,180+lcd_draw_tilt),-lcd_draw_shift);
            lcd_draw_matrix[i]=p.x;lcd_draw_matrix[3+i]=p.y;lcd_draw_matrix[6+i]=p.z;
        }
    }
}
