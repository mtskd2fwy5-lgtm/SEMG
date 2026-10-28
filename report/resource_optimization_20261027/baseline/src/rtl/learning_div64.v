`timescale 1ns/1ps
// One restoring unsigned divider shared by all accelerator divisions.
module learning_div64(input wire clk,rst_n,start,input wire [63:0] numerator,denominator,
                      output reg busy,done,output reg [63:0] quotient);
    reg [63:0] rem,den,q;
    reg [6:0] left;
    wire [64:0] trial={rem,q[63]};
    always @(posedge clk) begin
        if(!rst_n)begin busy<=0;done<=0;quotient<=0;rem<=0;den<=0;q<=0;left<=0;end
        else begin
            done<=0;
            if(start && !busy)begin
                rem<=0;q<=numerator;den<=denominator;left<=64;busy<=1;
            end else if(busy)begin
                rem<=trial>={1'b0,den}?trial-{1'b0,den}:trial;
                q<={q[62:0],trial>={1'b0,den}};
                left<=left-1;
                if(left==1)begin
                    quotient<=den==0?64'hffffffffffffffff:{q[62:0],trial>={1'b0,den}};
                    busy<=0;done<=1;
                end
            end
        end
    end
endmodule
