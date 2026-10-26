/* Runs the real firmware renderer/input scheduler with simulated MMIO.
 * It verifies frame ownership, update coalescing, clean-before-present,
 * input edges, calibration and timer rollover, and exports real pixels.
 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#define LCD_HOST_TEST 1
#define main firmware_main
#include "../sw/ps_uart_print/main.c"
#undef main

unsigned char __dma_buf[1048576];
static unsigned char frames[3][1024*600*3+64];
static volatile u32 regs[16];
static u32 test_time, clean_count;
static u32 test_clock_step=100u*333u;
static u32 test_clean_bytes[3];
static u32 mock_sd_active,mock_sd_ready,mock_sd_error,mock_sd_frames;
static u32 mock_sd_last_action;
static int mock_sd_last_raw[8],mock_sd_last_notch[8];

int sd_record_start(void) { mock_sd_ready=1u;mock_sd_error=0u;mock_sd_active=1u;return 1; }
int sd_record_stop(void) { mock_sd_active=0u;return 1; }
void sd_record_abort(uint32_t error) { mock_sd_active=0u;mock_sd_error=error; }
int sd_record_append(uint16_t seq,uint8_t action,const int raw[8],const int notch[8])
{
    u32 i;(void)seq;mock_sd_frames++;mock_sd_last_action=action;
    for(i=0;i<8;i++){mock_sd_last_raw[i]=raw[i];mock_sd_last_notch[i]=notch[i];}
    return 1;
}
int sd_record_active(void) { return (int)mock_sd_active; }
int sd_record_ready(void) { return (int)mock_sd_ready; }
int sd_record_error(void) { return (int)mock_sd_error; }
uint32_t sd_record_frames(void) { return mock_sd_frames; }
const char *sd_record_filename(void) { return "EMG000.BIN"; }
static u32 mock_rehab_save_error,mock_rehab_saves;
static char mock_rehab_csv[16384];
uint32_t sd_training_save(const char *data,uint32_t bytes,char name[13])
{
    if(mock_sd_active)return 0x301u;
    if(mock_rehab_save_error)return mock_rehab_save_error;
    assert(bytes<sizeof mock_rehab_csv);memcpy(mock_rehab_csv,data,bytes);mock_rehab_csv[bytes]=0;
    strcpy(name,"RH000.CSV");mock_rehab_saves++;return 0;
}

static u32 mock_hdc_saves;
uint32_t sd_hand_read(uint32_t slot,void *d,uint32_t b)
{(void)slot;(void)d;(void)b;return 1u;}
uint32_t sd_hand_write(uint32_t slot,const void *d,uint32_t b)
{(void)slot;(void)d;(void)b;return 1u;}
uint32_t sd_hdc_save(const char *data,uint32_t bytes,char name[13])
{
    u32 rc=sd_training_save(data,bytes,name);
    if(!rc){strcpy(name,"HD000.CSV");mock_hdc_saves++;}
    return rc;
}

volatile u32 *lcd_test_mmio(u32 address)
{
    switch (address) {
    case 0xe000002c: return &regs[0];
    case 0x40400034: return &regs[1];
    case 0x43000028: return &regs[2];
    case 0x41210000: return &regs[3];
    case 0x41210008: return &regs[10];
    case 0x41220000: return &regs[4];
    case 0x41220008: return &regs[7];
    case 0x41230000: return &regs[8];
    case 0x41230008: return &regs[9];
    case 0x43000004: return &regs[5];
    default: return &regs[6];
    }
}
volatile u8 *lcd_test_fb(u32 index) { assert(index<3); return frames[index]+32; }
u32 lcd_test_clock(void) { test_time+=test_clock_step; return test_time; }
void display_memory_clean(uintptr_t address, u32 bytes)
{
    u32 i;
    for(i=0;i<3;i++)
        if(address >= (uintptr_t)(frames[i]+32) &&
           address+bytes <= (uintptr_t)(frames[i]+32+FB_BYTES)) {
            clean_count++; test_clean_bytes[i]+=bytes; return;
        }
    assert(0 && "cache clean outside framebuffer");
}

static u32 hash(u32 index)
{
    u32 i,h=2166136261u;
    for(i=0;i<FB_BYTES;i++) h=(h^frames[index][i+32])*16777619u;
    return h;
}
static void guard_check(void)
{
    u32 i,j;
    for(i=0;i<3;i++) for(j=0;j<32;j++) {
        assert(frames[i][j]==0xa5);
        assert(frames[i][32+FB_BYTES+j]==0xa5);
    }
}
static void scanout_accept(void)
{
    regs[2]=(regs[2]&~0x1f0000u)|((regs[2]&31u)<<16);
}
static void drain_frame(void)
{
    u32 n;
    for(n=0;n<20000u && (dl_busy||lcd_pending);n++) {
        u32 actual=VDMA_PARK_CURRENT(regs[2]), ref=regs[2]&31u;
        u32 ha=hash(actual), hr=hash(ref), before=lcd_present_cnt;
        lcd_slice_tick(gt_stamp());
        assert(hash(actual)==ha && hash(ref)==hr);
        if(before != lcd_present_cnt) {
            assert(dl_clean_y==(u32)LCD_H);
            assert(test_clean_bytes[dl_back]>=FB_BYTES);
            test_clean_bytes[dl_back]=0;
        }
        scanout_accept();
    }
    assert(n<20000u);
    guard_check();
}
static void ppm(const char *name)
{
    FILE *f=fopen(name,"wb"); u32 i,index=regs[2]&31u;
    assert(f); fprintf(f,"P6\n%d %d\n255\n",LCD_W,LCD_H);
    for(i=0;i<FB_BYTES;i+=3u) {
        fputc(frames[index][32+i+2],f); fputc(frames[index][32+i+1],f);
        fputc(frames[index][32+i],f);
    }
    fclose(f);
}
static void press(u32 x,u32 y)
{
    regs[3]=0x80000000u|(x<<12)|y; touch_tick();
    regs[3]|=0x40000000u; touch_tick();
}
static void expected_frame(void)
{
    u32 index=regs[2]&31u, spare=(index+1u)%3u;
    dl_fb_now=lcd_test_fb(spare); dl_mode=0u;
    lcd_draw_tilt=lcd_state_tilt; lcd_draw_shift=lcd_state_shift;
    lcd_hand_snapshot();
    lcd_render_pose(lcd_state_cls,lcd_state_conf,lcd_state_fatigue,lcd_state_gated,1u);
    assert(memcmp(frames[index]+32,frames[spare]+32,FB_BYTES)==0);
}
/* Independent physical oracle: right-handed world = right/forward/up.
 * Sensor columns are X->little finger, Y->elbow, Z->dorsal. Gravity and
 * body gyro come from double-precision rotation matrices, not firmware
 * quaternions or the firmware mapping constants. Renderer z is down. */
static double physical[9], sensor_bias[3];
static double matrix_max_error;
static u32 sensor_seq,sensor_noise;
static i32 rounded(double x) { return (i32)(x>=0 ? x+0.5 : x-0.5); }
static void physical_step(u32 axis,double degrees)
{
    double r[9]={1,0,0,0,1,0,0,0,1},out[9]={0};
    double a=degrees*3.141592653589793/180.0,c=cos(a),s=sin(a);
    u32 i,j,k;
    if(axis==0) {r[4]=r[8]=c;r[5]=-s;r[7]=s;}
    if(axis==1) {r[0]=r[8]=c;r[2]=s;r[6]=-s;}
    if(axis==2) {r[0]=r[4]=c;r[1]=-s;r[3]=s;}
    for(i=0;i<3;i++)for(j=0;j<3;j++)for(k=0;k<3;k++)out[i*3+j]+=r[i*3+k]*physical[k*3+j];
    memcpy(physical,out,sizeof physical);
}
static void sensor_sample(const double *rate, u32 pulse)
{
    double acc[3]={physical[6],physical[7],physical[8]};
    i32 a[3],g[3];u32 i;
    if(pulse==1)acc[0]+=0.4; /* Non-gravity acceleration, often changes |a| */
    if(pulse==2) { /* Unit-norm transient: |a| alone is insufficient. */
        double c=cos(0.21),s=sin(0.21),x=acc[0];
        acc[0]=c*x+s*acc[2];acc[2]=-s*x+c*acc[2];
    }
    if(sensor_noise) {
        double s=(sensor_seq&1u)?1:-1;
        acc[0]+=s*0.008;acc[1]-=s*0.006;acc[2]+=s*0.004;
    }
    for(i=0;i<3;i++) {a[i]=rounded(acc[i]*16384);g[i]=rounded(((rate?rate[i]:0)+sensor_bias[i])*32.8);}
    if(sensor_noise)for(i=0;i<3;i++)g[i]+=(sensor_seq&1u)?12:-12;
    test_time+=10u*GT_TICKS_PER_MS-33300u;
    lcd_imu_ingest((((u32)a[0]&65535u)<<16)|((u32)a[1]&65535u),
        (((u32)a[2]&65535u)<<16)|((u32)g[0]&65535u),
        (((u32)g[1]&65535u)<<16)|((u32)g[2]&65535u),
        0x80000000u|((++sensor_seq&127u)<<24));
}
static void physical_motion(u32 axis,double degrees,u32 samples,u32 pulse)
{
    u32 n,i;double rate[3];
    for(n=0;n<samples;n++) {
        for(i=0;i<3;i++)rate[i]=physical[axis*3+i]*degrees/(samples*0.01);
        physical_step(axis,degrees/samples);
        sensor_sample(rate,(n>=samples/3 && n<2*samples/3)?pulse:0);
    }
}
static void physical_pronation(double degrees,u32 samples)
{
    u32 n,i;double a=degrees/samples*3.141592653589793/180.0,c=cos(a),s=sin(a);
    double rate[3]={0,degrees/(samples*0.01),0};
    for(n=0;n<samples;n++) {
        for(i=0;i<3;i++) {
            double x=physical[i*3],z=physical[i*3+2];
            physical[i*3]=c*x-s*z;physical[i*3+2]=s*x+c*z;
        }
        sensor_sample(rate,0);
    }
}
static void matrix_matches(double tolerance)
{
    u32 i,j;double worst=0;
    for(i=0;i<3;i++)for(j=0;j<3;j++) {
        double expected=(i==2?1:-1)*physical[i*3+j];
        double e=fabs(lcd_imu_matrix[i*3+j]/4096.0-expected);
        if(e>worst)worst=e;
    }
    if(worst>matrix_max_error)matrix_max_error=worst;
    if(worst>=tolerance) {printf("IMU matrix error %.6f, limit %.6f\n",worst,tolerance);fflush(stdout);}
    assert(worst<tolerance);
    for(i=0;i<3;i++)for(j=0;j<3;j++) {
        double dot=0;u32 k;
        for(k=0;k<3;k++)dot+=lcd_imu_matrix[k*3+i]*(double)lcd_imu_matrix[k*3+j]/16777216.0;
        assert(fabs(dot-(i==j?1:0))<0.004);
    }
}
static void physical_home(u32 palm,double elevation)
{
    u32 i;
    lcd_state_valid=0;lcd_imu_reset();sensor_seq=sensor_noise=0;
    for(i=0;i<3;i++)imu_bias[i]=sensor_bias[i]=0;
    memset(physical,0,sizeof physical);
    physical[0]=palm?1:-1;physical[4]=-1;physical[8]=palm?-1:1;
    physical_step(0,elevation);
}
static void stationary_samples(u32 n) {while(n--)sensor_sample(NULL,0);}
static void settle_and_zero(void)
{
    u32 n=0;
    while(!mpu_zero_valid && n++<150) sensor_sample(NULL,0);
    assert(mpu_zero_valid && n<=150);
}
static void capture_home(void)
{
    stationary_samples(101);assert(mpu_zero_valid && mpu_zero_cnt==100);
    matrix_matches(0.003);
}
static i32 wrist_screen_y(void)
{
    double a=50.0*3.141592653589793/180.0,qy=-174*physical[4],qz=174*physical[7];
    double cy=-260+sin(a)*qy-cos(a)*qz,cz=800+cos(a)*qy+sin(a)*qz;
    i32 y;
    memset(lcd_draw_angles,0,sizeof lcd_draw_angles);lcd_hand_snapshot();
    y=hand_project(hand_camera((hand_v3){0,0,0},0)).y;
    if(lcd_imu_valid && mpu_zero_valid)
        assert(abs(y-rounded(LCD_Y(270)-cy*LCD_Y(1000)/cz))<=3);
    return y;
}
static void test_imu_rotation(void)
{
    u32 palm,flip,n,before;i32 home_y;
    /* Moving boot cannot contaminate the zero; stable offsets >3dps can
     * be calibrated. Every count must be a distinct sensor sample. */
    physical_home(1,0);sensor_bias[0]=5; sensor_bias[2]=-4;
    stationary_samples(51);assert(mpu_zero_cnt==50 && !mpu_zero_valid);
    physical_motion(0,15,10,0);assert(mpu_zero_cnt==0 && !mpu_zero_valid);
    settle_and_zero();
    assert(fabs(imu_bias[0]-164)<0.1 && fabs(imu_bias[2]+131)<0.1);
    physical_home(1,0);stationary_samples(21);
    physical_motion(0,5,100,0);assert(!mpu_zero_valid && mpu_zero_cnt<30);
    settle_and_zero();
    physical_home(1,90);stationary_samples(200);
    assert(!mpu_zero_valid && !mpu_zero_cnt);
    /* Almost upside-down initialization must retain small real tilt. */
    physical_home(1,1);capture_home();physical_motion(0,20,100,0);
    matrix_matches(0.012);
    /* All four cases must lift UP: palm/back at capture, before/after
     * flipping. Assert screen motion as well as physical rotation. */
    for(palm=0;palm<2;palm++)for(flip=0;flip<2;flip++) {
        physical_home(palm,0);capture_home();
        if(flip)physical_pronation(180,30); /* 600deg/s, beyond old 250 range */
        matrix_matches(0.012);home_y=wrist_screen_y();
        physical_motion(0,30,100,0);matrix_matches(0.012);
        assert(lcd_imu_matrix[7]<-1950 && wrist_screen_y()<home_y-25);
        physical_motion(0,15,50,0);matrix_matches(0.012);wrist_screen_y();
        {hand_screen tip=hand_project(hand_camera((hand_v3){-14,213,-8},0));
         assert(tip.y>LCD_Y(110) && tip.y<LCD_Y(520));}
        physical_motion(0,-45,100,0);
        if(flip)physical_pronation(-180,30);
        stationary_samples(200);matrix_matches(0.012);
        assert(imu_clip_count==0);
    }
    /* Capturing while already raised must keep world up, rather than
     * making gravity relative to whichever face was shown at capture. */
    physical_home(1,15);capture_home();home_y=wrist_screen_y();
    physical_motion(0,30,100,0);matrix_matches(0.012);
    /* Perspective motion is smaller near the eye's viewing direction;
     * wrist_screen_y also checks the independent analytic projection. */
    assert(wrist_screen_y()<home_y-1);
    home_y=wrist_screen_y();physical_pronation(180,30);matrix_matches(0.012);
    assert(abs(wrist_screen_y()-home_y)<=3);
    physical_motion(0,-30,100,0);
    lcd_imu_reset();capture_home();assert(lcd_imu_matrix[8]>3500);
    /* Noncommuting XYZ movement and acceleration pulses must return
     * without accumulating large post-motion tilt errors. */
    physical_home(1,0);capture_home();
    physical_pronation(180,30);physical_motion(0,45,100,1);
    physical_motion(2,45,100,2);physical_motion(2,-45,100,0);
    physical_motion(0,-45,100,0);physical_pronation(-180,30);
    stationary_samples(400);matrix_matches(0.02);
    for(n=0;n<10;n++) {
        physical_pronation(180,30);physical_motion(0,30,100,2);
        physical_motion(0,-30,100,0);physical_pronation(-180,30);
        stationary_samples(100);matrix_matches(0.025);
    }
    /* Idle thermal bias adapts, while deliberate slow 2dps yaw remains. */
    physical_home(1,0);capture_home();sensor_bias[2]=0.6;
    stationary_samples(1500);assert(imu_stationary);
    assert(fabs(imu_bias[2]-20)<0.2);matrix_matches(0.012);
    physical_motion(2,20,1000,0);matrix_matches(0.025);assert(!imu_stationary);
    /* Sequence wrap, low32 timer wrap, and gaps do not manufacture rotation. */
    physical_home(1,0);capture_home();before=imu_gap_count;
    test_time=0xffff0000u;imu_last_t=test_time;
    stationary_samples(200);assert(imu_gap_count==before);matrix_matches(0.003);
    {i32 saved[9];double fast[3]={600,0,0};memcpy(saved,lcd_imu_matrix,sizeof saved);
     test_time+=100u*GT_TICKS_PER_MS;sensor_sample(fast,0);
     assert(imu_gap_count==before+1 && memcmp(saved,lcd_imu_matrix,sizeof saved)==0);
     sensor_seq+=9;sensor_sample(fast,0);
     assert(imu_gap_count==before+2 && memcmp(saved,lcd_imu_matrix,sizeof saved)==0);}
    /* Rezero while moving waits; dropout clears readiness. */
    lcd_imu_reset();physical_motion(0,30,50,0);assert(!mpu_zero_valid && !mpu_zero_cnt);
    settle_and_zero();
    mpu_seen=1;regs[4]=0;mpu_tick();assert(!mpu_zero_valid && !lcd_imu_valid);
    /* Default fallback is palm-up and positive elevation raises the arm. */
    lcd_draw_tilt=lcd_draw_shift=0;home_y=wrist_screen_y();
    assert(lcd_draw_matrix[0]==-4096 && lcd_draw_matrix[8]==-4096);
    lcd_draw_shift=30;
    /* New framing gives about 25 pixels at 800x480 for this lift. */
    assert(wrist_screen_y()<home_y-20 && lcd_draw_matrix[7]<-2000);
    lcd_draw_shift=0;
    for(n=0;n<3;n++)imu_bias[n]=0;
    puts("TEST_PASS IMU: palm/back lift before/after 600dps flip, fixed gravity, moving zero,");
    puts("          bias adaptation/2dps yaw, acceleration pulses/XYZ return, gap/seq/timer wrap.");
    printf("IMU oracle: max rotation-matrix component error %.6f (all checked checkpoints)\n",matrix_max_error);
}
static void test_projection_and_depth(void)
{
    lcd_dl_t near_face={0},far_face={0};
    hand_screen near_p=hand_project((hand_v3){40,20,500});
    hand_screen far_p=hand_project((hand_v3){40,20,1000});
    assert(near_p.x-LCD_X(512)>far_p.x-LCD_X(512) && near_p.d>far_p.d);
    lcd_clip_top=0;lcd_clip_bottom=LCD_H;
    near_face.v0=30;near_face.v1=30;near_face.v3=90;near_face.v4=30;
    near_face.v6=30;near_face.v7=90;near_face.v8=near_face.v2=near_face.v5=12000;
    far_face=near_face;far_face.v8=far_face.v2=far_face.v5=6000;
    lcd_depth_clear(0,LCD_H);
    lcd_depth_triangle(lcd_test_fb(0),&near_face,255,0,0);
    lcd_depth_triangle(lcd_test_fb(0),&far_face,0,0,255);
    assert(lcd_test_fb(0)[40*FB_BPL+40*3+2]==255);
    lcd_depth_clear(0,LCD_H);
    lcd_depth_triangle(lcd_test_fb(0),&far_face,0,0,255);
    lcd_depth_triangle(lcd_test_fb(0),&near_face,255,0,0);
    assert(lcd_test_fb(0)[40*FB_BPL+40*3+2]==255);
    /* Sloping inverse depth: interior barycentric weights are 2/3,1/6,1/6. */
    near_face.v8=12000;near_face.v2=6000;near_face.v5=9000;
    lcd_depth_clear(0,LCD_H);
    lcd_depth_triangle(lcd_test_fb(0),&near_face,255,0,0);
    assert(hand_abs((i32)lcd_depth[40*LCD_W+40]-10500)<=1);
    lcd_pose_initialized=0;lcd_pose_sample(1);lcd_pose_sample(2);
    assert(lcd_animation_busy);
    test_time+=300u*GT_TICKS_PER_MS;lcd_pose_sample(2);
    assert(!lcd_animation_busy && lcd_draw_angles[2]==pose_table[2][2]);
    test_time=lcd_pose_t0+0xffffff00u;lcd_pose_sample(2);
    assert(!lcd_animation_busy && lcd_draw_angles[2]==pose_table[2][2]);
    lcd_pose_initialized=0;
}
static void test_wrist_direction(void)
{
    u32 palm,flip;
    assert(pose_table[3][0]==34 && pose_table[4][0]==-34);
    for(palm=0;palm<2;palm++)for(flip=0;flip<2;flip++) {
        hand_v3 origin,normal,straight,arm,flex,ext,pivot; i32 dot;
        physical_home(palm,0);capture_home();
        physical_motion(0,30,100,0);physical_motion(2,20,100,0);
        if(flip)physical_pronation(180,30);
        lcd_hand_snapshot();memset(lcd_draw_angles,0,sizeof lcd_draw_angles);
        origin=hand_camera((hand_v3){0,0,0},0);
        normal=hand_sub(hand_camera((hand_v3){0,0,100},0),origin);
        straight=hand_camera((hand_v3){0,100,0},0);
        arm=hand_camera((hand_v3){0,-85,0},0);
        lcd_pose_initialized=0;lcd_pose_sample(3);assert(lcd_draw_angles[0]==34);
        flex=hand_sub(hand_camera((hand_v3){0,100,0},1),straight);
        dot=flex.x*normal.x+flex.y*normal.y+flex.z*normal.z;
        assert(dot>5000); /* Flexion must approach the actual palm normal. */
        pivot=hand_camera((hand_v3){0,0,0},1);assert(memcmp(&pivot,&origin,sizeof pivot)==0);
        pivot=hand_camera((hand_v3){0,-85,0},0);assert(memcmp(&pivot,&arm,sizeof pivot)==0);
        lcd_pose_initialized=0;lcd_pose_sample(4);assert(lcd_draw_angles[0]==-34);
        ext=hand_sub(hand_camera((hand_v3){0,100,0},1),straight);
        dot=ext.x*normal.x+ext.y*normal.y+ext.z*normal.z;
        assert(dot<-5000); /* Extension must move to the dorsal side. */
        pivot=hand_camera((hand_v3){0,0,0},1);assert(memcmp(&pivot,&origin,sizeof pivot)==0);
    }
    lcd_imu_reset();lcd_pose_initialized=0;
    puts("TEST_PASS WRIST: class3 +34 flex toward palm, class4 -34 extend toward back,");
    puts("          wrist pivot/forearm fixed, both faces and flipped raised/yawed arm.");
}
static void test_tracking_startup(void)
{
    u32 before,n;
    physical_home(1,0);sensor_sample(NULL,0);before=lcd_imu_generation;
    assert(!mpu_zero_valid);
    physical_motion(0,30,50,0);
    assert(!mpu_zero_valid && lcd_imu_generation>before);
    lcd_hand_snapshot();assert(lcd_draw_matrix[7]<-1950);
    matrix_matches(0.012);
    before=lcd_imu_generation;lcd_imu_reset();sensor_sample(NULL,0);
    physical_motion(0,-15,50,0);
    assert(!mpu_zero_valid && lcd_imu_generation>before);matrix_matches(0.012);
    /* +/-8/6/4 mg and +/-12 gyro LSB: old adjacent raw thresholds
     * reset every sample. Stability filtering must complete within 2s. */
    physical_home(1,0);sensor_noise=1;
    for(n=0;n<200 && !mpu_zero_valid;n++)sensor_sample(NULL,0);
    assert(mpu_zero_valid && n<=200);matrix_matches(0.02);
    sensor_noise=0;physical_motion(0,30,50,0);matrix_matches(0.03);
    physical_home(1,90);sensor_sample(NULL,0);before=lcd_imu_generation;
    physical_motion(0,-30,50,0);
    assert(lcd_imu_valid && lcd_imu_generation>before && !mpu_zero_valid);
    lcd_imu_reset();
    puts("TEST_PASS STARTUP: pre-zero/rezero/vertical tracking, noisy zero within 2s.");
}

static void wave_packet(u32 type,u32 channel,u32 seq,i32 value)
{
    parse_packet((u32)value&0xffffffu,(type<<28)|(channel<<24)|(seq&65535u));
}

static void result_packet(u32 id, u32 payload, u32 seq)
{
    parse_packet(payload, (4u<<28)|((id & 0xfu)<<20)|(seq & 65535u));
}

static u32 spectrum_packet(u32 a, u32 b, u32 c, u32 d, u32 e, u32 f)
{
    return (a & 0x1fu) | ((b & 0x1fu) << 5) |
           ((c & 0x1fu) << 10) | ((d & 0x1fu) << 15) |
           ((e & 0x1fu) << 20) | ((f & 0x1fu) << 25);
}

static void test_wave_data(void)
{
    u32 i;
    parsed_total=16u;next_report=0xffffffffu;
    lcd_wave_select(2u,1u);
    wave_packet(1,2,5,700);wave_packet(5,1,5,800);
    lcd_wave_ingest(900,(5u<<28)|(2u<<24)|(1u<<16)|5u);
    lcd_wave_ingest(900,(5u<<28)|(2u<<24)|(1u<<20)|5u);
    assert(!wave_count);
    wave_packet(5,2,65534,-8388608);wave_packet(5,2,65535,-1);
    wave_packet(5,2,0,8388607);wave_packet(5,2,0,5);
    assert(wave_count==3 && wave_ring[0]==-8388608 && wave_ring[1]==-1 &&
           wave_ring[2]==8388607 && !wave_missing && !wave_restarts);
    wave_packet(5,2,3,123);
    lcd_wave_snapshot();
    assert(wave_snapshot_count==4 && wave_snapshot[0]==123 && wave_age[0]==0 &&
           wave_age[1]==3 && wave_age[2]==4 && wave_age[3]==5 && wave_missing==2);
    wave_packet(5,2,2,-123); /* reverse is a new epoch, not 65534 lost samples */
    assert(wave_count==1 && wave_restarts==1 && wave_missing==2);
    lcd_wave_select(0,0);
    assert(!wave_count && !wave_snapshot_valid && !wave_paused);
    for(i=0;i<1500;i++)wave_packet(1,0,i,(i32)i-750);
    lcd_wave_snapshot();
    assert(wave_count==1024 && wave_snapshot_count==800 &&
           wave_snapshot[0]==749 && wave_snapshot[799]==-50 && wave_age[799]==799);
    lcd_wave_select(0,1); /* no stale data from the previous channel/source */
    assert(!wave_count && !wave_missing && !wave_restarts);
    puts("TEST_PASS WAVE DATA: true signed int24, source/channel/header isolation, duplicates,");
    puts("          sequence wrap/restart, real-time gap positions, ring wrap, switch reset.");
}

static void test_wave_display(void)
{
    u32 i,j,before,old_count,old_channel,old_source;char name[100];
    /* Enter through the same touch handler as the device. */
    ui_home_open();press((u32)LCD_X(100),(u32)LCD_Y(280));assert(lcd_wave_view);
    for(j=0;j<8;j++) {
        press((u32)(LCD_X(28)+(i32)j*LCD_X(122)+LCD_X(50)),(u32)LCD_Y(555));
        assert(wave_channel==j);
    }
    /* Select CH3, RAW, 100 ms, DC ZERO, AUTO; synthesize a bipolar ramp
     * around a deliberate 10-sample gap, with a uint16 sequence wrap. */
    lcd_wave_select(2,0);wave_time_sel=1;wave_dc_auto=0;wave_scale_sel=0;
    for(i=0;i<800;i++)
        if(i<740 || i>=750)wave_packet(1,2,(65500u+i)&65535u,((i32)(i%40u)-20)*100);
    drain_frame();expected_frame();
    assert(wave_visible==390 && wave_missing==10 && wave_segments==388 && wave_span==5000);
    assert(!wave_clipped && wave_center==0 && dl_len<LCD_DL_MAX);
    sprintf(name,"wave_raw_%u.ppm",(u32)LCD_W);ppm(name);
    for(j=0;j<3;j++) {
        static const u32 expected_n[3]={190,390,790};
        wave_time_sel=j;lcd_wave_changed();drain_frame();expected_frame();
        assert(wave_visible==expected_n[j] && wave_segments==expected_n[j]-2);
        sprintf(name,"wave_%ums_%u.ppm",wave_times_ms[j],(u32)LCD_W);ppm(name);
    }
    /* Pause freezes samples while acquisition continues. Timebase and DC
     * controls still operate on that frozen 200-ms snapshot. */
    press((u32)LCD_X(900),(u32)LCD_Y(165));assert(wave_paused);
    drain_frame();expected_frame();
    /* Compare held samples after the independent tap acknowledgement ends. */
    test_time+=101u*GT_TICKS_PER_MS;ui_feedback_tick();
    drain_frame();expected_frame();before=hash(regs[2]&31u);old_count=wave_count;
    for(i=800;i<1000;i++)wave_packet(1,2,(65500u+i)&65535u,500000);
    assert(wave_count>old_count && wave_snapshot[0]!=500000);
    lcd_wave_changed();drain_frame();expected_frame();assert(hash(regs[2]&31u)==before);
    /* Tap timebase: 200 -> 50 ms of the same held data. */
    press((u32)LCD_X(300),(u32)LCD_Y(165));assert(wave_time_sel==0);
    drain_frame();expected_frame();assert(wave_visible==190);
    press((u32)LCD_X(700),(u32)LCD_Y(165));assert(wave_dc_auto);
    press((u32)LCD_X(500),(u32)LCD_Y(165));assert(wave_scale_sel==1);
    drain_frame();expected_frame();assert(wave_clipped && wave_span==100);
    sprintf(name,"wave_pause_%u.ppm",(u32)LCD_W);ppm(name);
    /* Source changes resume capture and clear old data; no fallback to RAW. */
    old_source=rec_notch;old_channel=wave_channel;
    press((u32)LCD_X(100),(u32)LCD_Y(165));
    assert(wave_notch && !wave_count && !wave_paused && rec_notch==old_source);
    wave_packet(1,old_channel,1000,12345);assert(!wave_count);
    drain_frame();expected_frame();assert(!wave_visible);
    sprintf(name,"wave_wait_%u.ppm",(u32)LCD_W);ppm(name);
    wave_scale_sel=0;wave_time_sel=2;
    /* Worst-case int24 alternating rails exercise overflow-safe scaling,
     * line raster bounds and maximum command count on both panel sizes. */
    for(i=0;i<800;i++)wave_packet(5,old_channel,i,(i&1u)?8388607:-8388608);
    drain_frame();expected_frame();
    assert(wave_visible==800 && wave_segments==799 && !wave_clipped && wave_span==20000000);
    assert(lcd_overflow_cnt==0 && wave_center==0);
    sprintf(name,"wave_fullscale_%u.ppm",(u32)LCD_W);ppm(name);
    test_time=0xffff0000u;
    wave_packet(5,old_channel,800,0);wave_stale=0;
    test_time=wave_last_t+251u*GT_TICKS_PER_MS;
    lcd_wave_tick();assert(wave_stale);drain_frame();expected_frame();
    wave_packet(5,old_channel,801,0);assert(!wave_stale);
    /* Feed newer samples and change controls during an in-flight frame.
     * Only pending work may change; draw commands and scanout stay owned. */
    for(i=0;i<50;i++) {
        u32 old_i=dl_i,old_back=dl_back,busy=dl_busy;
        u32 a=VDMA_PARK_CURRENT(regs[2]),q=regs[2]&31u;
        u32 ha=hash(a),hq=hash(q),command_hash=0;
        if(busy)command_hash=(u32)dl[dl_len-1u].v0;
        wave_packet(5,old_channel,802u+i,(i32)i*10-250);
        if(busy)assert(dl_i==old_i && dl_back==old_back &&
                       (u32)dl[dl_len-1u].v0==command_hash);
        lcd_slice_tick(gt_stamp());
        assert(hash(a)==ha && hash(q)==hq);
        if(i%5u==0u)scanout_accept();
    }
    drain_frame();expected_frame();
    /* Exit, open/close existing menu while on the wave page, then restore
     * the hand. Commands already in flight must remain immutable. */
    press((u32)LCD_X(350),(u32)LCD_Y(45));assert(ui_menu_open);
    drain_frame();expected_frame();
    press((u32)LCD_X(100),(u32)LCD_Y(280));assert(!ui_menu_open && lcd_wave_view);
    drain_frame();expected_frame();
    press((u32)LCD_X(560),(u32)LCD_Y(45));assert(!lcd_wave_view);
    drain_frame();expected_frame();guard_check();
    lcd_wave_select(0,1);wave_time_sel=1;wave_scale_sel=0;wave_dc_auto=1;
    puts("TEST_PASS WAVE LCD: touch CH1-8/source/time/DC/range/pause/return, signed traces,");
    puts("          gaps, hold with active input, both panel bounds, fullscale, immutable frames, stale/wrap.");
}

static void test_analysis_display(void)
{
    lcd_quality_view=0u;
    u32 i, before;
    lcd_wave_view = 0u;
    lcd_data_view = 0u;
    lcd_spectrum_view = 0u;
    lcd_analysis_focus = 0u;
    cal_stage = 2u;
    raw_gap_cnt = 3u;
    feature_gap_cnt = 1u;
    fat_mdf = 27u;
    fat_level = 1u;
    fat_full = 1u;
    feat_rows = 12u;
    for (i = 0u; i < 8u; i++) {
        feat_mav[i] = 1000u + i * 500u;
        cal_thr[i] = 2000u + i * 1000u;
        raw_latest[i] = (u32)((i & 1u) ? -(i32)(200u + i) : (i32)(200u + i));
        raw_outlier[i] = i == 7u ? 2u : 0u;
    }
    fat_mdf = 27u; fat_level = 1u; fat_full = 1u;
    result_packet(10u, spectrum_packet(12u, 20u, 16u, 7u, 3u, 2u), 40u);
    result_packet(11u, spectrum_packet(18u, 30u, 25u, 14u, 5u, 4u), 40u);
    result_packet(12u, spectrum_packet(20u, 24u, 16u, 9u, 8u, 7u), 40u);
    result_packet(13u, spectrum_packet(24u, 20u, 12u, 6u, 4u, 3u), 40u);
    result_packet(14u, spectrum_packet(8u, 5u, 4u, 3u, 2u, 1u), 40u);
    result_packet(15u, (51u<<21)|123u, 40u);
    assert(spec_band[0] == 12u && spec_band[1] == 20u &&
           spec_band[4] == 3u && spec_band[5] == 2u &&
           spec_band[6] == 18u && spec_band[24] == 8u &&
           spec_band[29] == 1u && pl_spec_peak_bin == 51u);
    before = lcd_present_cnt;
    ui_open_page(UI_DATA);
    assert(lcd_data_view && !lcd_wave_view);
    drain_frame();
    assert(lcd_present_cnt > before && dl_len < LCD_DL_MAX);
    {
        char name[64];
        sprintf(name, "analysis_%u.ppm", (u32)LCD_W);
        ppm(name);
    }
    press((u32)(LCD_X(28) + LCD_X(500) + LCD_X(30)),
          (u32)(LCD_Y(130) + LCD_Y(78) * 2 + LCD_Y(30)));
    assert(lcd_analysis_focus == 6u);
    drain_frame();
    press((u32)LCD_X(560), (u32)LCD_Y(45));
    assert(!lcd_data_view && !lcd_wave_view);ui_open_page(UI_MONITOR);
    drain_frame();
    ui_open_page(UI_DATA);
    assert(lcd_data_view && !lcd_spectrum_view);
    ui_open_page(UI_SPECTRUM);
    assert(lcd_spectrum_view && !lcd_data_view && !lcd_wave_view);
    before = lcd_present_cnt;
    drain_frame();
    assert(lcd_present_cnt > before && dl_len < LCD_DL_MAX);
    {
        char name[64];
        sprintf(name, "spectrum_%u.ppm", (u32)LCD_W);
        ppm(name);
    }
    press((u32)LCD_X(560), (u32)LCD_Y(45));
    assert(!lcd_spectrum_view && !lcd_data_view && !lcd_wave_view);
    drain_frame();
    puts("TEST_PASS DATA LCD: live MAV bars, raw values, gate/fatigue/gap status, focus, spectrum and return touch.");
}

static void test_fatigue_readiness_display(void)
{
    u32 before,ready_pixels;
    ui_open_page(UI_MONITOR);fat_full=1u;
    lcd_show_state(1u,90u,0u,0u,0,0);drain_frame();expected_frame();
    ready_pixels=hash(regs[2]&31u);before=lcd_present_cnt;
    // Level remains zero: readiness alone must refresh the monitor label.
    fat_full=0u;lcd_show_state(1u,90u,0u,0u,0,0);drain_frame();expected_frame();
    assert(lcd_present_cnt>before && lcd_state_fatigue_ready==0u);
    assert(hash(regs[2]&31u)!=ready_pixels);
    {char name[80];sprintf(name,"fatigue_pending_%u.ppm",(u32)LCD_W);ppm(name);}
    before=lcd_present_cnt;fat_full=1u;
    lcd_show_state(1u,90u,0u,0u,0,0);drain_frame();expected_frame();
    assert(lcd_present_cnt>before && lcd_state_fatigue_ready==1u);
    puts("TEST_PASS FATIGUE LCD: readiness-only refresh, pending distinct from normal, both panels");
}

static void test_quality_display(void)
{
    u32 i,ch,n;char name[80];
    memset(channel_quality,0,sizeof channel_quality);
    cq_reference=cq_ref_failed=0;
    lcd_wave_view=lcd_spectrum_view=lcd_synergy_view=0;
    ui_open_page(UI_DATA);lcd_quality_view=1;lcd_analysis_focus=0;
    /* Actual final waveform packets drive all eight channel diagnostics. */
    for(n=0;n<4000;n++)for(ch=0;ch<8;ch++) {
        i32 v=(i32)(120.0*sin(2.0*3.141592653589793*(ch==2?50:137)*n/4000.0));
        if(ch==5 && n==100)v=10000;
        lcd_spectrum_ingest((u32)v,0x50000000u|(ch<<24)|n);
    }
    for(ch=0;ch<8;ch++)assert(channel_quality[ch].valid);
    for(ch=0;ch<8;ch++)assert(channel_quality[ch].grade==CQ_GRADE_UNKNOWN);
    assert(channel_quality[2].line10>990);
    assert(channel_quality[0].line10<5);
    assert(channel_quality[5].cf10>100);
    lcd_pending=1;drain_frame();expected_frame();
    sprintf(name,"quality_%u.ppm",(u32)LCD_W);ppm(name);
    press(LCD_X(560),LCD_Y(248));assert(lcd_analysis_focus==5);
    press(LCD_X(100),LCD_Y(552));assert(lcd_wave_view && !lcd_data_view && wave_channel==5 && wave_notch);
    drain_frame();expected_frame();
    lcd_wave_view=0;lcd_data_view=1;
    press(LCD_X(270),LCD_Y(552));assert(lcd_spectrum_view && !lcd_data_view);
    drain_frame();expected_frame();
    lcd_spectrum_view=0;lcd_data_view=1;
    press(LCD_X(860),LCD_Y(110));assert(!lcd_quality_view);
    press(LCD_X(860),LCD_Y(110));assert(lcd_quality_view);
    press(LCD_X(580),LCD_Y(110));assert(cq_reference);
    /* Three complete relaxed windows; no shared channel masks may advance
     * a missing channel's baseline. */
    for(i=0;i<3;i++)for(n=0;n<4000;n++)for(ch=0;ch<8;ch++) {
        i32 v=(i32)(120.0*sin(2.0*3.141592653589793*137*n/4000.0));
        cq_ingest((u32)v,0x50000000u|(ch<<24)|(4000u+i*4000u+n),gt_stamp());
    }
    assert(!cq_reference && !cq_ref_failed);
    for(ch=0;ch<8;ch++)assert(channel_quality[ch].base>80 && channel_quality[ch].base<86);
    assert(channel_quality[0].grade==CQ_GRADE_A && channel_quality[0].total_score==100u);
    for(ch=0;ch<8;ch++)assert(channel_quality[ch].grade==CQ_GRADE_A);
    drain_frame();expected_frame();sprintf(name,"quality_scored_%u.ppm",(u32)LCD_W);ppm(name);
    test_time+=1501u*GT_TICKS_PER_MS;
    lcd_quality_tick(gt_stamp());assert(cq_stale_mask==255);
    assert(strcmp(lcd_quality_status(0,gt_stamp()),"无新数据")==0);
    lcd_pending=1;drain_frame();expected_frame();
    sprintf(name,"quality_stale_%u.ppm",(u32)LCD_W);ppm(name);
    lcd_data_view=0;lcd_pending=1;drain_frame();
    puts("TEST_PASS quality LCD: final-waveform ingestion, 8 channels, residual mains/spikes, baseline, stale, touch drill-down, both panels.");
}

static void test_synergy_display(void)
{
    u32 t,ch,id,base=65520u,saved_logits[5],saved_cls=res_cls;
    u32 saved_label=lcd_action_label;
    char name[80];
    synergy_nmf_reset(&synergy_nmf);
    synergy_feedback_reset(&synergy_feedback);
    synergy_seq_seen=synergy_history_count=synergy_history_write=synergy_history_hop=0u;
    feature_seq_seen=feature_synced=feat_win_cnt=0u;
    cal_stage=2u;selfcal_reset(&selfcal);feature_stream=0u;
    memcpy(saved_logits,res_logits,sizeof saved_logits);
    for(t=0;t<440u;t++) {
        for(ch=0;ch<8u;ch++)for(id=0;id<5u;id++) {
            u32 amplitude=2000u+(u32)(1500.0*(1.0+sin((double)t*.04+ch)));
            u32 value=id==0u?amplitude*(ch+1u):17u;
            parse_packet(value,0x20000000u|(ch<<24)|(id<<20)|((base+t*40u+ch*5u+id)&65535u));
            if(ch==7u && id==3u && !t)assert(!synergy_nmf.valid);
        }
    }
    assert(synergy_nmf.valid && synergy_history_count==100u);
    assert(res_cls==saved_cls && !memcmp(saved_logits,res_logits,sizeof saved_logits));
    assert(lcd_action_label==saved_label);
    assert(lcd_zh_glyph(0x534Fu) && lcd_zh_glyph(0x540Cu)); /* 协同 */
    ui_open_page(2u);drain_frame();
    ui_open_page(UI_SPECTRUM);assert(lcd_spectrum_view);
    ui_open_page(UI_SYNERGY);assert(lcd_synergy_view && !lcd_data_view && !lcd_spectrum_view);
    drain_frame();expected_frame();guard_check();assert(dl_len<LCD_DL_MAX);
    sprintf(name,"synergy_%u.ppm",(u32)LCD_W);ppm(name);
    /* A missing feature window clears the history rather than joining epochs. */
    synergy_on_window(feat_mav,(u16)(synergy_last_seq+80u));
    assert(synergy_history_count==0u);
    for(ch=0;ch<8u;ch++)feat_mav[ch]=0x7fffffffu;
    synergy_on_window(feat_mav,(u16)(synergy_last_seq+40u));
    lcd_pending=1u;drain_frame();expected_frame();
    sprintf(name,"synergy_overref_%u.ppm",(u32)LCD_W);ppm(name);
    test_time+=501u*GT_TICKS_PER_MS;synergy_stale_reported=0u;
    lcd_slice_tick(gt_stamp());assert(synergy_stale_reported);
    drain_frame();expected_frame();
    sprintf(name,"synergy_stale_%u.ppm",(u32)LCD_W);ppm(name);
    press((u32)LCD_X(560),(u32)LCD_Y(45));assert(!lcd_synergy_view && !lcd_wave_view);
    drain_frame();expected_frame();
    puts("TEST_PASS SYNERGY LCD: complete-window parser, seq wrap/gap, 10s history, both panels, frame equivalence, unchanged logits/labels, page routes.");
}

static u32 rehab_test_seq;
static void rehab_test_feed(u32 cls);
static void test_grip_feedback_ui(void)
{
    u32 i,n,e[8],base,now;char name[80];
    g_mode=MODE_MONITOR;mock_sd_active=0u;rehab.state=RH_IDLE;rehab_setup_stage=0u;
    rehab_effort_enabled=0u;rehab_combo=0u;rehab_action=2u;
    synergy_feedback_reset(&synergy_feedback);synergy_seq_seen=0u;
    lcd_rehab_open();
    press((u32)LCD_X(120),(u32)LCD_Y(490));assert(rehab_effort_enabled);
    press((u32)LCD_X(100),(u32)LCD_Y(545));ui_apply_action();
    assert(rehab.state==RH_IDLE); /* enabled without reference cannot start */
    press((u32)LCD_X(450),(u32)LCD_Y(545));assert(!rehab_setup_stage);
    press((u32)LCD_X(350),(u32)LCD_Y(490));ui_apply_action();
    assert(synergy_feedback.capture==1u);
    for(i=0u;i<8u;i++)e[i]=(u32)((uint64_t)synergy_w_q15[i][1]*40000u/32768u);
    base=65520u;
    for(n=0u;n<140u;n++) {
        test_time+=25u*GT_TICKS_PER_MS;
        synergy_on_window(e,(u16)(base+n*40u));rehab_service();
    }
    assert(synergy_feedback.capture==3u && synergy_feedback.reference>=256u);
    drain_frame();expected_frame();sprintf(name,"grip_setup_%u.ppm",(u32)LCD_W);ppm(name);
    press((u32)LCD_X(100),(u32)LCD_Y(545));ui_apply_action();
    assert(rehab_setup_stage);
    press((u32)LCD_X(100),(u32)LCD_Y(230));press((u32)LCD_X(100),(u32)LCD_Y(300));
    cal_stage=2u;press((u32)LCD_X(100),(u32)LCD_Y(545));ui_apply_action();
    assert(rehab.state==RH_CALIBRATE && rehab.effort_enabled && rehab.effort_reference);
    cal_stage=2u;
    for(n=0u;n<120u && rehab.state!=RH_CUE;n++)rehab_test_feed(0u);
    assert(rehab.state==RH_CUE);
    /* Pure inference without matching features must not score a grip. */
    for(n=0u;n<12u;n++)rehab_test_feed(2u);
    assert(!rehab.segment_ms);
    for(n=0u;n<24u;n++) {
        test_time+=25u*GT_TICKS_PER_MS;
        rehab_test_seq=(rehab_test_seq+40u)&65535u;
        synergy_on_window(e,(u16)rehab_test_seq);
        rehab_on_result(rehab_test_seq,2u,2u,90u,0u,1u);
    }
    assert(rehab.state==RH_HOLD && rehab.segment_ms>200u && rehab.effort_valid);
    drain_frame();expected_frame();sprintf(name,"grip_hold_%u.ppm",(u32)LCD_W);ppm(name);
    now=rehab_milliseconds();rehab_on_result(rehab_test_seq+40u,2u,2u,90u,0u,1u);
    assert(!rehab.segment_ms && !rehab.effort_valid);
    rehab_finish(&rehab,now,1u);rehab_save_report();
    assert(strstr(mock_rehab_csv,"grip_effort_enabled,1") &&
           strstr(mock_rehab_csv,"grip_reference_c2_q8,") &&
           strstr(mock_rehab_csv,"relative_emg_c2_not_force"));
    rehab.state=RH_IDLE;rehab_effort_enabled=0u;
    press((u32)LCD_X(560),(u32)LCD_Y(45));
    guard_check();
    puts("TEST_PASS GRIP LCD: capture/touch/start guard/matched-window hold/missing evidence/CSV/both panels");
}

static void test_spectrum_fft(void)
{
    u32 i,a;
    for(a=0u;a<3u;a++) {
        double amplitude=a==0u?8.0:a==1u?100000.0:7000000.0;
        for(i=0u;i<SPEC_FFT_N;i++)
            spec_samples[i]=(i32)(amplitude*sin(6.283185307179586*52.0*i/SPEC_FFT_N))+12345;
        lcd_spectrum_fft();
        assert(spec_valid && spec_has_signal && spec_peak_bin==52u);
    }
    for(i=0u;i<SPEC_FFT_N;i++) spec_samples[i]=12345;
    lcd_spectrum_fft();
    assert(spec_valid && !spec_has_signal && spec_peak_bin==0u);
    for(i=0u;i<SPEC_BIN_COUNT;i++) assert(!spec_nonzero[i]);
    for(i=1u;i<100000u;i+=173u)
        assert(abs((int)spec_log2_power_q8(i)-(int)(log((double)i)/log(2.0)*256.0))<=2);
    for(i=0u;i<SPEC_FFT_N;i++)
        spec_samples[i]=(i32)(100000.0*sin(6.283185307179586*52.0*i/SPEC_FFT_N));
    spec_valid=0u;
    lcd_spectrum_fft();
    assert(spec_valid && spec_peak_bin==52u);
    assert(spec_max_level>0u && spec_bin_log[52u-SPEC_BIN_FIRST]==spec_max_level);
    ui_open_page(3u);drain_frame();expected_frame();
    {char name[64];sprintf(name,"spectrum_live_%u.ppm",(u32)LCD_W);ppm(name);}
    ui_open_page(0u);drain_frame();
    puts("TEST_PASS SPECTRUM FFT: small/full-scale/DC/zero inputs, peak bin, log-power accuracy.");
}

static void test_text_alignment(void)
{
    u32 k,index=regs[2]&31u,old_mode=dl_mode;
    volatile u8 *old_fb=dl_fb_now;
    char name[64];
    for(k=0;k<4u;k++) {
        const u8 *zero=lcd_zh_glyph('0')+lcd_font_metrics[k].offset;
        const u8 *upper=lcd_zh_glyph('H')+lcd_font_metrics[k].offset;
        const u8 *lower=lcd_zh_glyph('g')+lcd_font_metrics[k].offset;
        i32 row,col,last_zero=-1,last_upper=-1,last_lower=-1;
        i32 size=lcd_font_metrics[k].size,height=lcd_font_metrics[k].height;
        for(row=0;row<height;row++) for(col=0;col<size/2;col++) {
            if(zero[row*size/2+col]) last_zero=row;
            if(upper[row*size/2+col]) last_upper=row;
            if(lower[row*size/2+col]) last_lower=row;
        }
        assert(last_zero==last_upper);
        assert(last_zero==(i32)lcd_font_metrics[k].baseline-1);
        assert(last_lower>last_zero && last_lower<height);
    }
    dl_mode=0u;dl_fb_now=lcd_test_fb(index);
    p_rect(0,0,LCD_W,LCD_H,255,255,255);
    for(k=1;k<=3u;k++) {
        i32 baseline=LCD_Y(65)+(i32)(k-1u)*LCD_Y(125);
        p_rect(LCD_X(24),baseline,LCD_W-LCD_X(48),1,211,222,222);
        ui_label_baseline(LCD_X(28),baseline,LCD_W-LCD_X(56),(i32)k,
                          31,49,58,"通道1 ADC 4000 Hz");
        ui_label_baseline(LCD_X(28),baseline+LCD_Y(58),LCD_W-LCD_X(56),(i32)k,
                          31,49,58,"幅值±500 / 100 ms");
    }
    ui_label_baseline(LCD_X(28),LCD_Y(490),LCD_X(360),2,31,49,58,"全通道MDF");
    ui_label_baseline(LCD_X(460),LCD_Y(490),LCD_X(500),1,31,49,58,"53 Hz / 75% / gpqy");
    sprintf(name,"typography_%u.ppm",(u32)LCD_W);ppm(name);
    guard_check();dl_mode=old_mode;dl_fb_now=old_fb;
    puts("TEST_PASS TEXT BASELINE: all font sizes, capitals/digits, descenders, mixed-size rows.");
}

static void test_ui_settings(void)
{
    char fitted[48],axis[48],name[64];u32 i;
    const char *long_text="ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ";
    assert(ui_text_width("A:1.0/%",1)==84);
    assert(ui_text_width("张手",2)==(LCD_W<=800?42:50));
    /* Native gray glyphs must cover Chinese, lower-case SI units and ±.
     * Check actual blended output, clipping, and a two-byte UTF-8 fit. */
    {
        u16 cp;u32 j,gray=0u,ink=0u;
        volatile u8 *fb=lcd_test_fb(0u);
        assert(lcd_zh_glyph(0x7F6Eu) && lcd_zh_glyph('z') && lcd_zh_glyph('s'));
        assert(lcd_utf8_char("±",&cp)==2u && cp==0xb1u && lcd_zh_glyph(cp));
        ui_fit_label(fitted,"幅值±500 Hz",ui_text_width("幅值±500 Hz",2),2);
        assert(strcmp(fitted,"幅值±500 Hz")==0);
        lcd_fill_rect(fb,0,0,LCD_W,LCD_H,255,255,255);
        lcd_text(fb,2,2,2,31,49,58,"设置 Hz ms ±");
        for(j=0;j<(u32)(LCD_W*lcd_cjk_size(2)*3);j+=3u) {
            if(fb[j]<255u) ink++;
            if(fb[j]>58u && fb[j]<255u) gray++;
        }
        assert(ink>50u && gray>20u);
        lcd_text(fb,-8,-5,2,31,49,58,"设置");
        lcd_text(fb,LCD_W-4,LCD_H-3,2,31,49,58,"设置");
        guard_check();
    }
    for(i=0;i<180u;i++) {
        ui_fit_label(fitted,"CH1 张手 123456789",(i32)i,2);
        assert(ui_text_width(fitted,2)<=(i32)i);
        /* Every retained CJK character is complete, never partial UTF-8. */
        {u32 j;for(j=0;fitted[j];j++)if((u8)fitted[j]>=128u) {
            assert(((u8)fitted[j]&0xf0u)==0xe0u && fitted[j+1] && fitted[j+2]);j+=2;
        }}
    }
    ui_fit_label(fitted,long_text,2000,2);
    assert(strlen(fitted)<=47u && strcmp(fitted+strlen(fitted)-3,"...")==0);
    lcd_wave_axis(axis,-20000000);assert(strcmp(axis,"-20M")==0);
    lcd_wave_axis(axis,500000);assert(strcmp(axis,"500K")==0);
    press((u32)LCD_X(920),(u32)LCD_Y(55));assert(lcd_settings_view);
    for(i=0;i<3u;i++) {
        press((u32)LCD_X(450+190*i),(u32)LCD_Y(250));assert(ui_refresh_ms==ui_refresh_choices[i]);
        press((u32)LCD_X(450+190*i),(u32)LCD_Y(390));assert(wave_time_sel==i);
    }
    ui_grid_enabled=1u;wave_dc_auto=1u;wave_scale_sel=2u;lcd_wave_select(4u,1u);
    press((u32)LCD_X(500),(u32)LCD_Y(320));assert(!ui_grid_enabled);
    press((u32)LCD_X(800),(u32)LCD_Y(320));assert(!wave_notch && wave_channel==4u);
    press((u32)LCD_X(500),(u32)LCD_Y(460));assert(!wave_dc_auto);
    press((u32)LCD_X(800),(u32)LCD_Y(460));assert(wave_scale_sel==0u);
    drain_frame();expected_frame();
    sprintf(name,"settings_custom_%u.ppm",(u32)LCD_W);ppm(name);
    press((u32)LCD_X(800),(u32)LCD_Y(550));
    assert(ui_refresh_ms==20u && ui_grid_enabled && wave_time_sel==1u &&
           wave_dc_auto && !wave_scale_sel && wave_notch && wave_channel==4u);
    drain_frame();expected_frame();
    sprintf(name,"settings_%u.ppm",(u32)LCD_W);ppm(name);
    /* Changing display settings or pages must not stop SD capture. */
    mock_sd_active=1u;
    for(i=0;i<5u;i++) {
        press((u32)LCD_X(90+198*i),(u32)LCD_Y(170));
        assert(!lcd_settings_view && lcd_wave_view==(i==1u) && lcd_data_view==(i==2u) &&
               lcd_spectrum_view==(i==3u) && lcd_sd_view==(i==4u) && mock_sd_active);
        drain_frame();expected_frame();
        press((u32)LCD_X(920),(u32)LCD_Y(55));assert(lcd_settings_view);
    }
    mock_sd_active=0u;
    press((u32)LCD_X(920),(u32)LCD_Y(55));assert(!lcd_settings_view);
    press((u32)LCD_X(760),(u32)LCD_Y(60));assert(lcd_rehab_view);
    press((u32)LCD_X(560),(u32)LCD_Y(45));assert(ui_menu_open && !lcd_rehab_view);
    press((u32)LCD_X(920),(u32)LCD_Y(55));assert(lcd_settings_view && !ui_menu_open);
    drain_frame();expected_frame();guard_check();assert(dl_len<LCD_DL_MAX);
    press((u32)LCD_X(90),(u32)LCD_Y(170));assert(!lcd_settings_view);
    drain_frame();expected_frame();
    puts("TEST_PASS UI SETTINGS: text fit/UTF8, both panels, touch controls/reset, page routes, SD continuity.");
}

static void test_sd_capture_ui(void)
{
    u32 ch,seq=301u,before=mock_sd_frames;
    ui_action=ui_sd_action=0u;ui_menu_open=0u;ui_mode_sel=0u;
    lcd_sd_view=lcd_wave_view=lcd_data_view=lcd_spectrum_view=0u;
    lcd_action_label=SD_ACTION_NONE;lcd_sd_label_page=0u;g_mode=MODE_MONITOR;sd_pair_reset();
    press((u32)LCD_X(350),(u32)LCD_Y(45));
    assert(ui_menu_open);
    press((u32)LCD_X(100),(u32)LCD_Y(380));
    assert(!ui_menu_open && lcd_sd_view && ui_action==0u);
    press((u32)LCD_X(90),(u32)LCD_Y(400));
    assert(lcd_action_label==SD_ACTION_REST);
    press((u32)LCD_X(500),(u32)LCD_Y(276));
    assert(ui_sd_action==1u && !mock_sd_active);
    ui_apply_action();assert(mock_sd_active && sd_record_ready());
    for(ch=0;ch<8u;ch++) {
        parse_packet((u32)(1000+(int)ch),0x10000000u|(ch<<24)|seq);
        parse_packet((u32)(2000+(int)ch),0x50000000u|(ch<<24)|seq);
    }
    assert(mock_sd_frames==before+1u && mock_sd_last_action==SD_ACTION_REST);
    assert(mock_sd_last_raw[7]==1007 && mock_sd_last_notch[7]==2007);
    /* Duplicate packets cannot create a second frame. */
    for(ch=0;ch<8u;ch++) {
        sd_pair_packet(ch,0x10000000u|(ch<<24)|seq);
        sd_pair_packet(ch,0x50000000u|(ch<<24)|seq);
    }
    assert(mock_sd_frames==before+1u);
    press((u32)LCD_X(22+2*196+90),(u32)LCD_Y(400));
    assert(lcd_action_label==SD_ACTION_FIST);
    /* Every expanded manual label is reachable on its page and selected IDs persist. */
    {
        u32 page,slot,action;
        for(action=1u;action<=SD_ACTION_COUNT;action++) {
            page=(action-1u)/SD_LABELS_PER_PAGE;
            slot=(action-1u)%SD_LABELS_PER_PAGE;
            press((u32)LCD_X(512+(i32)page*161+76),(u32)LCD_Y(346));
            assert(lcd_sd_label_page==page);
            press((u32)LCD_X(22+(i32)slot*196+90),(u32)LCD_Y(400));
            assert(lcd_action_label==action);
        }
    }
    seq++;
    for(ch=0;ch<8u;ch++) {
        parse_packet((u32)(3000+(int)ch),0x10000000u|(ch<<24)|seq);
        parse_packet((u32)(4000+(int)ch),0x50000000u|(ch<<24)|seq);
    }
    assert(mock_sd_frames==before+2u && mock_sd_last_action==SD_ACTION_THUMB_INDEX_MIDDLE);
    press((u32)LCD_X(500),(u32)LCD_Y(276));
    assert(ui_sd_action==2u);
    ui_apply_action();assert(!mock_sd_active);
    drain_frame(); expected_frame(); guard_check();
    {char name[64];sprintf(name,"sd_capture_%u.ppm",(u32)LCD_W);ppm(name);}
    press((u32)LCD_X(800),(u32)LCD_Y(545));
    assert(lcd_action_label==SD_ACTION_NONE);
    press((u32)LCD_X(560),(u32)LCD_Y(45));
    assert(!lcd_sd_view);
    lcd_sd_view=lcd_wave_view=lcd_data_view=lcd_spectrum_view=0u;
    lcd_show_state(0,80,0,0,0,0);drain_frame();
    puts("TEST_PASS SD LCD: fifth menu entry, capture toggle, action labels, paired raw/notch frames.");
}

static void rehab_test_feed(u32 cls)
{
    u32 i;
    test_time+=25u*GT_TICKS_PER_MS;
    for(i=0u;i<5u;i++)res_logits[i]=i==cls?10000u:0u;
    for(i=0u;i<8u;i++){feat_mav[i]=cls?10000u:100u;cal_thr[i]=300u;}
    rehab_test_seq=(rehab_test_seq+40u)&65535u;
    parse_packet(cls,0x30500000u|rehab_test_seq);
}
static void test_rehab_ui(void)
{
    u32 i,n,old_label=lcd_action_label,saves=mock_rehab_saves;
    char name[80];
    g_mode=MODE_MONITOR;mock_sd_active=0u;rehab.state=RH_IDLE;rehab_setup_stage=0u;
    ui_rehab_action=ui_action=ui_sd_action=0u;ui_menu_open=0u;
    press((u32)LCD_X(350),(u32)LCD_Y(45));assert(ui_menu_open);
    press((u32)LCD_X(450),(u32)LCD_Y(175));assert(lcd_rehab_view && !ui_menu_open);
    assert(ui_preview_cls==-1);
    drain_frame();expected_frame();sprintf(name,"rehab_setup_%u.ppm",(u32)LCD_W);ppm(name);
    press((u32)LCD_X(700),(u32)LCD_Y(170));assert(rehab_combo);
    press((u32)LCD_X(300),(u32)LCD_Y(170));assert(!rehab_combo);
    press((u32)LCD_X(500),(u32)LCD_Y(240));assert(rehab_action==2u);
    press((u32)LCD_X(300),(u32)LCD_Y(310));assert(rehab_reps_sel==0u);
    press((u32)LCD_X(300),(u32)LCD_Y(380));assert(rehab_hold_sel==0u);
    press((u32)LCD_X(300),(u32)LCD_Y(450));assert(rehab_rest_sel==0u);
    press((u32)LCD_X(100),(u32)LCD_Y(545));assert(rehab_setup_stage);
    drain_frame();expected_frame();sprintf(name,"rehab_prepare_%u.ppm",(u32)LCD_W);ppm(name);
    press((u32)LCD_X(100),(u32)LCD_Y(545));ui_apply_action();assert(rehab.state==RH_IDLE);
    press((u32)LCD_X(100),(u32)LCD_Y(230));assert(rehab_contact_checked);
    press((u32)LCD_X(100),(u32)LCD_Y(300));assert(rehab_comfort_checked);
    cal_stage=2u;
    mock_sd_active=1u;press((u32)LCD_X(100),(u32)LCD_Y(545));ui_apply_action();
    assert(rehab.state==RH_IDLE);mock_sd_active=0u;
    press((u32)LCD_X(100),(u32)LCD_Y(545));ui_apply_action();
    assert(rehab.state==RH_CALIBRATE && cal_stage==0u && rehab.total==3u);
    drain_frame();expected_frame();sprintf(name,"rehab_calibration_%u.ppm",(u32)LCD_W);ppm(name);
    cal_stage=2u;
    for(n=0u;n<120u && rehab.state!=RH_CUE;n++)rehab_test_feed(0u);
    assert(n<120u && rehab.target==2u);
    for(n=0u;n<22u;n++)rehab_test_feed(2u);
    assert(rehab.state==RH_HOLD && rehab.segment_ms>200u && !rehab.attempted);
    drain_frame();expected_frame();sprintf(name,"rehab_hold_%u.ppm",(u32)LCD_W);ppm(name);
    /* Returning to training never loses the session; leaving it does not score. */
    press((u32)LCD_X(100),(u32)LCD_Y(545));ui_apply_action();assert(rehab.state==RH_PAUSED);
    press((u32)LCD_X(560),(u32)LCD_Y(45));assert(!lcd_rehab_view);
    rehab_service();assert(rehab.state==RH_PAUSED);
    lcd_rehab_open();
    drain_frame();expected_frame();sprintf(name,"rehab_pause_%u.ppm",(u32)LCD_W);ppm(name);
    press((u32)LCD_X(100),(u32)LCD_Y(545));ui_apply_action();assert(rehab.state==RH_CALIBRATE);
    cal_stage=2u;
    for(n=0;n<120u && rehab.state!=RH_CUE;n++)rehab_test_feed(0u);
    assert(n<120u);
    for(i=0u;i<3u;i++) {
        for(n=0u;n<100u && rehab.state!=RH_RECOVER;n++)rehab_test_feed(2u);
        assert(n<100u && rehab.successes==i+1u);
        for(n=0u;n<120u && rehab.state==RH_RECOVER;n++)rehab_test_feed(0u);
        assert(n<120u);
    }
    assert(rehab.state==RH_DONE && rehab.attempted==3u && rehab.successes==3u);
    assert(lcd_action_label==old_label); /* cues never become training labels */
    rehab_service();assert(ui_rehab_action==4u);ui_apply_action();
    assert(rehab.save_state==2u && mock_rehab_saves==saves+1u);
    assert(strstr(mock_rehab_csv,BUILD_TAG) && strstr(mock_rehab_csv,"trial,1,2,1,"));
    sprintf(name,"rehab_report_%u.csv",(u32)LCD_W);
    {FILE *f=fopen(name,"wb");assert(f);fputs(mock_rehab_csv,f);fclose(f);}
    drain_frame();expected_frame();sprintf(name,"rehab_result_%u.ppm",(u32)LCD_W);ppm(name);
    /* Manual retry reports a failed write and can recover. */
    rehab.save_state=3u;mock_rehab_save_error=99u;
    press((u32)LCD_X(450),(u32)LCD_Y(545));ui_apply_action();
    assert(rehab.save_state==3u && rehab_save_error==99u);
    mock_rehab_save_error=0u;press((u32)LCD_X(450),(u32)LCD_Y(545));ui_apply_action();assert(rehab.save_state==2u);
    press((u32)LCD_X(100),(u32)LCD_Y(545));assert(rehab.state==RH_IDLE);
    press((u32)LCD_X(560),(u32)LCD_Y(45));assert(!lcd_rehab_view);
    /* Low GT word wraps every ~12.9s; accumulated milliseconds stay correct. */
    rehab_clock_seen=1u;rehab_clock_last=0xffff0000u;rehab_clock_remainder=0u;
    rehab_clock_ms=200u;test_time=0x10000u;
    assert(rehab_milliseconds()==200u && rehab_clock_remainder>0u);
    guard_check();assert(lcd_overflow_cnt==0u);
    puts("TEST_PASS REHAB LCD: setup/touch, blocked recording, real classifier packets, hold/recovery, pause/recalibration, result/CSV/retry, labels unchanged, both panels, GT rollover.");
}

static u32 pose_test_seq;
static void pose_test_feed(u32 cls, u32 ambiguous, u32 gate)
{
    u32 i;
    for(i=0;i<5;i++) res_logits[i]=(!ambiguous && i==cls)?10000u:0u;
    pose_test_seq=(u16)(pose_test_seq+40u);
    pose_observe(pose_test_seq,gate?0u:cls,logit_conf(),gate);
}

static void test_pose_stability(void)
{
    u32 i, q;
    pose_active_cls=pose_active_conf=pose_pending_cls=pose_pending_count=0u;
    pose_uncertain_count=pose_observe_seen=pose_active_gated=0u;
    pose_test_seq=65500u; /* Confirmation must also survive normal seq wrap. */
    lcd_stream_started=1u;
    pose_test_feed(1,0,0);pose_test_feed(1,0,0);
    assert(pose_active_cls==0u);
    pose_test_feed(1,0,0);assert(pose_active_cls==1u);
    pose_test_feed(1,1,0);assert(pose_active_cls==1u && pose_active_conf==20u);
    pose_test_feed(1,0,0);assert(pose_active_conf>=98u);
    for(i=0;i<POSE_REST_WINDOWS-1u;i++)pose_test_feed(0,0,1);
    assert(pose_active_cls==1u);
    pose_test_feed(0,0,1);assert(pose_active_cls==0u);
    for(i=0;i<POSE_CONFIRM_WINDOWS;i++)pose_test_feed(2,0,0);
    assert(pose_active_cls==2u);
    for(i=0;i<POSE_UNCERTAIN_WINDOWS-1u;i++)pose_test_feed(2,1,0);
    assert(pose_active_cls==2u);
    pose_test_feed(2,1,0);assert(pose_active_cls==0u);
    for(i=0;i<20u;i++)pose_test_feed(1u+i%2u,0,0);
    assert(pose_active_cls==0u); /* Alternating predictions cannot enter an action. */
    pose_test_feed(4,0,0);pose_test_feed(4,0,0);
    pose_test_seq+=40u;pose_test_feed(4,0,0); /* A missing window breaks confirmation. */
    assert(pose_active_cls==0u);
    pose_test_feed(4,0,0);pose_test_feed(4,0,0);assert(pose_active_cls==4u);
    for(i=0;i<POSE_UNCERTAIN_WINDOWS;i++)pose_test_feed(1u+i%2u,0,0);
    assert(pose_active_cls==0u); /* Conflicting strong candidates also expire the old pose. */
    for(i=0;i<5;i++)res_logits[i]=i==4u?10000u:0u;
    q=logit_conf();
    for(i=0;i<5;i++)res_logits[i]=(u32)((i32)res_logits[i]-20000);
    assert(logit_conf()==q); /* Scores must not depend on common logit offset. */
    res_logits[0]=0x80000000u;res_logits[1]=0x7fffffffu;
    res_logits[2]=res_logits[3]=res_logits[4]=0u;
    assert(logit_conf()==100u);
    tx_ring_reset();g_tx_data=1u;
    print_pose_frame(0,4,20,1); /* Accepted P frame must not be gated again. */
    g_tx_data=0u;
    {
        char line[2048];u32 n=0;
        while(tx_tail!=tx_head && n<sizeof(line)-1u) {
            line[n++]=(char)tx_ring[tx_tail];tx_tail=(tx_tail+1u)&TX_RING_MASK;
        }
        line[n]=0;
        assert(strstr(line,"gid=4 q=20") && strstr(line,"stable=1"));
    }
    pose_active_cls=pose_active_conf=pose_active_gated=0u;
    pose_pending_count=pose_uncertain_count=pose_observe_seen=0u;
    lcd_stream_started=0u;tx_ring_reset();
    puts("TEST_PASS pose: entry/hold hysteresis, bounded uncertainty, rest debounce, score refresh, accepted P authority.");
}

static u16 hdc_test_seq;
static void hdc_test_window(u32 cls)
{
    u32 ch,id;
    test_time+=25u*GT_TICKS_PER_MS;
    for(ch=0;ch<8;ch++)for(id=0;id<5;id++) {
        u32 v=id==0u?(ch==cls?10000u:0u):0u;
        parse_packet(v,0x20000000u|(ch<<24)|(id<<20)|hdc_test_seq);
        hdc_test_seq++;
    }
}
static void test_virtual_mapping(void)
{
    u32 k,old_cls=pose_active_cls,old_row=hand_profile.row_mask;char name[80];
    uint32_t physical[6];
    assert(hdc.stage==HDC_DONE && hdc_hand_model_ready());
    memcpy(physical,hdc.hand_pose[5],sizeof physical);
    ui_open_page(UI_MONITOR);ui_recognition_source(1u);
    assert(hand_source_hdc && hdc_available() && !hand_run);
    assert(virtual_live_class()==UINT32_MAX);
    for(k=0;k<2u;k++)hdc_test_window(5u);
    assert(virtual_live_class()==UINT32_MAX);
    hdc_test_window(5u);assert(virtual_live_class()==5u && !virtual_live_mapped(5u));
    lcd_virtual_sample();assert(lcd_pose_cls==0u); /* Unmapped is visibly neutral. */
    press(LCD_X(600),LCD_Y(115));assert(lcd_virtual_view && !hand_run);
    assert(!hdc_available() && !hdc.virtual_mapped[5]);
    virtual_load(5u);virtual_group=2u;virtual_joint=2u;
    press(LCD_X(900),LCD_Y(550));assert(virtual_dirty && !hdc.virtual_mapped[5]);
    press(LCD_X(800),LCD_Y(120));assert(hdc.virtual_mapped[5] && !virtual_dirty);
    assert(hdc.virtual_pose[5][4]==pose_table[0][4]+1);
    assert(!memcmp(physical,hdc.hand_pose[5],sizeof physical) && hand_profile.row_mask==old_row);
    /* Held slider, clamping, +/- one degree and release/page-exit cancellation. */
    press(LCD_X(940),LCD_Y(495));assert(virtual_drag);
    lcd_virtual_contact((u32)LCD_W-1u,LCD_Y(495),1u);assert(virtual_draft[4]==100);
    lcd_virtual_contact(0u,LCD_Y(495),1u);assert(virtual_draft[4]==0);
    lcd_virtual_contact(0u,0u,0u);assert(!virtual_drag);
    press(LCD_X(900),LCD_Y(550));assert(virtual_draft[4]==1);
    press(LCD_X(800),LCD_Y(120));assert(hdc.virtual_pose[5][4]==1);
    drain_frame();expected_frame();sprintf(name,"virtual_neutral_%u.ppm",(u32)LCD_W);ppm(name);
    virtual_group=0u;virtual_joint=0u;virtual_adjust(-70);
    virtual_joint=1u;virtual_adjust(30);virtual_group=1u;virtual_joint=1u;virtual_adjust(-100);
    press(LCD_X(800),LCD_Y(120));
    assert(hdc.virtual_pose[5][0]==-70 && hdc.virtual_pose[5][1]==30 && hdc.virtual_pose[5][19]==-100);
    drain_frame();expected_frame();sprintf(name,"virtual_editor_%u.ppm",(u32)LCD_W);ppm(name);
    press(LCD_X(690),LCD_Y(120));assert(virtual_row==6u && !hdc.virtual_mapped[6]);
    press(LCD_X(100),LCD_Y(165));assert(virtual_dirty);
    press(LCD_X(800),LCD_Y(120));assert(hdc.virtual_mapped[6]);
    assert(!memcmp(hdc.virtual_pose[6],pose_table[virtual_preset],sizeof virtual_draft));
    press(LCD_X(920),LCD_Y(120));assert(!hdc.virtual_mapped[6] && !virtual_dirty);
    virtual_load(5u);
    ui_open_page(UI_MONITOR);
    for(k=0;k<3u;k++)hdc_test_window(5u);
    assert(virtual_live_class()==5u && virtual_live_mapped(5u));
    lcd_virtual_sample();assert(lcd_pose_cls==5u);
    test_time+=POSE_SMOOTH_MS*GT_TICKS_PER_MS;lcd_virtual_sample();
    for(k=0;k<22u;k++)assert(lcd_draw_angles[k]==hdc.virtual_pose[5][k]);
    assert(pose_active_cls==old_cls && !hand_run);
    /* Source/preview are display decisions and never override rehab truth. */
    ui_preview_cls=2;lcd_virtual_sample();assert(lcd_pose_cls==2u && !hand_run);
    ui_preview_cls=-1;
    test_time+=251u*GT_TICKS_PER_MS;hdc_service();
    assert(virtual_live_class()==UINT32_MAX && !hand_hdc_valid);
    lcd_virtual_sample();assert(lcd_pose_cls==0u);
    mock_sd_active=1u;assert(!hdc_available());mock_sd_active=0u;
    ui_recognition_source(0u);assert(!hand_source_hdc && !hand_run);
    lcd_state_cls=1u;lcd_virtual_sample();assert(lcd_pose_cls==1u);
    lcd_hand_open();for(k=0;k<3u;k++)hdc_test_window(5u);
    assert(hand_hdc_valid && hand_hdc_class==5u && !hand_run);
    puts("TEST_PASS VIRTUAL MAPPING: independent 22 joint degrees, editor save/clear/preset/drag, shared MLP-HDC source, stable parser classes, unmapped/stale guards, no implicit PWM, basic rehab truth preserved, both panels.");
}

static void test_hdc_ui(void)
{
    u32 c,t,k,pose,rows,label;char name[80];FILE *csv;
    u32 proto_hash;
    g_mode=MODE_MONITOR;cal_stage=2u;mock_sd_active=0u;
    rehab.state=RH_IDLE;hdc.stage=HDC_IDLE;hdc_custom=3u;
    selfcal_reset(&selfcal);feature_seq_seen=0u;hdc_test_seq=65496u;
    ui_open_page(UI_SETTINGS);
    press((u32)LCD_X(400),(u32)LCD_Y(545));assert(lcd_hdc_view);
    press((u32)LCD_X(220),(u32)LCD_Y(545));assert(hdc.stage==HDC_FIT && hdc.classes==8u);
    pose=pose_active_cls;rows=res_rows;label=lcd_action_label;
    /* Page departure discards a partial trial, preserves committed data. */
    press((u32)LCD_X(60),(u32)LCD_Y(240));assert(hdc.armed);
    for(k=0;k<44;k++)hdc_test_window(0);
    assert(hdc.n==4u && !hdc.fit_n[0]);
    press((u32)LCD_X(560),(u32)LCD_Y(45));hdc_service();
    assert(!lcd_hdc_view && !hdc.armed && hdc.interruptions==1u);
    lcd_hdc_open();
    for(c=0;c<8;c++)for(t=0;t<3;t++) {
        u32 x=50u+(c%4u)*245u,y=c<4u?240u:320u;
        press((u32)LCD_X(x),(u32)LCD_Y(y));assert(hdc.armed);
        for(k=0;k<80;k++)hdc_test_window(c);
        assert(!hdc.armed && hdc.fit_n[c]==40u*(t+1u));
    }
    assert(hdc.stage==HDC_BUILD);
    for(k=0;k<960u;k++)hdc_service();
    assert(hdc.stage==HDC_VALIDATE && pose_active_cls==pose && res_rows==rows);
    proto_hash=0u;for(k=0;k<2048;k++)proto_hash=proto_hash*33u+(u32)hdc.proto[0][k];
    drain_frame();expected_frame();sprintf(name,"hdc_validate_%u.ppm",(u32)LCD_W);ppm(name);
    for(c=0;c<8;c++)for(t=0;t<2;t++) {
        u32 x=50u+(c%4u)*245u,y=c<4u?240u:320u;
        press((u32)LCD_X(x),(u32)LCD_Y(y));assert(hdc.armed);
        for(k=0;k<80;k++)hdc_test_window(c);
        assert(!hdc.armed && hdc.val_n[c]==40u*(t+1u));
    }
    assert(hdc.stage==HDC_DONE && hdc.latest==7u && hdc_accuracy(hdc.hdc_cm,8u)==100u);
    {u32 after=0u;for(k=0;k<2048;k++)after=after*33u+(u32)hdc.proto[0][k];assert(after==proto_hash);}
    assert(pose_active_cls==pose && res_rows==rows && lcd_action_label==label);
    drain_frame();expected_frame();sprintf(name,"hdc_result_%u.ppm",(u32)LCD_W);ppm(name);
    press((u32)LCD_X(800),(u32)LCD_Y(545));assert(ui_hdc_save);ui_apply_action();
    assert(hdc_saved && !hdc_save_error && mock_hdc_saves && !rehab_csv_overflow);
    assert(strstr(mock_rehab_csv,"hdc,custom3,custom3,80") && strstr(mock_rehab_csv,"RAM_only_relearn_after_reset"));
    sprintf(name,"hdc_report_%u.csv",(u32)LCD_W);csv=fopen(name,"wb");assert(csv);
    fwrite(mock_rehab_csv,1,strlen(mock_rehab_csv),csv);fclose(csv);
    mock_rehab_save_error=7u;hdc_save_report();assert(!hdc_saved && hdc_save_error==7u);
    mock_rehab_save_error=0u;
    /* Keep the actual frozen HDC predictor alive on the hand page. These
     * labels come from parsed features and model output, not touch labels. */
    assert(hdc_hand_model_ready());lcd_hand_open();
    assert(lcd_hand_view && hdc_available() && !hand_hdc_valid);
    for(c=5u;c<8u;c++) {
        for(k=0;k<3u;k++)hdc_test_window(c);
        assert(hand_hdc_valid && hand_hdc_class==c && hdc.latest==c);
    }
    {u32 after=0u;for(k=0;k<2048;k++)after=after*33u+(u32)hdc.proto[0][k];assert(after==proto_hash);}
    test_time+=300u*GT_TICKS_PER_MS;hdc_service();assert(!hdc.latest_valid);
    assert(!hand_hdc_valid);lcd_hdc_open();
    test_virtual_mapping();lcd_hdc_open();
    /* Append beyond three custom gestures without mechanical mappings. */
    assert(!hdc.hand_mapped[5]);
    press((u32)LCD_X(500),(u32)LCD_Y(545));
    assert(hdc.classes==9u && hdc.stage==HDC_FIT && hdc_page==1u);
    assert(!hdc_save_error && !hdc_saved);
    assert(hdc.fit_n[5]==HDC_FIT_WINDOWS && !hdc.fit_n[8]);
    assert(hdc.virtual_mapped[5] && hdc.virtual_pose[5][19]==-100 && !hdc.virtual_mapped[8]);
    drain_frame();expected_frame();sprintf(name,"hdc_page2_%u.ppm",(u32)LCD_W);ppm(name);
    press((u32)LCD_X(700),(u32)LCD_Y(170));assert(hdc_page==0u);
    press((u32)LCD_X(880),(u32)LCD_Y(170));assert(hdc_page==1u);
    press((u32)LCD_X(60),(u32)LCD_Y(240));assert(hdc.armed && hdc.target==8u);
    hdc_interrupt(&hdc);
    /* First packet timeout after arming is handled even before seq_seen. */
    hdc_begin(&hdc,3u);assert(hdc_arm(&hdc,0u));hdc.last_ms=rehab_milliseconds();
    test_time+=300u*GT_TICKS_PER_MS;hdc_service();assert(!hdc.armed);
    ui_open_page(0u);hdc.stage=HDC_IDLE;
    puts("TEST_PASS HDC LCD: real parser, eight classes, independent validation, frozen custom1/2/3 live hand bridge, timeout abort, CSV/retry, original pose/manual labels untouched, both panels.");
}

static void test_navigation_lifecycle(void)
{
    u32 from,to,flags,backend=g_mode;char name[80];
    rehab.state=RH_IDLE;hdc.stage=HDC_IDLE;
    /* All route pairs have exactly one owner and never change the backend
     * or stop an existing SD recording. This catches overlapping page flags. */
    mock_sd_active=1u;
    for(from=0u;from<UI_PAGE_COUNT;from++)for(to=0u;to<UI_PAGE_COUNT;to++) {
        ui_open_page(from);ui_open_page(to);
        flags=lcd_wave_view+lcd_data_view+lcd_spectrum_view+lcd_sd_view+lcd_synergy_view+
            lcd_rehab_view+lcd_settings_view+lcd_hdc_view+lcd_hand_view+lcd_selfcal_view+lcd_virtual_view;
        assert(flags==(to==UI_MONITOR?0u:1u) && mock_sd_active && g_mode==backend);
    }
    mock_sd_active=0u;
    ui_open_page(UI_DATA);lcd_wave_toggle();assert(lcd_wave_view && !lcd_data_view);
    ui_open_page(UI_SD);ui_sd_action=1u;ui_home_open();ui_apply_action();assert(!mock_sd_active);
    ui_open_page(UI_REHAB);rehab_setup_stage=rehab_contact_checked=rehab_comfort_checked=1u;
    ui_rehab_action=1u;ui_home_open();ui_apply_action();assert(rehab.state==RH_IDLE);
    selfcal_begin(&selfcal);assert(selfcal.state==1u);
    ui_open_page(UI_WAVE);assert(selfcal.state!=1u && selfcal.state!=2u);
    g_mode=MODE_MONITOR;cal_stage=2u;hdc_begin(&hdc,1u);assert(hdc_arm(&hdc,1u));
    ui_open_page(UI_REHAB);assert(!hdc.armed);
    /* Leaving is an immediate pause, before the next service tick. */
    rehab_start(&rehab,0u,2u,5u,1000u,1000u,rehab_milliseconds());
    ui_home_open();assert(rehab.state==RH_PAUSED);
    ui_rehab_action=2u;ui_open_page(UI_WAVE);ui_apply_action();assert(rehab.state==RH_PAUSED);
    rehab_finish(&rehab,rehab_milliseconds(),1u);rehab.state=RH_IDLE;
    /* Four completed trials in one combination group, then explicit rest. */
    ui_open_page(UI_REHAB);rehab_start(&rehab,1u,1u,2u,1000u,1000u,rehab_milliseconds());
    rehab.group_every=4u;rehab.group_rest_ms=15000u;
    rehab.attempted=4u;rehab.groups_completed=1u;rehab.group_pending=1u;
    rehab_phase(&rehab,RH_GROUP_REST,rehab_milliseconds());rehab.seen=1u;
    rehab.last_observation=rehab_milliseconds();
    press(LCD_X(100),LCD_Y(545));ui_apply_action();assert(rehab.state==RH_GROUP_REST);
    drain_frame();expected_frame();sprintf(name,"rehab_group_%u.ppm",(u32)LCD_W);ppm(name);
    {u32 i;for(i=0u;i<600u;i++)rehab_test_feed(0u);}
    assert(rehab.state==RH_GROUP_REST && rehab.attempted==4u);
    press(LCD_X(100),LCD_Y(545));ui_apply_action();assert(rehab.state==RH_RELAX);
    rehab_finish(&rehab,rehab_milliseconds(),1u);rehab.state=RH_IDLE;
    rehab_setup_stage=rehab_contact_checked=rehab_comfort_checked=0u;
    hdc.stage=HDC_IDLE;ui_rehab_action=0u;ui_home_open();
    drain_frame();expected_frame();sprintf(name,"home_%u.ppm",(u32)LCD_W);ppm(name);
    ui_open_page(UI_MONITOR);guard_check();
    puts("TEST_PASS NAV LIFECYCLE: 144 routes, unique page, SD continuity, backend unchanged, orphan actions canceled, capture canceled, immediate pause, explicit group continuation.");
}

static void test_button_feedback(void)
{
    u32 i,before,pressed_hash,normal_hash,serial;char name[96];
    drain_frame();test_clock_step=0u;
    ui_open_page(UI_SETTINGS);ui_grid_enabled=0u;
    drain_frame();expected_frame();normal_hash=hash(regs[2]&31u);
    press(LCD_X(500),LCD_Y(320));
    assert(ui_grid_enabled && ui_feedback_active && !ui_feedback_presented);
    assert(ui_button_pressed(LCD_X(410),LCD_Y(296),LCD_X(270),LCD_Y(54)));
    before=touch_press_cnt;
    for(i=0u;i<10u;i++)touch_tick();
    assert(ui_grid_enabled && touch_press_cnt==before);
    /* Even a slow first render gets a full visible dwell after presentation. */
    test_time+=500u*GT_TICKS_PER_MS;ui_feedback_tick();assert(ui_feedback_active);
    drain_frame();expected_frame();assert(ui_feedback_presented);
    pressed_hash=hash(regs[2]&31u);assert(pressed_hash!=normal_hash);
    {u32 at=32u+((u32)LCD_Y(306)*(u32)LCD_W+(u32)LCD_X(430))*3u;
     u32 frame=regs[2]&31u;
     assert(frames[frame][at]==212u && frames[frame][at+1u]==245u && frames[frame][at+2u]==164u);}
    sprintf(name,"feedback_selected_%u.ppm",(u32)LCD_W);ppm(name);
    test_time+=99u*GT_TICKS_PER_MS;ui_feedback_tick();assert(ui_feedback_active);
    test_time+=GT_TICKS_PER_MS;ui_feedback_tick();assert(!ui_feedback_active);
    drain_frame();expected_frame();assert(hash(regs[2]&31u)!=pressed_hash && ui_grid_enabled);
    sprintf(name,"feedback_restored_%u.ppm",(u32)LCD_W);ppm(name);
    press(LCD_X(500),LCD_Y(320));assert(!ui_grid_enabled);
    drain_frame();expected_frame();assert(ui_feedback_presented);
    sprintf(name,"feedback_unselected_%u.ppm",(u32)LCD_W);ppm(name);
    /* An older in-flight draw-list cannot start a newer tap's dwell. */
    press(LCD_X(500),LCD_Y(320));serial=ui_feedback_serial;
    lcd_begin_pending();assert(dl_busy && dl_feedback_serial==serial);
    press(LCD_X(500),LCD_Y(320));assert(ui_feedback_serial==serial+1u);
    lcd_slice_tick(gt_stamp());scanout_accept();
    assert(ui_feedback_active && !ui_feedback_presented);
    drain_frame();expected_frame();assert(ui_feedback_presented && !ui_grid_enabled);
    /* Page cards disappear on navigation; the destination retains the tap
     * ring, but unrelated controls at the same coordinates stay unpressed. */
    ui_home_open();drain_frame();press(LCD_X(100),LCD_Y(280));
    assert(lcd_wave_view && ui_feedback_owner==UI_PAGE_COUNT);
    assert(!ui_button_pressed(LCD_X(28),LCD_Y(246),LCD_X(308),LCD_Y(78)));
    drain_frame();expected_frame();assert(ui_feedback_presented);
    sprintf(name,"feedback_navigation_%u.ppm",(u32)LCD_W);ppm(name);
    serial=ui_feedback_serial;press(LCD_X(900),LCD_Y(55));
    assert(lcd_settings_view && ui_feedback_serial==serial+1u && !ui_feedback_presented);
    assert(ui_button_pressed(LCD_X(875),LCD_Y(30),LCD_X(133),LCD_Y(52)));
    drain_frame();expected_frame();
    /* Expiration uses unsigned timer subtraction across wrap. */
    ui_feedback_t=test_time=0xffff0000u;ui_feedback_presented=1u;
    test_time+=99u*GT_TICKS_PER_MS;ui_feedback_tick();assert(ui_feedback_active);
    test_time+=GT_TICKS_PER_MS;ui_feedback_tick();assert(!ui_feedback_active);
    drain_frame();expected_frame();test_clock_step=100u*333u;
    puts("TEST_PASS BUTTON FEEDBACK: selected/unselected shared controls, no held-repeat, visible dwell after present, navigation ownership, restore, timer wrap, exact full/partial pixels, both panels");
}

int main(void)
{
#ifdef _MSC_VER
    _set_error_mode(_OUT_TO_STDERR);
    _set_abort_behavior(0,_WRITE_ABORT_MSG | _CALL_REPORTFAULT);
#endif
    assert(strcmp(adc_config_label(),"ADC配置等待")==0);
    regs[10]=0xC0EC0101u;adc_status_tick();
    assert(strcmp(adc_config_label(),"ADC配置正常")==0);
    regs[10]=0xADED0001u;adc_status_tick();
    assert(strcmp(adc_config_label(),"ADC配置错误")==0);
    regs[10]=0u;adc_status_tick();
    assert(strcmp(adc_config_label(),"ADC配置等待")==0);
    regs[10]=0xC0ED0101u;adc_status_tick();
    assert(strcmp(adc_config_label(),"ADC配置正常")==0);
    u32 i,panel;
    regs[0]=UART_SR_TXEMPTY|UART_SR_RXEMPTY|UART_SR_TXFULL;
    regs[1]=DMASR_HALTED; regs[5]=VDMA_DMASR_HALTED;
    test_pose_stability();
    assert(mpu_tilt_fold(100,35)==9 && mpu_tilt_fold(-100,35)==-9);
    assert(mpu_tilt_fold(400,35)==35 && mpu_tilt_fold(-400,35)==-35);
    test_tracking_startup();
    test_imu_rotation();
    test_wrist_direction();
    test_projection_and_depth();
    test_wave_data();
    lcd_imu_reset();mpu_word_seen=0;
    regs[7]=regs[9]=0;regs[8]=0xc0000000u;
    for(i=0;i<1000u;i++) { regs[4]=0x81000000u|(200u<<12)|100u; mpu_tick(); }
    assert(mpu_zero_cnt==0u && !mpu_zero_valid);
    for(i=1;i<=100u;i++) {
        test_time+=10u*GT_TICKS_PER_MS;
        regs[4]=0x80000000u|(((i+1u)&127u)<<24)|(200u<<12)|100u; mpu_tick();
    }
    assert(mpu_zero_valid && mpu_zero_r==100 && mpu_zero_p==200);
    regs[4]=0x85000000u|(400u<<12)|100u; mpu_tick(); assert(mpu_tilt_q==-19);
    lcd_imu_valid=0; /* Below renderer stress cases use explicit fallback angles. */
    for(panel=0;panel<2;panel++) {
        lcd_w=panel?1024:800; lcd_h=panel?600:480;
        fb_bpl=(u32)lcd_w*3; fb_bytes=fb_bpl*(u32)lcd_h;
        memset(frames,0xa5,sizeof frames);
        lcd_stream_started=0; lcd_state_valid=0; lcd_pending=dl_busy=0;
        lcd_front_index=0; regs[2]=0; ui_menu_open=ui_dirty=ui_generation=0;
        ui_preview_cls=-1; lcd_clip_top=0; lcd_clip_bottom=LCD_H;
        lcd_show_state(0,80,0,0,0,0);
        lcd_stream_started=lcd_stream_on=1;
        for(i=0;i<5;i++) {
            char name[100];
            lcd_show_state(i,75,i&3u,0,0,0); drain_frame(); expected_frame();
            sprintf(name,"pose_%u_%u.ppm",(u32)LCD_W,i); ppm(name);
        }
        for(i=0;i<60;i++) {
            u32 old_i=dl_i,old_back=dl_back,busy=dl_busy;
            lcd_show_state(1,90,0,0,(i32)i-30,(i32)(i%25)-12);
            if(busy) assert(dl_i==old_i && dl_back==old_back);
            lcd_slice_tick(gt_stamp());
            if((i%8u)==0u) scanout_accept();
        }
        drain_frame(); expected_frame(); assert(lcd_present_cnt>5u);
        /* Complete a frame while scanout delays accepting the last request.
         * The next completed frame waits; neither reserved buffer changes.
         */
        lcd_show_state(1,90,0,0,12,5);
        { u32 n=0, before=lcd_present_cnt;
          while(before==lcd_present_cnt && n++<10000u) lcd_slice_tick(gt_stamp());
          assert(n<10000u);
          lcd_show_state(2,90,1,0,-12,-5);
          for(n=0;n<1000;n++) {
              u32 a=VDMA_PARK_CURRENT(regs[2]),q=regs[2]&31u;
              u32 ha=hash(a),hq=hash(q);
              lcd_slice_tick(gt_stamp());
              assert(hash(a)==ha && hash(q)==hq);
          }
          assert(dl_busy && lcd_present_cnt==before+1u);
          scanout_accept(); drain_frame(); expected_frame();
        }
        lcd_show_state(1,90,0,0,35,25); drain_frame(); expected_frame();
        { char name[80]; sprintf(name,"tilt_%u.ppm",(u32)LCD_W); ppm(name); }
        lcd_show_state(1,90,0,0,180,0); drain_frame(); expected_frame();
        { char name[80]; sprintf(name,"back_%u.ppm",(u32)LCD_W); ppm(name); }
        lcd_show_state(1,90,0,0,90,0); drain_frame(); expected_frame();
        { char name[80]; sprintf(name,"side_%u.ppm",(u32)LCD_W); ppm(name); }
        /* Hold the previous park request off scanout: no premature reuse. */
        lcd_show_state(2,90,0,0,-35,-25); drain_frame(); expected_frame();
        test_time=0xffff0000u;
        lcd_show_state(0,50,0,0,-10,0); drain_frame(); expected_frame();
        press((u32)LCD_X(350),(u32)LCD_Y(45)); assert(ui_menu_open);
        drain_frame(); expected_frame();
        { char name[80]; sprintf(name,"menu_%u.ppm",(u32)LCD_W); ppm(name); }
        press((u32)LCD_X(100),(u32)LCD_Y(510)); assert(!ui_menu_open && ui_action==1u);
        ui_apply_action(); drain_frame(); expected_frame();
        press((u32)LCD_X(350),(u32)LCD_Y(45)); assert(ui_menu_open);
        press((u32)LCD_X(820),(u32)LCD_Y(510)); assert(ui_action==4u);
        ui_apply_action(); assert(!mpu_zero_valid && mpu_zero_cnt==0u);
        drain_frame(); expected_frame();
        press((u32)LCD_X(350),(u32)LCD_Y(45));
        press((u32)LCD_X(920),(u32)LCD_Y(55));
        press((u32)LCD_X(100),(u32)LCD_Y(550));assert(lcd_selfcal_view);
        /* Opening the new adaptation page must not restart rest calibration. */
        press((u32)LCD_X(100),(u32)LCD_Y(545)); assert(!lcd_selfcal_view);ui_open_page(UI_MONITOR);
        drain_frame(); expected_frame();
        press((u32)LCD_X(440),(u32)LCD_Y(555)); assert(ui_preview_cls==2);
        drain_frame(); expected_frame();
        press((u32)LCD_X(440),(u32)LCD_Y(555)); assert(ui_preview_cls==-1);
        drain_frame(); expected_frame();
        { u32 before=touch_press_cnt,bad=touch_bad_xy;
          regs[3]=0x80000000u;touch_tick();
          regs[3]=0xc0000000u|((u32)LCD_W<<12);touch_tick();touch_tick();
          assert(touch_press_cnt==before && touch_bad_xy==bad+1u);
          press((u32)LCD_W-1u,(u32)LCD_H-1u);
          assert(touch_press_cnt==before+1u && touch_seen && touch_dn);
          assert(touch_x==(u32)LCD_W-1u && touch_y==(u32)LCD_H-1u);
          regs[3]=0;touch_tick();assert(!touch_seen && !touch_dn);
          regs[3]=0x80000000u;touch_tick();assert(touch_seen && !touch_dn);
          drain_frame();expected_frame();
        }
        /* Export frames driven by actual calibrated six-axis motion. */
        physical_home(1,0);capture_home();
        lcd_show_state(1,90,0,0,0,0);drain_frame();expected_frame();
        {char name[80];sprintf(name,"imu_palm_%u.ppm",(u32)LCD_W);ppm(name);}
        physical_motion(0,30,100,0);
        lcd_show_state(1,90,0,0,0,0);drain_frame();expected_frame();
        {char name[80];sprintf(name,"imu_lift_%u.ppm",(u32)LCD_W);ppm(name);}
        physical_pronation(180,30);
        lcd_show_state(1,90,0,0,0,0);drain_frame();expected_frame();
        {char name[80];sprintf(name,"imu_flip_lift_%u.ppm",(u32)LCD_W);ppm(name);}
        physical_motion(0,-30,100,0);
        lcd_show_state(1,90,0,0,0,0);drain_frame();expected_frame();
        {char name[80];sprintf(name,"imu_back_%u.ppm",(u32)LCD_W);ppm(name);}
        lcd_imu_reset();
        test_fatigue_readiness_display();
        test_analysis_display();
        test_quality_display();
        test_spectrum_fft();
        test_sd_capture_ui();
        test_wave_display();
        test_ui_settings();
        test_rehab_ui();
        test_synergy_display();
        test_grip_feedback_ui();
        test_text_alignment();
        test_hdc_ui();
        test_navigation_lifecycle();
        test_button_feedback();
        guard_check(); assert(lcd_overflow_cnt==0);
    }
    /* Record mode touch/MPU reports must not contaminate the binary UART. */
    g_mode=MODE_RECORD; regs[6]=0x12345678u;
    regs[4]=0x80000000u|(10u<<24); mpu_tick();
    regs[3]=0x80000000u; touch_tick(); assert(regs[6]==0x12345678u);
    puts("TEST_PASS LCD: continuous updates, buffer ownership, clean ordering, both panels,");
    puts("          full/partial equivalence, bounds, timer wrap, repeated taps, calibration, binary UART,");
    puts("          quaternion XYZ rotation/flip/rezero, perspective, depth-order independence, animation wrap.");
    return 0;
}
