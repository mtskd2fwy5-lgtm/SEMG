#ifndef HAND_CONTROL_H
#define HAND_CONTROL_H
/* PS configures/calibrates; PL executes. Base classes and frozen HDC are
 * explicitly selected sources; MPU rotation has an independent lease. */
#include <stdint.h>
#include <string.h>
typedef struct {
    uint32_t magic,version,generation,crc;
    uint32_t low[6],high[6],pose[8][6],cal_mask,row_mask;
} HandProfile;
static HandProfile hand_profile;
static uint32_t hand_status_word,hand_link_error,hand_io_error;
static uint32_t hand_axis,hand_row,hand_pulse=1500u,hand_view_mode;
static uint32_t hand_storage_action;
static uint32_t hand_queue[96],hand_qread,hand_qwrite,hand_inflight;
static uint32_t hand_toggle,hand_initialized,hand_sent_ms,hand_lease_ms;
static uint32_t hand_run,hand_test_until,hand_stop_pending;
static uint32_t hand_manual_pending,hand_manual_axis,hand_manual_value,hand_slider_drag;
static uint32_t hand_clearing;
enum { HAND_HOME_IDLE,HAND_HOME_WAIT,HAND_HOME_DRIVE,HAND_HOME_DONE,
       HAND_HOME_SKIPPED,HAND_HOME_CANCELED };
static uint32_t hand_home_state,hand_home_step,hand_home_until;
static uint32_t hand_home_target[6];
static int32_t hand_rotation_deg;
static uint32_t hand_rotation_valid,hand_rotation_sent;
static uint32_t hand_rotation_sent_ms;
static uint32_t hand_hdc_valid,hand_hdc_class;
static uint32_t hand_hdc_history[8],hand_hdc_history_ok[8],hand_hdc_head,hand_hdc_size;
static uint32_t hand_hdc_generation,hand_hdc_sent_generation,hand_hdc_ms,hand_hdc_hold,hand_hdc_support_ms;
static uint32_t hand_hdc_seq_seen;
static uint16_t hand_hdc_seq;
/* The enabled mechanical link owns a last accepted, calibrated target.
 * Classifier abstention may clear the live UI decision without disarming it. */
static uint32_t hand_hdc_target[6],hand_hdc_target_valid,hand_hdc_target_class;
static uint32_t hand_hdc_target_ms;
/* Mode 4 reuses the PL live-target executor (wire mode 3), with PL NMF C2
 * rather than an HDC class as its source. No change to the PWM protocol. */
static uint32_t hand_grip_valid,hand_grip_seen,hand_grip_seq,hand_grip_ms;
static uint32_t hand_grip_percent,hand_grip_generation,hand_grip_sent_generation;
static uint32_t hand_grip_sent_ms,hand_grip_capturing;
static uint32_t hand_hdc_get_pose(uint32_t cls,uint32_t pose[6]);
static uint32_t hand_crc(const HandProfile *p)
{
    const unsigned char *b=(const unsigned char *)p;
    uint32_t crc=~0u,i,k;
    for(i=0;i<sizeof(*p);i++) {
        crc^=(i>=12u && i<16u)?0u:b[i];
        for(k=0;k<8u;k++)crc=(crc>>1)^(0xedb88320u & (0u-(crc&1u)));
    }
    return ~crc;
}
static void hand_profile_init(void)
{
    uint32_t i,j;memset(&hand_profile,0,sizeof hand_profile);
    hand_profile.magic=0x48414e44u;hand_profile.version=1u;
    for(i=0;i<6u;i++) {
        hand_profile.low[i]=hand_profile.high[i]=1500u;
        for(j=0;j<8u;j++)hand_profile.pose[j][i]=1500u;
    }
}
static uint32_t hand_profile_valid(const HandProfile *p)
{
    uint32_t i,j;
    if(p->magic!=0x48414e44u || p->version!=1u || p->crc!=hand_crc(p) ||
       p->cal_mask>4095u || p->row_mask>255u)return 0u;
    for(i=0;i<6u;i++) {
        if(p->low[i]<500u || p->low[i]>2500u || p->high[i]<500u || p->high[i]>2500u)return 0u;
        if((p->cal_mask&(1u<<i)) && (p->cal_mask&(64u<<i)) && p->low[i]>p->high[i])return 0u;
        for(j=0;j<8u;j++) {
            uint32_t v=p->pose[j][i];
            if(v<500u || v>2500u)return 0u;
            if((p->row_mask&(1u<<j)) && (p->cal_mask!=4095u ||
               (i && (v<p->low[i] || v>p->high[i]))))return 0u;
        }
    }
    return 1u;
}
static uint32_t hand_word(uint32_t op,uint32_t row,uint32_t axis,uint32_t value)
{return (op<<27)|(row<<24)|(axis<<16)|value;}
static uint32_t hand_busy(void)
{return hand_run || hand_inflight || hand_stop_pending || hand_qread!=hand_qwrite ||
       hand_home_state==HAND_HOME_WAIT || hand_home_state==HAND_HOME_DRIVE ||
       ((hand_status_word>>19)&3u);}
static void hand_stop(void)
{
    if(hand_home_state==HAND_HOME_WAIT || hand_home_state==HAND_HOME_DRIVE ||
       hand_home_state==HAND_HOME_DONE)
        hand_home_state=HAND_HOME_CANCELED;
    hand_run=0u;hand_qread=hand_qwrite=0u;
    hand_hdc_target_valid=0u;
    hand_manual_pending=hand_slider_drag=0u;
#if PL_CONTROL_ENABLE
    hand_stop_pending=1u;
#else
    hand_stop_pending=hand_inflight=0u;
#endif
}
static void hand_hdc_history_reset(void)
{
    hand_hdc_valid=hand_hdc_size=hand_hdc_head=hand_hdc_hold=0u;
}
static void hand_hdc_reset(void)
{
    hand_hdc_seq_seen=0u;hand_hdc_history_reset();
    if(hand_run==3u)hand_stop();
}
static void hand_grip_observe(uint32_t now,uint16_t seq,uint32_t c2,
                              uint32_t reference,uint32_t cls,uint32_t valid)
{
    uint32_t continuous=!hand_grip_seen ||
        ((uint16_t)(seq-hand_grip_seq)==40u && now-hand_grip_ms<=75u);
    if(hand_grip_seen && seq==hand_grip_seq)return;
    hand_grip_seen=1u;hand_grip_seq=seq;hand_grip_ms=now;
    hand_grip_valid=valid && reference>=256u && continuous;
    hand_grip_percent=0u;
    if(hand_grip_valid && cls==2u) {
        uint64_t scaled=(uint64_t)c2*1000u/reference;
        /* Ten percent dead band; comfortable reference is full mapped grip. */
        if(scaled>100u)hand_grip_percent=scaled>=1000u?100u:(uint32_t)((scaled-100u)/9u);
    }
    if(hand_grip_valid)hand_grip_generation++;
    else if(hand_run==4u)hand_stop();
}
static uint32_t hand_grip_mapped(void)
{
    uint32_t i,j;
    if(hand_profile.cal_mask!=4095u || (hand_profile.row_mask&5u)!=5u)return 0u;
    for(j=0u;j<3u;j+=2u)for(i=1u;i<6u;i++)
        if(hand_profile.low[i]>hand_profile.high[i] ||
           hand_profile.pose[j][i]<hand_profile.low[i] ||
           hand_profile.pose[j][i]>hand_profile.high[i])return 0u;
    return 1u;
}
static uint32_t hand_grip_pulse(uint32_t axis,uint32_t percent)
{
    int32_t open=(int32_t)hand_profile.pose[0][axis];
    int32_t delta=(int32_t)hand_profile.pose[2][axis]-open;
    if(percent>100u)percent=100u;
    return (uint32_t)(open+delta*(int32_t)percent/100);
}
/* Evidence: 0 = invalid model/data (immediate STOP), 1 = qualified prediction
 * (margin >= 1%), 2 = abstention, 3 = weak but nonzero gap (>=0.25%).
 * Weak evidence needs six of eight agreeing windows with a three-vote lead.
 * Votes never modify
 * training/validation results.
 * Confirm 3 of the last 6 qualified windows, including the current window,
 * with two votes ahead of any rival, or three consecutive strong predictions,
 * to reject a 3:3 oscillation without delaying clean gesture transitions.
 * While the feature stream remains fresh, ambiguity holds the last accepted
 * mapped pose; the independent 250 ms stream watchdog still stops on dropout. */
static void hand_hdc_observe(uint32_t now,uint16_t seq,uint32_t cls,uint32_t evidence)
{
    /* Every custom class uses the same evidence-dependent rule. No class ID
     * is implicitly treated as rest or granted a special acceptance path. */
    uint32_t i,j,votes=0u,rival=0u,consecutive=1u,width=evidence==3u?8u:6u;
    uint32_t qualified=evidence==1u || evidence==3u,required=evidence==3u?6u:3u;
    if(!evidence || evidence>3u) {hand_hdc_reset();return;}
    if(hand_hdc_seq_seen && now-hand_hdc_ms>250u) {
        hand_hdc_reset();
    } else if(hand_hdc_seq_seen && (uint16_t)(seq-hand_hdc_seq)!=40u) {
        /* A skipped classifier window restarts transition voting, but does
         * not cancel a fresh, already accepted live target. The timestamp
         * watchdog below remains the hard dropout boundary. */
        if(hand_run==3u)hand_hdc_history_reset();
        else hand_hdc_reset();
    }
    hand_hdc_seq_seen=1u;hand_hdc_seq=seq;hand_hdc_ms=now;
    hand_hdc_history[hand_hdc_head]=cls;
    hand_hdc_history_ok[hand_hdc_head]=qualified?evidence:0u;
    hand_hdc_head=(hand_hdc_head+1u)%8u;
    if(hand_hdc_size<8u)hand_hdc_size++;
    if(hand_hdc_size<3u)consecutive=0u;
    for(i=0u;i<hand_hdc_size && i<width;i++) {
        uint32_t slot=(hand_hdc_head+7u-i)%8u;
        uint32_t usable=hand_hdc_history_ok[slot]==1u ||
            (evidence==3u && hand_hdc_history_ok[slot]==3u);
        if(i<3u && (hand_hdc_history_ok[slot]!=1u || hand_hdc_history[slot]!=cls))consecutive=0u;
        if(usable && hand_hdc_history[slot]==cls)votes++;
        else if(usable) {
            uint32_t n=0u;
            for(j=0u;j<hand_hdc_size && j<width;j++) {
                uint32_t other=(hand_hdc_head+7u-j)%8u;
                if((hand_hdc_history_ok[other]==1u || (evidence==3u && hand_hdc_history_ok[other]==3u)) &&
                   hand_hdc_history[other]==hand_hdc_history[slot])n++;
            }
            if(n>rival)rival=n;
        }
    }
    if(qualified && votes>=required && (votes>=rival+(evidence==3u?3u:2u) || consecutive)) {
        hand_hdc_class=cls;hand_hdc_valid=1u;hand_hdc_hold=0u;hand_hdc_support_ms=now;
    } else if(hand_hdc_valid && (++hand_hdc_hold>=10u || now-hand_hdc_support_ms>=250u)) {
        /* Expire the displayed decision, not the explicitly enabled link. */
        hand_hdc_history_reset();return;
    }
    if(hand_hdc_valid)hand_hdc_generation++;
}
static uint32_t hand_enqueue(uint32_t op,uint32_t row,uint32_t axis,uint32_t value)
{
    if(hand_qwrite>=96u){hand_link_error=2u;hand_stop();return 0u;}
    hand_queue[hand_qwrite++]=hand_word(op,row,axis,value);return 1u;
}
static void hand_upload(void)
{
    uint32_t i,j;
    hand_stop();hand_link_error=0u;
    // Legacy profiles may contain wrist rows and an axis-0 gesture target.
    // Keep the on-disk format, but discard wrist rows and ignore pose axis 0.
    hand_profile.row_mask&=7u;
    for(i=0;i<6u;i++) {
        if(hand_profile.cal_mask&(1u<<i))hand_enqueue(1u,i,0u,hand_profile.low[i]);
        if(hand_profile.cal_mask&(64u<<i))hand_enqueue(2u,i,0u,hand_profile.high[i]);
    }
    for(j=0;j<3u;j++)if(hand_profile.row_mask&(1u<<j)) {
        for(i=0;i<6u;i++)hand_enqueue(3u,j,i,i?hand_profile.pose[j][i]:
                                    (hand_profile.low[0]+hand_profile.high[0])/2u);
        hand_enqueue(4u,j,0u,1u);
    }
}
static void hand_test(uint32_t now)
{
    if(hand_home_state==HAND_HOME_WAIT || hand_home_state==HAND_HOME_DRIVE ||
       hand_home_state==HAND_HOME_DONE)return;
    if(hand_axis>=6u || hand_pulse<500u || hand_pulse>2500u || hand_run>=2u)return;
    if(hand_run==1u) {
        if(hand_axis!=hand_manual_axis)return;
    } else {
        if(hand_busy())return;
        hand_link_error=0u;hand_stop_pending=1u;
        hand_manual_pending=1u;
        hand_manual_axis=hand_axis;hand_run=1u;hand_lease_ms=now;
    }
    /* One coalesced latest target, independent of the held-until-ACK word. */
    if(hand_manual_value!=hand_pulse)
        hand_manual_pending=1u;
    hand_manual_value=hand_pulse;hand_test_until=now+1000u;
}
static void hand_home_request(void)
{
    uint32_t i,valid=hand_profile.cal_mask==4095u && (hand_profile.row_mask&1u);
    /* Same measured pulse/angle relationship as the live MPU mapping.
     * This fixed zero does not require a fresh sensor or classifier result. */
    hand_home_target[0]=500u+(45u*2000u+135u)/270u;
    for(i=1u;i<6u;i++)hand_home_target[i]=hand_profile.pose[0][i];
    for(i=0u;i<6u;i++)
        if(hand_profile.low[i]<500u || hand_profile.high[i]>2500u ||
           hand_profile.low[i]>hand_profile.high[i] ||
           hand_home_target[i]<hand_profile.low[i] ||
           hand_home_target[i]>hand_profile.high[i])valid=0u;
    hand_stop();
    if(!valid){hand_home_state=HAND_HOME_SKIPPED;return;}
    hand_upload();hand_home_step=0u;hand_home_state=HAND_HOME_WAIT;
}
static void hand_auto(void)
{
    if(hand_busy() || hand_profile.cal_mask!=4095u ||
       (hand_profile.row_mask&7u)!=7u || !hand_rotation_valid)return;
    hand_rotation_sent=0xffffffffu;
    hand_upload();hand_enqueue(9u,0u,0u,0u);hand_enqueue(6u,0u,0u,0u);hand_run=2u;
}
static void hand_live_queue_target(const uint32_t p[6])
{
    uint32_t i;
    for(i=1u;i<6u;i++)hand_enqueue(12u,0u,i,p[i]);
    hand_enqueue(13u,0u,0u,0u);
}
static uint32_t hand_hdc_queue_target(void)
{
    uint32_t p[6];
    if(hand_hdc_valid && hand_hdc_get_pose(hand_hdc_class,p)) {
        memcpy(hand_hdc_target,p,sizeof hand_hdc_target);
        hand_hdc_target_class=hand_hdc_class;hand_hdc_target_valid=1u;
    }
    if(!hand_hdc_target_valid)return 0u;
    hand_live_queue_target(hand_hdc_target);
    hand_hdc_target_ms=hand_hdc_ms;
    hand_hdc_sent_generation=hand_hdc_generation;return 1u;
}
static void hand_grip_queue_target(uint32_t now)
{
    uint32_t i,p[6]={0u};
    for(i=1u;i<6u;i++)p[i]=hand_grip_pulse(i,hand_grip_percent);
    hand_live_queue_target(p);
    hand_grip_sent_generation=hand_grip_generation;hand_grip_sent_ms=now;
}
static void hand_auto_grip(uint32_t now)
{
    if(hand_busy() || !hand_grip_mapped() || !hand_rotation_valid ||
       !hand_grip_valid || now-hand_grip_ms>75u || hand_grip_capturing)return;
    hand_upload();hand_enqueue(9u,0u,0u,0u);
    hand_grip_queue_target(now);hand_enqueue(11u,0u,0u,1u);hand_run=4u;
}
static void hand_auto_hdc(void)
{
    uint32_t p[6];
    if(hand_busy() || hand_profile.cal_mask!=4095u || !hand_rotation_valid ||
       !hand_hdc_valid || !hand_hdc_get_pose(hand_hdc_class,p))return;
    hand_upload();hand_enqueue(9u,0u,0u,0u);
    hand_hdc_queue_target();hand_enqueue(11u,0u,0u,1u);hand_run=3u;
}
static void hand_tick(uint32_t now,uint32_t manual_page,int32_t rotation_deg,uint32_t rotation_valid)
{
#if PL_CONTROL_ENABLE
    uint32_t w=MMIO32(0x41250008u),payload=0u,send=0u;
    uint32_t rotation_us=1500u;
    int32_t angle=rotation_deg;
    // User measured 500..2500 us = 0..270 deg. Relative home is
    // absolute 45 deg: left -45, right +225; calibrated limits clamp it.
    if(angle>225)angle=225;
    if(angle< -45)angle=-45;
    if(hand_profile.cal_mask==4095u && hand_profile.low[0]<=hand_profile.high[0]) {
        rotation_us=500u+((uint32_t)(angle+45)*2000u+135u)/270u;
        if(rotation_us<hand_profile.low[0])rotation_us=hand_profile.low[0];
        if(rotation_us>hand_profile.high[0])rotation_us=hand_profile.high[0];
    }
    hand_rotation_deg=rotation_deg;hand_rotation_valid=rotation_valid;
    hand_status_word=w;
    if((hand_home_state==HAND_HOME_WAIT || hand_home_state==HAND_HOME_DRIVE ||
        hand_home_state==HAND_HOME_DONE) &&
       (w&((1u<<22)|(1u<<21))))hand_stop();
    if(hand_run>=2u && !rotation_valid)hand_stop();
    if(hand_run==3u) {
        uint32_t p[6];
        if(!hand_hdc_seq_seen || now-hand_hdc_ms>250u || !hand_hdc_target_valid ||
           !hand_hdc_get_pose(hand_hdc_target_class,p))hand_stop();
    }
    if(hand_run==4u && (!hand_grip_valid || now-hand_grip_ms>75u ||
                       !hand_grip_mapped()))hand_stop();
    if(hand_run==1u && hand_home_state!=HAND_HOME_DRIVE && hand_home_state!=HAND_HOME_DONE &&
       (!manual_page || (int32_t)(now-hand_test_until)>=0))hand_stop();
    if((w>>24)!=0x48u) {hand_link_error=1u;hand_stop();return;}
    if(!hand_initialized) {
        hand_toggle=MMIO32(0x41250000u)>>31;
        hand_initialized=1u;hand_stop_pending=1u;
    }
    if(hand_inflight) {
        if(((w>>23)&1u)==hand_toggle)hand_inflight=0u;
        else if(now-hand_sent_ms>100u) {
            hand_link_error=3u;hand_stop();return;
        } else return;
    }
    if(hand_home_state==HAND_HOME_DRIVE || hand_home_state==HAND_HOME_DONE) {
        /* ACK and group-enable share one coherent status word. A reset or
         * lost home mode must not silently restart from stale targets. */
        if(((w>>19)&3u)!=1u || !(w&1u))hand_stop();
        else if(hand_home_state==HAND_HOME_DRIVE && (w&(1u<<18)) &&
                (int32_t)(now-hand_home_until)>=0)
            hand_home_state=HAND_HOME_DONE;
        /* DONE means the target has been sent; without position feedback it
         * is not physical arrival. Keep all six PWM targets until STOP. */
    }
    if(hand_clearing) {
        if(w&((1u<<22)|(1u<<21)))return;
        hand_clearing=0u;
    }
    if(!hand_stop_pending && (w&((1u<<22)|(1u<<21)))) {
        if(hand_home_state==HAND_HOME_WAIT || hand_home_state==HAND_HOME_DRIVE ||
           hand_home_state==HAND_HOME_DONE)
            hand_home_state=HAND_HOME_CANCELED;
        hand_run=0u;hand_manual_pending=hand_slider_drag=0u;
        hand_qread=hand_qwrite=0u;return;
    }
    if(hand_stop_pending) {
        payload=0u;hand_stop_pending=0u;hand_clearing=1u;send=1u;
    } else if(hand_run>=2u && ((w>>19)&3u)>=2u && now-hand_lease_ms>=80u) {
        /* A five-axis staged target must not starve independent leases when
         * firmware work stretches the command/ACK loop. Do not preempt the
         * initial disabled configuration upload. */
        payload=hand_word(7u,0u,0u,0u);send=1u;hand_lease_ms=now;
    } else if(hand_run>=2u && ((w>>19)&3u)>=2u && rotation_valid &&
              now-hand_rotation_sent_ms>=50u) {
        payload=hand_word(9u,0u,0u,rotation_us);send=1u;
        hand_rotation_sent=rotation_us;hand_rotation_sent_ms=now;
    } else if(hand_qread<hand_qwrite) {
        payload=hand_queue[hand_qread++];send=1u;
        if(((payload>>27)&15u)==9u) {
            payload=hand_word(9u,0u,0u,rotation_us);
            hand_rotation_sent=rotation_us;hand_rotation_sent_ms=now;
        }
        if(((payload>>27)&15u)==10u) {
            payload=hand_word(10u,hand_hdc_class,0u,0u);
            hand_hdc_sent_generation=hand_hdc_generation;
        }
        if(((payload>>27)&15u)==13u && hand_run==3u)hand_hdc_target_ms=now;
        if(((payload>>27)&15u)==6u || ((payload>>27)&15u)==11u)hand_lease_ms=now;
    } else if(hand_home_state==HAND_HOME_WAIT && !((w>>19)&3u)) {
        if(!(w&2u)){hand_link_error=4u;hand_stop();return;}
        if(hand_home_step<6u) {
            payload=hand_word(14u,0u,hand_home_step,hand_home_target[hand_home_step]);
            hand_home_step++;
        } else {
            /* None of the staging writes enables PWM. Only this atomic
             * commit starts all six axes on the generator's shared frame. */
            payload=hand_word(15u,0u,0u,0u);hand_run=1u;hand_manual_pending=0u;
            hand_home_state=HAND_HOME_DRIVE;hand_home_until=now+1000u;
            hand_lease_ms=now;
        }
        send=1u;
    } else if(hand_run==1u && hand_manual_pending) {
        payload=hand_word(5u,hand_manual_axis,0u,hand_manual_value);
        hand_manual_pending=0u;send=1u;hand_lease_ms=now;
    } else if(hand_run>=2u && now-hand_lease_ms>=80u) {
        payload=hand_word(7u,0u,0u,0u);send=1u;hand_lease_ms=now;
    } else if(hand_run>=2u && rotation_valid &&
              ((rotation_us!=hand_rotation_sent && now-hand_rotation_sent_ms>=20u) ||
               now-hand_rotation_sent_ms>=50u)) {
        payload=hand_word(9u,0u,0u,rotation_us);send=1u;hand_rotation_sent=rotation_us;
        hand_rotation_sent_ms=now;
    } else if(hand_run==3u && (hand_hdc_sent_generation!=hand_hdc_generation ||
                             now-hand_hdc_target_ms>=50u)) {
        hand_qread=hand_qwrite=0u;
        if(!hand_hdc_queue_target())hand_stop();
        else hand_hdc_target_ms=now;
    } else if(hand_run==4u && hand_grip_sent_generation!=hand_grip_generation &&
              now-hand_grip_sent_ms>=50u) {
        hand_qread=hand_qwrite=0u;hand_grip_queue_target(now);
    } else {
        hand_qread=hand_qwrite=0u;
        if(hand_run && now-hand_lease_ms>=80u) {
            payload=hand_word(7u,0u,0u,0u);send=1u;hand_lease_ms=now;
        }
    }
    if(send) {
        hand_toggle^=1u;MMIO32(0x41250000u)=payload|(hand_toggle<<31);
        hand_sent_ms=now;hand_inflight=1u;
    }
#else
    (void)now;(void)manual_page;(void)rotation_deg;(void)rotation_valid;hand_link_error=1u;
#endif
}
#endif

