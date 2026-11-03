`timescale 1ns/1ps
// Generic six-channel execution primitive. No gesture/end-point defaults:
// every target must be calibrated outside this block before enabling it.
// No pin assignment, no power drive. Emergency stop disables signals only;
// a real emergency stop must also control actuator power appropriately.
module hand_servo_pwm #(
    parameter integer CLOCK_HZ=25000000,
    parameter integer FRAME_US=20000,
    parameter integer CHANNELS=6,
    parameter integer WATCHDOG_MS=250,
    parameter integer MIN_US=500,
    parameter integer MAX_US=2500,
    parameter integer MAX_STEP_US=20
)(
    input wire clk,rst_n,
    input wire enable,estop,
    input wire command_valid,
    input wire [CHANNELS*16-1:0] command_us,
    output reg [CHANNELS-1:0] pwm,
    output reg armed,
    output reg fault,
    output reg [CHANNELS*16-1:0] current_us
);
    localparam integer TICKS_US=CLOCK_HZ/1000000;
    localparam integer FRAME_TICKS=FRAME_US*TICKS_US;
    localparam integer WD_TICKS=(CLOCK_HZ/1000)*WATCHDOG_MS;
    localparam integer US_W=(FRAME_US<2)?1:$clog2(FRAME_US);
    localparam integer SUB_W=(TICKS_US<2)?1:$clog2(TICKS_US);
    localparam integer AGE_W=(WD_TICKS<2)?1:$clog2(WD_TICKS+1);
    reg [US_W-1:0] frame_us;
    reg [SUB_W-1:0] sub_tick;
    reg [AGE_W-1:0] age;
    // Kept as a debug alias; unused in the synthesized datapath.
    wire [31:0] frame_tick=frame_us*TICKS_US+sub_tick;
    reg [15:0] pending[0:CHANNELS-1];
    reg have_target;
    integer i;
    reg command_ok;
    reg [15:0] position,target;
    always @(posedge clk) begin
        if(!rst_n)begin
            pwm<=0;armed<=0;fault<=0;current_us<=0;frame_us<=0;sub_tick<=0;age<=0;have_target<=0;
            for(i=0;i<CHANNELS;i=i+1)pending[i]<=0;
        end else if(!enable || estop)begin
            pwm<=0;armed<=0;frame_us<=0;sub_tick<=0;age<=0;have_target<=0;
            if(estop)fault<=1;
            else fault<=0; // disabling explicitly clears the latched fault
        end else if(fault)begin pwm<=0;armed<=0;have_target<=0;end
        else begin
            command_ok=1;
            if(age<WD_TICKS)age<=age+1;
            if(command_valid)begin
                command_ok=1;
                for(i=0;i<CHANNELS;i=i+1)
                    if(command_us[i*16+:16]<MIN_US || command_us[i*16+:16]>MAX_US)command_ok=0;
                if(command_ok)begin
                    for(i=0;i<CHANNELS;i=i+1)pending[i]<=command_us[i*16+:16];
                    age<=0;have_target<=1;
                end else begin fault<=1;armed<=0;pwm<=0;end
            end
            if(age>=WD_TICKS && !command_valid)begin
                armed<=0;pwm<=0;have_target<=0;fault<=1;
            end else begin
                if(sub_tick==TICKS_US-1)begin
                    sub_tick<=0;
                    if(frame_us==FRAME_US-1)frame_us<=0;
                    else frame_us<=frame_us+1'b1;
                end else sub_tick<=sub_tick+1'b1;
                if(frame_us==0 && sub_tick==0)begin
                    if(have_target)begin
                        armed<=1;
                        for(i=0;i<CHANNELS;i=i+1)begin
                            position=current_us[i*16+:16];target=pending[i];
                            if(!armed)position=target;
                            else if(position<target)position=target-position>MAX_STEP_US?position+MAX_STEP_US:target;
                            else if(position>target)position=position-target>MAX_STEP_US?position-MAX_STEP_US:target;
                            current_us[i*16+:16]<=position;
                            pwm[i]<=1;
                        end
                    end else pwm<=0;
                end else for(i=0;i<CHANNELS;i=i+1)
                    if(frame_us>=current_us[i*16+:16])pwm[i]<=0;
            end
            // Invalid commands must win even at the atomic frame boundary.
            if(command_valid && !command_ok)begin
                fault<=1;armed<=0;pwm<=0;have_target<=0;
            end
        end
    end
endmodule

