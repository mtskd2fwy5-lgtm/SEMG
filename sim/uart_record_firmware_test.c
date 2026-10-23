/* Exercise the real PS recorder with fake MMIO; never opens hardware. */
#include <assert.h>
#include <stdio.h>
#include <string.h>
#define LCD_HOST_TEST 1
#define UART_CAPTURE_TEST 1
#define main firmware_main
#include "../sw/ps_uart_print/main.c"
#undef main

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
static unsigned char fb[3][1024*600*3];
static volatile u32 fake_reg;
static u32 buffer[BUF_PACKETS*2], time_ticks;
static unsigned char output[4096];
static unsigned output_size;
volatile u32 *lcd_test_mmio(u32 address) { (void)address; return &fake_reg; }
volatile u8 *lcd_test_fb(u32 index) { assert(index<3); return fb[index]; }
u32 lcd_test_clock(void) { return time_ticks+=3333u; }
void display_memory_clean(uintptr_t address,u32 bytes) { (void)address; (void)bytes; }
void uart_test_putc(char c) { assert(output_size<sizeof(output)); output[output_size++]=(unsigned char)c; }
static const i32 values[8]={-8388608,-1,0,1,8388607,0x55aa,-123456,654321};

static void clear_buffer(void) { memset(buffer,0,sizeof(buffer)); }
static void put(unsigned word,unsigned type,unsigned ch,unsigned seq,i32 value)
{
    assert(word<BUF_PACKETS);
    buffer[2*word]=(u32)value&0xffffffu;
    buffer[2*word+1]=(type<<28)|(ch<<24)|(seq&0xffffu);
}
static void group(unsigned offset,unsigned type,unsigned seq)
{
    unsigned ch;
    for(ch=0;ch<8;ch++) put(offset+ch,type,ch,seq,values[ch]);
}
static void expect_frame(unsigned offset,unsigned marker,unsigned seq)
{
    unsigned ch;
    assert(output_size>=offset+28);
    assert(output[offset]==0xaa && output[offset+1]==marker);
    assert(output[offset+2]==(seq&255) && output[offset+3]==(seq>>8));
    for(ch=0;ch<8;ch++) {
        u32 v=(u32)values[ch]&0xffffffu;
        assert(output[offset+4+3*ch]==(v&255));
        assert(output[offset+5+3*ch]==((v>>8)&255));
        assert(output[offset+6+3*ch]==((v>>16)&255));
    }
}

int main(void)
{
    unsigned ch,notch,base;
    /* Creating a file must preserve running DMA indices and MMIO state. */
    dma_running=1u;dma_head=17u;dma_tail=16u;dma_fault=0u;
    fake_reg=0x12345678u;ui_sd_action=1u;ui_action=0u;
    ui_apply_action();
    assert(dma_running==1u && dma_head==17u && dma_tail==16u && dma_fault==0u);
    assert(fake_reg==0x12345678u);
    dma_running=0u;
    g_mode=MODE_RECORD;
    assert(rec_notch==1u);
    /* LCD tap may observe a different source/channel without changing
     * the selected binary recording source or frame contents. */
    lcd_wave_view=1u;
    for(notch=0;notch<2;notch++) {
        memset(channel_quality,0,sizeof channel_quality);
        lcd_wave_select(7u,!notch);
        record_select(notch);output_size=0;clear_buffer();
        for(ch=0;ch<8;ch++) {
            put(3*ch,1,ch,17,values[ch]);
            put(3*ch+1,5,ch,17,values[ch]);
            put(3*ch+2,2,ch,17,42);
        }
        record_buffer(buffer);
        assert(output_size==28);expect_frame(0,notch?0x58:0x55,17);
        for(ch=0;ch<8;ch++)assert(channel_quality[ch].n==1 && channel_quality[ch].seq==17);
        assert(wave_count==1 && wave_ring[0]==values[7] && wave_channel==7u);
    }

    // Every channel in a frame must share a sequence; wrap remains uint16.
    record_select(1);output_size=0;clear_buffer();
    group(0,5,65535);group(8,5,0);group(16,5,1);
    record_buffer(buffer);assert(output_size==84);
    expect_frame(0,0x58,65535);expect_frame(28,0x58,0);expect_frame(56,0x58,1);

    // A partial frame survives DMA boundaries, but mixed sequences are dropped.
    record_select(1);output_size=0;clear_buffer();
    for(ch=0;ch<4;ch++) put(ch,5,ch,8,values[ch]);
    record_buffer(buffer);assert(output_size==0 && rec_acc==15);
    clear_buffer();for(ch=4;ch<8;ch++) put(ch,5,ch,9,values[ch]);
    record_buffer(buffer);assert(output_size==0 && rec_acc==240);
    clear_buffer();group(0,5,10);record_buffer(buffer);
    assert(output_size==28);expect_frame(0,0x58,10);

    record_select(1);output_size=0;clear_buffer();
    for(ch=0;ch<4;ch++) put(ch,5,ch,11,values[ch]);
    record_buffer(buffer);
    clear_buffer();group(0,5,12);record_buffer(buffer);
    assert(output_size==28);expect_frame(0,0x58,12);

    // Switching the source discards the previous source's partial assembly.
    record_select(1);output_size=0;clear_buffer();
    for(ch=0;ch<4;ch++) put(ch,5,ch,22,values[ch]);
    record_buffer(buffer);assert(rec_acc==15);
    record_select(0);assert(rec_acc==0);
    clear_buffer();for(ch=4;ch<8;ch++) put(ch,1,ch,22,values[ch]);
    record_buffer(buffer);assert(output_size==0);
    clear_buffer();group(0,1,23);record_buffer(buffer);
    assert(output_size==28);expect_frame(0,0x55,23);

    // Reject malformed waveform headers before they can fill a missing channel.
    record_select(1);output_size=0;clear_buffer();
    for(ch=0;ch<7;ch++) put(ch,5,ch,30,values[ch]);
    put(7,5,8,30,1);
    put(8,5,7,30,values[7]);buffer[17]|=1u<<20;
    put(9,5,7,30,values[7]);buffer[19]|=1u<<16;
    record_buffer(buffer);assert(output_size==0 && rec_acc==127);
    clear_buffer();put(0,5,7,30,values[7]);record_buffer(buffer);
    assert(output_size==28);expect_frame(0,0x58,30);

    // Monitor diagnostics remain original ADC, regardless of recording selection.
    g_mode=MODE_MONITOR;parsed_total=16;next_report=100000;
    memset(channel_quality,0,sizeof channel_quality);
    parse_packet(123,1u<<28);base=raw_cnt;output_size=0;
    assert(!channel_quality[0].seen);
    parse_packet(999,(5u<<28)|1u);
    assert(channel_quality[0].n==1 && channel_quality[0].seq==1);
    assert(raw_cnt==base && raw_latest[0]==123 && raw_last_seq[0]==0);
    assert(raw_gap_cnt==0 && other_cnt==0 && output_size==0);
    parse_packet(456,(1u<<28)|1u);
    assert(raw_cnt==base+1 && raw_latest[0]==456 && raw_gap_cnt==0);
    puts("TEST_PASS uart_record: both source markers, signed payloads, wrap, partial/mixed frames, source switch, malformed headers, raw diagnostics");
    return 0;
}
