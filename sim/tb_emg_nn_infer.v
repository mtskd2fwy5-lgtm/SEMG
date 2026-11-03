`timescale 1ns/1ps

// Bit-exactness testbench for emg_nn_infer against the Python Int8MLP.
//
// Golden vectors (exported by tools/export_int8.py):
//   data/models/nn_int8/tb_inputs.mem  64 windows x 40 u32 features
//   data/models/nn_int8/tb_logits.mem  64 windows x 5 s32 logits
// Features are driven in feature-bank order (index = feature_id*8 + channel,
// i.e. MAV ch0..7, WL ch0..7, Energy, ZC, SSC) which is exactly the column
// order of the training feature matrix.  All 5 logits and the argmax class
// are compared per window.

module tb_emg_nn_infer;

    localparam integer NW   = 64;   // windows
    localparam integer NIN  = 40;
    localparam integer NOUT = 5;

    // absolute paths keep the TB independent of the simulator run directory
`ifdef NN_PL_FILTER_FULLSTREAM
    localparam MEM_FILE    = "data/models/nn_int8_pl_filter_fullstream/nn_int8_weights.mem";
    localparam IN_FILE     = "data/models/nn_int8_pl_filter_fullstream/tb_inputs.mem";
    localparam GOLD_FILE   = "data/models/nn_int8_pl_filter_fullstream/tb_logits.mem";
`else
    localparam MEM_FILE    = "data/models/nn_int8_board_multiwear/nn_int8_weights.mem";
    localparam IN_FILE     = "data/models/nn_int8_board_multiwear/tb_inputs.mem";
    localparam GOLD_FILE   = "data/models/nn_int8_board_multiwear/tb_logits.mem";
`endif

    reg clk = 1'b0, rst_n = 1'b0;
    always #5 clk = ~clk;           // 100 MHz

    reg         feat_valid;
    reg  [5:0]  feat_index;
    reg  [31:0] feat_data;
    wire        feat_ready;
    wire        out_valid;
    reg         out_ready = 1'b1;
    wire [2:0]  out_id;
    wire [31:0] out_data;

    emg_nn_infer #(
        .MEM_FILE(MEM_FILE)
    ) dut (
        .clk(clk), .rst_n(rst_n),
        .feat_valid(feat_valid), .feat_index(feat_index),
        .feat_data(feat_data), .feat_ready(feat_ready),
        .out_valid(out_valid), .out_ready(out_ready),
        .out_id(out_id), .out_data(out_data)
    );

    reg [31:0] gold_in  [0:NW*NIN-1];
    reg [31:0] gold_out [0:NW*NOUT-1];

    integer win, k, errors;
    reg [31:0] got [0:NOUT];        // 5 logits + 1 class word
    reg signed [31:0] best;
    integer amax;
    reg [31:0] cycle_cnt;

    // drive one window: feed 40 features, collect 6 result words.
    // Handshake: data set on edge E is sampled by the DUT on edge E+1,
    // together with the feat_ready value seen at E+1, so sent advances
    // only when feat_ready was high at the same edge the DUT accepted.
    task run_window;
        input integer w;
        integer sent, recv;
        begin
            sent = 0; recv = 0;
            feat_valid <= 1'b1;
            feat_index <= 6'd0;
            feat_data  <= gold_in[w*NIN];
            while (recv < NOUT + 1) begin
                @(posedge clk);
                cycle_cnt = cycle_cnt + 1;
                if (sent < NIN && feat_ready) begin
                    sent = sent + 1;
                    if (sent < NIN) begin
                        feat_index <= sent[5:0];
                        feat_data  <= gold_in[w*NIN + sent];
                    end else begin
                        feat_valid <= 1'b0;
                    end
                end
                if (out_valid) begin
                    got[recv] = out_data;
                    recv = recv + 1;
                end
            end
        end
    endtask

    integer mismatch;
    initial begin
        $readmemh(IN_FILE,   gold_in);
        $readmemh(GOLD_FILE, gold_out);
        errors = 0;
        cycle_cnt = 0;
        feat_valid = 1'b0;

        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        repeat (4) @(posedge clk);

        if (dut.bram[0] === 32'hxxxxxxxx || dut.bram[11'h050] === 32'hxxxxxxxx)
            $display("BRAM NOT LOADED: bram[0]=%h bram[0x50]=%h",
                     dut.bram[0], dut.bram[11'h050]);
        else
            $display("BRAM OK: bram[0]=%h bram[0x50]=%h",
                     dut.bram[0], dut.bram[11'h050]);

        for (win = 0; win < NW; win = win + 1) begin
            run_window(win);
            if (win == 0) begin
                $display("DUT xq[0:9]  = %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d",
                         dut.xq[0], dut.xq[1], dut.xq[2], dut.xq[3], dut.xq[4],
                         dut.xq[5], dut.xq[6], dut.xq[7], dut.xq[8], dut.xq[9]);
                $display("DUT h1[0:15] = %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d",
                         dut.h1[0], dut.h1[1], dut.h1[2], dut.h1[3],
                         dut.h1[4], dut.h1[5], dut.h1[6], dut.h1[7],
                         dut.h1[8], dut.h1[9], dut.h1[10], dut.h1[11],
                         dut.h1[12], dut.h1[13], dut.h1[14], dut.h1[15]);
                $display("DUT h1[16:31] = %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d",
                         dut.h1[16], dut.h1[17], dut.h1[18], dut.h1[19],
                         dut.h1[20], dut.h1[21], dut.h1[22], dut.h1[23],
                         dut.h1[24], dut.h1[25], dut.h1[26], dut.h1[27],
                         dut.h1[28], dut.h1[29], dut.h1[30], dut.h1[31]);
                $display("DUT h1[32:63] nz =");
                for (k = 32; k < 64; k = k + 1) if (dut.h1[k] !== 0) $display("  h1[%0d]=%0d", k, dut.h1[k]);
                $display("DUT h2 = %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d",
                         dut.h2[0], dut.h2[1], dut.h2[2], dut.h2[3], dut.h2[4],
                         dut.h2[5], dut.h2[6], dut.h2[7], dut.h2[8], dut.h2[9],
                         dut.h2[10], dut.h2[11], dut.h2[12], dut.h2[13],
                         dut.h2[14], dut.h2[15], dut.h2[16], dut.h2[17],
                         dut.h2[18], dut.h2[19], dut.h2[20], dut.h2[21],
                         dut.h2[22], dut.h2[23], dut.h2[24], dut.h2[25],
                         dut.h2[26], dut.h2[27], dut.h2[28], dut.h2[29],
                         dut.h2[30], dut.h2[31]);
            end
            // compare logits
            mismatch = 0;
            for (k = 0; k < NOUT; k = k + 1)
                if (got[k] !== gold_out[win*NOUT + k])
                    mismatch = mismatch + 1;
            // golden argmax (numpy semantics: strict >, lowest index wins)
            best = $signed(gold_out[win*NOUT]);
            amax = 0;
            for (k = 1; k < NOUT; k = k + 1)
                if ($signed(gold_out[win*NOUT + k]) > best) begin
                    best = $signed(gold_out[win*NOUT + k]);
                    amax = k;
                end
            if (got[NOUT][2:0] !== amax[2:0])
                mismatch = mismatch + 1;
            if (mismatch != 0) begin
                errors = errors + 1;
                $display("FAIL win %0d: got [%h %h %h %h %h] cls %0d, exp [%h %h %h %h %h] cls %0d",
                         win, got[0], got[1], got[2], got[3], got[4], got[NOUT],
                         gold_out[win*NOUT], gold_out[win*NOUT+1],
                         gold_out[win*NOUT+2], gold_out[win*NOUT+3],
                         gold_out[win*NOUT+4], amax);
            end else begin
                $display("PASS win %0d: cls %0d", win, got[NOUT]);
            end
        end

        if (errors == 0)
            $display("ALL %0d WINDOWS PASS (%0d cycles)", NW, cycle_cnt);
        else
            $display("%0d/%0d WINDOWS FAILED", errors, NW);
        $finish;
    end

    initial begin
        #20000000;
        $display("TIMEOUT");
        $finish;
    end

endmodule
