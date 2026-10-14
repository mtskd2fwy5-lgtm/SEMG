// Restore AXI4-Stream video SOF when the MM2S VDMA never emits TUSER.
// The VDMA still supplies TLAST at the end of each active line.  For the
// current ATK-4384 panel, a frame is 480 lines; mark the first beat after
// reset and after every complete 480-line frame.
module axis_sof_repair #(
    parameter integer FRAME_WIDTH = 800,
    parameter integer FRAME_LINES = 480
) (
    input  wire        aclk,
    input  wire        aresetn,
    input  wire [23:0] s_tdata,
    input  wire        s_tlast,
    input  wire        s_tuser,
    input  wire        s_tvalid,
    output wire        s_tready,
    output wire [23:0] m_tdata,
    output wire        m_tlast,
    output wire        m_tuser,
    output wire        m_tvalid,
    input  wire        m_tready
);

    reg [18:0] pixel_count;
    wire      transfer = s_tvalid & m_tready;

    assign s_tready = m_tready;
    assign m_tdata  = s_tdata;
    assign m_tlast  = s_tlast;
    assign m_tvalid = s_tvalid;
    // Do not depend on VDMA TLAST: the failing VDMA configuration can keep
    // its internal frame/line sync suppressed while still streaming pixels.
    // A fixed pixel count gives the video-out core a recurring SOF anyway.
    assign m_tuser  = s_tuser | (s_tvalid && (pixel_count == 0));

    always @(posedge aclk) begin
        if (!aresetn) begin
            pixel_count <= 19'd0;
        end else if (transfer) begin
            if (pixel_count == FRAME_WIDTH * FRAME_LINES - 1) begin
                pixel_count <= 19'd0;
            end else begin
                pixel_count <= pixel_count + 19'd1;
            end
        end
    end
endmodule
