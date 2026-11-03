`timescale 1ns/1ps
// SPDX-License-Identifier: Apache-2.0
// Two-line RGB888 nearest-neighbour scaler. One elastic output register;
// AXIS data and markers remain stable under arbitrary downstream stalls.
// 4384: 800x480 -> 1200x720 + 40px borders.
// 7016: 1024x600 -> 1228x720 + 26px borders (integer aspect rounding).
module hdmi_scaler (
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF s_axis:m_axis, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000" *)
    input wire aclk,
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *) input wire aresetn,
    input wire [15:0] panel_id,
    input wire run,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TDATA" *) input wire [23:0] s_data,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TVALID" *) input wire s_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TREADY" *) output wire s_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TUSER" *) input wire s_user,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TLAST" *) input wire s_last,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TDATA" *) output wire [23:0] m_data,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TVALID" *) output reg m_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TREADY" *) input wire m_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TUSER" *) output reg m_user,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TLAST" *) output reg m_last,
    output reg fault
);
    // The panel ID latches once in the 50MHz panel domain. Synchronize the
    // single mode bit before enabling DMA (PS waits for panel detection).
    (* ASYNC_REG="TRUE" *) reg panel_meta,panel_sync;
    always @(posedge aclk) begin
        if(!aresetn) begin panel_meta<=0;panel_sync<=0;end
        else begin panel_meta<=panel_id==16'h7016;panel_sync<=panel_meta;end
    end
    wire large_panel = panel_sync;
    wire [10:0] sw = large_panel ? 11'd1024 : 11'd800;
    wire [9:0] sh = large_panel ? 10'd600 : 10'd480;
    wire [10:0] dw = large_panel ? 11'd1228 : 11'd1200;
    wire [10:0] left_edge = large_panel ? 11'd26 : 11'd40;
    wire [10:0] right_edge = left_edge + dw;
    (* ram_style = "block" *) reg [23:0] line0 [0:1023];
    (* ram_style = "block" *) reg [23:0] line1 [0:1023];
    reg [1:0] full;
    reg wb, rb;
    reg [10:0] wx, ox, sx, xp;
    reg [9:0] wy, oy, yp;
    wire [11:0] xsum = {1'b0,xp} + {1'b0,sw};
    wire [10:0] ysum = {1'b0,yp} + {1'b0,sh};
    wire in_active = ox >= left_edge && ox < right_edge;
    reg [23:0] q0,q1;
    reg output_black,output_bank;
    wire read_en=(!m_valid || m_ready) && full[rb] && !fault;
    assign s_ready = !full[wb] && !fault;
    // Keep reset/blanking/mux logic outside the synchronous memory read
    // ports. Putting it on the memory output prevents 7-series BRAM inference.
    always @(posedge aclk) begin
        if (aresetn && run && s_valid && s_ready) begin
            if (wb) line1[wx[9:0]]<=s_data;
            else line0[wx[9:0]]<=s_data;
        end
        if (read_en) begin
            q0<=line0[sx[9:0]];
            q1<=line1[sx[9:0]];
        end
    end
    assign m_data=output_black ? 24'd0 : (output_bank ? q1 : q0);
    always @(posedge aclk) begin
        if (!aresetn || !run) begin
            full<=0; wb<=0; rb<=0; wx<=0; wy<=0;
            ox<=0; oy<=0; sx<=0; xp<=0; yp<=0;
            m_valid<=0; output_black<=1; output_bank<=0;
            m_user<=0; m_last<=0; fault<=0;
        end else begin
            if (s_valid && s_ready) begin
                if (s_user != (wx==0 && wy==0) || s_last != (wx==sw-1'b1))
                    fault<=1;
                if (wx==sw-1'b1) begin
                    full[wb]<=1; wb<=!wb; wx<=0;
                    wy<=wy==sh-1'b1 ? 10'd0 : wy+1'b1;
                end else wx<=wx+1'b1;
            end
            if (!m_valid || m_ready) begin
                m_valid<=full[rb] && !fault;
                if (full[rb] && !fault) begin
                    // Synchronous BRAM read, selected in the output register.
                    output_black<=!in_active;output_bank<=rb;
                    m_user<=ox==0 && oy==0;
                    m_last<=ox==1279;
                    if (in_active) begin
                        if (xsum >= {1'b0,dw}) begin
                            sx<=sx+1'b1; xp<=xsum-{1'b0,dw};
                        end else xp<=xsum[10:0];
                    end
                    if (ox==1279) begin
                        ox<=0; sx<=0; xp<=0;
                        oy<=oy==719 ? 10'd0 : oy+1'b1;
                        if (ysum>=720) begin
                            full[rb]<=0; rb<=!rb; yp<=ysum-720;
                        end else yp<=ysum[9:0];
                    end else ox<=ox+1'b1;
                end
            end
        end
    end
endmodule

