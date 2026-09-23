`timescale 1ns/1ps

// Per-channel EMG bandpass filter for the native 4 kSPS ADS1299 stream.
//
// Stage 1: 2nd-order Butterworth high-pass, target fc = 20 Hz, Q16
//          fixed-point coefficients, Direct Form I. The fed-back states
//          are the quantized SAMPLE_WIDTH-bit outputs, not the wide
//          accumulator. HP_B1 = -(HP_B0+HP_B2) so the DC gain is exactly
//          zero.
// Stage 2: 1st-order low-pass, pole matched to fc = 215 Hz, Q15
//          coefficient.
//
// Coefficient derivation (ideal reals before Q16/Q15 rounding), RBJ
// cookbook Butterworth Q = 1/sqrt(2) at fs = 4 kSPS:
//   HP: w0 = 2*pi*20/4000, alpha = sin(w0)/sqrt(2) = 0.0222129
//       b0 = b2 = 0.978030, b1 = -1.956061 (= -2*b0),
//       a1 = -1.955587, a2 = 0.956542
//   LP: alpha = 0.286606 (= 1 - exp(-2*pi*215/4000))
// The response matches the original 1 kSPS design (fc = 20 Hz corner,
// same pole time constants); below ~15 Hz the quantization noise floor
// limits the attenuation to about -12 dB at 10 Hz.
//
// The RTL is bit-exact against the fixed-point reference model in
// tools/emg_reference.py. Any change here must be mirrored there.
module emg_bandpass #(
    parameter integer SAMPLE_WIDTH = 24,
    // 2nd-order Butterworth high-pass, fc = 20 Hz @ 4 kSPS, Q16.
    parameter signed [17:0] HP_B0 = 18'sd64096,
    parameter signed [17:0] HP_B1 = -18'sd128192,
    parameter signed [17:0] HP_B2 = 18'sd64096,
    parameter signed [17:0] HP_A1 = -18'sd128161,
    parameter signed [17:0] HP_A2 = 18'sd62688,
    // 1st-order low-pass, fc = 215 Hz @ 4 kSPS, Q15.
    parameter signed [15:0] LP_ALPHA = 16'sd9392
) (
    input  wire                           clk,
    input  wire                           rst_n,
    input  wire                           sample_valid,
    input  wire signed [SAMPLE_WIDTH-1:0] sample_in,
    output reg                            filtered_valid,
    output reg  signed [SAMPLE_WIDTH-1:0] filtered_out
);
    // Five 24x18 products plus summation margin.
    localparam integer ACC_WIDTH = SAMPLE_WIDTH + 18 + 3;
    localparam signed [47:0] SAT_MAX = (48'sd1 <<< (SAMPLE_WIDTH-1)) - 48'sd1;
    localparam signed [47:0] SAT_MIN = -(48'sd1 <<< (SAMPLE_WIDTH-1));

    function signed [47:0] sat_to_input;
        input signed [47:0] value;
        begin
            if (value > SAT_MAX)
                sat_to_input = SAT_MAX;
            else if (value < SAT_MIN)
                sat_to_input = SAT_MIN;
            else
                sat_to_input = value;
        end
    endfunction

    reg signed [SAMPLE_WIDTH-1:0] hp_x1, hp_x2;
    reg signed [SAMPLE_WIDTH-1:0] hp_y1, hp_y2;
    reg signed [SAMPLE_WIDTH-1:0] lp_y;

    // Blocking-assignment intermediates (evaluated in zero time inside
    // the clocked block; never read across clock edges).
    reg signed [ACC_WIDTH-1:0]   hp_acc;
    reg signed [47:0]            hp_shift;
    reg signed [47:0]            sat_val;
    reg signed [SAMPLE_WIDTH-1:0] hp_y;
    reg signed [SAMPLE_WIDTH:0]  lp_diff;
    reg signed [40:0]            lp_prod;
    reg signed [41:0]            lp_sum;

    always @(posedge clk) begin
        filtered_valid <= 1'b0;
        if (!rst_n) begin
            hp_x1 <= {SAMPLE_WIDTH{1'b0}};
            hp_x2 <= {SAMPLE_WIDTH{1'b0}};
            hp_y1 <= {SAMPLE_WIDTH{1'b0}};
            hp_y2 <= {SAMPLE_WIDTH{1'b0}};
            lp_y  <= {SAMPLE_WIDTH{1'b0}};
            filtered_out <= {SAMPLE_WIDTH{1'b0}};
        end else if (sample_valid) begin
            // High-pass biquad: y = (b0*x + b1*x1 + b2*x2 - a1*y1 - a2*y2) >> 16
            hp_acc = HP_B0 * sample_in
                   + HP_B1 * hp_x1
                   + HP_B2 * hp_x2
                   - HP_A1 * hp_y1
                   - HP_A2 * hp_y2;
            hp_shift = hp_acc >>> 16;      // sign-extends to 48 bits
            sat_val = sat_to_input(hp_shift);
            hp_y = sat_val[SAMPLE_WIDTH-1:0];

            // Low-pass: y += (alpha * (x - y)) >> 15
            lp_diff = hp_y - lp_y;
            lp_prod = LP_ALPHA * lp_diff;
            lp_sum  = lp_y + (lp_prod >>> 15);
            sat_val = sat_to_input(lp_sum);
            lp_y    = sat_val[SAMPLE_WIDTH-1:0];

            filtered_out  <= lp_y;
            filtered_valid <= 1'b1;
            hp_x2 <= hp_x1;
            hp_x1 <= sample_in;
            hp_y2 <= hp_y1;
            hp_y1 <= hp_y;
        end
    end
endmodule
