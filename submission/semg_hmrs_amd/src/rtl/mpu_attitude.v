`timescale 1ns/1ps
// 100 MHz GPIO mailbox / attitude subsystem. The existing MPU frontend is
// 50 MHz; its six-axis bus is held for a full 10 ms between sequence changes.
// Three settling clocks after the synchronized sequence precede the capture.
module mpu_attitude(
    input wire clk, rst_n,
    input wire [31:0] mpu_data,motion_a,motion_b,motion_c,
    input wire [31:0] command,
    output reg [31:0] response
);
    (* ASYNC_REG="TRUE" *) reg [7:0] sequence_meta,sequence_sync;
    reg [7:0] sequence_stable,sequence_previous;
    reg [1:0] settling;
    reg [31:0] sensor_a,sensor_b,sensor_c;
    reg [6:0] sensor_seq;
    reg sensor_pulse,sensor_gap;
    reg [23:0] age;
    wire link_ok=sequence_sync[7] && age<24'd10000000; // 100 ms timeout
    reg reset_pulse;
    wire core_ready,core_valid;
    wire [959:0] core_result;
    wire [31:0] overruns;
    reg [959:0] snapshot;
    reg ack;
    reg last_link;
    wire core_reset_n=rst_n && link_ok && !reset_pulse;
    mpu_attitude_core core(clk,core_reset_n,sensor_pulse,sensor_seq,
        sensor_a,sensor_b,sensor_c,sensor_gap,core_ready,core_valid,core_result,overruns);
    always @(posedge clk)begin
        if(!rst_n)begin
            sequence_meta<=0;sequence_sync<=0;sequence_stable<=0;sequence_previous<=0;
            settling<=0;sensor_a<=0;sensor_b<=0;sensor_c<=0;sensor_seq<=0;sensor_pulse<=0;sensor_gap<=0;
            age<=24'hffffff;reset_pulse<=0;snapshot<=0;ack<=0;response<=0;last_link<=0;
        end else begin
            sequence_meta<=mpu_data[31:24];sequence_sync<=sequence_meta;
            sensor_pulse<=0;reset_pulse<=0;last_link<=link_ok;
            if(age!=24'hffffff)age<=age+1;
            if(sequence_sync!=sequence_stable)begin
                sequence_stable<=sequence_sync;settling<=3;
            end else if(settling!=0)begin
                settling<=settling-1;
                if(settling==1 && sequence_stable!=sequence_previous)begin
                    sequence_previous<=sequence_stable;
                    if(sequence_stable[7])begin
                        sensor_a<=motion_a;sensor_b<=motion_b;sensor_c<=motion_c;
                        sensor_seq<=sequence_stable[6:0];sensor_gap<=age>24'd8000000 && last_link;
                        // On first link-up the engine needs <400 clocks to
                        // clear RAM. Drop that frame; the next one initializes.
                        if(core_ready)sensor_pulse<=1;
                        age<=0;
                    end
                end
            end
            // Same clock as AXI GPIO. Payload remains held until next command.
            // bit31 toggles per transaction; op1=snapshot, op2=read, op3=zero.
            // Read responses carry signed 31-bit payload, ack in bit31.
            if(command[31]!=ack)begin
                ack<=command[31];response<={command[31],31'd0};
                case(command[27:24])
                1:begin
                    snapshot<=link_ok ? core_result : 960'd0;
                    response<={command[31],31'h17494d55};
                end
                2:begin
                    if(command[7:0]<30)response<={command[31],snapshot[command[7:0]*32+:31]};
                    else response<={command[31],31'h7fffffff};
                end
                3:begin reset_pulse<=1;snapshot<=0;end
                default:response<={command[31],31'h7fffffff};
                endcase
            end
            // Invalidate a previously frozen snapshot on disconnect. A stale
            // matrix is never returned as a current valid actuator target.
            if(!link_ok)snapshot<=0;
        end
    end
endmodule

