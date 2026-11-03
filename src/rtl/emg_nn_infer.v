`timescale 1ns/1ps

// INT8 MLP inference engine, bit-exact with tools/export_int8.py (Int8MLP).
//
// Network: 40 inputs -> 64 -> 32 -> 5 classes, quantised per
// data/models/nn_int8/quant_params.json:
//
//   input    xq = clip((x * M_in + 2^(n-1)) >> n, 0, 127)   per-channel;
//            PL features (MAV/WL/Energy/ZC/SSC sums) are unsigned >= 0 and
//            the StandardScaler is fused into W1/b1 upstream (export_int8.py)
//   layer    acc = sum(w8 * x8) + b32, INT8 weights / INT32 bias
//   requant  q  = (acc * M + 2^(n-1)) >>> n, clip [0, 127] for ReLU layers
//   output   INT32 logits (softmax-invariant scale; done on the PS side)
//
// Weights live in a single 2048x32 BRAM initialised from
// data/models/nn_int8/nn_int8_weights.mem (neuron-major, 4 INT8 per word,
// little-endian byte k = bits [8k+7:8k]).  Word addresses must match
// MEM_LAYOUT in tools/export_int8.py.
//
// One serial MAC per cycle: ~5.3k cycles per window (~53 us at 100 MHz),
// < 0.2% duty cycle against the 50 ms window period.
//
// Handshake: features arrive one per window in feature-bank order
// (index = feature_id*8 + channel); feat_ready back-pressures the feature
// serializer while normalising / infering.  Results stream out as six
// words: logits[0..4] then {class, zero-padded}.

module emg_nn_infer #(
    // absolute path: the BD synthesizes this module in a Vivado run
    // directory where a relative $readmemh path would not resolve
    parameter MEM_FILE = "data/models/nn_int8_board_multiwear/nn_int8_weights.mem"
) (
    input  wire        clk,
    input  wire        rst_n,

    // feature window stream
    input  wire        feat_valid,
    input  wire [5:0]  feat_index,    // 0..39 = feature_id*8 + channel
    input  wire [31:0] feat_data,     // unsigned 32-bit PL feature
    output wire        feat_ready,

    // result stream
    output reg         out_valid,
    input  wire        out_ready,
    output reg  [2:0]  out_id,        // 0..4 logits, 5 = argmax class
    output reg  [31:0] out_data
);

    // ------------------------------------------------------------------
    // memory map (sync with MEM_LAYOUT in tools/export_int8.py)
    // ------------------------------------------------------------------
    localparam [10:0] A_M_IN = 11'h000, A_N_IN = 11'h028;
    localparam [10:0] A_W1   = 11'h050, A_B1 = 11'h2D0, A_R1 = 11'h310;
    localparam [10:0] A_W2   = 11'h312, A_B2 = 11'h512, A_R2 = 11'h532;
    localparam [10:0] A_W3   = 11'h534, A_B3 = 11'h55C;

    localparam integer N_IN  = 40;
    localparam integer N_H1  = 64;
    localparam integer N_H2  = 32;
    localparam integer N_OUT = 5;
    localparam [1:0] LAYER1 = 2'd0, LAYER2 = 2'd1, LAYER3 = 2'd2;

    // ------------------------------------------------------------------
    // control states (declared early: combinational helpers below use them)
    // ------------------------------------------------------------------
    localparam S_IDLE = 5'd0,   // waiting for a feature
               S_NM   = 5'd1,   // latch m_in for the feature
               S_NN   = 5'd2,   // latch n_in, start multiply
               S_NX   = 5'd3,   // latch n_in, start multiply
               S_WR   = 5'd18,  // shift + clip -> xq (input normalisation)
               S_RQM  = 5'd4,   // load requant m for the layer
               S_RQN  = 5'd5,   // load requant m, issue neuron-0 bias address
               S_LDBN = 5'd19,  // layer entry: latch requant n, issue weight addr
               S_LDB  = 5'd6,   // issue first weight word address
               S_LDBW = 5'd7,   // acc <= bias, issue weight word 0 address
               S_MAC0 = 5'd8,   // latch word, MAC byte 0, prefetch next
               S_MAC1 = 5'd9,
               S_MAC2 = 5'd10,
               S_MAC3 = 5'd11,
               S_LST  = 5'd17,  // last MAC of a neuron landed in acc
               S_REQ  = 5'd12,  // requant multiply
               S_REQS = 5'd13,  // shift + clip + store activation
               S_NEXT = 5'd14,  // advance neuron / layer
               S_AM   = 5'd15,  // argmax captured combinationally
               S_OUT  = 5'd16;  // result serializer

    // ------------------------------------------------------------------
    // weight / parameter BRAM (2048 x 32, synchronous read)
    // ------------------------------------------------------------------
    reg [31:0] bram [0:2047];
    reg [10:0] bram_addr;
    reg [31:0] bram_rdata;
    initial $readmemh(MEM_FILE, bram);

    always @(posedge clk) begin
        bram_rdata <= bram[bram_addr];
    end

    // ------------------------------------------------------------------
    // state registers (declared before the combinational helpers below)
    // ------------------------------------------------------------------
    reg [4:0]  state;
    reg [1:0]  layer;
    reg [6:0]  neuron;        // 0..63
    reg [4:0]  word_idx;      // word within the neuron (0..15)
    reg [6:0]  in_idx;        // input index within the neuron (0..63)
    reg [5:0]  feat_cnt;      // features received this window
    reg [5:0]  feat_save_idx;
    reg [31:0] feat_save;
    reg [31:0] m_in_r;
    reg [31:0] n_in_r;
    reg [63:0] norm_prod, norm_res;
    reg signed [31:0] acc;
    reg [31:0] word_buf;
    reg [17:0] rq_m;
    reg [5:0]  rq_n;
    reg signed [63:0] rq_prod, rq_res;
    reg [2:0]  out_cnt;

    // Half-round constants are shared by the state machine and RAM writes.
    wire [63:0] in_half = (n_in_r == 32'd0) ? 64'd0
                        : (64'd1 << (n_in_r[5:0] - 6'd1));
    wire [63:0] rq_half = (rq_n == 6'd0) ? 64'd0 : (64'd1 << (rq_n - 6'd1));

    // Activations use asynchronous-read distributed RAM. Input seen bits
    // preserve reset-to-zero semantics even for repeated/missing indices.
    // Hidden layers are fully written before they can be consumed.
    (* ram_style="distributed" *) reg signed [7:0] xq [0:N_IN-1];
    (* ram_style="distributed" *) reg signed [7:0] h1 [0:N_H1-1];
    (* ram_style="distributed" *) reg signed [7:0] h2 [0:N_H2-1];
    reg [N_IN-1:0] xq_seen;
    wire [63:0] normalized_raw=(norm_prod + in_half) >> n_in_r[5:0];
    wire [7:0] normalized_activation=(normalized_raw > 64'd127) ? 8'd127 : {1'b0,normalized_raw[6:0]};
    wire signed [63:0] requantized_raw=(rq_prod + $signed(rq_half)) >>> rq_n;
    wire [7:0] hidden_activation=(requantized_raw < 64'sd0) ? 8'd0 :
        (requantized_raw > 64'sd127) ? 8'd127 : {1'b0,requantized_raw[6:0]};
    always @(posedge clk)begin
        if(rst_n && state==S_WR)xq[feat_save_idx[5:0]]<=normalized_activation;
        if(rst_n && state==S_REQS)begin
            if(layer==LAYER1)h1[neuron[5:0]]<=hidden_activation;
            else h2[neuron[4:0]]<=hidden_activation;
        end
    end
    reg signed [31:0] logits [0:N_OUT-1];

    integer i;

    // neuron-major weight word base for the current neuron
    wire [10:0] w_base = (layer == LAYER1) ? (A_W1 + neuron * 5'd10)
                       : (layer == LAYER2) ? (A_W2 + {neuron, 4'b0000})
                                           : (A_W3 + {neuron, 3'b000});
    // bias word address for the current neuron
    wire [10:0] b_base = (layer == LAYER1) ? (A_B1 + neuron)
                       : (layer == LAYER2) ? (A_B2 + neuron)
                                           : (A_B3 + neuron);
    wire [4:0]  layer_words = (layer == LAYER1) ? 5'd10
                            : (layer == LAYER2) ? 5'd16 : 5'd8;
    wire [6:0]  layer_last  = (layer == LAYER1) ? 7'd63
                            : (layer == LAYER2) ? 7'd31 : 7'd4;

    // current layer's activation source, indexed by the byte currently
    // being MACed: word_idx gives the word, the state gives the byte
    wire [1:0] mac_phase = (state == S_MAC1) ? 2'd1
                         : (state == S_MAC2) ? 2'd2
                         : (state == S_MAC3) ? 2'd3 : 2'd0;
    wire [6:0] mac_in    = {word_idx[3:0], 2'b00} + {5'd0, mac_phase};
    reg signed [7:0] act;
    always @(*) begin
        case (layer)
            LAYER1:  act = xq_seen[mac_in[5:0]] ? xq[mac_in[5:0]] : 8'sd0;
            LAYER2:  act = h1[mac_in[5:0]];
            default: act = h2[mac_in[5:0]];
        endcase
    end

    wire signed [7:0] mac_weight=(state==S_MAC0) ? $signed(bram_rdata[7:0]) :
        (state==S_MAC1) ? $signed(word_buf[15:8]) :
        (state==S_MAC2) ? $signed(word_buf[23:16]) : $signed(word_buf[31:24]);
    wire signed [15:0] mac_product=act * mac_weight;

    // numpy-argmax semantics: strict >, ties keep the lowest index.
    // Purely combinational (single driver): the old `amax` reg was also
    // reset in the clocked block, creating a multi-driven net that synthesis
    // resolved to the constant 0 (Synth 8-6859/8-6858) - wrong verdicts.
    // After reset logits are all zero, so argmax is 0 anyway; no reset needed.
    reg signed [31:0] am_best;
    reg [2:0]  amax_c;
    always @(*) begin
        am_best = logits[0];
        amax_c  = 3'd0;
        if (logits[1] > am_best) begin am_best = logits[1]; amax_c = 3'd1; end
        if (logits[2] > am_best) begin am_best = logits[2]; amax_c = 3'd2; end
        if (logits[3] > am_best) begin am_best = logits[3]; amax_c = 3'd3; end
        if (logits[4] > am_best) begin am_best = logits[4]; amax_c = 3'd4; end
    end

    // ------------------------------------------------------------------
    // half-round constants
    // ------------------------------------------------------------------
    // half-round constant for the input normalisation shift; n = 0 means
    // the scale is exact (defensive)
    // half-round constant for requant

    assign feat_ready = (state == S_IDLE);

    always @(posedge clk) begin
        if (!rst_n) begin
            state         <= S_IDLE;
            layer         <= LAYER1;
            neuron        <= 7'd0;
            word_idx      <= 5'd0;
            in_idx        <= 7'd0;
            feat_cnt      <= 6'd0;
            feat_save_idx <= 6'd0;
            feat_save     <= 32'd0;
            m_in_r        <= 32'd0;
            norm_prod     <= 64'd0;
            norm_res      <= 64'd0;
            acc           <= 32'd0;
            word_buf      <= 32'd0;
            rq_m          <= 18'd0;
            rq_n          <= 6'd0;
            rq_prod       <= 64'd0;
            rq_res        <= 64'd0;
            out_valid     <= 1'b0;
            out_id        <= 3'd0;
            out_data      <= 32'd0;
            out_cnt       <= 3'd0;
            bram_addr     <= 11'd0;
            xq_seen <= 0;
            for (i = 0; i < N_OUT; i = i + 1) logits[i] <= 32'sd0;
        end else begin
            case (state)

            // ---- input normalisation: one feature every 5 cycles -------
            // BRAM read latency: an address issued on edge E makes
            // bram_rdata valid at the END of edge E+1, so the consuming
            // state must sample it two edges after issuing.
            S_IDLE: begin
                if (feat_valid) begin
                    feat_save     <= feat_data;
                    feat_save_idx <= {2'd0, feat_index};
                    bram_addr     <= A_M_IN + {4'd0, feat_index};
                    state         <= S_NM;
                end
            end
            S_NM: begin
                bram_addr <= A_N_IN + {4'd0, feat_save_idx};
                state     <= S_NN;
            end
            S_NN: begin
                m_in_r    <= bram_rdata;              // m_in word
                state     <= S_NX;
            end
            S_NX: begin
                n_in_r    <= bram_rdata;              // n_in word
                norm_prod <= feat_save * m_in_r;      // unsigned 32 x 17
                state     <= S_WR;
            end
            S_WR: begin
                norm_res = (norm_prod + in_half) >> n_in_r[5:0];
                xq_seen[feat_save_idx[5:0]] <= 1'b1;
                feat_cnt <= feat_cnt + 6'd1;
                if (feat_cnt == N_IN-1) begin
                    feat_cnt  <= 6'd0;
                    layer     <= LAYER1;
                    neuron    <= 7'd0;
                    word_idx  <= 5'd0;
                    in_idx    <= 7'd0;
                    bram_addr <= A_R1;
                    state     <= S_RQM;
                end else begin
                    state <= S_IDLE;
                end
            end

            // ---- load requant constants for the layer ------------------
            S_RQM: begin
                bram_addr <= (layer == LAYER1) ? (A_R1 + 11'd1) : (A_R2 + 11'd1);
                state     <= S_RQN;
            end
            S_RQN: begin
                rq_m      <= bram_rdata[17:0];        // requant m word
                bram_addr <= b_base;                  // neuron 0 bias
                state     <= S_LDBN;
            end
            // layer entry only: the requant n word is in flight here;
            // S_LDB (subsequent neurons) must NOT touch rq_n
            S_LDBN: begin
                rq_n      <= bram_rdata[5:0];         // requant n word
                bram_addr <= w_base + {6'd0, word_idx};
                state     <= S_LDBW;
            end

            // ---- one neuron: bias + sequential weight words ------------
            S_LDB: begin
                bram_addr <= w_base + {6'd0, word_idx};
                state     <= S_LDBW;
            end
            S_LDBW: begin
                acc   <= $signed(bram_rdata);         // bias word
                state <= S_MAC0;                      // w0 address set in S_LDB
            end
            S_MAC0: begin
                word_buf <= bram_rdata;               // word for this neuron
                acc      <= acc + mac_product;
                if (word_idx != layer_words - 5'd1)
                    bram_addr <= bram_addr + 11'd1;   // prefetch next word
                state    <= S_MAC1;
            end
            S_MAC1: begin
                acc    <= acc + mac_product;
                state  <= S_MAC2;
            end
            S_MAC2: begin
                acc    <= acc + mac_product;
                state  <= S_MAC3;
            end
            S_MAC3: begin
                acc    <= acc + mac_product;
                if (word_idx == layer_words - 5'd1)
                    state <= S_LST;   // wait one cycle for the last MAC
                else begin
                    word_idx <= word_idx + 5'd1;
                    state    <= S_MAC0;
                end
            end

            // ---- last MAC landed in acc: store logit or requant --------
            S_LST: begin
                if (layer == LAYER3) begin
                    logits[neuron[2:0]] <= acc;       // no requant on logits
                    state <= S_NEXT;
                end else begin
                    rq_prod <= acc * $signed(rq_m);
                    state   <= S_REQ;
                end
            end

            // ---- requant: (acc*m + half) >>> n, clip to [0, 127] -------
            S_REQ: begin
                state <= S_REQS;
            end
            S_REQS: begin
                rq_res = (rq_prod + $signed(rq_half)) >>> rq_n;
                if (rq_res < 64'sd0)
                    rq_res = 64'sd0;
                else if (rq_res > 64'sd127)
                    rq_res = 64'sd127;
                state <= S_NEXT;
            end

            // ---- advance neuron / layer --------------------------------
            S_NEXT: begin
                word_idx <= 5'd0;
                in_idx   <= 7'd0;
                if (neuron == layer_last) begin
                    neuron <= 7'd0;
                    if (layer == LAYER3) begin
                        layer <= LAYER1;
                        state <= S_AM;
                    end else if (layer == LAYER1) begin
                        layer     <= LAYER2;
                        bram_addr <= A_R2;
                        state     <= S_RQM;
                    end else begin
                        layer     <= LAYER3;
                        bram_addr <= A_B3;
                        state     <= S_LDB;
                    end
                end else begin
                    neuron    <= neuron + 7'd1;
                    bram_addr <= b_base + 11'd1;
                    state     <= S_LDB;
                end
            end

            // ---- output serializer: logits[0..4], then class -----------
            S_AM: begin
                out_cnt   <= 3'd0;
                out_id    <= 3'd0;
                out_valid <= 1'b1;
                out_data  <= logits[0];
                state     <= S_OUT;
            end
            S_OUT: begin
                if (out_ready) begin
                    if (out_cnt == 3'd5) begin
                        out_valid <= 1'b0;
                        state     <= S_IDLE;
                    end else begin
                        out_cnt <= out_cnt + 3'd1;
                        out_id  <= out_cnt + 3'd1;
                        if (out_cnt == 3'd4)
                            out_data <= {29'd0, amax_c};
                        else
                            out_data <= logits[out_cnt + 3'd1];
                    end
                end
            end

            default: state <= S_IDLE;
            endcase
        end
    end

endmodule
