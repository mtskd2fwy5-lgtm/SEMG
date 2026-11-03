/* Exercise the real PS recorder with fake MMIO; never opens hardware. */
#include <assert.h>
#include <stdio.h>
#include <string.h>
#define LCD_HOST_TEST 1
#define UART_CAPTURE_TEST 1
#define main firmware_main
#include "../sw/ps_uart_print/main.c"
#undef main
#include "hdc_model_sd_mock.h"

unsigned char __dma_buf[1048576];
int sd_record_start(void) { return 1; }
int sd_record_stop(void) { return 1; }
void sd_record_abort(uint32_t error) { (void)error; }
int sd_record_append(uint16_t s,uint8_t a,const int r[8],const int n[8])
{ (void)s;(void)a;(void)r;(void)n;return 1; }
int sd_record_active(void) { return 0; }
int sd_record_ready(void) { return 0; }
int sd_record_error(void) { return 0; }
uint32_t sd_record_frames(void) { return 0; }
const char *sd_record_filename(void) { return "EMG000.BIN"; }
uint32_t sd_training_save(const char *d,uint32_t b,char n[13])
{(void)d;(void)b;(void)n;return 0u;}
static unsigned char hand_banks[2][512];
static uint32_t hand_bank_size[2],hand_bank_fail;
uint32_t sd_hand_read(uint32_t slot,void *d,uint32_t b)
{if(slot>1 || hand_bank_size[slot]!=b)return 1;memcpy(d,hand_banks[slot],b);return 0;}
uint32_t sd_hand_write(uint32_t slot,const void *d,uint32_t b)
{assert(slot<2 && b<=512);if(hand_bank_fail)return 1;memcpy(hand_banks[slot],d,b);hand_bank_size[slot]=b;return 0;}
uint32_t sd_hdc_save(const char *d,uint32_t b,char n[13])
{(void)d;(void)b;(void)n;return 0u;}
static unsigned char fb[3][1024*600*3];
static volatile u32 fake_reg;
static volatile u32 control_command_reg,control_status_reg;
static volatile u32 hand_command_reg,hand_status_reg;
static volatile u32 imu_command_reg,imu_response_reg,imu_legacy_word;
static u32 buffer[BUF_PACKETS*2], time_ticks,uart_char_count;

volatile u32 *lcd_test_mmio(u32 address) {
    if(address==0x41270000u)return &imu_command_reg;
    if(address==0x41270008u)return &imu_response_reg;
    if(address==0x41220000u)return &imu_legacy_word;
    if(address==0x41250000u)return &hand_command_reg;
    if(address==0x41250008u)return &hand_status_reg;
    if(address==0x41240000u)return &control_command_reg;
    if(address==0x41240008u)return &control_status_reg;
    return &fake_reg;
}
volatile u8 *lcd_test_fb(u32 index) { assert(index<3); return fb[index]; }
u32 lcd_test_clock(void) { return time_ticks+=3333u; }
void display_memory_clean(uintptr_t address,u32 bytes) { (void)address; (void)bytes; }
void uart_test_putc(char c) { (void)c;uart_char_count++; }

#ifndef CONTROL_REFERENCE_NO_MAIN
int main(int argc,char **argv)
{
    unsigned reset,seq,ch,ready,best,gate;
    int logits[5];unsigned mav[8];
    if(argc>1 && strcmp(argv[1],"--mapping")==0) {
        u32 shift,features[40],i;i32 out[5];
        while(scanf("%u",&shift)==1) {
            for(i=0u;i<40u;i++)assert(scanf("%u",&features[i])==1);
            selfcal_nn_logits(features,shift,out);
            printf("%d %d %d %d %d\n",out[0],out[1],out[2],out[3],out[4]);
        }
        return 0;
    }
    parsed_total=16;g_mode=MODE_MONITOR;
    while(scanf("%u %u %u %u %u %u %u %u %u %u %d %d %d %d %d",&reset,&seq,
      &mav[0],&mav[1],&mav[2],&mav[3],&mav[4],&mav[5],&mav[6],&mav[7],
      &logits[0],&logits[1],&logits[2],&logits[3],&logits[4])==15) {
        if(reset)cal_start();
        for(ch=0;ch<8;ch++)feat_mav[ch]=mav[ch];
        cal_on_window();ready=cal_stage==2;best=0;gate=0;
        for(ch=0;ch<5;ch++)res_logits[ch]=(u32)logits[ch];
        for(ch=1;ch<5;ch++)if(logits[ch]>logits[best])best=ch;
        if(ready){
            if(best && rest_gate()){best=0;gate=1;}
            pose_observe(seq,best,logit_conf(),gate);
        }
        printf("%u %u %u %u %u %u %u %u %u\n",cal_stage,ready,pose_active_cls,
          pose_active_conf,gate,best,logit_conf_for(best),pose_pending_count,pose_uncertain_count);
    }
    return 0;
}
#endif

