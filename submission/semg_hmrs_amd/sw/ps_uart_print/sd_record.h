#ifndef SD_RECORD_H
#define SD_RECORD_H

#include <stdint.h>

#include "capture_actions.h"

int sd_record_start(void);
int sd_record_stop(void);
void sd_record_abort(uint32_t error);
int sd_record_append(uint16_t sequence, uint8_t action,
                     const int raw[8], const int notch[8]);
int sd_record_active(void);
int sd_record_ready(void);
int sd_record_error(void);
uint32_t sd_record_frames(void);
const char *sd_record_filename(void);
/* Save a completed training summary, never during an active waveform file.
 * CREATE_NEW preserves earlier reports. Returns zero on success. */
uint32_t sd_training_save(const char *data,uint32_t bytes,char name[13]);

/* HDC independent validation report, same no-overwrite policy. */
uint32_t sd_hdc_save(const char *data,uint32_t bytes,char name[13]);
/* Fixed-size, two-bank mechanical calibration journal. No output-enable state. */
uint32_t sd_hand_read(uint32_t slot,void *data,uint32_t bytes);
uint32_t sd_hand_write(uint32_t slot,const void *data,uint32_t bytes);

/* Streamed, versioned HDC snapshots. Separate from validation CSV. */
typedef uint32_t (*sd_model_stream_fn)(void *context,uint32_t writing);
typedef struct { uint32_t id; char name[13]; } sd_model_entry;
uint32_t sd_model_save(sd_model_stream_fn fn,void *context,char name[13]);
uint32_t sd_model_load(const char *name,sd_model_stream_fn fn,void *context);
uint32_t sd_model_transfer(void *data,uint32_t bytes,uint32_t writing);
/* after=0 starts at the first file; otherwise skip IDs below after. */
uint32_t sd_model_list(uint32_t after,sd_model_entry *entries,uint32_t capacity,
                       uint32_t *count,uint32_t *more);
#endif

