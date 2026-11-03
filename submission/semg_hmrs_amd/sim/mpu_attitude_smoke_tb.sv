`timescale 1ns/1ps
module mpu_attitude_smoke_tb;
    reg clk=0;always #5 clk=~clk;
    reg rst_n=0,valid=0,gap=0;
    reg [6:0] seq=0;
    reg [31:0] a=0,b=32'h40000000,c=0;
    wire ready,done;wire [959:0] result;wire [31:0] overruns;
    mpu_attitude_core dut(clk,rst_n,valid,seq,a,b,c,gap,ready,done,result,overruns);
    integer i,k,ticks;
    initial begin #100000000;$fatal(1,"attitude smoke watchdog");end
    initial begin
        repeat(5)@(negedge clk);rst_n=1;
        for(i=0;i<101;i=i+1)begin
            wait(ready);@(negedge clk);valid=1;seq=i;
            @(negedge clk);valid=0;ticks=0;
            while(!done && ticks<20000)begin @(negedge clk);ticks=ticks+1;end
            if(!done)$fatal(1,"sample timeout pc=%d state=%d",dut.pc,dut.state);
            if(i==0 || i==100)$display("sample=%d flags=%h matrix=%d,%d,%d cycles=%d",i,result[32+:32],
                $signed(result[96+:32]),$signed(result[224+:32]),$signed(result[352+:32]),ticks);
        end
        if(result[33:32]!=3 || result[3*32+:32]!=4095 || result[7*32+:32]!=4095 ||result[11*32+:32]!=4095)
            $fatal(1,"stationary calibration / matrix mismatch %h",result);
        if(overruns!=0)$fatal(1,"unexpected overrun");
        $display("TEST_PASS PL attitude smoke calibration and palm-down identity");$finish;
    end
endmodule

