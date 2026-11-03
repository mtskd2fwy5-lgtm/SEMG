`timescale 1ns/1ps

// 50 Hz notch comb at fs=4000, N=80, 1 Hz -3 dB bandwidth at each tooth.
// scipy.signal.iircomb(50, 50, fs=4000), Q24 coefficients:
// y[n] = B*(x[n]-x[n-80]) + R*y[n-80], R=2*B-1.
// Eight independent Q12/40-bit feedback histories, shared multiplier.
// History RAM is NOT reset; per-channel fill counts mask unwritten entries.
module emg_comb50 (
    input wire clk, rst_n, sample_valid,
    input wire signed [23:0] sample_data,
    input wire [2:0] sample_channel,
    input wire [15:0] sample_sequence,
    output wire sample_ready,
    output reg filtered_valid,
    output reg signed [23:0] filtered_data,
    output reg [2:0] filtered_channel,
    output reg [15:0] filtered_sequence,
    output reg overrun
);
    localparam signed [25:0] B = 26'sd16266035;
    localparam signed [25:0] R = 26'sd15754854;
    localparam [2:0] IDLE=0, DIFFERENCE=1, MULT_X=2, SUM_X=3,
                     MULT_Y=4, SUM_Y=5, COMMIT=6;
    reg [2:0] state, channel_q;
    reg [6:0] position[0:7], filled[0:7];
    reg [9:0] address_q;
    reg [15:0] sequence_q;
    reg signed [23:0] x_q;
    (* ram_style = "block" *) reg [63:0] history[0:639];
    reg [63:0] history_q;
    reg history_valid_q;
    reg signed [39:0] operand;
    reg signed [65:0] product_q;
    reg signed [68:0] accumulator;
    wire [9:0] address = {sample_channel,6'b0} +
                        {sample_channel,4'b0} + position[sample_channel];
    wire signed [23:0] delayed_x = history_valid_q ? $signed(history_q[23:0]) : 24'sd0;
    wire signed [24:0] difference = $signed({x_q[23],x_q}) -
                                   $signed({delayed_x[23],delayed_x});
    wire signed [25:0] coefficient = state == MULT_Y ? R : B;
    wire signed [68:0] rounded = (accumulator + 69'sd8388608) >>> 24;
    wire signed [39:0] next_y = rounded > 69'sd549755813887 ? 40'sd549755813887 :
                              rounded < -69'sd549755813888 ? -40'sd549755813888 : rounded[39:0];
    wire signed [40:0] output_q = ($signed({next_y[39],next_y}) + 41'sd2048) >>> 12;
    integer ch;
    assign sample_ready = rst_n && state == IDLE;

    // Keep RAM accesses outside reset branches so Vivado infers block RAM.
    always @(posedge clk) begin
        if (rst_n && state == IDLE && sample_valid) history_q <= history[address];
        if (rst_n && state == COMMIT) history[address_q] <= {next_y,x_q};
    end
    always @(posedge clk) begin
        filtered_valid <= 1'b0;
        if (!rst_n) begin
            state<=IDLE; channel_q<=0; sequence_q<=0; address_q<=0;
            x_q<=0; history_valid_q<=0; operand<=0; product_q<=0; accumulator<=0;
            filtered_data<=0; filtered_channel<=0; filtered_sequence<=0; overrun<=0;
            for(ch=0;ch<8;ch=ch+1) begin position[ch]<=0; filled[ch]<=0; end
        end else begin
            if(sample_valid && !sample_ready) overrun<=1'b1;
            case(state)
                IDLE: if(sample_valid) begin
                    x_q<=sample_data; channel_q<=sample_channel;
                    sequence_q<=sample_sequence; address_q<=address;
                    history_valid_q<=filled[sample_channel]==80;
                    state<=DIFFERENCE;
                end
                DIFFERENCE: begin
                    operand <= $signed({{15{difference[24]}},difference}) <<< 12;
                    state<=MULT_X;
                end
                MULT_X: begin product_q<=operand*coefficient; state<=SUM_X; end
                SUM_X: begin
                    accumulator<=product_q;
                    operand<=history_valid_q ? $signed(history_q[63:24]) : 40'sd0;
                    state<=MULT_Y;
                end
                MULT_Y: begin product_q<=operand*coefficient; state<=SUM_Y; end
                SUM_Y: begin accumulator<=accumulator+product_q; state<=COMMIT; end
                COMMIT: begin
                    filtered_data<=output_q > 41'sd8388607 ? 24'sd8388607 :
                                   output_q < -41'sd8388608 ? -24'sd8388608 : output_q[23:0];
                    filtered_channel<=channel_q; filtered_sequence<=sequence_q;
                    filtered_valid<=1'b1;
                    position[channel_q]<=position[channel_q]==79 ? 0 : position[channel_q]+1'b1;
                    if(filled[channel_q]<80) filled[channel_q]<=filled[channel_q]+1'b1;
                    state<=IDLE;
                end
            endcase
        end
    end
endmodule

