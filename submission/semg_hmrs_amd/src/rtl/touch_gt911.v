/*
 * touch_gt911.v - PL-side GT911 capacitive touch front end for the ATK
 * RGB LCD modules (ATK-MD0700R 7" 1024x600, ATK-4384 4.3" 800x480).
 *
 * PL-first: the reset sequencing, I2C address selection and point polling
 * all run autonomously in the PL.  The PS only reads one 32-bit word
 * through axi_gpio_1 (single 32-bit input channel):
 *
 *   [31]    link_valid - GT911 acknowledged its I2C address probe
 *   [30]    down       - buffer-ready status has at least one contact
 *   [29:24] roll       - increments on every accepted point report; the PS
 *                        reads the word twice and compares roll to avoid
 *                        tearing across the asynchronous update
 *   [23:12] x[11:0]    - panel-native X (0..1023 on 7016, 0..799 on 4384)
 *   [11:0]  y[11:0]    - panel-native Y (0..599 on 7016, 0..479 on 4384)
 *
 * I2C: single master, 50 MHz / 250 = 200 kHz.  SDA is open drain (module
 * has pull-ups), SCL is push-pull (GT911 never stretches the clock).
 * GT911 registers are addressed with a 16-bit register pointer.
 *
 * Reset / address selection (GT911 programming guide):
 *   INT driven low + RST driven low for 10 ms;
 *   RST released, INT held low for another 50 ms;
 *   INT released to Hi-Z (module pull-up).
 *   The GT911 latches its I2C address at RST release: INT low -> 0x5D,
 *   INT high -> 0x14.  We probe 0x5D first, then 0x14, and hard-reset
 *   the chip after 3 consecutive failed probe rounds.
 *
 * Polling (~2.5 ms period, gated by the GT911 buffer-status bit):
 *   read 0x814E (bit7 = buffer ready, [3:0] = points);
 *   if ready and >= 1 point: read point 1 at 0x814F..0x8153
 *     (track id, xL, xH, yL, yH) and write 0x00 back to 0x814E;
 *     GT911 down/up comes from the status point count, not xH event bits.
 *   if ready with 0 points: just clear 0x814E.
 *
 * Board wiring (banks 34/35, LVCMOS33, see hz_zynq_lcd.xdc).  J10 pin
 * numbers follow the ATK module 40P table (user re-checked 2026-10-11:
 * an earlier draft was shifted up one row, T_CS is J10-35).  The FPGA
 * ball mapping is keyed to the carrier NET names (T_CS/IIC2_SDA/...),
 * cross-validated against the working LCD pins, so it is unaffected by
 * the J10 renumbering:
 *   touch_rst  M19  J10-35 T_CS  = CT_RST (GT911 RST)
 *   touch_sda  P20  J10-36 IIC2_SDA (shared with HDMI DDC - GT911 addr
 *                    0x5D/0x14 differs from the display EDID address 0x50)
 *   touch_scl  R19  J10-38 IIC2_SCL
 *   touch_int  U19  J10-39 T_PEN = CT_INT (driven low during reset only)
 *   (J10-37 T_MISO unused on the capacitive module; J10-40 LCD_RST is
 *    RC self-released on the carrier)
 */
module touch_gt911 (
    input  wire clk,            // 50 MHz (FCLK_CLK1), panel-clock independent
    input  wire rst_in,         // active high (peripheral_reset)
    output wire touch_rst,      // GT911 RST, push-pull
    output wire touch_scl,      // I2C SCL, push-pull master
    inout  wire touch_sda_io,   // I2C SDA, open drain
    inout  wire touch_int_io,   // driven low during reset, Hi-Z afterwards
    output reg  [31:0] touch_data
);

    // ------------------------------------------------------------
    // Timing constants (50 MHz domain).  Hardcoded on purpose - the
    // Vivado 2025.2 OOC wrapper stringifies positive module parameters.
    // ------------------------------------------------------------
    localparam [22:0] T_RST_LO   = 23'd500_000;   // 10 ms   RST low
    localparam [22:0] T_INT_HOLD = 23'd2_500_000; // 50 ms   INT low after RST
    localparam [22:0] T_SETTLE   = 23'd250_000;   // 5 ms    bus settle
    localparam [22:0] T_POLL_GAP = 23'd100_000;   // 2 ms    poll period
    localparam [22:0] T_RETRY    = 23'd5_000_000; // 100 ms  retry wait
    localparam [19:0] T_I2C_WD   = 20'd500_000;   // 10 ms   I2C watchdog

    localparam [7:0] I2C_HALF = 8'd124;           // SCL rise point (of 249)
    localparam [7:0] I2C_SMP  = 8'd190;           // SDA sample point

    localparam [6:0] GT_ADDR0 = 7'h5D;            // INT low  at reset release
    localparam [6:0] GT_ADDR1 = 7'h14;            // INT high at reset release
    localparam [15:0] REG_STATUS = 16'h814E;      // buffer status / points
    localparam [15:0] REG_POINT1 = 16'h814F;      // point 1: id,xL,xH,yL,yH

    // ---------------- pin drives ----------------
    // Explicit IOBUF primitives are MANDATORY: OOC synthesis (module_ref
    // flow) silently degrades inferred tristates ("assign io = oe ? 0 :
    // 1'bz") into a GND + OBUF chain, leaving the SDA pad stuck low and
    // the I2C bus wedged (2026-10-12 netlist audit).  Primitives survive
    // OOC synthesis untouched.  int_in is the INT readback (unused by the
    // poll-only FSM today, kept wired for the pad direction to be real).
    reg        rst_pin, int_drv;
    reg        scl_r, sda_oe_r;
    wire       sda_in;
    wire       int_in;
    assign touch_rst = rst_pin;
    assign touch_scl = scl_r;
    IOBUF u_sda_iobuf (.I(1'b0), .O(sda_in), .T(~sda_oe_r), .IO(touch_sda_io));
    IOBUF u_int_iobuf (.I(1'b0), .O(int_in), .T(~int_drv),  .IO(touch_int_io));

    // ============================================================
    // I2C byte engine (bit-banged, quarter-phase scheduling)
    // ============================================================
    localparam [3:0] E_IDLE  = 4'd0, E_START = 4'd1, E_TXBIT = 4'd2,
                     E_ACKIN = 4'd3, E_RXBIT = 4'd4, E_ACKOUT= 4'd5,
                     E_STOP1 = 4'd6, E_STOP2 = 4'd7;
    localparam [2:0] PH_ADDR_W = 3'd0, PH_REG_H = 3'd1, PH_REG_L = 3'd2,
                     PH_WDATA  = 3'd3, PH_ADDR_R= 3'd4, PH_RDATA= 3'd5,
                     PH_STOP   = 3'd6;

    reg [3:0]  eng_st;
    reg [7:0]  eng_div;
    reg [19:0] eng_wd;
    reg [2:0]  bit_i;
    reg [7:0]  tx_byte;
    reg [39:0] rx_word;
    reg [2:0]  ph;
    reg [3:0]  rd_left;
    reg        eng_ack_err, eng_done;
    reg        req_d;

    // transaction descriptor (written by the sequencer before sq_req rises)
    reg [6:0]  t_addr;
    reg [15:0] t_reg;
    reg        t_reg_en, t_write1;
    reg [7:0]  t_wdata;
    reg [3:0]  t_nread;
    reg        sq_req;

    // next phase after the current byte completes
    reg [2:0] nph;
    always @* begin
        case (ph)
            PH_ADDR_W: nph = t_reg_en            ? PH_REG_H  :
                             t_write1            ? PH_WDATA  :
                             (t_nread != 4'd0)   ? PH_ADDR_R : PH_STOP;
            PH_REG_H:  nph = PH_REG_L;
            PH_REG_L:  nph = t_write1            ? PH_WDATA  :
                             (t_nread != 4'd0)   ? PH_ADDR_R : PH_STOP;
            PH_WDATA:  nph = (t_nread != 4'd0)   ? PH_ADDR_R : PH_STOP;
            PH_ADDR_R: nph = PH_RDATA;
            PH_RDATA:  nph = (rd_left == 4'd1)   ? PH_STOP   : PH_RDATA;
            default:   nph = PH_STOP;
        endcase
    end

    wire [7:0] next_tx =
        (nph == PH_ADDR_R) ? {t_addr, 1'b1} :
        (nph == PH_ADDR_W) ? {t_addr, 1'b0} :
        (nph == PH_REG_H)  ? t_reg[15:8]    :
        (nph == PH_REG_L)  ? t_reg[7:0]     : t_wdata;

    always @(posedge clk) begin
        if (rst_in) begin
            eng_st <= E_IDLE;  eng_div <= 8'd0;  eng_wd <= 20'd0;
            bit_i <= 3'd0;     tx_byte <= 8'hFF; rx_word <= 40'd0;
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

            // receive one bit (GT911 changes SDA while SCL is low)
            E_RXBIT: begin
                sda_oe_r <= 1'b0;
                if (eng_div == I2C_HALF) scl_r <= 1'b1;
                if (eng_div == I2C_SMP)  rx_word <= {rx_word[38:0], sda_in};
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
    // Sequencer: reset -> probe -> poll -> parse -> clear
    // ============================================================
    localparam [3:0] S_RST0    = 4'd0,  S_RST1   = 4'd1,  S_INTZ   = 4'd2,
                     S_PROBE   = 4'd3,  S_PROBE_W= 4'd4,  S_POLL   = 4'd5,
                     S_POLL_W  = 4'd6,  S_POINT  = 4'd7,  S_POINT_W= 4'd8,
                     S_CLEAR   = 4'd9,  S_CLEAR_W= 4'd10, S_WAIT   = 4'd11,
                     S_RETRY   = 4'd12;

    reg [3:0]  sq;
    reg [22:0] tmr;
    reg        probe_sel;     // 0: 0x5D, 1: 0x14
    reg [1:0]  probe_round;   // consecutive both-address probe failures
    reg [2:0]  tx_fail;       // consecutive failed transactions after link
    reg        link_valid;
    reg [5:0]  roll;

    wire [7:0] status  = rx_word[7:0];
    wire [11:0] pt_x   = {rx_word[19:16], rx_word[31:24]};  // xH[3:0],xL
    wire [11:0] pt_y   = {rx_word[3:0],   rx_word[15:8]};   // yH[3:0],yL

    always @(posedge clk) begin
        if (rst_in) begin
            sq <= S_RST0;      tmr <= 23'd0;
            rst_pin <= 1'b1;   int_drv <= 1'b0;
            probe_sel <= 1'b0; probe_round <= 2'd0; tx_fail <= 3'd0;
            link_valid <= 1'b0; roll <= 6'd0;
            touch_data <= 32'd0;
            t_addr <= GT_ADDR0; t_reg <= REG_STATUS;
            t_reg_en <= 1'b0;   t_write1 <= 1'b0; t_wdata <= 8'd0;
            t_nread <= 4'd0;    sq_req <= 1'b0;
        end else begin
            tmr <= tmr + 23'd1;
            case (sq)

            // --- hardware reset + address selection window ---
            S_RST0: begin                       // RST low, INT low, 10 ms
                touch_data[31:30] <= 2'b00;
                rst_pin  <= 1'b0;
                int_drv  <= 1'b1;
                link_valid <= 1'b0;
                tx_fail  <= 3'd0;
                if (tmr >= T_RST_LO) begin
                    tmr <= 23'd0;
                    sq  <= S_RST1;
                end
            end
            S_RST1: begin                       // RST high, INT low, 50 ms
                rst_pin <= 1'b1;
                if (tmr >= T_INT_HOLD) begin
                    tmr <= 23'd0;
                    sq  <= S_INTZ;
                end
            end
            S_INTZ: begin                       // release INT, settle
                int_drv <= 1'b0;
                if (tmr >= T_SETTLE) begin
                    tmr       <= 23'd0;
                    probe_sel <= 1'b0;
                    sq        <= S_PROBE;
                end
            end

            // --- address probe: bare START + ADDR(W) + STOP ---
            S_PROBE: begin
                t_addr   <= probe_sel ? GT_ADDR1 : GT_ADDR0;
                t_reg_en <= 1'b0;
                t_write1 <= 1'b0;
                t_nread  <= 4'd0;
                sq_req   <= 1'b1;
                sq       <= S_PROBE_W;
            end
            S_PROBE_W: begin
                if (eng_done) begin
                    sq_req <= 1'b0;
                    if (!eng_ack_err) begin
                        link_valid  <= 1'b1;
                        touch_data[31] <= 1'b1;
                        probe_round <= 2'd0;
                        sq          <= S_POLL;
                    end else if (!probe_sel) begin
                        probe_sel <= 1'b1;      // try the other address now
                        sq        <= S_PROBE;
                    end else begin
                        probe_sel <= 1'b0;
                        if (probe_round == 2'd2) begin
                            probe_round <= 2'd0;
                            sq          <= S_RST0;  // hard reset and retry
                            tmr         <= 23'd0;
                        end else begin
                            probe_round <= probe_round + 2'd1;
                            sq          <= S_RETRY;
                        end
                    end
                end
            end

            // --- poll buffer status 0x814E ---
            S_POLL: begin
                tmr <= 23'd0;
                t_reg    <= REG_STATUS;
                t_reg_en <= 1'b1;
                t_write1 <= 1'b0;
                t_nread  <= 4'd1;
                sq_req   <= 1'b1;
                sq       <= S_POLL_W;
            end
            S_POLL_W: begin
                if (eng_done) begin
                    sq_req <= 1'b0;
                    if (eng_ack_err) begin
                        touch_data[30] <= 1'b0; // no stuck button across bus errors
                        if (tx_fail == 3'd5) begin
                            tx_fail <= 3'd0;
                            sq      <= S_RST0;  // link lost, hard reset
                            tmr     <= 23'd0;
                        end else begin
                            tx_fail <= tx_fail + 3'd1;
                            sq      <= S_RETRY;
                        end
                    end else begin
                        tx_fail <= 3'd0;
                        if (status[7] && status[3:0] != 4'd0) sq <= S_POINT;
                        else if (status[7]) begin
                            roll <= roll + 6'd1;
                            touch_data <= {link_valid,1'b0,roll+6'd1,touch_data[23:0]};
                            sq <= S_CLEAR;
                        end
                        else                                  sq <= S_WAIT;
                    end
                end
            end

            // --- read point 1 (ID at 0x814F, XY at 0x8150..0x8153) ---
            S_POINT: begin
                t_reg    <= REG_POINT1;
                t_reg_en <= 1'b1;
                t_write1 <= 1'b0;
                t_nread  <= 4'd5;
                sq_req   <= 1'b1;
                sq       <= S_POINT_W;
            end
            S_POINT_W: begin
                if (eng_done) begin
                    sq_req <= 1'b0;
                    roll   <= roll + 6'd1;
                    if (!eng_ack_err)
                        touch_data <= {link_valid, 1'b1, roll + 6'd1,
                                       pt_x, pt_y};
                    else touch_data[30] <= 1'b0;
                    sq <= S_CLEAR;
                end
            end

            // --- release the buffer: write 0 to 0x814E ---
            S_CLEAR: begin
                t_reg    <= REG_STATUS;
                t_reg_en <= 1'b1;
                t_write1 <= 1'b1;
                t_wdata  <= 8'd0;
                t_nread  <= 4'd0;
                sq_req   <= 1'b1;
                sq       <= S_CLEAR_W;
            end
            S_CLEAR_W: begin
                if (eng_done) begin
                    sq_req <= 1'b0;
                    sq     <= S_WAIT;
                end
            end

            S_WAIT: begin
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

            default: sq <= S_RST0;
            endcase
        end
    end

endmodule

