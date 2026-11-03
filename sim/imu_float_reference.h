/* Independent float reference. Generated; never built for ARM. */
static FILE *imu_vector_file;
static void imu_vector_open(void) {
    if(!imu_vector_file) {imu_vector_file=fopen("imu_float_vectors.txt","w");assert(imu_vector_file);}
}
/* Sensor attitude is body->world in a right-handed system. Eye coordinates
 * use x=right, y=forward, z=down, so the sensor/model basis is a reflection.
 * Measured gravity fixes world up even after pronation. No position integral.
 */
#define IMU_GYRO_LSB_DPS 32.8f /* GYRO_CONFIG=0x10: +/-1000 deg/s */
typedef struct { float w,x,y,z; } imu_quat;
static imu_quat imu_q={1,0,0,0},imu_zero={1,0,0,0};
static float imu_bias[3],imu_bias_sum[3],imu_acc_sum[3],imu_previous_acc[3];
static float imu_zero_anchor[3];
static float imu_zero_acc[3],imu_zero_rate[3];
static i32 imu_previous_raw[3];
static i32 imu_last_acc[3];
static hand_v3 imu_up={0,0,4096},imu_forward={0,-4096,0},imu_right={-4096,0,0};
static u32 imu_last_seq,imu_last_t,imu_time_valid,imu_previous_valid;
static u32 imu_still_ticks,imu_stationary,imu_gap_count,imu_clip_count;
static u32 imu_zero_filter_valid,imu_zero_restarts,imu_zero_reason,imu_sample_count,imu_last_dt_ms;
static i32 imu_hand_rotation_deg,imu_hand_rotation_raw,imu_hand_rotation_unwrapped;
static u32 imu_hand_rotation_valid,imu_hand_rotation_seen;
/* Swing/twist decomposition about sensor Y (towards elbow). Reuse the
 * attitude quaternion, rather than the legacy pitch that folds at 90 deg.
 * Integer sine lookup/bisection avoids adding libm to the bare-metal image. */
static void imu_hand_rotation_update(imu_quat rel)
{
    float w=rel.w,y=rel.y,s=2.0f*w*y,c=w*w-y*y;
    i32 lo=0,hi=180,raw,delta;
    imu_hand_rotation_valid=0u;
    if(!mpu_zero_valid || w*w+y*y<0.01f)return;
    if(s<0)s=-s;
    while(lo<hi) {
        i32 mid=(lo+hi)/2;
        if(s*lcd_cos_q12(mid)-c*lcd_sin_q12(mid)>0)lo=mid+1;
        else hi=mid;
    }
    raw=(w*y>0)?-lo:lo; /* left forearm; sensor Y points to elbow */
    if(!imu_hand_rotation_seen) {
        imu_hand_rotation_unwrapped=raw;imu_hand_rotation_seen=1u;
    } else {
        delta=raw-imu_hand_rotation_raw;
        if(delta>180)delta-=360;
        if(delta< -180)delta+=360;
        imu_hand_rotation_unwrapped+=delta;
    }
    imu_hand_rotation_raw=raw;
    imu_hand_rotation_deg=imu_hand_rotation_unwrapped;
    if(imu_hand_rotation_deg>225)imu_hand_rotation_deg=225;
    if(imu_hand_rotation_deg< -45)imu_hand_rotation_deg=-45;
    imu_hand_rotation_valid=1u;
}
static float imu_absf(float v) { return v<0 ? -v : v; }
static float imu_inv_sqrt(float a)
{
    union { float f; u32 u; } v;
    float y;
    v.f=a;v.u=0x5f3759dfu-(v.u>>1);y=v.f;
    y=y*(1.5f-0.5f*a*y*y);y=y*(1.5f-0.5f*a*y*y);
    return y*(1.5f-0.5f*a*y*y);
}
static imu_quat imu_mul(imu_quat a,imu_quat b)
{
    return (imu_quat){a.w*b.w-a.x*b.x-a.y*b.y-a.z*b.z,
        a.w*b.x+a.x*b.w+a.y*b.z-a.z*b.y,
        a.w*b.y-a.x*b.z+a.y*b.w+a.z*b.x,
        a.w*b.z+a.x*b.y-a.y*b.x+a.z*b.w};
}
static imu_quat imu_norm(imu_quat q)
{
    float k=imu_inv_sqrt(q.w*q.w+q.x*q.x+q.y*q.y+q.z*q.z);
    return (imu_quat){q.w*k,q.x*k,q.y*k,q.z*k};
}
static imu_quat imu_conj(imu_quat q) { return (imu_quat){q.w,-q.x,-q.y,-q.z}; }
static imu_quat imu_gravity(float ax,float ay,float az)
{
    float k=imu_inv_sqrt(ax*ax+ay*ay+az*az);
    ax*=k;ay*=k;az*=k;
    /* Choose the well-conditioned hemisphere; near palm-up, 1+az loses
     * precision. The lower branch is tilt correction followed by Rx180. */
    return az>=0 ? imu_norm((imu_quat){1.0f+az,ay,-ax,0}) :
                   imu_norm((imu_quat){ay,1.0f-az,0,ax});
}
static hand_v3 imu_rotate(imu_quat q,hand_v3 v)
{
    imu_quat p=imu_mul(imu_mul(q,(imu_quat){0,(float)v.x,(float)v.y,(float)v.z}),imu_conj(q));
    return (hand_v3){(i32)p.x,(i32)p.y,(i32)p.z};
}
static i32 imu_dot(hand_v3 a,hand_v3 b) { return (a.x*b.x+a.y*b.y+a.z*b.z)/4096; }
static void imu_capture_basis(float ax,float ay,float az)
{
    (void)ax;(void)ay;(void)az;
    imu_up=(hand_v3){0,0,-4096};
    imu_forward=(hand_v3){0,-4096,0};
    imu_right=(hand_v3){4096,0,0};
}
static void lcd_imu_reset(void)
{
    imu_vector_open();fprintf(imu_vector_file,"R\n");fflush(imu_vector_file);
    u32 i;
    mpu_zero_valid=mpu_zero_cnt=0;
    mpu_zero_acc_r=mpu_zero_acc_p=0;
    mpu_tilt_q=mpu_shift_q=0;
    imu_hand_rotation_deg=imu_hand_rotation_raw=imu_hand_rotation_unwrapped=0;
    imu_hand_rotation_valid=imu_hand_rotation_seen=0u;
    lcd_state_tilt=lcd_state_shift=0;
    lcd_imu_valid=imu_time_valid=imu_previous_valid=imu_zero_filter_valid=0;
    imu_zero_reason=imu_last_dt_ms=0;
    imu_still_ticks=imu_stationary=0;
    for(i=0;i<3;i++)imu_bias_sum[i]=imu_acc_sum[i]=0;
    lcd_input_status_changed();
}
static i32 imu_s16(u32 v) { return (i32)((v&65535u)^32768u)-32768; }
static void lcd_imu_ingest(u32 a,u32 b,u32 c,u32 word)
{
    float acc[3]={imu_s16(a>>16)/16384.0f,imu_s16(a)/16384.0f,imu_s16(b>>16)/16384.0f};
    i32 raw[3]={imu_s16(b),imu_s16(c>>16),imu_s16(c)},i;
    float g[3],an=acc[0]*acc[0]+acc[1]*acc[1]+acc[2]*acc[2],dt,delta=0;
    float zero_delta=0,rate_delta=0;
    u32 seq=(word>>24)&127u,step=(seq-imu_last_seq)&127u;
    u32 t=gt_stamp(),ticks=t-imu_last_t;
    u32 vector_gap=imu_time_valid && ticks>80u*GT_TICKS_PER_MS;
    u32 still=imu_previous_valid && an>0.90f && an<1.10f;
    imu_quat rel;
    i32 matrix[9],changed=0;
    if(!lcd_imu_valid) {
        if(an<0.5f || an>1.5f)return;
        imu_q=imu_gravity(acc[0],acc[1],acc[2]);
        imu_zero=imu_q;imu_capture_basis(acc[0],acc[1],acc[2]);
        lcd_imu_valid=1;step=0;
        imu_previous_valid=0;still=0;
        lcd_input_status_changed();
    }
    if(!imu_time_valid || ticks>80u*GT_TICKS_PER_MS || step>8u) {
        dt=0;still=0;
        if(imu_time_valid)imu_gap_count++;
    } else dt=step*0.01f;
    imu_last_seq=seq;imu_last_t=t;imu_time_valid=1;
    imu_sample_count++;imu_last_dt_ms=(u32)(dt*1000+0.5f);
    imu_zero_reason=(!step || !dt)?1u:0u;
    if(an<=0.90f || an>=1.10f)imu_zero_reason|=2u;
    for(i=0;i<3;i++) {
        float old_acc=imu_zero_acc[i],old_rate=imu_zero_rate[i];
        float k=dt/(0.05f+dt);
        imu_last_acc[i]=(i32)(acc[i]*16384);
        if(imu_absf(raw[i]-imu_bias[i])>0.8f*IMU_GYRO_LSB_DPS)still=0;
        /* Filter only the stability decision, never live motion inputs.
         * Adjacent raw samples need not be identical on a real forearm. */
        if(!imu_zero_filter_valid || !dt) {
            imu_zero_acc[i]=acc[i];imu_zero_rate[i]=(float)raw[i];
        } else {
            imu_zero_acc[i]+=(acc[i]-imu_zero_acc[i])*k;
            imu_zero_rate[i]+=(raw[i]-imu_zero_rate[i])*k;
        }
        zero_delta+=(imu_zero_acc[i]-old_acc)*(imu_zero_acc[i]-old_acc);
        rate_delta+=(imu_zero_rate[i]-old_rate)*(imu_zero_rate[i]-old_rate);
        if(imu_absf(raw[i]-imu_bias[i])>20.0f*IMU_GYRO_LSB_DPS)imu_zero_reason|=4u;
        imu_previous_raw[i]=raw[i];
        delta+=(acc[i]-imu_previous_acc[i])*(acc[i]-imu_previous_acc[i]);
        imu_previous_acc[i]=acc[i];
        if(hand_abs(raw[i])>=32700) {imu_clip_count++;imu_zero_reason|=64u;}
    }
    if(delta>0.0001f)still=0; /* idle bias adaptation remains conservative */
    if(imu_zero_filter_valid) {
        if(zero_delta>0.0001f)imu_zero_reason|=8u;
        if(rate_delta>256.0f)imu_zero_reason|=4u;
    }
    imu_zero_filter_valid=1;
    imu_previous_valid=1;
    if(still && step)imu_still_ticks+=step;
    else imu_still_ticks=0;
    imu_stationary=imu_still_ticks>=50u;
    if(!mpu_zero_valid) {
        /* A moving sample restarts the entire zero window. Reject a nearly
         * vertical forearm, where horizontal heading cannot be established. */
        float travel=0;
        for(i=0;i<3;i++) {
            if(!mpu_zero_cnt)imu_zero_anchor[i]=imu_zero_acc[i];
            travel+=(imu_zero_acc[i]-imu_zero_anchor[i])*(imu_zero_acc[i]-imu_zero_anchor[i]);
        }
        if(travel>0.0004f)imu_zero_reason|=16u;

        if(imu_zero_reason) {
            if(mpu_zero_cnt)imu_zero_restarts++;
            mpu_zero_cnt=0;mpu_zero_acc_r=mpu_zero_acc_p=0;
            for(i=0;i<3;i++)imu_bias_sum[i]=imu_acc_sum[i]=0;
        } else {
            for(i=0;i<3;i++) {imu_bias_sum[i]+=raw[i];imu_acc_sum[i]+=acc[i];}
            mpu_zero_acc_p+=MPU_TW_PITCH(word);mpu_zero_acc_r+=MPU_TW_ROLL(word);
            if(++mpu_zero_cnt>=MPU_ZERO_SAMPLES) {
                for(i=0;i<3;i++) {imu_bias[i]=imu_bias_sum[i]/MPU_ZERO_SAMPLES;imu_acc_sum[i]/=MPU_ZERO_SAMPLES;}
                /* Reset tilt from averaged stationary gravity, removing
                 * contamination by motion immediately before calibration. */
                imu_q=imu_gravity(imu_acc_sum[0],imu_acc_sum[1],imu_acc_sum[2]);imu_zero=imu_q;
                imu_capture_basis(imu_acc_sum[0],imu_acc_sum[1],imu_acc_sum[2]);
                mpu_zero_p=mpu_zero_acc_p/(i32)MPU_ZERO_SAMPLES;
                mpu_zero_r=mpu_zero_acc_r/(i32)MPU_ZERO_SAMPLES;
                mpu_zero_valid=1;dt=0;
                lcd_input_status_changed();
            }
        }
    } else if(imu_stationary) {
        /* Adapt thermal bias while stationary; preserve heading rather
         * than integrating residual bias into an artificial rotation. */
        float k=dt;if(k>0.08f)k=0.08f;
        for(i=0;i<3;i++)imu_bias[i]+=(raw[i]-imu_bias[i])*k;
    }
    for(i=0;i<3;i++)g[i]=imu_stationary ? 0 : (raw[i]-imu_bias[i])*(0.01745329252f/IMU_GYRO_LSB_DPS);
    /* Lower gravity influence in motion and cap it. Norm alone cannot
     * distinguish linear acceleration from gravity during an arm lift. */
    if(an>0.94f && an<1.06f) {
        float k=imu_inv_sqrt(an),vx,vy,vz,e[3],en,rate2;
        float ax=acc[0]*k,ay=acc[1]*k,az=acc[2]*k;
        vx=2*(imu_q.x*imu_q.z-imu_q.w*imu_q.y);
        vy=2*(imu_q.y*imu_q.z+imu_q.w*imu_q.x);
        vz=1-2*(imu_q.x*imu_q.x+imu_q.y*imu_q.y);
        e[0]=ay*vz-az*vy;e[1]=az*vx-ax*vz;e[2]=ax*vy-ay*vx;
        rate2=g[0]*g[0]+g[1]*g[1]+g[2]*g[2];
        k=imu_stationary ? 5.0f : (rate2<0.25f ? 0.5f : 0.1f);
        en=e[0]*e[0]+e[1]*e[1]+e[2]*e[2];
        if(k*k*en>0.0625f)k=0.25f*imu_inv_sqrt(en);
        for(i=0;i<3;i++)g[i]+=k*e[i];
    }
    if(dt>0) {
        u32 j,n=(u32)(dt/0.005f)+1u;float h=dt/n;
        for(j=0;j<n;j++) {
            imu_quat dq=imu_mul(imu_q,(imu_quat){0,g[0],g[1],g[2]});
            imu_q=imu_norm((imu_quat){imu_q.w+0.5f*h*dq.w,imu_q.x+0.5f*h*dq.x,
                                     imu_q.y+0.5f*h*dq.y,imu_q.z+0.5f*h*dq.z});
        }
    }
    /* Provisional attitude is usable from the first valid sample. Bias
     * calibration may wait/restart without ever freezing live tracking. */
    rel=imu_norm(imu_mul(imu_conj(imu_zero),imu_q));
    imu_hand_rotation_update(rel);
    /* X little-finger, Y elbow imply sensor Z is dorsal. Model Z points
     * into the palm, so sensor_from_model = diag(-1,-1,-1), NOT the old
     * diag(-1,-1,+1). Project onto fixed right/forward/down after rotation.
     * Gravity selects palm/back at calibration without reversing lift. */
    for(i=0;i<3;i++) {
        hand_v3 axis={i==0?-4096:0,i==1?-4096:0,i==2?-4096:0};
        hand_v3 v=imu_rotate(rel,axis);
        matrix[i]=imu_dot(imu_right,v);
        matrix[3+i]=imu_dot(imu_forward,v);
        matrix[6+i]=-imu_dot(imu_up,v);
    }
    for(i=0;i<9;i++)if(hand_abs(matrix[i]-lcd_imu_matrix[i])>=8)changed=1;
    if(changed) {
        for(i=0;i<9;i++)lcd_imu_matrix[i]=matrix[i];
        lcd_imu_generation++;
    }

    imu_vector_open();
    fprintf(imu_vector_file,"S %08x %08x %08x %08x %u %u %u %u %u %d %u %u %u %u %u",
        a,b,c,word,vector_gap,mpu_zero_valid,mpu_zero_cnt,imu_stationary,
        imu_hand_rotation_valid,imu_hand_rotation_deg,imu_zero_reason,imu_gap_count,
        imu_clip_count,imu_sample_count,imu_last_dt_ms);
    for(i=0;i<9;i++)fprintf(imu_vector_file," %d",lcd_imu_matrix[i]);
    for(i=0;i<3;i++)fprintf(imu_vector_file," %.8f",imu_bias[i]);
    fprintf(imu_vector_file,"\n");fflush(imu_vector_file);
}
