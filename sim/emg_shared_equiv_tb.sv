`timescale 1ns/1ps
module shared_feature_case #(parameter W=400,H=100,SHIFT=12,THRESH=0,BYPASS=1)(output reg done=0);
 reg clk=0,rst_n=0,valid=0,ready=0,started=0;
 reg [2:0] channel=0;
 reg signed [23:0] data=0;
 reg [31:0] rng=32'h1892ac35;
 integer n,c,windows=0,words=0;
 always #5 clk=~clk;
 wire sv;wire [2:0] sc;wire [31:0] sm,sw,se,sz,ss;
 wire [7:0] rv;wire [31:0] rm[0:7],rw[0:7],re_[0:7],rz[0:7],rs[0:7];
 emg_window_features_shared #(.WINDOW_SAMPLES(W),.HOP_SAMPLES(H),.RMS_INPUT_SHIFT(SHIFT),
 .ZC_THRESHOLD(THRESH),.SSC_THRESHOLD(THRESH)) dut(
 .clk(clk),.rst_n(rst_n),.sample_valid(valid),.sample_channel(channel),.sample_in(data),
 .window_valid(sv),.window_channel(sc),.mav_sum(sm),.wl_sum(sw),.energy_sum(se),.zc_count(sz),.ssc_count(ss));
 genvar g;
 generate for(g=0;g<8;g=g+1)begin : scalar
  emg_window_features_reference #(.WINDOW_SAMPLES(W),.HOP_SAMPLES(H),.RMS_INPUT_SHIFT(SHIFT),
  .ZC_THRESHOLD(THRESH),.SSC_THRESHOLD(THRESH)) ref_core(
  .clk(clk),.rst_n(rst_n),.sample_valid(valid && channel==g),.sample_in(data),
  .window_valid(rv[g]),.mav_sum(rm[g]),.wl_sum(rw[g]),.energy_sum(re_[g]),.zc_count(rz[g]),.ssc_count(rs[g]));
 end endgenerate
 wire av,bv;wire [3:0] ai,bi;wire [2:0] ac,bc;wire [31:0] ad,bd;wire [15:0] aq,bq;
 emg_feature_bank #(.BYPASS_BANDPASS(BYPASS),.WINDOW_SAMPLES(W),.HOP_SAMPLES(H),.RMS_INPUT_SHIFT(SHIFT),
 .ZC_THRESHOLD(THRESH),.SSC_THRESHOLD(THRESH)) bank(
 .clk(clk),.rst_n(rst_n),.sample_valid(valid),.sample_channel(channel),.sample_data(data),.feature_ready(ready),
 .feature_valid(av),.feature_id(ai),.feature_channel(ac),.feature_data(ad),.feature_sequence(aq));
 emg_feature_bank_reference #(.BYPASS_BANDPASS(BYPASS),.WINDOW_SAMPLES(W),.HOP_SAMPLES(H),.RMS_INPUT_SHIFT(SHIFT),
 .ZC_THRESHOLD(THRESH),.SSC_THRESHOLD(THRESH)) ref_bank(
 .clk(clk),.rst_n(rst_n),.sample_valid(valid),.sample_channel(channel),.sample_data(data),.feature_ready(ready),
 .feature_valid(bv),.feature_id(bi),.feature_channel(bc),.feature_data(bd),.feature_sequence(bq));
 always @(posedge clk)begin
  #1;
  if(started && !done)begin
   if(sv !== (|rv))$fatal(1,"shared feature valid W=%0d n=%0d",W,n);
   for(c=0;c<8;c=c+1)if(rv[c])begin
    if(sc!==c || {sm,sw,se,sz,ss} !== {rm[c],rw[c],re_[c],rz[c],rs[c]})
     $fatal(1,"shared feature data W=%0d n=%0d ch=%0d got=%h ref=%h",W,n,c,{sm,sw,se,sz,ss},{rm[c],rw[c],re_[c],rz[c],rs[c]});
    windows=windows+1;
   end
   if({av,ai,ac,ad,aq} !== {bv,bi,bc,bd,bq})
    $fatal(1,"shared bank cycle/data W=%0d n=%0d got=%h ref=%h",W,n,{av,ai,ac,ad,aq},{bv,bi,bc,bd,bq});
   if(av && ready)words=words+1;
  end
 end
 initial begin
  repeat(20)@(negedge clk);rst_n=1;started=1;
  for(n=0;n<80000;n=n+1)begin
   @(negedge clk);
   rng=rng^(rng<<13);rng=rng^(rng>>17);rng=rng^(rng<<5);
   // Long same-channel dependency chains, round robin, random order,
   // and native-rate spacing, then bounded and prolonged backpressure.
   if(n<4000)channel=0;
   else if(n<12000)channel=n[2:0];
   else channel=rng[2:0];
   valid=n<20000 || (n<50000 ? rng[5:3]!=0 : n%12==0);
   ready=(n%1900<1750) && rng[8:6]!=0;
   case(n/4000)
    0:data=n[0]?24'sh7fffff:24'sh800000;
    1:data=0;
    2:data=n[0]?24'sd1:-24'sd1;
    3:data=n%97-48;
    default:data=rng[23:0];
   endcase
   rst_n=!(n==25003 || n==59017 || (n>=63000 && n<63003));
  end
  @(negedge clk);valid=0;ready=1;rst_n=1;repeat(150)@(negedge clk);
  if(windows<20 || words<20)$fatal(1,"incomplete shared feature test");
  done=1;$display("TEST_PASS shared feature W=%0d H=%0d windows=%0d words=%0d cycle-exact II=1",W,H,windows,words);
 end
endmodule

module shared_bandpass_case #(parameter FRAC=1)(output reg done=0);
 reg clk=0,rst_n=0,valid=0,started=0;reg [2:0] channel=0,expected_channel=0;
 reg signed [23:0] data=0;reg [31:0] rng=32'h98ed76ac;
 integer n,c,count=0;always #5 clk=~clk;
 wire av;wire signed [23:0] ad;wire [7:0] bv;wire signed [23:0] bd[0:7];
 emg_bandpass_shared #(.FRACTION_SAVE(FRAC)) dut(.clk(clk),.rst_n(rst_n),.sample_valid(valid),
 .sample_channel(channel),.sample_in(data),.filtered_valid(av),.filtered_out(ad));
 genvar g;generate for(g=0;g<8;g=g+1)begin : scalar
  emg_bandpass_reference #(.FRACTION_SAVE(FRAC)) ref_filter(.clk(clk),.rst_n(rst_n),
  .sample_valid(valid && channel==g),.sample_in(data),.filtered_valid(bv[g]),.filtered_out(bd[g]));
 end endgenerate
 always @(posedge clk)begin
  #1;
  if(started && !done)begin
   if(av !== (|bv))$fatal(1,"shared bandpass valid frac=%0d n=%0d",FRAC,n);
   for(c=0;c<8;c=c+1)if(bv[c])begin
    if(ad!==bd[c])$fatal(1,"shared bandpass data frac=%0d n=%0d ch=%0d got=%h ref=%h",FRAC,n,c,ad,bd[c]);
    count=count+1;
   end
  end
 end
 initial begin
  repeat(20)@(negedge clk);started=1;rst_n=1;
  for(n=0;n<80000;n=n+1)begin
   @(negedge clk);rng=rng^(rng<<13);rng=rng^(rng>>17);rng=rng^(rng<<5);
   channel=n<4000?0:(n<12000?n[2:0]:rng[2:0]);
   valid=n<20000 || rng[7:3]!=0;
   case(n/4000)
    0:data=n[0]?24'sh7fffff:24'sh800000;
    1:data=24'sd1000;
    2:data=n[0]?24'sd1:-24'sd1;
    3:data=0;
    default:data=rng[23:0];
   endcase
   rst_n=!(n==25003 || n==59017 || (n>=63000 && n<63003));
  end
  @(negedge clk);valid=0;repeat(4)@(negedge clk);
  if(count<50000)$fatal(1,"incomplete shared bandpass test");
  done=1;$display("TEST_PASS shared bandpass fraction=%0d beats=%0d cycle-exact II=1",FRAC,count);
 end
endmodule

module emg_shared_equiv_tb;
 wire [6:0] done;
 shared_feature_case main_case(done[0]);
 shared_feature_case #(.W(8),.H(4),.SHIFT(0)) power_two(done[1]);
 shared_feature_case #(.W(63),.H(9),.SHIFT(5),.THRESH(17)) odd_case(done[2]);
 shared_feature_case #(.W(1),.H(1),.SHIFT(23)) single_case(done[3]);
 shared_bandpass_case #(.FRAC(0)) classic(done[4]);
 shared_bandpass_case #(.FRAC(1)) fractions(done[5]);
 shared_feature_case #(.BYPASS(0)) local_bandpass(done[6]);
 initial begin wait(&done);$display("TEST_PASS shared arithmetic equivalence complete");$finish;end
 initial begin #1000000;$fatal(1,"shared equivalence watchdog");end
endmodule
