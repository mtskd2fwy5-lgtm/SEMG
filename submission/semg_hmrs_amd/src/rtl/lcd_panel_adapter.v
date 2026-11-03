/*
 * PL-side LCD panel auto-detection and timing adaptation, following the
 * ATK official 21_lcd_rgb_char example (rd_id.v + lcd_driver.v scheme):
 *
 *   1. While DE is idle the RGB pins are tri-stated (FPGA drives Z), so the
 *      panel's hardwired ID levels on B7/G7/R7 can be read back.
 *   2. After reset the module waits for MMCM lock plus ~20 ms, samples
 *      {B7, G7, R7} once and decodes the panel id:
 *          3'b100 -> 16'h4384  ATK-4384 4.3"  800x480
 *          3'b010 -> 16'h7016  ATK-7016 7"   1024x600
 *          other  -> 16'h0000  (falls back to the 4384 configuration)
 *   3. A single MMCM (CLKIN = FCLK_CLK1 50 MHz, VCO 1000 MHz) generates
 *      both pixel clocks: 50.000 MHz (divide 20) and 31.250 MHz (divide
 *      32).  A glitchless BUFGMUX picks the pixel clock from the latched
 *      id, so the whole video domain (vid_out + ODDR forwarding + this
 *      timing generator) self-adapts.  FCLK1 stays at 50 MHz for both
 *      panels; the PS never touches SLCR.
 *   4. A small counter FSM generates the video_timing (v_tc replacement)
 *      with the per-panel timing tables previously programmed into
 *      v_tc_0 via set_lcd_panel.tcl:
 *          4384: H 800/840/888/976,  V 480/493/496/528 (31.25 MHz)
 *          7016: H 1024/1154/1184/1344, V 600/602/612/635 (50 MHz)
 *      HS/VS are active low, DE active high (same polarity as the GEN_*
 *      properties of the v_tc this module replaces).
 *   4a. The counters advance only while vtg_ce (v_axi4s_vid_out, slave mode)
 *      is high.  The vid_out synchronizer stalls the timing master while it
 *      waits for the stream SOF and fills its FIFO (CALN_SOF_VTG/CALN_SOF_FIFO
 *      states); a free-running generator never lets it reach FALN_LOCK
 *      (locked stays 0, DE never asserts: the permanent white screen).  The
 *      Xilinx v_tc gets the same handshake through gen_clken.
 *   5. vid_io_out_reset (to v_axi4s_vid_out) is held asserted until the
 *      id is latched and the pixel clock + timing have settled, then
 *      released synchronously in the selected pixel clock domain.
 *
 * The PS reads the latched id through axi_gpio_0 channel 2 to size the
 * framebuffer/VDMA; everything timing-related stays in the PL.
 *
 * Timing/clocking notes:
 *   - Both pixel clocks derive from the same VCO (phase-related), so the
 *     2-FF synchronizers crossing clk50 -> pixel domain are safe.
 *   - The BUFGMUX switch happens while vid_out is held in reset, before
 *     any data flows.
 *   - The id lines are sampled ~20 ms after reset release, long after the
 *     panel (powered seconds earlier) drives stable DC levels, and while
 *     DE has never asserted (VDMA not started yet).
 */
module lcd_panel_adapter (
    // RGB888 pads: driven while DE active, tri-stated (panel ID readback)
    inout  wire [23:0] lcd_data_io,
    input  wire [23:0] rgb_o,       // v_axi4s_vid_out vid_data
    input  wire        de_o,        // v_axi4s_vid_out vid_active_video
    // reset / clock
    input  wire        rst_in,      // rst50/peripheral_reset (active high)
    input  wire        clk50_in,    // FCLK_CLK1, fixed 50 MHz
    output wire        vid_rst_out, // -> vid_out vid_io_out_reset (active high)
    output wire        lcd_pclk,    // selected pixel clock
    input  wire        vtg_ce,      // v_axi4s_vid_out vtg_ce: timing enable
    // latched panel id for the PS (axi_gpio_0 channel 2)
    output wire [15:0] lcd_id,
    // video timing -> v_axi4s_vid_out vtiming_in (replaces v_tc_0).
    // Plain ports: the BD surgery script expands the vtiming_in interface
    // pin and wires these one by one (X_INTERFACE_INFO inference proved
    // unreliable for the video_timing bus across 2025.2 runs).
    output wire        vtiming_out_active_video,
    output wire        vtiming_out_field,
    output wire        vtiming_out_hblank,
    output wire        vtiming_out_hsync,
    output wire        vtiming_out_vblank,
    output wire        vtiming_out_vsync
);

    // ------------------------------------------------------------
    // RGB tri-state: drive only during active video, read ID otherwise.
    // Same scheme as the official lcd_rgb_char.v.
    // Explicit IOBUF primitives are MANDATORY here: OOC synthesis
    // (module_ref flow) silently degrades an inferred tristate
    // ("assign io = de ? x : 1'bz") into a LUT2 "de & x" + OBUF chain
    // with no pad readback, so the panel id always reads 0 (2026-10-12
    // white-screen case).  Primitives survive OOC synthesis untouched.
    // ------------------------------------------------------------
    (* MARK_DEBUG = "1" *) wire [23:0] id_pins;  // readback (panel ID in blanking)
    genvar gi;
    generate
        for (gi = 0; gi < 24; gi = gi + 1) begin : g_rgb_iobuf
            IOBUF u_iobuf (
                .I (rgb_o[gi]),
                .O (id_pins[gi]),
                .T (~de_o),
                .IO(lcd_data_io[gi])
            );
        end
    endgenerate

    // ------------------------------------------------------------
    // MMCM: 50 MHz in -> 50 MHz + 31.25 MHz out (common 1000 MHz VCO)
    // ------------------------------------------------------------
    wire rst50 = rst_in;
    (* MARK_DEBUG = "1" *) wire mmcm_locked;
    wire c50_raw, c31_raw;

    // MMCME2_ADV (not BASE): CLKIN2/CLKINSEL/CLKOUTxB ports exist only here;
    // static config behaves identically to BASE.
    MMCME2_ADV #(
        .BANDWIDTH        ("OPTIMIZED"),
        .CLKIN1_PERIOD    (20.0),       // 50 MHz
        .DIVCLK_DIVIDE    (1),
        .CLKFBOUT_MULT_F  (20.0),       // VCO = 1000 MHz
        .CLKOUT0_DIVIDE_F (20.0),       // 50.000 MHz
        .CLKOUT1_DIVIDE   (32),         // 31.250 MHz
        .CLKOUT0_PHASE    (0.0),
        .CLKOUT1_PHASE    (0.0),
        .STARTUP_WAIT     ("FALSE")
    ) u_mmcm (
        .CLKIN1    (clk50_in),
        .CLKIN2    (1'b0),
        .CLKINSEL  (1'b1),
        .CLKFBOUT  (mmcm_fb),
        .CLKFBOUTB (),
        .CLKOUT0   (c50_raw),
        .CLKOUT0B  (),
        .CLKOUT1   (c31_raw),
        .CLKOUT1B  (),
        .CLKOUT2   (),
        .CLKOUT2B  (),
        .CLKOUT3   (),
        .CLKOUT3B  (),
        .CLKOUT4   (),
        .CLKOUT5   (),
        .CLKOUT6   (),
        .CLKFBIN   (mmcm_fb),
        .LOCKED    (mmcm_locked),
        .PWRDWN    (1'b0),
        .RST       (rst50)
    );

    wire g50, g31;
    BUFG u_bufg50 (.I(c50_raw), .O(g50));
    BUFG u_bufg31 (.I(c31_raw), .O(g31));

    // ------------------------------------------------------------
    // ID sampling (50 MHz domain)
    // ------------------------------------------------------------
    reg [19:0] sample_cnt;
    (* MARK_DEBUG = "1" *) reg [15:0] id_reg;
    (* MARK_DEBUG = "1" *) reg        id_valid;
    reg [10:0] settle_cnt;
    (* MARK_DEBUG = "1" *) reg        id_settled;

    always @(posedge g50 or posedge rst50) begin
        if (rst50) begin
            sample_cnt <= 20'd0;
            id_reg     <= 16'd0;
            id_valid   <= 1'b0;
            settle_cnt <= 11'd0;
            id_settled <= 1'b0;
        end else if (!mmcm_locked) begin
            sample_cnt <= 20'd0;
        end else if (!id_valid) begin
            if (&sample_cnt) begin             // ~21 ms after lock
                id_valid <= 1'b1;
                case ({id_pins[7], id_pins[15], id_pins[23]})   // B7,G7,R7
                    3'b100:   id_reg <= 16'h4384;
                    3'b010:   id_reg <= 16'h7016;
                    default:  id_reg <= 16'h0000;   // unknown -> 4384 config
                endcase
            end else begin
                sample_cnt <= sample_cnt + 20'd1;
            end
        end else if (!id_settled) begin
            if (&settle_cnt) begin             // ~41 us for clock mux switch
                id_settled <= 1'b1;
            end else begin
                settle_cnt <= settle_cnt + 11'd1;
            end
        end
    end

    assign lcd_id = id_reg;

    // 4384 selection: latched 0x4384, or unknown id (0) default
    wire is4384_50 = (id_reg == 16'h4384) | (id_reg == 16'h0000);

    // ------------------------------------------------------------
    // Pixel clock mux (glitchless), switched while vid_out is in reset
    // ------------------------------------------------------------
    // 2-FF sync into the pixel domain happens after the mux, on the
    // quasi-static select and settle flags.  Before the id latches the
    // select stays at its default (4384), so no glitches occur until the
    // (still reset) settle window.
    wire sel4384;
    // BUFGMUX truth table: S=0 -> I0, S=1 -> I1.  sel4384 is 1 in 4384 mode,
    // so the port needs the inverted value.  Driving .S with sel4384 directly
    // (bug found 2026-10-12 after the first live 4.3" test) selected I1 = the
    // 50 MHz clock for the 4.3" panel: 97 fps, far out of the module spec ->
    // the panel never synced (white screen) and its ID lines stayed undriven
    // (id read 0x0).  ILA probes (mark_debug below) were added in the same
    // build to expose id_pins/id_reg/hcnt directly if anything still fails.
    BUFGMUX #(
        .CLK_SEL_TYPE("ASYNC")
    ) u_pclk_mux (
        .O (lcd_pclk),
        .I0(g31),        // S=0 -> 31.25 MHz (4384, and the power-on default)
        .I1(g50),        // S=1 -> 50.00 MHz (7016)
        .S (~sel4384)
    );

    (* MARK_DEBUG = "1" *) reg sel4384_meta, sel4384_sync;
    always @(posedge lcd_pclk or posedge rst50) begin
        if (rst50) begin
            sel4384_meta <= 1'b1;
            sel4384_sync <= 1'b1;
        end else begin
            sel4384_meta <= is4384_50;
            sel4384_sync <= sel4384_meta;
        end
    end
    assign sel4384 = sel4384_sync;

    reg settle_meta, settle_sync;
    always @(posedge lcd_pclk or posedge rst50) begin
        if (rst50) begin
            settle_meta <= 1'b0;
            settle_sync <= 1'b0;
        end else begin
            settle_meta <= id_settled;
            settle_sync <= settle_meta;
        end
    end

    // vid_out reset: asserted from rst_in until the pixel domain has seen
    // the settled id; released synchronously to lcd_pclk.
    wire vid_rst = rst50 | ~settle_sync;
    reg vid_rst_meta, vid_rst_sync;
    always @(posedge lcd_pclk or posedge vid_rst) begin
        if (vid_rst) begin
            vid_rst_meta <= 1'b1;
            vid_rst_sync <= 1'b1;
        end else begin
            vid_rst_meta <= 1'b0;
            vid_rst_sync <= vid_rst_meta;
        end
    end
    assign vid_rst_out = vid_rst_sync;

    // ------------------------------------------------------------
    // Timing generator (lcd_pclk domain), case-selected per panel
    // ------------------------------------------------------------
    wire pclk_rst = vid_rst_sync;

    // H: active / sync_start(active+fp) / sync_end(+pw) / total(+bp)
    wire [11:0] H_ACT  = sel4384 ? 12'd800  : 12'd1024;
    wire [11:0] H_SST  = sel4384 ? 12'd840  : 12'd1154;
    wire [11:0] H_SEN  = sel4384 ? 12'd888  : 12'd1184;
    wire [11:0] H_TOT  = sel4384 ? 12'd976  : 12'd1344;
    // V: active / sync_start / sync_end / total
    wire [11:0] V_ACT  = sel4384 ? 12'd480  : 12'd600;
    wire [11:0] V_SST  = sel4384 ? 12'd493  : 12'd602;
    wire [11:0] V_SEN  = sel4384 ? 12'd496  : 12'd612;
    wire [11:0] V_TOT  = sel4384 ? 12'd528  : 12'd635;

    (* MARK_DEBUG = "1" *) reg [11:0] hcnt;
    (* MARK_DEBUG = "1" *) reg [11:0] vcnt;
    always @(posedge lcd_pclk or posedge pclk_rst) begin
        if (pclk_rst) begin
            hcnt <= 12'd0;
            vcnt <= 12'd0;
        end else begin
            if (vtg_ce) begin
                if (hcnt >= H_TOT - 12'd1) begin
                    hcnt <= 12'd0;
                    vcnt <= (vcnt >= V_TOT - 12'd1) ? 12'd0 : vcnt + 12'd1;
                end else begin
                    hcnt <= hcnt + 12'd1;
                end
            end
        end
    end

    // HS/VS active low, DE active high (ATK RGB module spec)
    assign vtiming_out_active_video = (hcnt < H_ACT) & (vcnt < V_ACT);
    assign vtiming_out_field        = 1'b0;
    assign vtiming_out_hblank       = (hcnt >= H_ACT);
    assign vtiming_out_hsync        = ~((hcnt >= H_SST) & (hcnt < H_SEN));
    assign vtiming_out_vblank       = (vcnt >= V_ACT);
    assign vtiming_out_vsync        = ~((vcnt >= V_SST) & (vcnt < V_SEN));

endmodule

