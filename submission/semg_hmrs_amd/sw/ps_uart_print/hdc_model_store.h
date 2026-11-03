#ifndef HDC_MODEL_STORE_H
#define HDC_MODEL_STORE_H
#include "hdc_learning.h"
#include "sd_record.h"
/* HMD1: explicit little endian fields, no pointers or ABI structure dumps.
 * Contract: ordered D2048, seed7 ROM, 4 kHz, final HP20/LP215 lane.
 * Q16 and Q32 have separate IDs; stored levels select the matching PL job.
 * Unknown ROM/config contracts are rejected rather than reinterpreted.
 * 0x07105004: every class is a user-defined custom gesture (no fixed base
 * classes) and the stored 5x5 base-gesture MLP reference table is gone.
 * 0x07105005: Q32 learning; Q16 prototypes remain Q16 when restored. */
#define HDC_MODEL_CONTRACT 0x07105004u
#define HDC_MODEL_CONTRACT_Q32 0x07105005u
typedef struct {
    hdc_learning_t *model;
    uint32_t shift,calibration[13],crc,writing;
} hdc_model_io;
static uint32_t hdc_model_crc(uint32_t crc,const unsigned char *p,uint32_t n)
{
    uint32_t i;while(n--){crc^=*p++;for(i=0;i<8u;i++)crc=(crc>>1)^((0u-(crc&1u))&0xedb88320u);}return crc;
}
/* Small fixed work buffer keeps DDR-sized models off the PS stack. */
static uint32_t hdc_model_values(hdc_model_io *io,void *values,uint32_t count,uint32_t width)
{
    unsigned char buffer[512],*p=(unsigned char *)values;uint32_t n,i,j,rc;uint64_t v;
    while(count){
        n=count>512u/width?512u/width:count;
        if(io->writing)for(i=0;i<n;i++){
            v=0u;memcpy(&v,p+i*width,width);
            for(j=0;j<width;j++)buffer[i*width+j]=(unsigned char)(v>>(j*8u));
        }
        rc=sd_model_transfer(buffer,n*width,io->writing);if(rc)return rc;
        io->crc=hdc_model_crc(io->crc,buffer,n*width);
        if(!io->writing)for(i=0;i<n;i++){
            v=0u;for(j=0;j<width;j++)v|=(uint64_t)buffer[i*width+j]<<(j*8u);
            memcpy(p+i*width,&v,width);
        }
        p+=n*width;count-=n;
    }
    return 0u;
}
static uint64_t hdc_model_file_size(uint32_t c)
{return 13u*4u+8u*4u+13u*4u+8u*4u+
    (uint64_t)c*(4u*4u+120u*8u*4u+2048u*2u+8u*8u+6u*4u+22u*4u)+(uint64_t)c*c*8u+8u;}
static uint32_t hdc_model_valid(const hdc_learning_t *s)
{
    uint32_t c,j,h,v;
    if(s->classes<1u || (s->levels!=16u && s->levels!=32u) || hdc_storage_size(s->classes)>HDC_STORAGE_BYTES)return 0u;
    for(c=0;c<s->classes;c++){
        if(s->fit_n[c]!=HDC_FIT_WINDOWS || s->val_n[c]!=HDC_VAL_WINDOWS ||
            s->hand_mapped[c]>1u || s->virtual_mapped[c]>1u)return 0u;
        h=v=0u;
        for(j=0;j<s->classes;j++){
            if(s->hdc_cm[c][j]>80u || s->centroid_cm[c][j]>80u)return 0u;
            h+=s->hdc_cm[c][j];v+=s->centroid_cm[c][j];
        }
        if(h!=80u || v!=80u)return 0u;
        for(j=0;j<HDC_D;j++)if(s->proto[c][j]<-120 || s->proto[c][j]>120)return 0u;
        if(s->hand_mapped[c])for(j=1u;j<6u;j++)
            if(s->hand_pose[c][j]<500u || s->hand_pose[c][j]>2500u)return 0u;
        if(s->virtual_mapped[c])for(j=0;j<22u;j++){
            int32_t low=j==0u?-70:j==19u?-100:j==1u || (j>=2u && j<18u && (j-2u)%4u==1u)?-30:0;
            int32_t high=j==0u?70:j==1u || j==19u || (j>=2u && j<18u && (j-2u)%4u==1u)?30:100;
            if(s->virtual_pose[c][j]<low || s->virtual_pose[c][j]>high)return 0u;
        }
    }
    return 1u;
}
static uint32_t hdc_model_stream(void *context,uint32_t writing)
{
    hdc_model_io *io=(hdc_model_io *)context;hdc_learning_t *s=io->model;
    uint32_t c,rc,header[13]={0x31444d48u,1u,HDC_MODEL_CONTRACT,HDC_D,8u,16u,7u,4000u,120u,80u,0u,0u,0u};
    uint32_t meta[8],footer[2],crc;
    io->writing=writing;io->crc=0xffffffffu;
    if(writing){
        if(io->shift>7u || s->stage!=HDC_DONE || s->armed || s->accelerator_error || !hdc_model_valid(s))return 0x401u;
        header[10]=s->classes;header[11]=(uint32_t)hdc_model_file_size(s->classes);header[12]=io->shift;
        header[5]=s->levels;header[2]=s->levels==32u?HDC_MODEL_CONTRACT_Q32:HDC_MODEL_CONTRACT;
    }
#define HM_VALUES(p,n,w) do{rc=hdc_model_values(io,p,n,w);if(rc)return rc;}while(0)
    HM_VALUES(header,13u,4u);
    if(!writing){
        if(header[0]!=0x31444d48u || header[1]!=1u ||
            !((header[2]==HDC_MODEL_CONTRACT && header[5]==16u) ||
              (header[2]==HDC_MODEL_CONTRACT_Q32 && header[5]==32u)) ||
            header[3]!=HDC_D || header[4]!=8u || header[6]!=7u || header[7]!=4000u ||
            header[8]!=120u || header[9]!=80u || header[10]<1u || header[12]>7u ||
            hdc_storage_size(header[10])>HDC_STORAGE_BYTES || header[11]!=hdc_model_file_size(header[10]))return 0x402u;
        if(!hdc_reserve(s,header[10]))return 0x403u;
        s->classes=header[10];s->levels=header[5];io->shift=header[12];
    }
    HM_VALUES(s->scale,8u,4u);HM_VALUES(io->calibration,13u,4u);
    if(writing){meta[0]=s->margin_sum;meta[1]=s->clip_values;meta[2]=s->validation_values;
        meta[3]=s->interruptions;meta[4]=s->saturated;meta[5]=s->completed_ms;meta[6]=meta[7]=0u;}
    HM_VALUES(meta,8u,4u);
    if(!writing){s->margin_sum=meta[0];s->clip_values=meta[1];s->validation_values=meta[2];
        s->interruptions=meta[3];s->saturated=meta[4];s->completed_ms=meta[5];}
    for(c=0;c<s->classes;c++){
        HM_VALUES(&s->fit_n[c],1u,4u);HM_VALUES(&s->val_n[c],1u,4u);
        HM_VALUES(&s->hand_mapped[c],1u,4u);HM_VALUES(&s->virtual_mapped[c],1u,4u);
        HM_VALUES(s->fit[c],120u*8u,4u);HM_VALUES(s->proto[c],HDC_D,2u);
        HM_VALUES(s->centroid_sum[c],8u,8u);HM_VALUES(s->hand_pose[c],6u,4u);
        HM_VALUES(s->virtual_pose[c],22u,4u);
        HM_VALUES(s->hdc_cm[c],s->classes,4u);HM_VALUES(s->centroid_cm[c],s->classes,4u);
    }
    crc=io->crc^0xffffffffu;footer[0]=crc;footer[1]=0x454e4f44u;
    HM_VALUES(footer,2u,4u);
#undef HM_VALUES
    if(!writing && (footer[0]!=crc || footer[1]!=0x454e4f44u || !hdc_model_valid(s)))return 0x404u;
    if(!writing)s->stage=HDC_DONE;
    return 0u;
}
static void hdc_model_discard(hdc_learning_t *s)
{
#if !defined(__arm__)
    free(s->storage);
#endif
    s->storage=0;
}
/* Current model is untouched until stream, EOF, checksum AND file close pass. */
static uint32_t hdc_model_restore(hdc_learning_t *active,const char *name,hdc_model_io *result)
{
    hdc_learning_t candidate={0};uint32_t rc;
    candidate.storage_bank=active->storage_bank;result->model=&candidate;
    rc=sd_model_load(name,hdc_model_stream,result);
    if(rc){hdc_model_discard(&candidate);result->model=active;return rc;}
    hdc_model_discard(active);*active=candidate;result->model=active;
    return 0u;
}
#endif

