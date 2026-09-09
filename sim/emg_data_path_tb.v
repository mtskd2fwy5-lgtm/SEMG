`timescale 1ns/1ps

module emg_data_path_tb;
    reg pl_clk = 1'b0;
    reg axis_clk = 1'b0;
    reg pl_rst_n = 1'b0;
    reg axis_rst_n = 1'b0;
    reg raw_valid = 1'b0;
    reg [2:0] raw_channel = 3'd0;
    reg signed [23:0] raw_data = 24'sd0;
    reg [15:0] raw_sequence = 16'd0;
    reg feature_valid = 1'b0;
    reg [3:0] feature_id = 4'd0;
    reg [31:0] feature_data = 32'd0;
    reg [15:0] feature_sequence = 16'd0;
    reg result_valid = 1'b0;
    reg [3:0] result_id = 4'd0;
    reg [31:0] result_data = 32'd0;
    reg [15:0] result_sequence = 16'd0;
    wire raw_overflow;
    wire feature_overflow;
    wire result_overflow;
    wire [63:0] m_axis_tdata;
    wire m_axis_tvalid;
    wire m_axis_tlast;
    integer received = 0;
    integer errors = 0;

    always #5 pl_clk = ~pl_clk;
    always #7 axis_clk = ~axis_clk;

    emg_data_path #(.FIFO_ADDR_WIDTH(2), .PACKET_WORDS(4)) dut (
        .pl_clk(pl_clk), .pl_rst_n(pl_rst_n),
        .axis_clk(axis_clk), .axis_rst_n(axis_rst_n),
        .raw_valid(raw_valid), .raw_channel(raw_channel), .raw_data(raw_data),
        .raw_sequence(raw_sequence), .feature_valid(feature_valid),
        .feature_id(feature_id), .feature_data(feature_data),
        .feature_sequence(feature_sequence), .result_valid(result_valid),
        .result_id(result_id), .result_data(result_data),
        .result_sequence(result_sequence), .raw_overflow(raw_overflow),
        .feature_overflow(feature_overflow), .result_overflow(result_overflow),
        .m_axis_tdata(m_axis_tdata), .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(1'b1), .m_axis_tlast(m_axis_tlast)
    );

    task send_raw;
        input [2:0] channel;
        input signed [23:0] value;
        begin
            @(negedge pl_clk);
            raw_channel = channel;
            raw_data = value;
            raw_valid = 1'b1;
            @(negedge pl_clk);
            raw_valid = 1'b0;
        end
    endtask

    task send_feature;
        input [3:0] id;
        input [31:0] value;
        begin
            @(negedge pl_clk);
            feature_id = id;
            feature_data = value;
            feature_valid = 1'b1;
            @(negedge pl_clk);
            feature_valid = 1'b0;
        end
    endtask

    task send_result;
        input [3:0] id;
        input [31:0] value;
        begin
            @(negedge pl_clk);
            result_id = id;
            result_data = value;
            result_valid = 1'b1;
            @(negedge pl_clk);
            result_valid = 1'b0;
        end
    endtask

    always @(posedge axis_clk) begin
        if (m_axis_tvalid) begin
            $display("export type=%0h channel_or_id=%0h data=%0h last=%0d",
                     m_axis_tdata[63:60], m_axis_tdata[55:52],
                     m_axis_tdata[31:0], m_axis_tlast);
            case (received)
                0: if (m_axis_tdata[63:60] !== 4'h1 || m_axis_tdata[55:52] !== 4'h0)
                       errors = errors + 1;
                1: if (m_axis_tdata[63:60] !== 4'h1 || m_axis_tdata[55:52] !== 4'h1)
                       errors = errors + 1;
                2: if (m_axis_tdata[63:60] !== 4'h2 || m_axis_tdata[55:52] !== 4'h3)
                       errors = errors + 1;
                3: if (m_axis_tdata[63:60] !== 4'h3 || m_axis_tdata[55:52] !== 4'h5)
                       errors = errors + 1;
                default: errors = errors + 1;
            endcase
            received = received + 1;
        end
    end

    initial begin
        repeat (4) @(posedge pl_clk);
        pl_rst_n = 1'b1;
        axis_rst_n = 1'b1;
        send_raw(3'd0, 24'sd100);
        send_raw(3'd1, -24'sd200);
        send_feature(4'd3, 32'h1234_5678);
        send_result(4'd5, 32'hCAFE_BEEF);
        repeat (30) @(posedge axis_clk);
        if (received != 4 || errors != 0 || raw_overflow || feature_overflow || result_overflow)
            $display("EMG data path test FAILED: received=%0d errors=%0d overflow=%0d/%0d/%0d",
                     received, errors, raw_overflow, feature_overflow, result_overflow);
        else
            $display("EMG data path test PASSED: received=%0d", received);
        $finish;
    end
endmodule
