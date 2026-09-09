`timescale 1ns/1ps

// Integer EMG preprocessing block.
// Input samples are signed ADC codes after conversion to a centered value.
// The block removes slow baseline drift, rectifies the result, and accumulates
// a window sum that can be used as an envelope/MAV feature.
module emg_preprocess #(
    parameter integer SAMPLE_WIDTH = 16,
    parameter integer ACC_WIDTH = 32,
    parameter integer WINDOW_SAMPLES = 200,
    parameter integer BASELINE_SHIFT = 8
) (
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         sample_valid,
    input  wire signed [SAMPLE_WIDTH-1:0] sample_in,
    output reg                          feature_valid,
    output reg [ACC_WIDTH-1:0]          window_sum,
    output reg signed [SAMPLE_WIDTH-1:0] baseline,
    output reg [SAMPLE_WIDTH-1:0]       rectified
);

    localparam integer COUNT_WIDTH = (WINDOW_SAMPLES <= 1) ? 1 : $clog2(WINDOW_SAMPLES);
    reg [COUNT_WIDTH-1:0] sample_count;
    reg signed [SAMPLE_WIDTH:0] centered;
    reg signed [SAMPLE_WIDTH:0] next_baseline;
    reg [ACC_WIDTH-1:0] next_sum;
    reg [SAMPLE_WIDTH:0] magnitude;

    always @(posedge clk) begin
        feature_valid <= 1'b0;
        if (!rst_n) begin
            sample_count <= {COUNT_WIDTH{1'b0}};
            window_sum <= {ACC_WIDTH{1'b0}};
            baseline <= {SAMPLE_WIDTH{1'b0}};
            rectified <= {SAMPLE_WIDTH{1'b0}};
        end else if (sample_valid) begin
            // A slow IIR estimate tracks the ADC baseline without storing a
            // large history buffer: b[n+1] = b[n] + (x[n]-b[n])/2^N.
            next_baseline = $signed(baseline) + (($signed(sample_in) - $signed(baseline)) >>> BASELINE_SHIFT);
            centered = $signed(sample_in) - next_baseline;
            if (centered < 0)
                magnitude = -centered;
            else
                magnitude = centered;

            baseline <= next_baseline[SAMPLE_WIDTH-1:0];
            rectified <= magnitude[SAMPLE_WIDTH-1:0];
            next_sum = window_sum + magnitude;

            if (sample_count == WINDOW_SAMPLES-1) begin
                window_sum <= {ACC_WIDTH{1'b0}};
                sample_count <= {COUNT_WIDTH{1'b0}};
                feature_valid <= 1'b1;
            end else begin
                window_sum <= next_sum;
                sample_count <= sample_count + 1'b1;
            end
        end
    end
endmodule
