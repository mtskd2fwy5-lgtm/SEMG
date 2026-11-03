#ifndef EMG_SELFCAL_H
#define EMG_SELFCAL_H

/* Small software mirror of the PL INT8 MLP. The PL inference engine remains
 * the default path; this mirror allows the PS to score a few ring rotations
 * during a labeled fitting/validation pass without changing PL weights. */
#define SELFCAL_RING_N 6u
#define SELFCAL_CLASS_N 5u
#define SELFCAL_RING_CH0 3u,0u,1u,2u,4u,5u /* CH4,1,2,3,5,6 */
#define SELFCAL_CANDIDATES 6u

static const u32 selfcal_nn_mem[2048] = {
#include "selfcal_nn_mem.inc"
};

static i32 selfcal_i8(u32 word,u32 byte)
{
    u32 v=(word>>(byte*8u))&255u;
    return v&128u?(i32)v-256:(i32)v;
}

static i32 selfcal_clip_relu(int64_t v,u32 m,u32 n)
{
    int64_t h=n?((int64_t)1<<(n-1u)):0;
    int64_t q=n?(v*(int64_t)m+h)>>n:v*(int64_t)m;
    if(q<0)return 0;
    if(q>127)return 127;
    return (i32)q;
}

/* Input order is feature-major, channel-minor, matching the PL packet
 * contract. Positive shift rotates the ordered six-channel forearm ring;
 * the two near-elbow channels (CH7/CH8) remain fixed. */
static void selfcal_nn_logits(const u32 in[40],u32 shift,i32 out[5])
{
    static const u8 ring[6]={SELFCAL_RING_CH0};
    i32 x[40],h1[64],h2[32];
    u32 f,ch,j,k,a,base,word; int64_t acc,prod; i32 src;
    shift%=SELFCAL_CANDIDATES;
    for(f=0;f<5u;f++)for(ch=0;ch<8u;ch++) {
        src=(i32)ch;
        for(j=0;j<6u;j++)if(ring[j]==ch) {
            src=(i32)ring[(j+shift)%6u];break;
        }
        a=f*8u+ch;
        prod=(int64_t)in[f*8u+(u32)src]*selfcal_nn_mem[a];
        {u32 n=selfcal_nn_mem[40u+a];
         if(n)prod+=((int64_t)1<<(n-1u));
         prod=n?prod>>n:prod;}
        if(prod<0)prod=0;
        if(prod>127)prod=127;
        x[a]=(i32)prod;
    }
    for(j=0;j<64u;j++) {
        acc=(i32)selfcal_nn_mem[0x2d0u+j];base=0x50u+j*10u;
        for(k=0;k<40u;k++) {
            word=selfcal_nn_mem[base+k/4u];
            acc+=(int64_t)selfcal_i8(word,k%4u)*x[k];
        }
        h1[j]=selfcal_clip_relu(acc,selfcal_nn_mem[0x310u],selfcal_nn_mem[0x311u]);
    }
    for(j=0;j<32u;j++) {
        acc=(i32)selfcal_nn_mem[0x512u+j];base=0x312u+j*16u;
        for(k=0;k<64u;k++) {
            word=selfcal_nn_mem[base+k/4u];
            acc+=(int64_t)selfcal_i8(word,k%4u)*h1[k];
        }
        h2[j]=selfcal_clip_relu(acc,selfcal_nn_mem[0x532u],selfcal_nn_mem[0x533u]);
    }
    for(j=0;j<5u;j++) {
        acc=(i32)selfcal_nn_mem[0x55cu+j];base=0x534u+j*8u;
        for(k=0;k<32u;k++) {
            word=selfcal_nn_mem[base+k/4u];
            acc+=(int64_t)selfcal_i8(word,k%4u)*h2[k];
        }
        out[j]=(i32)acc;
    }
}

typedef struct {
    u32 state;                 /* 0 idle, 1 fit, 2 validation, 3 complete */
    u32 target;                /* user-confirmed action label 0..4 */
    u32 armed, windows;
    u32 fit_n[5], val_n[5];
    u32 fit_ok[6][5], val_ok[6][5];
    u32 chosen_shift, applied_shift, accepted;
    i32 latest_logits[5];
    u32 latest_valid;
} selfcal_state_t;

static void selfcal_reset(selfcal_state_t *s)
{
    u32 i,j;
    s->state=0u;s->target=0u;s->armed=0u;s->windows=0u;
    s->chosen_shift=0u;s->applied_shift=0u;s->accepted=0u;
    s->latest_valid=0u;
    for(i=0;i<5u;i++) {
        s->fit_n[i]=s->val_n[i]=0u;
        for(j=0;j<6u;j++)s->fit_ok[j][i]=s->val_ok[j][i]=0u;
    }
}

static void selfcal_begin(selfcal_state_t *s)
{
    selfcal_reset(s);s->state=1u;
}

static u32 selfcal_arm(selfcal_state_t *s,u32 target)
{
    if((s->state!=1u && s->state!=2u) || target>=5u || s->armed)return 0u;
    if((s->state==1u && s->fit_n[target]>=40u) ||
       (s->state==2u && s->val_n[target]>=40u))return 0u;
    s->target=target;s->windows=0u;s->armed=1u;return 1u;
}

/* Consume one completed 40-feature window. Each stage requires 40 consecutive
 * windows for the selected labeled action; the independent validation pass
 * is always used before enabling a non-zero ring shift. */
static u32 selfcal_window(selfcal_state_t *s,const u32 features[40])
{
    u32 shift,k,best; i32 logits[5],top;
    if(s->state==3u) {
        selfcal_nn_logits(features,s->applied_shift,s->latest_logits);
        s->latest_valid=1u;return 0u;
    }
    if(!s->armed || (s->state!=1u && s->state!=2u))return 0u;
    for(shift=0u;shift<6u;shift++) {
        selfcal_nn_logits(features,shift,logits);best=0u;top=logits[0];
        for(k=1u;k<5u;k++)if(logits[k]>top){top=logits[k];best=k;}
        if(s->state==1u) {if(best==s->target)s->fit_ok[shift][s->target]++;}
        else if(best==s->target)s->val_ok[shift][s->target]++;
    }
    if(s->state==1u)s->fit_n[s->target]++;else s->val_n[s->target]++;
    if(++s->windows<40u)return 0u;
    s->armed=0u;s->windows=0u;
    if(s->state==1u) {
        for(k=0u;k<5u;k++)if(s->fit_n[k]<40u)return 0u;
        /* Maximize balanced per-action hit rate; ties prefer no remapping. */
        best=0u;
        for(shift=1u;shift<6u;shift++) {
            u32 lhs=0u,rhs=0u;
            for(k=0u;k<5u;k++) {
                lhs+=s->fit_ok[shift][k];
                rhs+=s->fit_ok[best][k];
            }
            if(lhs>rhs)best=shift;
        }
        s->chosen_shift=best;s->state=2u;return 1u;
    }
    for(k=0u;k<5u;k++)if(s->val_n[k]<40u)return 0u;
    {
        u32 selected=0u,baseline=0u,total=0u;
        for(k=0u;k<5u;k++) {
            baseline+=s->val_ok[0][k];
            selected+=s->val_ok[s->chosen_shift][k];
            total+=s->val_n[k];
        }
        /* Require >=3 percentage-point held-out gain and retain the unmodified
         * model if adaptation does not generalize to the validation pass. */
        s->accepted=(s->chosen_shift!=0u && total && selected*100u>=baseline*100u+3u*total);
        s->applied_shift=s->accepted?s->chosen_shift:0u;
    }
    s->state=3u;return 2u;
}

#endif

