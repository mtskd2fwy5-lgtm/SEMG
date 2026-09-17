`timescale 1ns/1ps

// PL integration shell. ADS1299 samples feed both the raw export path and
// the eight-channel feature bank (bandpass + sliding-window features).
// The merged AXI-Stream output is ready for an AXI DMA S2MM connection.
// The INT8 MLP engine (emg_nn_infer) taps the committed feature words of
// one window at a time and exports its six result words (logits 0..4 +
// argmax class) on the result lane.
module emg_pl_export #(
    // Filter and window parameters forwarded to the feature bank.
    parameter signed [17:0] HP_B0 = 18'sd59967,
    parameter signed [17:0] HP_B1 = -18'sd119934,
    parameter signed [17:0] HP_B2 = 18'sd59967,
    parameter signed [17:0] HP_A1 = -18'sd119462,
    parameter signed [17:0] HP_A2 = 18'sd54864,
    parameter signed [15:0] LP_ALPHA = 16'sd24206,
    parameter integer WINDOW_SAMPLES = 200,
    parameter integer HOP_SAMPLES = 50,
    parameter integer RMS_INPUT_SHIFT = 12
) (
    input  wire                  pl_clk,
    input  wire                  pl_rst_n,
    input  wire                  axis_clk,
    input  wire                  axis_rst_n,
    input  wire                  adc_drdy_n,
    input  wire                  adc_dout,
    output wire                  adc_sclk,
    output wire                  adc_din,
    output wire                  adc_cs_n,
    output wire                  adc_reset_n,
    output wire                  adc_start,
    output wire                  adc_pwdn_n,
    output wire                  status_led,
    output wire [63:0]           m_axis_tdata,
    output wire                  m_axis_tvalid,
    input  wire                  m_axis_tready,
    output wire                  m_axis_tlast,
    output wire                  raw_overflow,
    output wire                  feature_overflow,
    output wire                  result_overflow
);
    wire sample_valid;
    wire signed [23:0] sample_data;
    wire [2:0] sample_channel;
    wire frame_valid;
    wire busy;
    wire error;
    reg [15:0] raw_sequence;

    wire feature_valid;
    wire [3:0] feature_id;
    wire [2:0] feature_channel;
    wire [31:0] feature_data;
    wire [15:0] feature_sequence;
    wire feature_ready;

    ads1299_spi u_ads1299_spi (
        .clk(pl_clk), .rst_n(pl_rst_n), .start(1'b1),
        .adc_drdy_n(adc_drdy_n), .adc_dout(adc_dout),
        .adc_sclk(adc_sclk), .adc_din(adc_din), .adc_cs_n(adc_cs_n),
        .adc_reset_n(adc_reset_n), .adc_start(adc_start),
        .adc_pwdn_n(adc_pwdn_n), .sample_valid(sample_valid),
        .sample_data(sample_data), .sample_channel(sample_channel),
        .frame_valid(frame_valid), .busy(busy), .error(error)
    );

    always @(posedge pl_clk) begin
        if (!pl_rst_n)
            raw_sequence <= 16'd0;
        else if (frame_valid)
            raw_sequence <= raw_sequence + 1'b1;
    end

    emg_feature_bank #(
        .HP_B0(HP_B0), .HP_B1(HP_B1), .HP_B2(HP_B2),
        .HP_A1(HP_A1), .HP_A2(HP_A2), .LP_ALPHA(LP_ALPHA),
        .WINDOW_SAMPLES(WINDOW_SAMPLES),
        .HOP_SAMPLES(HOP_SAMPLES),
        .RMS_INPUT_SHIFT(RMS_INPUT_SHIFT)
    ) u_feature_bank (
        .clk(pl_clk), .rst_n(pl_rst_n),
        .sample_valid(sample_valid), .sample_channel(sample_channel),
        .sample_data(sample_data),
        .feature_ready(feature_ready), .feature_valid(feature_valid),
        .feature_id(feature_id), .feature_channel(feature_channel),
        .feature_data(feature_data), .feature_sequence(feature_sequence)
    );

    // ------------------------------------------------------------------
    // On-device inference: capture the 40 committed feature words of one
    // window (tap on the same handshake the export path accepts), feed
    // them to the INT8 MLP engine and pass the six result words into the
    // result lane.  A window is only captured while the engine is idle;
    // windows arriving mid-inference are skipped (they still stream to
    // the PS via the feature lane).  Engine cadence: ~5.6k cycles per
    // window vs >=50 ms between windows, so skipping is the exception.
    // ------------------------------------------------------------------
    localparam [1:0] NN_IDLE = 2'd0,   // waiting for a window-start word
                     NN_CAP  = 2'd1,   // capturing the remaining 39 words
                     NN_FEED = 2'd2,   // streaming the window into the engine
                     NN_WAIT = 2'd3;   // results passing through

    reg  [1:0]  nn_state;
    reg  [15:0] nn_seq;                 // sequence of the window-start word
    reg  [5:0]  nn_win_idx;             // feature index being fed (0..39)
    reg  [31:0] nn_buf [0:39];          // indexed by feature_id*8 + channel

    wire        nn_feat_valid = (nn_state == NN_FEED);
    wire [5:0]  nn_feat_index = nn_win_idx;
    wire [31:0] nn_feat_data  = nn_buf[nn_win_idx];
    wire        nn_feat_ready;
    wire        nn_out_valid;
    wire        nn_out_ready;
    wire [2:0]  nn_out_id;
    wire [31:0] nn_out_data;

    wire win_start = feature_valid && feature_ready
                   && (feature_id == 4'd0) && (feature_channel == 3'd0);
    wire win_end   = feature_valid && feature_ready
                   && (feature_id == 4'd4) && (feature_channel == 3'd7);

    always @(posedge pl_clk) begin
        if (!pl_rst_n) begin
            nn_state   <= NN_IDLE;
            nn_seq     <= 16'd0;
            nn_win_idx <= 6'd0;
        end else begin
            case (nn_state)
            NN_IDLE: begin
                if (win_start) begin
                    nn_buf[0] <= feature_data;
                    nn_seq    <= feature_sequence;
                    nn_state  <= NN_CAP;
                end
            end
            NN_CAP: begin
                if (feature_valid && feature_ready) begin
                    nn_buf[{feature_id[2:0], feature_channel}] <= feature_data;
                    if (win_end)
                        nn_state <= NN_FEED;
                end
            end
            NN_FEED: begin
                if (nn_feat_valid && nn_feat_ready) begin
                    if (nn_win_idx == 6'd39) begin
                        nn_win_idx <= 6'd0;
                        nn_state   <= NN_WAIT;
                    end else begin
                        nn_win_idx <= nn_win_idx + 6'd1;
                    end
                end
            end
            NN_WAIT: begin
                // window closes when the class word (id 5) is accepted
                if (nn_out_valid && nn_out_ready && nn_out_id == 3'd5)
                    nn_state <= NN_IDLE;
            end
            endcase
        end
    end

    emg_nn_infer u_nn_infer (
        .clk(pl_clk), .rst_n(pl_rst_n),
        .feat_valid(nn_feat_valid), .feat_index(nn_feat_index),
        .feat_data(nn_feat_data), .feat_ready(nn_feat_ready),
        .out_valid(nn_out_valid), .out_ready(nn_out_ready),
        .out_id(nn_out_id), .out_data(nn_out_data)
    );

    // ------------------------------------------------------------------
    // Fatigue monitor: spectral MDF tracking on the same sample stream,
    // two result words (id 8/9) every 512 ms window.
    // ------------------------------------------------------------------
    wire        fat_out_valid;
    wire        fat_out_ready;
    wire [3:0]  fat_out_id;
    wire [31:0] fat_out_data;
    wire [15:0] fat_out_sequence;
    wire        result_ready;

    emg_fatigue u_emg_fatigue (
        .clk(pl_clk), .rst_n(pl_rst_n),
        .sample_valid(sample_valid), .sample_channel(sample_channel),
        .sample_data(sample_data),
        .out_valid(fat_out_valid), .out_ready(fat_out_ready),
        .out_id(fat_out_id), .out_data(fat_out_data),
        .out_sequence(fat_out_sequence)
    );

    // result-lane arbiter: the rare fatigue words take priority over the
    // NN words; both sources tolerate backpressure
    assign nn_out_ready = result_ready && !fat_out_valid;
    assign fat_out_ready = result_ready && fat_out_valid;

    emg_data_path u_emg_data_path (
        .pl_clk(pl_clk), .pl_rst_n(pl_rst_n), .axis_clk(axis_clk), .axis_rst_n(axis_rst_n),
        .raw_valid(sample_valid), .raw_ready(), .raw_channel(sample_channel),
        .raw_data(sample_data), .raw_sequence(raw_sequence),
        .feature_valid(feature_valid), .feature_ready(feature_ready),
        .feature_channel(feature_channel), .feature_id(feature_id),
        .feature_data(feature_data), .feature_sequence(feature_sequence),
        .result_valid(nn_out_valid || fat_out_valid),
        .result_ready(result_ready),
        .result_id(fat_out_valid ? fat_out_id : {1'b0, nn_out_id}),
        .result_data(fat_out_valid ? fat_out_data : nn_out_data),
        .result_sequence(fat_out_valid ? fat_out_sequence : nn_seq),
        .raw_overflow(raw_overflow), .feature_overflow(feature_overflow),
        .result_overflow(result_overflow), .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid), .m_axis_tready(m_axis_tready),
        .m_axis_tlast(m_axis_tlast)
    );

    assign status_led = !busy && !error;
endmodule
