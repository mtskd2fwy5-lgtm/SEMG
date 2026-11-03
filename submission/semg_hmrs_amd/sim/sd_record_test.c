/* Tests the actual recorder/packing/diskio with injectable filesystem/card IO. */
#ifndef _CRT_SECURE_NO_WARNINGS
#define _CRT_SECURE_NO_WARNINGS
#endif
#include <assert.h>
#include <stdio.h>
#include <string.h>
#define SD_RECORD_HOST_TEST 1
#include "../sw/ps_uart_print/sd_record.c"
static BYTE file_data[300000];
static const char *directory_names[]={"HM000007.HDC","HM000001.HDC","HM000009.HDC","HM000003.HDC","HM000005.HDC","HM000002.HDC","HM000008.HDC","HM000004.HDC","HM000006.HDC","EMG000.BIN","HM000x01.HDC","HM000010.HDC","HM000011.HDC","HM000099.HDC.bak"};
static uint32_t directory_error,directory_close_error;
FRESULT f_opendir(DIR *d,const char *p){(void)p;d->index=0;return directory_error;}
FRESULT f_readdir(DIR *d,FILINFO *info){if(directory_error)return directory_error;info->fattrib=0;
 if(d->index>=sizeof directory_names/sizeof directory_names[0]){info->fname[0]=0;return 0;}
 strcpy(info->fname,directory_names[d->index++]);if(!strcmp(info->fname,"HM000011.HDC"))info->fattrib=AM_DIR;return 0;}
FRESULT f_closedir(DIR *d){(void)d;return directory_close_error;}
static uint32_t model_test_stream(void *context,uint32_t writing)
{return sd_model_transfer(context,9000u,writing);}
static UINT read_pos;
static UINT file_size, open_calls, close_calls, sync_calls, service_calls;
static int read_error,open_error, write_error, sync_error, close_error, short_write;
static uint32_t card_address,card_count;
u32 Xil_In32(UINTPTR a) { (void)a;return 0; }
void usleep(unsigned long us) { (void)us; }
void acquisition_service(void) { service_calls++; }
int XSdPs_CfgInitialize(XSdPs *s,XSdPs_Config *c,uint32_t b)
{ (void)c;(void)b;s->HCS=1;s->SectorCount=100000;return 0; }
int XSdPs_CardInitialize(XSdPs *s) { (void)s;return 0; }
int XSdPs_ReadPolled(XSdPs *s,uint32_t a,UINT n,BYTE *b)
{ (void)s;card_address=a;card_count=n;assert(!((uintptr_t)b&31));memset(b,0x5a,n*512);return 0; }
int XSdPs_WritePolled(XSdPs *s,uint32_t a,UINT n,const BYTE *b)
{ (void)s;card_address=a;card_count=n;assert(!((uintptr_t)b&31));assert(b[0]==0x5a);return 0; }
FRESULT f_mount(FATFS *f,const char *p,BYTE m)
{ (void)f;(void)p;(void)m;return 0; }
FRESULT f_open(FIL *f,const char *p,BYTE m)
{ (void)f;open_calls++;if(open_error)return open_error;
  if(m==FA_READ){read_pos=0;return FR_OK;}
  if(!strcmp(p,"EMG000.BIN") || !strcmp(p,"RH000.CSV") || !strcmp(p,"HD000.CSV") || !strcmp(p,"HM000000.HDC"))return FR_EXIST;file_size=0;return FR_OK; }
FRESULT f_write(FIL *f,const void *p,UINT n,UINT *w)
{ (void)f;*w=write_error?0:short_write?n/2:n;assert(file_size+*w<sizeof file_data);
  memcpy(file_data+file_size,p,*w);file_size+=*w;return write_error; }
FRESULT f_read(FIL *f,void *p,UINT n,UINT *r)
{(void)f;if(read_error){*r=0;return read_error;}*r=file_size-read_pos<n?file_size-read_pos:n;memcpy(p,file_data+read_pos,*r);read_pos+=*r;return 0;}
FRESULT f_sync(FIL *f) { (void)f;sync_calls++;return sync_error; }
FRESULT f_close(FIL *f) { (void)f;close_calls++;return close_error; }
static int decode24(const BYTE *p)
{ uint32_t v=p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16);return (int32_t)(v<<8)>>8; }
int main(void)
{
    int raw[8]={-8388608,-1,0,1,8388607,123,-456,789},notch[8];
    unsigned i,j,closes;BYTE data[512*10+2];LBA_t sectors=0;
    for(i=0;i<8;i++)notch[i]=raw[7-i];
    assert(sd_record_start() && open_calls==2 && !strcmp(sd_record_filename(),"EMG001.BIN"));
    for(i=0;i<4101;i++)assert(sd_record_append((uint16_t)(65530+i),3,raw,notch));
    assert(sd_record_frames()==4101 && sync_calls>0 && sd_record_stop());
    assert(!sd_record_active() && !sd_record_error() && file_size==512+4101*52);
    assert(!memcmp(file_data,"SEMGSD1",7));
    assert(file_data[8]==2 && file_data[32]==3);
    for(i=0;i<4101;i++) {
        BYTE *p=file_data+512+i*52;unsigned seq=(65530+i)&65535;
        assert((p[0]|(p[1]<<8))==seq && p[2]==3 && p[3]==0);
        for(j=0;j<8;j++){assert(decode24(p+4+j*3)==raw[j]);assert(decode24(p+28+j*3)==notch[j]);}
    }
    assert(sd_record_start());assert(sd_record_append(30566,0,raw,notch));
    assert(!sd_record_append(30055,0,raw,notch) && sd_record_error()==0x105 && !sd_record_active());
    assert(sd_record_start());assert(sd_record_append(1,0,raw,notch));
    assert(!sd_record_append(1,0,raw,notch) && sd_record_error()==0x105);
    open_error=FR_DENIED;i=open_calls;assert(!sd_record_start() && open_calls==i+1);open_error=0;
    assert(sd_record_start());assert(sd_record_append(1,0,raw,notch));
    short_write=1;closes=close_calls;assert(!sd_record_stop());
    assert(sd_record_error()==0x103 && !sd_record_active() && close_calls==closes+1);
    i=file_size;assert(!sd_record_append(2,0,raw,notch) && file_size==i);short_write=0;
    assert(sd_record_start());assert(sd_record_append(1,0,raw,notch));
    sync_error=FR_DISK_ERR;closes=close_calls;assert(!sd_record_stop() && close_calls==closes+1);sync_error=0;
    assert(sd_record_start());close_error=FR_DISK_ERR;assert(!sd_record_stop());close_error=0;
    assert(sd_record_start());assert(sd_record_append(1,0,raw,notch));
    write_error=FR_DISK_ERR;assert(!sd_record_stop() && !sd_record_active());write_error=0;
    memset(data,0,sizeof data);assert(disk_read(0,data+1,3,10)==RES_OK);
    assert(data[0]==0 && data[sizeof(data)-1]==0 && data[1]==0x5a && card_address==11 && card_count==2);
    assert(disk_write(0,data+1,3,10)==RES_OK && card_address==11);
    sd0.HCS=0;assert(disk_write(0,data+1,3,1)==RES_OK && card_address==1536);
    assert(disk_ioctl(0,GET_SECTOR_COUNT,&sectors)==RES_OK && sectors==100000);
    assert(disk_read(0,0,0,1)==RES_PARERR && disk_write(0,data,0,0)==RES_PARERR);
    assert(service_calls>0);
    {
        char name[13];const char csv[]="kind,index,target,success\r\ntrial,1,2,1\r\n";
        assert(sd_training_save(csv,sizeof csv-1,name)==0u && !strcmp(name,"RH001.CSV"));
        assert(file_size==sizeof csv-1 && !memcmp(file_data,csv,sizeof csv-1));
        assert(sd_hdc_save(csv,sizeof csv-1,name)==0u && !strcmp(name,"HD001.CSV"));
        assert(file_size==sizeof csv-1 && !memcmp(file_data,csv,sizeof csv-1));
        assert(sd_record_start());i=open_calls;
        assert(sd_training_save(csv,sizeof csv-1,name)==0x301u && open_calls==i && sd_record_active());
        assert(sd_hdc_save(csv,sizeof csv-1,name)==0x301u && open_calls==i);
        assert(sd_record_stop());
        short_write=1;closes=close_calls;
        assert(sd_training_save(csv,sizeof csv-1,name)==0x304u && close_calls==closes+1u);short_write=0;
        sync_error=FR_DISK_ERR;assert(sd_training_save(csv,sizeof csv-1,name)!=0u);sync_error=0;
        close_error=FR_DISK_ERR;assert(sd_training_save(csv,sizeof csv-1,name)!=0u);close_error=0;
        open_error=FR_DENIED;assert(sd_training_save(csv,sizeof csv-1,name)!=0u);open_error=0;
        assert(sd_training_save(0,1,name)==0x302u);
        assert(sd_hdc_save(0,1,name)==0x302u);
        puts("TEST_PASS training CSV: no overwrite, exact bytes, waveform exclusion, short write/sync/close/open errors.");
    }
    {
        BYTE expected[264],got[264];memset(expected,0x5c,sizeof expected);
        assert(sd_hand_write(0,expected,sizeof expected)==0u);
        assert(sd_hand_read(0,got,sizeof got)==0u && !memcmp(got,expected,sizeof got));
        file_size--;assert(sd_hand_read(0,got,sizeof got)==0x304u);
        file_size+=2;assert(sd_hand_read(0,got,sizeof got)==0x304u);
        short_write=1;assert(sd_hand_write(1,expected,sizeof expected)==0x304u);short_write=0;
        sync_error=1;assert(sd_hand_write(1,expected,sizeof expected)!=0u);sync_error=0;
        close_error=1;assert(sd_hand_write(1,expected,sizeof expected)!=0u);close_error=0;
        open_error=1;assert(sd_hand_read(1,got,sizeof got)!=0u);open_error=0;
        assert(sd_record_start());assert(sd_hand_write(0,expected,sizeof expected)==0x301u);
        assert(sd_hand_read(0,got,sizeof got)==0x301u);assert(sd_record_stop());
        puts("TEST_PASS hand SD: exact length, truncated/extra data, short write, sync/close/open errors, recording exclusion");
    }
    {
        BYTE expected[9000],got[9000];char name[13];sd_model_entry entries[6];uint32_t count,more;
        memset(expected,0x63,sizeof expected);
        assert(sd_model_save(model_test_stream,expected,name)==0u && !strcmp(name,"HM000001.HDC"));
        assert(sd_model_load(name,model_test_stream,got)==0u && !memcmp(got,expected,sizeof got));
        file_size--;assert(sd_model_load(name,model_test_stream,got)==0x304u);file_size+=2;
        assert(sd_model_load(name,model_test_stream,got)==0x304u);
        read_error=1;assert(sd_model_load(name,model_test_stream,got)!=0u);read_error=0;
        open_error=FR_DENIED;assert(sd_model_save(model_test_stream,expected,name)!=0u);
        assert(sd_model_load(name,model_test_stream,got)!=0u);open_error=0;
        assert(sd_model_transfer(got,1u,0u)==0x302u);
        short_write=1;assert(sd_model_save(model_test_stream,expected,name)==0x304u);short_write=0;
        sync_error=1;assert(sd_model_save(model_test_stream,expected,name)!=0u);sync_error=0;
        close_error=1;assert(sd_model_save(model_test_stream,expected,name)!=0u);
        assert(sd_model_load(name,model_test_stream,got)!=0u);close_error=0;
        assert(sd_model_load("../HAND0.CFG",model_test_stream,got)==0x302u);
        assert(sd_record_start());i=open_calls;
        assert(sd_model_save(model_test_stream,expected,name)==0x301u);
        assert(sd_model_load(name,model_test_stream,got)==0x301u);
        assert(sd_model_list(0u,entries,6u,&count,&more)==0x301u && open_calls==i);assert(sd_record_stop());
        assert(sd_model_list(0u,entries,6u,&count,&more)==0u && count==6u && more);
        for(i=0;i<6u;i++)assert(entries[i].id==i+1u);
        assert(sd_model_list(7u,entries,6u,&count,&more)==0u && count==4u && !more);
        for(i=0;i<4u;i++)assert(entries[i].id==i+7u);
        directory_error=1;assert(sd_model_list(0u,entries,6u,&count,&more)!=0u);directory_error=0;
        directory_close_error=1;assert(sd_model_list(0u,entries,6u,&count,&more)!=0u);directory_close_error=0;
        puts("TEST_PASS model SD IO: chunked exact stream, truncation/trailing, short write, sync/close, recording exclusion, sorted paged directory filtering");
    }
    puts("TEST_PASS sd_record: signed paired frames, wrap, tail flush, periodic sync, no overwrite, IO errors, aligned bounce, SDSC addressing.");
    return 0;
}

