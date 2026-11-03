`timescale 1ns/1ps
module emg_learning_accel_tb;
    reg clk=0;always #5 clk=~clk;
    reg rst_n=0;reg [31:0] command=0;wire [31:0] status;
    wire [31:0] awaddr,wdata,araddr;wire [7:0] awlen,arlen;wire [2:0] awsize,arsize;
    wire [1:0] awburst,arburst;wire awvalid,wvalid,arvalid,rready,bready,wlast;wire [3:0] wstrb;
    reg awready=0,wready=0,arready=0,bvalid=0,rvalid=0;
    reg [31:0] rdata;reg [1:0] bresp=0,rresp=0;
    reg [31:0] mem[0:65535];reg [31:0] saved_aw,saved_w;reg got_aw=0,got_w=0;
    reg [31:0] cycle=0;integer delay_r=0;reg pending_r=0;
    reg inject_error=0,hang_reads=0;
`ifdef LEARNING_NETLIST
    design_1_emg_learning_0_0 dut(.clk(clk),.rst_n(rst_n),.command(command),.status(status),
`else
    emg_learning_accel #(.WATCHDOG(200000)) dut(.clk(clk),.rst_n(rst_n),.command(command),.status(status),
`endif
        .m_axi_awaddr(awaddr),.m_axi_awlen(awlen),.m_axi_awsize(awsize),.m_axi_awburst(awburst),
        .m_axi_awvalid(awvalid),.m_axi_awready(awready),.m_axi_wdata(wdata),.m_axi_wstrb(wstrb),
        .m_axi_wlast(wlast),.m_axi_wvalid(wvalid),.m_axi_wready(wready),.m_axi_bresp(bresp),
        .m_axi_bvalid(bvalid),.m_axi_bready(bready),.m_axi_araddr(araddr),.m_axi_arlen(arlen),
        .m_axi_arsize(arsize),.m_axi_arburst(arburst),.m_axi_arvalid(arvalid),.m_axi_arready(arready),
        .m_axi_rdata(rdata),.m_axi_rresp(rresp),.m_axi_rlast(1'b1),.m_axi_rvalid(rvalid),.m_axi_rready(rready));
    function integer index_of(input [31:0] a);
        if(a>=32'h12000000)index_of=(a-32'h12000000)/4;
        else index_of=60000+(a-32'h11100000)/4;
    endfunction
    // Independent, varying channel delays; held response must be stable.
    always @(posedge clk)begin
        cycle<=cycle+1;awready<=cycle%3==0;wready<=cycle%5==0;arready<=cycle%4==0;
        if(!rst_n)begin bvalid<=0;rvalid<=0;got_aw<=0;got_w<=0;pending_r<=0;end
        else begin
            if(awvalid && awready)begin saved_aw<=awaddr;got_aw<=1;end
            if(wvalid && wready)begin saved_w<=wdata;got_w<=1;end
            if(got_aw && got_w && !bvalid)begin
                mem[index_of(saved_aw)]<=saved_w;got_aw<=0;got_w<=0;bvalid<=1;bresp<=inject_error?2:0;
            end
            if(bvalid && bready)bvalid<=0;
            if(arvalid && arready)begin pending_r<=1;delay_r<=3;saved_aw<=araddr;end
            if(pending_r && !rvalid && !hang_reads)begin
                if(delay_r==0)begin rdata<=mem[index_of(saved_aw)];rvalid<=1;rresp<=inject_error?2:0;pending_r<=0;end
                else delay_r<=delay_r-1;
            end
            if(rvalid && rready)rvalid<=0;
        end
    end
    task send(input [6:0] op,input [23:0] value);
        begin @(negedge clk);command={!command[31],op,value};
            @(negedge clk);if(status[31]!=command[31])$fatal(1,"mailbox ACK");end
    endtask
    task arg_set(input [2:0] idx,input [31:0] value);
        begin send(1,{8'd0,value[15:0]});send(2,{8'd0,value[31:16]});send(3,{21'd0,idx});end
    endtask
    integer max_cycles[0:6];integer proto_hash_before=0,proto_hash_after=0;
    task run(input [3:0] job,input bit expect_error);
        integer start_cycle;
        begin send(4,{20'd0,job});start_cycle=cycle;
            while(status[30])begin @(negedge clk);if(cycle-start_cycle>250000)$fatal(1,"job timeout");end
            if(status[29]!=expect_error)$fatal(1,"job=%0d status=%h",job,status);
            if(!expect_error && cycle-start_cycle>max_cycles[job])max_cycles[job]=cycle-start_cycle;
        end
    endtask
    reg [31:0] vectors[0:32767];integer tests,t,i,c,n;integer ptr;
    initial begin
        for(i=0;i<65536;i=i+1)mem[i]=0;
        for(i=0;i<7;i=i+1)max_cycles[i]=0;
        $readmemh("learning_vectors.mem",vectors);
        // Let the primitive-library 100 ns global reset settle in netlist mode.
        repeat(32)@(negedge clk);rst_n=1;
        @(negedge clk);if(status[23:16]!==8'h13)$fatal(1,"learning ABI mismatch");
        arg_set(0,32'h11100000);arg_set(1,32'h11100040);arg_set(2,32'h12000000);
        arg_set(3,32'h11100080);arg_set(4,6);
        tests=vectors[0];ptr=1;
        for(t=0;t<tests;t=t+1)begin
            for(i=0;i<8;i=i+1)mem[60000+i]=vectors[ptr+i];ptr=ptr+8;
            run(1,0);
            for(i=0;i<8;i=i+1)if(mem[60032+i]!==vectors[ptr+i])
                $fatal(1,"NMF t=%0d i=%0d got=%d expected=%d",t,i,mem[60032+i],vectors[ptr+i]);
            ptr=ptr+8;
        end
        $display("TEST_PASS NMF bit-exact %0d windows",tests);
        // Scale update from a batch; maxima must match all committed samples.
        arg_set(0,32'h12008000);arg_set(4,3);
        for(i=0;i<24;i=i+1)mem[8192+i]=vectors[ptr+i];ptr=ptr+24;
        run(2,0);
        for(i=0;i<8;i=i+1)if(mem[60016+i]!==vectors[ptr+i])$fatal(1,"scale channel%0d",i);
        ptr=ptr+8;arg_set(0,32'h11100000);
        // Train six classes, 120 heterogeneous examples each. Golden signed
        // prototypes and queries are independent Python references.
        for(c=0;c<6;c=c+1)begin
            arg_set(2,32'h12000000+c*4096);
`ifdef LEARNING_NETLIST
            for(n=0;n<4;n=n+1)begin
`else
            for(n=0;n<120;n=n+1)begin
`endif
                for(i=0;i<8;i=i+1)mem[60000+i]=vectors[ptr+i];ptr=ptr+8;run(5,0);
            end
            for(i=0;i<1024;i=i+1)if(mem[c*1024+i]!==vectors[ptr+i])
                $fatal(1,"HDC proto class%0d word%0d got%h exp%h",c,i,mem[c*1024+i],vectors[ptr+i]);
            ptr=ptr+1024;
        end
        $display("TEST_PASS HDC normalization majority encoding and prototype learning");
        for(i=0;i<6144;i=i+1)proto_hash_before=proto_hash_before^mem[i];
        arg_set(2,32'h12000000);arg_set(4,6);
        tests=vectors[ptr];ptr=ptr+1;
        for(t=0;t<tests;t=t+1)begin
            for(i=0;i<8;i=i+1)mem[60000+i]=vectors[ptr+i];ptr=ptr+8;run(6,0);
            for(i=0;i<4;i=i+1)if(mem[60032+i]!==vectors[ptr+i])
                $fatal(1,"HDC prediction %0d field%0d got%d exp%d",t,i,mem[60032+i],vectors[ptr+i]);
            ptr=ptr+4;
        end
        for(i=0;i<6144;i=i+1)proto_hash_after=proto_hash_after^mem[i];
        if(proto_hash_before!==proto_hash_after)$fatal(1,"prediction mutated prototypes");
        $display("TEST_PASS HDC prediction margin clipping tie handling and frozen prototype");
        // Q16 legacy model support after Q32 inference, independent golden.
        for(i=0;i<6144;i=i+1)mem[i]=0;
        for(i=0;i<8;i=i+1)mem[60000+i]=vectors[ptr+i];ptr=ptr+8;
        arg_set(2,32'h12000000);arg_set(4,1);run(3,0);
        for(i=0;i<1024;i=i+1)if(mem[i]!==vectors[ptr+i])$fatal(1,"legacy Q16 ROM mismatch word%0d",i);
        ptr=ptr+1024;run(4,0);
        if(mem[60032]!=0 || mem[60033]!=0 || mem[60035]!=0)$fatal(1,"single-class must not manufacture margin");
        $display("TEST_PASS legacy Q16 model encoding and single-class zero precise margin");
        arg_set(4,6);
        for(i=0;i<6144;i=i+1)mem[i]=0;
        run(4,0);
        if(mem[60032]!=0 || mem[60033]!=0)$fatal(1,"equal-score tie must choose first class, margin0");
        for(i=0;i<8;i=i+1)mem[60016+i]=0;
        run(4,0);
        if(mem[60032]!=0 || mem[60033]!=0)$fatal(1,"zero scale normalization");
        $display("TEST_PASS zero scale and exact first-class ties");
        // Saturation of signed16 endpoints, including negative 32768 score.
        for(i=0;i<1024;i=i+1)mem[i]=32'h80007fff;
        run(3,0);
        if(mem[60032]==0)$fatal(1,"missing saturation reporting");
        $display("TEST_PASS HDC saturating prototype update");
        arg_set(0,32'h10000000);run(1,1);
        arg_set(0,32'h11100000);inject_error=1;run(1,1);inject_error=0;
        run(1,0);
        $display("TEST_PASS address bounds AXI response fault and retry");
`ifndef LEARNING_NETLIST
        hang_reads=1;run(1,1);
        if(!status[28])$fatal(1,"timeout did not quarantine");
        hang_reads=0;repeat(20)@(negedge clk);run(1,1);
        $display("TEST_PASS timeout quarantine drains late read without restarting");
`endif
        for(i=1;i<7;i=i+1)$display("LEARNING_CYCLES job%0d max=%0d clock=100MHz AXI with variable stalls",i,max_cycles[i]);
        $display("TEST_PASS learning accelerator complete");$finish;
    end
    initial begin repeat(20)#1000000000;$fatal(1,"watchdog");end
endmodule

