#ifndef HDC_MODEL_SD_MOCK_H
#define HDC_MODEL_SD_MOCK_H
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "../sw/ps_uart_print/sd_record.h"
typedef struct { unsigned char *data;uint32_t size;char name[13]; } model_mock_file;
static model_mock_file model_files[32];
static uint32_t model_files_n,model_mock_pos,model_mock_write,model_mock_error,model_mock_close_error;
static model_mock_file *model_mock_open;
static void model_mock_reset(void)
{uint32_t i;for(i=0;i<model_files_n;i++)free(model_files[i].data);memset(model_files,0,sizeof model_files);
 model_files_n=model_mock_pos=model_mock_error=model_mock_close_error=0u;model_mock_open=0;}
uint32_t sd_model_transfer(void *data,uint32_t bytes,uint32_t writing)
{
    unsigned char *p;
    if(model_mock_error)return model_mock_error;
    if(!model_mock_open || writing!=model_mock_write)return 0x302u;
    if(writing){
        p=(unsigned char *)realloc(model_mock_open->data,model_mock_pos+bytes);assert(p);
        model_mock_open->data=p;memcpy(p+model_mock_pos,data,bytes);model_mock_open->size=model_mock_pos+bytes;
    }else{
        if(model_mock_pos+bytes>model_mock_open->size)return 0x304u;
        memcpy(data,model_mock_open->data+model_mock_pos,bytes);
    }
    model_mock_pos+=bytes;return 0u;
}
uint32_t sd_model_save(sd_model_stream_fn fn,void *context,char name[13])
{
    uint32_t rc;if(sd_record_active())return 0x301u;
    assert(model_files_n<32u);model_mock_open=&model_files[model_files_n++];
    sprintf(model_mock_open->name,"HM%06u.HDC",model_files_n-1u);strcpy(name,model_mock_open->name);
    model_mock_pos=0u;model_mock_write=1u;rc=fn(context,1u);model_mock_open=0;
    return rc?rc:model_mock_close_error;
}
uint32_t sd_model_load(const char *name,sd_model_stream_fn fn,void *context)
{
    uint32_t i,rc;if(sd_record_active())return 0x301u;
    for(i=0;i<model_files_n;i++)if(!strcmp(name,model_files[i].name))break;
    if(i==model_files_n)return 5u;
    model_mock_open=&model_files[i];model_mock_pos=0u;model_mock_write=0u;rc=fn(context,0u);
    if(!rc && model_mock_pos!=model_mock_open->size)rc=0x304u;
    model_mock_open=0;return rc?rc:model_mock_close_error;
}
uint32_t sd_model_list(uint32_t after,sd_model_entry *entries,uint32_t cap,uint32_t *count,uint32_t *more)
{
    uint32_t i;if(sd_record_active())return 0x301u;if(model_mock_error)return model_mock_error;
    *count=*more=0u;
    for(i=after;i<model_files_n;i++){
        if(*count==cap){*more=1u;break;}
        entries[*count].id=i;strcpy(entries[*count].name,model_files[i].name);(*count)++;
    }
    return 0u;
}
#endif
