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
//
// Coefficient registers (2026-10-08 MAV-saturation incident): the six
// coefficients reach this module through three levels of parameter
// forwarding (emg_pl_export -> emg_feature_bank -> here). The root
// cause of the corruption was NOT synthesis: Vivado 2025.2's module_ref
// OOC top wrapper writes POSITIVE sized signed parameter values as
// QUOTED STRING literals (e.g. .HP_B0("64096")), and elaboration
// truncates the ASCII bytes to the parameter width (B0/B2 64096 ->
// 14646, A2 62688 -> -116680, LP_ALPHA 9392 -> 14642) while negative
// values and integer-typed parameters pass through bare and correct.
// A2 = -1.78 in Q16 pushed the poles outside the unit circle and
// railed every channel (board symptom: MAV = INT_MAX). The fix lives
// in emg_pl_export.v: the six parameters are declared `parameter
// integer` there, which the wrapper emits unquoted.
// The dont_touch coefficient registers below are retained as a netlist
// verification anchor: tmp/verify_coeff_regs.py decodes the Q16/Q15
// values straight from the FF INIT attributes of the synthesized
// netlist (bandpass_0..7), so any parameter-binding regression is
// caught before a bitstream is packed. Without dont_touch, sequential
// constant propagation would fold the registers away and remove that
// anchor.
// Post-synth checks: tmp/scan_literal_b.py reports zero literal-B DSPs;
// tmp/verify_coeff_regs.py reports ALL COEFFICIENT REGISTERS CORRECT.
module emg_bandpass #(
    parameter integer SAMPLE_WIDTH = 24,
    // Preserve discarded fractions in the final export chain. Default 0
    // retains historical standalone/training arithmetic bit for bit.
    parameter integer FRACTION_SAVE = 0,
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
    reg [15:0] hp_fraction;
    reg [14:0] lp_fraction;

    // Filter coefficients in registers (see header note). Declared with
    // bitstream init AND reset-loaded; either path alone would suffice.
    (* dont_touch = "true" *) reg signed [17:0] b0_r = HP_B0;
    (* dont_touch = "true" *) reg signed [17:0] b1_r = HP_B1;
    (* dont_touch = "true" *) reg signed [17:0] b2_r = HP_B2;
    (* dont_touch = "true" *) reg signed [17:0] a1_r = HP_A1;
    (* dont_touch = "true" *) reg signed [17:0] a2_r = HP_A2;
    (* dont_touch = "true" *) reg signed [15:0] alpha_r = LP_ALPHA;

    always @(posedge clk) begin
        if (!rst_n) begin
            b0_r    <= HP_B0;
            b1_r    <= HP_B1;
            b2_r    <= HP_B2;
            a1_r    <= HP_A1;
            a2_r    <= HP_A2;
            alpha_r <= LP_ALPHA;
        end
    end

    // Combinational datapath as continuous assignments. The previous
    // version used module-level regs assigned with blocking assignments
    // inside the clocked block; Vivado inferred them as registers
    // (Synth 8-6014 "Unused sequential element ... was removed") and the
    // resulting netlist implemented a different filter than the RTL,
    // which was unstable in the full-design synthesis context. Wires
    // leave no such ambiguity.
    wire signed [ACC_WIDTH-1:0] hp_acc_w = b0_r * sample_in
                                          + b1_r * hp_x1
                                          + b2_r * hp_x2
                                          - a1_r * hp_y1
                                          - a2_r * hp_y2
                                          + (FRACTION_SAVE ? $signed({1'b0,hp_fraction}) : 17'sd0);
    wire signed [47:0] hp_sat_w = sat_to_input(hp_acc_w >>> 16);
    wire signed [SAMPLE_WIDTH-1:0] hp_y_w = hp_sat_w[SAMPLE_WIDTH-1:0];

    wire signed [SAMPLE_WIDTH:0] lp_diff_w = hp_y_w - lp_y;
    wire signed [40:0] lp_prod_w = alpha_r * lp_diff_w
                                 + (FRACTION_SAVE ? $signed({1'b0,lp_fraction}) : 16'sd0);
    wire signed [41:0] lp_sum_w = lp_y + (lp_prod_w >>> 15);
    wire signed [47:0] lp_sat_w = sat_to_input(lp_sum_w);
    wire signed [SAMPLE_WIDTH-1:0] lp_y_w = lp_sat_w[SAMPLE_WIDTH-1:0];

    always @(posedge clk) begin
        filtered_valid <= 1'b0;
        if (!rst_n) begin
            hp_x1 <= {SAMPLE_WIDTH{1'b0}};
            hp_x2 <= {SAMPLE_WIDTH{1'b0}};
            hp_y1 <= {SAMPLE_WIDTH{1'b0}};
            hp_y2 <= {SAMPLE_WIDTH{1'b0}};
            lp_y  <= {SAMPLE_WIDTH{1'b0}};
            hp_fraction <= 0;
            lp_fraction <= 0;
            filtered_out <= {SAMPLE_WIDTH{1'b0}};
        end else if (sample_valid) begin
            filtered_out  <= lp_y_w;
            filtered_valid <= 1'b1;
            hp_x2 <= hp_x1;
            hp_x1 <= sample_in;
            hp_y2 <= hp_y1;
            hp_y1 <= hp_y_w;
            lp_y  <= lp_y_w;
            // Clear the saved error on saturation (no quantizer windup).
            hp_fraction <= (hp_sat_w == (hp_acc_w >>> 16)) ? hp_acc_w[15:0] : 16'd0;
            lp_fraction <= (lp_sat_w == lp_sum_w) ? lp_prod_w[14:0] : 15'd0;
        end
    end
endmodule
