// ADS8698 capture interface skeleton.
// Fill in the exact command/data timing from the mounted ADS8698 board
// schematic and datasheet before connecting this module to a human subject.
module ads8698_spi #(
    parameter integer CLK_FREQ_HZ = 100_000_000,
    parameter integer SCLK_FREQ_HZ = 10_000_000,
    parameter integer CHANNELS = 4,
    parameter integer FRAME_BITS = 16
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    start,
    input  wire                    adc_sdo,
    output wire                    adc_sclk,
    output wire                    adc_cs_n,
    output wire                    adc_sdi,
    output wire                    sample_valid,
    output wire [15:0]             sample_data,
    output wire [$clog2(CHANNELS)-1:0] sample_channel,
    output wire                    busy,
    output wire                    error
);

    // This stub deliberately exposes the project contract without inventing
    // ADS8698 command words or board-specific timing.
    assign adc_sclk = 1'b0;
    assign adc_cs_n = 1'b1;
    assign adc_sdi = 1'b0;
    assign sample_valid = 1'b0;
    assign sample_data = 16'd0;
    assign sample_channel = {((CHANNELS <= 1) ? 1 : $clog2(CHANNELS)){1'b0}};
    assign busy = 1'b0;
    assign error = 1'b0;

endmodule

