`timescale 1ns/1ps
// Current BD adapter: autonomous decision core plus an acknowledged PS command
// mailbox. Both bundled payloads remain held until a synchronized ACK returns.
// GPIO1: [31]request toggle [7:4]epoch [3]recalibrate [2:0]ring shift.
// GPIO2: [31:16]magic504c [15]ack [11:8]epoch [6:4]shift [3]fault [2]stale [1:0]cal.
module emg_pl_control #(
    parameter integer HP_B0=64096,HP_B1=-128192,HP_B2=64096,
    parameter integer HP_A1=-128161,HP_A2=62688,LP_ALPHA=9392,
    parameter integer DECIM_RATIO=1,WINDOW_SAMPLES=400,HOP_SAMPLES=100,
    parameter integer RMS_INPUT_SHIFT=12,PACKET_WORDS=1024
)(
    input wire pl_clk,pl_rst_n,axis_clk,axis_rst_n,
    input wire adc_drdy_n,adc_dout,reconfig_n,
    input wire [31:0] control_command,
    output wire [31:0] control_status,
    input wire [31:0] hand_command,
    output wire [31:0] hand_status,
    output wire [5:0] hand_pwm,
    output wire adc_sclk,adc_din,adc_cs_n,adc_reset_n,adc_start,adc_pwdn_n,status_led,
    output wire [31:0] adc_config_status,
    output wire [63:0] m_axis_tdata,
    output wire m_axis_tvalid,input wire m_axis_tready,
    output wire m_axis_tlast,raw_overflow,feature_overflow,result_overflow
);
    (* ASYNC_REG="TRUE" *) reg req_meta,req_sync,ack_meta,ack_sync;
    reg command_ack,recalibrate;
    reg [2:0] shift;
    reg [3:0] epoch;
    wire [1:0] stage;
    wire stale,fault;
    wire [2:0] active;
    wire hand_decision_valid;
    hand_control hand(.clk(pl_clk),.rst_n(pl_rst_n),.axis_clk(axis_clk),.axis_rst_n(axis_rst_n),
        .command(hand_command),.status(hand_status),.pwm(hand_pwm),
        .decision_valid(hand_decision_valid),.decision_ready(stage==2 && !stale && !fault && !recalibrate),
        .decision_class(active));
    always @(posedge pl_clk)begin
        if(!pl_rst_n)begin req_meta<=0;req_sync<=0;command_ack<=0;recalibrate<=0;shift<=0;epoch<=0;end
        else begin
            req_meta<=control_command[31];req_sync<=req_meta;recalibrate<=0;
            if(req_sync!=command_ack)begin
                shift<=control_command[2:0]<6?control_command[2:0]:0;
                epoch<=control_command[7:4];recalibrate<=control_command[3];command_ack<=req_sync;
            end
        end
    end
    wire [15:0] status_pl={4'd0,epoch,1'b0,shift,fault,stale,stage};
    reg [15:0] status_hold,status_axis;
    reg status_req,status_ack;
    (* ASYNC_REG="TRUE" *) reg status_ack_meta,status_ack_sync,status_req_meta,status_req_sync;
    always @(posedge pl_clk)begin
        if(!pl_rst_n)begin status_hold<=0;status_req<=0;status_ack_meta<=0;status_ack_sync<=0;end
        else begin
            status_ack_meta<=status_ack;status_ack_sync<=status_ack_meta;
            if(status_req==status_ack_sync && status_hold!=status_pl)begin
                status_hold<=status_pl;status_req<=!status_req;
            end
        end
    end
    always @(posedge axis_clk)begin
        if(!axis_rst_n)begin ack_meta<=0;ack_sync<=0;status_req_meta<=0;status_req_sync<=0;status_ack<=0;status_axis<=0;end
        else begin
            ack_meta<=command_ack;ack_sync<=ack_meta;
            status_req_meta<=status_req;status_req_sync<=status_req_meta;
            if(status_req_sync!=status_ack)begin status_axis<=status_hold;status_ack<=status_req_sync;end
        end
    end
    assign control_status={16'h504c,ack_sync,status_axis[14:0]};
    emg_pl_export #(.HP_B0(HP_B0),.HP_B1(HP_B1),.HP_B2(HP_B2),.HP_A1(HP_A1),.HP_A2(HP_A2),
        .LP_ALPHA(LP_ALPHA),.DECIM_RATIO(DECIM_RATIO),.WINDOW_SAMPLES(WINDOW_SAMPLES),
        .HOP_SAMPLES(HOP_SAMPLES),.RMS_INPUT_SHIFT(RMS_INPUT_SHIFT),.PACKET_WORDS(PACKET_WORDS),
        .CONTROL_ENABLE(1)) u_core(
        .pl_clk(pl_clk),.pl_rst_n(pl_rst_n),.axis_clk(axis_clk),.axis_rst_n(axis_rst_n),
        .adc_drdy_n(adc_drdy_n),.adc_dout(adc_dout),.reconfig_n(reconfig_n),
        .control_shift(shift),.control_epoch(epoch),.control_recalibrate(recalibrate),
        .control_cal_stage(stage),.control_stale(stale),.control_fault(fault),.control_class(active),
        .control_decision_valid(hand_decision_valid),
        .adc_sclk(adc_sclk),.adc_din(adc_din),.adc_cs_n(adc_cs_n),.adc_reset_n(adc_reset_n),
        .adc_start(adc_start),.adc_pwdn_n(adc_pwdn_n),.status_led(status_led),.adc_config_status(adc_config_status),
        .m_axis_tdata(m_axis_tdata),.m_axis_tvalid(m_axis_tvalid),.m_axis_tready(m_axis_tready),
        .m_axis_tlast(m_axis_tlast),.raw_overflow(raw_overflow),.feature_overflow(feature_overflow),.result_overflow(result_overflow));
endmodule

