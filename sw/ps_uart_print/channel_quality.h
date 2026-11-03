/* Baseline-free, display-only quality of FINAL signed 4 kSPS samples.
 * Engineering scores follow EMG Lab's four-component/weakest-component
 * pattern. Percentile contrast is a distribution proxy, NOT measured SNR.
 * Processed data cannot certify input contact, impedance or ADC saturation.
 * A bounded background worker analyzes frozen windows; ingestion never FFTs. */
#ifndef CHANNEL_QUALITY_H
#define CHANNEL_QUALITY_H
#include <stdint.h>
#include <string.h>
#include "channel_quality_tables.h"
#define CQ_N 4000u
#define CQ_CHANNELS 8u
#define CQ_FFT_N 2048u
#define CQ_STALE_TICKS (1500u*333333u)
/* u32 ticks cap any interval below 2^32 (~12.87 s), so 12 s is the
 * ceiling; with burst draining the check completes in well under a second
 * and this is only a stream-restart backstop. */
#define CQ_CHECK_TIMEOUT_TICKS (12000u*333333u)
#define CQ_WORK_BUDGET 32u

enum { CQ_GRADE_A,CQ_GRADE_B,CQ_GRADE_C,CQ_GRADE_D,CQ_GRADE_UNKNOWN=4u };
typedef struct {
    uint32_t n,peak,near_rail,seen,valid,last_t,score_t,windows,gaps,epoch,analysis_drops;
    uint16_t seq;
    int64_t sum;
    uint64_t energy;
    int32_t min_sample,max_sample;
    uint32_t rms,cf10,line10,rail10,clipped,window_peak;
    uint32_t snr10,low10,noise10,artifact10,kurtosis10;
    uint32_t distribution_score,mains_score,motion_score,contact_score,total_score,grade,grade_cap;
} channel_quality_t;
static channel_quality_t channel_quality[CQ_CHANNELS];
typedef struct {uint32_t total,distribution,mains,motion,contact,grade,cap;} cq_score_t;
typedef struct {
    uint32_t ready,buffer,epoch,stamp,rms,cf10,rail10,clipped,peak;
    int32_t mean;
} cq_pending_t;
static cq_pending_t cq_pending[CQ_CHANNELS];
static int32_t cq_samples[CQ_CHANNELS][2][CQ_N];
static uint8_t cq_write_buffer[CQ_CHANNELS];
static uint32_t cq_jobs_completed;
/* On-demand full check (one button press): every live channel captures one
 * synchronized window, the worker drains them, and the visible result set
 * commits in a single step. No diagnostic FFT runs between checks. Results
 * are latched per channel when its window completes: a later sequence gap
 * on the live stream clears channel_quality[].valid but must not erase an
 * already delivered check result before the commit. */
static uint32_t cq_check_state,cq_check_t0,cq_check_done,cq_check_nodata,cq_check_valid;
static uint32_t cq_check_count,cq_result_t;
static uint8_t cq_result_ok[CQ_CHANNELS];
static uint32_t cq_sqrt(uint64_t x)
{
    uint64_t bit=(uint64_t)1<<62,r=0;
    while(bit>x)bit>>=2;
    while(bit){if(x>=r+bit){x-=r+bit;r=(r>>1)+bit;}else r>>=1;bit>>=2;}
    return (uint32_t)r;
}
static uint32_t cq_ramp(uint32_t x,uint32_t good,uint32_t bad)
{return x<=good?100u:x>=bad?0u:100u-(x-good)*100u/(bad-good);}
/* Uniform thresholds, no learned rest amplitude or across-channel reference.
 * Motion: 0-5 Hz energy, >5-sigma outliers and Pearson kurtosis.
 * Contact proxy: peak factor and 2-20 Hz energy; not an impedance result. */
static cq_score_t cq_assess_score(uint32_t valid,uint32_t rms,uint32_t snr10,
    uint32_t line10,uint32_t low10,uint32_t artifact10,uint32_t kurtosis10,
    uint32_t cf10,uint32_t noise10,uint32_t clipped)
{
    cq_score_t s;uint32_t gates[5],i,cap=0u,noise_score;
    memset(&s,0,sizeof s);s.grade=CQ_GRADE_UNKNOWN;
    if(!valid)return s;
    if(rms<2u){s.grade=s.cap=CQ_GRADE_D;return s;}
    s.distribution=snr10>=200u?100u:(snr10+50u)*100u/250u;
    /* 10log10((1-p)/p): <=0 dB ->0, >=20 dB ->100.
     * Piecewise power-ratio table avoids soft-float logarithms in ingestion. */
    {
        static const uint16_t pct10[21]={500,443,387,334,285,240,201,166,137,112,91,74,59,48,38,31,25,20,16,13,10};
        uint32_t d;
        s.mains=100u;
        if(line10>=500u)s.mains=0;
        else for(d=1;d<=20;d++)if(line10>=pct10[d]) {
            s.mains=(d-1u)*5u+(pct10[d-1u]-line10)*5u/(pct10[d-1u]-pct10[d]);break;
        }
    }
    s.motion=(4u*cq_ramp(low10,300,800)+3u*cq_ramp(artifact10,50,200)+
              3u*cq_ramp(kurtosis10,80,200)+5u)/10u;
    noise_score=cq_ramp(noise10,100,500);
    s.contact=(6u*cq_ramp(cf10,60,150)+4u*noise_score+5u)/10u;
    s.total=(s.distribution+s.mains+s.motion+s.contact+2u)/4u;
    s.grade=s.total>=80?CQ_GRADE_A:s.total>=60?CQ_GRADE_B:s.total>=40?CQ_GRADE_C:CQ_GRADE_D;
    gates[0]=s.distribution;gates[1]=s.mains;gates[2]=s.motion;gates[3]=noise_score;
    /* A zero/flat processed signal must not pass just because noise is zero.
     * Fullscale is an output warning; raw clipping is not inferred. */
    gates[4]=(rms<2u || clipped)?0u:100u;
    for(i=0;i<5;i++) {
        uint32_t c=gates[i]<30?CQ_GRADE_D:gates[i]<60?CQ_GRADE_C:gates[i]<80?CQ_GRADE_B:CQ_GRADE_A;
        if(c>cap)cap=c;
    }
    if(cap>s.grade)s.grade=cap;
    s.cap=cap;return s;
}
static void cq_clear_window(channel_quality_t *q)
{q->n=q->peak=q->near_rail=0;q->sum=0;q->energy=0;}
static int cq_ingest(uint32_t payload,uint32_t hdr,uint32_t now)
{
    uint32_t ch=(hdr>>24)&15u,a,delta;int32_t v=(int32_t)(payload<<8)>>8;
    channel_quality_t *q;cq_pending_t *p;
    if((hdr>>28)!=5u || ch>=8 || ((hdr>>16)&255u))return 0;
    q=&channel_quality[ch];p=&cq_pending[ch];
    if(q->seen){
        delta=(uint16_t)((uint16_t)hdr-q->seq);if(!delta)return 0;
        if(delta!=1 || now-q->last_t>CQ_STALE_TICKS){
            q->gaps++;q->epoch++;q->valid=0;cq_clear_window(q);
            /* An in-flight worker owns its buffer until it notices epoch.
             * Do not release/reuse that frozen buffer here. */
        }
    }
    q->seq=(uint16_t)hdr;q->seen=1;q->last_t=now;
    cq_samples[ch][cq_write_buffer[ch]][q->n]=v;
    if(!q->n)q->min_sample=q->max_sample=v;
    if(v<q->min_sample)q->min_sample=v;
    if(v>q->max_sample)q->max_sample=v;
    a=v<0?(uint32_t)(-v):(uint32_t)v;
    if(a>q->peak)q->peak=a;
    if(a>=8304721u)q->near_rail++;
    q->sum+=v;q->energy+=(uint64_t)((int64_t)v*v);
    if(++q->n<CQ_N)return 0;
    /* During a check a channel that already delivered its window stops
     * freezing further diagnostics; the worker is busy with the check. */
    if(!p->ready && !(cq_check_state&&(cq_check_done&(1u<<ch)))){
        int64_t mean=q->sum/(int32_t)CQ_N;
        uint64_t centered=(uint64_t)((int64_t)q->energy-2*mean*q->sum+mean*mean*CQ_N);
        uint32_t hi=(uint32_t)(q->max_sample-mean),lo=(uint32_t)(mean-q->min_sample),peak=hi>lo?hi:lo;
        p->buffer=cq_write_buffer[ch];p->epoch=q->epoch;p->stamp=now;
        p->mean=(int32_t)mean;p->rms=cq_sqrt(centered/CQ_N);
        p->cf10=p->rms?(uint32_t)((uint64_t)peak*10u/p->rms):0;
        p->clipped=q->near_rail;p->rail10=q->near_rail*1000u/CQ_N;p->peak=q->peak;
        p->ready=1;cq_write_buffer[ch]^=1u;
    } else q->analysis_drops++; /* diagnostics only, acquisition continues */
    cq_clear_window(q);return 1;
}
static int32_t cq_sine(uint32_t k)
{
    k&=2047u;
    return k<=512u?cq_sin_quarter[k]:k<=1024u?cq_sin_quarter[1024u-k]:
           k<=1536u?-cq_sin_quarter[k-1024u]:-cq_sin_quarter[2048u-k];
}
typedef struct {int64_t x1,x2,y1,y2;} cq_biquad_t;
static int64_t cq_filter(cq_biquad_t *s,int64_t x,const int32_t c[5])
{
    int64_t y=(x*c[0]+s->x1*c[1]+s->x2*c[2]-s->y1*c[3]-s->y2*c[4])/(1LL<<30);
    s->x2=s->x1;s->x1=x;s->y2=s->y1;s->y1=y;return y;
}
static double cq_median(double *a,uint32_t n)
{
    uint32_t i,j;for(i=1;i<n;i++){double v=a[i];j=i;while(j && a[j-1]>v){a[j]=a[j-1];j--;}a[j]=v;}
    return n?(n&1u?a[n/2]:(a[n/2-1]+a[n/2])*0.5):0;
}
/* At most 31 bins per flank; only 20-200 Hz harmonics are scored, matching
 * the final 20-215 Hz branch. Hann ±2 Hz band, 3-15 Hz flank medians. */
static uint32_t cq_pli_stat(const uint64_t *psd,uint32_t fc,double *band,double *base,double *ratio)
{
    double l[16],r[16],pl,pr,fl=0,fr=0;uint32_t nl=0,nr=0,k,n=0;
    uint32_t first=(fc-15u)*CQ_FFT_N/4000u,last=(fc+15u)*CQ_FFT_N/4000u+1u;
    *band=*base=*ratio=0;
    for(k=first;k<=last;k++) {
        int32_t d=(int32_t)(k*4000u)-(int32_t)(fc*CQ_FFT_N);uint32_t ad=(uint32_t)(d<0?-d:d);
        if(ad<=2u*CQ_FFT_N){*band+=(double)psd[k];n++;}
        else if(ad>=3u*CQ_FFT_N && ad<=15u*CQ_FFT_N) {
            if(d<0 && nl<16){l[nl++]=(double)psd[k];fl+=k;}
            if(d>0 && nr<16){r[nr++]=(double)psd[k];fr+=k;}
        }
    }
    if(!n || nl<3 || nr<3)return 0;
    /* Two Welch segments -> nu=4; same median-to-mean correction form. */
    pl=cq_median(l,nl)*1.187054752;pr=cq_median(r,nr)*1.187054752;
    fl/=nl;fr/=nr;
    for(k=first;k<=last;k++) {
        int32_t d=(int32_t)(k*4000u)-(int32_t)(fc*CQ_FFT_N);
        if(d>=-(int32_t)(2*CQ_FFT_N) && d<=(int32_t)(2*CQ_FFT_N))
            *base+=pl+(pr-pl)*((double)k-fl)/(fr-fl);
    }
    *ratio=*base>0?*band / *base:(*band>0?1e9:0);return 1;
}
typedef struct {
    uint32_t stage,ch,cursor,segment,len,group,j,shift,left,peak,scan,nnull;
    int32_t mean;uint32_t hist[2048];
    uint64_t m2,m4,low_energy,noise_energy;
    uint32_t artifacts,snr10,low10,noise10,kurtosis10;
    int32_t re[CQ_FFT_N],im[CQ_FFT_N];uint64_t psd[CQ_FFT_N/2+1];
    cq_biquad_t filter[3];double nulls[64],threshold;
} cq_worker_t;
static cq_worker_t cq_worker;
/* Contrast of top/bottom 20% RMS, not activity-versus-rest SNR. */
static uint32_t cq_contrast(const uint32_t hist[2048])
{
    uint64_t lo=0,hi=0;uint32_t n=0,k,t;int32_t db10=0;
    for(k=0;k<2048 && n<800;k++){t=hist[k];if(t>800-n)t=800-n;lo+=(uint64_t)t*k*k;n+=t;}
    n=0;for(k=2048;k>0 && n<800;){--k;t=hist[k];if(t>800-n)t=800-n;hi+=(uint64_t)t*k*k;n+=t;}
    if(!lo)return hi?300u:0u;
    /* Binary log ratio to ~0.12 dB. Normalize before squaring (Q31). */
    {
        uint32_t nbits=0,i;uint64_t ratio=(hi<<20)/lo,y;int32_t e=-20;
        while(ratio>=((uint64_t)2<<31)){ratio>>=1;e++;}
        while(ratio<((uint64_t)1<<31)){ratio<<=1;e--;}
        e+=31;y=ratio;
        for(i=0;i<8;i++){y=(y*y)>>31;nbits<<=1;if(y>=((uint64_t)2<<31)){y>>=1;nbits++;}}
        db10=(e*256+(int32_t)nbits)*301/2560;
    }
    return db10>0?(uint32_t)db10:0u;
}
/* One call performs <=32 sample/FFT operations, or one small spectrum
 * statistic. No recursive acquisition callbacks and no blocking full FFT. */
static uint32_t cq_service(void)
{
    static const int32_t coeff[3][5]={{16467,32934,16467,-2135557497,1061881540},
      {1071359217,-2142718434,1071359217,-2142713147,1068981897},
      {259157,518315,259157,-2099786147,1027080952}};
    cq_worker_t *w=&cq_worker;cq_pending_t *p;uint32_t b;
    if(!w->stage){
        for(b=0;b<8;b++)if(cq_pending[(w->ch+b)%8].ready){
            uint32_t ch=(w->ch+b)%8;memset(w,0,sizeof *w);w->ch=ch;w->stage=1;break;
        }
        if(!w->stage)return 0;
    }
    p=&cq_pending[w->ch];
    if(p->epoch!=channel_quality[w->ch].epoch){p->ready=0;w->stage=0;w->ch=(w->ch+1)%8;return 0;}
    for(b=0;b<CQ_WORK_BUDGET;b++){
        if(w->stage==1){
            int32_t x=cq_samples[w->ch][p->buffer][w->cursor]-p->mean;
            uint32_t a=(uint32_t)(x<0?-x:x);if(a>w->peak)w->peak=a;
            if(++w->cursor==CQ_N){
                while((w->peak>>w->shift)>8191u)w->shift++;
                if(w->peak)while((w->peak<<w->left)<4096u)w->left++;
                w->cursor=0;w->stage=2;
            }
        }else if(w->stage==2){
            int32_t raw=cq_samples[w->ch][p->buffer][w->cursor]-p->mean;
            int32_t x=(raw*(int32_t)(1u<<w->left))/(int32_t)(1u<<w->shift);
            uint32_t a=(uint32_t)(x<0?-x:x);uint64_t x2=(uint64_t)((int64_t)x*x);
            int64_t low=cq_filter(&w->filter[0],(int64_t)x*65536,coeff[0])/65536;
            int64_t noise=cq_filter(&w->filter[2],cq_filter(&w->filter[1],(int64_t)x*65536,coeff[1]),coeff[2])/65536;
            w->hist[(a>>2)>2047?2047:(a>>2)]++;w->m2+=x2;w->m4+=x2*x2;
            w->low_energy+=(uint64_t)(low*low);w->noise_energy+=(uint64_t)(noise*noise);
            if((uint64_t)((int64_t)raw*raw)>25u*(uint64_t)p->rms*p->rms)w->artifacts++;
            if(++w->cursor==CQ_N){
                w->low10=w->m2?(uint32_t)(1000*w->low_energy/w->m2):0;
                w->noise10=w->m2?(uint32_t)(1000*w->noise_energy/w->m2):0;
                w->kurtosis10=w->m2?(uint32_t)((double)w->m4/(double)w->m2*(double)CQ_N*10.0/(double)w->m2):0;
                w->snr10=cq_contrast(w->hist);w->cursor=0;w->stage=3;
            }
        }else if(w->stage==3){
            uint32_t i=w->cursor,hann=(uint32_t)(32767-cq_sine(i*2048u/(CQ_FFT_N-1u)+512u))/2;
            int32_t raw=cq_samples[w->ch][p->buffer][i+w->segment*1024u]-p->mean;
            int64_t x=(int64_t)raw*((int64_t)1<<w->left)*256/((int64_t)1<<w->shift);
            w->re[i]=(int32_t)(x*hann/32768);w->im[i]=0;
            if(++w->cursor==CQ_FFT_N){w->cursor=1;w->j=0;w->stage=4;}
        }else if(w->stage==4){
            uint32_t i=w->cursor,bit=CQ_FFT_N>>1;
            while(w->j&bit){w->j^=bit;bit>>=1;}w->j^=bit;
            if(i<w->j){int32_t t=w->re[i];w->re[i]=w->re[w->j];w->re[w->j]=t;t=w->im[i];w->im[i]=w->im[w->j];w->im[w->j]=t;}
            if(++w->cursor==CQ_FFT_N){w->len=2;w->group=w->j=0;w->stage=5;}
        }else if(w->stage==5){
            uint32_t a=w->group+w->j,d=a+w->len/2,phase=w->j*CQ_FFT_N/w->len;
            int32_t co=cq_sine(phase+512u),si=-cq_sine(phase);
            int32_t tr=(int32_t)(((int64_t)w->re[d]*co-(int64_t)w->im[d]*si)/32768);
            int32_t ti=(int32_t)(((int64_t)w->re[d]*si+(int64_t)w->im[d]*co)/32768);
            int32_t ar=w->re[a],ai=w->im[a];
            w->re[a]=(ar+tr)/2;w->im[a]=(ai+ti)/2;w->re[d]=(ar-tr)/2;w->im[d]=(ai-ti)/2;
            if(++w->j==w->len/2){w->j=0;w->group+=w->len;
                if(w->group==CQ_FFT_N){w->group=0;w->len*=2;
                    if(w->len>CQ_FFT_N){w->cursor=0;w->stage=6;}
                }
            }
        }else if(w->stage==6){
            uint32_t k=w->cursor;w->psd[k]+=(uint64_t)((int64_t)w->re[k]*w->re[k])+(uint64_t)((int64_t)w->im[k]*w->im[k]);
            if(++w->cursor==CQ_FFT_N/2+1){w->cursor=0;
                if(!w->segment){w->segment=1;w->stage=3;}
                else {w->scan=20;w->stage=7;}
            }
        }else break;
    }
    if(w->stage==7){
        /* Skip excluded centers without spending a service call on each Hz. */
        while(w->scan<=215){
            uint32_t f=w->scan++,d50=f%50u,d60=f%60u;double band,base,r;
            if(d50>25)d50=50-d50;
            if(d60>30)d60=60-d60;
            if(d50>=17 && d60>=17 && w->nnull<64 && cq_pli_stat(w->psd,f,&band,&base,&r)) {
                w->nulls[w->nnull++]=r;break;
            }
        }
        if(w->scan>215){
            uint32_t i;double med=cq_median(w->nulls,w->nnull);
            for(i=0;i<w->nnull;i++){double v=w->nulls[i]-med;w->nulls[i]=v<0?-v:v;}
            w->threshold=w->nnull>=10?med+6*1.4826*cq_median(w->nulls,w->nnull):1e9;
            w->stage=8;
        }
    }else if(w->stage==8){
        channel_quality_t *q=&channel_quality[w->ch];cq_score_t s;
        double total=0,pli=0;uint32_t i;
        for(i=1;i<=CQ_FFT_N/2;i++)total+=(double)w->psd[i];
        for(i=50;i<=200;i+=50){double band,base,r;
            if(cq_pli_stat(w->psd,i,&band,&base,&r) && r>w->threshold && band>base)pli+=band-base;
        }
        q->line10=total>0?(uint32_t)(pli/total*1000):0;if(q->line10>1000)q->line10=1000;
        q->rms=p->rms;q->cf10=p->cf10;q->clipped=p->clipped;q->rail10=p->rail10;q->window_peak=p->peak;
        q->snr10=w->snr10;q->low10=w->low10;q->noise10=w->noise10;
        q->artifact10=w->artifacts*1000u/CQ_N;q->kurtosis10=w->kurtosis10;
        s=cq_assess_score(1,q->rms,q->snr10,q->line10,q->low10,q->artifact10,q->kurtosis10,q->cf10,q->noise10,q->clipped);
        q->distribution_score=s.distribution;q->mains_score=s.mains;q->motion_score=s.motion;q->contact_score=s.contact;
        q->total_score=s.total;q->grade=s.grade;q->grade_cap=s.cap;q->score_t=p->stamp;q->valid=1;q->windows++;
        if(cq_check_state){cq_check_done|=1u<<w->ch;cq_check_valid|=1u<<w->ch;}
        p->ready=0;w->stage=0;w->ch=(w->ch+1u)%8u;cq_jobs_completed++;return 1;
    }
    return 0;
}
/* One press: pre-press frozen windows and partial captures are discarded so
 * every channel restarts its window from the press; an in-flight worker job
 * is aborted, not finished. Second press while running is rejected. */
static uint32_t cq_work_pending(void)
{
    uint32_t b;
    for(b=0u;b<CQ_CHANNELS;b++)if(cq_pending[b].ready)return 1u;
    return cq_worker.stage!=0u;
}
static uint32_t cq_request_check(uint32_t now)
{
    uint32_t ch;
    if(cq_check_state)return 0u;
    for(ch=0u;ch<CQ_CHANNELS;ch++) {
        channel_quality_t *q=&channel_quality[ch];
        cq_pending[ch].ready=0u;
        q->valid=0u;
        cq_clear_window(q);
    }
    cq_worker.stage=0u;
    cq_check_done=0u;cq_check_nodata=0u;cq_check_valid=0u;cq_check_t0=now;cq_check_state=1u;
    return 1u;
}
/* Returns 1 when the visible result set changed (progress or commit). A
 * channel with neither a live stream nor a frozen check window resolves as
 * no-data immediately; live-but-slow checks are bounded by the timeout. */
static uint32_t cq_check_tick(uint32_t now)
{
    uint32_t ch,changed=0u;
    if(!cq_check_state)return 0u;
    for(ch=0u;ch<CQ_CHANNELS;ch++) {
        channel_quality_t *q=&channel_quality[ch];
        if(!(cq_check_done&(1u<<ch)) && !cq_pending[ch].ready &&
           (!q->seen || now-q->last_t>CQ_STALE_TICKS)) {
            cq_check_done|=1u<<ch;cq_check_nodata|=1u<<ch;changed=1u;
        }
    }
    if(cq_check_done!=(1u<<CQ_CHANNELS)-1u &&
       now-cq_check_t0<=CQ_CHECK_TIMEOUT_TICKS)return changed;
    for(ch=0u;ch<CQ_CHANNELS;ch++)
        cq_result_ok[ch]=(uint8_t)(((cq_check_done>>ch)&1u) &&
            !((cq_check_nodata>>ch)&1u) && ((cq_check_valid>>ch)&1u));
    cq_check_state=0u;cq_check_count++;cq_result_t=now;
    return 1u;
}
#endif
