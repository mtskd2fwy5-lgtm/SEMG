`timescale 1ns/1ps

// ADS1299 SPI controller for continuous multi-channel acquisition.
//
// Default configuration:
//   CONFIG1 = 0x94 : high-resolution, 4 kSPS
//   CONFIG2 = 0xD0 : test source disabled
//   CONFIG3 = 0xEC : internal reference and bias circuitry enabled
//   CHnSET  = 0x60 : normal input, PGA gain 24, channel powered on
//
// Register values are parameters so the final EMG front-end can choose a
// different gain or data rate without changing the controller structure.
module ads1299_spi #(
    parameter integer CLK_FREQ_HZ = 25_000_000,
    parameter integer SCLK_FREQ_HZ = 1_250_000,
    parameter integer CHANNELS = 8,
    parameter integer DATA_BITS = 24,
    parameter integer CHANNEL_BITS = (CHANNELS <= 1) ? 1 : $clog2(CHANNELS),
    parameter integer RESET_CYCLES = 100_000,
    parameter integer POST_RESET_CYCLES = 100_000,
    parameter integer COMMAND_GAP_CYCLES = 250,
    parameter [7:0] CONFIG1_VALUE = 8'h94,  /* 0x90 base | DR=100 = 4 kSPS */
    parameter [7:0] CONFIG2_VALUE = 8'hD0,
    parameter [7:0] CONFIG3_VALUE = 8'hEC,
    parameter [7:0] LOFF_VALUE = 8'h00,
    parameter [7:0] CHANNEL_VALUE = 8'h60
) (
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         start,
    input  wire                         adc_drdy_n,
    input  wire                         adc_dout,
    output reg                          adc_sclk,
    output reg                          adc_din,
    output reg                          adc_cs_n,
    output reg                          adc_reset_n,
    output reg                          adc_start,
    output reg                          adc_pwdn_n,
    output reg                          sample_valid,
    output reg signed [DATA_BITS-1:0]   sample_data,
    output reg [CHANNEL_BITS-1:0]       sample_channel,
    output reg                          frame_valid,
    output reg                          busy,
    output reg                          error
);

    localparam integer HALF_SCLK_CYCLES = (CLK_FREQ_HZ / (2 * SCLK_FREQ_HZ) < 1) ?
                                          1 : CLK_FREQ_HZ / (2 * SCLK_FREQ_HZ);
    localparam integer FRAME_BITS = 24 + DATA_BITS * CHANNELS;
    localparam integer CONFIG_REG_COUNT = 4 + CHANNELS;
    localparam integer CONFIG_LAST_BYTE = 1 + CONFIG_REG_COUNT;

    localparam [4:0] ST_RESET_HOLD = 5'd0;
    localparam [4:0] ST_POST_RESET = 5'd1;
    localparam [4:0] ST_SDATAC_START = 5'd2;
    localparam [4:0] ST_SDATAC_BITS = 5'd3;
    localparam [4:0] ST_SDATAC_GAP = 5'd4;
    localparam [4:0] ST_CONFIG_START = 5'd5;
    localparam [4:0] ST_CONFIG_BITS = 5'd6;
    localparam [4:0] ST_CONFIG_GAP = 5'd7;
    localparam [4:0] ST_RDATAC_START = 5'd8;
    localparam [4:0] ST_RDATAC_BITS = 5'd9;
    localparam [4:0] ST_RDATAC_GAP = 5'd10;
    localparam [4:0] ST_START_START = 5'd11;
    localparam [4:0] ST_START_BITS = 5'd12;
    localparam [4:0] ST_START_GAP = 5'd13;
    localparam [4:0] ST_WAIT_DRDY = 5'd14;
    localparam [4:0] ST_READ_BITS = 5'd15;

    reg [4:0] state;
    reg [31:0] delay_count;
    reg [31:0] sclk_count;
    reg [7:0] tx_shift;
    reg [3:0] tx_bit_count;
    reg [4:0] config_byte_index;
    reg [8:0] frame_bit_count;
    reg [5:0] channel_bit_count;
    reg [CHANNEL_BITS-1:0] channel_count;
    reg [DATA_BITS-1:0] rx_shift;
    reg drdy_meta;
    reg drdy_sync;
    reg drdy_prev;

    wire drdy_falling = drdy_prev && !drdy_sync;

    function [7:0] config_data;
        input [3:0] index;
        begin
            case (index)
                4'd0: config_data = CONFIG1_VALUE;
                4'd1: config_data = CONFIG2_VALUE;
                4'd2: config_data = CONFIG3_VALUE;
                4'd3: config_data = LOFF_VALUE;
                default: config_data = CHANNEL_VALUE;
            endcase
        end
    endfunction

    function [7:0] config_tx_byte;
        input [4:0] index;
        begin
            case (index)
                5'd0: config_tx_byte = 8'h41;
                5'd1: config_tx_byte = CONFIG_REG_COUNT - 1;
                default: config_tx_byte = config_data(index - 5'd2);
            endcase
        end
    endfunction

    always @(posedge clk) begin
        sample_valid <= 1'b0;
        frame_valid <= 1'b0;

        if (!rst_n) begin
            state <= ST_RESET_HOLD;
            delay_count <= RESET_CYCLES;
            sclk_count <= 32'd0;
            tx_shift <= 8'd0;
            tx_bit_count <= 4'd0;
            config_byte_index <= 5'd0;
            frame_bit_count <= 9'd0;
            channel_bit_count <= 6'd0;
            channel_count <= {CHANNEL_BITS{1'b0}};
            rx_shift <= {DATA_BITS{1'b0}};
            adc_sclk <= 1'b0;
            adc_din <= 1'b0;
            adc_cs_n <= 1'b1;
            adc_reset_n <= 1'b0;
            adc_start <= 1'b0;
            adc_pwdn_n <= 1'b1;
            sample_data <= {DATA_BITS{1'b0}};
            sample_channel <= {CHANNEL_BITS{1'b0}};
            busy <= 1'b1;
            error <= 1'b0;
            drdy_meta <= 1'b1;
            drdy_sync <= 1'b1;
            drdy_prev <= 1'b1;
        end else begin
            drdy_meta <= adc_drdy_n;
            drdy_sync <= drdy_meta;
            drdy_prev <= drdy_sync;
            case (state)
                ST_RESET_HOLD: begin
                    busy <= 1'b1;
                    adc_reset_n <= 1'b0;
                    adc_cs_n <= 1'b1;
                    adc_sclk <= 1'b0;
                    if (delay_count == 0) begin
                        adc_reset_n <= 1'b1;
                        delay_count <= POST_RESET_CYCLES;
                        state <= ST_POST_RESET;
                    end else begin
                        delay_count <= delay_count - 1'b1;
                    end
                end

                ST_POST_RESET: begin
                    if ((delay_count == 0) && start)
                        state <= ST_SDATAC_START;
                    else if (delay_count != 0)
                        delay_count <= delay_count - 1'b1;
                end

                ST_SDATAC_START: begin
                    adc_cs_n <= 1'b0;
                    adc_sclk <= 1'b0;
                    tx_shift <= 8'h11;
                    tx_bit_count <= 4'd0;
                    adc_din <= 1'b0;
                    state <= ST_SDATAC_BITS;
                end

                ST_SDATAC_BITS: begin
                    if (sclk_count == HALF_SCLK_CYCLES-1) begin
                        sclk_count <= 32'd0;
                        if (!adc_sclk) begin
                            adc_sclk <= 1'b1;
                        end else begin
                            adc_sclk <= 1'b0;
                            if (tx_bit_count == 4'd7) begin
                                adc_cs_n <= 1'b1;
                                delay_count <= COMMAND_GAP_CYCLES;
                                state <= ST_SDATAC_GAP;
                            end else begin
                                tx_bit_count <= tx_bit_count + 1'b1;
                                tx_shift <= {tx_shift[6:0], 1'b0};
                                adc_din <= tx_shift[6];
                            end
                        end
                    end else begin
                        sclk_count <= sclk_count + 1'b1;
                    end
                end

                ST_SDATAC_GAP: begin
                    if (delay_count == 0)
                        state <= ST_CONFIG_START;
                    else
                        delay_count <= delay_count - 1'b1;
                end

                ST_CONFIG_START: begin
                    adc_cs_n <= 1'b0;
                    adc_sclk <= 1'b0;
                    config_byte_index <= 5'd0;
                    tx_shift <= config_tx_byte(5'd0);
                    tx_bit_count <= 4'd0;
                    adc_din <= config_tx_byte(5'd0) >> 7;
                    state <= ST_CONFIG_BITS;
                end

                ST_CONFIG_BITS: begin
                    if (sclk_count == HALF_SCLK_CYCLES-1) begin
                        sclk_count <= 32'd0;
                        if (!adc_sclk) begin
                            adc_sclk <= 1'b1;
                        end else begin
                            adc_sclk <= 1'b0;
                            if (tx_bit_count == 4'd7) begin
                                delay_count <= COMMAND_GAP_CYCLES;
                                state <= ST_CONFIG_GAP;
                            end else begin
                                tx_bit_count <= tx_bit_count + 1'b1;
                                tx_shift <= {tx_shift[6:0], 1'b0};
                                adc_din <= tx_shift[6];
                            end
                        end
                    end else begin
                        sclk_count <= sclk_count + 1'b1;
                    end
                end

                ST_CONFIG_GAP: begin
                    if (delay_count == 0) begin
                        if (config_byte_index == CONFIG_LAST_BYTE) begin
                            adc_cs_n <= 1'b1;
                            state <= ST_RDATAC_START;
                        end else begin
                            config_byte_index <= config_byte_index + 1'b1;
                            tx_shift <= config_tx_byte(config_byte_index + 1'b1);
                            tx_bit_count <= 4'd0;
                            adc_din <= config_tx_byte(config_byte_index + 1'b1) >> 7;
                            state <= ST_CONFIG_BITS;
                        end
                    end else begin
                        delay_count <= delay_count - 1'b1;
                    end
                end

                ST_RDATAC_START: begin
                    adc_cs_n <= 1'b0;
                    adc_sclk <= 1'b0;
                    tx_shift <= 8'h10;
                    tx_bit_count <= 4'd0;
                    adc_din <= 1'b0;
                    state <= ST_RDATAC_BITS;
                end

                ST_RDATAC_BITS: begin
                    if (sclk_count == HALF_SCLK_CYCLES-1) begin
                        sclk_count <= 32'd0;
                        if (!adc_sclk) begin
                            adc_sclk <= 1'b1;
                        end else begin
                            adc_sclk <= 1'b0;
                            if (tx_bit_count == 4'd7) begin
                                adc_cs_n <= 1'b1;
                                delay_count <= COMMAND_GAP_CYCLES;
                                state <= ST_RDATAC_GAP;
                            end else begin
                                tx_bit_count <= tx_bit_count + 1'b1;
                                tx_shift <= {tx_shift[6:0], 1'b0};
                                adc_din <= tx_shift[6];
                            end
                        end
                    end else begin
                        sclk_count <= sclk_count + 1'b1;
                    end
                end

                ST_RDATAC_GAP: begin
                    if (delay_count == 0)
                        state <= ST_START_START;
                    else
                        delay_count <= delay_count - 1'b1;
                end

                ST_START_START: begin
                    adc_cs_n <= 1'b0;
                    adc_sclk <= 1'b0;
                    tx_shift <= 8'h08;
                    tx_bit_count <= 4'd0;
                    adc_din <= 1'b0;
                    state <= ST_START_BITS;
                end

                ST_START_BITS: begin
                    if (sclk_count == HALF_SCLK_CYCLES-1) begin
                        sclk_count <= 32'd0;
                        if (!adc_sclk) begin
                            adc_sclk <= 1'b1;
                        end else begin
                            adc_sclk <= 1'b0;
                            if (tx_bit_count == 4'd7) begin
                                adc_cs_n <= 1'b1;
                                delay_count <= COMMAND_GAP_CYCLES;
                                state <= ST_START_GAP;
                            end else begin
                                tx_bit_count <= tx_bit_count + 1'b1;
                                tx_shift <= {tx_shift[6:0], 1'b0};
                                adc_din <= tx_shift[6];
                            end
                        end
                    end else begin
                        sclk_count <= sclk_count + 1'b1;
                    end
                end

                ST_START_GAP: begin
                    if (delay_count == 0) begin
                        adc_start <= 1'b1;
                        busy <= 1'b0;
                        state <= ST_WAIT_DRDY;
                    end else begin
                        delay_count <= delay_count - 1'b1;
                    end
                end

                ST_WAIT_DRDY: begin
                    busy <= 1'b0;
                    adc_cs_n <= 1'b1;
                    adc_sclk <= 1'b0;
                    if (drdy_falling) begin
                        busy <= 1'b1;
                        adc_cs_n <= 1'b0;
                        frame_bit_count <= 9'd0;
                        channel_bit_count <= 6'd0;
                        channel_count <= {CHANNEL_BITS{1'b0}};
                        rx_shift <= {DATA_BITS{1'b0}};
                        state <= ST_READ_BITS;
                    end
                end

                ST_READ_BITS: begin
                    busy <= 1'b1;
                    if (sclk_count == HALF_SCLK_CYCLES-1) begin
                        sclk_count <= 32'd0;
                        if (!adc_sclk) begin
                            adc_sclk <= 1'b1;
                            rx_shift <= {rx_shift[DATA_BITS-2:0], adc_dout};
                            if (frame_bit_count >= 9'd24) begin
                                if (channel_bit_count == DATA_BITS-1) begin
                                    sample_data <= {rx_shift[DATA_BITS-2:0], adc_dout};
                                    sample_channel <= channel_count;
                                    sample_valid <= 1'b1;
                                    channel_bit_count <= 6'd0;
                                    if (channel_count == CHANNELS-1) begin
                                        frame_valid <= 1'b1;
                                        adc_cs_n <= 1'b1;
                                        adc_sclk <= 1'b0;
                                        busy <= 1'b0;
                                        state <= ST_WAIT_DRDY;
                                    end else begin
                                        channel_count <= channel_count + 1'b1;
                                    end
                                end else begin
                                    channel_bit_count <= channel_bit_count + 1'b1;
                                end
                            end
                            if (frame_bit_count != FRAME_BITS-1)
                                frame_bit_count <= frame_bit_count + 1'b1;
                        end else begin
                            adc_sclk <= 1'b0;
                        end
                    end else begin
                        sclk_count <= sclk_count + 1'b1;
                    end
                end

                default: begin
                    error <= 1'b1;
                    state <= ST_RESET_HOLD;
                    delay_count <= RESET_CYCLES;
                end
            endcase
        end
    end
endmodule
