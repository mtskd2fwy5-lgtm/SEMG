`timescale 1ns/1ps
// Behavioral requirements: deliberate independent MDF traces, not an FFT
// golden-model comparison. Each beat represents one completed 512 ms window.
module tb_emg_fatigue_state;
    reg clk=0; always #5 clk=~clk;
    reg rst_n=0,valid=0,active=0;
    reg [2:0] cls=0;
    reg [15:0] mdf=0;
    wire [1:0] level,fast_level;
    wire ready,fast_ready;
    emg_fatigue_state dut(.clk(clk),.rst_n(rst_n),.window_valid(valid),
        .activity_ok(active),.activity_class(cls),.mdf(mdf),.level(level),.ready(ready));
    emg_fatigue_state #(.LEVEL_CONFIRM_WINDOWS(1)) fast(
        .clk(clk),.rst_n(rst_n),.window_valid(valid),.activity_ok(active),
        .activity_class(cls),.mdf(mdf),.level(fast_level),.ready(fast_ready));
    integer i,checks=0;
    task beat(input bit a,input integer c,input integer f);
        begin
            @(negedge clk);active=a;cls=c;mdf=f;valid=1;
            @(negedge clk);valid=0;checks=checks+1;
        end
    endtask
    task quiet_check;
        if(level!=0 || ready || fast_level!=0 || fast_ready)
            $fatal(1,"quiet/invalid input inherited fatigue: level=%d ready=%b",level,ready);
    endtask
    initial begin
        repeat(3)@(negedge clk);rst_n=1;
        // A strong descending noise spectrum with the activity gate CLOSED.
        for(i=0;i<50;i=i+1)begin beat(0,1,200-i*3);quiet_check();end
        // Stable force with small frequency fluctuation is not fatigue.
        for(i=0;i<40;i=i+1)begin
            beat(1,1,100+(i%5)-2);
            if(level!=0)$fatal(1,"stable contraction falsely escalated");
        end
        if(!ready)$fatal(1,"missing ready after sustained contraction");
        // An isolated frequency dip is rejected by smoothing/confirmation.
        beat(1,1,50);
        for(i=0;i<8;i=i+1)beat(1,1,100);
        if(level!=0)$fatal(1,"one-window frequency dip falsely latched");
        // Sustained relative MDF drop is confirmed, even when its slope
        // eventually becomes zero. Both default and one-window confirmation.
        for(i=0;i<9;i=i+1)beat(1,1,65);
        if(level!=3 || fast_level!=3)$fatal(1,"sustained 35%% decrease not detected");
        for(i=0;i<32;i=i+1)begin
            beat(1,1,65+(i%3)-1);
            if(level!=3)$fatal(1,"plateau downgraded despite uninterrupted contraction");
        end
        // A different gesture has a different spectrum, not instant fatigue.
        beat(1,2,50);
        if(level!=0 || ready)$fatal(1,"gesture change retained prior baseline");
        for(i=0;i<22;i=i+1)beat(1,2,50);
        if(level!=0 || !ready)$fatal(1,"new gesture reference incorrect");
        beat(0,2,30);quiet_check();
        // Invalid spectrum and calibration/reset also clear stale state.
        beat(1,2,0);quiet_check();
        beat(1,2,231);quiet_check();
        beat(1,0,100);quiet_check();
        for(i=0;i<20;i=i+1)beat(1,1,100);
        rst_n=0;@(negedge clk);quiet_check();rst_n=1;
        $display("TEST_PASS fatigue state %0d windows: rest, stable, transient dip, plateau, class/reset/invalid",checks);
        $finish;
    end
    initial begin #1000000;$fatal(1,"fatigue state watchdog");end
endmodule
