`timescale 1ns/1ps

// Three-source PL data export path. Producers run in pl_clk; the AXI output
// runs in axis_clk and is ready for an AXI DMA S2MM connection.
module emg_data_path #(
    parameter integer FIFO_ADDR_WIDTH = 6,
    parameter integer PACKET_WORDS = 256
) (
    input  wire                  pl_clk,
    input  wire                  pl_rst_n,
    input  wire                  axis_clk,
    input  wire                  axis_rst_n,
    input  wire                  raw_valid,
    output wire                  raw_ready,
    input  wire [2:0]            raw_channel,
    input  wire signed [23:0]    raw_data,
    input  wire [15:0]           raw_sequence,
    input  wire                  feature_valid,
    output wire                  feature_ready,
    input  wire [2:0]            feature_channel,
    input  wire [3:0]            feature_id,
    input  wire [31:0]           feature_data,
    input  wire [15:0]           feature_sequence,
    input  wire                  result_valid,
    output wire                  result_ready,
    input  wire [3:0]            result_id,
    input  wire [31:0]           result_data,
    input  wire [15:0]           result_sequence,
    output reg                   raw_overflow,
    output reg                   feature_overflow,
    output reg                   result_overflow,
    output wire [63:0]           m_axis_tdata,
    output wire                  m_axis_tvalid,
    input  wire                  m_axis_tready,
    output wire                  m_axis_tlast
);
    // 64-bit packet format (see report/pl_ps_data_path.md):
    //   63:60  packet type: 1 raw, 2 feature, 3 result (NN), 4 fatigue
    //   59:56  channel (raw sample channel / feature source channel)
    //   55:52  feature or result id (0 for raw)
    //   51:48  reserved
    //   47:32  sequence number
    //   31:0   payload (raw: 24-bit signed sample in low bits)
    wire [63:0] raw_word = {4'h1, {1'b0, raw_channel}, 4'h0, 4'h0,
                             raw_sequence, 8'h00, raw_data};
    wire [63:0] feature_word = {4'h2, {1'b0, feature_channel}, feature_id, 4'h0,
                                 feature_sequence, feature_data};
    // Result lane carries NN results (ids 0..5, type 3) and fatigue
    // results (ids 8/9, type 4); type is derived from the id range.
    wire [63:0] result_word = {(result_id[3] ? 4'h4 : 4'h3), 4'h0, result_id,
                                4'h0, result_sequence, result_data};

    wire raw_rd_valid, feature_rd_valid, result_rd_valid;
    wire raw_rd_ready, feature_rd_ready, result_rd_ready;
    wire [63:0] raw_rd_data, feature_rd_data, result_rd_data;

    axis_async_fifo #(.DATA_WIDTH(64), .ADDR_WIDTH(FIFO_ADDR_WIDTH)) raw_fifo (
        .s_clk(pl_clk), .s_rst_n(pl_rst_n), .s_valid(raw_valid),
        .s_ready(raw_ready), .s_data(raw_word), .m_clk(axis_clk),
        .m_rst_n(axis_rst_n), .m_valid(raw_rd_valid), .m_ready(raw_rd_ready),
        .m_data(raw_rd_data)
    );
    axis_async_fifo #(.DATA_WIDTH(64), .ADDR_WIDTH(FIFO_ADDR_WIDTH)) feature_fifo (
        .s_clk(pl_clk), .s_rst_n(pl_rst_n), .s_valid(feature_valid),
        .s_ready(feature_ready), .s_data(feature_word), .m_clk(axis_clk),
        .m_rst_n(axis_rst_n), .m_valid(feature_rd_valid), .m_ready(feature_rd_ready),
        .m_data(feature_rd_data)
    );
    axis_async_fifo #(.DATA_WIDTH(64), .ADDR_WIDTH(FIFO_ADDR_WIDTH)) result_fifo (
        .s_clk(pl_clk), .s_rst_n(pl_rst_n), .s_valid(result_valid),
        .s_ready(result_ready), .s_data(result_word), .m_clk(axis_clk),
        .m_rst_n(axis_rst_n), .m_valid(result_rd_valid), .m_ready(result_rd_ready),
        .m_data(result_rd_data)
    );

    axis_packet_mux #(.PACKET_WORDS(PACKET_WORDS)) mux (
        .clk(axis_clk), .rst_n(axis_rst_n),
        .raw_data(raw_rd_data), .raw_valid(raw_rd_valid), .raw_ready(raw_rd_ready),
        .feature_data(feature_rd_data), .feature_valid(feature_rd_valid), .feature_ready(feature_rd_ready),
        .result_data(result_rd_data), .result_valid(result_rd_valid), .result_ready(result_rd_ready),
        .m_data(m_axis_tdata), .m_valid(m_axis_tvalid), .m_ready(m_axis_tready),
        .m_last(m_axis_tlast)
    );

    always @(posedge pl_clk) begin
        if (!pl_rst_n) begin
            raw_overflow <= 1'b0;
            feature_overflow <= 1'b0;
            result_overflow <= 1'b0;
        end else begin
            if (raw_valid && !raw_ready) raw_overflow <= 1'b1;
            if (feature_valid && !feature_ready) feature_overflow <= 1'b1;
            if (result_valid && !result_ready) result_overflow <= 1'b1;
        end
    end
endmodule
