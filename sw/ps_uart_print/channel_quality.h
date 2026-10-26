/* Display-only diagnostics of the final signed 4 kSPS waveform.
 * No lead impedance/lead-off measurement and no raw ADC clipping claim.
 * Coherent 1 s DFT bins at 50/100/150/200 Hz; NOT Welch or broadband SNR.
 * Integer arithmetic, O(4) per sample, no FFT or sample buffer allocation. */
#ifndef CHANNEL_QUALITY_H
#define CHANNEL_QUALITY_H
#include <stdint.h>
#define CQ_N 4000u
#define CQ_CHANNELS 8u
#define CQ_STALE_TICKS (1500u*333333u)
static const int16_t cq_sin[80]={0,2571,5126,7649,10126,12539,14876,17121,19260,21280,23170,24916,26509,27938,29196,30273,31163,31862,32364,32666,32767,32666,32364,31862,31163,30273,29196,27938,26509,24916,23170,21280,19260,17121,14876,12539,10126,7649,5126,2571,0,-2571,-5126,-7649,-10126,-12539,-14876,-17121,-19260,-21280,-23170,-24916,-26509,-27938,-29196,-30273,-31163,-31862,-32364,-32666,-32767,-32666,-32364,-31862,-31163,-30273,-29196,-27938,-26509,-24916,-23170,-21280,-19260,-17121,-14876,-12539,-10126,-7649,-5126,-2571};
typedef struct {
    uint32_t n,phase,peak,near_rail,seen,valid,last_t,windows,gaps;
    uint16_t seq;
    int64_t sum,dc[4],ds[4];
    int32_t min_sample,max_sample;
    uint64_t energy;
    uint32_t rms,cf10,line10,rail10,clipped,window_peak,base,base_n,base_sum;
    uint32_t activity_score,mains_score,spike_score,rail_score,total_score,grade,grade_cap;
} channel_quality_t;
static channel_quality_t channel_quality[8];
static uint32_t cq_reference,cq_ref_failed;
enum { CQ_GRADE_A,CQ_GRADE_B,CQ_GRADE_C,CQ_GRADE_D,CQ_GRADE_UNKNOWN=4u };
typedef struct {uint32_t total,activity,mains,spike,rail,grade,cap;} cq_score_t;
static uint32_t cq_sqrt(uint64_t x)
{
    uint64_t bit=(uint64_t)1<<62,r=0;
    while(bit>x)bit>>=2;
    while(bit){if(x>=r+bit){x-=r+bit;r=(r>>1)+bit;}else r>>=1;bit>>=2;}
    return (uint32_t)r;
}
/* LCD adaptation of EMG Lab's 4-way equal-weight score + weakest-component
 * grade cap. Uses only final-signal amplitude, narrowband share, peak factor
 * and processed output rail flags; this differs from website metrics. */
static cq_score_t cq_assess_score(uint32_t valid,uint32_t rms,uint32_t cf10,
                                  uint32_t line10,uint32_t rail10,uint32_t baseline)
{
    cq_score_t s;uint32_t activity,main,spike,rail,cap=0u;
    if(!valid || !rms) {
        s.total=0u;s.activity=s.mains=s.spike=s.rail=0u;s.grade=CQ_GRADE_UNKNOWN;s.cap=0u;return s;
    }
    if(!baseline) {s.total=0u;s.activity=s.mains=s.spike=s.rail=0u;s.grade=CQ_GRADE_UNKNOWN;s.cap=0u;return s;}
    activity=(uint64_t)rms*4u<(uint64_t)baseline?0u:(uint64_t)rms*2u<(uint64_t)baseline?80u:
             (uint64_t)rms>=(uint64_t)baseline*2u?80u:100u;
    main=line10>=200u?0u:line10>=20u?100u-(line10-20u)*100u/180u:100u;
    spike=cf10<=100u?100u:cf10>=300u?0u:100u-(cf10-100u)/2u;
    rail=rail10?0u:100u;
    s.total=(activity+main+spike+rail+2u)/4u;s.activity=activity;s.mains=main;s.spike=spike;s.rail=rail;
    s.grade=s.total>=80u?CQ_GRADE_A:s.total>=60u?CQ_GRADE_B:s.total>=40u?CQ_GRADE_C:CQ_GRADE_D;
    if(activity<80u || main<80u || spike<80u || rail<80u)
        cap=(activity<30u || main<30u || spike<30u || rail<30u)?CQ_GRADE_D:
            (activity<60u || main<60u || spike<60u || rail<60u)?CQ_GRADE_C:CQ_GRADE_B;
    if(rail==0u)cap=CQ_GRADE_D;
    if(cap>s.grade)s.grade=cap;
    s.cap=cap;return s;
}
static void cq_score_channel(channel_quality_t *q)
{
    cq_score_t s=cq_assess_score(q->valid,q->rms,q->cf10,q->line10,q->rail10,q->base);
    q->activity_score=s.activity;q->mains_score=s.mains;q->spike_score=s.spike;q->rail_score=s.rail;
    q->total_score=s.total;q->grade=s.grade;q->grade_cap=s.cap;
}
static void cq_clear_window(channel_quality_t *q)
{
    uint32_t i;q->n=q->phase=q->peak=q->near_rail=0;q->sum=0;q->energy=0;
    for(i=0;i<4;i++)q->dc[i]=q->ds[i]=0;
}
static void cq_start_reference(void)
{
    uint32_t i;cq_reference=1;cq_ref_failed=0;
    for(i=0;i<8;i++){
        channel_quality_t *q=&channel_quality[i];
        q->base=q->base_n=q->base_sum=0;
        cq_clear_window(q);q->valid=0;
    }
}
/* now uses the firmware's wrapping global-timer low word. */
static int cq_ingest(uint32_t payload,uint32_t hdr,uint32_t now)
{
    uint32_t ch=(hdr>>24)&15u,i,a,delta;
    int32_t v=(int32_t)(payload<<8)>>8;
    channel_quality_t *q;
    if((hdr>>28)!=5u || ch>=8 || ((hdr>>16)&255u))return 0;
    q=&channel_quality[ch];
    if(q->seen){
        delta=(uint16_t)((uint16_t)hdr-q->seq);
        if(!delta)return 0;
        if(delta!=1 || now-q->last_t>CQ_STALE_TICKS){
            q->gaps++;q->valid=0;cq_clear_window(q);
            if(cq_reference){cq_reference=0;cq_ref_failed=1;}
        }
    }
    q->seq=(uint16_t)hdr;q->seen=1;q->last_t=now;
    if(!q->n)q->min_sample=q->max_sample=v;
    if(v<q->min_sample)q->min_sample=v;
    if(v>q->max_sample)q->max_sample=v;
    a=v<0?(uint32_t)(-v):(uint32_t)v;
    if(a>q->peak)q->peak=a;
    if(a>=8304721u)q->near_rail++; /* 99% of signed 24-bit range, processed only */
    q->sum+=v;q->energy+=(uint64_t)((int64_t)v*v);
    for(i=0;i<4;i++){
        uint32_t k=(q->phase*(i+1u))%80u;
        q->ds[i]+=(int64_t)v*cq_sin[k];
        q->dc[i]+=(int64_t)v*cq_sin[(k+20u)%80u];
    }
    q->phase++;if(q->phase==80)q->phase=0;
    if(++q->n<CQ_N)return 0;
    {
        int64_t mean=q->sum/(int32_t)CQ_N;
        int64_t rem=q->sum-mean*CQ_N;
        uint64_t centered=(uint64_t)((int64_t)q->energy-2*mean*q->sum+mean*mean*CQ_N);
        uint64_t e16=(centered/CQ_N)*65536u+(centered%CQ_N)*65536u/CQ_N;
        uint64_t lines=0,den;
        e16-=(uint64_t)(rem*rem)*65536u/((uint64_t)CQ_N*CQ_N);
        /* Q16 power avoids rounding residual mains to zero at low RMS. */
        q->rms=cq_sqrt(e16>>16);q->clipped=q->near_rail;q->window_peak=q->peak;
        for(i=0;i<4;i++){
            /* Q8 bin mean retains precision for small EMG amplitudes.
             * Individual squares fit int64 even at the signed 24-bit rails. */
            int64_t re=q->dc[i]/((int32_t)CQ_N*128);
            int64_t im=q->ds[i]/((int32_t)CQ_N*128);
            lines+=(uint64_t)(re*re)+(uint64_t)(im*im);
        }
        den=e16;
        while(lines>((uint64_t)1<<52)){lines>>=1;den>>=1;}
        q->line10=den?(uint32_t)((lines*2000u)/den):0;
        if(q->line10>1000)q->line10=1000;
        {
            uint32_t positive=(uint32_t)((int64_t)q->max_sample-mean);
            uint32_t negative=(uint32_t)(mean-(int64_t)q->min_sample);
            uint32_t ac_peak=positive>negative?positive:negative;
            q->cf10=q->rms?(uint32_t)((uint64_t)ac_peak*10u/q->rms):0;
        }
        q->rail10=q->near_rail*1000u/CQ_N;
        q->valid=1;q->windows++;
        if(cq_reference && q->base_n<3){
            if(q->near_rail || !q->rms){cq_reference=0;cq_ref_failed=1;}
            else {q->base_sum+=q->rms;q->base_n++;}
        }
        if(cq_reference){
            uint32_t ready=1;
            for(i=0;i<8;i++)if(channel_quality[i].base_n<3)ready=0;
            if(ready){
                for(i=0;i<8;i++) {
                    channel_quality[i].base=channel_quality[i].base_sum/3u;
                    cq_score_channel(&channel_quality[i]);
                }
                cq_reference=0;
            }
        }
        cq_score_channel(q);
    }
    cq_clear_window(q);
    return 1;
}
#endif
