`timescale 1ns/1ps

// File-driven bit-exact test for the per-channel chain
// emg_bandpass -> emg_window_features. Small window parameters
// (WINDOW=8, HOP=4, shift=0, thresholds=0) exercise the sliding logic;
// tools/emg_reference.py mirrors the same chain and compares.
module emg_window_features_tb;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg sample_valid = 1'b0;
    reg signed [23:0] sample_in = 24'sd0;
    wire bp_valid;
    wire signed [23:0] bp_out;
    wire window_valid;
    wire [31:0] mav_sum, wl_sum, energy_sum, zc_count, ssc_count;
    integer stim_fd, out_fd, code, value, count, windows;

    always #5 clk = ~clk;

    emg_bandpass u_bp (
        .clk(clk), .rst_n(rst_n), .sample_valid(sample_valid),
        .sample_in(sample_in), .filtered_valid(bp_valid),
        .filtered_out(bp_out)
    );

    emg_window_features #(
        .WINDOW_SAMPLES(8),
        .HOP_SAMPLES(4),
        .RMS_INPUT_SHIFT(0),
        .ZC_THRESHOLD(0),
        .SSC_THRESHOLD(0)
    ) u_wf (
        .clk(clk), .rst_n(rst_n), .sample_valid(bp_valid),
        .sample_in(bp_out), .window_valid(window_valid),
        .mav_sum(mav_sum), .wl_sum(wl_sum), .energy_sum(energy_sum),
        .zc_count(zc_count), .ssc_count(ssc_count)
    );

    always @(posedge clk) begin
        if (window_valid) begin
            windows = windows + 1;
            $fdisplay(out_fd, "%0d,%0d,%0d,%0d,%0d,%0d",
                      windows, mav_sum, wl_sum, energy_sum, zc_count, ssc_count);
        end
    end

    initial begin
        stim_fd = $fopen("features_stim.txt", "r");
        if (stim_fd == 0) begin
            $display("EMG window features TB FAILED: cannot open features_stim.txt");
            $finish;
        end
        out_fd = $fopen("features_out.csv", "w");
        $fdisplay(out_fd, "window,mav,wl,energy,zc,ssc");
        windows = 0;
        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);
        count = 0;
        forever begin
            code = $fscanf(stim_fd, "%d", value);
            if (code != 1) begin
                repeat (8) @(posedge clk);
                $fclose(stim_fd);
                $fclose(out_fd);
                $display("EMG window features TB completed: samples=%0d windows=%0d",
                         count, windows);
                $finish;
            end
            @(negedge clk);
            sample_in = value[23:0];
            sample_valid = 1'b1;
            @(negedge clk);
            sample_valid = 1'b0;
            count = count + 1;
        end
    end
endmodule

