`timescale 1ns/1ps

// Gate-level variant of emg_pl_export_tb.  Instantiates the post-synthesis
// funcsim netlist of design_1_emg_pl_export_0_4 - the exact logic inside the
// on-board bitstream (synth run 2026-10-08 17:36-17:38, bit 17:45:41) -
// instead of the behavioral RTL, to check whether the synthesized design
// reproduces the on-board MAV saturation (INT_MAX) that the behavioral sim
// does not show.
//
// Differences from emg_pl_export_tb:
//   - DUT is the OOC netlist wrapper (identical port list).
//   - No defparam: the netlist has no parameter hierarchy, so the ADS1299
//     post-reset wait is baked at the board value (POST_RESET_CYCLES =
//     3_500_000 pl_clk cycles).  The ready-wait cap is raised accordingly.
module emg_pl_export_tb_gate;
    reg pl_clk = 1'b0;
    reg axis_clk = 1'b0;
    reg pl_rst_n = 1'b0;
    reg axis_rst_n = 1'b0;
    reg adc_drdy_n = 1'b1;
    reg adc_dout = 1'b0;
    wire adc_sclk, adc_din, adc_cs_n, adc_reset_n, adc_start, adc_pwdn_n;
    wire status_led;
    wire [63:0] m_axis_tdata;
    wire m_axis_tvalid, m_axis_tlast;
    wire raw_overflow, feature_overflow, result_overflow;

    reg [215:0] frame_bits;
    reg [8:0] driven_bit;
    reg read_active = 1'b0;

    integer stim_fd, out_fd, code;
    integer v0, v1, v2, v3, v4, v5, v6, v7;
    integer frames, axi_words, feature_words, raw_words, result_words;
    integer errors, wait_count;

    always #20 pl_clk = ~pl_clk;    // 25 MHz
    always #10 axis_clk = ~axis_clk; // 50 MHz

    design_1_emg_pl_export_0_4 dut (
        .pl_clk(pl_clk), .pl_rst_n(pl_rst_n),
        .axis_clk(axis_clk), .axis_rst_n(axis_rst_n),
        .reconfig_n(1'b1),
        .adc_drdy_n(adc_drdy_n), .adc_dout(adc_dout),
        .adc_sclk(adc_sclk), .adc_din(adc_din), .adc_cs_n(adc_cs_n),
        .adc_reset_n(adc_reset_n), .adc_start(adc_start),
        .adc_pwdn_n(adc_pwdn_n), .status_led(status_led),
        .m_axis_tdata(m_axis_tdata), .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(1'b1), .m_axis_tlast(m_axis_tlast),
        .raw_overflow(raw_overflow), .feature_overflow(feature_overflow),
        .result_overflow(result_overflow)
    );

    // Behavioral ADS1299 data path: DOUT updates after rising SCLK edges;
    // the controller samples it on the following falling edge.
    always @(negedge adc_drdy_n) begin
        read_active = 1'b1;
        driven_bit = 9'd0;
        adc_dout = 1'b0;
    end

    always @(posedge adc_sclk) begin
        if (read_active && !adc_cs_n) begin
            if (driven_bit < 9'd216) begin
                adc_dout = frame_bits[215-driven_bit];
                driven_bit = driven_bit + 1'b1;
            end
        end
    end

    // AXI consumer: always ready, log every accepted word.
    always @(posedge axis_clk) begin
        if (m_axis_tvalid) begin
            axi_words = axi_words + 1;
            if (m_axis_tdata[63:60] == 4'h1) raw_words = raw_words + 1;
            else if (m_axis_tdata[63:60] == 4'h2) feature_words = feature_words + 1;
            else if (m_axis_tdata[63:60] == 4'h3) result_words = result_words + 1;
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
            read_active = 1'b0;
            @(posedge pl_clk);
        end
    endtask

    initial begin
        stim_fd = $fopen("export_stim.txt", "r");
        if (stim_fd == 0) begin
            $display("GATE TB FAILED: cannot open export_stim.txt");
            $finish;
        end
        out_fd = $fopen("export_out.csv", "w");
        $fdisplay(out_fd, "type,channel,id,sequence,payload");
        frames = 0;
        axi_words = 0;
        raw_words = 0;
        feature_words = 0;
        result_words = 0;
        errors = 0;
        frame_bits = {24'hC00000, 192'd0};

        repeat (10) @(posedge pl_clk);
        pl_rst_n = 1'b1;
        axis_rst_n = 1'b1;

        // The netlist's ADS1299 controller runs the full board timing
        // (10 ms reset + 140 ms post-reset wait = 3.75M pl_clk cycles at
        // 25 MHz) before status_led goes high, so the cap must exceed it.
        wait_count = 0;
        while (status_led !== 1'b1 && wait_count < 5_000_000) begin
            @(posedge pl_clk);
            wait_count = wait_count + 1;
        end
        if (status_led !== 1'b1) begin
            $display("GATE TB FAILED: controller never became ready");
            $finish;
        end
        repeat (100) @(posedge pl_clk);

        forever begin
            code = $fscanf(stim_fd, "%d %d %d %d %d %d %d %d",
                           v0, v1, v2, v3, v4, v5, v6, v7);
            if (code != 8) begin
                repeat (20000) @(posedge pl_clk);
                $fclose(stim_fd);
                $fclose(out_fd);
                $display("GATE TB DONE: frames=%0d raw=%0d feature=%0d result=%0d errors=%0d overflow=%b%b%b",
                         frames, raw_words, feature_words, result_words,
                         errors, raw_overflow, feature_overflow,
                         result_overflow);
                $finish;
            end
            frame_bits = {24'hC00000, v0[23:0], v1[23:0], v2[23:0], v3[23:0],
                          v4[23:0], v5[23:0], v6[23:0], v7[23:0]};
            send_frame;
            frames = frames + 1;
        end
    end
endmodule
