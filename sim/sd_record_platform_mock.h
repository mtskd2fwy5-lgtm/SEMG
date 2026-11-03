#ifndef SD_RECORD_PLATFORM_MOCK_H
#define SD_RECORD_PLATFORM_MOCK_H
#include <stdint.h>
typedef uint32_t u32, UINT, DWORD, LBA_t;
typedef uint16_t WORD;
typedef uint8_t BYTE, DSTATUS;
typedef uintptr_t UINTPTR;
typedef intptr_t INTPTR;
typedef int FRESULT, DRESULT;
typedef struct { int unused; } FATFS, FIL;
typedef struct { uint32_t index; } DIR;
typedef struct { char fname[64];BYTE fattrib; } FILINFO;
typedef struct { uint32_t HCS, SectorCount; } XSdPs;
typedef struct { uint32_t v[17]; } XSdPs_Config;
enum { XST_SUCCESS=0, XST_FAILURE=1, XST_TIMEOUT=2, XSDPS_SLOT_REM=0,
       AM_DIR=16, FR_OK=0, FR_DISK_ERR=1, FR_EXIST=8, FR_DENIED=7,
       FA_CREATE_NEW=4, FA_CREATE_ALWAYS=8, FA_READ=1, FA_WRITE=2, STA_NOINIT=1,
       RES_OK=0, RES_ERROR=1, RES_NOTRDY=3, RES_PARERR=4,
       CTRL_SYNC=0, GET_SECTOR_COUNT=1, GET_SECTOR_SIZE=2, GET_BLOCK_SIZE=3 };
u32 Xil_In32(UINTPTR address);
void usleep(unsigned long microseconds);
int XSdPs_CfgInitialize(XSdPs *, XSdPs_Config *, uint32_t);
int XSdPs_CardInitialize(XSdPs *);
int XSdPs_ReadPolled(XSdPs *,uint32_t,UINT,BYTE *);
int XSdPs_WritePolled(XSdPs *,uint32_t,UINT,const BYTE *);
FRESULT f_mount(FATFS *,const char *,BYTE);
FRESULT f_open(FIL *,const char *,BYTE);
FRESULT f_write(FIL *,const void *,UINT,UINT *);
FRESULT f_read(FIL *,void *,UINT,UINT *);
FRESULT f_sync(FIL *);
FRESULT f_close(FIL *);
FRESULT f_opendir(DIR *,const char *);
FRESULT f_readdir(DIR *,FILINFO *);
FRESULT f_closedir(DIR *);
#endif
