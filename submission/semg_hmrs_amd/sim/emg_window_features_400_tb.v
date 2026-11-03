`timescale 1ns/1ps

module emg_window_features_400_tb;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg sample_valid = 1'b0;
    reg signed [23:0] sample_in = 24'sd0;
    wire bp_valid;
    wire signed [23:0] bp_out;
    wire window_valid;
    wire [31:0] mav_sum, wl_sum, energy_sum, zc_count, ssc_count;
    integer i, windows, fd;

    always #5 clk = ~clk;

    emg_bandpass u_bp (
        .clk(clk), .rst_n(rst_n), .sample_valid(sample_valid),
        .sample_in(sample_in), .filtered_valid(bp_valid),
        .filtered_out(bp_out)
    );

    emg_window_features #(
        .WINDOW_SAMPLES(400), .HOP_SAMPLES(100),
        .RMS_INPUT_SHIFT(12), .ZC_THRESHOLD(0), .SSC_THRESHOLD(0)
    ) u_wf (
        .clk(clk), .rst_n(rst_n), .sample_valid(bp_valid),
        .sample_in(bp_out), .window_valid(window_valid),
        .mav_sum(mav_sum), .wl_sum(wl_sum), .energy_sum(energy_sum),
        .zc_count(zc_count), .ssc_count(ssc_count)
    );

    always @(posedge clk) begin
        if (window_valid) begin
            windows = windows + 1;
            $fdisplay(fd, "%0d,%0d,%0d,%0d,%0d,%0d",
                      windows, mav_sum, wl_sum, energy_sum, zc_count, ssc_count);
            $display("WINDOW %0d MAV=%0d WL=%0d ENERGY=%0d ZC=%0d SSC=%0d",
                     windows, mav_sum, wl_sum, energy_sum, zc_count, ssc_count);
        end
    end

    initial begin
        fd = $fopen("window_400_out.csv", "w");
        windows = 0;
        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);
        for (i = 0; i < 1200; i = i + 1) begin
            @(negedge clk);
            sample_in = (i % 2) ? -24'sd5800 : 24'sd6000;
            sample_valid = 1'b1;
            @(negedge clk);
            sample_valid = 1'b0;
        end
        repeat (20) @(posedge clk);
        $fclose(fd);
        if (windows < 2)
            $display("WINDOW 400 TEST FAILED: only %0d windows", windows);
        else
            $display("WINDOW 400 TEST PASSED: windows=%0d", windows);
        $finish;
    end
endmodule

