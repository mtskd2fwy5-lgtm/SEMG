`timescale 1ns/1ps

// Small asynchronous FIFO for one-way PL-to-AXI clock-domain crossing.
// ADDR_WIDTH must describe a power-of-two depth.
module axis_async_fifo #(
    parameter integer DATA_WIDTH = 64,
    parameter integer ADDR_WIDTH = 6
) (
    input  wire                     s_clk,
    input  wire                     s_rst_n,
    input  wire                     s_valid,
    output wire                     s_ready,
    input  wire [DATA_WIDTH-1:0]    s_data,
    input  wire                     m_clk,
    input  wire                     m_rst_n,
    output wire                     m_valid,
    input  wire                     m_ready,
    output wire [DATA_WIDTH-1:0]    m_data
);
    localparam integer DEPTH = (1 << ADDR_WIDTH);

    // Synchronous prefetch permits true dual-clock block RAM. Read pointer
    // still advances only on downstream acceptance: exact DEPTH capacity.
    (* ram_style="block" *) reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [DATA_WIDTH-1:0] read_data;
    reg [ADDR_WIDTH:0] s_bin, s_gray;
    reg [ADDR_WIDTH:0] m_bin, m_gray;
    // Gray-pointer double synchronizers across the two clock domains.
    // ASYNC_REG keeps the two stages placed together and excluded from
    // shift-register inference, as required for safe CDC.
    (* ASYNC_REG = "TRUE" *) reg [ADDR_WIDTH:0] m_gray_sync1, m_gray_sync2;
    (* ASYNC_REG = "TRUE" *) reg [ADDR_WIDTH:0] s_gray_sync1, s_gray_sync2;
    reg s_full, m_empty;

    wire s_fire = s_valid && s_ready;
    wire m_fire = m_valid && m_ready;
    wire [ADDR_WIDTH:0] s_bin_next = s_bin + s_fire;
    wire [ADDR_WIDTH:0] m_bin_next = m_bin + m_fire;
    wire [ADDR_WIDTH:0] s_gray_next = (s_bin_next >> 1) ^ s_bin_next;
    wire [ADDR_WIDTH:0] m_gray_next = (m_bin_next >> 1) ^ m_bin_next;
    wire s_full_next = (s_gray_next ==
                        {~m_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1],
                         m_gray_sync2[ADDR_WIDTH-2:0]});
    wire m_empty_next = (m_gray_next == s_gray_sync2);

    assign s_ready = s_rst_n && !s_full;
    assign m_valid = m_rst_n && !m_empty;
    assign m_data = read_data;

    always @(posedge m_clk)begin
        if(m_empty || m_ready)read_data<=mem[m_bin_next[ADDR_WIDTH-1:0]];
    end

    always @(posedge s_clk) begin
        if (!s_rst_n) begin
            s_bin <= 'd0;
            s_gray <= 'd0;
            m_gray_sync1 <= 'd0;
            m_gray_sync2 <= 'd0;
            s_full <= 1'b0;
        end else begin
            m_gray_sync1 <= m_gray;
            m_gray_sync2 <= m_gray_sync1;
            s_bin <= s_bin_next;
            s_gray <= s_gray_next;
            s_full <= s_full_next;
            if (s_fire)
                mem[s_bin[ADDR_WIDTH-1:0]] <= s_data;
        end
    end

    always @(posedge m_clk) begin
        if (!m_rst_n) begin
            m_bin <= 'd0;
            m_gray <= 'd0;
            s_gray_sync1 <= 'd0;
            s_gray_sync2 <= 'd0;
            m_empty <= 1'b1;
        end else begin
            s_gray_sync1 <= s_gray;
            s_gray_sync2 <= s_gray_sync1;
            m_bin <= m_bin_next;
            m_gray <= m_gray_next;
            if(m_empty || m_ready)m_empty <= m_empty_next;
        end
    end
endmodule
