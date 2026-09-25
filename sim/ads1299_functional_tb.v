`timescale 1ns/1ps

module ads1299_functional_tb;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg start = 1'b0;
    reg reconfig_n = 1'b1;
    reg adc_drdy_n = 1'b1;
    reg adc_dout = 1'b0;
    wire adc_sclk;
    wire adc_din;
    wire adc_cs_n;
    wire adc_reset_n;
    wire adc_start;
    wire adc_pwdn_n;
    wire sample_valid;
    wire signed [23:0] sample_data;
    wire [2:0] sample_channel;
    wire frame_valid;
    wire busy;
    wire error;

    reg [215:0] frame_bits;
    reg [8:0] driven_bit;
    reg read_active = 1'b0;
    integer received_count = 0;
    integer error_count = 0;
    integer command_error_count = 0;
    integer command_transfer = 0;
    integer command_byte_count = 0;
    integer command_bit_count = 0;
    reg command_monitor_enable = 1'b1;
    reg [7:0] command_shift = 8'd0;

    function [7:0] expected_command_byte;
        input integer transfer_index;
        input integer byte_index;
        begin
            case (transfer_index)
                0: expected_command_byte = 8'h11;
                1: begin
                    case (byte_index)
                        0: expected_command_byte = 8'h41;  /* WREG @ CONFIG1 (addr 01h): op 010r rrrr */
                        1: expected_command_byte = 8'h0B;
                        2: expected_command_byte = 8'h92;  /* CONFIG1: DR=010 = 4 kSPS */
                        3: expected_command_byte = 8'hD5;  /* INT_TEST bring-up */
                        4: expected_command_byte = 8'hEC;
                        5: expected_command_byte = 8'h00;
                        default: expected_command_byte = 8'h65;  /* MUX=101 internal test signal */
                    endcase
                end
                2: expected_command_byte = 8'h10;
                3: expected_command_byte = 8'h08;
                default: expected_command_byte = 8'h00;
            endcase
        end
    endfunction

    function integer expected_command_count;
        input integer transfer_index;
        begin
            case (transfer_index)
                1: expected_command_count = 14;
                default: expected_command_count = 1;
            endcase
        end
    endfunction

    always #5 clk = ~clk;

    ads1299_spi #(
        .CLK_FREQ_HZ(10_000_000),
        .SCLK_FREQ_HZ(1_000_000),
        .RESET_CYCLES(2),
        .POST_RESET_CYCLES(2),
        .COMMAND_GAP_CYCLES(5),
        .BTN_DEBOUNCE_CYCLES(4)
    ) dut (
        .clk(clk), .rst_n(rst_n), .start(start), .reconfig_n(reconfig_n),
        .adc_drdy_n(adc_drdy_n), .adc_dout(adc_dout),
        .adc_sclk(adc_sclk), .adc_din(adc_din), .adc_cs_n(adc_cs_n),
        .adc_reset_n(adc_reset_n), .adc_start(adc_start),
        .adc_pwdn_n(adc_pwdn_n), .sample_valid(sample_valid),
        .sample_data(sample_data), .sample_channel(sample_channel),
        .frame_valid(frame_valid), .busy(busy), .error(error)
    );

    // Data frame: 24 status bits followed by eight 24-bit test values.
    initial begin
        frame_bits = {24'hC00000, 24'd1, 24'd2, 24'd3, 24'd4,
                      24'd5, 24'd6, 24'd7, 24'd8};
        #40;
        rst_n = 1'b1;
        repeat (10) @(posedge clk);
        start = 1'b1;
        repeat (2) @(posedge clk);
        start = 1'b0;
        // Allow the controller to complete reset, configuration and START.
        repeat (4000) @(posedge clk);
        adc_drdy_n = 1'b0;
        repeat (4) @(posedge clk);
        adc_drdy_n = 1'b1;
        repeat (3500) @(posedge clk);
        if (received_count != 8)
            error_count = error_count + 1;
        if (error || error_count != 0 || command_error_count != 0 || command_transfer != 4)
            $display("ADS1299 functional test FAILED (boot phase): samples=%0d data_errors=%0d command_errors=%0d transfers=%0d",
                     received_count, error_count, command_error_count, command_transfer);
        else
            $display("ADS1299 functional test boot phase PASSED: samples=%0d command_transfers=%0d",
                     received_count, command_transfer);

        // Reconfig button: replay of the full command sequence, then a new
        // data frame.  Expected byte stream repeats (transfers 4..7 mirror
        // 0..3) and the monitor counts to 8 transfers total.  The monitor is
        // re-armed BEFORE the press so the debounced CS falling edge resets
        // the byte counters; the burst starts within the debounce window.
        command_monitor_enable = 1'b1;
        reconfig_n = 1'b0;
        repeat (20) @(posedge clk);
        reconfig_n = 1'b1;
        repeat (3000) @(posedge clk);
        if (adc_start !== 1'b1) begin
            $display("ADS1299 reconfig FAILED: adc_start not restored");
            error_count = error_count + 1;
        end
        adc_drdy_n = 1'b0;
        repeat (4) @(posedge clk);
        adc_drdy_n = 1'b1;
        repeat (3500) @(posedge clk);
        if (received_count != 16)
            error_count = error_count + 1;
        if (error || error_count != 0 || command_error_count != 0 || command_transfer != 8)
            $display("ADS1299 functional test FAILED: samples=%0d data_errors=%0d command_errors=%0d transfers=%0d",
                     received_count, error_count, command_error_count, command_transfer);
        else
            $display("ADS1299 functional test PASSED: samples=%0d command_transfers=%0d (reconfig replay OK)",
                     received_count, command_transfer);
        $finish;
    end

    // Capture DIN on each SCLK falling edge, matching the ADS1299 (the chip
    // latches DIN on the falling edge). The controller places each bit on the
    // preceding rising edge, so it is stable here with >= half-cycle setup.
    always @(negedge adc_cs_n) begin
        if (rst_n && command_monitor_enable) begin
            command_shift = 8'd0;
            command_bit_count = 0;
            command_byte_count = 0;
        end
    end

    always @(negedge adc_sclk) begin
        if (rst_n && command_monitor_enable && !adc_cs_n) begin
            command_shift = {command_shift[6:0], adc_din};
            if (command_bit_count == 7) begin
                $display("ADS1299 TX transfer=%0d byte=%0d value=0x%02h expected=0x%02h",
                         command_transfer, command_byte_count, command_shift,
                         expected_command_byte(command_transfer % 4, command_byte_count));
                if (command_shift !== expected_command_byte(command_transfer % 4, command_byte_count))
                    command_error_count = command_error_count + 1;
                command_byte_count = command_byte_count + 1;
                command_bit_count = 0;
            end else begin
                command_bit_count = command_bit_count + 1;
            end
        end
    end

    always @(posedge adc_cs_n) begin
        if (rst_n && command_monitor_enable) begin
            if (command_byte_count != expected_command_count(command_transfer % 4)) begin
                $display("ADS1299 TX transfer=%0d byte_count=%0d expected_count=%0d",
                         command_transfer, command_byte_count,
                         expected_command_count(command_transfer % 4));
                command_error_count = command_error_count + 1;
            end
            command_transfer = command_transfer + 1;
            // Disable between command phases: data-read frames also pulse
            // CS/SCLK and would pollute the byte stream (re-armed in the
            // stimulus right after the reconfig button press).
            if (command_transfer == 4 || command_transfer == 8)
                command_monitor_enable = 1'b0;
        end
    end

    // ADS1299 updates DOUT after rising SCLK edges; the controller samples
    // each bit on the following falling edge.
    always @(negedge adc_drdy_n) begin
        read_active = 1'b1;
        driven_bit = 0;
        adc_dout = 1'b0;
    end

    always @(posedge adc_sclk) begin
        if (read_active && !adc_cs_n) begin
            if (driven_bit < 216) begin
                adc_dout = frame_bits[215-driven_bit];
                driven_bit = driven_bit + 1'b1;
            end
        end
    end

    always @(posedge clk) begin
        if (sample_valid) begin
            $display("sample channel=%0d data=%0d expected_channel=%0d expected_data=%0d",
                     sample_channel, sample_data, received_count, (received_count % 8) + 1);
            // Same test frame (values 1..8) is driven after every DRDY edge,
            // so expectations wrap per 8-sample frame.
            if (sample_channel !== received_count[2:0] || sample_data !== (received_count % 8) + 1)
                error_count = error_count + 1;
            received_count = received_count + 1;
            if (received_count == 8)
                read_active = 1'b0;
        end
    end
endmodule
