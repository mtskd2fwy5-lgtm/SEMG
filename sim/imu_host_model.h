/* Test-only, bit-exact sequencer interpreter. ARM builds never include this.
 * RTL is separately checked against the same vectors and frozen float oracle.
 * LCD tests exercise the real production PL-result consumer / renderer. */
#include "imu_program.h"
static i32 imu_host_rf[256];
static u32 imu_host_pc,imu_host_sp,imu_host_stack[8],imu_host_result[30];
static i32 imu_host_input[8];
static i32 imu_host_saturate(int64_t n)
{return n>2147483647LL?2147483647:n< -2147483648LL?(-2147483647-1):(i32)n;}
static u32 imu_host_sqrt(uint64_t n)
{
    uint64_t bit=UINT64_C(1)<<62,r=0;
    while(bit>n)bit>>=2;
    while(bit) {if(n>=r+bit) {n-=r+bit;r=(r>>1)+bit;}else r>>=1;bit>>=2;}
    return (u32)r;
}
static void imu_host_run(u32 have_sample)
{
    u32 watchdog;
    for(watchdog=0;watchdog<50000;watchdog++) {
        uint64_t ins=imu_test_rom[imu_host_pc];
        u32 op=(u32)(ins>>56),dst=(u32)(ins>>48)&255;
        i32 a=imu_host_rf[(ins>>40)&255],b=imu_host_rf[(ins>>32)&255],imm=(i32)ins;
        uint64_t aa=a<0?-(int64_t)a:a,bb=b<0?-(int64_t)b:b,qv;
        if(op==20 && !have_sample)return;
        imu_host_pc++;
        switch(op) {
        case 1:imu_host_rf[dst]=a;break;
        case 2:imu_host_rf[dst]=imm;break;
        case 3:imu_host_rf[dst]=imu_host_saturate((int64_t)a+b);break;
        case 4:imu_host_rf[dst]=imu_host_saturate((int64_t)a-b);break;
        case 5:imu_host_rf[dst]=imu_host_saturate(((int64_t)a*b)>>imm);break;
        case 6:
            qv=bb?((aa<<(imm==1?0:24))/bb):UINT64_MAX;
            imu_host_rf[dst]=qv>2147483647u?((a<0)!=(b<0)?(-2147483647-1):2147483647):
                ((a<0)!=(b<0)?-(i32)qv:(i32)qv);break;
        case 7:imu_host_rf[dst]=imu_host_sqrt(a<0?0:aa<<24);break;
        case 8:imu_host_rf[dst]=-a;break;
        case 9:imu_host_rf[dst]=(i32)aa;break;
        case 10:imu_host_rf[dst]=b<0?(i32)((u32)a<<(-b)):(a>>b);break;
        case 11:imu_host_rf[dst]=a&b;break;
        case 12:imu_host_rf[dst]=a|b;break;
        case 13:imu_host_pc=(u32)imm;break;
        case 14:if(a==b)imu_host_pc=(u32)imm;break;
        case 15:if(a!=b)imu_host_pc=(u32)imm;break;
        case 16:if(a<b)imu_host_pc=(u32)imm;break;
        case 17:if(a<=b)imu_host_pc=(u32)imm;break;
        case 18:if(a>b)imu_host_pc=(u32)imm;break;
        case 19:if(a>=b)imu_host_pc=(u32)imm;break;
        case 20:have_sample=0;break;
        case 21:break;
        case 22:imu_host_stack[imu_host_sp++]=imu_host_pc;imu_host_pc=imm;break;
        case 23:imu_host_pc=imu_host_stack[--imu_host_sp];break;
        case 24:imu_host_rf[dst]=imu_host_input[imm];break;
        case 25:imu_host_result[imm]=a;break;
        default:assert(0 && "bad IMU instruction");
        }
    }
    assert(0 && "IMU host sequencer watchdog");
}
void imu_host_reset(void)
{
    memset(imu_host_rf,0,sizeof imu_host_rf);memset(imu_host_result,0,sizeof imu_host_result);
    imu_host_pc=IMU_TEST_START;imu_host_sp=0;imu_host_run(0);
}
static void lcd_imu_ingest(u32 a,u32 b,u32 c,u32 word)
{
    u32 now=gt_stamp();
    imu_host_input[0]=imu_s16(a>>16)*1024;imu_host_input[1]=imu_s16(a)*1024;
    imu_host_input[2]=imu_s16(b>>16)*1024;imu_host_input[3]=imu_s16(b);
    imu_host_input[4]=imu_s16(c>>16);imu_host_input[5]=imu_s16(c);
    imu_host_input[6]=(word>>24)&127u;
    imu_host_input[7]=imu_time_valid && now-imu_last_t>80u*GT_TICKS_PER_MS;
    imu_host_run(1);imu_pl_apply(imu_host_result,now);
    imu_previous_raw[0]=imu_s16(b);imu_previous_raw[1]=imu_s16(c>>16);imu_previous_raw[2]=imu_s16(c);
    imu_last_acc[0]=imu_s16(a>>16);imu_last_acc[1]=imu_s16(a);imu_last_acc[2]=imu_s16(b>>16);
}
