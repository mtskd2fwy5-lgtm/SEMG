#ifndef SD_RECORD_H
#define SD_RECORD_H

#include <stdint.h>

enum {
    SD_ACTION_NONE = 0,
    SD_ACTION_REST = 1,
    SD_ACTION_OPEN = 2,
    SD_ACTION_FIST = 3,
    SD_ACTION_FLEX = 4,
    SD_ACTION_EXTEND = 5
};

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

#endif
