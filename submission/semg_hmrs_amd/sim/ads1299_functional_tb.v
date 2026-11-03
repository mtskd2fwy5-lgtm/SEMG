`timescale 1ns/1ps
module ads1299_functional_tb;
    reg clk=0, rst_n=0, reconfig_n=1, drdy_n=1;
    wire sclk,din,cs_n,reset_n,adc_start,pwdn_n,sample_valid,frame_valid,busy,error,dout;
    wire signed [23:0] sample_data;
    wire [2:0] channel;
    wire [31:0] config_status;
    reg [1:0] fault=0;
    reg [4:0] fault_address=13;
    integer samples=0,frames=0,phase=0,k;
    wire variant4_done,variant6_done;
    ads1299_variant_check #(.N(4)) check4(.done(variant4_done));
    ads1299_variant_check #(.N(6)) check6(.done(variant6_done));
    reg [215:0] frame_bits={24'hC00000,24'h800000,24'hFFFFFF,24'd0,24'd1,
                           24'h7FFFFF,24'hAA55AA,24'd123456,24'hFE1DC0};
    always #20 clk=~clk;
    ads1299_spi #(.RESET_CYCLES(8),.POST_RESET_CYCLES(8),.BTN_DEBOUNCE_CYCLES(4)) dut (
        .clk(clk),.rst_n(rst_n),.start(1'b1),.reconfig_n(reconfig_n),
        .adc_drdy_n(drdy_n),.adc_dout(dout),.adc_sclk(sclk),.adc_din(din),
        .adc_cs_n(cs_n),.adc_reset_n(reset_n),.adc_start(adc_start),.adc_pwdn_n(pwdn_n),
        .sample_valid(sample_valid),.sample_data(sample_data),.sample_channel(channel),
        .frame_valid(frame_valid),.busy(busy),.error(error),.config_status(config_status));
    ads1299_model adc(.reset_n(reset_n),.cs_n(cs_n),.sclk(sclk),.din(din),
        .drdy_n(drdy_n),.frame_bits(frame_bits),.fault(fault),.fault_address(fault_address),.dout(dout));
    always @(posedge clk) begin
        if(sample_valid) begin
            if(error || !config_status[30]) $fatal(1,"sample without verified config");
            if(channel !== (samples%8) || sample_data !== frame_bits[191-(samples%8)*24 -:24])
                $fatal(1,"sample mismatch ch=%0d data=%h",channel,sample_data);
            samples=samples+1;
        end
        if(frame_valid) frames=frames+1;
    end
    task replay;
        begin
            @(negedge clk); reconfig_n=0;
            repeat(20) @(negedge clk); reconfig_n=1;
            wait(config_status==0);
        end
    endtask
    task check_registers;
        begin
            if(adc.registers[1]!==8'h92 || adc.registers[2]!==8'hC0 ||
               adc.registers[3]!==8'hEC || adc.registers[4]!==8'h00 ||
               adc.registers[13]!==8'h01 || adc.registers[14]!==8'h01)
                $fatal(1,"wrong real-acquisition/BIAS registers");
            for(k=5;k<=12;k=k+1) if(adc.registers[k]!==8'h40)
                $fatal(1,"CHn normal-input/gain mismatch");
        end
    endtask
    task good_boot;
        begin
            wait(adc_start); @(negedge clk);
            if(config_status!==32'hC0ED0101 || error) $fatal(1,"readback status %h",config_status);
            check_registers;
            drdy_n=0; repeat(12) @(negedge clk); drdy_n=1;
            wait(frames==(phase+1)); wait(!busy); @(negedge clk);
            if(samples!=(phase+1)*8) $fatal(1,"missing samples");
            phase=phase+1;
        end
    endtask
    task bad_boot;
        input [4:0] bad_address;
        begin
            wait(config_status[31]); repeat(100) @(negedge clk);
            if(!error || adc_start || config_status[30] || !config_status[29] ||
               config_status[28:24]!==bad_address || !cs_n || busy)
                $fatal(1,"failed readback not held: %h",config_status);
            drdy_n=0; repeat(12) @(negedge clk);drdy_n=1;
            repeat(5000) @(negedge clk);
            if(samples!=phase*8 || adc.starts!=phase) $fatal(1,"started after bad readback");
        end
    endtask
    initial begin
        repeat(5) @(negedge clk); rst_n=1;
        good_boot; $display("CHECK boot/actual RREG/RO bit/signed frame PASS");
        replay; good_boot; $display("CHECK button replay PASS");
        fault=1;fault_address=13;replay;bad_boot(13);
        if(config_status[15:8]!==0) $fatal(1,"actual corrupt BIAS P not exported");
        $display("CHECK BIAS P corruption/stop PASS");
        fault_address=14;replay;bad_boot(14);
        if(config_status[7:0]!==0) $fatal(1,"actual corrupt BIAS N not exported");
        fault_address=5;replay;bad_boot(5);
        $display("CHECK BIAS N/channel corruption PASS");
        fault=2;replay;bad_boot(1);
        if(config_status[23:0]!==0) $fatal(1,"stuck-low data not exported");
        fault=3;replay;bad_boot(1);
        if(config_status[23:0]!==24'hFFFFFF) $fatal(1,"stuck-high data not exported");
        $display("CHECK DOUT stuck-low/high PASS");
        fault=0; replay; good_boot;
        if(adc.writes!=8 || adc.reads!=8 || adc.starts!=3) $fatal(1,"unexpected transaction totals");
        if(!variant4_done || !variant6_done) $fatal(1,"parameterized channel tests incomplete");
        $display("TEST_PASS ADS1299 BIAS/readback/failure/recovery: 8 configurations, 3 signed frames");
        $finish;
    end
    initial begin #20_000_000; $fatal(1,"watchdog: status=%h phase=%0d",config_status,phase); end
endmodule

module ads1299_variant_check #(parameter integer N=4)(output reg done=0);
    reg clk=0,rst_n=0;
    wire sclk,din,cs_n,reset_n,adc_start,dout,error;
    wire [31:0] status;
    integer k;
    localparam [7:0] MASK=8'hFF>>(8-N);
    always #20 clk=~clk;
    ads1299_spi #(.CHANNELS(N),.RESET_CYCLES(8),.POST_RESET_CYCLES(8),
        .BIAS_SENSP_VALUE(8'hFF),.BIAS_SENSN_VALUE(8'hFF)) dut(
        .clk(clk),.rst_n(rst_n),.start(1'b1),.reconfig_n(1'b1),
        .adc_drdy_n(1'b1),.adc_dout(dout),.adc_sclk(sclk),.adc_din(din),
        .adc_cs_n(cs_n),.adc_reset_n(reset_n),.adc_start(adc_start),
        .adc_pwdn_n(),.sample_valid(),.sample_data(),.sample_channel(),.frame_valid(),.busy(),
        .error(error),.config_status(status));
    ads1299_model #(.CHANNELS(N)) adc(.reset_n(reset_n),.cs_n(cs_n),.sclk(sclk),
        .din(din),.drdy_n(1'b1),.frame_bits({(24+24*N){1'b0}}),
        .fault(2'd0),.fault_address(5'd0),.dout(dout));
    initial begin
        repeat(5) @(negedge clk);rst_n=1;
        wait(adc_start);@(negedge clk);
        if(status!=={16'hC0ED,MASK,MASK} || error) $fatal(1,"variant %0d readback %h",N,status);
        for(k=5+N;k<=12;k=k+1) if(adc.registers[k]!==0) $fatal(1,"reserved slot nonzero");
        if(adc.registers[13]!==MASK || adc.registers[14]!==MASK)
            $fatal(1,"variant masks at wrong fixed address");
        done=1; $display("CHECK ADS1299-%0d fixed 0D/0E addresses/masks PASS",N);
    end
endmodule

