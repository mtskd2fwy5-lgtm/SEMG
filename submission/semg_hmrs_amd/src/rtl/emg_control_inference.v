`timescale 1ns/1ps
// Autonomous feature capture -> selected ring mapping -> existing INT8 MLP
// -> PS-equivalent policy. Telemetry may drop under backpressure; this core
// never waits for DMA/LCD/UART. Configuration is snapshotted per window.
module emg_control_inference #(
    parameter integer CLOCK_HZ=25000000,
    parameter MEM_FILE="data/models/nn_int8_board_multiwear/nn_int8_weights.mem"
)(
    input wire clk,rst_n,recalibrate,
    input wire [2:0] shift,
    input wire [3:0] epoch,
    input wire feature_valid,
    input wire [2:0] feature_channel,
    input wire [3:0] feature_id,
    input wire [15:0] feature_seq,
    input wire [31:0] feature_data,
    output wire nn_valid,
    output wire [2:0] nn_id,
    output wire [31:0] nn_data,
    output reg [15:0] nn_seq,
    output wire decision_valid,
    output wire [31:0] decision_data,
    output wire [15:0] decision_seq,
    output wire [1:0] cal_stage,
    output wire stale,
    output wire fault,
    output wire muscle_active,
    output wire [2:0] active_class
);
    localparam IDLE=0,CAPTURE=1,FEED=2,INFER=3,DECIDE=4;
    reg [2:0] state,window_shift;
    reg [3:0] window_epoch;
    reg [5:0] capture_index,feed_index;
    reg [31:0] features[0:39];
    reg [15:0] expected_seq;
    reg capture_fault;
    wire engine_ready;
    wire [6:0] active_conf,candidate_conf;
    wire [2:0] candidate_class;
    wire gated,policy_fault;
    wire reset_n=rst_n && !recalibrate;
    wire complete_window=state==CAPTURE && feature_valid && capture_index==39 &&
        feature_seq==expected_seq && feature_channel==7 && feature_id==4;
    wire [255:0] mav={features[7],features[6],features[5],features[4],features[3],features[2],features[1],features[0]};
    // Ring order CH4,CH1,CH2,CH3,CH5,CH6. CH7/CH8 are never remapped.
    function [2:0] source_channel;
        input [2:0] destination,rotation;
        integer pos,sum;
        begin
            case(destination)
                3:pos=0;0:pos=1;1:pos=2;2:pos=3;4:pos=4;5:pos=5;
                default:pos=0;
            endcase
            sum=pos+rotation;if(sum>=6)sum=sum-6;
            if(destination>=6)source_channel=destination;
            else case(sum)
                0:source_channel=3;1:source_channel=0;2:source_channel=1;
                3:source_channel=2;4:source_channel=4;default:source_channel=5;
            endcase
        end
    endfunction
    wire [5:0] source_index={feed_index[5:3],source_channel(feed_index[2:0],window_shift)};
    emg_nn_infer #(.MEM_FILE(MEM_FILE)) nn(
        .clk(clk),.rst_n(reset_n),.feat_valid(state==FEED),
        .feat_index(feed_index),.feat_data(features[source_index]),.feat_ready(engine_ready),
        .out_valid(nn_valid),.out_ready(1'b1),.out_id(nn_id),.out_data(nn_data)
    );
    emg_control_policy #(.CLOCK_HZ(CLOCK_HZ)) policy(
        .clk(clk),.rst_n(reset_n),.recalibrate(1'b0),
        .window_valid(complete_window),.window_seq(nn_seq),.window_mav(mav),
        .logit_valid(nn_valid),.logit_id(nn_id),.logit_data(nn_data),.logit_seq(nn_seq),
        .decision_valid(decision_valid),.decision_seq(decision_seq),
        .active_class(active_class),.active_conf(active_conf),
        .candidate_class(candidate_class),.candidate_conf(candidate_conf),.gated(gated),.muscle_active(muscle_active),
        .cal_stage(cal_stage),.stale(stale),.protocol_fault(policy_fault)
    );
    assign fault=capture_fault || policy_fault;
    // type3/id6: [31:28]epoch [27]stale [26:24]shift [23]valid
    // [22:21]cal [20:14]candidate conf [13:11]candidate [10]gate
    // [9:3]active conf [2:0]active. One coherent word per accepted window.
    assign decision_data={window_epoch,stale,window_shift,1'b1,cal_stage,
                          candidate_conf,candidate_class,gated,active_conf,active_class};
    always @(posedge clk)begin
        if(!reset_n)begin
            state<=IDLE;window_shift<=0;window_epoch<=0;capture_index<=0;feed_index<=0;
            expected_seq<=0;nn_seq<=0;capture_fault<=0;
        end else begin
            if(feature_valid)begin
                if(state==IDLE && feature_channel==0 && feature_id==0)begin
                    features[0]<=feature_data;nn_seq<=feature_seq;expected_seq<=feature_seq+1;
                    capture_index<=1;window_shift<=shift<6?shift:0;window_epoch<=epoch;state<=CAPTURE;
                end else if(state==CAPTURE)begin
                    if(feature_seq!=expected_seq || feature_channel!=capture_index/5 || feature_id!=capture_index%5)begin
                        capture_fault<=1;state<=IDLE;
                    end else begin
                        features[{feature_id[2:0],feature_channel}]<=feature_data;
                        expected_seq<=expected_seq+1;capture_index<=capture_index+1;
                        if(capture_index==39)begin state<=FEED;feed_index<=0;end
                    end
                end else if(feature_channel==0 && feature_id==0)capture_fault<=1;
            end
            if(state==FEED && engine_ready)begin
                if(feed_index==39)state<=INFER;else feed_index<=feed_index+1;
            end
            if(state==INFER && nn_valid && nn_id==5)begin
                // Calibration windows have no policy output, active ones do.
                state<=cal_stage==2?DECIDE:IDLE;
            end
            if(state==DECIDE && decision_valid)state<=IDLE;
        end
    end
endmodule

