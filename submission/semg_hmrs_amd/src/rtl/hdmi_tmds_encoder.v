`timescale 1ns/1ps
// SPDX-License-Identifier: Apache-2.0
// DVI TMDS 8b/10b encoder; symbol bit 0 is transmitted first.
module hdmi_tmds_encoder (
    input wire clk, rst, de, c0, c1,
    input wire [7:0] data,
    output reg [9:0] symbol
);
    integer i, n1, balance;
    reg [8:0] qm;
    reg signed [5:0] disparity;
    always @* begin
        n1=0;
        for (i=0;i<8;i=i+1) n1=n1+data[i];
        qm[0]=data[0];
        qm[8]=!(n1>4 || (n1==4 && !data[0]));
        for (i=1;i<8;i=i+1)
            qm[i]=qm[8] ? (qm[i-1]^data[i]) : !(qm[i-1]^data[i]);
        balance=0;
        for (i=0;i<8;i=i+1) balance=balance+(qm[i] ? 1 : -1);
    end
    always @(posedge clk) begin
        if (rst) begin symbol<=10'b1101010100; disparity<=0; end
        else if (!de) begin
            disparity<=0;
            case ({c1,c0})
                2'b00: symbol<=10'b1101010100;
                2'b01: symbol<=10'b0010101011;
                2'b10: symbol<=10'b0101010100;
                2'b11: symbol<=10'b1010101011;
            endcase
        end else if (disparity==0 || balance==0) begin
            symbol<={!qm[8],qm[8],qm[8] ? qm[7:0] : ~qm[7:0]};
            disparity<=disparity+(qm[8] ? balance : -balance);
        end else if ((disparity>0 && balance>0) || (disparity<0 && balance<0)) begin
            symbol<={1'b1,qm[8],~qm[7:0]};
            disparity<=disparity+2*qm[8]-balance;
        end else begin
            symbol<={1'b0,qm};
            disparity<=disparity-2*(!qm[8])+balance;
        end
    end
endmodule

