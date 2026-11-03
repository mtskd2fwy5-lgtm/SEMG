`timescale 1ns/1ps
// Pin-level contract, at 1 MHz to make each checked cycle exactly one us.
module hand_pwm_polarity_tb;
 reg clk=0,axis_clk=0,rst_n=0,axis_rst_n=0;
 always #500 clk=~clk;always #370 axis_clk=~axis_clk;
 reg [31:0] command=0;wire [31:0] status;
 reg decision_valid=0,decision_ready=0;reg [2:0] decision_class=0;
 wire [5:0] pwm;
`ifdef HAND_NETLIST
 hand_control dut(.*);
`else
 hand_control #(.CLOCK_HZ(1000000),.TIMEOUT_MS(100)) dut(.*);
`endif
 integer n,i,waited,t,width[0:5];
 task automatic ticks(input integer count);repeat(count)@(negedge clk);endtask
 task automatic cmd(input integer op,row,axis,value);
  command={~command[31],4'(op),3'(row),5'd0,3'(axis),16'(value)};
  n=0;while(status[23]!=command[31] && n<200)begin ticks(1);n++;end
  if(n>=200)$fatal(1,"ACK timeout");ticks(12);
 endtask
 function automatic integer pulse(input integer axis);
  case(axis)0:pulse=500;1:pulse=833;2:pulse=1300;3:pulse=1700;4:pulse=2200;5:pulse=2500;endcase
 endfunction
 task automatic idle;
  if(pwm!==6'h3f)$fatal(1,"FPGA idle must be HIGH on all six pins: %b",pwm);
 endtask
 task automatic home;
  for(integer a=0;a<6;a++)begin cmd(14,0,a,pulse(a));idle();end
  cmd(15,0,0,0);
 endtask
 task automatic next_frame;
  waited=0;
  while(pwm!==6'd0 && waited<21000)begin ticks(1);waited++;end
  if(pwm!==6'd0)$fatal(1,"six simultaneous falling edges missing");
 endtask
 initial begin
  ticks(10);idle();rst_n=1;axis_rst_n=1;ticks(100);cmd(0,0,0,0);idle();
  for(i=0;i<6;i++)begin cmd(1,i,0,500);cmd(2,i,0,2500);end
  home();next_frame();
  for(i=0;i<6;i++)width[i]=0;
  for(t=0;t<2600;t++)begin
   for(i=0;i<6;i++)if(!pwm[i])width[i]++;
   ticks(1);
  end
  for(i=0;i<6;i++)if(width[i]!=pulse(i))$fatal(1,"active-low width axis %0d got %0d expected %0d",i,width[i],pulse(i));
  next_frame();if(waited!=17400)$fatal(1,"frame period changed: %0d",waited+2600);
  // Stop while the active-low pulse is in progress, no remaining low level.
  cmd(8,0,0,0);idle();ticks(21000);idle();
  cmd(0,0,0,0);cmd(5,2,0,1200);
  waited=0;while(pwm[2]!==0 && waited<21000)begin ticks(1);waited++;end
  if(pwm[2]!==0)$fatal(1,"manual pulse missing");
  for(t=0;t<1200;t++)begin
   if(pwm!==6'b111011)$fatal(1,"manual axis isolation/polarity failed: %b",pwm);
   ticks(1);
  end
  idle();cmd(5,2,0,499);idle();
  cmd(0,0,0,0);home();next_frame();rst_n=0;axis_rst_n=0;ticks(3);idle();
  rst_n=1;axis_rst_n=1;ticks(100);cmd(0,0,0,0);idle();
  for(i=0;i<6;i++)begin cmd(1,i,0,500);cmd(2,i,0,2500);end
  home();ticks(110000);idle();if(!status[22])$fatal(1,"watchdog did not trip");
  $display("TEST_PASS pin polarity: six idle HIGH, low widths 500/833/1300/1700/2200/2500us, 20ms frame, single-axis isolation, midpulse estop/reset, invalid target and watchdog");
  $finish;
 end
 initial begin #1000000000;$fatal(1,"pin-level test watchdog");end
endmodule
