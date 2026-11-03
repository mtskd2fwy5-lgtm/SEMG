#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
typedef unsigned int u32;
typedef unsigned short u16;
#include "../sw/ps_uart_print/synergy_nmf.h"

int main(int argc,char **argv)
{
    synergy_nmf_state_t s;
    u32 rest[8]={0,0,0,0,0,0,0,0};
    u32 signal[8]={10000,12000,180000,9000,160000,40000,8000,7000};
    u32 stronger[8]={20000,24000,360000,18000,320000,80000,16000,14000};
    u32 once[3],j;
    if(argc==2 && strcmp(argv[1],"--stream")==0) {
        u32 e[8];synergy_nmf_reset(&s);
        while(scanf("%u %u %u %u %u %u %u %u",&e[0],&e[1],&e[2],&e[3],&e[4],&e[5],&e[6],&e[7])==8) {
            synergy_nmf_step(&s,e);
            printf("%u %u %u\n",s.c[0],s.c[1],s.c[2]);
        }
        return 0;
    }
    synergy_nmf_reset(&s);
    synergy_nmf_step(&s,rest);
    assert(s.valid);
    for(j=0;j<3;j++)assert(s.percent[j]<=100u);
    synergy_nmf_step(&s,signal); /* must recover from a silent window */
    assert(s.c[0] || s.c[1] || s.c[2]);
    synergy_nmf_reset(&s);
    synergy_nmf_step(&s,signal);
    for(j=0;j<3;j++)once[j]=s.c[j];
    assert(once[0] || once[1] || once[2]);
    synergy_nmf_step(&s,signal);
    for(j=0;j<3;j++)assert(s.percent[j]<=100u);
    synergy_nmf_reset(&s);
    synergy_nmf_step(&s,signal);
    for(j=0;j<3;j++)assert(s.c[j]==once[j]);
    synergy_nmf_reset(&s);
    synergy_nmf_step(&s,signal);
    synergy_nmf_step(&s,stronger);
    for(j=0;j<3;j++)assert(s.c[j]>once[j]);
    for(j=0;j<8;j++)signal[j]=0xffffffffu;
    for(j=0;j<100;j++)synergy_nmf_step(&s,signal);
    for(j=0;j<3;j++)assert(s.c[j]<=0x7fffffffu && s.percent[j]<=100u);
    assert(s.c[0] || s.c[1] || s.c[2]);
    puts("TEST_PASS SYNERGY: silence recovery, deterministic reset, amplitude step, full-range bounds.");
    return 0;
}

