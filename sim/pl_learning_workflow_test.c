/* Exercise the production backend branches. Stub arithmetic is deliberately
 * trivial: exact arithmetic is verified independently by XSim/Python. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#define PL_LEARNING_HOST_TEST 1
typedef unsigned int u32;typedef unsigned short u16;
#include "../sw/ps_uart_print/hdc_learning.h"
#include "../sw/ps_uart_print/synergy_nmf.h"
#include "../sw/ps_uart_print/hdc_model_store.h"
int sd_record_active(void){return 0;}
#include "hdc_model_sd_mock.h"
static uint32_t scale_calls,train_calls,predict_calls,nmf_calls;
static uint32_t fail_scale,fail_train,fail_predict,fail_nmf;
#define CHECK(x) do{if(!(x)){fprintf(stderr,"FAIL line%d: %s\n",__LINE__,#x);exit(1);}}while(0)
static uint32_t pl_learning_nmf(const uint32_t e[8],uint32_t out[8])
{uint32_t i;nmf_calls++;if(fail_nmf)return 0;for(i=0;i<8;i++)out[i]=e[i];out[7]=1;return 1;}
static uint32_t pl_learning_scale(const uint32_t *e,uint32_t n,uint32_t scale[8])
{uint32_t i;scale_calls++;if(fail_scale)return 0;for(i=0;i<n*8;i++)if(e[i]>scale[i%8])scale[i%8]=e[i];return 1;}
static uint32_t pl_learning_train(const uint32_t e[8],const uint32_t scale[8],int16_t *p,uint32_t levels,uint32_t *sat)
{(void)e;(void)scale;(void)levels;(void)sat;train_calls++;if(fail_train)return 0;p[0]++;return 1;}
static uint32_t pl_learning_predict(const uint32_t e[8],const uint32_t scale[8],const int16_t *p,uint32_t classes,
                                  uint32_t levels,uint32_t *best,uint32_t *margin,uint32_t *clip,uint32_t *margin_bp)
{(void)scale;(void)p;(void)levels;predict_calls++;if(fail_predict)return 0;*best=e[0]%classes;*margin=70;*margin_bp=7000;*clip=0;return 1;}
static uint16_t seq;static uint32_t ms;
static void trial(hdc_learning_t *s,uint32_t c)
{uint32_t n,e[8]={0};e[0]=c;CHECK(hdc_arm(s,c));for(n=0;n<80;n++){seq+=40;ms+=25;hdc_window(s,e,seq,ms);}CHECK(!s->armed);}
static void fit(hdc_learning_t *s)
{uint32_t c,n;for(n=0;n<3;n++)for(c=0;c<s->classes;c++)trial(s,c);CHECK(s->stage==HDC_BUILD);}
int main(void)
{
    hdc_learning_t s={0};synergy_nmf_state_t nmf;uint32_t n,c,e[8]={8,7,6,5,4,3,2,1};
    synergy_nmf_reset(&nmf);synergy_nmf_step(&nmf,e);CHECK(nmf.valid && nmf.c[0]==8 && nmf.percent[0]==5 && nmf.residual_percent==2 && nmf_calls==1);
    fail_nmf=1;synergy_nmf_step(&nmf,e);CHECK(!nmf.valid);fail_nmf=0;
    CHECK(hdc_begin(&s,6));fit(&s);CHECK(scale_calls==18 && train_calls==0);
    while(s.stage==HDC_BUILD)hdc_build_step(&s);
    CHECK(train_calls==720 && s.stage==HDC_VALIDATE);
    for(c=0;c<6;c++)CHECK(s.proto[c][0]==120);
    n=train_calls;
    for(c=0;c<6;c++){trial(&s,c);trial(&s,c);}
    CHECK(s.stage==HDC_DONE && train_calls==n && s.latest_valid);
    CHECK(hdc_accuracy(s.hdc_cm,s.classes)==100);
    {hdc_model_io io={0};char name[13];uint32_t prev=predict_calls;void *storage=s.storage;
     io.model=&s;CHECK(sd_model_save(hdc_model_stream,&io,name)==0u);
     CHECK(hdc_model_restore(&s,name,&io)==0u && s.storage!=storage && !s.latest_valid);
     seq+=40u;ms+=25u;hdc_window(&s,e,seq,ms);
     CHECK(predict_calls==prev+1u && s.latest_valid && s.proto[0][0]==120);
     model_mock_reset();puts("TEST_PASS PL model restore: DDR prototype roundtrip, next-window accelerator inference, no software fallback");}
    CHECK(hdc_validate_again(&s));CHECK(s.stage==HDC_VALIDATE);
    for(c=0;c<6;c++){trial(&s,c);trial(&s,c);}
    CHECK(hdc_append(&s) && s.classes==7 && s.stage==HDC_FIT);
    for(c=0;c<3;c++)trial(&s,6);
    CHECK(s.stage==HDC_BUILD);while(s.stage==HDC_BUILD)hdc_build_step(&s);
    CHECK(train_calls==720+840 && s.stage==HDC_VALIDATE);
    puts("TEST_PASS PL backend workflow: labels, committed scale, 120/class, frozen validation, dynamic append");
    fail_predict=1;seq+=40;ms+=25;hdc_window(&s,e,seq,ms);
    CHECK(s.stage==HDC_IDLE && s.accelerator_error && !s.latest_valid && !s.armed);fail_predict=0;
    CHECK(hdc_begin(&s,1));fit(&s);fail_train=1;hdc_build_step(&s);
    CHECK(s.stage==HDC_IDLE && s.accelerator_error && !s.latest_valid);fail_train=0;
    CHECK(hdc_begin(&s,1));fail_scale=1;trial(&s,0);
    CHECK(s.stage==HDC_IDLE && s.accelerator_error && !s.latest_valid);
    puts("TEST_PASS PL backend failures invalidate model and NMF without software fallback");
    free(s.storage);return 0;
}
