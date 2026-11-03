`timescale 1ns/1ps
// Six-axis hand controller. Command payload is held until the returned ACK.
// [31]toggle [30:27]opcode [26:24]row/channel [18:16]axis [15:0]value.
// 0 stop/clear, 1 lower, 2 upper, 3 stage target, 4 commit row,
// 5 one-axis manual test, 6 automatic enable, 7 host lease, 8 emergency stop,
// 9 calibrated MPU rotation target (us), 10 fresh PS HDC class,
// 11 explicitly enable HDC source. Only opcode 9 owns auto axis 0.
// 12 stages a live HDC finger target, 13 commits all five atomically.
// Opcode 11 value=1 selects live targets, decoupling gesture IDs from PL rows.
// 14 stages a home axis; 15 starts the complete six-axis target atomically.
// No pose or mechanical calibration is supplied by default.
module hand_control_active_high_reference #(
    parameter integer CLOCK_HZ=25000000,
    parameter integer TIMEOUT_MS=250
)(
    input wire clk,rst_n,axis_clk,axis_rst_n,
    input wire [31:0] command,
    output wire [31:0] status,
    input wire decision_valid,decision_ready,
    input wire [2:0] decision_class,
    output wire [5:0] pwm
);
    localparam integer TIMEOUT_TICKS=(CLOCK_HZ/1000)*TIMEOUT_MS;
    (* ASYNC_REG="TRUE" *) reg req_meta,req_sync;
    reg ack;
    reg [1:0] mode;
    reg error,trip;
    reg [31:0] host_age,decision_age,rotation_age,hdc_age;
    reg [2:0] accepted_class,hdc_class,test_channel;
    reg [15:0] rotation_target;
    reg hdc_direct,hdc_direct_valid;
    reg [79:0] hdc_staging,hdc_target;
    reg [4:0] hdc_staging_mask;
    reg [15:0] lower[0:5],upper[0:5];
    reg [5:0] lower_mask,upper_mask;
    reg [95:0] poses[0:7];
    reg [7:0] pose_mask;
    reg [95:0] staging;
    reg [5:0] staging_mask;
    reg [2:0] staging_row;
    reg [95:0] test_target;
    reg test_group;
    reg target_valid;
    wire [2:0] execution_class=mode==3?hdc_class:accepted_class;
    wire [79:0] fingers=(mode==3 && hdc_direct)?hdc_target:poses[execution_class][95:16];
    wire [95:0] auto_target={fingers,rotation_target};
    wire [95:0] target=mode==1?test_target:auto_target;
    wire all_cal=(&lower_mask)&&(&upper_mask);
    wire fresh=decision_ready && decision_age<TIMEOUT_TICKS;
    wire rotation_fresh=rotation_age<TIMEOUT_TICKS;
    wire source_fresh=mode==3?(hdc_age<TIMEOUT_TICKS):accepted_class<3;
    wire mapping_valid=(mode==3 && hdc_direct)?hdc_direct_valid:pose_mask[execution_class];
    wire enabled=mode!=0 && !trip && !error && host_age<TIMEOUT_TICKS &&
                 (mode==1 || (fresh && rotation_fresh && source_fresh && mapping_valid));
    wire armed,pwm_fault;
    wire [5:0] pulses;
    wire [95:0] current_us;
    // Ordinary manual tests isolate one axis. Explicit home commits hold all six.
    assign pwm=enabled?(pulses & ((mode==1 && !test_group)?(6'b000001<<test_channel):6'b111111)):6'b0;
    hand_servo_pwm #(.CLOCK_HZ(CLOCK_HZ),.WATCHDOG_MS(TIMEOUT_MS)) generator(
        .clk(clk),.rst_n(rst_n),.enable(enabled),.estop(trip),
        .command_valid(target_valid && enabled),.command_us(target),
        .pwm(pulses),.armed(armed),.fault(pwm_fault),.current_us(current_us));
    wire [3:0] op=command[30:27];
    wire [2:0] row=command[26:24],axis=command[18:16];
    wire [15:0] value=command[15:0];
    wire legal_pulse=value>=500 && value<=2500;
    integer i;
    reg legal_row;
    always @(posedge clk)begin
        if(!rst_n)begin
            req_meta<=0;req_sync<=0;ack<=0;mode<=0;error<=0;trip<=0;
            host_age<=TIMEOUT_TICKS;decision_age<=TIMEOUT_TICKS;rotation_age<=TIMEOUT_TICKS;
            hdc_age<=TIMEOUT_TICKS;hdc_class<=0;
            hdc_direct<=0;hdc_direct_valid<=0;hdc_staging<=0;hdc_target<=0;hdc_staging_mask<=0;
            accepted_class<=0;test_channel<=0;lower_mask<=0;upper_mask<=0;
            rotation_target<=1500;
            pose_mask<=0;staging<=0;staging_mask<=0;staging_row<=0;
            test_target<={6{16'd1500}};test_group<=0;target_valid<=0;
            for(i=0;i<6;i=i+1)begin lower[i]<=1500;upper[i]<=1500;end
            for(i=0;i<8;i=i+1)poses[i]<=0;
        end else begin
            req_meta<=command[31];req_sync<=req_meta;target_valid<=0;
            if(host_age<TIMEOUT_TICKS)host_age<=host_age+1;
            if(decision_age<TIMEOUT_TICKS)decision_age<=decision_age+1;
            if(rotation_age<TIMEOUT_TICKS)rotation_age<=rotation_age+1;
            if(hdc_age<TIMEOUT_TICKS)hdc_age<=hdc_age+1;
            if(decision_valid && decision_ready)begin
                // Wrist flexion/extension remain recognized classes, but the
                // six-axis hand has no wrist joint. Keep the last finger pose.
                if(decision_class<3 || decision_class>4)accepted_class<=decision_class;
                decision_age<=0;
                if(mode==2)target_valid<=1;
            end
            if(mode!=0 && (host_age>=TIMEOUT_TICKS ||
               error || (mode>=2 && (!fresh || !rotation_fresh || !source_fresh || !mapping_valid)) || pwm_fault))begin
                mode<=0;trip<=1;test_group<=0;staging_mask<=0;
            end
            if(req_sync!=ack)begin
                ack<=req_sync;
                case(op)
                    0:begin
                        mode<=0;trip<=0;error<=0;staging_mask<=0;test_group<=0;
                        rotation_age<=TIMEOUT_TICKS;hdc_age<=TIMEOUT_TICKS;hdc_class<=0;
                        hdc_direct<=0;hdc_direct_valid<=0;hdc_staging_mask<=0;
                    end
                    1,2:begin
                        if(mode!=0 || row>=6 || !legal_pulse)error<=1;
                        else begin
                            // Any changed calibration invalidates all saved PL rows.
                            pose_mask<=0;
                            staging_mask<=0;
                            rotation_age<=TIMEOUT_TICKS;
                            hdc_direct_valid<=0;hdc_staging_mask<=0;
                            if(op==1)begin lower[row]<=value;lower_mask[row]<=1;end
                            else begin upper[row]<=value;upper_mask[row]<=1;end
                        end
                    end
                    3:begin
                        if(mode!=0 || axis>=6 || !legal_pulse || row==3 || row==4)error<=1;
                        else begin
                            if(staging_mask==0 || staging_row!=row)begin
                                staging_mask<=6'b000001<<axis;staging_row<=row;
                            end else staging_mask[axis]<=1;
                            staging[axis*16+:16]<=value;
                        end
                    end
                    4:begin
                        legal_row=all_cal && staging_mask==63 && staging_row==row;
                        for(i=0;i<6;i=i+1)
                            if(lower[i]>upper[i] || staging[i*16+:16]<lower[i] ||
                               staging[i*16+:16]>upper[i])legal_row=0;
                        if(mode!=0 || ((row==3 || row==4) && value!=0) || (value!=0 && !legal_row))error<=1;
                        else begin
                            if(value==0)pose_mask[row]<=0;
                            else begin poses[row]<=staging;pose_mask[row]<=1;end
                            staging_mask<=0;
                        end
                    end
                    5:begin
                        // Explicit manual test: protocol limits only, no automatic sweep.
                        if(row>=6 || !legal_pulse || trip || error || mode>=2 ||
                           (mode==1 && (test_group || row!=test_channel)))error<=1;
                        else begin
                            mode<=1;test_group<=0;test_channel<=row;test_target<={6{16'd1500}};
                            test_target[row*16+:16]<=value;host_age<=0;target_valid<=1;
                        end
                    end
                    6:begin
                        // This firmware only has an authoritative five-class PL source.
                        if(mode!=0 || trip || error || !all_cal || !fresh || !rotation_fresh ||
                           accepted_class>=3 || !pose_mask[accepted_class])error<=1;
                        else begin mode<=2;host_age<=0;target_valid<=1;end
                    end
                    7:begin if(mode!=0)begin host_age<=0;target_valid<=1;end end
                    8:begin mode<=0;trip<=1;test_group<=0;staging_mask<=0;end
                    9:begin
                        // Live MPU-mapped palm rotation. The host maps the
                        // calibrated forearm rotation angle into axis-0 us.
                        if(mode==1 || trip || error || !legal_pulse || !lower_mask[0] ||
                           !upper_mask[0] || value<lower[0] || value>upper[0])error<=1;
                        else begin rotation_target<=value;rotation_age<=0;target_valid<=1;end
                    end
                    10:begin
                        // HDC is a separately selected PS source; a command
                        // never overrides the autonomous PL class in mode 2.
                        if(mode==1 || mode==2 || (mode==3 && hdc_direct) || trip || error)error<=1;
                        else begin
                            if(row!=3 && row!=4)hdc_class<=row;
                            hdc_age<=0;if(mode==3)target_valid<=1;
                        end
                    end
                    11:begin
                        if(mode!=0 || trip || error || !all_cal || !fresh ||
                           !rotation_fresh || hdc_age>=TIMEOUT_TICKS || value>1 ||
                           (value==1?!hdc_direct_valid:!pose_mask[hdc_class]))error<=1;
                        else begin mode<=3;hdc_direct<=value==1;host_age<=0;target_valid<=1;end
                    end
                    12:begin
                        if(mode==1 || mode==2 || (mode==3 && !hdc_direct) || trip || error ||
                           axis<1 || axis>5 || !legal_pulse)error<=1;
                        else if(!lower_mask[axis] || !upper_mask[axis] ||
                                value<lower[axis] || value>upper[axis])error<=1;
                        else begin
                            hdc_staging[(axis-1)*16+:16]<=value;hdc_staging_mask[axis-1]<=1;
                        end
                    end
                    13:begin
                        if(mode==1 || mode==2 || (mode==3 && !hdc_direct) || trip || error ||
                           !all_cal || hdc_staging_mask!=31)error<=1;
                        else begin
                            hdc_target<=hdc_staging;hdc_staging_mask<=0;hdc_direct_valid<=1;
                            hdc_age<=0;target_valid<=1;
                        end
                    end
                    14:begin
                        // Row 3 is forbidden to gesture staging; tag the shared
                        // buffer so a partial/old pose can never start a home.
                        if(mode!=0 || trip || error || axis>=6 || !legal_pulse)error<=1;
                        else if(!lower_mask[axis] || !upper_mask[axis] ||
                                lower[axis]>upper[axis] || value<lower[axis] || value>upper[axis])error<=1;
                        else begin
                            if(staging_mask==0 || staging_row!=3)begin
                                staging_mask<=6'b000001<<axis;staging_row<=3;
                            end else staging_mask[axis]<=1;
                            staging[axis*16+:16]<=value;
                        end
                    end
                    15:begin
                        legal_row=all_cal && staging_mask==63 && staging_row==3;
                        for(i=0;i<6;i=i+1)
                            if(lower[i]>upper[i] || staging[i*16+:16]<lower[i] ||
                               staging[i*16+:16]>upper[i])legal_row=0;
                        if(mode!=0 || trip || error || !legal_row)error<=1;
                        else begin
                            test_target<=staging;staging_mask<=0;test_channel<=0;
                            test_group<=1;mode<=1;host_age<=0;target_valid<=1;
                        end
                    end
                    default:error<=1;
                endcase
            end
        end
    end
    // Coherent status snapshot including ACK, instead of separately sampling bits.
    wire [31:0] state_word={8'h48,ack,(trip||pwm_fault),error,mode,armed,
        all_cal,fresh,pose_mask,execution_class,test_channel,1'b1,(mode==1 && test_group)};
    reg [31:0] status_hold,status_axis;
    reg status_req,status_ack;
    (* ASYNC_REG="TRUE" *) reg sa_meta,sa_sync,sr_meta,sr_sync;
    always @(posedge clk)begin
        if(!rst_n)begin status_hold<=0;status_req<=0;sa_meta<=0;sa_sync<=0;end
        else begin
            sa_meta<=status_ack;sa_sync<=sa_meta;
            if(status_req==sa_sync && status_hold!=state_word)begin
                status_hold<=state_word;status_req<=!status_req;
            end
        end
    end
    always @(posedge axis_clk)begin
        if(!axis_rst_n)begin status_axis<=0;status_ack<=0;sr_meta<=0;sr_sync<=0;end
        else begin
            sr_meta<=status_req;sr_sync<=sr_meta;
            if(sr_sync!=status_ack)begin status_axis<=status_hold;status_ack<=sr_sync;end
        end
    end
    assign status=status_axis;
endmodule
