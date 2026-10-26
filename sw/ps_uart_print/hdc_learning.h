/* PS workflow + DDR storage; ARM production uses PL arithmetic exclusively.
 * User-confirmed labels, no model mutation during validation.
 * Gesture storage grows in DDR; no fixed custom-slot count.
 */
#ifndef HDC_LEARNING_H
#define HDC_LEARNING_H
#include <stdint.h>
#include <string.h>
#include "pl_learning_api.h"
#if !PL_LEARNING_ENABLE
#include "hdc_memory.h"
#endif
#define HDC_D 2048u
#define HDC_WORDS 64u
#define HDC_STORAGE_BYTES (32u*1024u*1024u)
#if !defined(__arm__)
#include <stdlib.h>
#endif
#define HDC_TRIAL_WINDOWS 40u
#define HDC_GUARD_WINDOWS 40u
#define HDC_FIT_TRIALS 3u
#define HDC_VAL_TRIALS 2u
#define HDC_FIT_WINDOWS (HDC_TRIAL_WINDOWS*HDC_FIT_TRIALS)
#define HDC_VAL_WINDOWS (HDC_TRIAL_WINDOWS*HDC_VAL_TRIALS)
enum { HDC_IDLE,HDC_FIT,HDC_BUILD,HDC_VALIDATE,HDC_DONE };
typedef struct {
    uint32_t stage,classes,armed,target,guard,n,build_index;
    uint32_t *fit_n,*val_n,scale[8];
    uint32_t (*fit)[HDC_FIT_WINDOWS][8],trial[40][8];
    int16_t (*proto)[HDC_D];
    uint32_t **hdc_cm,**centroid_cm,mlp_cm[5][5];
    uint32_t trial_hdc[40],trial_centroid[40],trial_mlp[40],trial_margin[40];
    uint32_t trial_clip[40],margin_sum,clip_values,validation_values;
    uint32_t latest,latest_mlp,latest_centroid,margin,latest_valid,clip;
    uint32_t last_ms,seq_seen,interruptions,saturated,completed_ms;
    uint16_t last_seq;
    uint64_t (*centroid_sum)[8];
    uint32_t (*hand_pose)[6],*hand_mapped;
    int32_t (*virtual_pose)[22];
    uint32_t *virtual_mapped;
    uint32_t capacity,storage_bytes,storage_bank,storage_error;
    void *storage;
    uint32_t accelerator_error;
} hdc_learning_t;

/* Two linker-reserved banks permit transactional growth: failed allocation
 * leaves the old library intact. Host tests allocate the same byte layout. */
static uint64_t hdc_storage_size(uint32_t cap)
{
    if(cap>HDC_STORAGE_BYTES/(HDC_FIT_WINDOWS*32u+HDC_D*2u))return UINT64_MAX;
    return 128u+(uint64_t)cap*(4u*sizeof(uint32_t)+2u*sizeof(void*)+
        HDC_FIT_WINDOWS*8u*sizeof(uint32_t)+HDC_D*sizeof(int16_t)+
        8u*sizeof(uint64_t)+6u*sizeof(uint32_t)+22u*sizeof(int32_t))+(uint64_t)cap*cap*8u;
}
static uint32_t hdc_reserve(hdc_learning_t *s,uint32_t needed)
{
    uint32_t cap=s->capacity?s->capacity:8u,c;
    uint64_t bytes;
    unsigned char *base,*p;
    hdc_learning_t next=*s;
    if(needed<=s->capacity){s->storage_error=0u;return 1u;}
    while(cap<needed && cap<UINT32_MAX/2u)cap*=2u;
    bytes=hdc_storage_size(cap);
    if(cap<needed || bytes>HDC_STORAGE_BYTES) {
        cap=needed;bytes=hdc_storage_size(cap);
    }
    if(bytes>HDC_STORAGE_BYTES){s->storage_error=1u;return 0u;}
#if defined(__arm__)
    {extern unsigned char __hdc_bank0[],__hdc_bank1[];
     base=s->storage_bank?__hdc_bank0:__hdc_bank1;}
#else
    base=(unsigned char *)malloc((size_t)bytes);
    if(!base){s->storage_error=1u;return 0u;}
#endif
    memset(base,0,(size_t)bytes);p=base;
#define HDC_ALLOC(field,type,count) do { \
    p=(unsigned char *)(((uintptr_t)p+7u)&~(uintptr_t)7u); \
    next.field=(type)p;p+=(size_t)(count)*sizeof(*next.field); \
} while(0)
    HDC_ALLOC(fit_n,uint32_t *,cap);HDC_ALLOC(val_n,uint32_t *,cap);
    HDC_ALLOC(hand_mapped,uint32_t *,cap);
    HDC_ALLOC(virtual_mapped,uint32_t *,cap);
    HDC_ALLOC(virtual_pose,int32_t (*)[22],cap);
    HDC_ALLOC(fit,uint32_t (*)[HDC_FIT_WINDOWS][8],cap);
    HDC_ALLOC(proto,int16_t (*)[HDC_D],cap);
    HDC_ALLOC(centroid_sum,uint64_t (*)[8],cap);
    HDC_ALLOC(hand_pose,uint32_t (*)[6],cap);
    HDC_ALLOC(hdc_cm,uint32_t **,cap);HDC_ALLOC(centroid_cm,uint32_t **,cap);
    for(c=0;c<cap;c++) {
        next.hdc_cm[c]=(uint32_t *)p;p+=(size_t)cap*4u;
        next.centroid_cm[c]=(uint32_t *)p;p+=(size_t)cap*4u;
    }
#undef HDC_ALLOC
    for(c=0;c<s->classes;c++) {
        next.fit_n[c]=s->fit_n[c];next.val_n[c]=s->val_n[c];
        next.hand_mapped[c]=s->hand_mapped[c];
        next.virtual_mapped[c]=s->virtual_mapped[c];
        memcpy(next.virtual_pose[c],s->virtual_pose[c],sizeof next.virtual_pose[c]);
        memcpy(next.fit[c],s->fit[c],sizeof next.fit[c]);
        memcpy(next.proto[c],s->proto[c],sizeof next.proto[c]);
        memcpy(next.centroid_sum[c],s->centroid_sum[c],sizeof next.centroid_sum[c]);
        memcpy(next.hand_pose[c],s->hand_pose[c],sizeof next.hand_pose[c]);
        memcpy(next.hdc_cm[c],s->hdc_cm[c],s->classes*4u);
        memcpy(next.centroid_cm[c],s->centroid_cm[c],s->classes*4u);
    }
#if !defined(__arm__)
    free(s->storage);
#endif
    next.capacity=cap;next.storage=base;next.storage_bytes=(uint32_t)bytes;
    next.storage_bank=s->storage_bank^1u;next.storage_error=0u;*s=next;
    return 1u;
}
static uint32_t hdc_begin(hdc_learning_t *s,uint32_t custom)
{
    hdc_learning_t next={0};uint32_t n=custom+5u;
    next.storage_bank=s->storage_bank;
    if(custom>UINT32_MAX-5u || !hdc_reserve(&next,n)){s->storage_error=1u;return 0u;}
#if !defined(__arm__)
    free(s->storage);
#endif
    *s=next;s->classes=n;s->stage=HDC_FIT;return 1u;
}
static void hdc_clear_validation(hdc_learning_t *s);
static uint32_t hdc_append(hdc_learning_t *s)
{
    uint32_t c;
    if(s->armed || (s->stage!=HDC_FIT && s->stage!=HDC_DONE) || s->classes==UINT32_MAX)return 0u;
    if(!hdc_reserve(s,s->classes+1u))return 0u;
    c=s->classes++;
    memset(s->fit[c],0,sizeof s->fit[c]);memset(s->proto[c],0,sizeof s->proto[c]);
    memset(s->hand_pose[c],0,sizeof s->hand_pose[c]);s->hand_mapped[c]=0u;
    memset(s->virtual_pose[c],0,sizeof s->virtual_pose[c]);s->virtual_mapped[c]=0u;
    s->fit_n[c]=s->val_n[c]=0u;s->stage=HDC_FIT;s->latest_valid=0u;
    hdc_clear_validation(s);
    return 1u;
}
static void hdc_clear_validation(hdc_learning_t *s)
{
    uint32_t c;
    for(c=0;c<s->classes;c++) {
        s->val_n[c]=0u;memset(s->hdc_cm[c],0,s->classes*4u);
        memset(s->centroid_cm[c],0,s->classes*4u);
    }
    memset(s->mlp_cm,0,sizeof s->mlp_cm);
    s->margin_sum=s->clip_values=s->validation_values=s->completed_ms=0u;
}

static void hdc_interrupt(hdc_learning_t *s)
{
    if(s->armed) s->interruptions++;
    s->armed=0u;s->n=s->guard=0u;s->latest_valid=0u;
}

/* Re-wear evaluation can reuse a frozen model while starting fresh scores. */
static uint32_t hdc_validate_again(hdc_learning_t *s)
{
    if(s->stage!=HDC_DONE)return 0u;
    hdc_interrupt(s);hdc_clear_validation(s);
    s->stage=HDC_VALIDATE;return 1u;
}

static uint32_t hdc_arm(hdc_learning_t *s,uint32_t cls)
{
    uint32_t limit;
    if(s->armed || cls>=s->classes ||
       (s->stage!=HDC_FIT && s->stage!=HDC_VALIDATE))return 0u;
    limit=s->stage==HDC_FIT?s->fit_n[cls]:s->val_n[cls];
    if(limit>=(s->stage==HDC_FIT?HDC_FIT_WINDOWS:HDC_VAL_WINDOWS))return 0u;
    s->target=cls;s->n=0u;s->guard=HDC_GUARD_WINDOWS;s->armed=1u;s->seq_seen=0u;
    return 1u;
}

#if !PL_LEARNING_ENABLE
static void hdc_encode(const uint32_t e[8],const uint32_t scale[8],
                       uint32_t query[64],uint32_t *clipped)
{
    uint32_t ch,w,level[8],clips=0u;
    for(ch=0u;ch<8u;ch++) {
        uint32_t den=scale[ch]?scale[ch]:1u;
        uint64_t q=((uint64_t)e[ch]*15u+den/2u)/den;
        if(e[ch]>scale[ch])clips++;
        level[ch]=q>15u?15u:(uint32_t)q;
    }
    for(w=0u;w<64u;w++) {
        uint32_t b0=0u,b1=0u,b2=0u,b3=0u;
        for(ch=0u;ch<8u;ch++) {
            uint32_t v=~(hdc_cim[ch][w]^hdc_vim[level[ch]][w]);
            uint32_t carry=b0&v; b0^=v;
            v=carry;carry=b1&v;b1^=v;
            v=carry;carry=b2&v;b2^=v;b3^=carry;
        }
        query[w]=b2|b3; /* >=4 positive votes; an exact tie is positive. */
    }
    if(clipped)*clipped=clips;
}

static void hdc_add(hdc_learning_t *s,uint32_t cls,const uint32_t q[64])
{
    uint32_t d;
    for(d=0u;d<HDC_D;d++) {
        int32_t v=(int32_t)s->proto[cls][d]+((q[d/32u]>>(d%32u))&1u?1:-1);
        if(v>32767){v=32767;s->saturated++;}
        if(v< -32768){v=-32768;s->saturated++;}
        s->proto[cls][d]=(int16_t)v;
    }
}

static uint32_t hdc_predict(const hdc_learning_t *s,const uint32_t q[64],uint32_t *margin)
{
    uint32_t c,d,best=0u;
    int32_t top=INT32_MIN,second=INT32_MIN;
    for(c=0u;c<s->classes;c++) {
        int32_t sim=0;
        for(d=0u;d<HDC_D;d++)sim+=((q[d/32u]>>(d%32u))&1u)?s->proto[c][d]:-s->proto[c][d];
        if(sim>top){second=top;top=sim;best=c;}else if(sim>second)second=sim;
    }
    /* Percent of maximum possible score difference; NOT a probability. */
    if(margin)*margin=(uint32_t)(((int64_t)top-second)*100/(2u*HDC_FIT_WINDOWS*HDC_D));
    return best;
}

#endif /* software golden encoder / prototype arithmetic */
static uint32_t hdc_centroid_predict(const hdc_learning_t *s,const uint32_t e[8])
{
    uint32_t c,ch,best=0u;
    uint64_t best_dist=UINT64_MAX;
    for(c=0;c<s->classes;c++) {
        uint64_t distance=0u;
        for(ch=0;ch<8;ch++) {
            uint32_t den=s->scale[ch]?s->scale[ch]:1u;
            uint64_t value=(uint64_t)e[ch]*1024u/den;
            int64_t diff;
            /* Bound only the diagnostic centroid distance for bad inputs. */
            if(value>65535u)value=65535u;
            diff=(int64_t)value-(int64_t)(s->centroid_sum[c][ch]/HDC_FIT_WINDOWS);
            distance+=(uint64_t)(diff*diff);
        }
        if(distance<best_dist){best_dist=distance;best=c;}
    }
    return best;
}

/* One buffered training query per service call, never one long fit loop. */
static uint32_t hdc_build_step(hdc_learning_t *s)
{
    uint32_t c,n,ch;
#if !PL_LEARNING_ENABLE
    uint32_t q[64];
#endif
    if(s->stage!=HDC_BUILD)return 0u;
    c=s->build_index/HDC_FIT_WINDOWS;n=s->build_index%HDC_FIT_WINDOWS;
#if PL_LEARNING_ENABLE
    if(!pl_learning_train(s->fit[c][n],s->scale,s->proto[c],&s->saturated)) {
        s->accelerator_error=1u;s->stage=HDC_IDLE;hdc_interrupt(s);return 0u;
    }
#else
    hdc_encode(s->fit[c][n],s->scale,q,0);hdc_add(s,c,q);
#endif
    for(ch=0;ch<8;ch++)s->centroid_sum[c][ch]+=
        (uint64_t)s->fit[c][n][ch]*1024u/(s->scale[ch]?s->scale[ch]:1u);
    if(++s->build_index==s->classes*HDC_FIT_WINDOWS)s->stage=HDC_VALIDATE;
    return 1u;
}

/* Caller must supply USER-confirmed target via arm; mlp is a same-window
 * reference prediction, never a training label. window seq steps by 40. */
static void hdc_window(hdc_learning_t *s,const uint32_t e[8],uint16_t seq,
                       uint32_t ms,uint32_t mlp)
{
    uint32_t c,ch,k,all=1u;
#if !PL_LEARNING_ENABLE
    uint32_t q[64];
#endif
    if(s->stage==HDC_IDLE)return;
    if(s->seq_seen && ((uint16_t)(seq-s->last_seq)!=40u || ms-s->last_ms>250u))
        hdc_interrupt(s);
    s->last_seq=seq;s->last_ms=ms;s->seq_seen=1u;
    if(s->stage>=HDC_VALIDATE) {
#if PL_LEARNING_ENABLE
        if(!pl_learning_predict(e,s->scale,&s->proto[0][0],s->classes,&s->latest,&s->margin,&s->clip)) {
            s->accelerator_error=1u;s->stage=HDC_IDLE;hdc_interrupt(s);return;
        }
#else
        hdc_encode(e,s->scale,q,&s->clip);
        s->latest=hdc_predict(s,q,&s->margin);
#endif
        s->latest_centroid=hdc_centroid_predict(s,e);
        s->latest_mlp=mlp;s->latest_valid=1u;
    }
    if(!s->armed)return;
    if(s->guard){s->guard--;return;}
    k=s->n;c=s->target;
    if(s->stage==HDC_FIT)for(ch=0;ch<8;ch++)s->trial[k][ch]=e[ch];
    else if(s->stage==HDC_VALIDATE) {
        s->trial_hdc[k]=s->latest;s->trial_centroid[k]=s->latest_centroid;
        s->trial_mlp[k]=mlp;s->trial_margin[k]=s->margin;s->trial_clip[k]=s->clip;
    } else return;
    if(++s->n<HDC_TRIAL_WINDOWS)return;
    if(s->stage==HDC_FIT) {
        for(k=0;k<40;k++)for(ch=0;ch<8;ch++) {
            uint32_t v=s->trial[k][ch];
            s->fit[c][s->fit_n[c]+k][ch]=v;
#if !PL_LEARNING_ENABLE
            if(v>s->scale[ch])s->scale[ch]=v;
#endif
        }
#if PL_LEARNING_ENABLE
        if(!pl_learning_scale(&s->trial[0][0],HDC_TRIAL_WINDOWS,s->scale)) {
            s->accelerator_error=1u;s->stage=HDC_IDLE;hdc_interrupt(s);return;
        }
#endif
        s->fit_n[c]+=40u;
        for(c=0;c<s->classes;c++)if(s->fit_n[c]<HDC_FIT_WINDOWS)all=0u;
        if(all) {
            s->build_index=0u;hdc_clear_validation(s);
            for(c=0;c<s->classes;c++) {
                memset(s->proto[c],0,sizeof s->proto[c]);
                memset(s->centroid_sum[c],0,sizeof s->centroid_sum[c]);
            }
            s->stage=HDC_BUILD;
        }
    } else {
        for(k=0;k<40;k++) {
            s->hdc_cm[c][s->trial_hdc[k]]++;
            s->centroid_cm[c][s->trial_centroid[k]]++;
            if(c<5u && s->trial_mlp[k]<5u)s->mlp_cm[c][s->trial_mlp[k]]++;
            s->margin_sum+=s->trial_margin[k];s->clip_values+=s->trial_clip[k];
        }
        s->validation_values+=40u*8u;s->val_n[c]+=40u;
        for(c=0;c<s->classes;c++)if(s->val_n[c]<HDC_VAL_WINDOWS)all=0u;
        if(all){s->stage=HDC_DONE;s->completed_ms=ms;}
    }
    s->armed=0u;s->n=s->guard=0u;
}

static uint32_t hdc_accuracy(uint32_t *const *cm,uint32_t classes)
{
    uint32_t i,j,ok=0u,n=0u;
    for(i=0;i<classes;i++)for(j=0;j<classes;j++){n+=cm[i][j];if(i==j)ok+=cm[i][j];}
    return n?ok*100u/n:0u;
}
#endif
