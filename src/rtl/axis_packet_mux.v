`timescale 1ns/1ps

// Packet-aware round-robin mux. Each input is one complete packet word in
// the current data contract; TLAST marks the end of one DMA batch.
module axis_packet_mux #(
    parameter integer DATA_WIDTH = 64,
    parameter integer PACKET_WORDS = 256
) (
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire [DATA_WIDTH-1:0] raw_data,
    input  wire                  raw_valid,
    output reg                   raw_ready,
    input  wire [DATA_WIDTH-1:0] feature_data,
    input  wire                  feature_valid,
    output reg                   feature_ready,
    input  wire [DATA_WIDTH-1:0] result_data,
    input  wire                  result_valid,
    output reg                   result_ready,
    output reg [DATA_WIDTH-1:0]  m_data,
    output reg                   m_valid,
    input  wire                  m_ready,
    output reg                   m_last
);
    reg [1:0] round_robin;
    reg [1:0] selected;
    localparam integer COUNT_WIDTH = (PACKET_WORDS <= 1) ? 1 : $clog2(PACKET_WORDS);
    reg [COUNT_WIDTH-1:0] packet_count;

    always @* begin
        raw_ready = 1'b0;
        feature_ready = 1'b0;
        result_ready = 1'b0;
        m_data = {DATA_WIDTH{1'b0}};
        m_valid = 1'b0;
        m_last = 1'b0;
        selected = round_robin;

        case (round_robin)
            2'd0: begin
                if (raw_valid) begin selected = 2'd0; m_valid = 1'b1; m_data = raw_data; end
                else if (feature_valid) begin selected = 2'd1; m_valid = 1'b1; m_data = feature_data; end
                else if (result_valid) begin selected = 2'd2; m_valid = 1'b1; m_data = result_data; end
            end
            2'd1: begin
                if (feature_valid) begin selected = 2'd1; m_valid = 1'b1; m_data = feature_data; end
                else if (result_valid) begin selected = 2'd2; m_valid = 1'b1; m_data = result_data; end
                else if (raw_valid) begin selected = 2'd0; m_valid = 1'b1; m_data = raw_data; end
            end
            default: begin
                if (result_valid) begin selected = 2'd2; m_valid = 1'b1; m_data = result_data; end
                else if (raw_valid) begin selected = 2'd0; m_valid = 1'b1; m_data = raw_data; end
                else if (feature_valid) begin selected = 2'd1; m_valid = 1'b1; m_data = feature_data; end
            end
        endcase

        m_last = m_valid && (packet_count == PACKET_WORDS-1);
        if (m_valid) begin
            case (selected)
                2'd0: raw_ready = m_ready;
                2'd1: feature_ready = m_ready;
                default: result_ready = m_ready;
            endcase
        end
    end

    always @(posedge clk) begin
        if (!rst_n)
            begin
                round_robin <= 2'd0;
                packet_count <= {COUNT_WIDTH{1'b0}};
            end
        else if (m_valid && m_ready) begin
            if (packet_count == PACKET_WORDS-1)
                packet_count <= {COUNT_WIDTH{1'b0}};
            else
                packet_count <= packet_count + 1'b1;
            if (selected == 2'd2)
                round_robin <= 2'd0;
            else
                round_robin <= selected + 1'b1;
        end
    end
endmodule
