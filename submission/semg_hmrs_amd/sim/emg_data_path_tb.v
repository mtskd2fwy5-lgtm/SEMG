`timescale 1ns/1ps
module emg_data_path_tb;
    reg pl_clk=0, axis_clk=0, pl_rst_n=0, axis_rst_n=0;
    reg raw_valid=0, notch_valid=0, feature_valid=0, result_valid=0;
    reg [2:0] raw_channel=0, notch_channel=0, feature_channel=0;
    reg signed [23:0] raw_data=0, notch_data=0;
    reg [15:0] raw_sequence=0, notch_sequence=0, feature_sequence=0, result_sequence=0;
    reg [3:0] feature_id=0, result_id=0;
    reg [31:0] feature_data=0, result_data=0;
    reg m_axis_tready=0;
    wire raw_ready, notch_ready, feature_ready, result_ready;
    wire raw_overflow, notch_overflow, feature_overflow, result_overflow;
    wire [63:0] m_axis_tdata;
    wire m_axis_tvalid, m_axis_tlast;
    reg [63:0] q0[0:255], q1[0:255], q2[0:255], q3[0:255];
    integer w0=0,w1=0,w2=0,w3=0,r0=0,r1=0,r2=0,r3=0;
    integer received=0,stall_checks=0,i,tick,s0,s1,s2,s3;
    reg stalled=0;
    reg [63:0] stall_data,offered;
    reg stall_last;
    always #5 pl_clk=~pl_clk;
    always #7 axis_clk=~axis_clk;
    emg_data_path #(.FIFO_ADDR_WIDTH(2),.RAW_FIFO_ADDR_WIDTH(2),.PACKET_WORDS(4)) dut (
        .pl_clk(pl_clk),.pl_rst_n(pl_rst_n),.axis_clk(axis_clk),.axis_rst_n(axis_rst_n),
        .raw_valid(raw_valid),.raw_ready(raw_ready),.raw_channel(raw_channel),
        .raw_data(raw_data),.raw_sequence(raw_sequence),
        .notch_valid(notch_valid),.notch_ready(notch_ready),.notch_channel(notch_channel),
        .notch_data(notch_data),.notch_sequence(notch_sequence),
        .feature_valid(feature_valid),.feature_ready(feature_ready),
        .feature_channel(feature_channel),.feature_id(feature_id),
        .feature_data(feature_data),.feature_sequence(feature_sequence),
        .result_valid(result_valid),.result_ready(result_ready),.result_id(result_id),
        .result_data(result_data),.result_sequence(result_sequence),
        .raw_overflow(raw_overflow),.notch_overflow(notch_overflow),
        .feature_overflow(feature_overflow),.result_overflow(result_overflow),
        .m_axis_tdata(m_axis_tdata),.m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready),.m_axis_tlast(m_axis_tlast));
    // Scoreboard each independent lane without assuming CDC arrival ordering.
    always @(posedge pl_clk) begin
        if(!dut.fifo_pl_rst_n) begin w0=0;w1=0;w2=0;w3=0;end
        else begin
            if(raw_valid&&raw_ready) begin
                q0[w0]={4'h1,1'b0,raw_channel,8'h00,raw_sequence,8'h00,raw_data};w0=w0+1;end
            if(notch_valid&&notch_ready) begin
                q1[w1]={4'h5,1'b0,notch_channel,8'h00,notch_sequence,8'h00,notch_data};w1=w1+1;end
            if(feature_valid&&feature_ready) begin
                q2[w2]={4'h2,1'b0,feature_channel,feature_id,4'h0,feature_sequence,feature_data};w2=w2+1;end
            if(result_valid&&result_ready) begin
                q3[w3]={(result_id[3]?4'h4:4'h3),4'h0,result_id,4'h0,result_sequence,result_data};w3=w3+1;end
        end
    end
    always @(posedge axis_clk) begin
        if(!dut.fifo_axis_rst_n) begin r0=0;r1=0;r2=0;r3=0;received=0;stalled=0;end
        else begin
            if(stalled) begin
                if(!m_axis_tvalid||m_axis_tdata!==stall_data||m_axis_tlast!==stall_last)
                    $fatal(1,"AXI offer changed during backpressure");
                stall_checks=stall_checks+1;
            end
            stalled=m_axis_tvalid&&!m_axis_tready;stall_data=m_axis_tdata;stall_last=m_axis_tlast;
            if(m_axis_tvalid&&m_axis_tready) begin
                case(m_axis_tdata[63:60])
                    1:begin if(r0>=w0||m_axis_tdata!==q0[r0]) $fatal(1,"raw mismatch %0d",r0);r0=r0+1;end
                    5:begin if(r1>=w1||m_axis_tdata!==q1[r1]) $fatal(1,"notch mismatch %0d",r1);r1=r1+1;end
                    2:begin if(r2>=w2||m_axis_tdata!==q2[r2]) $fatal(1,"feature mismatch %0d",r2);r2=r2+1;end
                    3,4:begin if(r3>=w3||m_axis_tdata!==q3[r3]) $fatal(1,"result mismatch %0d",r3);r3=r3+1;end
                    default:$fatal(1,"unexpected type");
                endcase
                if(m_axis_tlast!==((received%4)==3)) $fatal(1,"TLAST mismatch %0d",received);
                received=received+1;
            end
        end
    end
    task reset_all;begin
        @(negedge pl_clk);pl_rst_n=0;axis_rst_n=0;m_axis_tready=0;
        raw_valid=0;notch_valid=0;feature_valid=0;result_valid=0;
        repeat(5) @(negedge axis_clk);
        @(negedge pl_clk);pl_rst_n=1;axis_rst_n=1;
        repeat(6) @(negedge pl_clk);
    end endtask
    task drain;integer n;begin
        @(negedge axis_clk);m_axis_tready=1;n=0;
        while(r0!=w0||r1!=w1||r2!=w2||r3!=w3) begin
            @(negedge axis_clk);n=n+1;if(n>1000) $fatal(1,"drain timeout");end
        repeat(8) @(negedge axis_clk);
    end endtask
    initial begin
        reset_all();
        // Feature is offered first; a higher-priority raw FIFO becomes nonempty while stalled.
        @(negedge pl_clk);feature_valid=1;feature_channel=6;feature_id=4;
        feature_sequence=16'hffff;feature_data=32'h81234567;
        @(negedge pl_clk);feature_valid=0;
        wait(m_axis_tvalid);@(negedge axis_clk);offered=m_axis_tdata;
        if(offered[63:60]!==4'h2) $fatal(1,"directed stall missing");
        @(negedge pl_clk);raw_valid=1;raw_channel=7;raw_data=-24'sd8388608;raw_sequence=16'hffff;
        @(negedge pl_clk);raw_valid=0;
        repeat(10) @(negedge axis_clk);
        if(m_axis_tdata!==offered) $fatal(1,"stalled word replaced");
        drain();
        if(received!=2||stall_checks<10) $fatal(1,"directed stall not exercised");
        s0=0;s1=0;s2=0;s3=0;tick=0;
        fork
            begin
                while(s0<64||s1<64||s2<64||s3<64) begin
                    @(negedge pl_clk);
                    raw_valid=(s0<64)&&raw_ready;raw_channel=s0%8;
                    raw_data=(s0&1)?-s0*12345:s0*90123;raw_sequence=65520+s0/8;
                    notch_valid=(s1<64)&&notch_ready;notch_channel=s1%8;
                    notch_data=(s1&1)?s1*54321:-s1*12345;notch_sequence=65530+s1/8;
                    feature_valid=(s2<64)&&feature_ready;feature_channel=s2%8;
                    feature_id=s2%5;feature_data=32'hfedc0000+s2;feature_sequence=s2;
                    result_valid=(s3<64)&&result_ready;result_id=(s3&1)?9:5;
                    result_data=32'h80000000+s3;result_sequence=65530+s3;
                    if(raw_valid)s0=s0+1;if(notch_valid)s1=s1+1;
                    if(feature_valid)s2=s2+1;if(result_valid)s3=s3+1;
                end
                @(negedge pl_clk);raw_valid=0;notch_valid=0;feature_valid=0;result_valid=0;
            end
            begin
                repeat(650) begin
                    @(negedge axis_clk);m_axis_tready=(tick%13>=5);tick=tick+1;end
            end
        join
        drain();
        if(received!=258||raw_overflow||notch_overflow||feature_overflow||result_overflow)
            $fatal(1,"nominal loss/overflow count=%0d",received);
        // DMA-only and PL-only short pulses must flush every lane, even
        // without a source-clock edge during assertion. RAM holds old words.
        for(tick=0;tick<6;tick=tick+1) begin
            reset_all();
            for(i=0;i<3;i=i+1) begin
                @(negedge pl_clk);raw_valid=1;notch_valid=1;feature_valid=1;result_valid=1;
                raw_data=100+i;notch_data=-100-i;feature_data=i;result_data=i;
            end
            @(negedge pl_clk);raw_valid=0;notch_valid=0;feature_valid=0;result_valid=0;
            wait(m_axis_tvalid);
            @(negedge pl_clk); #1;
            if(tick%2==0) axis_rst_n=0; else pl_rst_n=0;
            #1;
            if(m_axis_tvalid||raw_ready||notch_ready) $fatal(1,"reset handshake not suppressed");
            #1;axis_rst_n=1;pl_rst_n=1;
            repeat(10) @(negedge pl_clk);
            if(m_axis_tvalid) $fatal(1,"stale memory visible after unilateral reset");
            @(negedge pl_clk);raw_valid=1;notch_valid=1;feature_valid=1;result_valid=1;
            raw_sequence=60000+tick;notch_sequence=60000+tick;
            raw_data=777+tick;notch_data=-777-tick;feature_data=1234;result_data=4321;
            @(negedge pl_clk);raw_valid=0;notch_valid=0;feature_valid=0;result_valid=0;
            drain();
            if(received!=4) $fatal(1,"reset lost/replayed words: %0d",received);
        end
        reset_all();
        // An unthrottled ADC-like producer must expose rejected beats as sticky overflow.
        for(i=0;i<7;i=i+1) begin
            @(negedge pl_clk);raw_valid=1;notch_valid=1;feature_valid=1;result_valid=1;
            raw_data=i;notch_data=-i;feature_data=i;result_data=i;end
        @(negedge pl_clk);raw_valid=0;notch_valid=0;feature_valid=0;result_valid=0;
        repeat(5) @(negedge pl_clk);
        if(!(raw_overflow&&notch_overflow&&feature_overflow&&result_overflow))
            $fatal(1,"missing overflow diagnostic");
        drain();
        if(!(raw_overflow&&notch_overflow&&feature_overflow&&result_overflow))
            $fatal(1,"overflow not sticky");
        reset_all();
        if(raw_overflow||notch_overflow||feature_overflow||result_overflow) $fatal(1,"reset failed");
        $display("TEST_PASS data_path: four lanes, fields, sequence wrap, TLAST, %0d stall checks, overflow/reset, six unilateral reset flushes",stall_checks);
        $finish;
    end
    initial begin #1000000;$fatal(1,"data path watchdog");end
endmodule

