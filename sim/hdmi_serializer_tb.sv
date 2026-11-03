`timescale 1ns/1ps
module hdmi_serializer_tb;
    reg px=0,fast=0,rst=1;
    always #5 px=~px;
    always #1 fast=~fast;
    reg[9:0]word=10'h1a9;wire p,n;
    integer fp,fs,k=0;reg[31:0]rng=32'h8ab657c3;
    hdmi_serializer dut(px,fast,rst,word,p,n);
    always @(negedge px)begin
        rng={rng[30:0],rng[31]^rng[21]^rng[1]^rng[0]};word=rng[9:0];
    end
    always @(posedge px) if(!rst) begin $fdisplay(fp,"%010b",word);k=k+1;end
    always @(fast)begin
        #0.2;
        if(!rst)begin
            if(p!==!n)$fatal(1,"differential output not complementary");
            $fwrite(fs,"%b",p);
        end
    end
    initial begin
        fp=$fopen("serializer_words.txt","w");fs=$fopen("serializer_bits.txt","w");
        repeat(7)@(negedge px);#0.5;rst=0;
        repeat(500)@(negedge px);$fclose(fp);$fclose(fs);
        $display("TEST_PASS HDMI OSERDES capture complete");$finish;
    end
endmodule
