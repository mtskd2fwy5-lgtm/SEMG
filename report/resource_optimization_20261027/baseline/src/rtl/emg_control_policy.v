`timescale 1ns/1ps
// PS-equivalent calibration, Q20 softmax, rest gate and temporal policy.
// One complete MAV window precedes its five logits/class. No DMA ready input.
// Frames are rejected on reset/timeout; stale is an execution interlock,
// separate from the PS's existing observation-based decision semantics.
module emg_control_policy #(
    parameter integer CLOCK_HZ=25000000,
    parameter integer STALE_MS=250,
    parameter integer CAL_DISCARD=80,
    parameter integer CAL_COLLECT=16
)(
    input wire clk,rst_n,recalibrate,
    input wire window_valid,
    input wire [15:0] window_seq,
    input wire [255:0] window_mav,
    input wire logit_valid,
    input wire [2:0] logit_id,
    input wire [31:0] logit_data,
    input wire [15:0] logit_seq,
    output reg decision_valid,
    output reg [15:0] decision_seq,
    output reg [2:0] active_class,candidate_class,
    output reg [6:0] active_conf,candidate_conf,
    output reg gated,
    output reg muscle_active,
    output reg [1:0] cal_stage,
    output reg stale,
    output reg protocol_fault
);
    `include "emg_control_constants.vh"
    localparam integer STALE_CYCLES=(CLOCK_HZ/1000)*STALE_MS;
    reg [31:0] age;
    reg [31:0] cal_sum[0:7],threshold[0:7];
    reg [15:0] discard_count,collect_count;
    reg [15:0] frame_seq,last_seq;
    reg frame_seen,seq_seen,frame_gate;
    reg signed [31:0] logits[0:4];
    reg [2:0] expected_logit;
    reg [6:0] confidence[0:4];
    reg [20:0] exps[0:4];
    reg signed [31:0] top;
    reg [2:0] best,index;
    reg [22:0] exp_sum;
    reg [3:0] state;
    localparam IDLE=0,MAXIMUM=1,EXPONENT=2,DIV_BEGIN=3,DIVIDE=4,POLICY=5;
    reg [26:0] numerator,quotient;
    reg [23:0] remainder;
    reg [4:0] div_bit;
    reg [2:0] pending_class;
    reg [31:0] pending_count,uncertain_count;
    integer i;
    reg next_gate;
    reg [31:0] sum_now,thr_now;
    reg [32:0] gap;
    reg [63:0] scaled_bin;
    reg [20:0] exp_now;
    reg [23:0] trial;
    reg [26:0] quotient_now;
    reg [2:0] target,next_active,next_pending;
    reg [31:0] next_pending_count,next_uncertain;
    reg valid_candidate;
    integer required;
    always @(posedge clk) begin
        decision_valid<=0;
        if(!rst_n || recalibrate) begin
            cal_stage<=0;discard_count<=0;collect_count<=0;
            active_class<=0;active_conf<=0;candidate_class<=0;candidate_conf<=0;gated<=0;muscle_active<=0;
            pending_class<=0;pending_count<=0;uncertain_count<=0;
            frame_seen<=0;seq_seen<=0;expected_logit<=0;
            state<=IDLE;age<=0;stale<=1;protocol_fault<=0;
            frame_seq<=0;last_seq<=0;decision_seq<=0;frame_gate<=0;
            top<=0;best<=0;index<=0;exp_sum<=0;numerator<=0;quotient<=0;remainder<=0;div_bit<=0;
            for(i=0;i<8;i=i+1)begin cal_sum[i]<=0;threshold[i]<=0;end
            for(i=0;i<5;i=i+1)begin logits[i]<=0;confidence[i]<=0;exps[i]<=0;end
        end else begin
            if(age<STALE_CYCLES)age<=age+1;
            if(window_valid) begin
                if(frame_seen || state!=IDLE)protocol_fault<=1;
                else begin
                age<=0;frame_seen<=1;frame_seq<=window_seq;expected_logit<=0;
                next_gate=1;
                if(cal_stage==0) begin
                    if(discard_count+1>=CAL_DISCARD)begin
                        cal_stage<=1;collect_count<=0;
                        for(i=0;i<8;i=i+1)cal_sum[i]<=0;
                    end else discard_count<=discard_count+1;
                    next_gate=0;
                end else if(cal_stage==1) begin
                    for(i=0;i<8;i=i+1)begin
                        sum_now=cal_sum[i]+window_mav[i*32+:32];
                        cal_sum[i]<=sum_now;
                        if(collect_count+1>=CAL_COLLECT) begin
                            // Existing PS arithmetic: uint32 accumulation/multiply.
                            thr_now=3*(sum_now/CAL_COLLECT);
                            if(thr_now<1000)thr_now=1000;
                            threshold[i]<=thr_now;
                            if(window_mav[i*32+:32]>=thr_now)next_gate=0;
                        end
                    end
                    if(collect_count+1>=CAL_COLLECT)cal_stage<=2;
                    else begin collect_count<=collect_count+1;next_gate=0;end
                end else for(i=0;i<8;i=i+1)
                    if(window_mav[i*32+:32]>=threshold[i])next_gate=0;
                frame_gate<=next_gate;
                end
            end
            if(logit_valid) begin
                if(!frame_seen || logit_seq!=frame_seq || logit_id!=expected_logit || logit_id>5 || state!=IDLE)begin
                    protocol_fault<=1;frame_seen<=0;expected_logit<=0;
                end else if(logit_id<5)begin
                    logits[logit_id]<=logit_data;expected_logit<=expected_logit+1;
                end else begin
                    frame_seen<=0;expected_logit<=0;age<=0;
                    if(cal_stage==2)begin
                        decision_seq<=frame_seq;index<=1;top<=logits[0];best<=0;
                        state<=MAXIMUM;
                    end
                end
            end
            case(state)
                MAXIMUM:begin
                    if(logits[index]>top)begin top<=logits[index];best<=index;end
                    if(index==4)begin index<=0;exp_sum<=0;state<=EXPONENT;end
                    else index<=index+1;
                end
                EXPONENT:begin
                    gap=$signed({top[31],top})-$signed({logits[index][31],logits[index]});
                    scaled_bin=(gap*CONF_SCALE_Q24+64'd8388608)>>24;
                    exp_now=scaled_bin<=256?confidence_exp(scaled_bin[8:0]):0;
                    exps[index]<=exp_now;exp_sum<=exp_sum+exp_now;
                    if(index==4)begin index<=0;state<=DIV_BEGIN;end
                    else index<=index+1;
                end
                DIV_BEGIN:begin
                    numerator<=exps[index]*27'd100;quotient<=0;remainder<=0;div_bit<=26;
                    state<=DIVIDE;
                end
                DIVIDE:begin
                    trial={remainder[22:0],numerator[div_bit]};
                    quotient_now=quotient;
                    if(trial>={1'b0,exp_sum})begin
                        remainder<=trial-{1'b0,exp_sum};quotient_now[div_bit]=1;
                    end else remainder<=trial;
                    quotient<=quotient_now;
                    if(div_bit==0)begin
                        confidence[index]<=quotient_now[6:0];
                        if(index==4)state<=POLICY;
                        else begin index<=index+1;state<=DIV_BEGIN;end
                    end else div_bit<=div_bit-1;
                end
                POLICY:begin
                    // Preserve PS operation ordering, including uncertainty expiry
                    // and refreshing confidence for the held class every window.
                    next_pending=pending_class;next_pending_count=pending_count;next_uncertain=uncertain_count;
                    next_active=active_class;required=POSE_CONFIRM_WINDOWS;
                    if(seq_seen && (decision_seq-last_seq)!=16'd40)begin
                        next_pending_count=0;next_uncertain=0;
                    end
                    last_seq<=decision_seq;seq_seen<=1;
                    target=frame_gate?0:best;
                    valid_candidate=(frame_gate && best!=0) || confidence[best]>=
                        ((best==0 || best==active_class)?POSE_HOLD_CONF:POSE_MIN_CONF);
                    if(!valid_candidate)begin
                        next_pending_count=0;next_uncertain=next_uncertain+1;
                        if(next_uncertain>=POSE_UNCERTAIN_WINDOWS)begin
                            next_uncertain=POSE_UNCERTAIN_WINDOWS;
                            if(active_class!=0)begin next_active=0;next_pending_count=0;next_uncertain=0;end
                        end
                    end else if(target==active_class)begin next_pending_count=0;next_uncertain=0;end
                    else begin
                        if(next_uncertain<POSE_UNCERTAIN_WINDOWS)next_uncertain=next_uncertain+1;
                        if(target==0)required=POSE_REST_WINDOWS;
                        if(target==next_pending)next_pending_count=next_pending_count+1;
                        else begin next_pending=target;next_pending_count=1;end
                        if(next_pending_count>=required || (next_uncertain>=POSE_UNCERTAIN_WINDOWS && active_class!=0))begin
                            next_active=next_pending_count>=required?target:0;
                            next_pending_count=0;next_uncertain=0;
                        end
                    end
                    active_class<=next_active;active_conf<=confidence[next_active];
                    // Actual calibrated amplitude gate, independent of MLP confidence.
                    muscle_active<=!frame_gate;
                    candidate_class<=target;candidate_conf<=confidence[target];gated<=frame_gate && best!=0;
                    pending_class<=next_pending;pending_count<=next_pending_count;uncertain_count<=next_uncertain;
                    age<=0;stale<=0;decision_valid<=1;state<=IDLE;
                end
                default:;
            endcase
            // Last assignment wins: an in-flight calculation cannot publish
            // a fresh decision after its watchdog has expired.
            if(age>=STALE_CYCLES && !window_valid)begin
                stale<=1;muscle_active<=0;frame_seen<=0;state<=IDLE;expected_logit<=0;decision_valid<=0;
            end
        end
    end
endmodule
