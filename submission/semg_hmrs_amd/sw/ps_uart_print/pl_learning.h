#ifndef PL_LEARNING_H
#define PL_LEARNING_H
#if PL_LEARNING_ENABLE
/* GPIO6 and scratch DDR exist only in matching V12+ hardware/link layout.
 * HDC reserve and scratch are normal noncacheable in display_memory.S.
 * PS owns descriptors/labels. DDR ownership transfers with a full barrier.
 * No ARM query encoding, prototype arithmetic or NMF solve runs here. */
#define LEARN_COMMAND MMIO32(0x41260000u)
#define LEARN_STATUS  MMIO32(0x41260008u)
extern unsigned char __learning_scratch[];
static uint32_t pl_learning_toggle,pl_learning_offline,pl_learning_initialized;
static uint32_t pl_learning_jobs,pl_learning_failures,pl_learning_max_ticks,pl_learning_status;
static void pl_learning_barrier(void){__asm__ volatile("dsb sy" ::: "memory");}
static uint32_t pl_learning_send(uint32_t op,uint32_t value)
{
    uint32_t start=gt_stamp(),w;
    pl_learning_toggle^=1u;
    LEARN_COMMAND=(pl_learning_toggle<<31)|(op<<24)|(value&0xffffffu);
    do {
        w=LEARN_STATUS;
        if((w>>31)==pl_learning_toggle)return 1u;
    } while(gt_stamp()-start<2u*GT_TICKS_PER_MS);
    pl_learning_offline=1u;return 0u;
}
static uint32_t pl_learning_job(uint32_t job,const uint32_t args[5])
{
    uint32_t i,start,dt,w;
    if(pl_learning_offline)return 0u;
    w=LEARN_STATUS;pl_learning_status=w;
    if(((w>>16)&255u)!=0x13u || (w&0x50000000u)) {
        pl_learning_offline=1u;pl_learning_failures++;return 0u;
    }
    if(!pl_learning_initialized){pl_learning_toggle=LEARN_COMMAND>>31;pl_learning_initialized=1u;}
    pl_learning_barrier();start=gt_stamp();
    for(i=0;i<5;i++)
        if(!pl_learning_send(1,args[i]&65535u) || !pl_learning_send(2,args[i]>>16) ||
           !pl_learning_send(3,i)){pl_learning_failures++;return 0u;}
    if(!pl_learning_send(4,job)){pl_learning_failures++;return 0u;}
    do {
        w=LEARN_STATUS;
        if(!(w&(1u<<30)))break;
        if(gt_stamp()-start>110u*GT_TICKS_PER_MS){pl_learning_offline=1u;break;}
    }while(1);
    pl_learning_barrier();pl_learning_status=w;dt=gt_stamp()-start;
    if(dt>pl_learning_max_ticks)pl_learning_max_ticks=dt;
    if(pl_learning_offline || (w&0x30000000u)) {pl_learning_failures++;return 0u;}
    // A growing library must still fit the 25 ms feature cadence. Reject
    // an over-budget prediction rather than building a stale control queue.
    if((job==4u || job==6u) && dt>20u*GT_TICKS_PER_MS){pl_learning_failures++;return 0u;}
    pl_learning_jobs++;return 1u;
}
static uint32_t pl_learning_run(uint32_t job,const uint32_t *e,const uint32_t *scale,
                                int16_t *proto,uint32_t count,uint32_t out[8])
{
    volatile uint32_t *scratch=(volatile uint32_t *)__learning_scratch;
    uint32_t args[5],i;
    for(i=0;i<8;i++) {scratch[i]=e[i];scratch[16+i]=scale?scale[i]:0u;scratch[32+i]=0u;}
    args[0]=(uint32_t)(uintptr_t)__learning_scratch;
    args[1]=args[0]+64u;args[2]=(uint32_t)(uintptr_t)proto;
    args[3]=args[0]+128u;args[4]=count;
    if(!pl_learning_job(job,args))return 0u;
    for(i=0;i<8;i++)out[i]=scratch[32+i];
    return 1u;
}
static uint32_t pl_learning_nmf(const uint32_t e[8],uint32_t out[8])
{return pl_learning_run(1u,e,0,0,0,out);}
static uint32_t pl_learning_scale(const uint32_t *samples,uint32_t n,uint32_t scale[8])
{
    volatile uint32_t *scratch=(volatile uint32_t *)__learning_scratch;
    uint32_t args[5],i;
    // A committed trial is 40x8 words; bounce it into noncacheable scratch.
    if(n>40u)return 0u;
    for(i=0;i<n*8u;i++)scratch[128+i]=samples[i];
    for(i=0;i<8;i++)scratch[16+i]=scale[i];
    args[0]=(uint32_t)(uintptr_t)__learning_scratch+512u;
    args[1]=(uint32_t)(uintptr_t)__learning_scratch+64u;args[2]=0u;
    args[3]=(uint32_t)(uintptr_t)__learning_scratch+128u;args[4]=n;
    if(!pl_learning_job(2u,args))return 0u;
    for(i=0;i<8;i++)scale[i]=scratch[16+i];
    return 1u;
}
static uint32_t pl_learning_train(const uint32_t e[8],const uint32_t scale[8],int16_t *proto,uint32_t levels,uint32_t *saturated)
{
    uint32_t out[8];
    if((levels!=16u && levels!=32u) || !pl_learning_run(levels==32u?5u:3u,e,scale,proto,1u,out))return 0u;
    *saturated+=out[0];return 1u;
}
static uint32_t pl_learning_predict(const uint32_t e[8],const uint32_t scale[8],const int16_t *proto,
                                    uint32_t classes,uint32_t levels,uint32_t *best,uint32_t *margin,uint32_t *clip,uint32_t *margin_bp)
{
    uint32_t out[8];
    if(!classes || (levels!=16u && levels!=32u) ||
       !pl_learning_run(levels==32u?6u:4u,e,scale,(int16_t *)proto,classes,out))return 0u;
    if(out[0]>=classes || out[2]>8u || out[3]>20000u || out[1]!=out[3]/100u)return 0u;
    *best=out[0];*margin=out[1];*clip=out[2];*margin_bp=out[3];return 1u;
}
#endif
#endif

