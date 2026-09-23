`timescale 1ns/1ps

// Real-time EMG fatigue monitor.  Per channel: 1st-order high-pass, then a
// shared sequentially-time-multiplexed 2048-point radix-2 DIT FFT (4 kSPS
// -> 512 ms window, 1.95 Hz bins, 1/2 scaling per stage = 1/N total),
// median frequency (MDF) from the power spectrum, and - across the eight
// channels averaged - a 16-window least-squares MDF slope plus a 4-level
// fatigue state.  Two words ride the existing result lane each window:
//   id 8 : { num2_sat[15:0] signed, mdf_mean[15:0] }
//   id 9 : { level[1:0], hist_full, 6'b0, grand_total[45:23] }
// num2 = sum((2i-15) * y_i) over the circular 16-entry MDF history; the
// per-window MDF slope in bins equals num2 / 2720 (PS-side conversion).
//
// Twiddles (Q15 cos/sin, 1024 words) load from a ROM via $readmemh; the
// absolute default path keeps the module_ref OOC synthesis run resolvable.
module emg_fatigue #(
    parameter TW_FILE = "D:/FPGA/sEMG-HMRS/data/models/fatigue/twiddle2048.mem",
    // NOTE: 17 bits — 63570 does NOT fit in signed 16 bits (16'sd63570
    // wraps to -1976 and silently turns the HP into an attenuator)
    parameter signed [16:0] HP_ALPHA_Q16 = 17'sd63570, // ~20 Hz @ 4 kSPS
    parameter integer INPUT_SHIFT = 8,
    parameter signed [15:0] T_MILD    = -16'sd100,     // slope ~ -0.037 bin/win
    parameter signed [15:0] T_FATIGUE = -16'sd300,     // slope ~ -0.110 bin/win
    parameter signed [15:0] T_REST    = -16'sd600,     // slope ~ -0.220 bin/win
    parameter [31:0] MIN_ENERGY = 32'd0                // window energy gate
) (
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  sample_valid,
    input  wire [2:0]            sample_channel,
    input  wire signed [23:0]    sample_data,
    output reg                   out_valid,
    input  wire                  out_ready,
    output reg  [3:0]            out_id,
    output reg  [31:0]           out_data,
    output reg  [15:0]           out_sequence
);

    // ------------------------------------------------------------------
    // helpers
    // ------------------------------------------------------------------
    function [10:0] bitrev11;
        input [10:0] v;
        begin
            bitrev11 = {v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[7],
                        v[8], v[9], v[10]};
        end
    endfunction

    function signed [17:0] sat18;
        input signed [35:0] v;
        begin
            if (v > 35'sd131071)       sat18 = 18'sd131071;
            else if (v < -35'sd131072) sat18 = -18'sd131072;
            else                       sat18 = v[17:0];
        end
    endfunction

    function signed [15:0] sat16_27;
        input signed [26:0] v;
        begin
            if (v > 27'sd32767)       sat16_27 = 16'sd32767;
            else if (v < -27'sd32768) sat16_27 = -16'sd32768;
            else                      sat16_27 = v[15:0];
        end
    endfunction

    function signed [15:0] sat16_32;
        input signed [31:0] v;
        begin
            if (v > 31'sd32767)       sat16_32 = 16'sd32767;
            else if (v < -31'sd32768) sat16_32 = -16'sd32768;
            else                      sat16_32 = v[15:0];
        end
    endfunction

    localparam [3:0] P_IDLE = 4'd0,   // wait for a full window buffer
                     P_LOAD = 4'd1,   // bit-reversed load of one channel
                     P_FFT  = 4'd2,   // 11 stages x 1024 butterflies
                     P_P1   = 4'd3,   // power pass 1: total
                     P_P2   = 4'd4,   // power pass 2: MDF crossing
                     P_UPD  = 4'd5,   // push MDF mean into history
                     P_SLOPE= 4'd6,   // least-squares numerator
                     P_OUT1 = 4'd7,   // result word id 8
                     P_OUT2 = 4'd8;   // result word id 9

    // ------------------------------------------------------------------
    // collection side: 8x 1st-order HP + ping-pong sample buffers
    // ------------------------------------------------------------------
    reg                    wr_sel;      // buffer currently being filled
    reg  [13:0]            fill_cnt;    // 0..16383 sample beats in the window
                                        // (8ch x 2048: needs 14 bits!)
    reg                    proc_buf_valid;
    reg                    wr_sel_done; // buffer that just completed
    reg  [15:0]            win_seq;
    reg  [15:0]            win_seq_done; // sequence paired with wr_sel_done
    reg signed [23:0]      hp_xd [0:7];
    reg signed [26:0]      hp_yd [0:7];

    wire signed [43:0] hp_prod = hp_yd[sample_channel] * HP_ALPHA_Q16;
    wire signed [26:0] hp_hp   = hp_prod >>> 16;
    wire signed [26:0] hp_y    = (sample_data - hp_xd[sample_channel]) + hp_hp;
    wire signed [15:0] fft_in  = sat16_27(hp_y >>> INPUT_SHIFT);

    reg signed [15:0] sbuf [0:32767];  // 2 x 8 x 2048 ping-pong window RAM
    reg [14:0]        sbuf_raddr;
    reg signed [15:0] sbuf_rd;

    integer i;
    always @(posedge clk) begin
        if (!rst_n) begin
            wr_sel <= 1'b0; fill_cnt <= 14'd0;
            proc_buf_valid <= 1'b0; wr_sel_done <= 1'b0; win_seq <= 16'd0;
            for (i = 0; i < 8; i = i + 1) begin
                hp_xd[i] <= 24'sd0;
                hp_yd[i] <= 27'sd0;
            end
        end else if (sample_valid) begin
            hp_xd[sample_channel] <= sample_data;
            hp_yd[sample_channel] <= hp_y;
            // interleaved stream: sample n = frame (n>>3), channel (n&7);
            // a channel's window occupies consecutive slots in its slice
            sbuf[{wr_sel, sample_channel, fill_cnt[13:3]}] <= fft_in;
            if (fill_cnt == 14'd16383) begin
                fill_cnt <= 14'd0;
                wr_sel <= ~wr_sel;
                wr_sel_done <= wr_sel;
                win_seq_done <= win_seq + 16'd1;
                proc_buf_valid <= 1'b1;
                win_seq <= win_seq + 16'd1;
            end else begin
                fill_cnt <= fill_cnt + 14'd1;
            end
        end
    end

    always @(posedge clk) sbuf_rd <= sbuf[sbuf_raddr];

    // ------------------------------------------------------------------
    // FFT datapath memories
    // ------------------------------------------------------------------
    reg signed [17:0] fft_re [0:2047];
    reg signed [17:0] fft_im [0:2047];
    reg  [10:0]       fft_raddr;
    reg signed [17:0] re_rd, im_rd;
    reg  [31:0]       tw_rom [0:1023];
    reg  [9:0]        tw_raddr;
    reg  [31:0]       tw_rd;

    initial $readmemh(TW_FILE, tw_rom);

    always @(posedge clk) begin
        re_rd <= fft_re[fft_raddr];
        im_rd <= fft_im[fft_raddr];
        tw_rd <= tw_rom[tw_raddr];
    end

    // ------------------------------------------------------------------
    // processing FSM
    // ------------------------------------------------------------------
    reg [3:0]  state;
    reg        src_sel;         // buffer being processed (!= wr_sel)
    reg [15:0] seq_q;           // window sequence paired with src_sel
    reg [2:0]  ch_cnt;
    reg [10:0] load_idx;
    reg [1:0]  load_ph;
    reg [3:0]  bf_s;
    reg [9:0]  bf_j;
    reg [10:0] bf_k;
    reg [2:0]  bf_ph;
    reg [10:0] pwr_idx;
    reg [1:0]  pwr_ph;
    reg [47:0] total_acc, cum_acc;
    reg        crossed;
    reg [10:0] mdf_ch;
    reg [13:0] mdf_sum;
    reg [50:0] grand_total;
    reg [15:0] mdf_mean_q;
    reg signed [15:0] hist [0:15];   // signed: sc_coef*hist must stay signed
    reg [3:0]  hist_ptr;
    reg [4:0]  hist_cnt;        // saturates at 16
    reg [3:0]  slope_i;
    reg signed [31:0] num2_acc;
    reg signed [15:0] num2_sat;
    reg [1:0]  level_q;

    // butterfly operand registers
    reg signed [17:0] a_re, a_im, b_re, b_im;
    reg [31:0]        tw_q;
    wire signed [15:0] tw_c = tw_q[31:16];
    wire signed [15:0] tw_s = tw_q[15:0];

    // butterfly addressing
    wire [10:0] bf_half  = 11'd1 << bf_s;
    wire [11:0] bf_group = {bf_half, 1'b0};
    wire [10:0] bf_a     = bf_k + {1'b0, bf_j};
    wire [10:0] bf_b     = bf_a + bf_half;
    wire [9:0]  bf_w     = bf_j << (4'd10 - bf_s);

    // butterfly compute (Q15 twiddle, 1/2 scaling per stage)
    wire signed [35:0] t_re_raw = b_re * tw_c + b_im * tw_s;
    wire signed [35:0] t_im_raw = b_im * tw_c - b_re * tw_s;
    wire signed [17:0] t_re = sat18(t_re_raw >>> 15);
    wire signed [17:0] t_im = sat18(t_im_raw >>> 15);
    wire signed [18:0] na_sum_re = a_re + t_re;
    wire signed [18:0] na_sum_im = a_im + t_im;
    wire signed [18:0] nb_sum_re = a_re - t_re;
    wire signed [18:0] nb_sum_im = a_im - t_im;
    wire signed [17:0] na_re = na_sum_re >>> 1;
    wire signed [17:0] na_im = na_sum_im >>> 1;
    wire signed [17:0] nb_re = nb_sum_re >>> 1;
    wire signed [17:0] nb_im = nb_sum_im >>> 1;

    // single write port per array, muxed between load and butterfly
    wire        fft_we    = (state == P_LOAD && load_ph == 2'd2)
                         || (state == P_FFT && (bf_ph == 3'd4 || bf_ph == 3'd5));
    wire [10:0] fft_waddr = (state == P_FFT) ? ((bf_ph == 3'd5) ? bf_b : bf_a)
                                             : bitrev11(load_idx);
    wire signed [17:0] fft_wre = (state == P_FFT) ? ((bf_ph == 3'd5) ? nb_re : na_re)
                                                  : {{2{sbuf_rd[15]}}, sbuf_rd};
    wire signed [17:0] fft_wim = (state == P_FFT) ? ((bf_ph == 3'd5) ? nb_im : na_im)
                                                  : 18'sd0;

    always @(posedge clk) begin
        if (fft_we) begin
            fft_re[fft_waddr] <= fft_wre;
            fft_im[fft_waddr] <= fft_wim;
        end
    end

    // power pass helper: bin power of the currently latched bin
    wire [36:0] pwr_incr = re_rd * re_rd + im_rd * im_rd;

    // slope term: (2i-15) * hist[(hist_ptr + i) mod 16]
    wire [3:0]  hidx = hist_ptr + slope_i;
    wire signed [5:0] sc_coef = {slope_i, 1'b0} - 6'sd15;
    wire signed [21:0] sc_term = sc_coef * hist[hidx];

    wire        hist_full = (hist_cnt == 5'd16);
    wire        energy_ok = (grand_total >= {19'd0, MIN_ENERGY});
    wire signed [15:0] num2_next = sat16_32(num2_acc);
    wire signed [15:0] num2_rpt  = hist_full ? num2_next : 16'sd0;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= P_IDLE; src_sel <= 1'b0; seq_q <= 16'd0; ch_cnt <= 3'd0;
            load_idx <= 11'd0; load_ph <= 1'b0;
            bf_s <= 4'd0; bf_j <= 10'd0; bf_k <= 11'd0; bf_ph <= 3'd0;
            pwr_idx <= 11'd0; pwr_ph <= 1'b0;
            total_acc <= 48'd0; cum_acc <= 48'd0; crossed <= 1'b0;
            mdf_ch <= 11'd0; mdf_sum <= 14'd0; grand_total <= 51'd0;
            mdf_mean_q <= 16'd0; hist_ptr <= 4'd0; hist_cnt <= 5'd0;
            slope_i <= 4'd0; num2_acc <= 32'sd0; num2_sat <= 16'sd0;
            level_q <= 2'd0;
            out_valid <= 1'b0; out_id <= 4'd0; out_data <= 32'd0;
            out_sequence <= 16'd0;
        end else begin
            case (state)
            P_IDLE: begin
                // proc_buf_valid latches 1 at every window fill (collection
                // block only — never cleared here, that would double-drive
                // the net and fail opt_design DRC MDRV-1).  A fresh buffer
                // is detected by its sequence number instead.
                if (proc_buf_valid && (win_seq_done != seq_q)) begin
                    src_sel    <= wr_sel_done;
                    seq_q      <= win_seq_done;
                    ch_cnt     <= 3'd0;
                    mdf_sum    <= 14'd0;
                    grand_total<= 51'd0;
                    load_idx   <= 11'd0;
                    load_ph    <= 2'd0;
                    state      <= P_LOAD;
                end
            end
            P_LOAD: begin
                case (load_ph)
                2'd0: begin
                    sbuf_raddr <= {src_sel, ch_cnt, load_idx};
                    load_ph <= 2'd1;
                end
                2'd1: load_ph <= 2'd2;   // sbuf_rd latches this edge
                default: begin           // RAM write fires (fft_we)
                    load_ph <= 2'd0;
                    if (load_idx == 11'd2047) begin
                        load_idx <= 11'd0;
                        bf_s <= 4'd0; bf_j <= 10'd0; bf_k <= 11'd0;
                        bf_ph <= 3'd0;
                        state <= P_FFT;
                    end else begin
                        load_idx <= load_idx + 11'd1;
                    end
                end
                endcase
            end
            P_FFT: begin
                case (bf_ph)
                3'd0: begin
                    fft_raddr <= bf_a;
                    tw_raddr  <= bf_w;
                    bf_ph <= 3'd1;
                end
                3'd1: begin
                    fft_raddr <= bf_b;
                    bf_ph <= 3'd2;
                end
                3'd2: begin
                    a_re <= re_rd; a_im <= im_rd;
                    bf_ph <= 3'd3;
                end
                3'd3: begin
                    b_re <= re_rd; b_im <= im_rd; tw_q <= tw_rd;
                    bf_ph <= 3'd4;
                end
                3'd4: bf_ph <= 3'd5;      // write a (see fft_we decode)
                3'd5: bf_ph <= 3'd6;      // write b
                default: begin            // advance j / k / s
                    if (bf_j == bf_half - 11'd1) begin
                        bf_j <= 10'd0;
                        if (bf_k + bf_group >= 12'd2048) begin
                            bf_k <= 11'd0;
                            if (bf_s == 4'd10) begin
                                pwr_idx <= 11'd0;
                                pwr_ph  <= 1'b0;
                                state   <= P_P1;
                            end else begin
                                bf_s <= bf_s + 4'd1;
                            end
                        end else begin
                            bf_k <= bf_k + bf_group;
                        end
                    end else begin
                        bf_j <= bf_j + 10'd1;
                    end
                    bf_ph <= 3'd0;
                end
                endcase
            end
            P_P1: begin
                case (pwr_ph)
                2'd0: begin
                    fft_raddr <= pwr_idx;
                    pwr_ph <= 2'd1;
                end
                2'd1: pwr_ph <= 2'd2;   // re/im_rd latch this edge
                default: begin
                    total_acc <= total_acc + pwr_incr;
                    pwr_ph <= 2'd0;
                    if (pwr_idx == 11'd1024) begin
                        pwr_idx <= 11'd0;
                        cum_acc <= 48'd0;
                        crossed <= 1'b0;
                        state   <= P_P2;
                    end else begin
                        pwr_idx <= pwr_idx + 11'd1;
                    end
                end
                endcase
            end
            P_P2: begin
                case (pwr_ph)
                2'd0: begin
                    fft_raddr <= pwr_idx;
                    pwr_ph <= 2'd1;
                end
                2'd1: pwr_ph <= 2'd2;   // re/im_rd latch this edge
                default: begin
                    cum_acc <= cum_acc + pwr_incr;
                    pwr_ph <= 2'd0;
                    if (!crossed && (cum_acc + pwr_incr) >= (total_acc >>> 1))
                        mdf_ch <= pwr_idx;
                    if ((cum_acc + pwr_incr) >= (total_acc >>> 1))
                        crossed <= 1'b1;
                    if (pwr_idx == 11'd1024) begin
                        mdf_sum     <= mdf_sum + {3'b0, mdf_ch};
                        grand_total <= grand_total + total_acc;
                        total_acc   <= 48'd0;
                        cum_acc     <= 48'd0;
                        crossed     <= 1'b0;
                        mdf_ch      <= 11'd0;
                        pwr_idx     <= 11'd0;
                        pwr_ph      <= 2'd0;
                        if (ch_cnt == 3'd7) begin
                            state <= P_UPD;
                        end else begin
                            ch_cnt   <= ch_cnt + 3'd1;
                            load_idx <= 11'd0;
                            load_ph  <= 2'd0;
                            state    <= P_LOAD;
                        end
                    end else begin
                        pwr_idx <= pwr_idx + 11'd1;
                    end
                end
                endcase
            end
            P_UPD: begin
                mdf_mean_q <= mdf_sum[13:3];
                if (energy_ok) begin
                    hist[hist_ptr] <= mdf_sum[13:3];
                    hist_ptr <= hist_ptr + 4'd1;
                    if (hist_cnt != 5'd16)
                        hist_cnt <= hist_cnt + 5'd1;
                end
                slope_i  <= 4'd0;
                num2_acc <= 32'sd0;
                state    <= P_SLOPE;
            end
            P_SLOPE: begin
                num2_acc <= num2_acc + sc_term;
                if (slope_i == 4'd15) begin
                    slope_i <= 4'd0;
                    state   <= P_OUT1;
                end else begin
                    slope_i <= slope_i + 4'd1;
                end
            end
            P_OUT1: begin
                num2_sat <= num2_next;
                if (!hist_full)
                    level_q <= 2'd0;
                else if (num2_next <= T_REST)
                    level_q <= 2'd3;
                else if (num2_next <= T_FATIGUE)
                    level_q <= 2'd2;
                else if (num2_next <= T_MILD)
                    level_q <= 2'd1;
                else
                    level_q <= 2'd0;
                out_valid    <= 1'b1;
                out_id       <= 4'd8;
                out_data     <= {num2_rpt, mdf_mean_q};
                out_sequence <= seq_q;
                state        <= P_OUT2;
            end
            P_OUT2: begin
                if (out_valid && out_ready) begin
                    if (out_id == 4'd8) begin
                        out_id   <= 4'd9;
                        out_data <= {level_q, hist_full, 6'd0,
                                     grand_total[45:23]};
                    end else begin
                        out_valid <= 1'b0;
                        state     <= P_IDLE;
                    end
                end
            end
            default: state <= P_IDLE;
            endcase
        end
    end

endmodule
