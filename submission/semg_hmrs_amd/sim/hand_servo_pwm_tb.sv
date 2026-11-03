`timescale 1ns/1ps
module hand_servo_pwm_tb;
reg clk=0;always #5 clk=~clk;
reg rst_n=0,enable=0,estop=0,valid=0;reg[95:0] cmd=0;
wire[5:0] pwm;wire armed,fault;wire[95:0] current_us;
hand_servo_pwm #(.CLOCK_HZ(1000000),.WATCHDOG_MS(60)) dut(
 .clk(clk),.rst_n(rst_n),.enable(enable),.estop(estop),.command_valid(valid),.command_us(cmd),
 .pwm(pwm),.armed(armed),.fault(fault),.current_us(current_us));
integer i,ticks;reg [95:0] before_us;
task command(input integer us);begin
 for(i=0;i<6;i=i+1)cmd[16*i+:16]=us+i*10;
 valid=1;@(negedge clk);valid=0;
end endtask
task frame;begin
 ticks=0;while(pwm!=63 && ticks<21000)begin @(negedge clk);ticks=ticks+1;end
 if(pwm!=63)$fatal(1,"frame missing");
end endtask
initial begin
 repeat(4)@(negedge clk);rst_n=1;command(1000);repeat(21000)@(negedge clk);
 if(pwm || armed)$fatal(1,"disabled PWM");
 enable=1;command(1000);frame();
 if(!armed || fault || current_us[15:0]!=1000)$fatal(1,"first target");
 ticks=0;while(pwm[0])begin @(negedge clk);ticks=ticks+1;end
 if(ticks!=1000)$fatal(1,"pulse length %0d",ticks);
 command(1400);before_us=current_us;repeat(50)@(negedge clk);
 if(current_us!=before_us)$fatal(1,"midframe target change");
 frame();if(current_us[15:0]!=1020)$fatal(1,"slew %0d",current_us[15:0]);
 @(negedge clk);command(499);
 if(!fault || armed || pwm)$fatal(1,"invalid command must stop immediately");
 enable=0;@(negedge clk);enable=1;command(1200);frame();
 estop=1;@(negedge clk);
 if(!fault || pwm || armed)$fatal(1,"estop");
 estop=0;command(1200);repeat(21000)@(negedge clk);
 if(pwm || armed || !fault)$fatal(1,"latched estop");
 enable=0;@(negedge clk);enable=1;command(1200);frame();
 repeat(61000)@(negedge clk);
 if(pwm || armed || !fault)$fatal(1,"watchdog");
 // Invalid command on exactly frame tick zero must never create a pulse.
 enable=0;@(negedge clk);enable=1;command(1200);frame();
 while(dut.frame_tick!=0)@(negedge clk);
 command(499);if(pwm || armed || !fault)$fatal(1,"frame-boundary invalid command");
 $display("TEST_PASS six-channel PWM pulse/atomic/slew/disabled/watchdog/estop/range");$finish;
end
initial begin #5000000;$fatal(1,"PWM test watchdog");end
endmodule

