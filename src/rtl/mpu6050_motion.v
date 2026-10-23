/* Extended interface wrapper. Keeps the existing tilt frontend/test contract
 * while exposing its atomic six-axis snapshot to the display GPIOs. */
module mpu6050_motion(
    input wire clk, input wire rst_in,
    output wire mpu_scl, inout wire mpu_sda_io,
    output wire [31:0] mpu_data,
    output wire [31:0] motion_a,motion_b,motion_c
);
    mpu6050_tilt frontend(clk,rst_in,mpu_scl,mpu_sda_io,mpu_data,
                         motion_a,motion_b,motion_c);
endmodule
