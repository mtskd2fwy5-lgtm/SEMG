`timescale 1ns/1ps

// PL integration shell. ADS1299 samples feed the raw export path and a
// shared notch + comb + signed HP/LP chain. Final output feeds waveform
// export, features (without a second bandpass) and fatigue.
// The merged AXI-Stream output is ready for an AXI DMA S2MM connection.
// The INT8 MLP engine (emg_nn_infer) taps the committed feature words of
// one window at a time and exports its six result words (logits 0..4 +
// argmax class) on the result lane.
module emg_pl_export #(
    // Filter and window parameters forwarded to the feature bank.
    // The six coefficient parameters are plain integers ON PURPOSE.
    // Vivado 2025.2's module_ref OOC top wrapper quotes POSITIVE sized
    // signed parameter values as string literals (.HP_B0("64096")); at
    // elaboration the ASCII bytes get truncated to the parameter width,
    // corrupting the filter (B0/B2 64096 -> 14646, A2 62688 -> -116680,
    // LP_ALPHA 9392 -> 14642; A2 = -1.78 Q16 puts the poles outside the
    // unit circle -> output rails -> MAV = INT_MAX on the board).
    // Integer-typed parameters (like DECIM_RATIO below) and negative
    // values are emitted bare and survive. The downstream feature bank /
    // bandpass keep their signed [17:0]/[15:0] declarations: integer
    // values truncate into them losslessly and the hand-written RTL to
    // RTL instantiation path never goes through the wrapper. 2026-10-08.
    parameter integer HP_B0 = 64096,
    parameter integer HP_B1 = -128192,
    parameter integer HP_B2 = 64096,
    parameter integer HP_A1 = -128161,
    parameter integer HP_A2 = 62688,
    parameter integer LP_ALPHA = 9392,
    // Input decimation gate.  The ADC streams at 4 kSPS and the whole
    // processing chain (feature bank, fatigue monitor) runs on the native
    // rate, so the default DECIM_RATIO = 1 passes every frame.  The gate
    // stays in place for experiments: only every DECIM_RATIO-th 8-channel
    // frame is accepted, the raw export lane always keeps the full rate.
    parameter integer DECIM_RATIO = 1,
    parameter integer WINDOW_SAMPLES = 400,   // 100 ms window at 4 kSPS
    parameter integer HOP_SAMPLES = 100,      // 25 ms hop, 75% overlap
    parameter integer RMS_INPUT_SHIFT = 12,
    // Larger DMA batches reduce PS polling/re-arm overhead.  The packet
    // format is unchanged; TLAST moves to the end of each 16 KB batch.
    parameter integer PACKET_WORDS = 1024,
    parameter integer CONTROL_ENABLE = 0
) (
    input  wire                  pl_clk,
    input  wire                  pl_rst_n,
    input  wire                  axis_clk,
    input  wire                  axis_rst_n,
    input  wire                  adc_drdy_n,
    input  wire                  adc_dout,
    input  wire                  reconfig_n,
    input wire [2:0] control_shift,
    input wire [3:0] control_epoch,
    input wire control_recalibrate,
    output wire [1:0] control_cal_stage,
    output wire control_stale, control_fault,
    output wire [2:0] control_class,
    output wire                  adc_sclk,
    output wire                  adc_din,
    output wire                  adc_cs_n,
    output wire                  adc_reset_n,
    output wire                  adc_start,
    output wire                  adc_pwdn_n,
    output wire                  status_led,
    output reg [31:0]            adc_config_status,
    output wire                 control_decision_valid,
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
    wire [31:0] adc_config_status_pl;
    reg [15:0] raw_sequence;
    wire notch_valid, notch_ready, notch_overrun;
    wire signed [23:0] notch_data;
    wire [2:0] notch_channel;
    wire [15:0] notch_sequence;
    wire raw_fifo_overflow, notch_fifo_overflow;

    wire feature_valid;
    wire [3:0] feature_id;
    wire [2:0] feature_channel;
    wire [31:0] feature_data;
    wire [15:0] feature_sequence;
    wire feature_ready;
    wire feature_export_ready;
    assign feature_ready = CONTROL_ENABLE ? 1'b1 : feature_export_ready;

    ads1299_spi u_ads1299_spi (
        .clk(pl_clk), .rst_n(pl_rst_n), .start(1'b1),
        .reconfig_n(reconfig_n),
        .adc_drdy_n(adc_drdy_n), .adc_dout(adc_dout),
        .adc_sclk(adc_sclk), .adc_din(adc_din), .adc_cs_n(adc_cs_n),
        .adc_reset_n(adc_reset_n), .adc_start(adc_start),
        .adc_pwdn_n(adc_pwdn_n), .sample_valid(sample_valid),
        .sample_data(sample_data), .sample_channel(sample_channel),
        .frame_valid(frame_valid), .busy(busy), .error(error),
        .config_status(adc_config_status_pl)
    );

    // Bundled-data mailbox to the AXI/GPIO clock domain. The payload is
    // held until acknowledgement; only the request/ack toggles cross via
    // two-flop synchronizers. This also publishes WAIT on reconfiguration.
    reg [31:0] adc_status_hold;
    reg adc_status_req;
    reg adc_status_ack;
    (* ASYNC_REG = "TRUE" *) reg adc_ack_meta, adc_ack_sync;
    (* ASYNC_REG = "TRUE" *) reg adc_req_meta, adc_req_sync;
    always @(posedge pl_clk) begin
        if (!pl_rst_n) begin
            adc_status_hold <= 32'd0;
            adc_status_req <= 1'b0;
            adc_ack_meta <= 1'b0;
            adc_ack_sync <= 1'b0;
        end else begin
            adc_ack_meta <= adc_status_ack;
            adc_ack_sync <= adc_ack_meta;
            if (adc_status_req == adc_ack_sync && adc_status_hold != adc_config_status_pl) begin
                adc_status_hold <= adc_config_status_pl;
                adc_status_req <= !adc_status_req;
            end
        end
    end
    always @(posedge axis_clk) begin
        if (!axis_rst_n) begin
            adc_req_meta <= 1'b0;
            adc_req_sync <= 1'b0;
            adc_status_ack <= 1'b0;
            adc_config_status <= 32'd0;
        end else begin
            adc_req_meta <= adc_status_req;
            adc_req_sync <= adc_req_meta;
            if (adc_req_sync != adc_status_ack) begin
                adc_config_status <= adc_status_hold;
                adc_status_ack <= adc_req_sync;
            end
        end
    end

    always @(posedge pl_clk) begin
        if (!pl_rst_n)
            raw_sequence <= 16'd0;
        else if (frame_valid)
            raw_sequence <= raw_sequence + 1'b1;
    end

    // Capture sequence on the input beat, before frame_valid increments
    // raw_sequence. In particular, delayed ch7 must retain its own frame.
    emg_line_filter #(.BANDPASS_ENABLE(1),
        .HP_B0(HP_B0), .HP_B1(HP_B1), .HP_B2(HP_B2),
        .HP_A1(HP_A1), .HP_A2(HP_A2), .LP_ALPHA(LP_ALPHA)) u_notch50 (
        .clk(pl_clk), .rst_n(pl_rst_n), .sample_valid(sample_valid),
        .sample_data(sample_data), .sample_channel(sample_channel),
        .sample_sequence(raw_sequence), .sample_ready(notch_ready),
        .filtered_valid(notch_valid), .filtered_data(notch_data),
        .filtered_channel(notch_channel), .filtered_sequence(notch_sequence),
        .overrun(notch_overrun)
    );

    // ------------------------------------------------------------------
    // Input decimation gate.  sample_valid beats arrive one per channel,
    // eight per frame; the counter advances on the ch7 beat (the frame
    // boundary in the beat stream), so the gate passes exactly the eight
    // beats of one frame out of every DECIM_RATIO frames - never a
    // partial frame - and holds at DECIM_RATIO=1 (the default native-
    // rate configuration).
    // ------------------------------------------------------------------
    localparam integer DECIM_CNT_W = (DECIM_RATIO <= 2) ? 1 : $clog2(DECIM_RATIO);
    localparam [DECIM_CNT_W-1:0] DECIM_LAST = DECIM_RATIO - 1;
    reg [DECIM_CNT_W-1:0] decim_frame_cnt;
    wire gate_sample_valid = notch_valid && (decim_frame_cnt == {DECIM_CNT_W{1'b0}});

    always @(posedge pl_clk) begin
        if (!pl_rst_n)
            decim_frame_cnt <= {DECIM_CNT_W{1'b0}};
        else if (notch_valid && (notch_channel == 3'd7))
            decim_frame_cnt <= (decim_frame_cnt == DECIM_LAST)
                             ? {DECIM_CNT_W{1'b0}} : decim_frame_cnt + 1'b1;
    end

    emg_feature_bank #(
        .BYPASS_BANDPASS(1), // Shared line filter already applied it once.
        .HP_B0(HP_B0), .HP_B1(HP_B1), .HP_B2(HP_B2),
        .HP_A1(HP_A1), .HP_A2(HP_A2), .LP_ALPHA(LP_ALPHA),
        .WINDOW_SAMPLES(WINDOW_SAMPLES),
        .HOP_SAMPLES(HOP_SAMPLES),
        .RMS_INPUT_SHIFT(RMS_INPUT_SHIFT)
    ) u_feature_bank (
        .clk(pl_clk), .rst_n(pl_rst_n),
        .sample_valid(gate_sample_valid), .sample_channel(notch_channel),
        .sample_data(notch_data),
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
    wire nn_out_valid,nn_out_ready;
    wire [2:0] nn_out_id;
    wire [31:0] nn_out_data;
    wire [15:0] nn_seq,decision_seq;
    wire decision_valid;
    assign control_decision_valid=decision_valid;
    wire [31:0] decision_data;
    wire fatigue_muscle_active;
    generate if(CONTROL_ENABLE)begin:g_control
        emg_control_inference u_control(
            .clk(pl_clk),.rst_n(pl_rst_n),.recalibrate(control_recalibrate),
            .shift(control_shift),.epoch(control_epoch),
            .feature_valid(feature_valid),.feature_channel(feature_channel),
            .feature_id(feature_id),.feature_seq(feature_sequence),.feature_data(feature_data),
            .nn_valid(nn_out_valid),.nn_id(nn_out_id),.nn_data(nn_out_data),.nn_seq(nn_seq),
            .decision_valid(decision_valid),.decision_data(decision_data),.decision_seq(decision_seq),
            .cal_stage(control_cal_stage),.stale(control_stale),.fault(control_fault),
            .active_class(control_class),.muscle_active(fatigue_muscle_active));
    end else begin:g_legacy
        assign decision_valid=0;
        assign decision_data=0;
        assign decision_seq=0;
        assign control_cal_stage=0;
        assign control_stale=1;
        assign control_fault=0;
        assign control_class=0;
        // Legacy builds have no calibrated PL gate. Fail closed for fatigue;
        // spectrum/MDF telemetry remains available in both build modes.
        assign fatigue_muscle_active=0;
        assign nn_seq=legacy_seq;
    localparam [1:0] NN_IDLE = 2'd0,   // waiting for a window-start word
                     NN_CAP  = 2'd1,   // capturing the remaining 39 words
                     NN_FEED = 2'd2,   // streaming the window into the engine
                     NN_WAIT = 2'd3;   // results passing through

    reg  [1:0]  nn_state;
    reg  [15:0] legacy_seq;                 // sequence of the window-start word
    reg  [5:0]  nn_win_idx;             // feature index being fed (0..39)
    reg  [31:0] nn_buf [0:39];          // indexed by feature_id*8 + channel

    wire        nn_feat_valid = (nn_state == NN_FEED);
    wire [5:0]  nn_feat_index = nn_win_idx;
    wire [31:0] nn_feat_data  = nn_buf[nn_win_idx];
    wire        nn_feat_ready;

    wire win_start = feature_valid && feature_ready
                   && (feature_id == 4'd0) && (feature_channel == 3'd0);
    wire win_end   = feature_valid && feature_ready
                   && (feature_id == 4'd4) && (feature_channel == 3'd7);

    always @(posedge pl_clk) begin
        if (!pl_rst_n) begin
            nn_state   <= NN_IDLE;
            legacy_seq     <= 16'd0;
            nn_win_idx <= 6'd0;
        end else begin
            case (nn_state)
            NN_IDLE: begin
                if (win_start) begin
                    nn_buf[0] <= feature_data;
                    legacy_seq    <= feature_sequence;
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

    end endgenerate

    // ------------------------------------------------------------------
    // Fatigue monitor: spectral MDF tracking on the same 4 kSPS sample
    // stream, eight fatigue/spectrum result words (id 8..15) every 512 ms
    // window (2048 samples).
    // ------------------------------------------------------------------
    wire        fat_out_valid;
    wire        fat_out_ready;
    wire [3:0]  fat_out_id;
    wire [31:0] fat_out_data;
    wire [15:0] fat_out_sequence;
    wire        result_ready;

    emg_fatigue u_emg_fatigue (
        .clk(pl_clk), .rst_n(pl_rst_n),
        .activity_valid(CONTROL_ENABLE && control_cal_stage==2 &&
                        !control_stale && !control_fault && !control_recalibrate),
        .muscle_active(fatigue_muscle_active),.activity_class(control_class),
        .sample_valid(gate_sample_valid), .sample_channel(notch_channel),
        .sample_data(notch_data),
        .out_valid(fat_out_valid), .out_ready(fat_out_ready),
        .out_id(fat_out_id), .out_data(fat_out_data),
        .out_sequence(fat_out_sequence)
    );

    // result-lane arbiter: the rare fatigue words take priority over the
    // NN words; both sources tolerate backpressure
    assign nn_out_ready = CONTROL_ENABLE ? 1'b1 : result_ready && !fat_out_valid;
    assign fat_out_ready = result_ready && fat_out_valid &&
        (!CONTROL_ENABLE || (!nn_out_valid && !decision_valid));
    wire select_fat = fat_out_valid && (!CONTROL_ENABLE || (!nn_out_valid && !decision_valid));
    wire select_decision = CONTROL_ENABLE && decision_valid && !nn_out_valid;

    emg_data_path #(.PACKET_WORDS(PACKET_WORDS)) u_emg_data_path (
        .pl_clk(pl_clk), .pl_rst_n(pl_rst_n), .axis_clk(axis_clk), .axis_rst_n(axis_rst_n),
        .raw_valid(sample_valid), .raw_ready(), .raw_channel(sample_channel),
        .raw_data(sample_data), .raw_sequence(raw_sequence),
        .notch_valid(notch_valid), .notch_ready(), .notch_channel(notch_channel),
        .notch_data(notch_data), .notch_sequence(notch_sequence),
        .feature_valid(feature_valid), .feature_ready(feature_export_ready),
        .feature_channel(feature_channel), .feature_id(feature_id),
        .feature_data(feature_data), .feature_sequence(feature_sequence),
        .result_valid(nn_out_valid || fat_out_valid || decision_valid),
        .result_ready(result_ready),
        .result_id(select_fat ? fat_out_id : (select_decision ? 4'd6 : {1'b0, nn_out_id})),
        .result_data(select_fat ? fat_out_data : (select_decision ? decision_data : nn_out_data)),
        .result_sequence(select_fat ? fat_out_sequence : (select_decision ? decision_seq : nn_seq)),
        .raw_overflow(raw_fifo_overflow), .notch_overflow(notch_fifo_overflow),
        .feature_overflow(feature_overflow),
        .result_overflow(result_overflow), .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid), .m_axis_tready(m_axis_tready),
        .m_axis_tlast(m_axis_tlast)
    );

    // Preserve the BD port contract: waveform overflow includes either
    // waveform FIFO or a violated notch input timing contract.
    assign raw_overflow = raw_fifo_overflow | notch_fifo_overflow | notch_overrun;

    assign status_led = !busy && !error;
endmodule

