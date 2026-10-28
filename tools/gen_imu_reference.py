"""Keep the pre-migration float implementation as an independent test oracle."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
old=ROOT/'report/imu_pl_20261028/baseline'
header=(old/'sw/ps_uart_print/lcd_imu_3d.h').read_text(encoding='utf-8')
prefix='''/* Independent pre-migration reference. Generated; never built for ARM. */
static FILE *imu_vector_file;
static void imu_vector_open(void) {
    if(!imu_vector_file) {imu_vector_file=fopen("imu_float_vectors.txt","w");assert(imu_vector_file);}
}
'''
header=header.replace('static void lcd_imu_reset(void)\n{',
    'static void lcd_imu_reset(void)\n{\n    imu_vector_open();fprintf(imu_vector_file,"R\\n");fflush(imu_vector_file);')
header=header.replace('u32 t=gt_stamp(),ticks=t-imu_last_t;',
    'u32 t=gt_stamp(),ticks=t-imu_last_t;\n    u32 vector_gap=imu_time_valid && ticks>80u*GT_TICKS_PER_MS;')
end='''
    imu_vector_open();
    fprintf(imu_vector_file,"S %08x %08x %08x %08x %u %u %u %u %u %d %u %u %u %u %u",
        a,b,c,word,vector_gap,mpu_zero_valid,mpu_zero_cnt,imu_stationary,
        imu_hand_rotation_valid,imu_hand_rotation_deg,imu_zero_reason,imu_gap_count,
        imu_clip_count,imu_sample_count,imu_last_dt_ms);
    for(i=0;i<9;i++)fprintf(imu_vector_file," %d",lcd_imu_matrix[i]);
    for(i=0;i<3;i++)fprintf(imu_vector_file," %.8f",imu_bias[i]);
    fprintf(imu_vector_file,"\\n");fflush(imu_vector_file);
'''
header=header.rstrip()[:-1]+end+'}\n'
(ROOT/'sim/imu_float_reference.h').write_text(prefix+header,encoding='utf-8')
test=(old/'sim/lcd_firmware_test.c').read_text(encoding='utf-8')
test=test.replace('#define LCD_HOST_TEST 1','#define LCD_HOST_TEST 1\n#define IMU_REFERENCE_TEST 1')
(ROOT/'sim/imu_reference_test.c').write_text(test,encoding='utf-8')
print('IMU_FLOAT_REFERENCE_GENERATED from frozen pre-migration source')
