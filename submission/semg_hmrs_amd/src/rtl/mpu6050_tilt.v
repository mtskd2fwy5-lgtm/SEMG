/*
 * mpu6050_tilt.v - PL-side MPU6050 (GY-521 module) forearm-tilt front end.
 *
 * PL-first: wake-up config, 100 Hz 14-byte burst reads and the
 * accelerometer/gyro complementary filter all run autonomously in the PL.
 * The PS only reads one 32-bit word through axi_gpio_2 (single 32-bit
 * input channel), mirroring the touch path contract:
 *
 *   [31]    link_valid - configured link; cleared after six poll failures
 *   [30:24] seq        - increments on every accepted burst read; the PS
 *                        reads the word twice and compares seq to avoid
 *                        tearing across the asynchronous update
 *   [23:12] pitch[11:0]- signed, 0.1 deg units (s12, +/-204.7 deg)
 *   [11:0]  roll[11:0] - signed, 0.1 deg units (s12, +/-204.7 deg)
 *
 * I2C: single master, 50 MHz / 250 = 200 kHz.  SDA is open drain (pull-ups
 * on both the GY-521 module R4/R5 and the carrier R33/R34), SCL push-pull.
 * 8-bit register addressing (unlike the GT911's 16-bit pointer).
 *
 * Device bring-up (RM-MPU-6000A register map):
 *   - 100 ms power-up wait, then probe WHO_AM_I (0x75) at 0x68 (AD0 low,
 *     module R6 pulls AD0 down) with 0x69 as fallback.  The ACK is the
 *     only gate - the WHO_AM_I value is NOT checked because clone dies
 *     report 0x70 while being register-identical (vendor doc 2026-10-11).
 *   - PWR_MGMT_1  (0x6B) = 0x00  wake, internal oscillator
 *   - SMPLRT_DIV  (0x19) = 0x09  1 kHz/(1+9) = 100 Hz sample rate
 *   - CONFIG      (0x1A) = 0x03  DLPF 44 Hz (gyro + accel), 4.9 ms delay
 *   - GYRO_CONFIG (0x1B) = 0x10  +/-1000 dps (32.8 LSB/deg/s)
 *   - ACCEL_CONFIG(0x1C) = 0x00  +/-2g       (16384 LSB/g)
 *   - poll: burst-read 14 bytes from 0x3B at 100 Hz (matches the sample
 *     rate; the DLPF keeps any update-boundary straddle negligible)
 *
 * Attitude: shared sequential 13-iteration vectoring CORDIC (1/64 deg
 * units) computes
 *   roll_acc  = atan2(ay, az)
 *   pitch_acc = atan2(-ax, hypot(ay, az))
 * The CORDIC gain (1.647) on the magnitude output is removed with a Q14
 * constant before the second job.  Then the 100 Hz complementary filter
 *   angle += gyro_step + (acc_angle - angle)/32
 * anchors the slow gyro drift to the gravity vector. State uses Q8
 * subunits of 0.1 degree; gyro_step = LSB * 51150/65536 in those units.
 *
 * Probe/config NACKs retry after 100 ms; six consecutive poll failures
 * also trigger reprobe. Configuration is replayed on recovery, so a power
 * cycle self-heals.  No hardware reset pin is wired (J11 carries SCL/SDA
 * only), which is fine - the register map is writable at any time.
 *
 * Board wiring: carrier J11 "OLED&CAMERA" 2x9 header (2.54 mm, board has
 * R33/R34 4.7k pull-ups + 3.3V on the header):
 *   GY-521 VCC -> J11 3.3V, GND -> J11 GND,
 *   SCL -> CMOS_SCL = bank34_L1N = ball T10 (IO_L1N_T0_34)
 *   SDA -> CMOS_SDA = bank34_L1P = ball T11 (IO_L1P_T0_34)
 * (ball mapping cross-validated against the working LCD/touch pins in
 * a7z020clg400_pkg.xml; L1P/L1N are plain IO with no special function).
 *
 * Axis mapping depends on how the module sits on the forearm - bench-tune
 * by flipping the four localparam signs below, then rebuild.
 */
module mpu6050_tilt (
    input  wire clk,            // 50 MHz (FCLK_CLK1), fixed
    input  wire rst_in,         // active high (peripheral_reset)
    output wire mpu_scl,        // I2C SCL, push-pull master
    inout  wire mpu_sda_io,     // I2C SDA, open drain
    output reg  [31:0] mpu_data,
    output reg  [31:0] motion_a,
    output reg  [31:0] motion_b,
    output reg  [31:0] motion_c
);
    // ------------------------------------------------------------
    // Bench-tunable axis mapping (module flat on forearm, cable exit
    // toward the elbow assumed).  Flip to -1 if an axis runs backwards.
    //   roll  = rotation about the board X axis  (accel atan2(ay,az),
    //           rate sensor gx)
    //   pitch = rotation about the board Y axis  (accel atan2(ax,|yz|),
    //           rate sensor gy)
    // ------------------------------------------------------------
    localparam ROLL_ACC_SIGN  = 1;
    localparam PITCH_ACC_SIGN = -1; // pitch around Y: atan2(-ax, hypot(ay,az))
    localparam GX_SIGN        = 1;
    localparam GY_SIGN        = 1;

    // ------------------------------------------------------------
    // Timing constants (50 MHz domain).  Hardcoded on purpose - the
    // Vivado 2025.2 OOC wrapper stringifies positive module parameters.
    // ------------------------------------------------------------
    localparam [22:0] T_BOOT    = 23'd5_000_000; // 100 ms power-up wait
    localparam [22:0] T_POLL_GAP= 23'd500_000;   // 10 ms  poll period (100 Hz)
    localparam [22:0] T_RETRY   = 23'd5_000_000; // 100 ms failure retry
    localparam [19:0] T_I2C_WD  = 20'd500_000;   // 10 ms  I2C watchdog

    localparam [7:0] I2C_HALF = 8'd124;          // SCL rise point (of 249)
    localparam [7:0] I2C_SMP  = 8'd190;          // SDA sample point

    localparam [6:0] MPU_ADDR0 = 7'h68;          // AD0 = GND (module R6)
    localparam [6:0] MPU_ADDR1 = 7'h69;          // AD0 = VCC fallback
    localparam [7:0] REG_WHOAMI  = 8'h75;        // probe register
    localparam [7:0] REG_MEAS    = 8'h3B;        // ACCEL_XOUT_H burst start

    // CORDIC angle unit = 1/64 deg; 180 deg = 11520
    localparam signed [15:0] ANGLE_180 = 16'sd11520;

    // ---------------- pin drives ----------------
    // Explicit IOBUF primitive is MANDATORY: OOC synthesis (module_ref
    // flow) silently degrades the inferred tristate ("assign io = oe ? 0
    // : 1'bz") into a GND + OBUF chain, leaving the SDA pad stuck low so
    // every I2C read returns 0x00 (the p=949 r=949 CORDIC artifact,
    // 2026-10-12 netlist audit).  Primitives survive OOC untouched.
    reg        scl_r, sda_oe_r;
    wire       sda_in;
    assign mpu_scl = scl_r;
    IOBUF u_sda_iobuf (.I(1'b0), .O(sda_in), .T(~sda_oe_r), .IO(mpu_sda_io));

    // ============================================================
    // I2C byte engine (bit-banged, quarter-phase scheduling; 8-bit
    // register pointer per the MPU-6000 register map)
    // ============================================================
    localparam [3:0] E_IDLE  = 4'd0, E_START = 4'd1, E_TXBIT = 4'd2,
                     E_ACKIN = 4'd3, E_RXBIT = 4'd4, E_ACKOUT= 4'd5,
                     E_STOP1 = 4'd6, E_STOP2 = 4'd7;
    localparam [2:0] PH_ADDR_W = 3'd0, PH_REG = 3'd1, PH_WDATA = 3'd2,
                     PH_ADDR_R = 3'd3, PH_RDATA = 3'd4, PH_STOP = 3'd5;

    reg [3:0]  eng_st;
    reg [7:0]  eng_div;
    reg [19:0] eng_wd;
    reg [2:0]  bit_i;
    reg [7:0]  tx_byte;
    reg [111:0] rx_word;        // 14-byte sensor burst
    reg [2:0]  ph;
    reg [3:0]  rd_left;
    reg        eng_ack_err, eng_done;
    reg        req_d;

    // transaction descriptor (written by the sequencer before sq_req rises)
    reg [6:0]  t_addr;
    reg [7:0]  t_reg;
    reg        t_reg_en, t_write1;
    reg [7:0]  t_wdata;
    reg [3:0]  t_nread;
    reg        sq_req;

    // next phase after the current byte completes
    reg [2:0] nph;
    always @* begin
        case (ph)
            PH_ADDR_W: nph = t_reg_en            ? PH_REG    :
                              t_write1            ? PH_WDATA  :
                              (t_nread != 4'd0)  ? PH_REG    : PH_STOP;
            PH_REG:    nph = t_write1            ? PH_WDATA  :
                              (t_nread != 4'd0)  ? PH_ADDR_R : PH_STOP;
            PH_WDATA:  nph = (t_nread != 4'd0)   ? PH_ADDR_R : PH_STOP;
            PH_ADDR_R: nph = PH_RDATA;
            PH_RDATA:  nph = (rd_left == 4'd1)   ? PH_STOP   : PH_RDATA;
            default:   nph = PH_STOP;
        endcase
    end

    wire [7:0] next_tx =
        (nph == PH_ADDR_R) ? {t_addr, 1'b1} :
        (nph == PH_ADDR_W) ? {t_addr, 1'b0} :
        (nph == PH_REG)    ? t_reg[7:0]     : t_wdata;

    always @(posedge clk) begin
        if (rst_in) begin
            eng_st <= E_IDLE;  eng_div <= 8'd0;  eng_wd <= 20'd0;
            bit_i <= 3'd0;     tx_byte <= 8'hFF; rx_word <= 112'd0;
            ph <= PH_ADDR_W;   rd_left <= 4'd0;
            eng_ack_err <= 1'b0; eng_done <= 1'b0;
            scl_r <= 1'b0;     sda_oe_r <= 1'b0;  req_d <= 1'b0;
        end else begin
            eng_done <= 1'b0;
            req_d <= sq_req;

            // watchdog: any non-idle state longer than 10 ms -> abort
            if (eng_st != E_IDLE) begin
                if (eng_wd >= T_I2C_WD) begin
                    eng_st      <= E_IDLE;
                    scl_r       <= 1'b0;
                    sda_oe_r    <= 1'b0;
                    eng_ack_err <= 1'b1;
                    eng_done    <= 1'b1;
                end else begin
                    eng_wd <= eng_wd + 20'd1;
                end
            end else begin
                eng_wd <= 20'd0;
            end

            if (!(eng_st != E_IDLE && eng_wd >= T_I2C_WD)) case (eng_st)
            E_IDLE: begin
                scl_r <= 1'b0;
                sda_oe_r <= 1'b0;
                if (sq_req && !req_d) begin          // rising edge: begin
                    eng_ack_err <= 1'b0;
                    ph          <= PH_ADDR_W;
                    rd_left     <= t_nread;
                    tx_byte     <= {t_addr, 1'b0};
                    eng_div     <= 8'd0;
                    bit_i       <= 3'd0;
                    eng_st      <= E_START;
                end
            end

            // START / repeated START: SCL low+SDA high -> SCL high ->
            // SDA falls -> SCL low again
            E_START: begin
                if (eng_div == 8'd60)  scl_r    <= 1'b1;
                if (eng_div == 8'd123) sda_oe_r <= 1'b1;   // SDA falls, SCL high
                if (eng_div == 8'd186) scl_r    <= 1'b0;
                if (eng_div == 8'd249) begin
                    eng_div <= 8'd0;
                    eng_st  <= E_TXBIT;
                end else eng_div <= eng_div + 8'd1;
            end

            // transmit one bit (tx_byte[7] set while SCL low, sampled on rise)
            E_TXBIT: begin
                if (eng_div == 8'd0)    sda_oe_r <= ~tx_byte[7];
                if (eng_div == I2C_HALF) scl_r   <= 1'b1;
                if (eng_div == 8'd249) begin
                    scl_r   <= 1'b0;
                    eng_div <= 8'd0;
                    if (bit_i == 3'd7) begin
                        bit_i  <= 3'd0;
                        eng_st <= E_ACKIN;
                    end else begin
                        bit_i   <= bit_i + 3'd1;
                        tx_byte <= {tx_byte[6:0], 1'b0};
                    end
                end else eng_div <= eng_div + 8'd1;
            end

            // slave ACK slot: release SDA, sample it late in the SCL-high half
            E_ACKIN: begin
                sda_oe_r <= 1'b0;
                if (eng_div == I2C_HALF) scl_r <= 1'b1;
                if (eng_div == I2C_SMP)  eng_ack_err <= eng_ack_err | sda_in;
                if (eng_div == 8'd249) begin
                    scl_r    <= 1'b0;
                    eng_div  <= 8'd0;
                    ph       <= nph;
                    tx_byte  <= next_tx;
                    if (nph == PH_STOP)        eng_st <= E_STOP1;
                    else if (nph == PH_ADDR_R) eng_st <= E_START;  // rep. start
                    else if (nph == PH_RDATA)  eng_st <= E_RXBIT;
                    else                       eng_st <= E_TXBIT;
                end else eng_div <= eng_div + 8'd1;
            end

            // receive one bit (MPU changes SDA while SCL is low)
            E_RXBIT: begin
                sda_oe_r <= 1'b0;
                if (eng_div == I2C_HALF) scl_r <= 1'b1;
                if (eng_div == I2C_SMP)  rx_word <= {rx_word[110:0], sda_in};
                if (eng_div == 8'd249) begin
                    scl_r   <= 1'b0;
                    eng_div <= 8'd0;
                    if (bit_i == 3'd7) begin
                        bit_i  <= 3'd0;
                        eng_st <= E_ACKOUT;
                    end else begin
                        bit_i <= bit_i + 3'd1;
                    end
                end else eng_div <= eng_div + 8'd1;
            end

            // master ACK slot: ACK every byte, NAK the final one
            E_ACKOUT: begin
                sda_oe_r <= (rd_left != 4'd1);
                if (eng_div == I2C_HALF) scl_r <= 1'b1;
                if (eng_div == 8'd249) begin
                    scl_r    <= 1'b0;
                    eng_div  <= 8'd0;
                    if (ph == PH_RDATA) rd_left <= rd_left - 4'd1;
                    ph      <= nph;
                    tx_byte <= next_tx;
                    if (nph == PH_STOP) eng_st <= E_STOP1;
                    else                eng_st <= E_RXBIT;
                end else eng_div <= eng_div + 8'd1;
            end

            E_STOP1: begin                       // SDA low, then SCL high
                sda_oe_r <= 1'b1;
                if (eng_div == 8'd60) scl_r <= 1'b1;
                if (eng_div == 8'd249) begin
                    eng_div <= 8'd0;
                    eng_st  <= E_STOP2;
                end else eng_div <= eng_div + 8'd1;
            end

            E_STOP2: begin                       // SDA rises while SCL high
                if (eng_div == 8'd10) sda_oe_r <= 1'b0;
                if (eng_div == 8'd249) begin
                    scl_r    <= 1'b0;
                    sda_oe_r <= 1'b0;
                    eng_div  <= 8'd0;
                    eng_done <= 1'b1;            // transaction finished
                    eng_st   <= E_IDLE;
                end else eng_div <= eng_div + 8'd1;
            end

            default: eng_st <= E_IDLE;
            endcase
        end
    end

    // ============================================================
    // Shared vectoring CORDIC: atan2(y, x), 13 iterations, 1/64 deg
    // ============================================================
    localparam [1:0] C_IDLE = 2'd0, C_RUN = 2'd1, C_DONE = 2'd2;
    reg [1:0]  c_st;
    reg [3:0]  c_it;
    reg signed [17:0] cx, cy;               // datapath, gain headroom
    reg signed [15:0] cacc;                 // accumulated angle, 1/64 deg

    // 17-bit signed job inputs from the sequencer
    reg signed [16:0] cord_x, cord_y;
    reg               cord_start;
    wire              cord_done = (c_st == C_DONE);

    function signed [15:0] atan_lut;        // atan(2^-i) in 1/64 deg
        input [3:0] i;
        case (i)
            4'd0:  atan_lut = 16'sd2880;    // 45.000 deg
            4'd1:  atan_lut = 16'sd1700;    // 26.565
            4'd2:  atan_lut = 16'sd898;     // 14.036
            4'd3:  atan_lut = 16'sd456;     //  7.125
            4'd4:  atan_lut = 16'sd229;     //  3.576
            4'd5:  atan_lut = 16'sd114;     //  1.790
            4'd6:  atan_lut = 16'sd57;      //  0.895
            4'd7:  atan_lut = 16'sd29;      //  0.448
            4'd8:  atan_lut = 16'sd14;      //  0.224
            4'd9:  atan_lut = 16'sd7;       //  0.112
            4'd10: atan_lut = 16'sd4;       //  0.056
            4'd11: atan_lut = 16'sd2;       //  0.028
            4'd12: atan_lut = 16'sd1;       //  0.014
            default: atan_lut = 16'sd0;
        endcase
    endfunction

    // magnitude output: remove the 1.647 CORDIC gain (Q14 = 9950/16384).
    // Max |cx| = 46340*1.647 = 76324 -> product 759e6 fits signed 36.
    wire signed [35:0] mag_full = cx * 36'sd9950;
    wire signed [17:0] mag_c    = mag_full >>> 14;   // <= 46345, fits 18 bit

    always @(posedge clk) begin
        if (rst_in) begin
            c_st <= C_IDLE;  c_it <= 4'd0;
            cx <= 18'sd0;    cy <= 18'sd0;   cacc <= 16'sd0;
        end else begin
            case (c_st)
            C_IDLE: begin
                if (cord_start) begin
                    c_it <= 4'd0;
                    cacc <= 16'sd0;
                    if (cord_x[16]) begin        // x < 0: rotate 180 deg first
                        cx   <= -$signed({cord_x[16], cord_x});
                        cy   <= -$signed({cord_y[16], cord_y});
                        cacc <= cord_y[16] ? -ANGLE_180 : ANGLE_180;
                    end else begin
                        cx   <= $signed({cord_x[16], cord_x});
                        cy   <= $signed({cord_y[16], cord_y});
                    end
                    c_st <= C_RUN;
                end
            end
            C_RUN: begin
                if (cy >= 18'sd0) begin
                    cx   <= cx + (cy >>> c_it);
                    cy   <= cy - (cx >>> c_it);
                    cacc <= cacc + atan_lut(c_it);
                end else begin
                    cx   <= cx - (cy >>> c_it);
                    cy   <= cy + (cx >>> c_it);
                    cacc <= cacc - atan_lut(c_it);
                end
                if (c_it == 4'd12) c_st <= C_DONE;
                else               c_it <= c_it + 4'd1;
            end
            C_DONE: c_st <= C_IDLE;
            default: c_st <= C_IDLE;
            endcase
        end
    end

    // ============================================================
    // Sequencer: boot -> probe -> config -> poll/cordic/filter loop
    // ============================================================
    localparam [3:0] S_BOOT    = 4'd0,  S_PROBE  = 4'd1,  S_PROBE_W = 4'd2,
                     S_CFG     = 4'd3,  S_CFG_W  = 4'd4,  S_POLL    = 4'd5,
                     S_POLL_W  = 4'd6,  S_ANG_A  = 4'd7,  S_ANG_B   = 4'd8,
                     S_GAP     = 4'd9,  S_RETRY  = 4'd10;

    reg [3:0]  sq;
    reg [22:0] tmr;
    reg        addr_sel;      // 0: 0x68, 1: 0x69
    reg [2:0]  cfg_i;         // config write index 0..4
    reg        link_valid;
    reg [6:0]  seq;

    // raw sensor latches (big-endian byte pairs out of rx_word)
    reg signed [15:0] ax_raw, ay_raw, az_raw, gx_raw, gy_raw, gz_raw;
    reg signed [15:0] roll_raw, pitch_raw;  // CORDIC results, 1/64 deg

    // Q8 subunits of 0.1 degree retain small gyro steps and corrections.
    reg signed [31:0] roll_f, pitch_f;
    reg filter_valid;
    reg [2:0] poll_fail;

    // sign-normalized job inputs / gyro terms
    wire signed [16:0] ay_ext = $signed({ay_raw[15], ay_raw});
    wire signed [16:0] ax_ext = $signed({ax_raw[15], ax_raw});
    wire signed [16:0] ay_s   = (ROLL_ACC_SIGN  < 0) ? -ay_ext : ay_ext;
    wire signed [16:0] ax_s   = (PITCH_ACC_SIGN < 0) ? -ax_ext : ax_ext;
    wire signed [16:0] gx_ext = $signed({gx_raw[15], gx_raw});
    wire signed [16:0] gy_ext = $signed({gy_raw[15], gy_raw});
    wire signed [16:0] gx_s   = (GX_SIGN < 0) ? -gx_ext : gx_ext;
    wire signed [16:0] gy_s   = (GY_SIGN < 0) ? -gy_ext : gy_ext;

    // complementary filter terms (all signed 32-bit)
    // acc angle: 1/64 deg -> Q8 of 0.1 deg = *40
    // gyro step: LSB/32.8 deg/s * 10 ms -> Q8 of 0.1 deg = *51150 >> 16
    // complementary correction: alpha = 1/32
    wire signed [31:0] roll_acc_q8  = roll_raw * 32'sd40;
    wire signed [31:0] pitch_acc_q8 = cacc * 32'sd40; // current pitch job
    // 10 ms between STARTs: 10*256/(32.8*100) ~=51150/65536.
    wire signed [31:0] gx_step       = (gx_s * 32'sd51150) >>> 16;
    wire signed [31:0] gy_step       = (gy_s * 32'sd51150) >>> 16;
    wire signed [31:0] roll_corr     =
        (roll_acc_q8 - roll_f) >>> 5;   // 1/32: no 32-bit multiply overflow
    wire signed [31:0] pitch_corr    =
        (pitch_acc_q8 - pitch_f) >>> 5;
    wire signed [31:0] roll_next = filter_valid ? roll_f + gx_step + roll_corr : roll_acc_q8;
    wire signed [31:0] pitch_next = filter_valid ? pitch_f + gy_step + pitch_corr : pitch_acc_q8;
    wire signed [31:0] roll_out = roll_next >>> 8;
    wire signed [31:0] pitch_out = pitch_next >>> 8;

    // config register table
    function [7:0] cfg_reg; input [2:0] i;
        case (i)
            3'd0:    cfg_reg = 8'h6B;   // PWR_MGMT_1
            3'd1:    cfg_reg = 8'h19;   // SMPLRT_DIV
            3'd2:    cfg_reg = 8'h1A;   // CONFIG (DLPF)
            3'd3:    cfg_reg = 8'h1B;   // GYRO_CONFIG
            default: cfg_reg = 8'h1C;   // ACCEL_CONFIG
        endcase
    endfunction
    function [7:0] cfg_val; input [2:0] i;
        case (i)
            3'd0:    cfg_val = 8'h00;   // wake up
            3'd1:    cfg_val = 8'h09;   // 1 kHz/(1+9) = 100 Hz
            3'd2:    cfg_val = 8'h03;   // DLPF 44 Hz
            3'd3:    cfg_val = 8'h10;   // gyro +/-1000 dps
            default: cfg_val = 8'h00;   // accel +/-2g
        endcase
    endfunction

    always @(posedge clk) begin
        if (rst_in) begin
            sq <= S_BOOT;      tmr <= 23'd0;
            addr_sel <= 1'b0;  cfg_i <= 3'd0;
            link_valid <= 1'b0; seq <= 7'd0;
            ax_raw <= 16'sd0;  ay_raw <= 16'sd0;  az_raw <= 16'sd0;
            gx_raw <= 16'sd0;  gy_raw <= 16'sd0;
            gz_raw <= 0;
            roll_raw <= 16'sd0; pitch_raw <= 16'sd0;
            roll_f <= 32'sd0;  pitch_f <= 32'sd0;
            filter_valid <= 1'b0; poll_fail <= 3'd0;
            cord_x <= 17'sd0;  cord_y <= 17'sd0;  cord_start <= 1'b0;
            mpu_data <= 32'd0;
            motion_a<=0;motion_b<=0;motion_c<=0;
            t_addr <= MPU_ADDR0; t_reg <= REG_WHOAMI;
            t_reg_en <= 1'b0;   t_write1 <= 1'b0; t_wdata <= 8'd0;
            t_nread <= 4'd0;    sq_req <= 1'b0;
        end else begin
            tmr <= tmr + 23'd1;
            case (sq)

            // --- power-up: let VDD and the DCM settle ---
            S_BOOT: begin
                link_valid <= 1'b0;
                addr_sel   <= 1'b0;
                if (tmr >= T_BOOT) begin
                    tmr <= 23'd0;
                    sq  <= S_PROBE;
                end
            end

            // --- probe: read WHO_AM_I, ACK-only gate (clones ID = 0x70) ---
            S_PROBE: begin
                link_valid <= 1'b0;
                mpu_data[31] <= 1'b0;
                t_addr   <= addr_sel ? MPU_ADDR1 : MPU_ADDR0;
                t_reg    <= REG_WHOAMI;
                t_reg_en <= 1'b1;
                t_write1 <= 1'b0;
                t_nread  <= 4'd1;
                sq_req   <= 1'b1;
                sq       <= S_PROBE_W;
            end
            S_PROBE_W: begin
                if (eng_done) begin
                    sq_req <= 1'b0;
                    if (!eng_ack_err) begin
                        cfg_i <= 3'd0;
                        sq    <= S_CFG;
                    end else if (!addr_sel) begin
                        addr_sel <= 1'b1;      // try the other address
                        sq       <= S_RETRY;
                    end else begin
                        addr_sel <= 1'b0;
                        sq       <= S_RETRY;   // nothing answered, wait
                    end
                end
            end

            // --- config: replay all five registers on every recovery ---
            S_CFG: begin
                t_reg    <= cfg_reg(cfg_i);
                t_wdata  <= cfg_val(cfg_i);
                t_reg_en <= 1'b1;
                t_write1 <= 1'b1;
                t_nread  <= 4'd0;
                sq_req   <= 1'b1;
                sq       <= S_CFG_W;
            end
            S_CFG_W: begin
                if (eng_done) begin
                    sq_req <= 1'b0;
                    if (eng_ack_err) begin
                        mpu_data[31] <= 1'b0;
                        filter_valid <= 1'b0;
                        sq <= S_RETRY;
                    end else if (cfg_i == 3'd4) begin
                        link_valid <= 1'b1;
                        tmr        <= 23'd0;
                        sq         <= S_GAP;
                    end else begin
                        cfg_i <= cfg_i + 3'd1;
                        sq    <= S_CFG;
                    end
                end
            end

            // --- 100 Hz burst read of the 14 sensor bytes at 0x3B ---
            S_POLL: begin
                tmr <= 23'd0; // poll interval includes the burst/CORDIC latency
                t_reg    <= REG_MEAS;
                t_reg_en <= 1'b1;
                t_write1 <= 1'b0;
                t_nread  <= 4'd14;
                sq_req   <= 1'b1;
                sq       <= S_POLL_W;
            end
            S_POLL_W: begin
                if (eng_done) begin
                    sq_req <= 1'b0;
                    if (eng_ack_err) begin
                        if (poll_fail == 3'd5) begin
                            link_valid <= 1'b0;
                            mpu_data[31] <= 1'b0;
                            filter_valid <= 1'b0;
                            poll_fail <= 3'd0;
                            sq <= S_RETRY;
                        end else begin
                            poll_fail <= poll_fail + 3'd1;
                            sq <= S_GAP;
                        end
                    end else begin
                        poll_fail <= 3'd0;
                        ax_raw <= {rx_word[111:104], rx_word[103:96]};
                        ay_raw <= {rx_word[95:88],   rx_word[87:80]};
                        az_raw <= {rx_word[79:72],   rx_word[71:64]};
                        gx_raw <= {rx_word[47:40],   rx_word[39:32]};
                        gy_raw <= {rx_word[31:24],   rx_word[23:16]};
                        gz_raw <= rx_word[15:0];
                        // job A: roll = atan2(ay, az)
                        // Use the current burst (ax_raw etc update next edge).
                        cord_x <= $signed({rx_word[79],rx_word[79:64]});
                        cord_y <= (ROLL_ACC_SIGN < 0) ?
                            -$signed({rx_word[95],rx_word[95:80]}) :
                             $signed({rx_word[95],rx_word[95:80]});
                        cord_start<= 1'b1;
                        sq        <= S_ANG_A;
                    end
                end
            end

            // --- job A done: keep roll + magnitude, kick pitch job ---
            S_ANG_A: begin
                cord_start <= 1'b0;
                if (cord_done) begin
                    roll_raw  <= cacc;
                    cord_x    <= mag_c[16:0];
                    cord_y    <= ax_s;
                    cord_start<= 1'b1;
                    sq        <= S_ANG_B;
                end
            end

            // --- job B done: filter update + output word ---
            S_ANG_B: begin
                cord_start <= 1'b0;
                if (cord_done) begin
                    pitch_raw <= cacc;
                    roll_f    <= roll_next;
                    pitch_f   <= pitch_next;
                    filter_valid <= 1'b1;
                    seq <= seq + 7'd1;
                    mpu_data <= {link_valid, seq + 7'd1, pitch_out[11:0], roll_out[11:0]};
                    // Atomic snapshot. PS brackets the three GPIO reads with
                    // the sequence-bearing mpu_data word before consuming.
                    motion_a <= {ax_raw,ay_raw};
                    motion_b <= {az_raw,gx_raw};
                    motion_c <= {gy_raw,gz_raw};
                    sq        <= S_GAP;
                end
            end

            S_GAP: begin
                if (tmr >= T_POLL_GAP) begin
                    tmr <= 23'd0;
                    sq  <= S_POLL;
                end
            end

            S_RETRY: begin
                if (tmr >= T_RETRY) begin
                    tmr <= 23'd0;
                    sq  <= S_PROBE;
                end
            end

            default: sq <= S_BOOT;
            endcase
        end
    end

endmodule

