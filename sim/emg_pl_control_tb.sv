`timescale 1ns/1ps
// Actual export shell, unrelated clocks, stopped AXI consumer. Inject at the
// feature bank's documented output to isolate autonomy from ADC/filter tests.
module emg_pl_control_tb;
reg pc=0,ac=0;always #20 pc=~pc;always #7 ac=~ac;
reg pr=0,ar=0,ready=0;reg[31:0] command=0;
wire[31:0] status;wire[63:0] out_data;wire ov,fo,ro,last;
reg fv=0;reg[2:0] fc=0;reg[3:0] fi=0;reg[15:0] fs=0;reg[31:0] fd=0;
emg_pl_control dut(.pl_clk(pc),.pl_rst_n(pr),.axis_clk(ac),.axis_rst_n(ar),
 .adc_drdy_n(1'b1),.adc_dout(1'b0),.reconfig_n(1'b1),.control_command(command),.control_status(status),
 .m_axis_tdata(out_data),.m_axis_tvalid(ov),.m_axis_tready(ready),.m_axis_tlast(last),
 .feature_overflow(fo),.result_overflow(ro));
integer i,n,count=0,observed=0,waited;
reg[15:0] start_seq=0;
always @(negedge pc)if(dut.u_core.decision_valid)begin
 count=count+1;
 if(dut.u_core.decision_data[31:28]!=1 || dut.u_core.decision_data[26:24]!=2)
  $fatal(1,"configuration mismatch %h",dut.u_core.decision_data);
end
always @(posedge ac)if(ready && ov && out_data[63:60]==3 && out_data[55:52]==6)observed=observed+1;
initial begin
 force dut.u_core.feature_valid=fv;force dut.u_core.feature_channel=fc;
 force dut.u_core.feature_id=fi;force dut.u_core.feature_sequence=fs;
 force dut.u_core.feature_data=fd;
 repeat(8)@(negedge pc);pr=1;ar=1;repeat(8)@(negedge ac);
 command=32'h8000001a; // epoch1, reset, shift2, req1
 repeat(25)@(negedge ac);
 if(status[31:16]!=16'h504c || !status[15] || status[11:8]!=1 || status[6:4]!=2)
  $fatal(1,"mailbox ACK status %h",status);
 for(n=0;n<104;n=n+1)begin
  for(i=0;i<40;i=i+1)begin
   @(negedge pc);fv=1;fc=i/5;fi=i%5;fs=start_seq+i;fd=n<96?100:10000+i;
  end
  @(negedge pc);fv=0;repeat(6000)@(negedge pc);start_seq=start_seq+40;
 end
 if(count!=9 || dut.fault || dut.stale || !fo || !ro)
  $fatal(1,"autonomy count=%0d fault=%b stale=%b featureoverflow=%b resultoverflow=%b",count,dut.fault,dut.stale,fo,ro);
 // Overflowed telemetry is allowed; autonomous decision must be unaffected.
 ready=1;repeat(10000)@(negedge ac);
 // Fresh accepted words must still be exported once the consumer recovers.
 for(i=0;i<40;i=i+1)begin
  @(negedge pc);fv=1;fc=i/5;fi=i%5;fs=start_seq+i;fd=10000+i;
 end
 @(negedge pc);fv=0;repeat(6500)@(negedge pc);
 if(observed<1 || count!=10)$fatal(1,"telemetry recovery");
 // A command while no stream is running still gets acknowledged and resets.
 command=32'h0000002b;repeat(30)@(negedge ac);
 if(status[15] || status[11:8]!=2 || status[6:4]!=3 || status[1:0]!=0 || !status[2])
  $fatal(1,"recalibration ACK %h",status);
 $display("TEST_PASS PL shell independent of DMA backpressure, overflow/recovery, command CDC");$finish;
end
initial begin #100000000;$fatal(1,"PL shell watchdog");end
endmodule
