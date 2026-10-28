`timescale 1ns/1ps
// BD adapter: Vivado 2025.2 retains the old emg_pl_export module_ref port
// signature even after recreation/update_module_reference. A fresh module
// reference exposes the status port while reusing the entire signal chain.
module emg_pl_export_status #(
    parameter integer HP_B0 = 64096,
    parameter integer HP_B1 = -128192,
    parameter integer HP_B2 = 64096,
    parameter integer HP_A1 = -128161,
    parameter integer HP_A2 = 62688,
    parameter integer LP_ALPHA = 9392,
    parameter integer DECIM_RATIO = 1,
    parameter integer WINDOW_SAMPLES = 400,
    parameter integer HOP_SAMPLES = 100,
    parameter integer RMS_INPUT_SHIFT = 12,
    parameter integer PACKET_WORDS = 1024
)(
    input wire pl_clk, pl_rst_n, axis_clk, axis_rst_n,
    input wire adc_drdy_n, adc_dout, reconfig_n,
    output wire adc_sclk, adc_din, adc_cs_n, adc_reset_n, adc_start, adc_pwdn_n,
    output wire status_led,
    output wire [31:0] adc_config_status,
    output wire [63:0] m_axis_tdata,
    output wire m_axis_tvalid,
    input wire m_axis_tready,
    output wire m_axis_tlast, raw_overflow, feature_overflow, result_overflow
);
    emg_pl_export #(
        .HP_B0(HP_B0),.HP_B1(HP_B1),.HP_B2(HP_B2),.HP_A1(HP_A1),.HP_A2(HP_A2),
        .LP_ALPHA(LP_ALPHA),.DECIM_RATIO(DECIM_RATIO),.WINDOW_SAMPLES(WINDOW_SAMPLES),
        .HOP_SAMPLES(HOP_SAMPLES),.RMS_INPUT_SHIFT(RMS_INPUT_SHIFT),.PACKET_WORDS(PACKET_WORDS)
    ) u_core (
        .pl_clk(pl_clk),.pl_rst_n(pl_rst_n),.axis_clk(axis_clk),.axis_rst_n(axis_rst_n),
        .adc_drdy_n(adc_drdy_n),.adc_dout(adc_dout),.reconfig_n(reconfig_n),
        .control_shift(3'd0),.control_epoch(4'd0),.control_recalibrate(1'b0),
        .adc_sclk(adc_sclk),.adc_din(adc_din),.adc_cs_n(adc_cs_n),.adc_reset_n(adc_reset_n),
        .adc_start(adc_start),.adc_pwdn_n(adc_pwdn_n),.status_led(status_led),
        .adc_config_status(adc_config_status),.m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),.m_axis_tready(m_axis_tready),.m_axis_tlast(m_axis_tlast),
        .raw_overflow(raw_overflow),.feature_overflow(feature_overflow),.result_overflow(result_overflow)
    );
endmodule
