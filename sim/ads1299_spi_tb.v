`timescale 1ns/1ps

module ads1299_spi_tb;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg start = 1'b0;
    reg adc_drdy_n = 1'b1;
    reg adc_dout = 1'b0;
    wire adc_sclk;
    wire adc_din;
    wire adc_cs_n;
    wire adc_reset_n;
    wire adc_start;
    wire adc_pwdn_n;
    wire sample_valid;
    wire signed [23:0] sample_data;
    wire [2:0] sample_channel;
    wire frame_valid;
    wire busy;
    wire error;

    always #5 clk = ~clk;

    ads1299_spi dut (
        .clk(clk), .rst_n(rst_n), .start(start), .adc_drdy_n(adc_drdy_n),
        .adc_dout(adc_dout), .adc_sclk(adc_sclk), .adc_din(adc_din),
        .adc_cs_n(adc_cs_n), .adc_reset_n(adc_reset_n),
        .adc_start(adc_start), .adc_pwdn_n(adc_pwdn_n),
        .sample_valid(sample_valid), .sample_data(sample_data),
        .sample_channel(sample_channel), .frame_valid(frame_valid),
        .busy(busy), .error(error)
    );

    initial begin
        #100 rst_n = 1'b1;
        #100 start = 1'b1;
        #10 start = 1'b0;
        #500;
        $display("ADS1299 interface smoke test completed");
        $finish;
    end
endmodule
