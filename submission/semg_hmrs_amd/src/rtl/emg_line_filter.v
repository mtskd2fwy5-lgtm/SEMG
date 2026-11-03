`timescale 1ns/1ps

// Shared waveform/recognition chain: 50 Hz notch, comb, optional HP/LP.
// Raw export bypasses all stages. See emg_reference.ProcessedSignal.
module emg_line_filter #(
    parameter integer BANDPASS_ENABLE = 0,
    parameter integer HP_B0 = 64096, HP_B1 = -128192, HP_B2 = 64096,
    parameter integer HP_A1 = -128161, HP_A2 = 62688, LP_ALPHA = 9392
) (
    input wire clk, rst_n, sample_valid,
    input wire signed [23:0] sample_data,
    input wire [2:0] sample_channel,
    input wire [15:0] sample_sequence,
    output wire sample_ready, filtered_valid,
    output wire signed [23:0] filtered_data,
    output wire [2:0] filtered_channel,
    output wire [15:0] filtered_sequence,
    output wire overrun
);
    wire notch_valid, notch_ready, notch_overrun, comb_ready, comb_overrun;
    wire signed [23:0] notch_data;
    wire [2:0] notch_channel;
    wire [15:0] notch_sequence;
    wire comb_valid;
    wire signed [23:0] comb_data;
    wire [2:0] comb_channel;
    wire [15:0] comb_sequence;
    // Comb consumes a beat in 8 clocks, faster than the 12-clock notch.
    assign sample_ready=notch_ready;
    assign overrun=notch_overrun || comb_overrun;
    emg_notch50 notch (
        .clk(clk),.rst_n(rst_n),.sample_valid(sample_valid),.sample_data(sample_data),
        .sample_channel(sample_channel),.sample_sequence(sample_sequence),.sample_ready(notch_ready),
        .filtered_valid(notch_valid),.filtered_data(notch_data),
        .filtered_channel(notch_channel),.filtered_sequence(notch_sequence),.overrun(notch_overrun));
    emg_comb50 comb (
        .clk(clk),.rst_n(rst_n),.sample_valid(notch_valid),.sample_data(notch_data),
        .sample_channel(notch_channel),.sample_sequence(notch_sequence),.sample_ready(comb_ready),
        .filtered_valid(comb_valid),.filtered_data(comb_data),
        .filtered_channel(comb_channel),.filtered_sequence(comb_sequence),.overrun(comb_overrun));

    generate if (BANDPASS_ENABLE) begin : final_bandpass
        wire bp_valid;
        wire signed [23:0] bp_data;
        reg [2:0] channel_q;
        reg [15:0] sequence_q;
        always @(posedge clk) begin
            if (!rst_n) begin channel_q<=0; sequence_q<=0; end
            else if (comb_valid) begin channel_q<=comb_channel; sequence_q<=comb_sequence; end
        end
            emg_bandpass_shared #(.HP_B0(HP_B0),.HP_B1(HP_B1),.HP_B2(HP_B2),
                           .HP_A1(HP_A1),.HP_A2(HP_A2),.LP_ALPHA(LP_ALPHA),
                           .FRACTION_SAVE(1)) u_bandpass (
                .clk(clk),.rst_n(rst_n),.sample_valid(comb_valid),.sample_channel(comb_channel),
                .sample_in(comb_data),.filtered_valid(bp_valid),.filtered_out(bp_data));
        assign filtered_valid=bp_valid;
        assign filtered_data=bp_data;
        assign filtered_channel=channel_q;
        assign filtered_sequence=sequence_q;
    end else begin : no_bandpass
        assign filtered_valid=comb_valid;
        assign filtered_data=comb_data;
        assign filtered_channel=comb_channel;
        assign filtered_sequence=comb_sequence;
    end endgenerate
endmodule

