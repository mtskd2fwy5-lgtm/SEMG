`timescale 1ns/1ps

// Bit-exactness testbench for emg_fatigue against the Python golden model
// (tools/gen_fatigue_mem.py).
//
// Golden vectors (data/models/fatigue/):
//   tb_fatigue_samples.mem  14336 frames x 8 ch, 24-bit samples (hex)
//   tb_fatigue_exp_id.mem   56 expected result ids (8,9 per window)
//   tb_fatigue_exp_data.mem 56 expected result data words
//
// The stream is driven ch0..ch7 interleaved (ADS1299 frame order), 8
// back-to-back samples + 1 gap cycle per frame.  A new window only starts
// filling after the previous window has been fully processed: real
// hardware has 512 ms per window vs ~1.5 ms processing, the paced TB
// models that margin explicitly.  out_ready toggles (3 of 4 cycles) to
// exercise the output handshake hold.

module tb_emg_fatigue;

    localparam integer NFRAMES = 14336;   // 28 windows x 512 frames
    localparam integer NWORDS  = 56;      // 28 windows x 2 result words
    localparam [3:0]  P_IDLE  = 4'd0;

    // absolute paths keep the TB independent of the simulator run directory
    localparam SAMPLE_FILE  = "d:/FPGA/sEMG-HMRS/data/models/fatigue/tb_fatigue_samples.mem";
    localparam EXPID_FILE   = "d:/FPGA/sEMG-HMRS/data/models/fatigue/tb_fatigue_exp_id.mem";
    localparam EXPDATA_FILE = "d:/FPGA/sEMG-HMRS/data/models/fatigue/tb_fatigue_exp_data.mem";

    reg clk = 1'b0, rst_n = 1'b0;
    always #5 clk = ~clk;           // 100 MHz

    reg               sample_valid = 1'b0;
    reg  [2:0]        sample_channel = 3'd0;
    reg signed [23:0] sample_data = 24'sd0;
    wire              out_valid;
    wire              out_ready;
    wire [3:0]        out_id;
    wire [31:0]       out_data;
    wire [15:0]       out_sequence;

    emg_fatigue dut (
        .clk(clk), .rst_n(rst_n),
        .sample_valid(sample_valid), .sample_channel(sample_channel),
        .sample_data(sample_data),
        .out_valid(out_valid), .out_ready(out_ready),
        .out_id(out_id), .out_data(out_data),
        .out_sequence(out_sequence)
    );

    reg [23:0] samples  [0:NFRAMES*8-1];
    reg [3:0]  exp_id   [0:NWORDS-1];
    reg [31:0] exp_data [0:NWORDS-1];

    // backpressure pattern: ready 3 of every 4 cycles
    reg [1:0] rr_cnt = 2'd0;
    always @(posedge clk) rr_cnt <= rr_cnt + 2'd1;
    assign out_ready = (rr_cnt != 2'b11);

    // result collection and comparison
    integer words, errors;
    always @(posedge clk) begin
        if (out_valid && out_ready) begin
            if (words >= NWORDS) begin
                errors = errors + 1;
                $display("FAIL extra word %0d: id %0d data %h seq %0d",
                         words, out_id, out_data, out_sequence);
            end else if (out_id !== exp_id[words] ||
                         out_data !== exp_data[words] ||
                         out_sequence !== (words >> 1) + 1) begin
                errors = errors + 1;
                $display("FAIL word %0d (win %0d): id %0d data %h seq %0d, exp id %0d data %h seq %0d",
                         words, words >> 1, out_id, out_data, out_sequence,
                         exp_id[words], exp_data[words], (words >> 1) + 1);
            end else begin
                $display("PASS word %0d (win %0d): id %0d data %h",
                         words, words >> 1, out_id, out_data);
            end
            words = words + 1;
        end
    end

    integer fi, ch;
    initial begin
        $readmemh(SAMPLE_FILE,  samples);
        $readmemh(EXPID_FILE,   exp_id);
        $readmemh(EXPDATA_FILE, exp_data);
        words = 0; errors = 0;

        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        repeat (4) @(posedge clk);

        for (fi = 0; fi < NFRAMES; fi = fi + 1) begin
            // window boundary: the previous window must be fully
            // processed before the next one starts filling
            if (fi[8:0] == 9'd0) begin
                wait (dut.state == P_IDLE);
                @(posedge clk);
            end
            for (ch = 0; ch < 8; ch = ch + 1) begin
                @(posedge clk);
                sample_valid   <= 1'b1;
                sample_channel <= ch[2:0];
                sample_data    <= $signed(samples[fi*8 + ch]);
            end
            @(posedge clk);
            sample_valid <= 1'b0;
        end

        // drain the final window
        wait (words == NWORDS);
        repeat (8) @(posedge clk);

        if (errors == 0)
            $display("ALL %0d WORDS PASS", NWORDS);
        else
            $display("%0d ERRORS", errors);
        $finish;
    end

    initial begin
        #100000000;   // 100 ms sim time safety limit
        $display("TIMEOUT: words=%0d errors=%0d", words, errors);
        $finish;
    end

endmodule
