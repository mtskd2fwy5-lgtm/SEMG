`timescale 1ns/1ps
// Timing-only harness: exclude serializers already tested separately with
// real UNISIM master/slave cascades, so two full rasters simulate quickly.
// Never add this module to sources_1 or any synthesis input.
module hdmi_serializer(input wire pixel_clk,serial_clk,rst,
    input wire [9:0] symbol,output wire out_p,out_n);
    assign out_p=1'b0;
    assign out_n=1'b1;
endmodule
