`timescale 1ns/1ps
module nn_v15_case #(parameter MODEL="data/models/nn_int8_board_multiwear/nn_int8_weights.mem")(output reg done=0);
 reg clk=0,rst_n=0,valid=0,ready=1;
 always #20 clk=~clk;
 reg[5:0]idx=0;reg[31:0]data=0,rng=32'h12fab986;
 wire ar,br,av,bv;wire[2:0]ai,bi;wire[31:0]ad,bd;
 integer win,i,phase,ticks,outputs=0,cycles=0,start_cycle,latency;
 emg_nn_infer #(.MEM_FILE(MODEL)) a(.clk(clk),.rst_n(rst_n),.feat_valid(valid),.feat_index(idx),.feat_data(data),.feat_ready(ar),.out_valid(av),.out_ready(ready),.out_id(ai),.out_data(ad));
 emg_nn_infer_v14 #(.MEM_FILE(MODEL)) b(.clk(clk),.rst_n(rst_n),.feat_valid(valid),.feat_index(idx),.feat_data(data),.feat_ready(br),.out_valid(bv),.out_ready(ready),.out_id(bi),.out_data(bd));
 always @(posedge clk)begin
  #1;cycles=cycles+1;
  if({ar,av,ai,ad} !== {br,bv,bi,bd})$fatal(1,"MLP cycle mismatch model=%s cycle=%0d got=%h ref=%h",MODEL,cycles,{ar,av,ai,ad},{br,bv,bi,bd});
 end
 task tick;begin
  @(negedge clk);rng=rng^(rng<<13);rng=rng^(rng>>17);rng=rng^(rng<<5);
  ready=rng[4:0]!=0;
 end endtask
 task feature(input integer index,input reg[31:0]value);begin
  ticks=0;while(!ar && ticks<16000)begin tick();ticks=ticks+1;end
  if(!ar)$fatal(1,"MLP ready timeout");
  idx=index;data=value;valid=1;tick();valid=0;
 end endtask
 initial begin
  repeat(20)tick();rst_n=1;
  for(phase=0;phase<4;phase=phase+1)begin
   for(win=0;win<8;win=win+1)begin
    for(i=0;i<40;i=i+1)begin
     // Repeated indices exercise reset masks and persistent input semantics.
     feature(win==1 ? i%7 : (win==2 ? 39-i : i),win==0 ? 0 : (win==3 ? 32'hffffffff : rng));
     if(rng[5])tick();
    end
    start_cycle=cycles;outputs=0;ticks=0;
    while(outputs<6 && ticks<16000)begin
     if(av && ready)outputs=outputs+1;
     tick();ticks=ticks+1;
    end
    if(outputs!=6)$fatal(1,"MLP output timeout");
    latency=cycles-start_cycle;
    $display("MLP_V15_CYCLES phase=%0d window=%0d cycles=%0d",phase,win,latency);
    repeat(3)tick();
   end
   // Interrupt input or a hidden-layer computation before restarting.
   for(i=0;i<(phase==0?17:40);i=i+1)feature(i,rng);
   repeat(phase*83)tick();rst_n=0;valid=0;repeat(3)tick();rst_n=1;
  end
  done=1;$display("TEST_PASS MLP V15 cycle-exact 32 windows, repeated indices, saturation, backpressure, mid-task reset model=%s",MODEL);
 end
endmodule

module pwm_v15_case #(parameter CLOCK=25000000,FRAME=3000,WD=5)(output reg done=0);
 reg clk=0,rst_n=0,en=0,es=0,valid=0;always #5 clk=~clk;
 reg[95:0]cmd=0;reg[31:0]rng=32'h45abcd12;
 wire[5:0]ap,bp;wire aa,ba,af,bf;wire[95:0]ac,bc;
 integer n,j,accepted=0,stops=0;
 hand_servo_pwm #(.CLOCK_HZ(CLOCK),.FRAME_US(FRAME),.WATCHDOG_MS(WD)) a(.clk(clk),.rst_n(rst_n),.enable(en),.estop(es),.command_valid(valid),.command_us(cmd),.pwm(ap),.armed(aa),.fault(af),.current_us(ac));
 hand_servo_pwm_v14 #(.CLOCK_HZ(CLOCK),.FRAME_US(FRAME),.WATCHDOG_MS(WD)) b(.clk(clk),.rst_n(rst_n),.enable(en),.estop(es),.command_valid(valid),.command_us(cmd),.pwm(bp),.armed(ba),.fault(bf),.current_us(bc));
 always @(posedge clk)begin
  #1;
  if({ap,aa,af,ac} !== {bp,ba,bf,bc})$fatal(1,"PWM cycle mismatch clk=%0d n=%0d got=%h ref=%h",CLOCK,n,{ap,aa,af,ac},{bp,ba,bf,bc});
  if(aa)accepted=accepted+1;
  if(af)stops=stops+1;
 end
 initial begin
  repeat(20)@(negedge clk);rst_n=1;en=1;
  for(n=0;n<CLOCK/1000*100;n=n+1)begin
   @(negedge clk);rng=rng^(rng<<13);rng=rng^(rng>>17);rng=rng^(rng<<5);
   valid=(n%(CLOCK/1000)==0) && !(n>CLOCK/1000*30 && n<CLOCK/1000*40);
   for(j=0;j<6;j=j+1)cmd[j*16+:16]=500+(rng+j*173)%2001;
   if(n==CLOCK/1000*10)begin valid=1;cmd[31:16]=499;end
   if(n==CLOCK/1000*11 || n==CLOCK/1000*41 || n==CLOCK/1000*61)en=0;
   if(n==CLOCK/1000*12 || n==CLOCK/1000*42 || n==CLOCK/1000*62)en=1;
   es=(n==CLOCK/1000*60);
   rst_n=!(n==CLOCK/1000*80 || n==CLOCK/1000*80+1);
  end
  if(accepted<1000 || stops<100)$fatal(1,"PWM coverage incomplete");
  done=1;$display("TEST_PASS PWM V15 cycle-exact clock=%0d frame=%0d armed_cycles=%0d fault_cycles=%0d",CLOCK,FRAME,accepted,stops);
 end
endmodule

module emg_v15_equiv_tb;
 wire[4:0]done;
 nn_v15_case production(done[0]);
 nn_v15_case #(.MODEL("random_model.mem")) alternate(done[1]);
 pwm_v15_case #(.CLOCK(1000000)) one(done[2]);
 pwm_v15_case real_clock(done[3]);
 pwm_v15_case #(.CLOCK(3000000),.FRAME(4096),.WD(7)) odd_clock(done[4]);
 initial begin wait(&done);$display("TEST_PASS V15 MLP PWM equivalence complete");$finish;end
 initial begin #100000000;$fatal(1,"V15 equivalence watchdog");end
endmodule
