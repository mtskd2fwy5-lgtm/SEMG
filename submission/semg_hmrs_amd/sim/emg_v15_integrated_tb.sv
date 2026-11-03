`timescale 1ns/1ps
// Compare retained result boundaries in the actual module-reference OOC
// netlist with the full RTL shell, not re-synthesized isolated functions.
module emg_v15_integrated_tb;
 reg clk=0,axis_clk=0,rst_n=0,valid=0,started=0;
 always #20 clk=~clk;
 always #10 axis_clk=~axis_clk;
 reg[2:0]channel=0;reg signed[23:0]data=0;reg[15:0]seq=0;
 reg[31:0]rng=32'h18b92aac;
 wire[63:0]td,rd;wire tv,rv;
 integer n,drain_cycles=0,nn_words=0,fat_words=0;
 design_1_emg_pl_export_0_7 dut(.pl_clk(clk),.pl_rst_n(rst_n),
 .axis_clk(axis_clk),.axis_rst_n(rst_n),.adc_drdy_n(1'b1),.adc_dout(1'b0),
 .reconfig_n(1'b1),.control_command(32'd0),.hand_command(32'd0),
 .m_axis_tready(1'b1),.m_axis_tdata(td),.m_axis_tvalid(tv));
 emg_pl_control reference_dut(.pl_clk(clk),.pl_rst_n(rst_n),
 .axis_clk(axis_clk),.axis_rst_n(rst_n),.adc_drdy_n(1'b1),.adc_dout(1'b0),
 .reconfig_n(1'b1),.control_command(32'd0),.hand_command(32'd0),
 .m_axis_tready(1'b1),.m_axis_tdata(rd),.m_axis_tvalid(rv));
 always @(posedge clk)begin
  #1;
  if(started)begin
   if(dut.inst.u_core.nn_out_valid !== reference_dut.u_core.nn_out_valid)
    $fatal(1,"integrated MLP valid mismatch n=%0d",n);
   if(dut.inst.u_core.nn_out_valid)begin
    if({dut.inst.u_core.\g_control.u_control .nn_out_id,dut.inst.u_core.\g_control.u_control .nn_out_data} !==
       {reference_dut.u_core.nn_out_id,reference_dut.u_core.nn_out_data})
     $fatal(1,"integrated MLP data mismatch n=%0d",n);
    nn_words=nn_words+1;
   end
   if(dut.inst.u_core.fat_out_valid !== reference_dut.u_core.fat_out_valid)
    $fatal(1,"integrated FFT valid mismatch n=%0d",n);
   if(dut.inst.u_core.fat_out_valid)begin
    if({dut.inst.u_core.fat_out_id,dut.inst.u_core.fat_out_data,dut.inst.u_core.fat_out_sequence} !==
       {reference_dut.u_core.fat_out_id,reference_dut.u_core.fat_out_data,reference_dut.u_core.fat_out_sequence})
     $fatal(1,"integrated FFT data mismatch n=%0d",n);
    fat_words=fat_words+1;
   end
  end
 end
 initial begin
  force dut.inst.u_core.sample_valid=valid;
  force dut.inst.u_core.sample_data=data;
  force dut.inst.u_core.sample_channel=channel;
  force dut.inst.u_core.raw_sequence_reg=seq;
  force reference_dut.u_core.sample_valid=valid;
  force reference_dut.u_core.sample_data=data;
  force reference_dut.u_core.sample_channel=channel;
  force reference_dut.u_core.raw_sequence=seq;
  repeat(30)@(negedge clk);rst_n=1;started=1;
  for(n=0;n<640000;n=n+1)begin
   @(negedge clk);valid=n%16==0;
   if(n%100000==0)$display("V15 integrated progress cycles=%0d nn=%0d fft=%0d",n,nn_words,fat_words);
   if(valid)begin
    rng=rng^(rng<<13);rng=rng^(rng>>17);rng=rng^(rng<<5);
    channel=(n/16)%8;seq=n/128;
    data=$signed(rng[14:0])-16384;
   end
  end
  // Eight sequential channel FFTs take approximately 729,000 clocks after
  // capture.  Drain two full output frames, including ping-pong RAM reuse.
  @(negedge clk);valid=0;
  while(fat_words<16 && drain_cycles<1200000)begin
   @(negedge clk);drain_cycles=drain_cycles+1;
   if(drain_cycles%100000==0)$display("V15 integrated drain=%0d nn=%0d fft=%0d",drain_cycles,nn_words,fat_words);
  end
  if(nn_words<200 || fat_words<16)$fatal(1,"integrated coverage incomplete nn=%0d fft=%0d",nn_words,fat_words);
  $display("TEST_PASS V15 integrated OOC MLP FFT cycle-exact nn=%0d fft=%0d",nn_words,fat_words);$finish;
 end
 initial begin #80000000;$fatal(1,"V15 integrated watchdog");end
endmodule

