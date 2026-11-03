`timescale 1ns/1ps
// DDR-resident, serial NMF / HDC arithmetic accelerator. PS supplies descriptors
// and labels only. Query encoding, signed prototype updates, dot products,
// class selection and margin division all execute here. No fixed class slots.
// GPIO command: toggle31, opcode30:24, payload23:0.
// 1/2 stage operand low/high16; 3 commit register0..4; 4 launch job1..4.
// Registers: input pointer, scale pointer, prototype pointer, output pointer,
// count (scale: number of 8-word samples; prediction: number of classes).
// Status: toggle31, busy30, error29, quarantined28, ABI[23:16]=0x13.
// Jobs: 1 NMF; 2 extend eight-channel maxima; 3 encode+update one prototype;
//       4 legacy Q16 prediction; 5 Q32 training; 6 Q32 prediction.
// Prediction result3 is the score gap in 0.01 percent units; result1 keeps
// the legacy integer-percent meaning. Both memories remain immutable.
module emg_learning_accel #(
    parameter HDC_MEM="data/models/hdc_memory.mem",
    parameter integer WATCHDOG=10000000
)(
    (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME clk, ASSOCIATED_BUSIF M_AXI, ASSOCIATED_RESET rst_n, FREQ_HZ 100000000" *)
    input wire clk,
    (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW" *) input wire rst_n,
    input wire [31:0] command, output wire [31:0] status,
    output reg [31:0] m_axi_awaddr,output wire [7:0] m_axi_awlen,
    output wire [2:0] m_axi_awsize,output wire [1:0] m_axi_awburst,
    output reg m_axi_awvalid,input wire m_axi_awready,
    output reg [31:0] m_axi_wdata,output wire [3:0] m_axi_wstrb,
    output wire m_axi_wlast,output reg m_axi_wvalid,input wire m_axi_wready,
    input wire [1:0] m_axi_bresp,input wire m_axi_bvalid,output wire m_axi_bready,
    output reg [31:0] m_axi_araddr,output wire [7:0] m_axi_arlen,
    output wire [2:0] m_axi_arsize,output wire [1:0] m_axi_arburst,
    output reg m_axi_arvalid,input wire m_axi_arready,
    input wire [31:0] m_axi_rdata,input wire [1:0] m_axi_rresp,
    input wire m_axi_rlast,m_axi_rvalid,output wire m_axi_rready
);
    assign m_axi_awlen=0;assign m_axi_awsize=2;assign m_axi_awburst=1;
    assign m_axi_arlen=0;assign m_axi_arsize=2;assign m_axi_arburst=1;
    assign m_axi_wstrb=15;assign m_axi_wlast=1;
    reg [2:0] bus_state;
    assign m_axi_bready=bus_state==3;
    assign m_axi_rready=bus_state==2;
    reg bus_go,bus_write,bus_done,bus_error;
    reg [31:0] bus_addr,bus_data,bus_result;
    function allowed;
        input [31:0] a;
        begin allowed=a[1:0]==0 && ((a>=32'h12000000 && a<32'h16000000) ||
                        (a>=32'h11100000 && a<32'h11101000));end
    endfunction
    // Independent AXI channels: AW and W may accept on different cycles.
    // On a core timeout, outstanding AXI handshakes are still drained; the
    // accelerator is quarantined until reset and never starts another job.
    always @(posedge clk) begin
        if(!rst_n)begin
            bus_state<=0;bus_done<=0;bus_error<=0;bus_result<=0;
            m_axi_arvalid<=0;m_axi_awvalid<=0;m_axi_wvalid<=0;
            m_axi_araddr<=0;m_axi_awaddr<=0;m_axi_wdata<=0;
        end else begin
            bus_done<=0;
            case(bus_state)
            0: if(bus_go)begin
                bus_error<=0;
                if(!allowed(bus_addr))begin bus_error<=1;bus_done<=1;end
                else if(bus_write)begin
                    m_axi_awaddr<=bus_addr;m_axi_wdata<=bus_data;
                    m_axi_awvalid<=1;m_axi_wvalid<=1;bus_state<=1;
                end else begin m_axi_araddr<=bus_addr;m_axi_arvalid<=1;bus_state<=4;end
            end
            1: begin
                if(m_axi_awready)m_axi_awvalid<=0;
                if(m_axi_wready)m_axi_wvalid<=0;
                if((!m_axi_awvalid || m_axi_awready) && (!m_axi_wvalid || m_axi_wready))bus_state<=3;
            end
            2: if(m_axi_rvalid)begin
                bus_result<=m_axi_rdata;bus_error<=m_axi_rresp!=0 || !m_axi_rlast;
                bus_done<=1;bus_state<=0;
            end
            3: if(m_axi_bvalid)begin bus_error<=m_axi_bresp!=0;bus_done<=1;bus_state<=0;end
            4: if(m_axi_arready)begin m_axi_arvalid<=0;bus_state<=2;end
            default:bus_state<=0;
            endcase
        end
    end
    reg ack,busy,error,poison;
    assign status={ack,busy,error,poison,4'd0,8'h13,16'd0};
    reg [31:0] arg[0:4];reg [31:0] operand;
    reg [7:0] state,ret_state,div_ret,mul_ret;
    reg [3:0] job;
    reg [31:0] timer;
    reg div_start;wire div_busy,div_done;wire [63:0] quotient;
    reg [63:0] div_num,div_den;
    learning_div64 divide(.clk(clk),.rst_n(rst_n),.start(div_start),
        .numerator(div_num),.denominator(div_den),.busy(div_busy),.done(div_done),.quotient(quotient));
    // Single registered 32x32 multiplier reused for the complete NMF solve.
    reg [31:0] ma,mb;reg [63:0] product;
    always @(posedge clk)product<=ma*mb;
    reg [31:0] e[0:7],scale[0:7],x[0:7],c[0:2],next_c[0:2],wte[0:2];
    reg [31:0] results[0:7];
    reg [63:0] acc,total,err_sum,denom;
    reg [3:0] i,j,k,it;
    reg [31:0] sample,cls;
    reg [10:0] word_idx;
    reg [4:0] level[0:7];
    reg [3:0] clips;
    (* rom_style="block" *) reg [31:0] memory[0:4095];
    initial $readmemh(HDC_MEM,memory);
    reg [11:0] rom_addr;reg [31:0] rom_data,cim_word,b0,b1,b2,b3;
    always @(posedge clk)rom_data<=memory[rom_addr];
    wire [31:0] vote=~(cim_word^rom_data);
    wire [31:0] carry0=b0&vote,carry1=b1&carry0,carry2=b2&carry1;
    (* ram_style="distributed" *) reg [31:0] query[0:63];
    reg [31:0] qword,packed_proto;
    reg signed [31:0] score,top,second;
    reg [31:0] best,saturations;
    reg signed [16:0] p0,p1;
    wire bit0=query[word_idx[9:4]][{word_idx[3:0],1'b0}];
    wire bit1=query[word_idx[9:4]][{word_idx[3:0],1'b1}];
    wire signed [31:0] term0=bit0?$signed({{16{bus_result[15]}},bus_result[15:0]}):
                                                 -$signed({{16{bus_result[15]}},bus_result[15:0]});
    wire signed [31:0] term1=bit1?$signed({{16{bus_result[31]}},bus_result[31:16]}):
                                                 -$signed({{16{bus_result[31]}},bus_result[31:16]});
    function [15:0] weight;
        input [3:0] row,col;
        begin case(row*3+col)
        0:weight=1924;1:weight=8720;2:weight=119;3:weight=1732;4:weight=8434;5:weight=127;
        6:weight=16985;7:weight=18060;8:weight=30732;9:weight=443;10:weight=7281;11:weight=21;
        12:weight=27208;13:weight=17077;14:weight=10392;15:weight=5724;16:weight=11898;17:weight=4605;
        18:weight=2288;19:weight=7531;20:weight=157;21:weight=332;22:weight=7583;default:weight=137;
        endcase end
    endfunction
    function [15:0] gram;
        input [3:0] row,col;
        begin case(row*3+col)
        0:gram=32769;1,3:gram=27278;2,6:gram=25389;4,8:gram=32768;default:gram=24163;
        endcase end
    endfunction
    function [31:0] reference;
        input [3:0] n;
        begin case(n)0:reference=14592;1:reference=50432;default:reference=11008;endcase end
    endfunction
    // Subroutines have one caller at a time; operands held until completion.
    task read_word;input [31:0] address;input [7:0] target;
        begin bus_addr<=address;bus_write<=0;bus_go<=1;ret_state<=target;state<=250;end
    endtask
    task write_word;input [31:0] address,data;input [7:0] target;
        begin bus_addr<=address;bus_data<=data;bus_write<=1;bus_go<=1;ret_state<=target;state<=250;end
    endtask
    task divide_go;input [63:0] n,d;input [7:0] target;
        begin div_num<=n;div_den<=d;div_start<=1;div_ret<=target;state<=251;end
    endtask
    task multiply;input [31:0] a,b;input [7:0] target;
        begin ma<=a;mb<=b;mul_ret<=target;state<=252;end
    endtask
    integer z;
    always @(posedge clk)begin
        if(!rst_n)begin
            ack<=0;busy<=0;error<=0;poison<=0;state<=0;operand<=0;timer<=0;
            bus_go<=0;div_start<=0;job<=0;ret_state<=0;div_ret<=0;mul_ret<=0;
            i<=0;j<=0;k<=0;it<=0;sample<=0;cls<=0;word_idx<=0;clips<=0;
            ma<=0;mb<=0;div_num<=0;div_den<=0;bus_addr<=0;bus_data<=0;bus_write<=0;
            acc<=0;total<=0;err_sum<=0;denom<=0;rom_addr<=0;score<=0;top<=0;second<=0;
            best<=0;saturations<=0;cim_word<=0;b0<=0;b1<=0;b2<=0;b3<=0;
            p0<=0;p1<=0;packed_proto<=0;qword<=0;
            for(z=0;z<5;z=z+1)arg[z]<=0;
            for(z=0;z<8;z=z+1)begin e[z]<=0;scale[z]<=0;x[z]<=0;level[z]<=0;results[z]<=0;end
            for(z=0;z<3;z=z+1)begin c[z]<=0;next_c[z]<=0;wte[z]<=0;end
        end else begin
            bus_go<=0;div_start<=0;
            if(command[31]!=ack)begin
                ack<=command[31];
                if(!busy && !poison)case(command[30:24])
                1:operand[15:0]<=command[15:0];
                2:operand[31:16]<=command[15:0];
                3:if(command[23:0]<5)arg[command[2:0]]<=operand;else error<=1;
                4:begin
                    error<=0;
                    if(command[23:0]>=1 && command[23:0]<=6 &&
                       allowed(arg[0]) && allowed(arg[3]) &&
                       (command[23:0]==1 || (allowed(arg[1]) &&
                         (command[23:0]==2 || allowed(arg[2])))) &&
                       ((command[23:0]!=2 && command[23:0]!=4 && command[23:0]!=6) || (arg[4]>0 && arg[4]<=16384)))begin
                        job<=command[3:0];busy<=1;timer<=0;i<=0;clips<=0;
                        saturations<=0;sample<=0;state<=1;
                    end else error<=1;
                end
                default:error<=1;
                endcase
            end
            if(busy)begin
                timer<=timer+1;
                if(timer==WATCHDOG-1)begin busy<=0;error<=1;poison<=1;state<=0;end
                else case(state)
                1:read_word(arg[0]+sample*32+i*4,2);
                2:begin
                    e[i]<=bus_result;
                    if(i==7)begin i<=0;state<=job==1?10:60;end else begin i<=i+1;state<=1;end
                end
                // NMF input means, projection W^T e, eight simultaneous MU steps.
                10:divide_go({25'd0,(e[i]>32'h7fffffff ?32'h7fffffff:e[i]),8'd0},400,11);
                11:begin x[i]<=quotient[31:0];if(i==7)begin i<=0;j<=0;acc<=0;state<=12;end else begin i<=i+1;state<=10;end end
                12:multiply(x[i],{16'd0,weight(i,j)},13);
                13:begin acc<=acc+product;if(i==7)state<=14;else begin i<=i+1;state<=12;end end
                14:begin wte[j]<=(acc+16384)>>15;divide_go((acc+16384)>>15,3,15);end
                15:begin
                    c[j]<=quotient[31:0];acc<=0;i<=0;
                    if(j==2)begin j<=0;k<=0;it<=0;state<=16;end else begin j<=j+1;state<=12;end
                end
                16:multiply(c[k]?c[k]:1,{16'd0,gram(j,k)},17);
                17:begin acc<=acc+product;if(k==2)state<=18;else begin k<=k+1;state<=16;end end
                18:begin denom<=(acc+16384)>>15;multiply(c[j]?c[j]:1,wte[j],19);end
                19:if(!denom || !wte[j])begin next_c[j]<=0;state<=21;end
                   else divide_go(product+(denom>>1),denom,20);
                20:begin next_c[j]<=quotient>64'h7fffffff ?32'h7fffffff:quotient[31:0];state<=21;end
                21:begin
                    acc<=0;k<=0;
                    if(j==2)begin for(z=0;z<3;z=z+1)c[z]<=next_c[z];j<=0;
                        if(it==7)state<=23;else begin it<=it+1;state<=16;end
                    end else begin j<=j+1;state<=16;end
                end
                23:begin results[j]<=c[j];multiply(c[j],100,24);end
                24:divide_go(product,reference(j),25);
                25:begin results[j+3]<=quotient>100?100:quotient[31:0];
                    if(j==2)begin i<=0;j<=0;acc<=0;total<=0;err_sum<=0;state<=26;end
                    else begin j<=j+1;state<=23;end
                end
                26:multiply(c[j],{16'd0,weight(i,j)},27);
                27:begin acc<=acc+product;if(j==2)state<=28;else begin j<=j+1;state<=26;end end
                28:divide_go(e[i]>32'h7fffffff ?32'h7fffffff:e[i],400,29);
                29:begin
                    total<=total+quotient;
                    err_sum<=err_sum+(((acc+4194304)>>23)>quotient?
                        ((acc+4194304)>>23)-quotient:quotient-((acc+4194304)>>23));
                    acc<=0;j<=0;if(i==7)state<=30;else begin i<=i+1;state<=26;end
                end
                30:if(total)divide_go(err_sum*100,total,31);else begin results[6]<=0;state<=32;end
                31:begin results[6]<=quotient[31:0];state<=32;end
                32:begin results[7]<=1;i<=0;state<=240;end
                // Scale is frozen during encode/train/predict. Job2 updates it
                // only from complete, user-labelled training trials.
                60:read_word(arg[1]+i*4,61);
                61:begin scale[i]<=bus_result;
                    if(job==2)begin state<=62;end
                    else if(i==7)begin i<=0;state<=70;end else begin i<=i+1;state<=60;end
                end
                62:write_word(arg[1]+i*4,e[i]>scale[i]?e[i]:scale[i],63);
                63:if(i==7)begin i<=0;if(sample+1==arg[4])begin results[0]<=0;state<=240;end
                    else begin sample<=sample+1;state<=1;end
                    end else begin i<=i+1;state<=60;end
                70:divide_go({32'd0,e[i]}*(job>=5?31:15)+(scale[i]?scale[i]/2:0),scale[i]?scale[i]:1,71);
                71:begin
                    level[i]<=quotient>(job>=5?31:15)?(job>=5?31:15):quotient[4:0];if(e[i]>scale[i])clips<=clips+1;
                    if(i==7)begin i<=0;word_idx<=0;b0<=0;b1<=0;b2<=0;b3<=0;state<=72;end
                    else begin i<=i+1;state<=70;end
                end
                72:begin rom_addr<=(job>=5?1536:0)+i*64+word_idx;state<=73;end
                73:state<=74;
                74:begin cim_word<=rom_data;rom_addr<=(job>=5?2048:512)+level[i]*64+word_idx;state<=75;end
                75:state<=76;
                76:begin b0<=b0^vote;b1<=b1^carry0;b2<=b2^carry1;b3<=b3^carry2;
                    if(i==7)state<=77;else begin i<=i+1;state<=72;end
                end
                77:begin
                    query[word_idx[5:0]]<=b2|b3;i<=0;b0<=0;b1<=0;b2<=0;b3<=0;
                    if(word_idx==63)begin word_idx<=0;cls<=0;score<=0;top<=32'h80000000;second<=32'h80000000;best<=0;state<=80;end
                    else begin word_idx<=word_idx+1;state<=72;end
                end
                80:read_word(arg[2]+cls*4096+word_idx*4,81);
                81:if(job==3 || job==5)begin
                    p0<=$signed({bus_result[15],bus_result[15:0]})+(bit0?17'sd1:-17'sd1);
                    p1<=$signed({bus_result[31],bus_result[31:16]})+(bit1?17'sd1:-17'sd1);
                    state<=82;
                end else begin score<=score+term0+term1;state<=84;end
                82:begin
                    if(p0>32767 || p0< -32768 || p1>32767 || p1< -32768)saturations<=saturations+
                        (p0>32767 || p0< -32768)+(p1>32767 || p1< -32768);
                    write_word(arg[2]+word_idx*4,
                        {p1>32767?16'h7fff:p1< -32768?16'h8000:p1[15:0],
                         p0>32767?16'h7fff:p0< -32768?16'h8000:p0[15:0]},83);
                end
                83:if(word_idx==1023)begin results[0]<=saturations;results[1]<={28'd0,clips};i<=0;state<=240;end
                   else begin word_idx<=word_idx+1;state<=80;end
                84:if(word_idx==1023)begin
                    if(score>top)begin second<=top;top<=score;best<=cls;end
                    else if(score>second)second<=score;
                    if(cls+1==arg[4])state<=85;
                    else begin cls<=cls+1;word_idx<=0;score<=0;state<=80;end
                end else begin word_idx<=word_idx+1;state<=80;end
                85:begin
                    results[0]<=best;results[2]<={28'd0,clips};
                    if(arg[4]==1)begin results[1]<=0;results[3]<=0;i<=0;state<=240;end
                    else divide_go(({{32{top[31]}},top}-{{32{second[31]}},second})*10000,491520,86);
                end
                // Reuse the sequential divider: a 64-bit combinational /100
                // creates an unacceptable path at the real 100 MHz clock.
                86:begin results[3]<=quotient[31:0];divide_go(quotient,100,87);end
                87:begin results[1]<=quotient[31:0];i<=0;state<=240;end
                240:write_word(arg[3]+i*4,results[i],241);
                241:if(i==(job==1?7:job==2?0:(job==3 || job==5)?1:3))begin busy<=0;state<=0;end
                    else begin i<=i+1;state<=240;end
                250:if(bus_done)begin
                    if(bus_error)begin error<=1;busy<=0;state<=0;end else state<=ret_state;
                end
                251:if(div_done)state<=div_ret;
                252:state<=253;
                253:state<=mul_ret;
                default:begin error<=1;busy<=0;state<=0;end
                endcase
            end
        end
    end
endmodule

