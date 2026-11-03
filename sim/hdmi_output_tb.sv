`timescale 1ns/1ps
module hdmi_output_tb;
    reg clk=0;always #5 clk=~clk;
    reg rst=1,run=0,ce=1,hpd=0;
    wire px,vr,srn,av,f,hb,hs,vb,vs;
    wire[31:0]status;wire[2:0]dp,dn;wire cp,cn;
    hdmi_output dut(.clk100(clk),.rst(rst),.run(run),.pixel_clk(px),.video_rst(vr),.stream_resetn(srn),
        .vtg_ce(ce),.active_video(av),.field_id(f),.hblank(hb),.hsync(hs),.vblank(vb),.vsync(vs),
        .rgb(24'hf0832b),.de(av),.video_hsync(hs),.video_vsync(vs),
        .hpd(hpd),.video_locked(1'b1),.underflow(1'b0),.overflow(1'b0),.scaler_fault(1'b0),
        .status(status),.hdmi_data_p(dp),.hdmi_data_n(dn),.hdmi_clk_p(cp),.hdmi_clk_n(cn));
    integer x,y,n,pixels,hsn,vsn;real t0,t1;
    task verify_frame;
        begin
            pixels=0;hsn=0;vsn=0;
            for(y=0;y<750;y++)for(x=0;x<1650;x++)begin
                if(av!==(x<1280&&y<720)||hb!==(x>=1280)||vb!==(y>=720)||
                   hs!==(x>=1390&&x<1430)||vs!==(y>=725&&y<730)||f!==0)
                    $fatal(1,"720p timing mismatch at %0d,%0d",x,y);
                pixels+=av;hsn+=hs;vsn+=vs;
                @(negedge px);
            end
            if(pixels!=921600||hsn!=30000||vsn!=8250)$fatal(1,"CEA raster counts incorrect");
        end
    endtask
    initial begin
        #150;rst=0;run=1;
        wait(!vr);@(negedge px);
        // Hold timing as the actual video-out startup synchronizer does.
        ce=0;repeat(50)@(negedge px);
        if(dut.x!=0||dut.y!=0)$fatal(1,"VTG gate ignored");
        ce=1;t0=$realtime;verify_frame();t1=$realtime;
        if(t1-t0<16660000||t1-t0>16675000)$fatal(1,"720p clock/frame frequency incorrect: %f",t1-t0);
        hpd=1;repeat(5)@(negedge clk);if(status[2]!==1||status[31:16]!==16'h4844)$fatal(1,"HPD status CDC");
        run=0;repeat(12)@(negedge px);
        if(!vr||srn||dut.x!=0||dut.y!=0)$fatal(1,"stream reset not complete");
        run=1;wait(!vr);@(negedge px);verify_frame();
        $display("TEST_PASS HDMI output: UNISIM MMCM 74.25/371.25MHz, exact 1650x750 CEA 720p raster, VTG gate, HPD CDC, stop/restart");$finish;
    end
    initial begin #50000000;$fatal(1,"HDMI MMCM or output deadlock");end
endmodule
