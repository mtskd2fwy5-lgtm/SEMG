#if defined(_MSC_VER)
#include <crtdbg.h>
#endif
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "../sw/ps_uart_print/channel_quality.h"
static void reset(void){memset(channel_quality,0,sizeof channel_quality);memset(cq_pending,0,sizeof cq_pending);memset(&cq_worker,0,sizeof cq_worker);memset(cq_write_buffer,0,sizeof cq_write_buffer);memset(cq_result_ok,0,sizeof cq_result_ok);cq_jobs_completed=0;cq_check_state=cq_check_done=cq_check_nodata=cq_check_valid=cq_check_count=cq_result_t=0u;}
static void finish(void){unsigned i;for(i=0;i<30000;i++){unsigned ch,ready=0;for(ch=0;ch<8;ch++)ready|=cq_pending[ch].ready;if(!ready)break;cq_service();}assert(i<30000);}
static void signal(double amplitude,double hz,int offset,uint16_t seq)
{
    unsigned n;for(n=0;n<4000;n++){
        int v=(int)lrint(amplitude*sin(6.283185307179586*hz*n/4000)+offset);
        cq_ingest((uint32_t)v,0x50000000u|(uint16_t)(seq+n),n);
    }
    finish();
}
int main(int argc,char **argv)
{
    unsigned i,n;int v[8];cq_score_t sc;
#if defined(_MSC_VER)
    _set_error_mode(_OUT_TO_STDERR);_set_abort_behavior(0,_WRITE_ABORT_MSG|_CALL_REPORTFAULT);
#endif
    if(argc>1 && !strcmp(argv[1],"--stream")) {
        n=0;while(scanf("%d %d %d %d %d %d %d %d",&v[0],&v[1],&v[2],&v[3],&v[4],&v[5],&v[6],&v[7])==8){
            for(i=0;i<8;i++)cq_ingest((uint32_t)v[i],0x50000000u|(i<<24)|(uint16_t)n,n);
            if((n+1u)%CQ_N==0){
                finish();
                for(i=0;i<8;i++){
                    channel_quality_t *q=&channel_quality[i];
                    printf("%u %u %u %u %u %u %u %u %u %u %u %u %u %u %u\n",i,q->rms,q->cf10,q->line10,q->clipped,q->window_peak,
                        q->snr10,q->low10,q->noise10,q->kurtosis10,q->total_score,q->grade,q->distribution_score,q->motion_score,q->contact_score);
                }
            }n++;
        }return 0;
    }
    reset();signal(1000,137,0,0);assert(abs((int)channel_quality[0].rms-707)<2);
    assert(channel_quality[0].line10==0);
    for(i=1;i<=4;i++){
        reset();signal(1000,50*i,0,65000);
        assert(channel_quality[0].valid && channel_quality[0].line10>=900);
        assert(channel_quality[0].gaps==0); /* wrap without missing data */
    }
    reset();signal(1000,137,1000000,0);
    assert(abs((int)channel_quality[0].rms-707)<2 && channel_quality[0].line10==0);
    assert(channel_quality[0].clipped==0 && channel_quality[0].cf10<16); /* DC offset is not clipping or a spike */
    reset();signal(0,0,0,0);assert(channel_quality[0].rms==0 && channel_quality[0].line10==0);
    reset();signal(0,0,8388607,0);assert(channel_quality[0].clipped==4000);
    reset();signal(0,0,-8388608,0);assert(channel_quality[0].clipped==4000);
    reset();signal(8300000,50,0,0);assert(channel_quality[0].line10>=900);
    reset();signal(1000,137,0,0);assert(channel_quality[0].grade<=CQ_GRADE_B);
    cq_ingest(50,0x50000000u|4002u,4002);
    assert(!channel_quality[0].valid && channel_quality[0].gaps==1);
    n=channel_quality[0].n;cq_ingest(99,0x50000000u|4002u,4002);assert(channel_quality[0].n==n);
    cq_ingest(99,0x10000000u|4003u,4003);assert(channel_quality[0].n==n);
    cq_ingest(99,0x58000000u|4003u,4003);assert(channel_quality[0].n==n);
    cq_ingest(99,0x50100000u|4003u,4003);assert(channel_quality[0].n==n);
    reset();cq_ingest(50,0x50000000u,0);
    cq_ingest(50,0x50000001u,CQ_STALE_TICKS+1u);
    assert(channel_quality[0].gaps==1 && channel_quality[0].n==1);
    reset();cq_ingest(50,0x50000000u,0xfffffff0u);
    cq_ingest(50,0x50000001u,20u);assert(!channel_quality[0].gaps);
    sc=cq_assess_score(0,100,200,0,0,0,30,40,0,0);assert(sc.grade==CQ_GRADE_UNKNOWN);
    sc=cq_assess_score(1,0,300,0,0,0,0,0,0,0);assert(sc.grade==CQ_GRADE_D);
    sc=cq_assess_score(1,100,200,0,0,0,30,40,0,0);assert(sc.total==100 && sc.grade==CQ_GRADE_A);
    sc=cq_assess_score(1,100,200,800,0,0,30,40,0,0);assert(sc.mains==0 && sc.grade==CQ_GRADE_D);
    sc=cq_assess_score(1,100,200,0,800,0,30,40,0,0);assert(sc.motion==60 && sc.grade==CQ_GRADE_B);
    sc=cq_assess_score(1,100,200,0,0,0,30,40,500,0);assert(sc.grade==CQ_GRADE_D);
    sc=cq_assess_score(1,100,200,0,0,0,30,3000,0,1);assert(sc.grade==CQ_GRADE_D);
    reset();signal(0,0,0,0);assert(channel_quality[0].grade==CQ_GRADE_D);
    /* All fixed-score outputs are independent of boot history and other channels. */
    {unsigned clean,scaled;reset();signal(1000,137,0,0);clean=channel_quality[0].total_score;
     reset();signal(10000,137,0,0);scaled=channel_quality[0].total_score;
     assert(abs((int)clean-(int)scaled)<=1);}
    /* ±2 Hz drift and harmonics must not escape a single exact DFT bin. */
    for(i=0;i<4;i++){reset();signal(1000,49.5+i*50,0,0);assert(channel_quality[0].line10>750 && channel_quality[0].grade==CQ_GRADE_D);}
    /* A gap while a frozen job is pending invalidates that job. */
    reset();for(n=0;n<CQ_N;n++)cq_ingest((uint32_t)(n%31),0x50000000u|(uint16_t)n,n);
    assert(cq_pending[0].ready);cq_service();cq_ingest(1,0x50000000u|4002u,4002);finish();assert(!channel_quality[0].valid);
    /* Slow analysis never corrupts a frozen window or labels samples as DMA loss. */
    reset();for(n=0;n<CQ_N*3;n++)cq_ingest((uint32_t)(1000*sin(6.283185307179586*137*n/4000)),0x50000000u|(uint16_t)n,n);
    assert(channel_quality[0].analysis_drops==2 && !channel_quality[0].gaps);finish();assert(channel_quality[0].grade<=CQ_GRADE_B);
    /* Eight live channels with sufficient worker capacity: no diagnostic
     * backlog or acquisition gaps. Keep a fixed 1024 work-unit allowance
     * per batch, independent of chunk size. Wall-clock quotas and UI fairness
     * are separately tested in lcd_work_budget_test.c. */
    reset();
    for(n=0;n<CQ_N*5;n++){
        for(i=0;i<8;i++)cq_ingest((uint32_t)(1000*sin(6.283185307179586*137*n/4000)),0x50000000u|(i<<24)|(uint16_t)n,n);
        if((n&7u)==7u)for(i=0;i<1024u/CQ_WORK_BUDGET;i++)cq_service();
    }
    finish();for(i=0;i<8;i++)assert(channel_quality[i].windows==5 && !channel_quality[i].analysis_drops && !channel_quality[i].gaps);
    /* Button-triggered full check: the press discards pre-press frozen
     * windows, every channel captures one synchronized window, and the
     * result set commits in a single step. */
    reset();
    for(n=0;n<CQ_N;n++)for(i=0;i<8;i++)cq_ingest((uint32_t)(1000*sin(6.283185307179586*137*n/4000)),0x50000000u|(i<<24)|(uint16_t)n,n);
    assert(cq_pending[0].ready && cq_pending[7].ready);
    assert(cq_request_check(CQ_N));
    assert(!cq_request_check(CQ_N));            /* running check rejects re-press */
    assert(!cq_pending[0].ready && channel_quality[0].n==0);
    for(n=0;n<CQ_N;n++)for(i=0;i<8;i++)cq_ingest((uint32_t)(1000*sin(6.283185307179586*137*n/4000)),0x50000000u|(i<<24)|(uint16_t)(CQ_N+n),CQ_N+n);
    {unsigned k=0u;while(cq_check_state&&k<30000u){cq_service();cq_check_tick(2u*CQ_N+1000u);}assert(!cq_check_state&&k<30000u);}
    for(i=0;i<8;i++)assert(cq_result_ok[i] && channel_quality[i].windows==1u && channel_quality[i].valid);
    /* A sequence jump after some channels already committed must not erase
     * their results: the gap handler wipes the volatile per-channel valid
     * flag, but the check result set stays latched until the next press.
     * This is the board failure mode where only the last channel to finish
     * survived until commit. */
    reset();
    for(n=0;n<CQ_N;n++)for(i=0;i<8;i++)cq_ingest((uint32_t)(1000*sin(6.283185307179586*137*n/4000)),0x50000000u|(i<<24)|(uint16_t)n,n);
    assert(cq_request_check(CQ_N));
    for(n=0;n<CQ_N;n++)for(i=0;i<8;i++)cq_ingest((uint32_t)(1000*sin(6.283185307179586*137*n/4000)),0x50000000u|(i<<24)|(uint16_t)(CQ_N+n),CQ_N+n);
    {unsigned k=0u;while(cq_check_done!=0x7fu&&k<30000u){cq_service();cq_check_tick(2u*CQ_N+1000u);}assert(cq_check_done==0x7fu&&k<30000u);}
    cq_ingest(7,0x50000000u|(2u*CQ_N+2u),2u*CQ_N+2u); /* delta 3: jump on ch0 after it committed */
    assert(!channel_quality[0].valid);               /* volatile flag wiped, as on the board */
    {unsigned k=0u;while(cq_check_state&&k<30000u){cq_service();cq_check_tick(2u*CQ_N+1000u);}assert(!cq_check_state&&k<30000u);}
    for(i=0;i<8;i++)assert(cq_result_ok[i]);
    /* A second press discards the previous result set until it commits. */
    assert(cq_request_check(2u*CQ_N+2000u));
    assert(channel_quality[0].n==0u && !cq_pending[0].ready);
    cq_check_tick(2u*CQ_N+CQ_STALE_TICKS+2000u); /* stream long dead: no-data */
    assert(!cq_check_state && cq_check_count==2u);
    for(i=0;i<8;i++)assert(!cq_result_ok[i]);
    /* No stream at all: the first check also resolves immediately. */
    reset();assert(cq_request_check(100u));
    cq_check_tick(200u);
    assert(!cq_check_state && cq_check_count==1u);
    for(i=0;i<8;i++)assert(!cq_result_ok[i]);
    puts("TEST_PASS quality: AC RMS, offset, four mains harmonics, fullscale, silence, sequence wrap/gap/duplicates, baseline-free score, drifted mains, frozen worker cancellation/backpressure, source/header rejection, button-triggered full check with synchronized capture, gap-tolerant latched results and single commit.");
    return 0;
}
