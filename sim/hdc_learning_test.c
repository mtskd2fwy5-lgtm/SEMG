/* Actual firmware learner, runnable without MMIO. Binary replay is consumed
 * by test_hdc_learning.py, which independently checks NumPy encoding/scoring. */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "../sw/ps_uart_print/hdc_learning.h"
static hdc_learning_t s;
static uint16_t seq;
static uint32_t ms;
static void window(const uint32_t e[8],uint32_t mlp)
{ seq=(uint16_t)(seq+40u);ms+=25u;hdc_window(&s,e,seq,ms,mlp); }
static void trial(uint32_t c,const uint32_t e[8])
{
    uint32_t k;assert(hdc_arm(&s,c));
    for(k=0;k<80u;k++)window(e,c<5u?c:0u);
    assert(!s.armed);
}
static uint32_t model_hash(void)
{
    uint32_t i,h=2166136261u;const unsigned char *p;
#define HASH_PART(x) p=(const unsigned char *)(x);for(i=0;i<sizeof(x);i++)h=(h^p[i])*16777619u
    HASH_PART(s.scale);
    p=(const unsigned char *)s.proto;for(i=0;i<s.classes*sizeof(*s.proto);i++)h=(h^p[i])*16777619u;
    p=(const unsigned char *)s.centroid_sum;for(i=0;i<s.classes*sizeof(*s.centroid_sum);i++)h=(h^p[i])*16777619u;
#undef HASH_PART
    return h;
}
static void selftest(void)
{
    uint32_t e[8]={0},q[64],clips,c,t,k,before;
    assert(hdc_begin(&s,99u));assert(s.classes==104u);
    {void *old=s.storage;uint32_t cap=s.capacity;
     assert(!hdc_reserve(&s,UINT32_MAX) && s.storage==old && s.capacity==cap && s.classes==104u);}
    assert(hdc_begin(&s,3u));
    assert(!hdc_arm(&s,8u));assert(hdc_arm(&s,0));assert(!hdc_arm(&s,1));
    for(k=0;k<40;k++)window(e,0);assert(s.n==0u && s.guard==0u);
    for(k=0;k<39;k++)window(e,0);assert(!s.fit_n[0] && s.n==39u);
    seq+=40;window(e,0);assert(!s.armed && !s.fit_n[0] && s.interruptions==1u);
    assert(hdc_arm(&s,0));window(e,0);ms+=251;window(e,0);
    assert(!s.armed && s.interruptions==2u);
    assert(hdc_arm(&s,0));window(e,0);hdc_interrupt(&s);
    assert(!s.armed && !s.fit_n[0] && s.interruptions==3u);
    /* Both sequence and millisecond wrap continue an intact trial. */
    seq=65520u;ms=UINT32_MAX-10u;assert(hdc_arm(&s,0));
    window(e,0);window(e,0);assert(s.armed && s.guard==38u);
    hdc_interrupt(&s);
    for(c=0;c<8;c++) {
        memset(e,0,sizeof e);e[c]=10000u;
        for(t=0;t<3;t++)trial(c,e);
        assert(s.fit_n[c]==120u && !hdc_arm(&s,c));
    }
    assert(s.stage==HDC_BUILD);assert(!hdc_arm(&s,0));
    for(k=0;k<960u;k++)assert(hdc_build_step(&s));
    assert(s.stage==HDC_VALIDATE && !hdc_build_step(&s));
    before=model_hash();
    for(c=0;c<8;c++) {
        memset(e,0,sizeof e);e[c]=10000u;
        for(t=0;t<2;t++)trial(c,e);
        assert(s.val_n[c]==80u);
    }
    assert(s.stage==HDC_DONE && s.latest==7u && hdc_accuracy(s.hdc_cm,8)==100u);
    assert(hdc_accuracy(s.centroid_cm,8)==100u && !s.saturated);
    for(c=0;c<5;c++)assert(s.mlp_cm[c][c]==80u);
    for(k=0;k<100;k++){e[k%8]=UINT32_MAX;window(e,0);}
    assert(model_hash()==before && s.validation_values==8u*80u*8u);
    assert(hdc_validate_again(&s) && s.stage==HDC_VALIDATE);
    assert(!s.val_n[7] && !s.hdc_cm[7][7] && !s.validation_values && model_hash()==before);
    assert(!hdc_validate_again(&s));
    for(c=0;c<8;c++)e[c]=UINT32_MAX;
    hdc_encode(e,s.scale,q,&clips);assert(clips==8u);
    for(k=0;k<2048;k++)s.proto[0][k]=32767;
    for(k=0;k<64;k++)q[k]=UINT32_MAX;
    hdc_add(&s,0,q);assert(s.saturated==2048u && s.proto[0][0]==32767);
    for(k=0;k<2048;k++)s.proto[0][k]=-32768;
    memset(q,0,sizeof q);hdc_add(&s,0,q);
    assert(s.saturated==4096u && s.proto[0][0]==-32768);
    hdc_begin(&s,0);assert(s.classes==5 && s.stage==HDC_FIT && !s.fit_n[0]);
    // Append beyond three custom slots without discarding existing trials.
    for(c=0;c<18u;c++)assert(hdc_append(&s));
    assert(s.classes==23u && s.capacity>=23u && !s.storage_error);
    for(c=0;c<s.classes;c++) {
        for(k=0;k<8u;k++)e[k]=1000u+((c>>k)&1u)*9000u;
        for(t=0;t<3;t++)trial(c,e);
    }
    while(hdc_build_step(&s)){}
    assert(s.stage==HDC_VALIDATE);
    for(c=0;c<s.classes;c++) {
        for(k=0;k<8u;k++)e[k]=1000u+((c>>k)&1u)*9000u;
        for(t=0;t<2;t++)trial(c,e);
    }
    assert(s.stage==HDC_DONE && s.latest==22u && hdc_accuracy(s.hdc_cm,s.classes)==100u);
    s.virtual_mapped[22]=1u;s.virtual_pose[22][19]=-97;
    before=model_hash();s.hand_mapped[22]=1u;s.hand_pose[22][1]=1777u;
    assert(hdc_append(&s) && s.classes==24u && !s.hand_mapped[23] && !s.fit_n[23]);
    assert(s.hand_mapped[22] && s.hand_pose[22][1]==1777u && s.fit_n[0]==120u);
    assert(!s.val_n[22] && hdc_accuracy(s.hdc_cm,s.classes)==0u);
    {int16_t prototype=s.proto[22][0];uint32_t sample=s.fit[22][0][0];
     while(s.classes<33u)assert(hdc_append(&s));
     assert(s.capacity>=33u && s.proto[22][0]==prototype && s.fit[22][0][0]==sample);
     assert(s.virtual_mapped[22] && s.virtual_pose[22][19]==-97 && !s.virtual_mapped[32]);
     assert(s.hand_mapped[22] && s.hand_pose[22][1]==1777u);}
    {void *old=s.storage;assert(!hdc_begin(&s,UINT32_MAX));assert(s.storage==old && s.classes==33u);}
    puts("TEST_PASS HDC: dynamic growth beyond 3 custom slots, retained data/mappings, atomic OOM, 23-class held-out prediction, original encoding, immutable live models.");
}
static void replay(const char *input,const char *output)
{
    FILE *f=fopen(input,"rb"),*o;uint32_t classes,ntest,c,t,k,e[8],label,p,cp,m,q[64],h;
    assert(f && fread(&classes,4,1,f)==1 && fread(&ntest,4,1,f)==1);
    assert(classes>=5u);assert(hdc_begin(&s,classes-5u));
    for(c=0;c<classes;c++)for(t=0;t<3u;t++) {
        assert(hdc_arm(&s,c));memset(e,0,sizeof e);
        for(k=0;k<40u;k++)window(e,0u);
        for(k=0;k<40u;k++){assert(fread(e,4,8,f)==8);window(e,0);}
    }
    while(hdc_build_step(&s)){}
    assert(s.stage==HDC_VALIDATE);h=model_hash();
    o=fopen(output,"wb");assert(o);
    assert(fwrite(s.scale,4,8,o)==8);
    assert(fwrite(s.proto,2,classes*2048u,o)==classes*2048u);
    for(k=0;k<ntest;k++) {
        assert(fread(&label,4,1,f)==1 && fread(e,4,8,f)==8);
        hdc_encode(e,s.scale,q,0);p=hdc_predict(&s,q,&m);cp=hdc_centroid_predict(&s,e);
        if(!k)assert(fwrite(q,4,64,o)==64);
        assert(fwrite(&p,4,1,o)==1 && fwrite(&cp,4,1,o)==1 && fwrite(&m,4,1,o)==1);
        window(e,label<5u?label:0u);
    }
    assert(model_hash()==h);assert(fgetc(f)==EOF);fclose(f);fclose(o);
}
int main(int argc,char **argv)
{
    if(argc==3)replay(argv[1],argv[2]);else selftest();
    return 0;
}
