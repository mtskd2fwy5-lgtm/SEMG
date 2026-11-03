`timescale 1ns/1ps

// Full-chain integration test for emg_pl_export: ADS1299 SPI controller
// (with a behavioral ADC model), eight-channel feature bank, packet
// formatting and the AXI-Stream output. Reads export_stim.txt (one frame
// per line, eight space-separated signed decimals) and writes
// export_out.csv (type,channel,id,sequence,payload). tools/emg_reference.py
// verifies every raw and feature word bit-exact.
//
// Timing mirrors the board: pl_clk = 25 MHz, SCLK = 2.5 MHz, axis_clk
// = 50 MHz, one DRDY pulse per 6000 pl_clk cycles (faster than the real
// 1 kSPS cadence but far slower than any pipeline hazard).
module emg_pl_export_tb;
    reg pl_clk = 1'b0;
    reg axis_clk = 1'b0;
    reg pl_rst_n = 1'b0;
    reg axis_rst_n = 1'b0;
    reg reconfig_n = 1'b1;
    reg [1:0] adc_fault = 0;
    reg adc_drdy_n = 1'b1;
    wire adc_dout;
    wire adc_sclk, adc_din, adc_cs_n, adc_reset_n, adc_start, adc_pwdn_n;
    wire status_led;
    wire [31:0] adc_config_status;
    wire [63:0] m_axis_tdata;
    wire m_axis_tvalid, m_axis_tlast;
    wire raw_overflow, feature_overflow, result_overflow;

    reg [215:0] frame_bits;

    integer stim_fd, out_fd, code;
    integer v0, v1, v2, v3, v4, v5, v6, v7;
    integer frames, axi_words, feature_words, raw_words, result_words, notch_words;
    integer errors, wait_count;

    always #20 pl_clk = ~pl_clk;    // 25 MHz
    always #10 axis_clk = ~axis_clk; // 50 MHz

    emg_pl_export_status dut (
        .pl_clk(pl_clk), .pl_rst_n(pl_rst_n),
        .axis_clk(axis_clk), .axis_rst_n(axis_rst_n),
        .reconfig_n(reconfig_n),
        .adc_drdy_n(adc_drdy_n), .adc_dout(adc_dout),
        .adc_sclk(adc_sclk), .adc_din(adc_din), .adc_cs_n(adc_cs_n),
        .adc_reset_n(adc_reset_n), .adc_start(adc_start),
        .adc_pwdn_n(adc_pwdn_n), .status_led(status_led), .adc_config_status(adc_config_status),
        .m_axis_tdata(m_axis_tdata), .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(1'b1), .m_axis_tlast(m_axis_tlast),
        .raw_overflow(raw_overflow), .feature_overflow(feature_overflow),
        .result_overflow(result_overflow)
    );

    // Keep the integration test short while preserving the RTL state
    // sequence. The board value is 140 ms; this test only needs to verify
    // reset/configuration ordering before feeding the behavioral ADC.
    defparam dut.u_core.u_ads1299_spi.POST_RESET_CYCLES = 3_500;
    defparam dut.u_core.u_ads1299_spi.BTN_DEBOUNCE_CYCLES = 8;

    ads1299_model adc(.reset_n(adc_reset_n),.cs_n(adc_cs_n),.sclk(adc_sclk),
        .din(adc_din),.drdy_n(adc_drdy_n),.frame_bits(frame_bits),
        .fault(adc_fault),.fault_address(5'd13),.dout(adc_dout));

    // AXI consumer: always ready, log every accepted word.  Result words
    // (type 3) are verified bit-exact by tools/check_pl_nn_sim.py against
    // the Python INT8 model fed with this very stream's feature words.
    always @(posedge axis_clk) begin
        if (m_axis_tvalid) begin
            axi_words = axi_words + 1;
            if (m_axis_tdata[63:60] == 4'h1) raw_words = raw_words + 1;
            else if (m_axis_tdata[63:60] == 4'h5) notch_words = notch_words + 1;
            else if (m_axis_tdata[63:60] == 4'h2) feature_words = feature_words + 1;
            else if (m_axis_tdata[63:60] == 4'h3 ||
                     m_axis_tdata[63:60] == 4'h4) result_words = result_words + 1;
            else errors = errors + 1;
            $fdisplay(out_fd, "%0d,%0d,%0d,%0d,%0d",
                      m_axis_tdata[63:60], m_axis_tdata[59:56],
                      m_axis_tdata[55:52], m_axis_tdata[47:32],
                      m_axis_tdata[31:0]);
        end
    end

    task send_frame;
        begin
            @(negedge pl_clk);
            adc_drdy_n = 1'b0;
            repeat (12) @(posedge pl_clk);
            adc_drdy_n = 1'b1;
            // Frame read starts (LED off) and completes (LED on).
            wait_count = 0;
            while (status_led !== 1'b0 && wait_count < 100000) begin
                @(posedge pl_clk);
                wait_count = wait_count + 1;
            end
            if (wait_count >= 100000) begin
                errors = errors + 1;
                $display("timeout waiting for frame read start");
            end
            wait_count = 0;
            while (status_led !== 1'b1 && wait_count < 100000) begin
                @(posedge pl_clk);
                wait_count = wait_count + 1;
            end
            if (wait_count >= 100000) begin
                errors = errors + 1;
                $display("timeout waiting for frame read end");
            end
            @(posedge pl_clk);
        end
    endtask

    task check_status_replay;
        begin
            adc_fault=1;
            @(negedge pl_clk);reconfig_n=0;
            repeat(30) @(negedge pl_clk);reconfig_n=1;
            wait(adc_config_status==0);
            wait(adc_config_status[31]);
            if(adc_config_status!==32'hADED0001 || adc_start || status_led)
                $fatal(1,"failure mailbox mismatch %h",adc_config_status);
            adc_fault=0;
            @(negedge pl_clk);reconfig_n=0;
            repeat(30) @(negedge pl_clk);reconfig_n=1;
            wait(adc_config_status==0);
            wait(adc_start);
            repeat(100) @(posedge axis_clk);
            if(adc_config_status!==32'hC0ED0101)
                $fatal(1,"recovery mailbox mismatch %h",adc_config_status);
            $display("CHECK ADC mailbox WAIT/error/actual bytes/recovery PASS");
        end
    endtask

    initial begin
        stim_fd = $fopen("export_stim.txt", "r");
        if (stim_fd == 0) begin
            $fatal(1,"EMG export TB FAILED: cannot open export_stim.txt");
        end
        out_fd = $fopen("export_out.csv", "w");
        $fdisplay(out_fd, "type,channel,id,sequence,payload");
        frames = 0;
        axi_words = 0;
        raw_words = 0;
        notch_words = 0;
        feature_words = 0;
        result_words = 0;
        errors = 0;
        frame_bits = {24'hC00000, 192'd0};

        repeat (10) @(posedge pl_clk);
        pl_rst_n = 1'b1;
        axis_rst_n = 1'b1;

        // Wait for the controller to finish reset, register configuration
        // and START (status LED on, adc_start asserted).
        wait_count = 0;
        while (status_led !== 1'b1 && wait_count < 500000) begin
            @(posedge pl_clk);
            wait_count = wait_count + 1;
        end
        if (status_led !== 1'b1) begin
            $fatal(1,"EMG export TB FAILED: controller never became ready");
        end
        repeat (100) @(posedge pl_clk);
        if(adc_config_status!==32'hC0ED0101)
            $fatal(1,"ADC config mailbox mismatch %h",adc_config_status);

        forever begin
            code = $fscanf(stim_fd, "%d %d %d %d %d %d %d %d",
                           v0, v1, v2, v3, v4, v5, v6, v7);
            if (code != 8) begin
                // Drain: let the feature serializer flush remaining words.
                repeat (20000) @(posedge pl_clk);
                $fclose(stim_fd);
                $fclose(out_fd);
                check_status_replay;
                if (errors == 0 && raw_words == frames*8 && notch_words == frames*8
                    && !raw_overflow && !feature_overflow
                    && !result_overflow)
                    $display("TEST_PASS EMG export: frames=%0d raw=%0d notch=%0d feature=%0d result=%0d",
                             frames, raw_words, notch_words, feature_words, result_words);
                else
                    $fatal(1,"EMG export TB FAILED: frames=%0d raw=%0d feature=%0d result=%0d errors=%0d overflow=%b%b%b",
                             frames, raw_words, feature_words, result_words,
                             errors, raw_overflow, feature_overflow,
                             result_overflow);
                $finish;
            end
            // Frame order on the ADS1299 data stream: status, ch0..ch7.
            frame_bits = {24'hC00000, v0[23:0], v1[23:0], v2[23:0], v3[23:0],
                          v4[23:0], v5[23:0], v6[23:0], v7[23:0]};
            send_frame;
            frames = frames + 1;
        end
    end
    initial begin #1_000_000_000; $fatal(1,"EMG export watchdog"); end
endmodule

