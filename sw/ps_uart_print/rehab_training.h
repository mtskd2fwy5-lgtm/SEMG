/* Deterministic training task engine. No display, storage or hardware IO.
 * Caller supplies monotonic milliseconds and actual inference observations.
 * Scores are model support, not calibrated probability or clinical outcomes. */
#ifndef REHAB_TRAINING_H
#define REHAB_TRAINING_H
#include <stdint.h>
#include <string.h>
#define REHAB_MAX_TRIALS 40u
#define REHAB_SUPPORT_MIN 50u
#define REHAB_STALE_MS 250u
#define REHAB_EFFORT_LOWER_PERCENT 70u
#define REHAB_EFFORT_UPPER_PERCENT 130u
enum { RH_IDLE, RH_CALIBRATE, RH_RELAX, RH_CUE, RH_HOLD, RH_RECOVER, RH_PAUSED, RH_DONE, RH_GROUP_REST };
enum { RH_REASON_NONE, RH_REASON_USER, RH_REASON_DATA, RH_REASON_CAL, RH_REASON_RELAX };
typedef struct {
    uint32_t target, success, response_ms, hold_ms, breaks, duration_ms;
} rehab_trial_t;
typedef struct {
    uint32_t state, reason, combination, action, repetitions, hold_ms, rest_ms;
    uint32_t total, attempted, successes, failures, target, aborted;
    uint32_t now, started_at, elapsed_ms, phase_at, cue_at, last_observation;
    uint32_t seen, sequence, segment_ms, matching, response_ms, breaks;
    uint32_t changed, save_state;
    uint32_t effort_enabled, effort_reference, effort_valid, effort_c2;
    uint32_t effort_samples, effort_in_band;
    uint32_t group_every, group_rest_ms, group_pending, groups_completed, pause_count;
    rehab_trial_t trials[REHAB_MAX_TRIALS];
} rehab_training_t;

static uint32_t rehab_running(const rehab_training_t *r)
{ return (r->state>=RH_CALIBRATE && r->state<=RH_PAUSED) || r->state==RH_GROUP_REST; }

static void rehab_phase(rehab_training_t *r,uint32_t phase,uint32_t now)
{
    r->state=phase;r->phase_at=now;r->segment_ms=0u;r->matching=0u;r->changed=1u;
}

static void rehab_pause(rehab_training_t *r,uint32_t reason,uint32_t now)
{
    if (!rehab_running(r) || r->state==RH_PAUSED) return;
    r->pause_count++;
    r->elapsed_ms+=now-r->started_at;
    rehab_phase(r,RH_PAUSED,now);r->reason=reason;
    r->response_ms=0u;r->breaks=0u; /* interrupted trial restarts after relaxation */
}

static void rehab_start(rehab_training_t *r,uint32_t combination,uint32_t action,
                        uint32_t repetitions,uint32_t hold_ms,uint32_t rest_ms,uint32_t now)
{
    memset(r,0,sizeof *r);
    r->combination=!!combination;r->action=(action>=1u && action<=4u)?action:1u;
    r->repetitions=repetitions<1u?1u:repetitions>10u?10u:repetitions;
    r->hold_ms=hold_ms<1000u?1000u:hold_ms>5000u?5000u:hold_ms;
    r->rest_ms=rest_ms<1000u?1000u:rest_ms>10000u?10000u:rest_ms;
    r->total=r->repetitions*(r->combination?4u:1u);
    r->started_at=now;r->now=now;r->target=r->combination?1u:r->action;
    rehab_phase(r,RH_CALIBRATE,now);
}

static void rehab_resume(rehab_training_t *r,uint32_t now)
{
    if(r->state!=RH_PAUSED)return;
    r->started_at=now;r->seen=0u;r->reason=RH_REASON_NONE;
    rehab_phase(r,RH_CALIBRATE,now);
}

static void rehab_finish(rehab_training_t *r,uint32_t now,uint32_t aborted)
{
    if(!rehab_running(r))return;
    if(r->state!=RH_PAUSED)r->elapsed_ms+=now-r->started_at;
    r->aborted=aborted;r->reason=RH_REASON_NONE;rehab_phase(r,RH_DONE,now);
}

static void rehab_complete_trial(rehab_training_t *r,uint32_t success,uint32_t now)
{
    rehab_trial_t *t;
    if(r->attempted>=r->total || r->attempted>=REHAB_MAX_TRIALS)return;
    t=&r->trials[r->attempted++];
    t->target=r->target;t->success=success;t->response_ms=r->response_ms;
    t->hold_ms=success?r->hold_ms:r->segment_ms;t->breaks=r->breaks;
    t->duration_ms=now-r->cue_at;
    if(success)r->successes++;else r->failures++;
    if(r->attempted<r->total && r->group_every && r->attempted%r->group_every==0u)
        r->group_pending=1u;
    rehab_phase(r,RH_RECOVER,now);
}

/* A group is a pacing boundary, not a performance score. Recovery must finish
 * first; a rest timer alone cannot start the next target without user input. */
static void rehab_continue_group(rehab_training_t *r,uint32_t now)
{
    if(r->state!=RH_GROUP_REST || now-r->phase_at<r->group_rest_ms)return;
    if(!r->seen || now-r->last_observation>REHAB_STALE_MS) {
        rehab_pause(r,RH_REASON_DATA,now);return;
    }
    r->group_pending=0u;r->groups_completed++;rehab_phase(r,RH_RELAX,now);
}

/* Wall-clock service never completes a hold: only contiguous new evidence can.
 * Call regularly even when the stream stops so a frozen pose cannot score. */
static void rehab_tick(rehab_training_t *r,uint32_t now,uint32_t calibrated)
{
    r->now=now;
    if(!rehab_running(r) || r->state==RH_PAUSED)return;
    if(r->state==RH_CALIBRATE) {
        if(calibrated && r->seen && now-r->last_observation<=REHAB_STALE_MS)
            rehab_phase(r,r->group_pending?RH_GROUP_REST:RH_RELAX,now);
        else if(now-r->phase_at>=10000u)rehab_pause(r,RH_REASON_CAL,now);
        return;
    }
    if(!calibrated) {rehab_pause(r,RH_REASON_CAL,now);return;}
    if(!r->seen || now-r->last_observation>REHAB_STALE_MS) {
        rehab_pause(r,RH_REASON_DATA,now);return;
    }
    if((r->state==RH_RELAX || r->state==RH_RECOVER) && now-r->phase_at>=15000u)
        rehab_pause(r,RH_REASON_RELAX,now);
    else if((r->state==RH_CUE || r->state==RH_HOLD) && now-r->cue_at>=r->hold_ms+10000u)
        rehab_complete_trial(r,0u,now);
}

/* seq advances by 40 at the 25 ms inference hop. Continuous evidence requires
 * both accepted pose and current candidate; a policy-held old pose is excluded.
 * seen time, sequence and segment state remain independent of LCD previews. */
static void rehab_observe(rehab_training_t *r,uint32_t now,uint32_t seq,
                          uint32_t accepted,uint32_t candidate,uint32_t support,
                          uint32_t gated,uint32_t calibrated)
{
    uint32_t dt=now-r->last_observation;
    uint32_t adjacent=r->seen && (uint16_t)(seq-r->sequence)==40u && dt<=75u;
    uint32_t match;
    if(r->seen && (uint16_t)(seq-r->sequence)==0u)return;
    /* Service stale/calibration/timeout before accepting the arriving sample. */
    rehab_tick(r,now,calibrated);
    r->last_observation=now;r->sequence=seq;r->seen=1u;
    if(!rehab_running(r) || r->state==RH_PAUSED)return;
    if(r->state==RH_CALIBRATE) {rehab_tick(r,now,calibrated);return;}
    if(!adjacent) {
        if(r->state==RH_HOLD && r->matching)r->breaks++;
        r->segment_ms=0u;r->matching=0u;
    }
    /* Scheduling latency must not create extra evidence from one window. */
    if(dt>25u)dt=25u;
    if(r->state==RH_RELAX || r->state==RH_RECOVER) {
        match=accepted==0u && (gated || (candidate==0u && support>=REHAB_SUPPORT_MIN));
        if(match) {
            if(r->matching && adjacent)r->segment_ms+=dt;
            r->matching=1u;
        } else {r->segment_ms=0u;r->matching=0u;}
        if(r->segment_ms>=r->rest_ms) {
            if(r->attempted==r->total) {rehab_finish(r,now,0u);return;}
            if(r->group_pending) {
                rehab_phase(r,RH_GROUP_REST,now);return;
            }
            r->target=r->combination?1u+r->attempted%4u:r->action;
            r->response_ms=0u;r->breaks=0u;r->cue_at=now;
            rehab_phase(r,RH_CUE,now);
        }
    } else if(r->state==RH_CUE || r->state==RH_HOLD) {
        match=accepted==r->target && candidate==r->target &&
              support>=REHAB_SUPPORT_MIN && !gated;
        if(r->effort_enabled && r->target==2u) {
            uint32_t in_band=r->effort_valid && r->effort_reference &&
                (uint64_t)r->effort_c2*100u>=(uint64_t)r->effort_reference*REHAB_EFFORT_LOWER_PERCENT &&
                (uint64_t)r->effort_c2*100u<=(uint64_t)r->effort_reference*REHAB_EFFORT_UPPER_PERCENT;
            r->effort_samples++;
            if(match && in_band)r->effort_in_band++;
            match=match && in_band;
        }
        if(match) {
            if(r->matching && adjacent)r->segment_ms+=dt;
            else {
                r->segment_ms=0u;r->matching=1u;r->state=RH_HOLD;r->changed=1u;
                if(!r->response_ms)r->response_ms=now-r->cue_at;
            }
            if(r->segment_ms>=r->hold_ms)rehab_complete_trial(r,1u,now);
        } else {
            if(r->matching)r->breaks++;
            r->segment_ms=0u;r->matching=0u;
            if(r->state==RH_HOLD){r->state=RH_CUE;r->changed=1u;}
        }
    }
}
#endif
