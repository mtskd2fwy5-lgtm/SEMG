`timescale 1ns/1ps

module ads8698_spi_tb;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg start = 1'b0;
    reg adc_sdo = 1'b0;
    wire adc_sclk;
    wire adc_cs_n;
    wire adc_sdi;
    wire sample_valid;
    wire [15:0] sample_data;
    wire [1:0] sample_channel;
    wire busy;
    wire error;

    always #5 clk = ~clk;

    ads8698_spi #(.CHANNELS(4)) dut (
        .clk(clk), .rst_n(rst_n), .start(start), .adc_sdo(adc_sdo),
        .adc_sclk(adc_sclk), .adc_cs_n(adc_cs_n), .adc_sdi(adc_sdi),
        .sample_valid(sample_valid), .sample_data(sample_data),
        .sample_channel(sample_channel), .busy(busy), .error(error)
    );

    initial begin
        #100 rst_n = 1'b1;
        #100 start = 1'b1;
        #10 start = 1'b0;
        #500;
        $display("ADS8698 interface smoke test completed");
        $finish;
    end
endmodule

