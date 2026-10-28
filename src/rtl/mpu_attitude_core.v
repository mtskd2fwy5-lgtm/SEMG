`timescale 1ns/1ps
// Dedicated fixed-point quaternion datapath. One shared 32x32 multiplier,
// iterative divider/square root; ROM sequences the 100 Hz fusion equations.
// All arithmetic operands are signed Q24 except explicitly integer counters.
module mpu_attitude_core(
    input wire clk, rst_n,
    input wire sample_valid,
    input wire [6:0] sample_seq,
    input wire [31:0] motion_a, motion_b, motion_c,
    input wire sample_gap,
    output wire ready,
    output reg result_valid,
    output reg [959:0] result,
    output reg [31:0] overrun_count
);
    `include "mpu_attitude_regs.vh"
    (* rom_style="block" *) reg [63:0] rom[0:2047];
    integer init_index;
    initial begin
        for(init_index=0;init_index<2048;init_index=init_index+1)rom[init_index]=0;
        `include "mpu_attitude_rom.vh"
    end
    (* ram_style="distributed" *) reg signed [31:0] rf[0:255];
    localparam CLEAR=0,FETCH=1,READ=2,EXEC=3,MULT=4,DIV_START=5,
               DIV_WAIT=6,ROOT=7,MULT_WRITE=8;
    reg [3:0] state;
    reg [7:0] clear_addr;
    reg [10:0] pc;
    reg [63:0] instruction;
    wire [5:0] op=instruction[61:56];
    wire [7:0] dst=instruction[55:48];
    wire [7:0] ia=instruction[47:40],ib=instruction[39:32];
    wire signed [31:0] imm=instruction[31:0];
    reg signed [31:0] a,b;
    (* use_dsp="yes" *) reg signed [63:0] product;
    reg signed [31:0] multiply_value;
    wire signed [63:0] shifted_product=product >>> imm[5:0];
    function [31:0] saturate;
        input signed [63:0] v;
        begin
            if(v>64'sd2147483647)saturate=32'h7fffffff;
            else if(v< -64'sd2147483648)saturate=32'h80000000;
            else saturate=v[31:0];
        end
    endfunction
    wire signed [63:0] sum64={{32{a[31]}},a}+{{32{b[31]}},b};
    wire signed [63:0] sub64={{32{a[31]}},a}-{{32{b[31]}},b};
    reg div_start,div_negative;
    reg [63:0] div_num,div_den;
    wire div_done,div_busy;
    wire [63:0] div_q;
    learning_div64 divider(clk,rst_n,div_start,div_num,div_den,div_busy,div_done,div_q);
    wire [31:0] abs_a=a[31] ? -a : a;
    wire [31:0] abs_b=b[31] ? -b : b;
    reg [63:0] root_shift;
    reg [65:0] root_rem;
    reg [31:0] root_value;
    reg [5:0] root_left;
    wire [65:0] root_trial=(root_rem<<2)|{64'd0,root_shift[63:62]};
    wire [65:0] root_test=({34'd0,root_value}<<2)|66'd1;
    wire root_take=root_trial>=root_test;
    reg [10:0] stack[0:7];
    reg [2:0] sp;
    reg [31:0] elapsed,max_elapsed;
    reg running;
    reg [31:0] in_a,in_b,in_c;
    reg [6:0] in_seq;
    reg in_gap;
    reg [959:0] draft;
    // One explicit write port is essential: resetting / writing the array
    // through several procedural addresses prevents LUT RAM inference.
    reg rf_write;
    reg [7:0] rf_address;
    reg signed [31:0] rf_value;
    always @*begin
        rf_write=0;rf_address=dst;rf_value=0;
        case(state)
        CLEAR:begin rf_write=1;rf_address=clear_addr;end
        EXEC:begin
            rf_write=1;
            case(op)
            1:rf_value=a;
            2:rf_value=imm;
            3:rf_value=saturate(sum64);
            4:rf_value=saturate(sub64);
            8:rf_value=-a;
            9:rf_value=abs_a;
            10:rf_value=b[31] ? a<<(-b) : a>>>b;
            11:rf_value=a&b;
            12:rf_value=a|b;
            24:case(imm[3:0])
                0:rf_value={{6{in_a[31]}},in_a[31:16],10'd0};
                1:rf_value={{6{in_a[15]}},in_a[15:0],10'd0};
                2:rf_value={{6{in_b[31]}},in_b[31:16],10'd0};
                3:rf_value={{16{in_b[15]}},in_b[15:0]};
                4:rf_value={{16{in_c[31]}},in_c[31:16]};
                5:rf_value={{16{in_c[15]}},in_c[15:0]};
                6:rf_value={25'd0,in_seq};
                7:rf_value={31'd0,in_gap};
                default:rf_value=0;
                endcase
            default:rf_write=0;
            endcase
        end
        MULT_WRITE:begin rf_write=1;rf_value=multiply_value;end
        DIV_WAIT:if(div_done)begin
            rf_write=1;
            if(div_q>64'd2147483647)rf_value=div_negative ? 32'h80000000 : 32'h7fffffff;
            else rf_value=div_negative ? -div_q[31:0] : div_q[31:0];
        end
        ROOT:if(root_left==1)begin rf_write=1;rf_value={root_value[30:0],root_take};end
        default:begin end
        endcase
    end
    always @(posedge clk)if(rst_n && rf_write)rf[rf_address]<=rf_value;
    assign ready=state==EXEC && op==20;
    integer p;
    always @(posedge clk)begin
        if(!rst_n)begin
            state<=CLEAR;clear_addr<=0;pc<=IMU_START;instruction<=0;a<=0;b<=0;
            product<=0;multiply_value<=0;sp<=0;div_start<=0;div_num<=0;div_den<=0;div_negative<=0;
            root_shift<=0;root_rem<=0;root_value<=0;root_left<=0;
            result<=0;draft<=0;result_valid<=0;elapsed<=0;max_elapsed<=0;running<=0;overrun_count<=0;
            in_a<=0;in_b<=0;in_c<=0;in_seq<=0;in_gap<=0;
        end else begin
            div_start<=0;result_valid<=0;
            if(running)elapsed<=elapsed+1;
            if(sample_valid && !ready)overrun_count<=overrun_count+1;
            case(state)
            CLEAR:begin
                clear_addr<=clear_addr+1;
                if(clear_addr==255)state<=FETCH;
            end
            FETCH:begin instruction<=rom[pc];state<=READ;end
            READ:begin a<=rf[ia];b<=rf[ib];state<=EXEC;end
            EXEC:begin
                pc<=pc+1;state<=FETCH;
                case(op)
                1,2,3,4,8,9,10,11,12,24:begin end
                5:begin product<=a*b;state<=MULT;end
                6:begin
                    div_num<=imm==1 ? {32'd0,abs_a} : {8'd0,abs_a,24'd0};
                    div_den<={32'd0,abs_b};div_negative<=a[31]^b[31];state<=DIV_START;
                end
                7:begin
                    root_shift<=a[31] ? 64'd0 : {8'd0,a,24'd0};
                    root_rem<=0;root_value<=0;root_left<=32;state<=ROOT;
                end
                13:pc<=imm[10:0];
                14:if(a==b)pc<=imm[10:0];
                15:if(a!=b)pc<=imm[10:0];
                16:if(a<b)pc<=imm[10:0];
                17:if(a<=b)pc<=imm[10:0];
                18:if(a>b)pc<=imm[10:0];
                19:if(a>=b)pc<=imm[10:0];
                20:begin
                    if(sample_valid)begin
                        in_a<=motion_a;in_b<=motion_b;in_c<=motion_c;
                        in_seq<=sample_seq;in_gap<=sample_gap;
                        elapsed<=0;running<=1;
                    end else begin pc<=pc;state<=EXEC;end
                end
                21:begin
                    result_valid<=1;running<=0;
                    if(elapsed>max_elapsed)max_elapsed<=elapsed;
                    result<=draft;
                    result[26*32+:32]<=elapsed;result[27*32+:32]<=max_elapsed;
                    result[28*32+:32]<=overrun_count;
                end
                22:begin stack[sp]<=pc+1;sp<=sp+1;pc<=imm[10:0];end
                23:begin sp<=sp-1;pc<=stack[sp-1'b1];end
                25:if(imm<30)draft[imm*32+:32]<=a;
                default:begin state<=CLEAR;clear_addr<=0;running<=0;end
                endcase
            end
            // Separate product reconstruction / scaling from the shared RAM
            // write mux. The extra cycle preserves all Q24 rounding bits.
            MULT:begin multiply_value<=saturate(shifted_product);state<=MULT_WRITE;end
            MULT_WRITE:state<=FETCH;
            DIV_START:begin div_start<=1;state<=DIV_WAIT;end
            DIV_WAIT:if(div_done)begin
                state<=FETCH;
            end
            ROOT:begin
                root_shift<=root_shift<<2;
                root_rem<=root_take ? root_trial-root_test : root_trial;
                root_value<={root_value[30:0],root_take};root_left<=root_left-1;
                if(root_left==1)state<=FETCH;
            end
            default:begin state<=CLEAR;clear_addr<=0;end
            endcase
        end
    end
endmodule
