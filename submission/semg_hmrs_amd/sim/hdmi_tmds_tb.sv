`timescale 1ns/1ps
module hdmi_tmds_tb;
    reg clk=0; always #5 clk=~clk;
    reg rst=1,de=0,c0=0,c1=0;reg[7:0]data=0;
    wire[9:0] symbol;
    hdmi_tmds_encoder dut(clk,rst,de,c0,c1,data,symbol);
    integer rd=0,n,i,j,ones,bits,dispb;reg[8:0]q;reg[9:0]expected;
    reg[31:0]random_word=32'h879fa6b2;
    // Independent reference uses population counts and emitted-bit disparity.
    task reference;
        begin
            if(!de) begin
                case({c1,c0})
                    0:expected=10'b1101010100;1:expected=10'b0010101011;
                    2:expected=10'b0101010100;3:expected=10'b1010101011;
                endcase
                rd=0;
            end else begin
                ones=$countones(data); q[0]=data[0];
                q[8]=(ones<4 || (ones==4 && data[0]));
                for(j=1;j<8;j++) q[j]=q[j-1]^data[j]^!q[8];
                ones=$countones(q[7:0]);
                if(rd==0 || ones==4) expected={!q[8],q[8],q[8]?q[7:0]:~q[7:0]};
                else if((rd>0 && ones>4)||(rd<0&&ones<4))expected={1'b1,q[8],~q[7:0]};
                else expected={1'b0,q};
                rd=rd+2*$countones(expected)-10;
                if(rd>8||rd< -8)$fatal(1,"reference disparity escaped");
            end
        end
    endtask
    initial begin
        repeat(4)@(negedge clk);rst=0;
        for(n=0;n<100000;n++)begin
            random_word={random_word[30:0],random_word[31]^random_word[21]^random_word[1]^random_word[0]};
            data=n<65536?n[7:0]:random_word[7:0];
            de=n%1031>6;{c1,c0}=n[1:0];reference();
            @(negedge clk);
            if(symbol!==expected)$fatal(1,"TMDS symbol n=%0d got=%b expected=%b",n,symbol,expected);
        end
        $display("TEST_PASS HDMI TMDS: 100000 symbols, all byte values, control periods and running disparity");$finish;
    end
endmodule

