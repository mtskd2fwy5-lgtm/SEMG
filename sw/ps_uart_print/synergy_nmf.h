#ifndef EMG_SYNERGY_NMF_H
#define EMG_SYNERGY_NMF_H

/* Fixed three-component NMF basis fitted on EMG008/009 processed MAV
 * windows. Q15, one unit-L2 column per synergy. These coefficients are
 * relative activation coordinates, not muscle force or calibrated effort. */
#define SYNERGY_N 3u
#define SYNERGY_Q 15u
#define SYNERGY_C_Q 8u

#include "synergy_nmf_model.h"

typedef struct {
    u32 c[SYNERGY_N];            /* mean-ADC-count coefficients, Q8 */
    u32 percent[SYNERGY_N];
    u32 residual_percent;       /* relative L1 envelope approximation error */
    u32 valid;
} synergy_nmf_state_t;

static void synergy_nmf_reset(synergy_nmf_state_t *s)
{
    u32 j;
    for(j=0u;j<SYNERGY_N;j++) { s->c[j]=1u; s->percent[j]=0u; }
    s->valid=0u;s->residual_percent=0u;
}

/* Eight multiplicative C updates against a fixed W. MAV is a 400-sample
 * sum (saturates at INT32_MAX in PL). Convert to Q8 mean ADC counts.
 * c is bounded to INT32_MAX; all products below fit uint64_t. */
static void synergy_nmf_step(synergy_nmf_state_t *s,const u32 e[8])
{
    u32 i,j,k,it;
    uint64_t wte[SYNERGY_N], gram[SYNERGY_N][SYNERGY_N], den, num;
    u32 next[SYNERGY_N];

    for(j=0u;j<SYNERGY_N;j++) {
        wte[j]=0u;
        for(i=0u;i<8u;i++) {
            u32 input=e[i]>0x7fffffffu?0x7fffffffu:e[i];
            wte[j]+=(uint64_t)synergy_w_q15[i][j]*(((uint64_t)input<<8)/400u);
        }
        wte[j]=(wte[j]+16384u)>>15;
        for(k=0u;k<SYNERGY_N;k++) {
            uint64_t sum=0u;
            for(i=0u;i<8u;i++)
                sum+=(uint64_t)synergy_w_q15[i][j]*synergy_w_q15[i][k];
            gram[j][k]=(sum+(1u<<(SYNERGY_Q-1u)))>>SYNERGY_Q;
        }
    }

    /* Initialize from this window's projection. A warm-started, quantized
     * multiplicative solve can lock a quiet component near zero for seconds,
     * even after its pattern becomes active. No temporal state in the solve. */
    for(j=0u;j<SYNERGY_N;j++)s->c[j]=(u32)(wte[j]/3u);

    for(it=0u;it<8u;it++) {
        for(j=0u;j<SYNERGY_N;j++) {
            den=0u;
            for(k=0u;k<SYNERGY_N;k++) den+=gram[j][k]*(s->c[k]?s->c[k]:1u);
            den=(den+16384u)>>15;
            if(den==0u || wte[j]==0u) { next[j]=0u; continue; }
            /* Positive floor lets an initially silent component recover
             * when its channel pattern appears in a later window. */
            num=((uint64_t)(s->c[j]?s->c[j]:1u)*wte[j]+den/2u)/den;
            next[j]=(u32)(num>0x7fffffffu?0x7fffffffu:num);
        }
        for(j=0u;j<SYNERGY_N;j++)s->c[j]=next[j];
    }

    for(j=0u;j<SYNERGY_N;j++) {
        uint64_t pct=(uint64_t)s->c[j]*100u/synergy_display_ref[j];
        s->percent[j]=(u32)(pct>100u?100u:pct);
    }
    {
        uint64_t total=0u,error=0u;
        for(i=0u;i<8u;i++) {
            uint64_t rec=0u;
            u32 input=(e[i]>0x7fffffffu?0x7fffffffu:e[i])/400u;
            for(j=0u;j<SYNERGY_N;j++)rec+=(uint64_t)synergy_w_q15[i][j]*s->c[j];
            rec=(rec+(1u<<22))>>23; /* W Q15 * C Q8 -> ADC counts */
            error+=rec>input?rec-input:input-rec;
            total+=input;
        }
        s->residual_percent=total?(u32)(error*100u/total):0u;
    }
    s->valid=1u;
}

#endif
