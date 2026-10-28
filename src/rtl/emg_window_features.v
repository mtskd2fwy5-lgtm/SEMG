`timescale 1ns/1ps

// Sliding-window EMG feature extractor for one filtered channel.
//
// Computes over WINDOW_SAMPLES with HOP_SAMPLES stride (400/100 samples =
// 100 ms window / 25 ms hop at the native 4 kSPS ADC stream rate, 75%
// overlap):
//   MAV    sum of |x[i]|                                  (feature id 0)
//   WL     sum of |x[i] - x[i-1]|                         (feature id 1)
//   ENERGY sum of (x[i] >>> RMS_INPUT_SHIFT)^2             (feature id 2)
//          (PS computes RMS = sqrt(ENERGY/N) * 2^SHIFT)
//   ZC     count of sign changes with amplitude threshold  (feature id 3)
//   SSC    count of slope sign changes with threshold      (feature id 4)
//
// Sliding is exact and needs no raw sample buffer: the window is split
// into WINDOW/HOP segments, completed segment sums replace the oldest
// segment sums in the window totals, and every feature contribution is
// an integer assigned to the segment of the sample that produced it.
// ZC/SSC events belong to the sample that closes them, so consecutive
// windows never double count or miss a boundary event.
//
// The first sample of the stream contributes no WL/ZC and the first two
// contribute no SSC. WL saturates to 32 bits on output (the 40-bit total
// can only overflow for physically impossible full-scale alternation).
//
// Bit-exact against tools/emg_reference.py.
module emg_window_features #(
    parameter integer SAMPLE_WIDTH = 24,
    parameter integer WINDOW_SAMPLES = 400,
    parameter integer HOP_SAMPLES = 100,
    parameter integer RMS_INPUT_SHIFT = 12,
    parameter signed [SAMPLE_WIDTH-1:0] ZC_THRESHOLD = 0,
    parameter signed [SAMPLE_WIDTH-1:0] SSC_THRESHOLD = 0
) (
    input  wire                           clk,
    input  wire                           rst_n,
    input  wire                           sample_valid,
    input  wire signed [SAMPLE_WIDTH-1:0] sample_in,
    output reg                            window_valid,
    output reg [31:0]                     mav_sum,
    output reg [31:0]                     wl_sum,
    output reg [31:0]                     energy_sum,
    output reg [31:0]                     zc_count,
    output reg [31:0]                     ssc_count
);
    localparam integer SEGMENTS = WINDOW_SAMPLES / HOP_SAMPLES;
    localparam integer SEG_CNT_W = (HOP_SAMPLES <= 2) ? 1 : $clog2(HOP_SAMPLES);
    localparam integer WIN_CNT_W = (WINDOW_SAMPLES <= 2) ? 1 : $clog2(WINDOW_SAMPLES);
    localparam integer SEG_PTR_W = (SEGMENTS <= 2) ? 1 : $clog2(SEGMENTS);
    // At most one ZC/SSC event per accepted sample; preserve the 32-bit
    // public fields while bounding internal counters by segment/window size.
    localparam integer SEG_EVENT_W = (HOP_SAMPLES < 2) ? 1 : $clog2(HOP_SAMPLES+1);
    localparam integer WIN_EVENT_W = (WINDOW_SAMPLES < 2) ? 1 : $clog2(WINDOW_SAMPLES+1);

    // synthesis translate_off
    initial begin
        if (WINDOW_SAMPLES % HOP_SAMPLES != 0) begin
            $display("FATAL: WINDOW_SAMPLES must be a multiple of HOP_SAMPLES");
            $finish;
        end
    end
    // synthesis translate_on

    localparam signed [47:0] CLAMP32_MAX = 48'sd2147483647;
    localparam signed [47:0] CLAMP32_MIN = -48'sd2147483648;

    function [31:0] clamp32;
        input signed [47:0] value;
        begin
            if (value > CLAMP32_MAX)
                clamp32 = 32'h7FFFFFFF;
            else if (value < CLAMP32_MIN)
                clamp32 = 32'h80000000;
            else
                clamp32 = value[31:0];
        end
    endfunction

    reg signed [SAMPLE_WIDTH-1:0] prev, prev2;
    reg have_prev, have_prev2;

    reg [SEG_CNT_W-1:0] seg_count;
    reg [31:0] seg_mav, seg_wl, seg_energy;
    reg [SEG_EVENT_W-1:0] seg_zc, seg_ssc;
    reg [31:0] ring_mav  [0:SEGMENTS-1];
    reg [31:0] ring_wl   [0:SEGMENTS-1];
    reg [31:0] ring_energy [0:SEGMENTS-1];
    reg [SEG_EVENT_W-1:0] ring_zc [0:SEGMENTS-1];
    reg [SEG_EVENT_W-1:0] ring_ssc[0:SEGMENTS-1];
    reg [SEG_PTR_W-1:0] wr_ptr;

    reg signed [39:0] win_mav, win_wl, win_energy;
    reg [WIN_EVENT_W-1:0] win_zc, win_ssc;

    reg priming;
    reg [WIN_CNT_W-1:0] prime_count;
    reg [SEG_CNT_W-1:0] hop_count;

    integer i;

    // Blocking intermediates for one sample step.
    reg signed [SAMPLE_WIDTH:0] abs_x, diff, abs_diff, s1, s2, abs_s1, abs_s2;
    reg signed [SAMPLE_WIDTH-1:0] x_shift;
    reg signed [47:0] x_sq;
    reg zc_event, ssc_event;
    reg seg_done, window_done;
    reg signed [39:0] next_mav, next_wl, next_energy;
    reg [WIN_EVENT_W-1:0] next_zc, next_ssc;
    reg [47:0] clamp_val;

    always @(posedge clk) begin
        window_valid <= 1'b0;
        if (!rst_n) begin
            prev <= {SAMPLE_WIDTH{1'b0}};
            prev2 <= {SAMPLE_WIDTH{1'b0}};
            have_prev <= 1'b0;
            have_prev2 <= 1'b0;
            seg_count <= {SEG_CNT_W{1'b0}};
            seg_mav <= 32'd0;
            seg_wl <= 32'd0;
            seg_energy <= 32'd0;
            seg_zc <= 32'd0;
            seg_ssc <= 32'd0;
            for (i = 0; i < SEGMENTS; i = i + 1) begin
                ring_mav[i] <= 32'd0;
                ring_wl[i] <= 32'd0;
                ring_energy[i] <= 32'd0;
                ring_zc[i] <= 32'd0;
                ring_ssc[i] <= 32'd0;
            end
            wr_ptr <= {SEG_PTR_W{1'b0}};
            win_mav <= 40'sd0;
            win_wl <= 40'sd0;
            win_energy <= 40'sd0;
            win_zc <= 32'd0;
            win_ssc <= 32'd0;
            priming <= 1'b1;
            prime_count <= {WIN_CNT_W{1'b0}};
            hop_count <= {SEG_CNT_W{1'b0}};
            mav_sum <= 32'd0;
            wl_sum <= 32'd0;
            energy_sum <= 32'd0;
            zc_count <= 32'd0;
            ssc_count <= 32'd0;
        end else if (sample_valid) begin
            abs_x = (sample_in < 0) ? -sample_in : sample_in;

            if (have_prev) begin
                diff = sample_in - prev;
                abs_diff = (diff < 0) ? -diff : diff;
                zc_event = (sample_in[SAMPLE_WIDTH-1] != prev[SAMPLE_WIDTH-1])
                           && (abs_diff > ZC_THRESHOLD);
            end else begin
                abs_diff = {SAMPLE_WIDTH+1{1'b0}};
                zc_event = 1'b0;
            end

            if (have_prev && have_prev2) begin
                s2 = sample_in - prev;
                s1 = prev - prev2;
                abs_s1 = (s1 < 0) ? -s1 : s1;
                abs_s2 = (s2 < 0) ? -s2 : s2;
                ssc_event = (s1[SAMPLE_WIDTH] != s2[SAMPLE_WIDTH])
                            && (abs_s1 > SSC_THRESHOLD)
                            && (abs_s2 > SSC_THRESHOLD);
            end else begin
                ssc_event = 1'b0;
            end

            x_shift = sample_in >>> RMS_INPUT_SHIFT;
            x_sq = x_shift * x_shift;

            // Segment and window completion flags for this sample.
            seg_done = (seg_count == HOP_SAMPLES-1);
            window_done = seg_done && (priming
                        ? (prime_count == WINDOW_SAMPLES-1)
                        : (hop_count == HOP_SAMPLES-1));

            if (seg_done) begin
                // Completed window totals: subtract oldest segment, add this one.
                // Cast every unsigned segment register before arithmetic.
                // Without the explicit signed extension, Verilog can
                // promote a mixed expression to unsigned and turn a small
                // sliding-window total into a large positive value that
                // clamps at INT32_MAX on hardware-scale streams.
                next_mav     = win_mav
                             - $signed({1'b0, ring_mav[wr_ptr]})
                             + $signed({1'b0, seg_mav}) + $signed(abs_x);
                next_wl      = win_wl
                             - $signed({1'b0, ring_wl[wr_ptr]})
                             + $signed({1'b0, seg_wl}) + $signed(abs_diff);
                next_energy  = win_energy
                             - $signed({1'b0, ring_energy[wr_ptr]})
                             + $signed({1'b0, seg_energy})
                             + $signed({16'd0, x_sq[31:0]});
                next_zc      = win_zc      - ring_zc[wr_ptr]      + (seg_zc      + zc_event);
                next_ssc     = win_ssc     - ring_ssc[wr_ptr]     + (seg_ssc     + ssc_event);

                ring_mav[wr_ptr]     <= seg_mav + abs_x;
                ring_wl[wr_ptr]      <= seg_wl + abs_diff;
                ring_energy[wr_ptr]  <= seg_energy + x_sq[31:0];
                ring_zc[wr_ptr]      <= seg_zc + zc_event;
                ring_ssc[wr_ptr]     <= seg_ssc + ssc_event;

                win_mav     <= next_mav;
                win_wl      <= next_wl;
                win_energy  <= next_energy;
                win_zc      <= next_zc;
                win_ssc     <= next_ssc;

                seg_mav <= 32'd0;
                seg_wl <= 32'd0;
                seg_energy <= 32'd0;
                seg_zc <= 32'd0;
                seg_ssc <= 32'd0;
                seg_count <= {SEG_CNT_W{1'b0}};
                wr_ptr <= (wr_ptr == SEGMENTS-1) ? {SEG_PTR_W{1'b0}}
                                                 : wr_ptr + 1'b1;
            end else begin
                seg_mav    <= seg_mav + abs_x;
                seg_wl     <= seg_wl + abs_diff;
                seg_energy <= seg_energy + x_sq[31:0];
                seg_zc     <= seg_zc + zc_event;
                seg_ssc    <= seg_ssc + ssc_event;
                seg_count  <= seg_count + 1'b1;
            end

            // Window bookkeeping: first window after WINDOW samples, then
            // one every HOP samples.
            if (priming) begin
                if (prime_count == WINDOW_SAMPLES-1) begin
                    priming <= 1'b0;
                    hop_count <= {SEG_CNT_W{1'b0}};
                end else begin
                    prime_count <= prime_count + 1'b1;
                end
            end else if (hop_count == HOP_SAMPLES-1) begin
                hop_count <= {SEG_CNT_W{1'b0}};
            end else begin
                hop_count <= hop_count + 1'b1;
            end

            if (window_done) begin
                clamp_val = next_mav;
                mav_sum <= clamp32(clamp_val);
                clamp_val = next_wl;
                wl_sum <= clamp32(clamp_val);
                clamp_val = next_energy;
                energy_sum <= clamp32(clamp_val);
                zc_count <= next_zc;
                ssc_count <= next_ssc;
                window_valid <= 1'b1;
            end

            prev2 <= prev;
            prev <= sample_in;
            have_prev2 <= have_prev;
            have_prev <= 1'b1;
        end
    end
endmodule

// Shared arithmetic, independent per-channel contexts. Asynchronous-read
// LUTRAM preserves one accepted sample per cycle, including same-channel
// consecutive samples. Only the small seen bitmap resets; unwritten history
// is masked until each context completes its first full window.
module emg_window_features_shared #(
    parameter integer CHANNELS = 8, CHANNEL_BITS = 3,
    parameter integer SAMPLE_WIDTH = 24,
    parameter integer WINDOW_SAMPLES = 400,
    parameter integer HOP_SAMPLES = 100,
    parameter integer RMS_INPUT_SHIFT = 12,
    parameter signed [SAMPLE_WIDTH-1:0] ZC_THRESHOLD = 0,
    parameter signed [SAMPLE_WIDTH-1:0] SSC_THRESHOLD = 0
) (
    input  wire                           clk,
    input  wire                           rst_n,
    input  wire                           sample_valid,
    input wire [CHANNEL_BITS-1:0] sample_channel,
    output reg [CHANNEL_BITS-1:0] window_channel,
    input  wire signed [SAMPLE_WIDTH-1:0] sample_in,
    output reg                            window_valid,
    output reg [31:0]                     mav_sum,
    output reg [31:0]                     wl_sum,
    output reg [31:0]                     energy_sum,
    output reg [31:0]                     zc_count,
    output reg [31:0]                     ssc_count
);
    localparam integer SEGMENTS = WINDOW_SAMPLES / HOP_SAMPLES;
    localparam integer SEG_CNT_W = (HOP_SAMPLES <= 2) ? 1 : $clog2(HOP_SAMPLES);
    localparam integer WIN_CNT_W = (WINDOW_SAMPLES <= 2) ? 1 : $clog2(WINDOW_SAMPLES);
    localparam integer SEG_PTR_W = (SEGMENTS <= 2) ? 1 : $clog2(SEGMENTS);
    // At most one ZC/SSC event per accepted sample; preserve the 32-bit
    // public fields while bounding internal counters by segment/window size.
    localparam integer SEG_EVENT_W = (HOP_SAMPLES < 2) ? 1 : $clog2(HOP_SAMPLES+1);
    localparam integer WIN_EVENT_W = (WINDOW_SAMPLES < 2) ? 1 : $clog2(WINDOW_SAMPLES+1);

    // synthesis translate_off
    initial begin
        if (WINDOW_SAMPLES % HOP_SAMPLES != 0) begin
            $display("FATAL: WINDOW_SAMPLES must be a multiple of HOP_SAMPLES");
            $finish;
        end
    end
    // synthesis translate_on

    localparam signed [47:0] CLAMP32_MAX = 48'sd2147483647;
    localparam signed [47:0] CLAMP32_MIN = -48'sd2147483648;

    function [31:0] clamp32;
        input signed [47:0] value;
        begin
            if (value > CLAMP32_MAX)
                clamp32 = 32'h7FFFFFFF;
            else if (value < CLAMP32_MIN)
                clamp32 = 32'h80000000;
            else
                clamp32 = value[31:0];
        end
    endfunction

    reg signed [SAMPLE_WIDTH-1:0] prev, prev2;
    reg have_prev, have_prev2;

    reg [SEG_CNT_W-1:0] seg_count;
    reg [31:0] seg_mav, seg_wl, seg_energy;
    reg [SEG_EVENT_W-1:0] seg_zc, seg_ssc;
    reg [SEG_PTR_W-1:0] wr_ptr;

    reg signed [39:0] win_mav, win_wl, win_energy;
    reg [WIN_EVENT_W-1:0] win_zc, win_ssc;

    reg priming;
    reg [WIN_CNT_W-1:0] prime_count;
    reg [SEG_CNT_W-1:0] hop_count;

    integer i;

    // Blocking intermediates for one sample step.
    reg signed [SAMPLE_WIDTH:0] abs_x, diff, abs_diff, s1, s2, abs_s1, abs_s2;
    reg signed [SAMPLE_WIDTH-1:0] x_shift;
    reg signed [47:0] x_sq;
    reg zc_event, ssc_event;
    reg seg_done, window_done;
    reg signed [39:0] next_mav, next_wl, next_energy;
    reg [WIN_EVENT_W-1:0] next_zc, next_ssc;
    reg [47:0] clamp_val;


    localparam integer CONTEXT_W = 2*SAMPLE_WIDTH + 2 + 2*SEG_CNT_W + 96
        + 2*SEG_EVENT_W + SEG_PTR_W + 120 + 2*WIN_EVENT_W + 1 + WIN_CNT_W;
    localparam integer RING_W = 96 + 2*SEG_EVENT_W;
    (* ram_style = "distributed" *) reg [CONTEXT_W-1:0] contexts[0:CHANNELS-1];
    (* ram_style = "distributed" *) reg [RING_W-1:0] history[0:CHANNELS*SEGMENTS-1];
    reg [CHANNELS-1:0] seen;
    wire channel_ok = sample_channel < CHANNELS;
    wire [CONTEXT_W-1:0] initial_context = {{(CONTEXT_W-1){1'b0}},1'b1}
        << (WIN_CNT_W+SEG_CNT_W);
    wire [CONTEXT_W-1:0] context_word = channel_ok && seen[sample_channel]
        ? contexts[sample_channel] : initial_context;
    reg [CONTEXT_W-1:0] context_next;
    integer ring_address;
    reg [31:0] old_mav,old_wl,old_energy,completed_mav,completed_wl,completed_energy;
    reg [SEG_EVENT_W-1:0] old_zc,old_ssc,completed_zc,completed_ssc;
    reg [31:0] result_mav_sum,result_wl_sum,result_energy_sum,result_zc_count,result_ssc_count;

    always @* begin
        {prev,prev2,have_prev,have_prev2,seg_count,seg_mav,seg_wl,seg_energy,seg_zc,seg_ssc,wr_ptr,win_mav,win_wl,win_energy,win_zc,win_ssc,priming,prime_count,hop_count} = context_word;
        ring_address = sample_channel*SEGMENTS + wr_ptr;
        {old_mav,old_wl,old_energy,old_zc,old_ssc} = priming || !channel_ok
            ? {RING_W{1'b0}} : history[ring_address];
        result_mav_sum=0;result_wl_sum=0;result_energy_sum=0;
        result_zc_count=0;result_ssc_count=0;clamp_val=0;
        diff=0;s1=0;s2=0;abs_s1=0;abs_s2=0;
        next_mav=0;next_wl=0;next_energy=0;next_zc=0;next_ssc=0;
            abs_x = (sample_in < 0) ? -sample_in : sample_in;

            if (have_prev) begin
                diff = sample_in - prev;
                abs_diff = (diff < 0) ? -diff : diff;
                zc_event = (sample_in[SAMPLE_WIDTH-1] != prev[SAMPLE_WIDTH-1])
                           && (abs_diff > ZC_THRESHOLD);
            end else begin
                abs_diff = {SAMPLE_WIDTH+1{1'b0}};
                zc_event = 1'b0;
            end

            if (have_prev && have_prev2) begin
                s2 = sample_in - prev;
                s1 = prev - prev2;
                abs_s1 = (s1 < 0) ? -s1 : s1;
                abs_s2 = (s2 < 0) ? -s2 : s2;
                ssc_event = (s1[SAMPLE_WIDTH] != s2[SAMPLE_WIDTH])
                            && (abs_s1 > SSC_THRESHOLD)
                            && (abs_s2 > SSC_THRESHOLD);
            end else begin
                ssc_event = 1'b0;
            end

            x_shift = sample_in >>> RMS_INPUT_SHIFT;
            x_sq = x_shift * x_shift;

            // Segment and window completion flags for this sample.
            seg_done = (seg_count == HOP_SAMPLES-1);
            window_done = seg_done && (priming
                        ? (prime_count == WINDOW_SAMPLES-1)
                        : (hop_count == HOP_SAMPLES-1));

            completed_mav = seg_mav + abs_x;
            completed_wl = seg_wl + abs_diff;
            completed_energy = seg_energy + x_sq[31:0];
            completed_zc = seg_zc + zc_event;
            completed_ssc = seg_ssc + ssc_event;
            if (seg_done) begin
                // Completed window totals: subtract oldest segment, add this one.
                // Cast every unsigned segment register before arithmetic.
                // Without the explicit signed extension, Verilog can
                // promote a mixed expression to unsigned and turn a small
                // sliding-window total into a large positive value that
                // clamps at INT32_MAX on hardware-scale streams.
                next_mav     = win_mav
                             - $signed({1'b0, old_mav})
                             + $signed({1'b0, seg_mav}) + $signed(abs_x);
                next_wl      = win_wl
                             - $signed({1'b0, old_wl})
                             + $signed({1'b0, seg_wl}) + $signed(abs_diff);
                next_energy  = win_energy
                             - $signed({1'b0, old_energy})
                             + $signed({1'b0, seg_energy})
                             + $signed({16'd0, x_sq[31:0]});
                next_zc      = win_zc      - old_zc      + (seg_zc      + zc_event);
                next_ssc     = win_ssc     - old_ssc     + (seg_ssc     + ssc_event);


                win_mav     = next_mav;
                win_wl      = next_wl;
                win_energy  = next_energy;
                win_zc      = next_zc;
                win_ssc     = next_ssc;

                seg_mav = 32'd0;
                seg_wl = 32'd0;
                seg_energy = 32'd0;
                seg_zc = 32'd0;
                seg_ssc = 32'd0;
                seg_count = {SEG_CNT_W{1'b0}};
                wr_ptr = (wr_ptr == SEGMENTS-1) ? {SEG_PTR_W{1'b0}}
                                                 : wr_ptr + 1'b1;
            end else begin
                seg_mav    = seg_mav + abs_x;
                seg_wl     = seg_wl + abs_diff;
                seg_energy = seg_energy + x_sq[31:0];
                seg_zc     = seg_zc + zc_event;
                seg_ssc    = seg_ssc + ssc_event;
                seg_count  = seg_count + 1'b1;
            end

            // Window bookkeeping: first window after WINDOW samples, then
            // one every HOP samples.
            if (priming) begin
                if (prime_count == WINDOW_SAMPLES-1) begin
                    priming = 1'b0;
                    hop_count = {SEG_CNT_W{1'b0}};
                end else begin
                    prime_count = prime_count + 1'b1;
                end
            end else if (hop_count == HOP_SAMPLES-1) begin
                hop_count = {SEG_CNT_W{1'b0}};
            end else begin
                hop_count = hop_count + 1'b1;
            end

            if (window_done) begin
                clamp_val = next_mav;
                result_mav_sum = clamp32(clamp_val);
                clamp_val = next_wl;
                result_wl_sum = clamp32(clamp_val);
                clamp_val = next_energy;
                result_energy_sum = clamp32(clamp_val);
                result_zc_count = next_zc;
                result_ssc_count = next_ssc;

            end

            prev2 = prev;
            prev = sample_in;
            have_prev2 = have_prev;
            have_prev = 1'b1;
        context_next = {prev,prev2,have_prev,have_prev2,seg_count,seg_mav,seg_wl,seg_energy,seg_zc,seg_ssc,wr_ptr,win_mav,win_wl,win_energy,win_zc,win_ssc,priming,prime_count,hop_count};
    end
    // Memory writes deliberately have no array reset to infer LUTRAM.
    always @(posedge clk) begin
        if(rst_n && sample_valid && channel_ok)begin
            contexts[sample_channel] <= context_next;
            if(seg_done)history[ring_address] <=
                {completed_mav,completed_wl,completed_energy,completed_zc,completed_ssc};
        end
    end
    always @(posedge clk) begin
        window_valid<=0;
        if(!rst_n)begin
            seen<=0;window_channel<=0;
            mav_sum<=0;wl_sum<=0;energy_sum<=0;zc_count<=0;ssc_count<=0;
        end else if(sample_valid && channel_ok)begin
            seen[sample_channel]<=1;
            if(window_done)begin
                window_valid<=1;window_channel<=sample_channel;
                mav_sum<=result_mav_sum;wl_sum<=result_wl_sum;energy_sum<=result_energy_sum;
                zc_count<=result_zc_count;ssc_count<=result_ssc_count;
            end
        end
    end
endmodule
