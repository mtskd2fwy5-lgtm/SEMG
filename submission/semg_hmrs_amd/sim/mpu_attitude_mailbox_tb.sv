`timescale 1ns/1ps
module mpu_attitude_mailbox_tb;
    reg clk=0;always #5 clk=~clk;
    reg rst_n=0;
    reg [31:0] word=0,a=0,b=32'hc0000000,c=0,command=0;
    wire [31:0] response;
    mpu_attitude dut(clk,rst_n,word,a,b,c,command,response);
    integer i;integer ax,az;real radians;reg [31:0] flags,counter,value,frozen;
    task transaction(input [3:0] op,input [7:0] index,output [31:0] payload);
        integer n;
        begin
            @(negedge clk);command={~command[31],3'd0,op,16'd0,index};n=0;
            while(response[31]!==command[31] && n<100)begin @(negedge clk);n=n+1;end
            if(n==100)$fatal(1,"mailbox ack timeout");
            payload=response&32'h7fffffff;
        end
    endtask
    task sample(input integer number);
        begin
            @(negedge clk);word=32'h80000000|((number&127)<<24);
`ifdef IMU_NETLIST_TEST
            // Keep >10 us margin over the complete core replay peak while
            // avoiding idle gate-level clocks. Sensor dt derives from seq.
            repeat(7500)@(negedge clk);
`else
            repeat(12000)@(negedge clk);
`endif
        end
    endtask
    initial begin #500000000;$fatal(1,"mailbox watchdog");end
    initial begin
        repeat(30)@(negedge clk);rst_n=1;
        for(i=0;i<103;i=i+1)sample(i);
        transaction(1,0,value);if(value!==32'h17494d55)$fatal(1,"mailbox ABI");
        transaction(2,1,flags);if(flags[3:0]!=15 || flags[14:8]!=100)$fatal(1,"calibration flags %h",flags);
        transaction(2,2,frozen);sample(103);
        transaction(2,2,counter);if(counter!==frozen)$fatal(1,"snapshot changed during read");
        transaction(2,3,value);if($signed({value[30],value[30:0]})> -4090)$fatal(1,"signed matrix %h",value);
        transaction(1,0,value);transaction(2,2,counter);if(counter<=frozen)$fatal(1,"snapshot failed to advance");
        transaction(2,28,value);if(value!=0)$fatal(1,"overrun");
        transaction(2,32,value);if(value!=32'h7fffffff)$fatal(1,"bad index handling");
        transaction(3,0,value);repeat(600)@(negedge clk);
        transaction(1,0,value);transaction(2,1,flags);if(flags!=0)$fatal(1,"zero failed to invalidate");
        for(i=104;i<207;i=i+1)sample(i);
        transaction(1,0,value);transaction(2,1,flags);if(flags[3:0]!=15)$fatal(1,"rezero failed");
        for(i=1;i<=60;i=i+1)begin
            radians=i*3.141592653589793/180.0;
            ax=$rtoi(-$sin(radians)*16384);az=$rtoi(-$cos(radians)*16384);
            @(negedge clk);a=(ax&65535)<<16;b=(az&65535)<<16;c=32'hf3300000; // gy=-3280
            sample(206+i);
        end
        transaction(1,0,value);transaction(2,12,value);
        if(value<58 || value>62)$fatal(1,"60 degree twist mismatch %d",value);
        // Recalibrate at 60 degrees and verify signed relative movement.
        @(negedge clk);c=0;
        transaction(3,0,value);repeat(600)@(negedge clk);
        for(i=267;i<370;i=i+1)sample(i);
        transaction(1,0,value);transaction(2,1,flags);
        if(flags[3:0]!=15)$fatal(1,"tilted recalibration failed");
        transaction(2,3,value);
        if($signed({value[30],value[30:0]})> -4090)$fatal(1,"calibrated X zero mismatch");
        transaction(2,11,value);
        if($signed({value[30],value[30:0]})> -4090)$fatal(1,"calibrated Z zero mismatch");
        transaction(2,12,value);
        if($signed({value[30],value[30:0]})< -1 || $signed({value[30],value[30:0]})>1)$fatal(1,"twist did not rebase to zero");
        for(i=1;i<=30;i=i+1)begin
            radians=(60-i)*3.141592653589793/180.0;
            ax=$rtoi(-$sin(radians)*16384);az=$rtoi(-$cos(radians)*16384);
            @(negedge clk);a=(ax&65535)<<16;b=(az&65535)<<16;c=32'h0cd00000;
            sample(369+i);
        end
        transaction(1,0,value);transaction(2,12,value);
        if($signed({value[30],value[30:0]})< -32 || $signed({value[30],value[30:0]})> -28)
            $fatal(1,"relative negative twist mismatch %h",value);
        $display("TEST_PASS arbitrary-pose recalibration: 60deg capture becomes zero, -30deg follow");
        @(negedge clk);word=0;repeat(12)@(negedge clk);
        transaction(1,0,value);transaction(2,1,flags);if(flags!=0)$fatal(1,"disconnect retained valid snapshot");
        sample(1);sample(2);
        transaction(1,0,value);transaction(2,1,flags);if(flags[0]!=1 || flags[1]!=0)$fatal(1,"reconnect/provisional tracking");
`ifndef IMU_NETLIST_TEST
        repeat(10000010)@(negedge clk);
        transaction(1,0,value);transaction(2,1,flags);if(flags!=0)$fatal(1,"stuck sequence timeout failed");
        $display("TEST_PASS PL attitude mailbox CDC settling, atomic snapshot, signed read, zero/reconnect and stale timeout");$finish;
`else
        $display("TEST_PASS synthesized PL attitude calibration, 60deg twist, atomic snapshot, zero and disconnect");$finish;
`endif
    end
endmodule

