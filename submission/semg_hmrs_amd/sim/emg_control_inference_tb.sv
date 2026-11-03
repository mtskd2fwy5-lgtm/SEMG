`timescale 1ns/1ps
module emg_control_inference_tb;
reg clk=0;always #20 clk=~clk;
reg rst_n=0,recalibrate=0,valid=0;
reg [2:0] shift=0,ch=0;reg [3:0] epoch=0,id=0;
reg [15:0] seq=0;reg [31:0] data=0;
wire nv,dv,stale,fault;wire[2:0] ni,active;wire[31:0] nd,dd;wire[15:0] ns,ds;wire[1:0] stage;
emg_control_inference dut(.clk(clk),.rst_n(rst_n),.recalibrate(recalibrate),.shift(shift),.epoch(epoch),
 .feature_valid(valid),.feature_channel(ch),.feature_id(id),.feature_seq(seq),.feature_data(data),
 .nn_valid(nv),.nn_id(ni),.nn_data(nd),.nn_seq(ns),.decision_valid(dv),.decision_data(dd),
 .decision_seq(ds),.cal_stage(stage),.stale(stale),.fault(fault),.active_class(active));
integer f,n,s,rotation,i,j,waited,outputs,count=0;
reg[31:0] features[0:39];reg signed[31:0] expected[0:4];
initial begin
 repeat(4)@(negedge clk);rst_n=1;
 f=$fopen("inference_vectors.txt","r");if(!f)$fatal(1,"missing inference vectors");
 while(!$feof(f))begin
  n=$fscanf(f,"%d %d",s,rotation);if(n!=2)$fatal(1,"bad header");
  for(i=0;i<40;i=i+1)n=$fscanf(f,"%d",features[i]);
  for(i=0;i<4;i=i+1)n=$fscanf(f,"%d",expected[i]);
  n=$fscanf(f,"%d\n",expected[4]);
  shift=rotation;epoch=rotation;
  for(i=0;i<40;i=i+1)begin
   valid=1;ch=i/5;id=i%5;seq=(s+i)&65535;data=features[(i%5)*8+i/5];
   @(negedge clk);
   // Configuration must be snapshotted on the first word, not midway.
   if(i==20)begin shift=(rotation+1)%6;epoch=15;end
  end
  valid=0;outputs=0;waited=0;
  while(outputs<6 && waited<20000)begin
   if(nv)begin
    if(ns!=s || ni!=outputs)$fatal(1,"sequence/order row %0d",count);
    if(ni<5 && nd!==expected[ni])$fatal(1,"mapped logit row %0d shift %0d id %0d actual %0d expected %0d",count,rotation,ni,$signed(nd),expected[ni]);
    outputs=outputs+1;
   end
   @(negedge clk);waited=waited+1;
  end
  if(outputs!=6)$fatal(1,"inference timeout");
  if(stage==2)begin
   waited=0;while(!dv && waited<200)begin @(negedge clk);waited=waited+1;end
   if(!dv || ds!=s || dd[31:28]!=rotation || dd[26:24]!=rotation || dd[27] || !dd[23])$fatal(1,"decision snapshot row %0d word %h",count,dd);
  end
  if(fault)$fatal(1,"protocol fault row %0d",count);
  repeat(3)@(negedge clk);count=count+1;
 end
 // Stop input: stale asserts; malformed features must be rejected and fault.
 repeat(6250100)@(negedge clk);
 if(!stale)$fatal(1,"stale watchdog missing");
 valid=1;ch=0;id=0;seq=0;@(negedge clk);ch=2;id=0;seq=1;@(negedge clk);valid=0;
 if(!fault)$fatal(1,"malformed window not rejected");
 recalibrate=1;@(negedge clk);recalibrate=0;@(negedge clk);
 if(fault || stage!=0 || !stale || active!=0)$fatal(1,"reset state");
 $display("TEST_PASS autonomous inference %0d windows six mappings, snapshot, stale, malformed/reset",count);$finish;
end
initial begin #600000000;$fatal(1,"inference test watchdog");end
endmodule

