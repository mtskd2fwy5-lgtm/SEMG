`timescale 1ns/1ps
module hdmi_scaler_tb;
    reg clk=0; always #5 clk=~clk;
    reg rstn=0;
    reg [15:0] panel;
    reg [23:0] sdata;
    reg sv=0,su=0,sl=0,mr=0;
    wire sr,mv,mu,ml,fault; wire [23:0] md;
    hdmi_scaler dut(clk,rstn,panel,1'b1,sdata,sv,sr,su,sl,md,mv,mr,mu,ml,fault);
    integer sw,sh,dw,leftx,ix,iy,ifrm,ox,oy,ofrm,cycles,accepted;
    reg [31:0] rng=32'hb9f56713;
    reg held=0; reg [25:0] hold_word;
    function [23:0] pix(input integer f,x,y);
        pix={8'(f+1),8'(x^y),8'(x+3*y)};
    endfunction
    task run_panel(input bit big_panel);
        begin
            rstn=0; sv=0; mr=0; held=0;
            panel=big_panel?16'h7016:16'h4384;
            sw=big_panel?1024:800; sh=big_panel?600:480;
            dw=big_panel?1228:1200; leftx=(1280-dw)/2;
            ix=0; iy=0; ifrm=0; ox=0; oy=0; ofrm=0; cycles=0; accepted=0;
            repeat(25) @(negedge clk); rstn=1; // UNISIM global reset ends at 100ns.
            while(ofrm<3) begin
                // Producer and consumer each introduce independent random stalls.
                rng={rng[30:0],rng[31]^rng[21]^rng[1]^rng[0]};
                if (!sv || sr) begin
                    sv=(ifrm<3 && rng[2:0]!=0);
                    su=(ix==0 && iy==0); sl=(ix==sw-1); sdata=pix(ifrm,ix,iy);
                end
                mr=(rng[7:4]!=0);
                @(posedge clk);
                if (held && {mu,ml,md}!==hold_word) $fatal(1,"AXIS stall changed payload");
                held=mv&&!mr; hold_word={mu,ml,md};
                if (fault) $fatal(1,"unexpected framing fault");
                if (sv && sr) begin
                    if (ix==sw-1) begin ix=0; if(iy==sh-1)begin iy=0; ifrm++; end else iy++; end
                    else ix++;
                end
                if (mv && mr) begin
                    if (mu!==(ox==0&&oy==0) || ml!==(ox==1279)) $fatal(1,"SOF/EOL mismatch");
                    if (md !== ((ox<leftx||ox>=leftx+dw)?24'd0:pix(ofrm,(ox-leftx)*sw/dw,oy*sh/720)))
                        $fatal(1,"pixel mismatch panel=%h f=%0d x=%0d y=%0d data=%h",panel,ofrm,ox,oy,md);
                    accepted++;
                    if (ox==1279) begin ox=0; if(oy==719)begin oy=0;ofrm++;end else oy++;end
                    else ox++;
                end
                cycles++;
                if(cycles>4000000) $fatal(1,"stream deadlock");
                @(negedge clk);
            end
            $display("TEST_PASS HDMI scaler %0dx%0d: %0d exact pixels, stalls, three frames",sw,sh,accepted);
            // Reset in the middle of a buffered frame, then validate sticky fault.
            rstn=0; repeat(4) @(negedge clk);rstn=1;
            sv=1;su=0;sl=0;sdata=0;mr=1;
            @(negedge clk); sv=0;
            repeat(5) @(negedge clk);
            if(!fault || sr || mv) $fatal(1,"malformed frame not isolated");
        end
    endtask
    initial begin run_panel(0);run_panel(1);$display("TEST_PASS HDMI scaler complete");$finish;end
endmodule


