`timescale 1ns/1ps

// Eight-channel EMG feature bank.
//
// Demultiplexes the serialized ADS1299 sample stream (one sample_valid
// beat per channel, channels 0..7 per frame) into per-channel
// bandpass + sliding-window feature pipelines, then serializes completed
// feature windows into one feature-word stream for emg_data_path.
//
// Feature ids: 0 = MAV, 1 = WL, 2 = ENERGY, 3 = ZC, 4 = SSC.
// A completed window produces five consecutive words, channel by channel
// in round-robin order. feature_sequence counts accepted words globally
// so the PS side can detect drops.
//
// Handshake: hold feature_valid until feature_ready is seen. feature_ready
// comes from the feature FIFO write side of emg_data_path (pl_clk domain).
module emg_feature_bank #(
    parameter integer CHANNELS = 8,
    parameter integer CHANNEL_BITS = 3,
    parameter integer SAMPLE_WIDTH = 24,
    parameter integer BYPASS_BANDPASS = 0,
    // Filter / window parameters forwarded to the per-channel chains.
    parameter signed [17:0] HP_B0 = 18'sd64096,
    parameter signed [17:0] HP_B1 = -18'sd128192,
    parameter signed [17:0] HP_B2 = 18'sd64096,
    parameter signed [17:0] HP_A1 = -18'sd128161,
    parameter signed [17:0] HP_A2 = 18'sd62688,
    parameter signed [15:0] LP_ALPHA = 16'sd9392,
    parameter integer WINDOW_SAMPLES = 400,   // 100 ms window at 4 kSPS
    parameter integer HOP_SAMPLES = 100,      // 25 ms hop, 75% overlap
    parameter integer RMS_INPUT_SHIFT = 12,
    parameter signed [SAMPLE_WIDTH-1:0] ZC_THRESHOLD = 0,
    parameter signed [SAMPLE_WIDTH-1:0] SSC_THRESHOLD = 0
) (
    input  wire                            clk,
    input  wire                            rst_n,
    input  wire                            sample_valid,
    input  wire [CHANNEL_BITS-1:0]         sample_channel,
    input  wire signed [SAMPLE_WIDTH-1:0]  sample_data,
    input  wire                            feature_ready,
    output wire                            feature_valid,
    output wire [3:0]                      feature_id,
    output wire [CHANNEL_BITS-1:0]         feature_channel,
    output wire [31:0]                     feature_data,
    output reg  [15:0]                     feature_sequence
);
    localparam integer CH_PTR_W = (CHANNELS <= 2) ? 1 : $clog2(CHANNELS);

    // Per-channel chain outputs.
    wire [CHANNELS-1:0] wf_valid;
    wire [31:0] wf_mav   [0:CHANNELS-1];
    wire [31:0] wf_wl    [0:CHANNELS-1];
    wire [31:0] wf_energy [0:CHANNELS-1];
    wire [31:0] wf_zc    [0:CHANNELS-1];
    wire [31:0] wf_ssc   [0:CHANNELS-1];

    wire shared_valid;
    wire [CHANNEL_BITS-1:0] shared_channel;
    wire [31:0] shared_mav,shared_wl,shared_energy,shared_zc,shared_ssc;
    genvar g;
    generate
      if(BYPASS_BANDPASS)begin : shared_features
        emg_window_features_shared #(.CHANNELS(CHANNELS),.CHANNEL_BITS(CHANNEL_BITS),
            .SAMPLE_WIDTH(SAMPLE_WIDTH),.WINDOW_SAMPLES(WINDOW_SAMPLES),
            .HOP_SAMPLES(HOP_SAMPLES),.RMS_INPUT_SHIFT(RMS_INPUT_SHIFT),
            .ZC_THRESHOLD(ZC_THRESHOLD),.SSC_THRESHOLD(SSC_THRESHOLD)) u_features (
            .clk(clk),.rst_n(rst_n),.sample_valid(sample_valid),.sample_channel(sample_channel),
            .sample_in(sample_data),.window_valid(shared_valid),.window_channel(shared_channel),
            .mav_sum(shared_mav),.wl_sum(shared_wl),.energy_sum(shared_energy),
            .zc_count(shared_zc),.ssc_count(shared_ssc));
        for(g=0;g<CHANNELS;g=g+1)begin : channel_outputs
            assign wf_valid[g]=shared_valid && shared_channel==g;
            assign wf_mav[g]=shared_mav;
            assign wf_wl[g]=shared_wl;
            assign wf_energy[g]=shared_energy;
            assign wf_zc[g]=shared_zc;
            assign wf_ssc[g]=shared_ssc;
        end
      end else begin : local_features
        assign shared_valid=0;
        assign shared_channel=0;
        assign shared_mav=0;assign shared_wl=0;assign shared_energy=0;
        assign shared_zc=0;assign shared_ssc=0;
        for (g = 0; g < CHANNELS; g = g + 1) begin : gen_ch
            wire ch_sample_valid = sample_valid && (sample_channel == g);
            wire bp_valid;
            wire signed [SAMPLE_WIDTH-1:0] bp_out;

            if (BYPASS_BANDPASS) begin : shared_filtered_input
                assign bp_valid=ch_sample_valid;
                assign bp_out=sample_data;
            end else begin : local_bandpass
            emg_bandpass #(
                .SAMPLE_WIDTH(SAMPLE_WIDTH),
                .HP_B0(HP_B0), .HP_B1(HP_B1), .HP_B2(HP_B2),
                .HP_A1(HP_A1), .HP_A2(HP_A2), .LP_ALPHA(LP_ALPHA)
            ) u_bandpass (
                .clk(clk), .rst_n(rst_n),
                .sample_valid(ch_sample_valid), .sample_in(sample_data),
                .filtered_valid(bp_valid), .filtered_out(bp_out)
            );
            end

            emg_window_features #(
                .SAMPLE_WIDTH(SAMPLE_WIDTH),
                .WINDOW_SAMPLES(WINDOW_SAMPLES),
                .HOP_SAMPLES(HOP_SAMPLES),
                .RMS_INPUT_SHIFT(RMS_INPUT_SHIFT),
                .ZC_THRESHOLD(ZC_THRESHOLD),
                .SSC_THRESHOLD(SSC_THRESHOLD)
            ) u_features (
                .clk(clk), .rst_n(rst_n),
                .sample_valid(bp_valid), .sample_in(bp_out),
                .window_valid(wf_valid[g]),
                .mav_sum(wf_mav[g]), .wl_sum(wf_wl[g]),
                .energy_sum(wf_energy[g]),
                .zc_count(wf_zc[g]), .ssc_count(wf_ssc[g])
            );
        end
      end
    endgenerate

    // Holding registers and pending flags for completed windows.
    (* ram_style="distributed" *) reg [159:0] hold_mem[0:CHANNELS-1];
    reg [CHANNELS-1:0] hold_seen;
    reg [CHANNELS-1:0] pending;

    // Serializer state.
    reg busy;
    reg [CH_PTR_W-1:0] active_ch;
    reg [2:0] fidx;
    reg [CH_PTR_W-1:0] scan_ptr;

    integer i;

    // Payload mux. Deliberately an always @(*) block, not a function inside
    // a continuous assign: function-call assigns are only sensitive to the
    // call arguments on some simulators, so a hold-register update with
    // unchanged fidx/active_ch (the very first word after reset) would
    // emit a stale payload.
    reg [31:0] feature_data_mux;
    wire [159:0] hold_word=hold_seen[active_ch] ? hold_mem[active_ch] : 160'd0;
    always @(*) begin
        case (fidx)
            3'd0:    feature_data_mux = hold_word[159:128];
            3'd1:    feature_data_mux = hold_word[127:96];
            3'd2:    feature_data_mux = hold_word[95:64];
            3'd3:    feature_data_mux = hold_word[63:32];
            default: feature_data_mux = hold_word[31:0];
        endcase
    end

    assign feature_valid   = busy;
    assign feature_channel = active_ch;
    assign feature_id      = fidx;
    assign feature_data    = feature_data_mux;

    // Payload memories are masked by resettable seen bits. Keeping the
    // arrays outside reset allows RAM inference without exposing stale data.
    generate if(BYPASS_BANDPASS)begin : shared_capture
        always @(posedge clk)
            if(rst_n && shared_valid)hold_mem[shared_channel] <=
                {shared_mav,shared_wl,shared_energy,shared_zc,shared_ssc};
    end else begin : local_capture
        for(g=0;g<CHANNELS;g=g+1)begin : ch
            always @(posedge clk)
                if(rst_n && wf_valid[g])hold_mem[g] <=
                    {wf_mav[g],wf_wl[g],wf_energy[g],wf_zc[g],wf_ssc[g]};
        end
    end endgenerate

    // Window capture, pending management and the serializer share one
    // clocked process so pending bits have a single driver. On a
    // same-cycle collision (impossible at the 4 kSPS sample pacing) the
    // capture below wins over the serializer clear above it.
    always @(posedge clk) begin
        if (!rst_n) begin
            pending <= {CHANNELS{1'b0}};
            busy <= 1'b0;
            active_ch <= {CH_PTR_W{1'b0}};
            fidx <= 3'd0;
            scan_ptr <= {CH_PTR_W{1'b0}};
            feature_sequence <= 16'd0;
            hold_seen <= 0;
        end else begin
            // Serializer: clear first so a simultaneous capture wins.
            if (busy && feature_ready) begin
                if (fidx == 3'd4) begin
                    pending[active_ch] <= 1'b0;
                    busy <= 1'b0;
                    scan_ptr <= (active_ch == CHANNELS-1) ? {CH_PTR_W{1'b0}}
                                                          : active_ch + 1'b1;
                end else begin
                    fidx <= fidx + 1'b1;
                end
                feature_sequence <= feature_sequence + 1'b1;
            end else if (!busy) begin
                if (pending[scan_ptr]) begin
                    active_ch <= scan_ptr;
                    fidx <= 3'd0;
                    busy <= 1'b1;
                end else if (scan_ptr != CHANNELS-1) begin
                    scan_ptr <= scan_ptr + 1'b1;
                end else begin
                    scan_ptr <= {CH_PTR_W{1'b0}};
                end
            end

            // Capture completed windows.
            for (i = 0; i < CHANNELS; i = i + 1) begin
                if (wf_valid[i]) begin
                    hold_seen[i]   <= 1'b1;
                    pending[i]     <= 1'b1;
                end
            end
        end
    end
endmodule
