`timescale 1ns/1ps

module hand_motion_top (
    input wire clk,
    input wire rst_n,
    input wire adc_drdy_n,
    input wire adc_dout,
    input wire reconfig_n,
    output wire adc_sclk,
    output wire adc_din,
    output wire adc_cs_n,
    output wire adc_reset_n,
    output wire adc_start,
    output wire adc_pwdn_n,
    output wire status_led
);
    wire sample_valid;
    wire signed [23:0] sample_data;
    wire [2:0] sample_channel;
    wire frame_valid;
    wire busy;
    wire error;

    ads1299_spi u_ads1299_spi (
        .clk(clk), .rst_n(rst_n), .start(1'b1),
        .reconfig_n(reconfig_n),
        .adc_drdy_n(adc_drdy_n), .adc_dout(adc_dout),
        .adc_sclk(adc_sclk), .adc_din(adc_din), .adc_cs_n(adc_cs_n),
        .adc_reset_n(adc_reset_n), .adc_start(adc_start),
        .adc_pwdn_n(adc_pwdn_n), .sample_valid(sample_valid),
        .sample_data(sample_data), .sample_channel(sample_channel),
        .frame_valid(frame_valid), .busy(busy), .error(error)
    );

    assign status_led = !busy && !error;
endmodule
