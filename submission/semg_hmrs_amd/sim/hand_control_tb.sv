`timescale 1ns/1ps
module hand_control_tb;
 reg clk=0,axis_clk=0,rst_n=0,axis_rst_n=0;
 always #500 clk=~clk;
 always #370 axis_clk=~axis_clk;
 reg [31:0] command=0;
 wire [31:0] status;
 reg decision_valid=0,decision_ready=0;
 reg [2:0] decision_class=0;
 wire [5:0] pwm_pin,pwm;
 assign pwm=~pwm_pin; // downstream inverting optocoupler, servo side
 hand_control #(.CLOCK_HZ(1000000),.TIMEOUT_MS(100)) dut(
  .clk(clk),.axis_clk(axis_clk),.rst_n(rst_n),.axis_rst_n(axis_rst_n),
  .command(command),.status(status),.decision_valid(decision_valid),
  .decision_ready(decision_ready),.decision_class(decision_class),.pwm(pwm_pin));
`ifdef HAND_POLARITY_REFERENCE
 wire [5:0] reference_pwm;wire [31:0] reference_status;
 hand_control_active_high_reference #(.CLOCK_HZ(1000000),.TIMEOUT_MS(100)) reference_dut(
  .clk(clk),.axis_clk(axis_clk),.rst_n(rst_n),.axis_rst_n(axis_rst_n),
  .command(command),.status(reference_status),.decision_valid(decision_valid),
  .decision_ready(decision_ready),.decision_class(decision_class),.pwm(reference_pwm));
 integer reference_cycles=0;
 always @(negedge clk)begin
  reference_cycles++;
  if(reference_cycles>2 && (reference_pwm!==pwm || reference_status!==status))
   $fatal(1,"optocoupler output/status mismatch from active-high baseline");
 end
`endif
 integer n,i,j;
 task automatic ticks(input integer count);
   repeat(count)@(negedge clk);
 endtask
 task automatic cmd(input integer op,row,axis,value);
   command={~command[31],4'(op),3'(row),5'd0,3'(axis),16'(value)};
   n=0;
   while(status[23]!=command[31] && n<200)begin ticks(1);n=n+1;end
   if(n>=200)$fatal(1,"ACK timeout");
   ticks(12);
 endtask
 task automatic beat(input integer cls);
   decision_class=cls;decision_ready=1;decision_valid=1;ticks(1);decision_valid=0;ticks(20);
 endtask
 task automatic off_check;
   if(pwm_pin!==6'h3f || pwm!==0 || status[20:19]!=0)$fatal(1,"Expected outputs disabled status=%h pwm=%h",status,pwm);
 endtask
 task automatic auto_start(input integer cls);
   beat(cls);cmd(9,0,0,1500);cmd(6,0,0,0);
 endtask
 function automatic integer home_us(input integer a);
   home_us=a==0?833:1200+a*100;
 endfunction
 task automatic home_stage;
   for(integer a=0;a<6;a=a+1)begin
     cmd(14,0,a,home_us(a));off_check();
   end
 endtask
 task automatic home_frame_check;
   integer wait_count,a,t,width[0:5];
   wait_count=0;
   while(pwm==0 && wait_count<22000)begin ticks(1);wait_count++;end
   if(pwm!==6'b111111)$fatal(1,"home axes did not rise on same frame %b",pwm);
   if(dut.current_us!=={16'd1700,16'd1600,16'd1500,16'd1400,16'd1300,16'd833})
     $fatal(1,"home targets wrong / unselected axes defaulted to 1500");
   for(a=0;a<6;a++)width[a]=0;
   for(t=0;t<2600;t++)begin
     for(a=0;a<6;a++)if(pwm[a])width[a]++;
     ticks(1);
   end
   for(a=0;a<6;a++)if(width[a]!=home_us(a))
     $fatal(1,"home width axis%0d got%0d expected%0d",a,width[a],home_us(a));
 endtask
 initial begin
   repeat(5)#1000000000;
   $fatal(1,"watchdog: test hung");
 end
 initial begin
   ticks(10);if(pwm_pin!==6'h3f)$fatal(1,"reset must idle HIGH before optocoupler");rst_n=1;axis_rst_n=1;ticks(100);off_check();
   cmd(6,0,0,0);if(!status[21])$fatal(1,"uncalibrated auto accepted");off_check();
   cmd(0,0,0,0);cmd(14,0,0,833);
   if(!status[21])$fatal(1,"uncalibrated home stage accepted");off_check();
   cmd(0,0,0,0);
   cmd(5,6,0,1500);if(!status[21])$fatal(1,"invalid manual channel accepted");
   cmd(0,0,0,0);cmd(5,2,0,1200);
   ticks(25000);
   if(status[20:19]!=1 || !status[18])$fatal(1,"manual did not arm");
   repeat(22000)begin ticks(1);if(pwm & 6'b111011)$fatal(1,"manual leaked another axis");end
   cmd(5,2,0,1300);ticks(22000);
   if(dut.target[47:32]!=1300 || status[20:19]!=1)$fatal(1,"live same-axis manual update failed");
   cmd(5,1,0,1200);ticks(100);off_check();
   cmd(0,0,0,0);cmd(5,2,0,1200);ticks(101000);off_check();
   if(!status[22])$fatal(1,"host timeout not latched");
   cmd(0,0,0,0);
   for(i=0;i<6;i=i+1)begin cmd(1,i,0,500);cmd(2,i,0,2500);end
   cmd(3,0,0,1500);cmd(4,0,0,1);
   if(!status[21] || status[15:8]!=0)$fatal(1,"partial pose was committed");
   cmd(0,0,0,0);
   cmd(3,3,1,1500);if(!status[21])$fatal(1,"wrist pose staging accepted");
   cmd(0,0,0,0);cmd(4,4,0,1);
   if(!status[21])$fatal(1,"wrist pose commit accepted");cmd(0,0,0,0);
   if(!status[1])$fatal(1,"atomic home capability missing");
   cmd(14,0,0,833);cmd(15,0,0,0);
   if(!status[21])$fatal(1,"partial home accepted");off_check();
   cmd(0,0,0,0);
   for(i=0;i<6;i++)cmd(3,0,i,1500);
   cmd(15,0,0,0);if(!status[21])$fatal(1,"ordinary pose reused as home");off_check();
   cmd(0,0,0,0);home_stage();cmd(4,0,0,1);
   if(!status[21])$fatal(1,"home staging reused as gesture");off_check();
   cmd(0,0,0,0);home_stage();cmd(0,0,0,0);cmd(15,0,0,0);
   if(!status[21])$fatal(1,"STOP retained old home staging");off_check();
   cmd(0,0,0,0);home_stage();cmd(1,5,0,500);cmd(15,0,0,0);
   if(!status[21])$fatal(1,"calibration edit retained old home staging");off_check();
   cmd(0,0,0,0);cmd(14,0,6,1500);
   if(!status[21])$fatal(1,"invalid home axis accepted");off_check();
   cmd(0,0,0,0);cmd(14,0,4,2501);
   if(!status[21])$fatal(1,"invalid home pulse accepted");off_check();
   cmd(0,0,0,0);cmd(1,4,0,1700);cmd(14,0,4,1600);
   if(!status[21])$fatal(1,"outside calibrated home travel accepted");off_check();
   cmd(0,0,0,0);cmd(1,4,0,500);
   for(j=0;j<2;j++)begin
     home_stage();cmd(15,0,0,0);
     if(status[20:19]!=1 || !status[0])$fatal(1,"atomic home not enabled");
     home_frame_check();
     // Keep targets across many shared frames, including ring/little finger.
     repeat(j==0?52:4)begin
       ticks(23000);beat(2);cmd(7,0,0,0);
       if(dut.target!==dut.current_us || status[22:21]!=0 || !status[0])
         $fatal(1,"home target drifted, source overrode it or lease expired");
     end
     if(j==0)begin
       cmd(5,4,0,1500);ticks(100);off_check();
       if(!status[21])$fatal(1,"single-axis command overwrote group hold");
     end else begin
       ticks(101000);off_check();
       if(!status[22])$fatal(1,"home heartbeat loss did not stop all axes");
       cmd(7,0,0,0);cmd(15,0,0,0);off_check();
     end
     cmd(0,0,0,0);ticks(22000);off_check();
   end
   home_stage();cmd(15,0,0,0);home_frame_check();
   cmd(8,0,0,0);off_check();cmd(15,0,0,0);off_check();
   cmd(0,0,0,0);cmd(15,0,0,0);
   if(!status[21])$fatal(1,"emergency stop retained a reusable home");off_check();
   cmd(0,0,0,0);
   // Actual controller reset clears calibration, group mode and pending data.
   home_stage();cmd(15,0,0,0);home_frame_check();
   rst_n=0;axis_rst_n=0;ticks(10);rst_n=1;axis_rst_n=1;ticks(100);off_check();
   cmd(15,0,0,0);if(!status[21])$fatal(1,"reset resurrected old home");off_check();
   cmd(0,0,0,0);
   for(i=0;i<6;i++)begin cmd(1,i,0,500);cmd(2,i,0,2500);end
   $display("TEST_PASS atomic home: no partial pulses, six same-frame rising edges, exact independent widths, ring/little hold beyond 1 second, STOP/calibration/reset invalidation, single-axis isolation, host watchdog and estop");
   for(j=0;j<8;j=j+1)if(j!=3 && j!=4)begin
     for(i=0;i<6;i=i+1)cmd(3,j,i,1400+j*100);
     cmd(4,j,0,1);
   end
   if(status[15:8]!=8'he7 || !status[17])$fatal(1,"calibration upload failed %h",status);
   beat(0);cmd(6,0,0,0);if(!status[21])$fatal(1,"auto accepted without MPU");
   cmd(0,0,0,0);auto_start(3);ticks(22000);
   if(status[20:19]!=2 || !status[18])$fatal(1,"auto failed to arm %h",status);
   if(dut.target[95:16]!={5{16'd1400}})$fatal(1,"startup wrist class did not use rest pose");
   beat(2);cmd(7,0,0,0);ticks(22000);
   if(dut.target!=={{5{16'd1600}},16'd1500})$fatal(1,"fingers not PL-driven / rotation taken from pose table");
   beat(3);cmd(9,0,0,1800);
   if(dut.target!=={{5{16'd1600}},16'd1800})$fatal(1,"wrist flexion changed fingers or MPU ignored");
   beat(4);cmd(9,0,0,1200);
   if(dut.target!=={{5{16'd1600}},16'd1200})$fatal(1,"wrist extension changed fingers or rotation stuck");
   beat(1);cmd(9,0,0,1700);
   if(dut.target!=={{5{16'd1500}},16'd1700})$fatal(1,"finger class overwrote MPU rotation");
   beat(7);ticks(100);off_check();
   if(!status[22])$fatal(1,"custom PS-only class did not trip");
   cmd(0,0,0,0);auto_start(0);
   // Heartbeats cannot hide loss of the authoritative PL result source.
   repeat(4)begin ticks(30000);cmd(7,0,0,0);cmd(9,0,0,1500);end
   off_check();if(!status[22])$fatal(1,"PL freshness watchdog failed");
   cmd(0,0,0,0);auto_start(0);
   // Host and decision leases cannot hide stale MPU data.
   repeat(4)begin ticks(30000);beat(4);cmd(7,0,0,0);end
   off_check();if(!status[22])$fatal(1,"MPU freshness watchdog failed");
   cmd(0,0,0,0);auto_start(0);cmd(9,0,0,499);ticks(100);off_check();
   if(!status[21])$fatal(1,"invalid rotation pulse accepted");
   cmd(0,0,0,0);beat(0);cmd(9,0,0,1500);cmd(11,0,0,0);
   if(!status[21])$fatal(1,"HDC enabled without a fresh HDC decision");
   cmd(0,0,0,0);beat(0);cmd(9,0,0,1500);cmd(10,5,0,0);cmd(11,0,0,0);ticks(22000);
   if(status[20:19]!=3 || dut.target!=={{5{16'd1900}},16'd1500})$fatal(1,"HDC custom1 target failed");
   beat(2);cmd(10,6,0,0);cmd(9,0,0,1800);
   if(dut.target!=={{5{16'd2000}},16'd1800})$fatal(1,"PL class overwrote HDC custom2 / MPU failed");
   cmd(10,3,0,0);cmd(10,4,0,0);
   if(dut.target!=={{5{16'd2000}},16'd1800})$fatal(1,"HDC wrist class changed fingers");
   cmd(10,7,0,0);
   if(dut.target[95:16]!={5{16'd2100}})$fatal(1,"HDC custom3 target failed");
   repeat(4)begin ticks(30000);beat(2);cmd(7,0,0,0);cmd(9,0,0,1800);end
   off_check();if(!status[22])$fatal(1,"HDC freshness watchdog failed");
   cmd(0,0,0,0);auto_start(0);cmd(10,5,0,0);ticks(100);off_check();
   if(!status[21])$fatal(1,"HDC mailbox overrode PL mode");
   cmd(0,0,0,0);cmd(4,5,0,0);beat(0);cmd(9,0,0,1500);cmd(10,5,0,0);cmd(11,0,0,0);
   if(!status[21])$fatal(1,"HDC unmapped custom row enabled");
   // Direct five-finger mailbox: class count is owned by the PS learner.
   cmd(0,0,0,0);cmd(12,0,1,1700);cmd(13,0,0,0);
   if(!status[21])$fatal(1,"partial direct target committed");off_check();
   cmd(0,0,0,0);cmd(12,0,0,1500);
   if(!status[21])$fatal(1,"direct target overwrote MPU axis");
   cmd(0,0,0,0);cmd(12,0,1,2501);
   if(!status[21])$fatal(1,"out-of-range direct target accepted");
   cmd(0,0,0,0);beat(0);cmd(9,0,0,1500);
   for(i=1;i<6;i=i+1)cmd(12,0,i,1700);
   cmd(13,0,0,0);cmd(11,0,0,1);ticks(22000);
   if(status[20:19]!=3 || dut.target!=={{5{16'd1700}},16'd1500})$fatal(1,"direct HDC start failed");
   for(i=1;i<6;i=i+1)begin
     cmd(12,0,i,1800);
     if(dut.target[95:16]!={5{16'd1700}})$fatal(1,"direct target updated before atomic commit");
   end
   beat(2);cmd(9,0,0,1900);cmd(13,0,0,0);
   if(dut.target!=={{5{16'd1800}},16'd1900})$fatal(1,"direct HDC target / MPU isolation failed");
   repeat(4)begin ticks(30000);beat(2);cmd(7,0,0,0);cmd(9,0,0,1800);end
   off_check();if(!status[22])$fatal(1,"direct HDC freshness watchdog failed");
   cmd(0,0,0,0);auto_start(0);cmd(12,0,1,1700);
   if(!status[21])$fatal(1,"direct HDC overrode autonomous PL source");
   cmd(0,0,0,0);auto_start(0);cmd(14,0,1,1300);ticks(100);off_check();
   if(!status[21])$fatal(1,"home stage overrode live automatic mode");
   cmd(0,0,0,0);cmd(5,2,0,1500);cmd(15,0,0,0);ticks(100);off_check();
   if(!status[21])$fatal(1,"home commit overrode live single-axis mode");
   cmd(0,0,0,0);auto_start(0);cmd(8,0,0,0);off_check();
   cmd(0,0,0,0);auto_start(0);decision_ready=0;ticks(100);off_check();
   cmd(0,0,0,0);cmd(1,0,0,700);
   if(status[15:8]!=0)$fatal(1,"calibration edit retained stale poses");
   $display("TEST_PASS hand control: ACK CDC, boot off, manual isolation, wrist hold, MPU rotation, legacy and direct HDC, atomic five-finger commit, source isolation, four watchdogs, estop");
`ifdef HAND_POLARITY_REFERENCE
   $display("TEST_PASS inverted PWM cycle-equivalence: all six pins complement V19, status/targets unchanged cycles=%0d",reference_cycles);
`endif
   $finish;
 end
endmodule

