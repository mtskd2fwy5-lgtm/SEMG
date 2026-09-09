`timescale 1ns/1ps

// PL integration shell: ADS1299 raw samples are exported immediately, while
// feature and result producers are reserved for the next processing stages.
module emg_pl_export (
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

    emg_data_path u_emg_data_path (
        .pl_clk(pl_clk), .pl_rst_n(pl_rst_n), .axis_clk(axis_clk), .axis_rst_n(axis_rst_n),
        .raw_valid(sample_valid), .raw_channel(sample_channel), .raw_data(sample_data),
        .raw_sequence(raw_sequence),
        .feature_valid(1'b0), .feature_id(4'd0), .feature_data(32'd0), .feature_sequence(16'd0),
        .result_valid(1'b0), .result_id(4'd0), .result_data(32'd0), .result_sequence(16'd0),
        .raw_overflow(raw_overflow), .feature_overflow(feature_overflow),
        .result_overflow(result_overflow), .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid), .m_axis_tready(m_axis_tready), .m_axis_tlast(m_axis_tlast)
    );

    assign status_led = !busy && !error;
endmodule
