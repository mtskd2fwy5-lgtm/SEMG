/*
 * Forward the 50 MHz pixel clock to the RGB LCD, phase-inverted (UG471
 * clock forwarding via ODDR).
 *
 * axi4stream_vid_out launches vid_io data on the rising edge of
 * vid_io_clk (= FCLK_CLK1).  The ATK 7" panel latches DE/HS/VS/RGB on
 * the rising edge of its DCLK input, so DCLK must be the inverse of
 * vid_io_clk: every pin then has half a pixel period (10 ns) of setup
 * and hold at the LCD.  Routing the inverted clock through the IOB
 * keeps its skew against the IOB-registered data pins near zero.
 */
module lcd_clk_fwd (
    input  wire clk_in,    // 50 MHz pixel clock (FCLK_CLK1)
    output wire clk_out    // LCD DCLK, inverted
);

    ODDR #(
        .DDR_CLK_EDGE ("SAME_EDGE"),
        .INIT         (1'b0),
        .SRTYPE       ("ASYNC")
    ) oddr_lcd_dclk (
        .Q  (clk_out),
        .C  (clk_in),
        .CE (1'b1),
        .D1 (1'b0),   // Q -> 0 on rising edge
        .D2 (1'b1),   // Q -> 1 on falling edge  => Q = ~clk_in
        .R  (1'b0),
        .S  (1'b0)
    );

endmodule
