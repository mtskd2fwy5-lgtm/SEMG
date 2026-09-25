`timescale 1ns/1ps

// ADS1299 SPI controller for continuous multi-channel acquisition.
//
// Default configuration:
//   CONFIG1 = 0x92 : high-resolution, 4 kSPS
//   CONFIG2 = 0xD5 : internal calibration signal enabled for bring-up;
//            use 0xC0 (INT_CAL=0) to disable it during real acquisition
//   CONFIG3 = 0xEC : internal reference and bias circuitry enabled
//   CHnSET  = 0x65 : internal test input, PGA gain 24, powered on
//            use 0x60 (normal input) for real electrode acquisition
//
// Register values are parameters so the final EMG front-end can choose a
// different gain or data rate without changing the controller structure.
//
// Reconfiguration button (reconfig_n, active low, board PL_KEY0 with 4K7
// pull-up): a debounced press replays the full SDATAC/WREG/RDATAC/START
// command sequence from ST_WAIT_DRDY and drops adc_start while it runs, so
// DRDY pauses for the burst duration and resumes afterwards.  Board-level
// debug aid: lets a scope trigger repeatedly on the DIN bursts and shows a
// DRDY period change (4 ms -> 250 us) the moment the commands actually get
// through to the chip.
module ads1299_spi #(
    parameter integer CLK_FREQ_HZ = 25_000_000,
    parameter integer SCLK_FREQ_HZ = 1_250_000,
    parameter integer CHANNELS = 8,
    parameter integer DATA_BITS = 24,
    parameter integer CHANNEL_BITS = (CHANNELS <= 1) ? 1 : $clog2(CHANNELS),
    parameter integer RESET_CYCLES = 100_000,
    parameter integer POST_RESET_CYCLES = 100_000,
    parameter integer COMMAND_GAP_CYCLES = 250,
    parameter integer BTN_DEBOUNCE_CYCLES = 500_000,  /* 20 ms @ 25 MHz */
    parameter [7:0] CONFIG1_VALUE = 8'h92,  /* reserved bits=1,10; DR=010 (4 kSPS), CLK_EN=0 */
    // 0xD5 enables the internal calibration signal; CAL_FREQ=01 selects
    // fCLK/2^20. Use 0xC0 (INT_CAL=0) to disable it for real EMG.
    parameter [7:0] CONFIG2_VALUE = 8'hD5,
    parameter [7:0] CONFIG3_VALUE = 8'hEC,
    parameter [7:0] LOFF_VALUE = 8'h00,
    // 0x65 = PD=0, GAIN=110 (24x), MUX=101 (internal test signal).
    // MUX=110 (0x66) selects BIAS_DRP, not the calibration signal.
    // Use 0x60 (MUX=000, normal electrode input) for real EMG.
    parameter [7:0] CHANNEL_VALUE = 8'h65
) (
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         start,
    input  wire                         reconfig_n,
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
    // CS is raised one COMMAND_GAP after the last SCLK falling edge, not on
    // the same edge: latching the final DIN bit and deasserting CS in the
    // same instant races on the chip side too.
    localparam [4:0] ST_SDATAC_CS_HIGH = 5'd16;
    localparam [4:0] ST_RDATAC_CS_HIGH = 5'd17;
    localparam [4:0] ST_START_CS_HIGH = 5'd18;
    localparam [4:0] ST_CONFIG_CS_HIGH = 5'd19;
    localparam [4:0] ST_READ_CS_HIGH = 5'd20;

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

    // Reconfig button synchronizer + debounce (single driver of reconfig_edge;
    // reconfig_pend is owned by the FSM block below to keep one-driver-per-sig).
    reg        reconfig_meta;
    reg        reconfig_sync;
    reg        reconfig_lvl;
    reg [31:0] reconfig_cnt;
    reg        reconfig_edge;
    reg        reconfig_pend;

    wire drdy_falling = drdy_prev && !drdy_sync;

    always @(posedge clk) begin
        if (!rst_n) begin
            reconfig_meta <= 1'b1;
            reconfig_sync <= 1'b1;
            reconfig_lvl  <= 1'b1;
            reconfig_cnt  <= 32'd0;
            reconfig_edge <= 1'b0;
        end else begin
            reconfig_edge <= 1'b0;
            reconfig_meta <= reconfig_n;
            reconfig_sync <= reconfig_meta;
            if (reconfig_sync == reconfig_lvl) begin
                reconfig_cnt <= 32'd0;
            end else if (reconfig_cnt == BTN_DEBOUNCE_CYCLES - 1) begin
                reconfig_lvl  <= reconfig_sync;
                reconfig_edge <= reconfig_lvl && !reconfig_sync;  /* press */
                reconfig_cnt  <= 32'd0;
            end else begin
                reconfig_cnt <= reconfig_cnt + 32'd1;
            end
        end
    end

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
                5'd0: config_tx_byte = 8'h41;  /* WREG (010r rrrr) @ CONFIG1 = addr 01h */
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
            reconfig_pend <= 1'b0;
        end else begin
            drdy_meta <= adc_drdy_n;
            drdy_sync <= drdy_meta;
            drdy_prev <= drdy_sync;
            if (reconfig_edge)
                reconfig_pend <= 1'b1;
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
                            // Place the bit on the rising edge: the chip
                            // latches DIN on the falling edge, so switching
                            // DIN there races the latch (observed on board as
                            // a one-bit-shifted, silently-dropped command).
                            // tx_shift has been shifted (k-1) times by R(k),
                            // so [7] is bit k of the byte.
                            adc_din <= tx_shift[7];
                        end else begin
                            adc_sclk <= 1'b0;
                            if (tx_bit_count == 4'd7) begin
                                delay_count <= COMMAND_GAP_CYCLES;
                                state <= ST_SDATAC_GAP;
                            end else begin
                                tx_bit_count <= tx_bit_count + 1'b1;
                                tx_shift <= {tx_shift[6:0], 1'b0};
                            end
                        end
                    end else begin
                        sclk_count <= sclk_count + 1'b1;
                    end
                end

                ST_SDATAC_GAP: begin
                    if (delay_count == 0) begin
                        adc_cs_n <= 1'b1;
                        delay_count <= COMMAND_GAP_CYCLES;
                        state <= ST_SDATAC_CS_HIGH;
                    end else begin
                        delay_count <= delay_count - 1'b1;
                    end
                end

                ST_SDATAC_CS_HIGH: begin
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
                            adc_din <= tx_shift[7];  /* place at rising edge, [7]=bit k after k-1 shifts */
                        end else begin
                            adc_sclk <= 1'b0;
                            if (tx_bit_count == 4'd7) begin
                                delay_count <= COMMAND_GAP_CYCLES;
                                state <= ST_CONFIG_GAP;
                            end else begin
                                tx_bit_count <= tx_bit_count + 1'b1;
                                tx_shift <= {tx_shift[6:0], 1'b0};
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
                            delay_count <= COMMAND_GAP_CYCLES;
                            state <= ST_CONFIG_CS_HIGH;
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

                ST_CONFIG_CS_HIGH: begin
                    if (delay_count == 0)
                        state <= ST_RDATAC_START;
                    else
                        delay_count <= delay_count - 1'b1;
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
                            adc_din <= tx_shift[7];  /* place at rising edge, [7]=bit k after k-1 shifts */
                        end else begin
                            adc_sclk <= 1'b0;
                            if (tx_bit_count == 4'd7) begin
                                delay_count <= COMMAND_GAP_CYCLES;
                                state <= ST_RDATAC_GAP;
                            end else begin
                                tx_bit_count <= tx_bit_count + 1'b1;
                                tx_shift <= {tx_shift[6:0], 1'b0};
                            end
                        end
                    end else begin
                        sclk_count <= sclk_count + 1'b1;
                    end
                end

                ST_RDATAC_GAP: begin
                    if (delay_count == 0) begin
                        adc_cs_n <= 1'b1;
                        delay_count <= COMMAND_GAP_CYCLES;
                        state <= ST_RDATAC_CS_HIGH;
                    end else begin
                        delay_count <= delay_count - 1'b1;
                    end
                end

                ST_RDATAC_CS_HIGH: begin
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
                            adc_din <= tx_shift[7];  /* place at rising edge, [7]=bit k after k-1 shifts */
                        end else begin
                            adc_sclk <= 1'b0;
                            if (tx_bit_count == 4'd7) begin
                                delay_count <= COMMAND_GAP_CYCLES;
                                state <= ST_START_GAP;
                            end else begin
                                tx_bit_count <= tx_bit_count + 1'b1;
                                tx_shift <= {tx_shift[6:0], 1'b0};
                            end
                        end
                    end else begin
                        sclk_count <= sclk_count + 1'b1;
                    end
                end

                ST_START_GAP: begin
                    if (delay_count == 0) begin
                        adc_cs_n <= 1'b1;
                        delay_count <= COMMAND_GAP_CYCLES;
                        state <= ST_START_CS_HIGH;
                    end else begin
                        delay_count <= delay_count - 1'b1;
                    end
                end

                ST_START_CS_HIGH: begin
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
                    if (reconfig_pend) begin
                        // Button-press replay of the whole command sequence.
                        // Dropping adc_start pauses conversions, so DRDY
                        // freezes for the burst and resumes on ST_START_GAP.
                        reconfig_pend <= 1'b0;
                        busy <= 1'b1;
                        adc_start <= 1'b0;
                        state <= ST_SDATAC_START;
                    end else if (drdy_falling) begin
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
                            // ADS1299 shifts DOUT out after SCLK rises;
                            // sample it on the following falling edge.
                        end else begin
                            adc_sclk <= 1'b0;
                            rx_shift <= {rx_shift[DATA_BITS-2:0], adc_dout};
                            if (frame_bit_count >= 9'd24) begin
                                if (channel_bit_count == DATA_BITS-1) begin
                                    sample_data <= {rx_shift[DATA_BITS-2:0], adc_dout};
                                    sample_channel <= channel_count;
                                    sample_valid <= 1'b1;
                                    channel_bit_count <= 6'd0;
                                    if (channel_count == CHANNELS-1) begin
                                        frame_valid <= 1'b1;
                                        delay_count <= COMMAND_GAP_CYCLES;
                                        state <= ST_READ_CS_HIGH;
                                    end else begin
                                        channel_count <= channel_count + 1'b1;
                                    end
                                end else begin
                                    channel_bit_count <= channel_bit_count + 1'b1;
                                end
                            end
                            if (frame_bit_count != FRAME_BITS-1)
                                frame_bit_count <= frame_bit_count + 1'b1;
                        end
                    end else begin
                        sclk_count <= sclk_count + 1'b1;
                    end
                end

                ST_READ_CS_HIGH: begin
                    busy <= 1'b1;
                    adc_sclk <= 1'b0;
                    if (delay_count == 0) begin
                        adc_cs_n <= 1'b1;
                        busy <= 1'b0;
                        state <= ST_WAIT_DRDY;
                    end else begin
                        delay_count <= delay_count - 1'b1;
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
