"""One-time derivation of context-banked RTL from the frozen scalar algorithms.

Historical derivation only, not a build or regeneration tool. The final RTL
also includes manually reviewed combinational defaults preventing latches.
Do not run this script over the verified sources. Golden scalar algorithms
remain unchanged.
"""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[2]
FROZEN = Path(__file__).resolve().parent / 'baseline/src/rtl'

old = (FROZEN / 'emg_window_features.v').read_text()
header = old[old.index('module emg_window_features #('):old.index('    localparam integer SEGMENTS')]
header = header.replace('module emg_window_features #(', 'module emg_window_features_shared #(\n    parameter integer CHANNELS = 8, CHANNEL_BITS = 3,')
header = header.replace('    input  wire                           sample_valid,', '    input  wire                           sample_valid,\n    input wire [CHANNEL_BITS-1:0] sample_channel,\n    output reg [CHANNEL_BITS-1:0] window_channel,')
declarations = old[old.index('    localparam integer SEGMENTS'):old.index('    always @(posedge clk) begin')]
declarations = re.sub(r'    reg \[31:0\] ring_mav.*?    reg \[SEG_PTR_W-1:0\] wr_ptr;', '    reg [SEG_PTR_W-1:0] wr_ptr;', declarations, flags=re.S)
fields = 'prev,prev2,have_prev,have_prev2,seg_count,seg_mav,seg_wl,seg_energy,seg_zc,seg_ssc,wr_ptr,win_mav,win_wl,win_energy,win_zc,win_ssc,priming,prime_count,hop_count'
body = old[old.index('            abs_x ='):old.index('            have_prev <= 1\'b1;')+len('            have_prev <= 1\'b1;')]
for name in ('mav','wl','energy','zc','ssc'):
    body = re.sub(r'^\s*ring_'+name+r'\[wr_ptr\]\s*<=.*?;\n', '\n', body, flags=re.M)
    body = body.replace('ring_'+name+'[wr_ptr]', 'old_'+name)
body = body.replace('            if (seg_done) begin', '''            completed_mav = seg_mav + abs_x;
            completed_wl = seg_wl + abs_diff;
            completed_energy = seg_energy + x_sq[31:0];
            completed_zc = seg_zc + zc_event;
            completed_ssc = seg_ssc + ssc_event;
            if (seg_done) begin''', 1)
for name in ('mav_sum','wl_sum','energy_sum','zc_count','ssc_count'):
    body = body.replace(name+' <=', 'result_'+name+' =')
body = body.replace("                window_valid <= 1'b1;", '')
body = body.replace(' <= ', ' = ')
shared = '''
// Shared arithmetic, independent per-channel contexts. Asynchronous-read
// LUTRAM preserves one accepted sample per cycle, including same-channel
// consecutive samples. Only the small seen bitmap resets; unwritten history
// is masked until each context completes its first full window.
'''+header+declarations+'''
    localparam integer CONTEXT_W = 2*SAMPLE_WIDTH + 2 + 2*SEG_CNT_W + 96
        + 2*SEG_EVENT_W + SEG_PTR_W + 120 + 2*WIN_EVENT_W + 1 + WIN_CNT_W;
    localparam integer RING_W = 96 + 2*SEG_EVENT_W;
    (* ram_style = "distributed" *) reg [CONTEXT_W-1:0] contexts[0:CHANNELS-1];
    (* ram_style = "distributed" *) reg [RING_W-1:0] history[0:CHANNELS*SEGMENTS-1];
    reg [CHANNELS-1:0] seen;
    wire channel_ok = sample_channel < CHANNELS;
    wire [CONTEXT_W-1:0] initial_context = {{(CONTEXT_W-1){1'b0}},1'b1}
        << (WIN_CNT_W+SEG_CNT_W);
    wire [CONTEXT_W-1:0] context_word = channel_ok && seen[sample_channel]
        ? contexts[sample_channel] : initial_context;
    reg [CONTEXT_W-1:0] context_next;
    integer ring_address;
    reg [31:0] old_mav,old_wl,old_energy,completed_mav,completed_wl,completed_energy;
    reg [SEG_EVENT_W-1:0] old_zc,old_ssc,completed_zc,completed_ssc;
    reg [31:0] result_mav_sum,result_wl_sum,result_energy_sum,result_zc_count,result_ssc_count;

    always @* begin
        {'''+fields+'''} = context_word;
        ring_address = sample_channel*SEGMENTS + wr_ptr;
        {old_mav,old_wl,old_energy,old_zc,old_ssc} = priming || !channel_ok
            ? {RING_W{1'b0}} : history[ring_address];
        result_mav_sum=0;result_wl_sum=0;result_energy_sum=0;
        result_zc_count=0;result_ssc_count=0;clamp_val=0;
'''+body+'''
        context_next = {'''+fields+'''};
    end
    // Memory writes deliberately have no array reset to infer LUTRAM.
    always @(posedge clk) begin
        if(rst_n && sample_valid && channel_ok)begin
            contexts[sample_channel] <= context_next;
            if(seg_done)history[ring_address] <=
                {completed_mav,completed_wl,completed_energy,completed_zc,completed_ssc};
        end
    end
    always @(posedge clk) begin
        window_valid<=0;
        if(!rst_n)begin
            seen<=0;window_channel<=0;
            mav_sum<=0;wl_sum<=0;energy_sum<=0;zc_count<=0;ssc_count<=0;
        end else if(sample_valid && channel_ok)begin
            seen[sample_channel]<=1;
            if(window_done)begin
                window_valid<=1;window_channel<=sample_channel;
                mav_sum<=result_mav_sum;wl_sum<=result_wl_sum;energy_sum<=result_energy_sum;
                zc_count<=result_zc_count;ssc_count<=result_ssc_count;
            end
        end
    end
endmodule
'''
(ROOT / 'src/rtl/emg_window_features.v').write_text(old+shared)

old = (FROZEN / 'emg_bandpass.v').read_text()
shared = old[old.index('module emg_bandpass #('):]
shared = shared.replace('module emg_bandpass #(', 'module emg_bandpass_shared #(\n    parameter integer CHANNELS = 8, CHANNEL_BITS = 3,')
shared = shared.replace('    input  wire                           sample_valid,', '    input  wire                           sample_valid,\n    input wire [CHANNEL_BITS-1:0] sample_channel,')
start = shared.index('    reg signed [SAMPLE_WIDTH-1:0] hp_x1, hp_x2;')
end = shared.index('    // Filter coefficients in registers', start)
shared = shared[:start]+'''    localparam integer CONTEXT_W=5*SAMPLE_WIDTH+31;
    (* ram_style="distributed" *) reg [CONTEXT_W-1:0] contexts[0:CHANNELS-1];
    reg [CHANNELS-1:0] seen;
    wire channel_ok=sample_channel<CHANNELS;
    wire [CONTEXT_W-1:0] context_word=channel_ok && seen[sample_channel]
        ? contexts[sample_channel] : {CONTEXT_W{1'b0}};
    wire signed [SAMPLE_WIDTH-1:0] hp_x1,hp_x2,hp_y1,hp_y2,lp_y;
    wire [15:0] hp_fraction;
    wire [14:0] lp_fraction;
    assign {hp_x1,hp_x2,hp_y1,hp_y2,lp_y,hp_fraction,lp_fraction}=context_word;

'''+shared[end:]
start = shared.index('    always @(posedge clk) begin\n        filtered_valid')
shared = shared[:start]+'''    wire [15:0] next_hp_fraction = (hp_sat_w == (hp_acc_w >>> 16)) ? hp_acc_w[15:0] : 16'd0;
    wire [14:0] next_lp_fraction = (lp_sat_w == lp_sum_w) ? lp_prod_w[14:0] : 15'd0;
    always @(posedge clk)begin
        if(rst_n && sample_valid && channel_ok)
            contexts[sample_channel] <= {sample_in,hp_x1,hp_y_w,hp_y1,lp_y_w,next_hp_fraction,next_lp_fraction};
    end
    always @(posedge clk)begin
        filtered_valid<=0;
        if(!rst_n)begin seen<=0;filtered_out<=0;end
        else if(sample_valid && channel_ok)begin
            seen[sample_channel]<=1;
            filtered_valid<=1;filtered_out<=lp_y_w;
        end
    end
endmodule
'''
(ROOT / 'src/rtl/emg_bandpass.v').write_text(old+'\n// The same bit-exact biquad/quantization with channel-banked LUTRAM state.\n'+shared)
print('DERIVED_SHARED_RTL')
