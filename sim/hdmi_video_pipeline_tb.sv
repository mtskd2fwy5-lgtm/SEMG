`timescale 1ns/1ps
// Actual generated AXI4-Stream to Video Out IP, scaler and MMCM/timing.
// Serializers have their own UNISIM bit-accurate test; this harness stubs
// only that already-tested endpoint to keep full raster simulation bounded.
module hdmi_video_pipeline_tb;
    reg clk=0;always #5 clk=~clk;
    reg rst=1,run=0;
    wire px,vr,srn,av,f,hb,hs,vb,vs,ce,locked,uf,of;
    wire de,vhs,vvs,vhb,vvb;wire [23:0] rgb;
    wire [31:0] status;wire [2:0] dp,dn;wire cp,cn;
    reg [23:0] sd;reg sv=0,su=0,sl=0;
    wire sr,mv,mr,mu,ml,fault;wire [23:0] md;
    hdmi_scaler scaler(clk,!rst,16'h4384,run,sd,sv,sr,su,sl,md,mv,mr,mu,ml,fault);
    hdmi_output timing(.clk100(clk),.rst(rst),.run(run),.pixel_clk(px),.video_rst(vr),.stream_resetn(srn),
        .vtg_ce(ce),.active_video(av),.field_id(f),.hblank(hb),.hsync(hs),.vblank(vb),.vsync(vs),
        .rgb(rgb),.de(de),.video_hsync(vhs),.video_vsync(vvs),.hpd(1'b1),
        .video_locked(locked),.underflow(uf),.overflow(of),.scaler_fault(fault),
        .status(status),.hdmi_data_p(dp),.hdmi_data_n(dn),.hdmi_clk_p(cp),.hdmi_clk_n(cn));
    design_1_video_out_hdmi_0 video(.aclk(clk),.aclken(1'b1),.aresetn(srn),
        .s_axis_video_tdata(md),.s_axis_video_tvalid(mv),.s_axis_video_tready(mr),
        .s_axis_video_tuser(mu),.s_axis_video_tlast(ml),.fid(1'b0),
        .vid_io_out_clk(px),.vid_io_out_ce(1'b1),.vid_io_out_reset(vr),
        .vid_active_video(de),.vid_hsync(vhs),.vid_vsync(vvs),.vid_hblank(vhb),.vid_vblank(vvb),
        .vid_data(rgb),.vtg_active_video(av),.vtg_hsync(hs),.vtg_vsync(vs),
        .vtg_hblank(hb),.vtg_vblank(vb),.vtg_field_id(f),.vtg_ce(ce),
        .locked(locked),.overflow(of),.underflow(uf));
    function [23:0] pixel(input integer x,y);
        pixel={8'(x+3*y),8'(x^y),8'(y+17)};
    endfunction
    integer ix=0,iy=0,ox=0,oy=0,count=0;
    reg [31:0] rng=32'hf17ca035;
    reg saw_blank=0,armed=0,prev_blank=0;
    always @(negedge clk) begin
        if(rst||!run)begin sv=0;ix=0;iy=0;end
        else if(!sv||sr)begin
            sv=rng[3:0]!=0;su=ix==0&&iy==0;sl=ix==799;sd=pixel(ix,iy);
        end
        rng={rng[30:0],rng[31]^rng[21]^rng[1]^rng[0]};
    end
    always @(posedge clk)if(!rst&&run&&sv&&sr)begin
        if(ix==799)begin ix=0;iy=iy==479?0:iy+1;end else ix++;
    end
    always @(negedge px)begin
        if(vr)begin saw_blank=0;armed=0;prev_blank=0;end
        else begin
            if(locked&&vvb)saw_blank=1;
            if(saw_blank&&prev_blank&&!vvb)armed=1;
            prev_blank=vvb;
            if(armed)begin
                if(!locked||uf||of||fault)$fatal(1,"video pipeline lost lock or overflow/underflow");
                if(de)begin
                    if(rgb!==((ox<40||ox>=1240)?24'd0:pixel((ox-40)*800/1200,oy*480/720)))
                        $fatal(1,"video pixel mismatch x=%0d y=%0d got=%h",ox,oy,rgb);
                    count++;
                    if(ox==1279)begin ox=0;oy++;end else ox++;
                    if(count==921600)begin
                        $display("TEST_PASS HDMI video pipeline: actual Video Out IP, MMCM, scaler, 921600 exact RGB pixels after lock, randomized AXIS bubbles");
                        $finish;
                    end
                end
            end
        end
    end
    initial begin #250;rst=0;repeat(20)@(negedge clk);run=1;end
    initial begin #250000000;$fatal(1,"video pipeline did not lock or finish");end
endmodule
