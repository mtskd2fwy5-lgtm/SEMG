#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "../sw/ps_uart_print/channel_quality.h"
static void reset(void){memset(channel_quality,0,sizeof channel_quality);cq_reference=cq_ref_failed=0;}
static void signal(double amplitude,double hz,int offset,uint16_t seq)
{
    unsigned n;for(n=0;n<4000;n++){
        int v=(int)lrint(amplitude*sin(6.283185307179586*hz*n/4000)+offset);
        cq_ingest((uint32_t)v,0x50000000u|(uint16_t)(seq+n),n);
    }
}
int main(int argc,char **argv)
{
    unsigned i,n;int v[8];cq_score_t sc;
    if(argc>1 && !strcmp(argv[1],"--stream")) {
        n=0;while(scanf("%d %d %d %d %d %d %d %d",&v[0],&v[1],&v[2],&v[3],&v[4],&v[5],&v[6],&v[7])==8){
            for(i=0;i<8;i++) if(cq_ingest((uint32_t)v[i],0x50000000u|(i<<24)|(uint16_t)n,n)) {
                channel_quality_t *q=&channel_quality[i];
                printf("%u %u %u %u %u %u\n",i,q->rms,q->cf10,q->line10,q->clipped,q->window_peak);
            }n++;
        }return 0;
    }
    reset();signal(1000,137,0,0);assert(abs((int)channel_quality[0].rms-707)<2);
    assert(channel_quality[0].line10==0);
    for(i=1;i<=4;i++){
        reset();signal(1000,50*i,0,65000);
        assert(channel_quality[0].valid && channel_quality[0].line10>=998);
        assert(channel_quality[0].gaps==0); /* wrap without missing data */
    }
    reset();signal(1000,137,1000000,0);
    assert(abs((int)channel_quality[0].rms-707)<2 && channel_quality[0].line10==0);
    assert(channel_quality[0].clipped==0 && channel_quality[0].cf10<16); /* DC offset is not clipping or a spike */
    reset();signal(0,0,0,0);assert(channel_quality[0].rms==0 && channel_quality[0].line10==0);
    reset();signal(0,0,8388607,0);assert(channel_quality[0].clipped==4000);
    reset();signal(0,0,-8388608,0);assert(channel_quality[0].clipped==4000);
    reset();signal(8300000,50,0,0);assert(channel_quality[0].line10>=998);
    reset();cq_start_reference();signal(1000,137,0,0);
    assert(cq_reference && channel_quality[0].base_n==1 && !channel_quality[0].base);
    cq_ingest(50,0x50000000u|4002u,4002);
    assert(!cq_reference && cq_ref_failed && !channel_quality[0].valid && channel_quality[0].gaps==1);
    n=channel_quality[0].n;cq_ingest(99,0x50000000u|4002u,4002);assert(channel_quality[0].n==n);
    cq_ingest(99,0x10000000u|4003u,4003);assert(channel_quality[0].n==n);
    cq_ingest(99,0x58000000u|4003u,4003);assert(channel_quality[0].n==n);
    cq_ingest(99,0x50100000u|4003u,4003);assert(channel_quality[0].n==n);
    reset();cq_ingest(50,0x50000000u,0);
    cq_ingest(50,0x50000001u,CQ_STALE_TICKS+1u);
    assert(channel_quality[0].gaps==1 && channel_quality[0].n==1);
    reset();cq_ingest(50,0x50000000u,0xfffffff0u);
    cq_ingest(50,0x50000001u,20u);assert(!channel_quality[0].gaps);
    sc=cq_assess_score(0,100,0,0,0,100);assert(sc.grade==CQ_GRADE_UNKNOWN);
    sc=cq_assess_score(1,0,0,0,0,100);assert(sc.grade==CQ_GRADE_UNKNOWN);
    sc=cq_assess_score(1,100,100,0,0,100);assert(sc.total==100 && sc.grade==CQ_GRADE_A);
    sc=cq_assess_score(1,100,100,300,0,100);
    assert(sc.mains==0 && sc.grade==CQ_GRADE_D && sc.cap==CQ_GRADE_D);
    sc=cq_assess_score(1,10,100,0,0,100);assert(sc.activity==0 && sc.grade==CQ_GRADE_D);
    /* Website grade boundaries are inclusive: an 80-point subscore does not cap A. */
    sc=cq_assess_score(1,25,100,0,0,100);assert(sc.activity==80 && sc.grade==CQ_GRADE_A && sc.cap==CQ_GRADE_A);
    sc=cq_assess_score(1,50,100,0,0,100);assert(sc.activity==100);
    sc=cq_assess_score(1,200,100,0,0,100);assert(sc.activity==80);
    sc=cq_assess_score(1,100,3000,0,1,100);assert(sc.rail==0 && sc.grade==CQ_GRADE_D);
    puts("TEST_PASS quality: AC RMS, offset, four mains harmonics, fullscale, silence, sequence wrap/gap/duplicates, missing baseline channel, source/header rejection.");
    return 0;
}
