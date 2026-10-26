`timescale 1ns/1ps
module axis_async_fifo_tb;
    reg sc=0,mc=0;always #7 sc=~sc;always #5 mc=~mc;
    reg sr=0,mr=0,sv=0,mready=0;wire ready,valid;wire [63:0] data;
    reg [63:0] sd=0;integer sent=0,received=0,cycle=0;
    reg [31:0] rand_s=32'h12345678,rand_m=32'h98765432;
    reg random_mode=0;reg [63:0] last_data;reg last_stalled=0;
    axis_async_fifo #(.ADDR_WIDTH(12)) dut(sc,sr,sv,ready,sd,mc,mr,valid,mready,data);
    always @(negedge sc)begin
        rand_s={rand_s[30:0],rand_s[31]^rand_s[21]^rand_s[1]^rand_s[0]};
        if(random_mode)begin sv=rand_s[0]|rand_s[3];sd=sent;end
    end
    always @(posedge sc)if(sr && sv && ready)sent=sent+1;
    always @(negedge mc)begin
        rand_m={rand_m[30:0],rand_m[31]^rand_m[21]^rand_m[1]^rand_m[0]};
        if(random_mode)mready=rand_m[1]|rand_m[4];
    end
    always @(posedge mc)if(mr)begin
        if(last_stalled && (!valid || data!==last_data))$fatal(1,"stalled data changed");
        last_stalled=valid && !mready;last_data=data;
        if(valid && mready)begin if(data!==received)$fatal(1,"FIFO order got%d expected%d",data,received);received=received+1;end
    end else last_stalled=0;
    integer i;
    task reset_both;
        begin
            sr=0;mr=0;sv=0;mready=0;random_mode=0;
            repeat(10)@(negedge sc);sent=0;received=0;sd=0;
            sr=1;mr=1;repeat(10)@(negedge sc);
        end
    endtask
    initial begin
        reset_both();
        sv=1;
        for(i=0;i<4096;i=i+1)begin sd=i;@(negedge sc);end
        sv=0;repeat(10)@(negedge sc);
        if(ready || sent!=4096)$fatal(1,"capacity changed sent%0d ready%0d",sent,ready);
        $display("TEST_PASS BRAM FIFO exact4096 capacity");
        mready=1;wait(received==4096);repeat(10)@(negedge mc);
        if(valid)$fatal(1,"FIFO not empty after drain");
        $display("TEST_PASS BRAM FIFO full drain no loss duplication");
        reset_both();random_mode=1;
        wait(sent>=30000);@(negedge sc);random_mode=0;sv=0;mready=1;
        wait(received==sent);repeat(10)@(negedge mc);
        if(valid)$fatal(1,"FIFO random final extra");
        $display("TEST_PASS BRAM FIFO asynchronous wrap backpressure stable output");
        reset_both();random_mode=1;wait(sent>=2000);@(negedge sc);reset_both();
        random_mode=1;wait(sent>=5000);@(negedge sc);random_mode=0;sv=0;mready=1;
        wait(received==sent);repeat(10)@(negedge mc);
        $display("TEST_PASS BRAM FIFO coordinated reset during traffic");$finish;
    end
    initial begin #10000000;$fatal(1,"FIFO watchdog sent%0d recv%0d",sent,received);end
endmodule
