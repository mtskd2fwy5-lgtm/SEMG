`timescale 1ns/1ps
module mpu_attitude_vectors_tb;
    reg clk=0;always #5 clk=~clk;
    reg rst_n=0,valid=0,gap=0;
    reg [6:0] seq=0;
    reg [31:0] a=0,b=0,c=0;
    wire ready,done;wire [959:0] result;wire [31:0] overruns;
    mpu_attitude_core dut(clk,rst_n,valid,seq,a,b,c,gap,ready,done,result,overruns);
    integer f,rc,n=0,i,ticks,peak_cycles=0,resets=0;
    reg [31:0] gold[0:29];reg [31:0] word,gap_word;
    reg [16383:0] line;reg [31:0] tag;
    initial begin #2000000000;$fatal(1,"attitude vectors watchdog sample %d",n);end
    initial begin
        f=$fopen("report/imu_pl_20261028/imu_rtl_vectors.txt","r");
        if(!f)$fatal(1,"missing generated attitude vectors");
        repeat(5)@(negedge clk);rst_n=1;
        while(!$feof(f))begin
            rc=$fgets(line,f);tag=0;if(rc>0)rc=$sscanf(line,"%s",tag);
            if(tag=="R")begin
                @(negedge clk);rst_n=0;repeat(4)@(negedge clk);rst_n=1;resets=resets+1;
            end else if(tag=="S")begin
                rc=$sscanf(line,"S %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h",
                    a,b,c,word,gap_word,gold[0],gold[1],gold[2],gold[3],gold[4],gold[5],gold[6],gold[7],gold[8],gold[9],gold[10],gold[11],gold[12],gold[13],gold[14],gold[15],gold[16],gold[17],gold[18],gold[19],gold[20],gold[21],gold[22],gold[23],gold[24],gold[25],gold[26],gold[27],gold[28],gold[29]);
                if(rc!=35)$fatal(1,"malformed vector %d count %d",n,rc);
                wait(ready);@(negedge clk);valid=1;seq=word[30:24];gap=gap_word[0];
                @(negedge clk);valid=0;ticks=0;
                while(!done && ticks<20000)begin @(negedge clk);ticks=ticks+1;end
                if(!done)$fatal(1,"sample timeout %d",n);
                if(ticks>peak_cycles)peak_cycles=ticks;
                for(i=0;i<30;i=i+1)begin
                    if(i<26 || i==29)begin
                        if(result[i*32+:32]!==gold[i])
                            $fatal(1,"sample=%d word=%d expected=%h observed=%h",n,i,gold[i],result[i*32+:32]);
                    end
                end
                if(overruns!=0)$fatal(1,"unexpected sample overrun");
                n=n+1;
                if(n%1000==0)$display("attitude vectors %d peak_cycles %d",n,peak_cycles);
            end
        end
        $fclose(f);
        if(n<13000 || resets<30)$fatal(1,"incomplete vector replay");
        $display("TEST_PASS PL attitude bit-exact replay samples=%d resets=%d peak_cycles=%d",n,resets,peak_cycles);
        $finish;
    end
endmodule

