/* Real model codec tested against corruptions and transactional switches. */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../sw/ps_uart_print/hdc_model_store.h"
int sd_record_active(void){return 0;}
#include "hdc_model_sd_mock.h"
static void fixture(hdc_learning_t *s,uint32_t custom)
{
    uint32_t c,k,ch;assert(hdc_begin(s,custom));
    for(c=0;c<s->classes;c++){
        for(k=0;k<120u;k++)for(ch=0;ch<8u;ch++)s->fit[c][k][ch]=c*200u+ch*17u+k;
        s->fit_n[c]=120u;s->val_n[c]=80u;s->hdc_cm[c][c]=s->centroid_cm[c][c]=80u;
        for(k=0;k<2048u;k++)s->proto[c][k]=(int16_t)(k%241u-120);
        for(k=0;k<8u;k++)s->centroid_sum[c][k]=((uint64_t)c<<36)+k;
    }
    for(ch=0;ch<8u;ch++)s->scale[ch]=1000u+ch;
    s->stage=HDC_DONE;s->latest_valid=1u;s->seq_seen=1u;s->last_ms=987u;
}
static void footer_repair(model_mock_file *f)
{
    uint32_t c=hdc_model_crc(~0u,f->data,f->size-8u)^~0u,k;
    for(k=0;k<4u;k++)f->data[f->size-8u+k]=(unsigned char)(c>>(8u*k));
}
static void rejected(hdc_learning_t *active)
{
    hdc_model_io io={0};void *old=active->storage;uint32_t c=active->classes;
    int16_t p=active->proto[0][17];
    assert(hdc_model_restore(active,"HM000000.HDC",&io)!=0u);
    assert(active->storage==old && active->classes==c && active->proto[0][17]==p);
}
int main(void)
{
    hdc_learning_t a={0},b={0};hdc_model_io io={0};char name[13];uint32_t k,size;
    unsigned char *gold;model_mock_file *f;
    fixture(&a,8u);io.model=&a;io.shift=3u;for(k=0;k<13u;k++)io.calibration[k]=k;
    assert(sd_model_save(hdc_model_stream,&io,name)==0u && model_files[0].size==hdc_model_file_size(8u));
    fixture(&b,1u);assert(hdc_model_restore(&b,name,&io)==0u && b.classes==8u);
    assert(!b.latest_valid && !b.armed && !b.seq_seen && !b.accelerator_error && b.stage==HDC_DONE && io.shift==3u);
    for(k=0;k<a.classes;k++){
        assert(!memcmp(a.fit[k],b.fit[k],sizeof a.fit[k]));assert(!memcmp(a.proto[k],b.proto[k],sizeof a.proto[k]));
        assert(!memcmp(a.centroid_sum[k],b.centroid_sum[k],sizeof a.centroid_sum[k]));
        assert(!memcmp(a.hdc_cm[k],b.hdc_cm[k],a.classes*4u));
    }
    f=&model_files[0];size=f->size;gold=(unsigned char *)malloc(size+1u);assert(gold);memcpy(gold,f->data,size);
    /* Every header word plus representative body/footer/CRC mutations. */
    for(k=0;k<13u;k++){f->data[k*4u]^=1u;rejected(&b);memcpy(f->data,gold,size);}
    {uint32_t offsets[]={100u,211u,8000u,50000u,0u};for(k=0;k<4u;k++){
        f->data[offsets[k]]^=4u;rejected(&b);memcpy(f->data,gold,size);}}
    for(k=0;k<8u;k++){f->data[size-8u+k]^=1u;rejected(&b);memcpy(f->data,gold,size);}
    for(k=0;k<4u;k++){f->size=k==0u?0u:k==1u?51u:k==2u?size/2u:size-1u;rejected(&b);}f->size=size;
    f->data=(unsigned char *)realloc(f->data,size+1u);f->data[size]=0;f->size=size+1u;rejected(&b);f->size=size;
    /* Even a rechecksummed impossible count/prototype is rejected. */
    f->data[40]=255;f->data[41]=255;f->data[42]=255;f->data[43]=255;footer_repair(f);rejected(&b);memcpy(f->data,gold,size);
    /* First prototype begins at header+meta+class counts+fit. */
    k=13u*4u+8u*4u+13u*4u+8u*4u+16u+120u*8u*4u;
    f->data[k]=0xff;f->data[k+1u]=0x7f;footer_repair(f);rejected(&b);memcpy(f->data,gold,size);
    model_mock_error=7u;rejected(&b);model_mock_error=0u;
    model_mock_close_error=3u;rejected(&b);model_mock_close_error=0u;
    /* Failed validation persists as failed, not promoted on restore. */
    a.hdc_cm[0][0]=10u;a.hdc_cm[0][1]=70u;io.model=&a;
    assert(sd_model_save(hdc_model_stream,&io,name)==0u && hdc_model_restore(&b,name,&io)==0u && b.hdc_cm[0][0]==10u);
    assert(hdc_append(&b) && b.classes==9u && b.fit_n[7]==120u && !b.fit_n[8]);
    a.stage=HDC_VALIDATE;io.model=&a;assert(sd_model_save(hdc_model_stream,&io,name)==0x401u);
    /* Legacy Q16 models keep their original ROM/quantizer contract. */
    a.stage=HDC_DONE;a.levels=16u;io.model=&a;
    assert(sd_model_save(hdc_model_stream,&io,name)==0u);
    assert(hdc_model_restore(&b,name,&io)==0u && b.levels==16u);
    a.levels=32u;io.model=&a;
    assert(sd_model_save(hdc_model_stream,&io,name)==0u);
    assert(hdc_model_restore(&b,name,&io)==0u && b.levels==32u);
    puts("TEST_PASS HDC model Q16/Q32 contracts roundtrip without reinterpretation");
    free(gold);hdc_model_discard(&a);hdc_model_discard(&b);model_mock_reset();
    puts("TEST_PASS HDC model codec: 8-class exact samples/prototypes/centroids, schema bounds, CRC, truncation/trailing, close rollback, frozen validation, append after load");return 0;
}

