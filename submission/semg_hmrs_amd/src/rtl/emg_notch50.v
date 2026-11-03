`timescale 1ns/1ps

// Eight independent 50 Hz biquads, fs=4000 Hz, Q=10 (5 Hz -3 dB width).
// A shared registered multiplier processes one beat in 12 clocks. The
// ADS1299 SPI controller spaces channel beats by much more than this.
// There is no input backpressure: a beat while !sample_ready sets overrun.
// Coefficients are Q24; feedback retains 12 fractional and 4 guard bits.
// Only the exported 24-bit result saturates at ADC full scale, so clipping
// a transient does not feed a clipped state back into this stable filter.
// See tools/emg_reference.py:Notch50 for the bit-exact arithmetic contract.
module emg_notch50 (
    input wire clk,
    input wire rst_n,
    input wire sample_valid,
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
    // scipy.signal.iirnotch(50, 10, fs=4000), rounded to Q24.
    // A2=2*B0-2^24 and A1=B1 preserve unity DC gain exactly.
    localparam signed [25:0] B0 = 26'sd16711589;
    localparam signed [25:0] B1 = -26'sd33320146;
    localparam signed [25:0] NEG_A1 = 26'sd33320146;
    localparam signed [25:0] NEG_A2 = -26'sd16645962;
    localparam [1:0] IDLE=0, MULTIPLY=1, ACCUMULATE=2, COMMIT=3;
    reg [1:0] state;
    reg [2:0] term, channel_q;
    reg [15:0] sequence_q;
    reg signed [39:0] x_q;
    reg signed [39:0] x1 [0:7], x2 [0:7], y1 [0:7], y2 [0:7];
    reg signed [39:0] operand;
    reg signed [25:0] coefficient;
    reg signed [65:0] product_q;
    reg signed [68:0] accumulator;
    integer ch;

    assign sample_ready = state == IDLE;
    always @* begin
        operand = x_q;
        coefficient = B0;
        case (term)
            3'd1: begin operand=x1[channel_q]; coefficient=B1; end
            3'd2: begin operand=x2[channel_q]; coefficient=B0; end
            3'd3: begin operand=y1[channel_q]; coefficient=NEG_A1; end
            3'd4: begin operand=y2[channel_q]; coefficient=NEG_A2; end
            default: begin operand=x_q; coefficient=B0; end
        endcase
    end

    wire signed [68:0] rounded_state = (accumulator + 69'sd8388608) >>> 24;
    wire signed [39:0] next_y = rounded_state > 69'sd549755813887
                            ? 40'sd549755813887
                            : rounded_state < -69'sd549755813888
                            ? -40'sd549755813888 : rounded_state[39:0];
    wire signed [40:0] rounded_output =
        ($signed({next_y[39], next_y}) + 41'sd2048) >>> 12;

    always @(posedge clk) begin
        filtered_valid <= 1'b0;
        if (!rst_n) begin
            state <= IDLE;
            term <= 0;
            channel_q <= 0;
            sequence_q <= 0;
            x_q <= 0;
            product_q <= 0;
            accumulator <= 0;
            filtered_data <= 0;
            filtered_channel <= 0;
            filtered_sequence <= 0;
            overrun <= 0;
            for (ch=0; ch<8; ch=ch+1) begin
                x1[ch]<=0; x2[ch]<=0; y1[ch]<=0; y2[ch]<=0;
            end
        end else begin
            if (sample_valid && !sample_ready) overrun <= 1'b1;
            case (state)
                IDLE: if (sample_valid) begin
                    x_q <= $signed({{16{sample_data[23]}},sample_data}) <<< 12;
                    channel_q <= sample_channel;
                    sequence_q <= sample_sequence;
                    accumulator <= 0;
                    term <= 0;
                    state <= MULTIPLY;
                end
                MULTIPLY: begin
                    product_q <= operand * coefficient;
                    state <= ACCUMULATE;
                end
                ACCUMULATE: begin
                    accumulator <= accumulator + product_q;
                    if (term == 4) state <= COMMIT;
                    else begin term <= term + 1'b1; state <= MULTIPLY; end
                end
                COMMIT: begin
                    x2[channel_q] <= x1[channel_q];
                    x1[channel_q] <= x_q;
                    y2[channel_q] <= y1[channel_q];
                    y1[channel_q] <= next_y;
                    filtered_data <= rounded_output > 41'sd8388607 ? 24'sd8388607
                                   : rounded_output < -41'sd8388608 ? -24'sd8388608
                                   : rounded_output[23:0];
                    filtered_channel <= channel_q;
                    filtered_sequence <= sequence_q;
                    filtered_valid <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule

