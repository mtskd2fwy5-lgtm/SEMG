#define CONTROL_REFERENCE_NO_MAIN 1
#define PL_CONTROL_ENABLE 1
#include "control_policy_reference.c"
static u32 device_frame[30],device_snapshot[30],suspend_ack,device_zeroes;
static void device_ack(void)
{
    u32 opcode=(imu_command_reg>>24)&15,index=imu_command_reg&255,token=imu_command_reg&0x80000000u;
    if(suspend_ack || (imu_response_reg&0x80000000u)==token)return;
    imu_response_reg=token;
    if(opcode==1) {memcpy(device_snapshot,device_frame,sizeof device_frame);imu_response_reg|=IMU_PL_ABI;}
    else if(opcode==2) {assert(index<30);imu_response_reg|=device_snapshot[index]&0x7fffffffu;}
    else if(opcode==3) {memset(device_frame,0,sizeof device_frame);device_zeroes++;}
}
static void spin(u32 ms)
{
    u32 end=time_ticks+ms*GT_TICKS_PER_MS;
    while((i32)(time_ticks-end)<0) {device_ack();mpu_tick();}
}
static void make_frame(u32 counter)
{
    memset(device_frame,0,sizeof device_frame);device_frame[0]=IMU_PL_ABI;
    device_frame[1]=15u|(100u<<8);device_frame[2]=counter;
    device_frame[3]=(u32)-4096;device_frame[7]=4096;device_frame[11]=(u32)-4096;
    device_frame[12]=180;device_frame[21]=counter&127;
}
int main(void)
{
    u32 count,before;
    imu_legacy_word=0x81000000u;make_frame(1);spin(20);
    assert(lcd_imu_valid && mpu_seen && mpu_zero_valid && imu_hand_rotation_valid);
    assert(lcd_imu_matrix[0]==-4096 && imu_hand_rotation_deg==180);
    count=imu_sample_count;spin(110);
    assert(!lcd_imu_valid && !mpu_seen && !imu_hand_rotation_valid && imu_sample_count==count);
    make_frame(2);spin(12);assert(lcd_imu_valid && imu_sample_count==2);
    /* Updating source during indexed reads must not mix snapshots. */
    while(!(imu_pl_pending && imu_pl_opcode==2u && imu_pl_index==15u)){device_ack();mpu_tick();}
    make_frame(3);device_frame[12]=45;
    while(imu_sample_count==2){device_ack();mpu_tick();}
    assert(imu_sample_count==3 && imu_hand_rotation_deg==45);
    make_frame(4);device_frame[28]=1;spin(12);assert(!lcd_imu_valid);
    make_frame(5);device_frame[3]=6000;spin(12);assert(!lcd_imu_valid && imu_pl_error==4);
    make_frame(6);spin(12);assert(lcd_imu_valid);
    suspend_ack=1;spin(8);assert(!lcd_imu_valid && imu_pl_error==1);
    suspend_ack=0;make_frame(7);spin(12);assert(lcd_imu_valid);
    /* Reset during final indexed read cannot briefly apply old data. */
    while(!(imu_pl_pending && imu_pl_opcode==2u && imu_pl_index==29u)){device_ack();mpu_tick();}
    before=device_zeroes;lcd_imu_reset();device_ack();mpu_tick();assert(!lcd_imu_valid);
    spin(12);assert(device_zeroes==before+1 && !lcd_imu_valid);
    make_frame(1);spin(12);assert(lcd_imu_valid);
    imu_legacy_word=0;spin(1);assert(!lcd_imu_valid && !imu_hand_rotation_valid);
    imu_legacy_word=0x81000000u;device_frame[0]=1;spin(12);assert(!lcd_imu_valid);
    puts("TEST_PASS PS attitude mailbox: frozen frames, signed payload, stale/timeout/ABI/overrun/matrix gates, mid-read zero and disconnect");
    return 0;
}

