`timescale 1ns/1ps
// Real module-reference OOC netlist, without re-synthesizing isolated blocks.
// Injection replaces only the ADC-decoded sample boundary; actual optimized
// filtering, feature bank, control and telemetry logic remain instantiated.
module emg_shared_netlist_tb;
 reg clk=0,axis_clk=0,rst_n=0,valid=0,ready=1,started=0;
 reg [2:0] channel=0;reg signed [23:0] data=0;
 reg [15:0] seq=0;reg [31:0] rng=32'h876accde;
 integer n,beats=0,words=0;always #20 clk=~clk;
 // Offset read/write edges avoid undefined same-address RAM collision data
 // during an empty FIFO's speculative prefetch; check accepted telemetry too.
 always #10 axis_clk=~axis_clk;
 wire [63:0] telemetry;wire telemetry_valid;
 design_1_emg_pl_export_0_7 dut(.pl_clk(clk),.pl_rst_n(rst_n),
 .axis_clk(axis_clk),.axis_rst_n(rst_n),.adc_drdy_n(1'b1),.adc_dout(1'b0),
 .reconfig_n(1'b1),.control_command(32'd0),.hand_command(32'd0),.m_axis_tready(ready),
 .m_axis_tdata(telemetry),.m_axis_tvalid(telemetry_valid));
 always @(posedge axis_clk)if(started && rst_n && telemetry_valid && ready)
  if((^telemetry) === 1'bx)$fatal(1,"unknown accepted telemetry");
 wire bv,br,bo;wire signed [23:0] bd;wire [2:0]bc;wire[15:0]bq;
 emg_line_filter_reference #(.BANDPASS_ENABLE(1)) filter_ref(.clk(clk),.rst_n(rst_n),
 .sample_valid(valid),.sample_data(data),.sample_channel(channel),.sample_sequence(seq),
 .sample_ready(br),.filtered_valid(bv),.filtered_data(bd),.filtered_channel(bc),
 .filtered_sequence(bq),.overrun(bo));
 wire bf;wire[3:0]bfi;wire[2:0]bfc;wire[31:0]bfd;wire[15:0]bfq;
 emg_feature_bank_reference #(.BYPASS_BANDPASS(1)) bank_ref(.clk(clk),.rst_n(rst_n),
 .sample_valid(bv),.sample_channel(bc),.sample_data(bd),.feature_ready(1'b1),
 .feature_valid(bf),.feature_id(bfi),.feature_channel(bfc),.feature_data(bfd),.feature_sequence(bfq));
 always @(posedge clk)begin
  #1;
  if(started)begin
   if(dut.inst.u_core.notch_valid !== bv)
    $fatal(1,"integrated filter valid n=%0d",n);
   if(bv && {dut.inst.u_core.notch_data,dut.inst.u_core.notch_channel,dut.inst.u_core.notch_sequence} !== {bd,bc,bq})
    $fatal(1,"integrated filter data n=%0d got=%h ref=%h",n,{dut.inst.u_core.notch_data,dut.inst.u_core.notch_channel,dut.inst.u_core.notch_sequence},{bd,bc,bq});
   if(dut.inst.u_core.feature_valid !== bf)
    $fatal(1,"integrated bank valid n=%0d",n);
   if(bf && {1'b0,dut.inst.u_core.feature_id,dut.inst.u_core.feature_channel,dut.inst.u_core.feature_data,dut.inst.u_core.feature_sequence} !== {bfi,bfc,bfd,bfq})
    $fatal(1,"integrated bank data n=%0d",n);
   if(bv)beats=beats+1;
   if(bf)words=words+1;
  end
 end
 initial begin
  force dut.inst.u_core.sample_valid=valid;
  force dut.inst.u_core.sample_data=data;
  force dut.inst.u_core.sample_channel=channel;
  force dut.inst.u_core.raw_sequence_reg=seq;
  repeat(20)@(negedge clk);rst_n=1;started=1;
  for(n=0;n<160000;n=n+1)begin
   @(negedge clk);rng=rng^(rng<<13);rng=rng^(rng>>17);rng=rng^(rng<<5);
   valid=n%16==0;ready=n%3100<2900 && rng[5:3]!=0;
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
  if(beats<9900 || words<180)$fatal(1,"incomplete integrated test beats=%0d words=%0d",beats,words);
  $display("TEST_PASS shared synthesized pipeline integrated OOC beats=%0d words=%0d cycle-exact",beats,words);$finish;
 end
 initial begin #6500000;$fatal(1,"integrated netlist watchdog");end
endmodule

