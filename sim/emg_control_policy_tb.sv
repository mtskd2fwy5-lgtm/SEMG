`timescale 1ns/1ps
module emg_control_policy_tb;
reg clk=0;always #20 clk=~clk;
reg rst_n=0,recalibrate=0,window_valid=0,logit_valid=0;
reg [15:0] window_seq=0,logit_seq=0;
reg [255:0] window_mav=0;
reg [2:0] logit_id=0;
reg [31:0] logit_data=0;
wire decision_valid,gated,stale,fault;
wire [15:0] decision_seq;
wire [2:0] active,candidate;
wire [6:0] ac,cc;
wire [1:0] stage;
emg_control_policy dut(.clk(clk),.rst_n(rst_n),.recalibrate(recalibrate),
 .window_valid(window_valid),.window_seq(window_seq),.window_mav(window_mav),
 .logit_valid(logit_valid),.logit_id(logit_id),.logit_data(logit_data),.logit_seq(logit_seq),
 .decision_valid(decision_valid),.decision_seq(decision_seq),.active_class(active),
 .candidate_class(candidate),.active_conf(ac),.candidate_conf(cc),.gated(gated),
 .cal_stage(stage),.stale(stale),.protocol_fault(fault));
integer f,n,r,s,j,k,count=0,waited;
reg [31:0] m[0:7];reg signed [31:0] l[0:4];integer e[0:8];
initial begin
 repeat(4)@(negedge clk);rst_n=1;
 f=$fopen("policy_vectors.txt","r");if(!f)$fatal(1,"missing policy vectors");
 while(!$feof(f))begin
  n=$fscanf(f,"%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n",
   r,s,m[0],m[1],m[2],m[3],m[4],m[5],m[6],m[7],l[0],l[1],l[2],l[3],l[4],
   e[0],e[1],e[2],e[3],e[4],e[5],e[6],e[7],e[8]);
  if(n!=24)$fatal(1,"bad vector row %0d fields %0d",count,n);
  if(r)begin recalibrate=1;@(negedge clk);recalibrate=0;end
  window_valid=1;window_seq=s;for(j=0;j<8;j=j+1)window_mav[j*32+:32]=m[j];
  @(negedge clk);window_valid=0;@(negedge clk);
  for(j=0;j<6;j=j+1)begin
   logit_valid=1;logit_id=j;logit_seq=s;logit_data=j<5?l[j]:0;
   @(negedge clk);
  end
  logit_valid=0;
  if(e[1])begin
   waited=0;while(!decision_valid && waited<200)begin @(negedge clk);waited=waited+1;end
   if(!decision_valid)$fatal(1,"no decision row %0d",count);
   if({active,ac,gated,candidate,cc} !== {3'(e[2]),7'(e[3]),1'(e[4]),3'(e[5]),7'(e[6])} ||
      dut.pending_count!=e[7] || dut.uncertain_count!=e[8] || decision_seq!=s)
    $fatal(1,"row %0d actual active=%0d conf=%0d gate=%0d cand=%0d cc=%0d pend=%0d uncertain=%0d expected=%0d %0d %0d %0d %0d %0d %0d",
      count,active,ac,gated,candidate,cc,dut.pending_count,dut.uncertain_count,e[2],e[3],e[4],e[5],e[6],e[7],e[8]);
  end
  if(stage!=e[0] || fault)$fatal(1,"stage/protocol row %0d stage=%0d expected=%0d fault=%b",count,stage,e[0],fault);
  @(negedge clk);count=count+1;
 end
 $fclose(f);$display("TEST_PASS policy equivalence %0d windows",count);$finish;
end
initial begin #300000000;$fatal(1,"policy watchdog");end
endmodule
