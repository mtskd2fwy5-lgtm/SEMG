/* PL attitude ABI 0x17494d55. PS consumes a frozen matrix / twist result;
 * it does not integrate gyro samples or run quaternion fusion. */
#define IMU_GYRO_LSB_DPS 32.8f
#define IMU_PL_COMMAND MMIO32(0x41270000u)
#define IMU_PL_RESPONSE MMIO32(0x41270008u)
#define IMU_PL_ABI 0x17494d55u
static float imu_bias[3]; /* raw-LSB diagnostics, not fusion state */
static i32 imu_last_acc[3],imu_previous_raw[3];
static u32 imu_last_seq,imu_last_t,imu_time_valid;
static u32 imu_stationary,imu_gap_count,imu_clip_count;
static u32 imu_zero_restarts,imu_zero_reason,imu_sample_count,imu_last_dt_ms;
static i32 imu_hand_rotation_deg,imu_hand_rotation_raw,imu_hand_rotation_unwrapped;
static u32 imu_hand_rotation_valid,imu_hand_rotation_seen;
static u32 imu_pl_pending,imu_pl_opcode,imu_pl_index,imu_pl_token;
static u32 imu_pl_sent_t,imu_pl_poll_t,imu_pl_zero_request,imu_pl_counter_seen;
static u32 imu_pl_frame[30],imu_pl_error,imu_pl_cycles,imu_pl_max_cycles;
static i32 imu_s16(u32 v) { return (i32)((v&65535u)^32768u)-32768; }
static void imu_pl_invalidate(void)
{
    u32 changed=lcd_imu_valid||mpu_zero_valid||mpu_seen;
    mpu_seen=mpu_zero_valid=mpu_zero_cnt=lcd_imu_valid=0;
    imu_hand_rotation_valid=imu_hand_rotation_seen=0;
    mpu_tilt_q=mpu_shift_q=lcd_state_tilt=lcd_state_shift=0;
    if(changed) {lcd_imu_generation++;lcd_input_status_changed();}
}
static void imu_pl_apply(const u32 *f,u32 now)
{
    u32 i,changed=0,was_zero=mpu_zero_valid;
    i32 value;
    if(f[0]!=IMU_PL_ABI || !(f[1]&1u) || f[28] ||
       ((f[1]>>8)&127u)>100u || f[21]>127u) {
        imu_pl_invalidate();return;
    }
    for(i=0;i<9;i++) {
        value=(i32)f[3+i];
        if(value< -4200 || value>4200) {imu_pl_error=4u;imu_pl_invalidate();return;}
    }
    if(imu_pl_counter_seen && f[2]==imu_sample_count)return;
    imu_pl_counter_seen=1u;
    if(!lcd_imu_valid)changed=1;
    lcd_imu_valid=mpu_seen=imu_time_valid=1u;
    imu_last_t=mpu_last_sample_t=now;imu_sample_count=f[2];imu_last_seq=f[21];
    mpu_zero_valid=(f[1]>>1)&1u;mpu_zero_cnt=(f[1]>>8)&127u;
    imu_stationary=(f[1]>>3)&1u;imu_zero_reason=(f[1]>>16)&127u;
    imu_hand_rotation_valid=(f[1]>>2)&1u;
    imu_hand_rotation_deg=(i32)f[12];imu_hand_rotation_raw=(i32)f[29];
    imu_hand_rotation_seen=imu_hand_rotation_valid;
    if(imu_hand_rotation_deg< -45 || imu_hand_rotation_deg>225)imu_hand_rotation_valid=0;
    imu_gap_count=f[16];imu_clip_count=f[17];imu_zero_restarts=f[18];imu_last_dt_ms=f[19];
    imu_pl_cycles=f[26];imu_pl_max_cycles=f[27];
    for(i=0;i<3;i++)imu_bias[i]=(float)(i32)f[13+i]*(32.8f/(16777216.0f*0.01745329252f));
    for(i=0;i<9;i++)if(hand_abs((i32)f[3+i]-lcd_imu_matrix[i])>=8)changed=1;
    if(changed) {for(i=0;i<9;i++)lcd_imu_matrix[i]=(i32)f[3+i];lcd_imu_generation++;}
    if(!was_zero && mpu_zero_valid) {
        /* Legacy fallback only; the live hand always uses the PL matrix. */
        mpu_zero_p=MPU_TW_PITCH(MPU_GPIO);mpu_zero_r=MPU_TW_ROLL(MPU_GPIO);
        lcd_input_status_changed();
    }
}
static void imu_pl_issue(u32 opcode,u32 index,u32 now)
{
    imu_pl_token=(IMU_PL_RESPONSE^0x80000000u)&0x80000000u;
    imu_pl_opcode=opcode;imu_pl_sent_t=now;imu_pl_pending=1u;
    lcd_memory_barrier();IMU_PL_COMMAND=imu_pl_token|(opcode<<24)|index;
    lcd_memory_barrier();
}
static void lcd_imu_reset(void)
{
    imu_pl_invalidate();imu_pl_zero_request=1u;imu_pl_counter_seen=0;
    imu_time_valid=0;imu_last_dt_ms=0;imu_hand_rotation_deg=0;
    imu_zero_reason=0;imu_hand_rotation_raw=imu_hand_rotation_unwrapped=0;
    mpu_zero_acc_r=mpu_zero_acc_p=0;
#ifdef LCD_HOST_TEST
    {extern void imu_host_reset(void);imu_host_reset();}
#endif
    lcd_input_status_changed();
}
static void lcd_imu_poll(void)
{
    u32 now=gt_stamp(),response,w=MPU_GPIO;
    /* Freshness belongs to the result counter, never a repeated raw GPIO. */
    if(!MPU_TW_VALID(w) || (imu_time_valid && now-imu_last_t>100u*GT_TICKS_PER_MS))
        imu_pl_invalidate();
    if(imu_pl_pending) {
        response=IMU_PL_RESPONSE;
        if((response&0x80000000u)!=imu_pl_token) {
            if(now-imu_pl_sent_t>5u*GT_TICKS_PER_MS) {imu_pl_error=1u;imu_pl_invalidate();}
            return; /* late acknowledgements are consumed before any retry */
        }
        imu_pl_pending=0;response&=0x7fffffffu;
        if(imu_pl_zero_request) {imu_pl_zero_request=0;imu_pl_issue(3u,0u,now);return;}
        if(imu_pl_opcode==1u) {
            if(response!=IMU_PL_ABI) {imu_pl_error=2u;imu_pl_invalidate();return;}
            imu_pl_index=0;
        } else if(imu_pl_opcode==2u) {
            imu_pl_frame[imu_pl_index++]=(response&0x40000000u)?response|0x80000000u:response;
            if(imu_pl_index==30u) {
                if(MPU_TW_VALID(w))imu_pl_apply(imu_pl_frame,now);
                else imu_pl_invalidate();
                imu_pl_poll_t=now;
                mpu_pitch=MPU_TW_PITCH(w);mpu_roll=MPU_TW_ROLL(w);
                imu_last_acc[0]=imu_s16(MPU_MOTION_A>>16);imu_last_acc[1]=imu_s16(MPU_MOTION_A);
                imu_last_acc[2]=imu_s16(MPU_MOTION_B>>16);imu_previous_raw[0]=imu_s16(MPU_MOTION_B);
                imu_previous_raw[1]=imu_s16(MPU_MOTION_C>>16);imu_previous_raw[2]=imu_s16(MPU_MOTION_C);
                if(lcd_state_valid && lcd_state_imu_generation!=lcd_imu_generation)
                    lcd_show_state(lcd_state_cls,lcd_state_conf,lcd_state_fatigue,lcd_state_gated,0,0);
                return;
            }
        } else if(imu_pl_opcode==3u) {imu_pl_poll_t=0;return;}
        if(imu_pl_zero_request) {imu_pl_zero_request=0;imu_pl_issue(3u,0u,now);return;}
        imu_pl_issue(2u,imu_pl_index,now);return;
    }
    if(imu_pl_zero_request) {imu_pl_zero_request=0;imu_pl_issue(3u,0u,now);return;}
    if(now-imu_pl_poll_t<5u*GT_TICKS_PER_MS)return;
    imu_pl_issue(1u,0u,now);
}
#ifdef LCD_HOST_TEST
#include "../../sim/imu_host_model.h"
#endif

