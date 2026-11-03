`timescale 1ns/1ps
module emg_notch50_tb;
    reg clk=0, rst_n=0, sample_valid=0;
    reg signed [23:0] sample_data=0;
    reg [2:0] sample_channel=0;
    reg [15:0] sample_sequence=0;
    wire sample_ready, filtered_valid, overrun;
    wire signed [23:0] filtered_data;
    wire [2:0] filtered_channel;
    wire [15:0] filtered_sequence;
    integer fd, out_fd, code, reset_row, block_i, frame_i, ch_i, seq_i, x_i, y_i, gap_i;
    integer expected, expected_ch, expected_seq, expected_block, expected_frame;
    integer received=0, accepted=0, pending=0, checking=0;
`ifdef LINE_FILTER_TEST
`ifdef FINAL_PROCESSED_TEST
    emg_line_filter #(.BANDPASS_ENABLE(1)) dut(.*);
`else
    emg_line_filter dut(.*);
`endif
`else
    emg_notch50 dut(.*);
`endif
    always #5 clk=~clk;

    always @(posedge clk) begin
        if (checking && rst_n && sample_valid) begin
            if (!sample_ready || pending) $fatal(1,"input contract violated");
            pending=1; accepted=accepted+1;
            expected=y_i; expected_ch=ch_i; expected_seq=seq_i;
            expected_block=block_i; expected_frame=frame_i;
        end
        #1;
        if (checking && rst_n && filtered_valid) begin
            if (!pending || filtered_data !== expected || filtered_channel !== expected_ch
                || filtered_sequence !== expected_seq)
                $fatal(1,"notch mismatch row=%0d got=%0d want=%0d ch=%0d/%0d seq=%0d/%0d",
                       received,filtered_data,expected,filtered_channel,expected_ch,filtered_sequence,expected_seq);
            $fdisplay(out_fd,"%0d,%0d,%0d,%0d,%0d",expected_block,expected_frame,
                      filtered_channel,filtered_sequence,filtered_data);
            received=received+1; pending=0;
        end
        if (checking && rst_n && overrun) $fatal(1,"unexpected overrun");
    end

    initial begin
        fd=$fopen("notch_stim.txt","r"); out_fd=$fopen("notch_out.csv","w");
        if (!fd || !out_fd) $fatal(1,"cannot open notch test files");
        $fdisplay(out_fd,"block,frame,channel,sequence,payload");
        repeat(3) @(negedge clk); rst_n=1;
        // An impossible producer cadence must be reported, not silently lost.
        sample_valid=1; sample_data=123;
        repeat(2) @(negedge clk);
        sample_valid=0;
        if (!overrun) $fatal(1,"missing overrun diagnostic");
        // Reset a job in flight; it must not emit a stale channel/sequence.
        rst_n=0; repeat(2) @(negedge clk); rst_n=1;
        repeat(20) begin @(negedge clk); if(filtered_valid || overrun) $fatal(1,"stale reset output"); end
        checking=1;
        forever begin
            code=$fscanf(fd,"%d %d %d %d %d %d %d %d",reset_row,block_i,frame_i,ch_i,seq_i,x_i,y_i,gap_i);
            if (code != 8) begin
                repeat(20) @(negedge clk);
                if(pending || received != accepted || received == 0) $fatal(1,"missing output");
                $fclose(fd); $fclose(out_fd);
                $display("TEST_PASS notch50: %0d beats, reset, overrun, channel/sequence alignment",received);
                $finish;
            end
            if(reset_row) begin
                if(pending) $fatal(1,"pending at block boundary");
                rst_n=0; repeat(2) @(negedge clk); rst_n=1;
            end
            sample_valid=1; sample_data=x_i; sample_channel=ch_i; sample_sequence=seq_i;
            @(negedge clk); sample_valid=0;
            repeat(gap_i-1) @(negedge clk);
        end
    end
    initial begin #1000000000; $fatal(1,"notch watchdog"); end
endmodule

