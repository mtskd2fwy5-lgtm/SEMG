`timescale 1ns/1ps
// Pin-level register/data model. Registers come only from captured DIN.
module ads1299_model #(parameter integer CHANNELS = 8) (
    input wire reset_n, cs_n, sclk, din, drdy_n,
    input wire [24+24*CHANNELS-1:0] frame_bits,
    input wire [1:0] fault, // 1=corrupt one read byte; 2/3=DOUT stuck low/high
    input wire [4:0] fault_address,
    output reg dout = 0
);
    reg [7:0] registers [0:23];
    reg [7:0] rx, opcode, count_byte, out_byte;
    integer bit_count=0, byte_count=0, frame_bit=0, i, address;
    integer writes=0, reads=0, starts=0, resets=0;
    reg continuous=1, started=0, pending=0, data_transfer=0, selected=0;
    time last_fall=0, last_rise=0, byte_end=0;
    always @(negedge reset_n) begin
        for(i=0;i<24;i=i+1) registers[i]=0;
        registers[1]=8'h96; registers[2]=8'hC0; registers[3]=8'h60;
        for(i=5;i<5+CHANNELS;i=i+1) registers[i]=8'h61;
        continuous=1; started=0; pending=0; resets=resets+1;
    end
    always @(negedge drdy_n) pending=1;
    always @(negedge cs_n) begin
        if(!reset_n) $fatal(1,"MODEL CS active during reset");
        selected=1; bit_count=0; byte_count=0; frame_bit=0;
        rx=0; opcode=0; count_byte=0; byte_end=0;
        data_transfer=started && continuous && pending;
    end
    always @(posedge sclk) if(selected) begin
        if(byte_end && $time-byte_end<1954) $fatal(1,"MODEL tSDECODE violation");
        byte_end=0;
        if(last_fall && $time-last_fall<300) $fatal(1,"MODEL SCLK low too short");
        last_rise=$time; dout=0;
        if(data_transfer) begin
            if(frame_bit>=24+24*CHANNELS) $fatal(1,"MODEL extra frame clock");
            dout=frame_bits[24+24*CHANNELS-1-frame_bit]; frame_bit=frame_bit+1;
        end else if(opcode[7:5]==3'b001 && byte_count>=2) begin
            address=opcode[4:0]+byte_count-2;
            if(address>23) $fatal(1,"MODEL register address overflow");
            out_byte=registers[address];
            if(address==3) out_byte=out_byte|8'h01; // read-only BIAS_STAT may change
            if(fault==1 && address==fault_address) out_byte=out_byte^8'h01;
            if(fault==2) out_byte=8'h00;
            if(fault==3) out_byte=8'hFF;
            dout=out_byte[7-bit_count];
        end
    end
    always @(negedge sclk) if(selected) begin
        if($time-last_rise<300) $fatal(1,"MODEL SCLK high too short");
        last_fall=$time;
        if(!data_transfer) begin
            rx={rx[6:0],din};
            if(bit_count==7) begin
                if(byte_count==0) begin
                    opcode=rx;
                    case(rx)
                        8'h11: continuous=0;
                        8'h10: begin
                            if(reads==0) $fatal(1,"MODEL RDATAC before RREG");
                            continuous=1;
                        end
                        8'h08: begin started=1; starts=starts+1; end
                        default: if(rx[7:5]!=3'b001 && rx[7:5]!=3'b010)
                            $fatal(1,"MODEL unexpected command %h",rx);
                    endcase
                    if((rx[7:5]==3'b001 || rx[7:5]==3'b010) && continuous)
                        $fatal(1,"MODEL register command before SDATAC");
                end else if(byte_count==1) count_byte=rx;
                else if(opcode[7:5]==3'b010) begin
                    address=opcode[4:0]+byte_count-2;
                    if(address>=5+CHANNELS && address<=12) registers[address]=0;
                    else registers[address]=rx;
                end
                byte_count=byte_count+1; bit_count=0; byte_end=$time;
            end else bit_count=bit_count+1;
        end
    end
    always @(posedge cs_n) if(selected) begin
        if(sclk!==0 || $time-last_fall<1954) $fatal(1,"MODEL CS hold violation");
        if(data_transfer) begin
            if(frame_bit!=24+24*CHANNELS) $fatal(1,"MODEL incomplete frame");
            pending=0;
        end else begin
            if(bit_count!=0) $fatal(1,"MODEL incomplete byte");
            if(opcode[7:5]==3'b001 || opcode[7:5]==3'b010) begin
                if(byte_count!=count_byte+3) $fatal(1,"MODEL wrong register count");
                if(opcode[7:5]==3'b010) writes=writes+1; else reads=reads+1;
            end else if(byte_count!=1) $fatal(1,"MODEL extra command byte");
        end
        selected=0; dout=0;
    end
endmodule

