`timescale 1ns/1ps
/* I2C pin-level models exercise the actual engines and sequencers. */
module lcd_i2c_model #(parameter integer ADDR=7'h68, REG_BYTES=1)(
    input wire scl, inout wire sda
);
    reg drive=0, enabled=1;
    assign sda=drive ? 1'b0 : 1'bz;
    reg [7:0] mem [0:65535];
    integer state=0, bits=0, reg_left=0, pointer=0, next_state=0, writes=0;
    reg [7:0] shift=0, tx=0;
    reg matched=0, read_mode=0, ack_clocked=0, master_ack=0;
    // state 1 RX addr, 2 RX reg, 3 RX data, 4 slave ACK,
    //       5 TX data, 6 master ACK, 7 wait STOP.
    always @(negedge sda) if(scl===1'b1) begin
        state=1; bits=0; shift=0; drive=0;
    end
    always @(posedge sda) if(scl===1'b1) begin
        state=0; drive=0;
    end
    always @(posedge scl) begin
        case(state)
        1,2,3: begin
            shift={shift[6:0],sda};
            if(bits==7) begin
                if(state==1) begin
                    matched=(shift[7:1]==ADDR)&&enabled;
                    read_mode=shift[0];
                    if(!read_mode) begin reg_left=REG_BYTES; pointer=0; end
                    next_state=read_mode ? 5 : 2;
                end else if(state==2) begin
                    pointer=((pointer<<8)|shift)&65535;
                    reg_left=reg_left-1;
                    next_state=reg_left ? 2 : 3;
                end else begin
                    if(matched) begin mem[pointer]=shift; writes=writes+1; end
                    pointer=(pointer+1)&65535; next_state=3;
                end
                state=4; ack_clocked=0; bits=0;
            end else bits=bits+1;
        end
        4: ack_clocked=1;
        5: begin
            if(bits==7) begin state=6; ack_clocked=0; end
            else bits=bits+1;
        end
        6: begin master_ack=!sda; ack_clocked=1; end
        endcase
    end
    always @(negedge scl) begin
        case(state)
        4: begin
            if(!ack_clocked) drive=matched;
            else begin
                drive=0;
                state=matched ? next_state : 7; bits=0; shift=0;
                if(state==5) begin tx=mem[pointer]; drive=!tx[7]; end
            end
        end
        5: drive=!tx[7-bits];
        6: begin
            drive=0;
            if(ack_clocked) begin
                if(master_ack) begin
                    pointer=(pointer+1)&65535; tx=mem[pointer];
                    bits=0; state=5; drive=!tx[7];
                end else state=7;
            end
        end
        default: drive=0;
        endcase
    end
endmodule

module lcd_input_tb;
    reg clk=0, rst=1;
    always #10 clk=~clk;
    wire mscl,tscl,trst;
    tri1 msda,tsda,tint;
    wire [31:0] mw,tw;
    wire [31:0] motion_a,motion_b,motion_c;
    mpu6050_tilt mpu(clk,rst,mscl,msda,mw,motion_a,motion_b,motion_c);
    touch_gt911 touch(clk,rst,trst,tscl,tsda,tint,tw);
    lcd_i2c_model #(7'h68,1) imu(mscl,msda);
    lcd_i2c_model #(7'h5d,2) gt(tscl,tsda);
    integer i,n,r,p,start_time;
    reg [6:0] seq_seen;
    task sample;
        begin
            seq_seen=mw[30:24];
            wait(mw[31] && mw[30:24]!=seq_seen);
            #1;
            r=$signed(mw[11:0]); p=$signed(mw[23:12]);
        end
    endtask
    task set_vector(input integer ax,ay,az,gx,gy);
        begin
            imu.mem['h3b]=(ax>>8)&255; imu.mem['h3c]=ax&255;
            imu.mem['h3d]=(ay>>8)&255; imu.mem['h3e]=ay&255;
            imu.mem['h3f]=(az>>8)&255; imu.mem['h40]=az&255;
            imu.mem['h41]=0; imu.mem['h42]=0;
            imu.mem['h43]=(gx>>8)&255; imu.mem['h44]=gx&255;
            imu.mem['h45]=(gy>>8)&255; imu.mem['h46]=gy&255;
            imu.mem['h47]=0; imu.mem['h48]=0;
        end
    endtask
    task touch_frame(input integer down,x,y);
        begin
            $display("PHASE touch request down=%d status=%h word=%h",down,gt.mem['h814e],tw);
            while(gt.mem['h814e]!=0) #10000;
            // Goodix 8-byte contact follows status at 0x814E. Keep this
            // map independent of the DUT's REG_POINT1 constant.
            gt.mem['h814f]=3; gt.mem['h8150]=x&255;
            gt.mem['h8151]=(x>>8)&255; gt.mem['h8152]=y&255;
            gt.mem['h8153]=(y>>8)&255; gt.mem['h8154]=7;
            gt.mem['h8155]=0; gt.mem['h8156]=0;
            gt.mem['h814e]=down ? 'h81 : 'h80;
            while(gt.mem['h814e]!=0) #10000;
            #100;
            $display("PHASE touch accepted down=%d word=%h",down,tw);
            if(tw[30]!==down[0]) $fatal(1,"Touch down/up mismatch %h",tw);
            if(down && (tw[23:12]!=x || tw[11:0]!=y)) $fatal(1,"Touch XY mismatch %h",tw);
        end
    endtask
    initial begin
        for(i=0;i<65536;i=i+1) begin imu.mem[i]=0;gt.mem[i]=0;end
        imu.mem['h75]='h68;
        set_vector(0,0,16384,0,0);
        #100 rst=0;
        wait(mw[31]); #1;
        $display("PHASE MPU link at %t writes=%d",$time,imu.writes);
        if(imu.writes!=5 || imu.mem['h6b]!=0 || imu.mem['h19]!=9 || imu.mem['h1a]!=3 ||
           imu.mem['h1b]!='h10 || imu.mem['h1c]!=0) $fatal(1,"MPU configuration address/data broken");
        r=$signed(mw[11:0]); p=$signed(mw[23:12]);
        if(r < -3 || r > 3 || p < -3 || p > 3) $fatal(1,"Flat MPU should be zero: r=%d p=%d",r,p);
        if(motion_a!==0 || motion_b!==32'h40000000 || motion_c!==0)
            $fatal(1,"Motion GPIO snapshot incorrect");
        start_time=$time;
        repeat(10) sample();
        $display("PHASE 100Hz at %t",$time);
        if(($time-start_time)<99900000 || ($time-start_time)>100100000)
            $fatal(1,"MPU start-to-start sample period is not 10ms");
        set_vector(0,8192,14189,0,0);
        repeat(110) sample();
        $display("PHASE roll30 at %t r=%d p=%d",$time,r,p);
        if(r<285 || r>305 || p < -3 || p > 3) $fatal(1,"Roll 30 degrees failed r=%d p=%d",r,p);
        set_vector(-8192,0,14189,0,0);
        repeat(150) sample();
        $display("PHASE pitch30 at %t r=%d p=%d",$time,r,p);
        if(p<285 || p>305 || r < -6 || r > 6) $fatal(1,"Pitch 30 degrees failed r=%d p=%d",r,p);
        set_vector(0,0,16384,33,0);
        repeat(180) sample();
        $display("PHASE gyro+ at %t r=%d",$time,r);
        if(r<1 || r>6) $fatal(1,"Small positive gyro step lost: %d",r);
        set_vector(0,0,16384,-33,0);
        repeat(180) sample();
        $display("PHASE gyro- at %t r=%d",$time,r);
        if(r > -1 || r < -7) $fatal(1,"Small negative gyro step lost: %d",r);
        set_vector(1234,-2345,15000,-321,654);
        imu.mem['h47]=8'hfc;imu.mem['h48]=8'h25; // gz = -987
        repeat(2) sample();
        if(motion_a!==32'h04d2f6d7 || motion_b!==32'h3a98febf || motion_c!==32'h028efc25)
            $fatal(1,"Signed six-axis snapshot packing failed: %h %h %h",motion_a,motion_b,motion_c);
        set_vector(0,0,-16384,0,-19680); // -600 deg/s, below new +/-1000 range
        repeat(2) sample();
        if(motion_b!==32'hc0000000 || motion_c!==32'hb3200000)
            $fatal(1,"Fast flip raw rate snapshot failed: %h %h",motion_b,motion_c);
        imu.enabled=0;
        wait(!mw[31]);
        imu.enabled=1;
        wait(mw[31]); #1;
        if(imu.writes<10) $fatal(1,"MPU recovery did not replay config");
        if(!tw[31]) $fatal(1,"Touch link should publish validity without press");
        touch_frame(1,300,40); touch_frame(0,300,40);
        touch_frame(1,360,220); touch_frame(0,360,220);
        touch_frame(1,799,479); touch_frame(0,799,479);
        gt.enabled=0;
        wait(!tw[30]); wait(!tw[31]);
        gt.enabled=1; wait(tw[31]);
        touch_frame(1,400,450); touch_frame(0,400,450);
        $display("TEST_PASS LCD_INPUT: +/-1000dps config, 600dps snapshot, signed six-axis burst, flat/30deg axes, 100Hz, slow signed gyro, recovery, touch press/release/repress");
        $finish;
    end
    initial begin
        #200000000;
        if(!mw[31]) $fatal(1,"MPU link timeout sq=%d eng=%d err=%b req=%b model=%d matched=%b ptr=%h shift=%h rx=%h writes=%d sda=%b",
            mpu.sq,mpu.eng_st,mpu.eng_ack_err,mpu.sq_req,imu.state,imu.matched,imu.pointer,imu.shift,mpu.rx_word,imu.writes,msda);
        repeat(12) #1000000000; $fatal(1,"LCD input test watchdog phase r=%d p=%d touch=%h model=%d ptr=%h sq=%d",r,p,tw,gt.state,gt.pointer,touch.sq);
    end
endmodule

