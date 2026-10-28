`timescale 1ns/1ps
module emg_shared_netlist_tb;
 reg clk=0,rst_n=0,valid=0,ready=1,started=0;
 reg [2:0] channel=0;reg signed [23:0] data=0;
 reg [15:0] seq=0;reg [31:0] rng=32'h876accde;
 integer n,beats=0,words=0;always #20 clk=~clk;
 wire ar,br,av,bv,ao,bo;wire signed [23:0] ad,bd;
 wire [2:0] ac,bc;wire [15:0] aq,bq;
`ifndef SHARED_FILTER_MODULE
`define SHARED_FILTER_MODULE emg_line_filter
`define SHARED_BANK_MODULE emg_feature_bank
`endif
 `SHARED_FILTER_MODULE filter(.clk(clk),.rst_n(rst_n),.sample_valid(valid),.sample_data(data),
 .sample_channel(channel),.sample_sequence(seq),.sample_ready(ar),.filtered_valid(av),
 .filtered_data(ad),.filtered_channel(ac),.filtered_sequence(aq),.overrun(ao));
 emg_line_filter_reference #(.BANDPASS_ENABLE(1)) filter_ref(.clk(clk),.rst_n(rst_n),
 .sample_valid(valid),.sample_data(data),.sample_channel(channel),.sample_sequence(seq),
 .sample_ready(br),.filtered_valid(bv),.filtered_data(bd),.filtered_channel(bc),
 .filtered_sequence(bq),.overrun(bo));
 wire af,bf;wire [3:0] afi,bfi;wire [2:0] afc,bfc;wire [31:0] afd,bfd;wire [15:0] afq,bfq;
 `SHARED_BANK_MODULE bank(.clk(clk),.rst_n(rst_n),.sample_valid(av),.sample_channel(ac),
 .sample_data(ad),.feature_ready(ready),.feature_valid(af),.feature_id(afi),
 .feature_channel(afc),.feature_data(afd),.feature_sequence(afq));
 emg_feature_bank_reference #(.BYPASS_BANDPASS(1)) bank_ref(.clk(clk),.rst_n(rst_n),
 .sample_valid(bv),.sample_channel(bc),.sample_data(bd),.feature_ready(ready),
 .feature_valid(bf),.feature_id(bfi),.feature_channel(bfc),.feature_data(bfd),.feature_sequence(bfq));
 always @(posedge clk)begin
  #1;
  if(started)begin
   if({ar,av,ao,ad,ac,aq} !== {br,bv,bo,bd,bc,bq})
    $fatal(1,"shared filter netlist cycle/data n=%0d got=%h ref=%h",n,{ar,av,ao,ad,ac,aq},{br,bv,bo,bd,bc,bq});
   if({af,afi,afc,afd,afq} !== {bf,bfi,bfc,bfd,bfq})
    $fatal(1,"shared bank netlist cycle/data n=%0d got=%h ref=%h",n,{af,afi,afc,afd,afq},{bf,bfi,bfc,bfd,bfq});
   if(av)beats=beats+1;
   if(af && ready)words=words+1;
  end
 end
 initial begin
  repeat(20)@(negedge clk);rst_n=1;started=1;
  for(n=0;n<160000;n=n+1)begin
   @(negedge clk);rng=rng^(rng<<13);rng=rng^(rng>>17);rng=rng^(rng<<5);
   valid=n%16==0;
   ready=n%3100<2900 && rng[5:3]!=0;
   if(valid)begin
    channel=(n/16)%8;seq=n/128;
    if(n<16000)data=n[4]?24'sh7fffff:24'sh800000;
    else if(n<32000)data=1000;
    else if(n<48000)data=n[4]?1:-1;
    else if(n<64000)data=0;
    else data=rng[23:0];
   end
   rst_n=!(n==93007 || n==93008 || n==145001);
  end
  @(negedge clk);valid=0;ready=1;repeat(180)@(negedge clk);
  if(beats<9900 || words<180)$fatal(1,"incomplete shared netlist test beats=%0d words=%0d",beats,words);
  $display("TEST_PASS shared synthesized pipeline beats=%0d words=%0d cycle-exact",beats,words);$finish;
 end
 initial begin #6500000;$fatal(1,"shared netlist watchdog");end
endmodule
