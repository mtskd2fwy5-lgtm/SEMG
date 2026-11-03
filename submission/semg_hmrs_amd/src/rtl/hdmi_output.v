`timescale 1ns/1ps
// SPDX-License-Identifier: Apache-2.0
// Fixed CEA 720p60 RGB/DVI-compatible output (no audio, no DDC master).
module hdmi_output (
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 100000000" *) input wire clk100,
    input wire rst, run,
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 74250000, ASSOCIATED_RESET video_rst" *) output wire pixel_clk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 video_rst RST", X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *) output wire video_rst,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 stream_resetn RST", X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *) output wire stream_resetn,
    input wire vtg_ce,
    output wire active_video, field_id, hblank, hsync, vblank, vsync,
    input wire [23:0] rgb,
    input wire de, video_hsync, video_vsync,
    input wire hpd, video_locked, underflow, overflow, scaler_fault,
    output wire [31:0] status,
    output wire [2:0] hdmi_data_p, hdmi_data_n,
    output wire hdmi_clk_p, hdmi_clk_n
);
    wire fb, fb_buf, px_raw, fast_raw, fast, locked;
    assign stream_resetn=!rst && run;
    MMCME2_BASE #(.CLKIN1_PERIOD(10.0),.DIVCLK_DIVIDE(5),
        .CLKFBOUT_MULT_F(37.125),.CLKOUT0_DIVIDE_F(10.0),.CLKOUT1_DIVIDE(2),
        .STARTUP_WAIT("FALSE")) mmcm (
        .CLKIN1(clk100),.RST(rst),.PWRDWN(1'b0),.CLKFBIN(fb_buf),
        .CLKFBOUT(fb),.CLKFBOUTB(),.CLKOUT0(px_raw),.CLKOUT0B(),
        .CLKOUT1(fast_raw),.CLKOUT1B(),.CLKOUT2(),.CLKOUT2B(),
        .CLKOUT3(),.CLKOUT3B(),.CLKOUT4(),.CLKOUT5(),.CLKOUT6(),.LOCKED(locked));
    BUFG fbclk (.I(fb),.O(fb_buf));
    BUFG pxclk (.I(px_raw),.O(pixel_clk));
    BUFG serclk (.I(fast_raw),.O(fast));
    (* ASYNC_REG="TRUE" *) reg [3:0] reset_sync;
    always @(posedge pixel_clk or posedge rst or negedge locked or negedge run)
        if (rst || !locked || !run) reset_sync<=4'b1111;
        else reset_sync<={reset_sync[2:0],1'b0};
    assign video_rst=reset_sync[3];
    reg [10:0] x;
    reg [9:0] y;
    always @(posedge pixel_clk) begin
        if (video_rst) begin x<=0; y<=0; end
        else if (vtg_ce) begin
            if (x==1649) begin x<=0; y<=y==749 ? 10'd0 : y+1'b1; end
            else x<=x+1'b1;
        end
    end
    assign hblank=x>=1280;
    assign vblank=y>=720;
    assign active_video=!hblank && !vblank;
    assign field_id=1'b0;
    assign hsync=x>=1390 && x<1430;
    assign vsync=y>=725 && y<730;
    wire [9:0] red, green, blue;
    hdmi_tmds_encoder r(pixel_clk,video_rst,de,1'b0,1'b0,rgb[23:16],red);
    hdmi_tmds_encoder g(pixel_clk,video_rst,de,1'b0,1'b0,rgb[15:8],green);
    hdmi_tmds_encoder b(pixel_clk,video_rst,de,video_hsync,video_vsync,rgb[7:0],blue);
    hdmi_serializer sr(pixel_clk,fast,video_rst,red,hdmi_data_p[2],hdmi_data_n[2]);
    hdmi_serializer sg(pixel_clk,fast,video_rst,green,hdmi_data_p[1],hdmi_data_n[1]);
    hdmi_serializer sb(pixel_clk,fast,video_rst,blue,hdmi_data_p[0],hdmi_data_n[0]);
    hdmi_serializer sc(pixel_clk,fast,video_rst,10'b1111100000,hdmi_clk_p,hdmi_clk_n);
    // Independent status bits only; no multi-bit sampled counter crossing.
    (* ASYNC_REG="TRUE" *) reg [5:0] stat_meta, stat_sync;
    always @(posedge clk100) begin
        if (rst) begin stat_meta<=0; stat_sync<=0; end
        else begin
            stat_meta<={scaler_fault,overflow,underflow,hpd,video_locked,locked};
            stat_sync<=stat_meta;
        end
    end
    assign status={16'h4844,10'd0,stat_sync};
endmodule

