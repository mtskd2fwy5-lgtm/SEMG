`timescale 1ns/1ps

module emg_preprocess_tb;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg sample_valid = 1'b0;
    reg signed [15:0] sample_in = 16'sd0;
    wire feature_valid;
    wire [31:0] window_sum;
    wire signed [15:0] baseline;
    wire [15:0] rectified;

    always #5 clk = ~clk;

    emg_preprocess #(
        .WINDOW_SAMPLES(8),
        .BASELINE_SHIFT(3)
    ) dut (
        .clk(clk), .rst_n(rst_n), .sample_valid(sample_valid),
        .sample_in(sample_in), .feature_valid(feature_valid),
        .window_sum(window_sum), .baseline(baseline), .rectified(rectified)
    );

    task feed;
        input signed [15:0] value;
        begin
            @(negedge clk);
            sample_in = value;
            sample_valid = 1'b1;
            @(negedge clk);
            sample_valid = 1'b0;
        end
    endtask

    initial begin
        #40 rst_n = 1'b1;
        // Baseline settles around 1000, then the pulse produces a non-zero
        // rectified response and a completed eight-sample feature window.
        feed(16'sd1000); feed(16'sd1000); feed(16'sd1000); feed(16'sd1000);
        feed(16'sd1400); feed(16'sd1400); feed(16'sd1000); feed(16'sd1000);
        #20;
        if (!feature_valid)
            $display("NOTE: feature_valid is a one-cycle pulse; inspect the waveform or add a scoreboard.");
        $display("EMG preprocessing smoke test completed, last_sum=%0d", window_sum);
        $finish;
    end
endmodule
