`timescale 1ns/1ps

// Debug testbench for emg_fatigue: drives only window 0 (2048 frames) and
// dumps intermediate DUT state for diffing against the golden debug files
// written by tools/gen_fatigue_mem.py:
//   dbg_win0_sbuf.mem      golden HP-filtered samples (8 ch x 2048)
//   dbg_win0_spec_re/im.mem golden FFT bins 0..1024 (8 ch x 1025)
//   dbg_win0_tot.mem       golden per-channel total power (8 lines)
// RTL dumps land beside them as dbg_rtl_*.mem.

module tb_fatigue_dbg;

    localparam integer NFRAMES = 2048;
    localparam SAMPLE_FILE = "d:/FPGA/sEMG-HMRS/data/models/fatigue/tb_fatigue_samples.mem";
    localparam DBG_DIR = "d:/FPGA/sEMG-HMRS/data/models/fatigue/";

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

    assign out_ready = 1'b1;

    emg_fatigue dut (
        .clk(clk), .rst_n(rst_n),
        .sample_valid(sample_valid), .sample_channel(sample_channel),
        .sample_data(sample_data),
        .out_valid(out_valid), .out_ready(out_ready),
        .out_id(out_id), .out_data(out_data),
        .out_sequence(out_sequence)
    );

    reg [23:0] samples [0:NFRAMES*8-1];

    reg [3:0] prev_state;
    integer spec_ch, tot_ch, k;
    integer f_sbuf, f_spec_re, f_spec_im, f_tot;
    integer f_load, f_ops;

    // stage/butterfly trace for channel 0: load-complete array snapshot +
    // every butterfly's latched operands, tagged (ch, stage, k, j)
    reg [3:0] prev_bfs;
    always @(posedge clk) begin
        prev_bfs <= dut.bf_s;
        if (rst_n) begin
            if (prev_state == 4'd1 && dut.state == 4'd2) begin
                for (k = 0; k < 2048; k = k + 1)
                    $fwrite(f_load, "%0d %0d\n", dut.ch_cnt,
                            $signed(dut.fft_re[k]));
            end
            // bf_ph==4: a/b/tw operand registers all latched and stable
            if (dut.state == 4'd2 && dut.ch_cnt == 3'd0 && dut.bf_ph == 3'd4)
                $fwrite(f_ops, "%0d %0d %0d %0d %0d %0d %0d %0d\n",
                        dut.bf_s, dut.bf_k, dut.bf_j,
                        $signed(dut.a_re), $signed(dut.a_im),
                        $signed(dut.b_re), $signed(dut.b_im), dut.tw_q);
        end
    end

    always @(posedge clk) begin
        prev_state <= dut.state;
        if (rst_n) begin
            // entered P_P1: fft arrays hold the finished channel's spectrum
            if (prev_state == 4'd2 && dut.state == 4'd3) begin
                for (k = 0; k <= 1024; k = k + 1) begin
                    $fwrite(f_spec_re, "%0d\n", $signed(dut.fft_re[k]));
                    $fwrite(f_spec_im, "%0d\n", $signed(dut.fft_im[k]));
                end
                spec_ch = spec_ch + 1;
            end
            // left P_P1: total_acc holds the 257-bin total
            if (prev_state == 4'd3 && dut.state == 4'd4) begin
                $fwrite(f_tot, "%0d\n", dut.total_acc);
                tot_ch = tot_ch + 1;
            end
        end
    end

    integer fi, ch;
    initial begin
        $readmemh(SAMPLE_FILE, samples);
        spec_ch = 0; tot_ch = 0;
        f_sbuf    = $fopen({DBG_DIR, "dbg_rtl_sbuf.mem"}, "w");
        f_spec_re = $fopen({DBG_DIR, "dbg_rtl_spec_re.mem"}, "w");
        f_spec_im = $fopen({DBG_DIR, "dbg_rtl_spec_im.mem"}, "w");
        f_tot     = $fopen({DBG_DIR, "dbg_rtl_tot.mem"}, "w");
        f_load    = $fopen({DBG_DIR, "dbg_rtl_load_re.mem"}, "w");
        f_ops     = $fopen({DBG_DIR, "dbg_rtl_ops.mem"}, "w");
        if (f_sbuf == 0 || f_spec_re == 0 || f_spec_im == 0 || f_tot == 0
            || f_load == 0 || f_ops == 0) begin
            $display("FAILED to open debug output files");
            $finish;
        end

        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        repeat (4) @(posedge clk);

        for (fi = 0; fi < NFRAMES; fi = fi + 1) begin
            for (ch = 0; ch < 8; ch = ch + 1) begin
                @(posedge clk);
                sample_valid   <= 1'b1;
                sample_channel <= ch[2:0];
                sample_data    <= $signed(samples[fi*8 + ch]);
            end
            @(posedge clk);
            sample_valid <= 1'b0;
        end

        // window 0 complete: dump all 8 channel slices of buffer 0
        wait (dut.proc_buf_valid === 1'b1);
        for (ch = 0; ch < 8; ch = ch + 1)
            for (k = 0; k < 2048; k = k + 1)
                $fwrite(f_sbuf, "%0d\n", $signed(dut.sbuf[{1'b0, ch[2:0], k[10:0]}]));

        // wait for the 8 per-channel totals, then finish
        wait (tot_ch == 8);
        repeat (4) @(posedge clk);
        $fclose(f_sbuf); $fclose(f_spec_re);
        $fclose(f_spec_im); $fclose(f_tot);
        $fclose(f_load); $fclose(f_ops);
        $display("DBG DONE: spec_ch=%0d tot_ch=%0d", spec_ch, tot_ch);
        $finish;
    end

    initial begin
        #20000000;
        $display("TIMEOUT state=%0d spec_ch=%0d tot_ch=%0d",
                 dut.state, spec_ch, tot_ch);
        $finish;
    end

endmodule
