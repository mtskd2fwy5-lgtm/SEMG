`timescale 1ns/1ps
// Public fields and valid timing must match the pre-optimization implementation.
module feature_width_case #(
 parameter integer W=400,H=100,SHIFT=12,THRESHOLD=0,SEED=1
)(output reg done=0);
 reg clk=0,rst_n=0,sample_valid=0;
 reg signed [23:0] sample_in=0;
 wire av,bv;
 wire [31:0] am,aw,ae,az,as_,bm,bw,be,bz,bs;
 integer n,windows=0,resets=0,accepted=0,cycles=0;
 integer first_cycle=-1,last_cycle=-1,continuous_windows=0;
 reg compare_ready=0,expected_valid;
 reg [31:0] rng=SEED;
 always #5 clk=~clk;
`ifdef FEATURE_NETLIST
 emg_window_features
`else
 emg_window_features #(.WINDOW_SAMPLES(W),.HOP_SAMPLES(H),
 .RMS_INPUT_SHIFT(SHIFT),.ZC_THRESHOLD(THRESHOLD),.SSC_THRESHOLD(THRESHOLD))
`endif
 candidate(.clk(clk),.rst_n(rst_n),.sample_valid(sample_valid),.sample_in(sample_in),
 .window_valid(av),.mav_sum(am),.wl_sum(aw),.energy_sum(ae),.zc_count(az),.ssc_count(as_));
 emg_window_features_baseline #(.WINDOW_SAMPLES(W),.HOP_SAMPLES(H),
 .RMS_INPUT_SHIFT(SHIFT),.ZC_THRESHOLD(THRESHOLD),.SSC_THRESHOLD(THRESHOLD))
 baseline(.clk(clk),.rst_n(rst_n),.sample_valid(sample_valid),.sample_in(sample_in),
 .window_valid(bv),.mav_sum(bm),.wl_sum(bw),.energy_sum(be),.zc_count(bz),.ssc_count(bs));
 always @(posedge clk) begin
  #1;
  if(!done && compare_ready)begin
   if({av,am,aw,ae,az,as_} !== {bv,bm,bw,be,bz,bs})
    $fatal(1,"feature mismatch W=%0d H=%0d n=%0d",W,H,n);
   cycles=cycles+1;
   expected_valid=0;
   if(!rst_n)accepted=0;
   else if(sample_valid)begin
    accepted=accepted+1;
    expected_valid=(accepted>=W && ((accepted-W)%H)==0);
    if(first_cycle<0)first_cycle=cycles;
   end
   if(av !== expected_valid)$fatal(1,"feature cadence mismatch W=%0d H=%0d accepted=%0d",W,H,accepted);
   if(av)begin
    windows=windows+1;
    if(az>W || as_>W)$fatal(1,"event bound violated");
    if(resets==0 && accepted<=12000)begin
     if(continuous_windows==0 && cycles-first_cycle!=W-1)
      $fatal(1,"first feature latency changed");
     if(continuous_windows>0 && cycles-last_cycle!=H)
      $fatal(1,"continuous feature interval changed");
     last_cycle=cycles;continuous_windows=continuous_windows+1;
    end
   end
  end
 end
 initial begin
  // Also cover synthesized primitives, whose global startup reset is 100 ns.
  repeat(20)@(negedge clk);compare_ready=1;rst_n=1;
  for(n=0;n<80000;n=n+1)begin
   @(negedge clk);
   rng=rng^(rng<<13);rng=rng^(rng>>17);rng=rng^(rng<<5);
   sample_valid=(n<12000 || rng[3:0]!=0);
   case(n/4000)
    0:sample_in=n[0]?24'sh7fffff:24'sh800000;
    1:sample_in=0;
    2:sample_in=n[0]?24'sd1:-24'sd1;
    3:sample_in=n%97-48;
    default:sample_in=rng[23:0];
   endcase
   if(n==20001 || n==47777 || n==63000)begin
    rst_n=0;resets=resets+1;
   end else rst_n=1;
  end
  @(negedge clk);sample_valid=0;repeat(4)@(negedge clk);
  if(windows<20 || resets!=3 || continuous_windows!=(12000-W)/H+1)
   $fatal(1,"incomplete feature test");
  done=1;
  $display("TEST_PASS feature widths W=%0d H=%0d shift=%0d windows=%0d",W,H,SHIFT,windows);
  $display("TEST_PASS performance W=%0d H=%0d consecutive_samples=12000 first_span_cycles=%0d output_interval_cycles=%0d continuous_windows=%0d",W,H,W-1,H,continuous_windows);
 end
endmodule
module emg_feature_width_equiv_tb;
 wire [3:0] done;
 feature_width_case #(.W(400),.H(100),.SEED(32'h7925)) actual(done[0]);
`ifdef FEATURE_NETLIST
 assign done[3:1]=3'b111;
`else
 feature_width_case #(.W(8),.H(4),.SHIFT(0),.SEED(32'h12ab)) small_window(done[1]);
 feature_width_case #(.W(63),.H(9),.SHIFT(5),.THRESHOLD(17),.SEED(32'h9912)) odd(done[2]);
 feature_width_case #(.W(1),.H(1),.SHIFT(23),.SEED(32'h3412)) unit_window(done[3]);
`endif
 initial begin wait(&done);$display("TEST_PASS feature width equivalence complete");$finish;end
 initial begin #1000000;$fatal(1,"feature equivalence watchdog");end
endmodule

