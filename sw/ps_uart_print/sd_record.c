#include <stdint.h>
#include <string.h>
#include "sd_record.h"
#ifdef SD_RECORD_HOST_TEST
#include "../../sim/sd_record_platform_mock.h"
#else
#include "ff.h"
#include "diskio.h"
#include "xsdps.h"
#endif

#define SD0_BASE 0xE0100000u
#define SD0_INPUT_CLOCK 100000000u
#define SD_WRITE_BATCH_FRAMES 256u
#define SD_FRAME_BYTES 52u

static XSdPs sd0;
static XSdPs_Config sd0_cfg = {
    0u, SD0_BASE, SD0_INPUT_CLOCK, 0u, 0u, 4u, 0u, 0u,
    XSDPS_SLOT_REM, 0u, 0u, 0u, 0u, 0u, 0u, 0u, 0u
};
static FATFS sd_fs;
static FIL sd_file;
static uint8_t sd_batch[SD_WRITE_BATCH_FRAMES * SD_FRAME_BYTES];
static uint32_t sd_batch_frames, sd_total_frames;
static uint32_t sd_ready, sd_active, sd_error;
static uint32_t sd_file_open, sd_synced_frames;
static uint16_t sd_last_sequence;
static uint8_t sd_have_sequence;
#ifdef _MSC_VER
__declspec(align(32)) static uint8_t sd_bounce[4096];
#else
static uint8_t sd_bounce[4096] __attribute__((aligned(32)));
#endif
extern void acquisition_service(void);
static char sd_name[13] = "EMG000.BIN";

u32 Xil_WaitForEvent(UINTPTR address,u32 mask,u32 event,u32 timeout)
{
    while (timeout--) {
        acquisition_service();
        if ((Xil_In32(address)&mask)==event) return XST_SUCCESS;
        usleep(1u);
    }
    return XST_FAILURE;
}

u32 Xil_WaitForEvents(UINTPTR address,u32 mask,u32 wait_events,
                      u32 timeout,u32 *events)
{
    while (timeout--) {
        acquisition_service();
        u32 current=Xil_In32(address)&mask;
        if (current&wait_events) { *events=current; return XST_SUCCESS; }
        usleep(1u);
    }
    *events=0u;
    return XST_TIMEOUT;
}

void Xil_DCacheFlushRange(INTPTR address, u32 bytes)
{
#if defined(__arm__)
    UINTPTR p=(UINTPTR)address & ~(UINTPTR)31u;
    UINTPTR end=(UINTPTR)address+bytes;
    for (;p<end;p+=32u)
        __asm__ volatile("mcr p15, 0, %0, c7, c10, 1" :: "r"(p) : "memory");
    __asm__ volatile("dsb sy" ::: "memory");
#else
    (void)address; (void)bytes;
#endif
}

void Xil_DCacheInvalidateRange(INTPTR address, u32 bytes)
{
#if defined(__arm__)
    UINTPTR start=(UINTPTR)address, end=start+bytes;
    UINTPTR p=start & ~(UINTPTR)31u;
    if (!bytes) return;
    /* Preserve dirty bytes outside an unaligned DMA range. The SD data
     * path uses aligned bounce storage; short driver control buffers still
     * require the BSP's clean+invalidate boundary semantics. */
    if (start&31u) {
        __asm__ volatile("mcr p15, 0, %0, c7, c14, 1" :: "r"(p) : "memory");
        p+=32u;
    }
    for (;p+32u<=end;p+=32u)
        __asm__ volatile("mcr p15, 0, %0, c7, c6, 1" :: "r"(p) : "memory");
    if (p<end)
        __asm__ volatile("mcr p15, 0, %0, c7, c14, 1" :: "r"(p) : "memory");
    __asm__ volatile("dsb sy" ::: "memory");
#else
    (void)address; (void)bytes;
#endif
}

static int sd_card_init(void)
{
    if (sd_ready) return 1;
    memset(&sd0, 0, sizeof sd0);
    if (XSdPs_CfgInitialize(&sd0, &sd0_cfg, SD0_BASE) != XST_SUCCESS)
        return 0;
    if (XSdPs_CardInitialize(&sd0) != XST_SUCCESS)
        return 0;
    sd_ready = 1u;
    return 1;
}

static int sd_mount(void)
{
    if (!sd_card_init()) return 0;
    return f_mount(&sd_fs, "0:/", 1u) == FR_OK;
}

uint32_t sd_training_save(const char *data,uint32_t bytes,char name[13])
{
    FIL report_file;
    UINT written=0u;
    FRESULT rc,close_rc;
    unsigned n;
    if(sd_active || sd_file_open)return 0x301u;
    if(!data || !bytes || bytes>16384u || !name)return 0x302u;
    if(!sd_mount())return 0x300u;
    memcpy(name,"RH000.CSV",10u);
    for(n=0u;n<1000u;n++) {
        name[2]=(char)('0'+n/100u);
        name[3]=(char)('0'+(n/10u)%10u);
        name[4]=(char)('0'+n%10u);
        rc=f_open(&report_file,name,FA_CREATE_NEW|FA_WRITE);
        if(rc==FR_OK)break;
        if(rc!=FR_EXIST)return (uint32_t)rc+1u;
    }
    if(n==1000u)return 0x303u;
    rc=f_write(&report_file,data,bytes,&written);
    if(rc==FR_OK && written!=bytes) {f_close(&report_file);return 0x304u;}
    if(rc==FR_OK)rc=f_sync(&report_file);
    close_rc=f_close(&report_file);
    if(rc==FR_OK)rc=close_rc;
    return rc==FR_OK?0u:(uint32_t)rc+1u;
}

static int sd_flush(void)
{
    UINT written = 0u;
    FRESULT rc;
    UINT bytes = (UINT)(sd_batch_frames * SD_FRAME_BYTES);
    if (!sd_batch_frames) return 1;
    rc = f_write(&sd_file, sd_batch, bytes, &written);
    sd_batch_frames = 0u; /* A partial write must never be retried as a whole. */
    if (rc != FR_OK || written != bytes) {
        sd_record_abort(rc==FR_OK?0x103u:(uint32_t)rc+1u);
        return 0;
    }
    if (sd_total_frames-sd_synced_frames>=4000u) {
        rc=f_sync(&sd_file);
        if (rc!=FR_OK) { sd_record_abort((uint32_t)rc+1u); return 0; }
        sd_synced_frames=sd_total_frames;
    }
    return 1;
}

static void sd_put32(uint8_t *p, uint32_t v)
{
    p[0]=(uint8_t)v; p[1]=(uint8_t)(v>>8);
    p[2]=(uint8_t)(v>>16); p[3]=(uint8_t)(v>>24);
}

static void sd_put24(uint8_t *p, int32_t v)
{
    uint32_t u=(uint32_t)v & 0xFFFFFFu;
    p[0]=(uint8_t)u; p[1]=(uint8_t)(u>>8); p[2]=(uint8_t)(u>>16);
}

int sd_record_start(void)
{
    uint8_t header[512];
    UINT written=0u;
    unsigned n;
    FRESULT rc;
    if (sd_active) return 1;
    sd_error=sd_total_frames=sd_batch_frames=sd_synced_frames=0u;
    if (!sd_mount()) { sd_error=0x100u; return 0; }
    for (n=0u;n<1000u;n++) {
        sd_name[3]=(char)('0'+(n/100u)%10u);
        sd_name[4]=(char)('0'+(n/10u)%10u);
        sd_name[5]=(char)('0'+n%10u);
        rc=f_open(&sd_file,sd_name,FA_CREATE_NEW|FA_WRITE);
        if (rc==FR_OK) break;
        if (rc!=FR_EXIST) { sd_error=(uint32_t)rc+1u; return 0; }
    }
    if (n==1000u) { sd_error=0x101u; return 0; }
    sd_file_open=1u;
    memset(header,0,sizeof header);
    memcpy(header,"SEMGSD1",7u);
    sd_put32(header+8u,2u);             /* v2 identifies the filtered lane */
    sd_put32(header+12u,4000u);         /* samples per channel */
    sd_put32(header+16u,8u);            /* channels */
    sd_put32(header+20u,SD_FRAME_BYTES);
    sd_put32(header+24u,1u);            /* int24 little endian */
    sd_put32(header+28u,2u);            /* raw and filtered */
    sd_put32(header+32u,3u);            /* 3 = notch + comb + HP20/LP215 */
    if (f_write(&sd_file,header,sizeof header,&written)!=FR_OK ||
        written!=sizeof header) {
        sd_record_abort(0x102u);
        return 0;
    }
    sd_total_frames=0u;
    sd_batch_frames=0u;
    sd_error=0u;
    sd_active=1u;
    sd_have_sequence=0u;
    return 1;
}

int sd_record_stop(void)
{
    FRESULT rc, close_rc;
    if (!sd_active) return sd_error==0u;
    if (!sd_flush()) return 0;
    rc=f_sync(&sd_file);
    close_rc=f_close(&sd_file);
    sd_file_open=0u;
    if (rc==FR_OK) rc=close_rc;
    sd_active=0u;
    if (rc!=FR_OK) { sd_error=(uint32_t)rc+1u; return 0; }
    return 1;
}

void sd_record_abort(uint32_t error)
{
    sd_active=0u;
    sd_batch_frames=0u;
    sd_error=error?error:0x104u;
    if (sd_file_open) { f_close(&sd_file); sd_file_open=0u; }
}

int sd_record_append(uint16_t sequence, uint8_t action,
                     const int raw[8], const int notch[8])
{
    uint8_t *p;
    uint32_t ch;
    if (!sd_active || sd_error) return 0;
    /* Never silently save replayed or out-of-order frames as fresh samples.
     * Forward loss and normal uint16 wrap remain visible in saved sequences. */
    if (sd_have_sequence) {
        uint16_t step=(uint16_t)(sequence-sd_last_sequence);
        if (step==0u || step>=0x8000u) { sd_record_abort(0x105u); return 0; }
    }
    if (sd_batch_frames==SD_WRITE_BATCH_FRAMES && !sd_flush()) return 0;
    p=&sd_batch[sd_batch_frames*SD_FRAME_BYTES];
    p[0]=(uint8_t)sequence; p[1]=(uint8_t)(sequence>>8);
    p[2]=action; p[3]=0u;
    p+=4;
    for (ch=0u;ch<8u;ch++,p+=3) sd_put24(p,raw[ch]);
    for (ch=0u;ch<8u;ch++,p+=3) sd_put24(p,notch[ch]);
    sd_batch_frames++;
    sd_total_frames++;
    sd_last_sequence=sequence;
    sd_have_sequence=1u;
    return 1;
}

int sd_record_active(void) { return (int)sd_active; }
int sd_record_ready(void) { return (int)sd_ready; }
int sd_record_error(void) { return (int)sd_error; }
uint32_t sd_record_frames(void) { return sd_total_frames; }
const char *sd_record_filename(void) { return sd_name; }

DSTATUS disk_status(BYTE pdrv)
{
    return pdrv==0u && sd_ready ? 0u : STA_NOINIT;
}

DSTATUS disk_initialize(BYTE pdrv)
{
    return pdrv==0u && sd_card_init() ? 0u : STA_NOINIT;
}

DRESULT disk_read(BYTE pdrv, BYTE *buff, LBA_t sector, UINT count)
{
    UINT chunk;
    if (!buff || !count) return RES_PARERR;
    if (pdrv!=0u || !sd_card_init()) return RES_NOTRDY;
    while (count) {
        chunk=count>8u?8u:count;
        if (XSdPs_ReadPolled(&sd0,(uint32_t)(sd0.HCS?sector:sector*512u),
                            chunk,sd_bounce)!=XST_SUCCESS) return RES_ERROR;
        memcpy(buff,sd_bounce,chunk*512u);
        buff+=chunk*512u; sector+=chunk; count-=chunk;
        acquisition_service();
    }
    return RES_OK;
}

DRESULT disk_write(BYTE pdrv, const BYTE *buff, LBA_t sector, UINT count)
{
    UINT chunk;
    if (!buff || !count) return RES_PARERR;
    if (pdrv!=0u || !sd_card_init()) return RES_NOTRDY;
    while (count) {
        chunk=count>8u?8u:count;
        memcpy(sd_bounce,buff,chunk*512u);
        if (XSdPs_WritePolled(&sd0,(uint32_t)(sd0.HCS?sector:sector*512u),
                             chunk,sd_bounce)!=XST_SUCCESS) return RES_ERROR;
        buff+=chunk*512u; sector+=chunk; count-=chunk;
        acquisition_service();
    }
    return RES_OK;
}

DRESULT disk_ioctl(BYTE pdrv, BYTE cmd, void *buff)
{
    if (pdrv!=0u || !sd_card_init()) return RES_NOTRDY;
    if (cmd==CTRL_SYNC) return RES_OK;
    if (!buff) return RES_PARERR;
    if (cmd==GET_SECTOR_COUNT) { *(LBA_t *)buff=sd0.SectorCount; return RES_OK; }
    if (cmd==GET_SECTOR_SIZE) { *(WORD *)buff=512u; return RES_OK; }
    if (cmd==GET_BLOCK_SIZE) { *(DWORD *)buff=1u; return RES_OK; }
    return RES_PARERR;
}

DWORD get_fattime(void)
{
    return ((DWORD)(2026u-1980u)<<25) | (1u<<21) | (1u<<16);
}
