//==============================================================================
// sect_pt_mul.v
//
// Elliptic curve point multiplication of SEC 2 F_{2^m} series.
//
// T = (m, f(x), a, b, G, n, h)
// E : y^2 + x*y = x^3 + a*x^2 + b in F_{2^m}
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module sect_pt_mul #(
    parameter M = 163,              // degree of f(x)
    parameter FX = 163'hc9,         // binary representation of f(x)
    parameter B = 163'h1,           // coefficient b of E
    parameter XG = 163'h2fe13c0537bbc11acaa07d793de4e6d5e5c94eee8,      // x coordinate of G
    parameter YG = 163'h289070fb05d38ff58321f2e800536d538ccdaa3d9,      // y coordinate of G
    parameter XG_SQR = 163'h6710bd85f2b559b085dc2832e086f4a4c7ef8d0be,  // squaring of x coordinate of G
    parameter XG_INV = 163'h63f514f39f4587684f96c8dd6558e69339a1efed9,  // inversion of x coordinate of G
    parameter NUM_CYCLE_MUL = 3     // number of computation cycles minus 1 in f2m_mul module (= NUM_SEG)
)
(
    // System signals
    input clk,                      // system clock
    input rst_n,                    // system asynchronous reset, active low
    input clr,                      // synchronous clear

    // Data interface
    input start,                    // computation start
    input [M-1:0] d,                // input scalar
    output reg done,                // computation done
    output [M-1:0] x,               // output x coordinate of d*G
    output [M-1:0] y                // output y coordinate of d*G
);

// Local parameters
localparam ST_IDLE = 4'd0;
localparam ST_LOOP_MUL1 = 4'd1;
localparam ST_LOOP_MUL2 = 4'd2;
localparam ST_ZB_ZERO = 4'd3;
localparam ST_MUL1 = 4'd4;
localparam ST_INV = 4'd5;
localparam ST_MUL2 = 4'd6;
localparam ST_MUL3 = 4'd7;
localparam ST_MUL4 = 4'd8;
localparam ST_MUL5 = 4'd9;

localparam CNT_WIDTH = $clog2(M + 2);
localparam CNT_LOOP_WIDTH = $clog2(M);


// Local signals
reg [3:0] state;
reg [3:0] state_next;
reg [CNT_WIDTH-1:0] cnt;
reg [CNT_LOOP_WIDTH-1:0] cnt_loop;
wire flag0;
wire flag1;
wire flag2;
wire flag3;
reg [M-1:0] d_r;
reg [M-1:0] xa_r;
reg [M-1:0] za_r;
reg [M-1:0] xb_r;
reg [M-1:0] zb_r;
reg [M-1:0] t1_r;
reg [M-1:0] t2_r;
reg [M-1:0] t3_r;
wire zb_zero;
wire [M-1:0] a_sqr1;
wire [M-1:0] z_sqr1;
wire [M-1:0] a_sqr2;
wire [M-1:0] z_sqr2;
wire [M-1:0] a_sqr3;
wire [M-1:0] z_sqr3;
wire [M-1:0] a_sqr4;
wire [M-1:0] z_sqr4;
wire start_mul1;
wire [M-1:0] a_mul1;
wire [M-1:0] b_mul1;
wire [M-1:0] z_mul1;
wire start_mul2;
wire [M-1:0] a_mul2;
wire [M-1:0] b_mul2;
wire [M-1:0] z_mul2;
wire start_mul3;
wire [M-1:0] a_mul3;
wire [M-1:0] b_mul3;
wire [M-1:0] z_mul3;
wire start_inv;
wire [M-1:0] a_inv;
wire [M-1:0] z_inv;


// Control unit
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= ST_IDLE;
    else if (clr)
        state <= ST_IDLE;
    else
        state <= state_next;
end

always @ (*) begin
    state_next = state;
    case (state)
        ST_IDLE:
            if (start)    state_next = ST_LOOP_MUL1;
        ST_LOOP_MUL1:
            if (flag1)    state_next = ST_LOOP_MUL2;
        ST_LOOP_MUL2:
            if (flag2)    state_next = (cnt_loop == M-1) ? ST_ZB_ZERO : ST_LOOP_MUL1;
        ST_ZB_ZERO:
            state_next = (zb_zero) ? ST_IDLE : ST_MUL1;
        ST_MUL1:
            if (flag2)    state_next = ST_INV;
        ST_INV:
            if (flag3)    state_next = ST_MUL2;
        ST_MUL2:
            if (flag2)    state_next = ST_MUL3;
        ST_MUL3:
            if (flag2)    state_next = ST_MUL4;
        ST_MUL4:
            if (flag2)    state_next = ST_MUL5;
        ST_MUL5:
            if (flag2)    state_next = ST_IDLE;
        default: state_next = ST_IDLE;
    endcase
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt <= 1'b0;
    else if (clr)
        cnt <= 1'b0;
    else if (state == ST_IDLE || state == ST_ZB_ZERO)
        cnt <= 1'b0;
    else if (state == ST_LOOP_MUL1)
        cnt <= (flag1) ? 1'b0 : cnt + 1'b1;
    else if (state == ST_LOOP_MUL2 || state == ST_MUL1 || state == ST_MUL2 || state == ST_MUL3
        || state == ST_MUL4 || state == ST_MUL5)
        cnt <= (flag2) ? 1'b0 : cnt + 1'b1;
    else if (state == ST_INV)
        cnt <= (flag3) ? 1'b0 : cnt + 1'b1;
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt_loop <= 1'b0;
    else if (clr)
        cnt_loop <= 1'b0;
    else if (state == ST_IDLE)
        cnt_loop <= 1'b0;
    else if (state == ST_LOOP_MUL2) begin
        if (flag2)
            cnt_loop <= cnt_loop + 1'b1;
    end
end

assign flag0 = (cnt == 1'b0) ? 1'b1 : 1'b0;
assign flag1 = (cnt == NUM_CYCLE_MUL) ? 1'b1 : 1'b0;
assign flag2 = (cnt == NUM_CYCLE_MUL+1) ? 1'b1 : 1'b0;
assign flag3 = (cnt == M+1) ? 1'b1 : 1'b0;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
        done <= 1'b0;
    else if (clr | start)
        done <= 1'b0;
    else if (state == ST_ZB_ZERO && zb_zero == 1'b1)
        done <= 1'b1;
    else if (state == ST_MUL5 && flag2 == 1'b1)
        done <= 1'b1;
end


// Computation
always @ (posedge clk) begin
    if (start)
        d_r <= d;
    else if (state == ST_LOOP_MUL2) begin
        if (flag2)
            d_r <= d_r << 1;
    end
end

always @ (posedge clk) begin
    if (start)
        xa_r <= 1'b1;
    else if (state == ST_LOOP_MUL2 && flag2 == 1'b1)
        xa_r <= (d_r[M-1] == 1'b0) ? z_sqr3 ^ z_mul3 : z_mul1 ^ z_mul2;
    else if (state == ST_ZB_ZERO && zb_zero == 1'b1)
        xa_r <= XG;
    else if (state == ST_MUL1 && flag2 == 1'b1)
        xa_r <= z_mul1;
    else if (state == ST_MUL2 && flag2 == 1'b1)
        xa_r <= z_mul1;
end

always @ (posedge clk) begin
    if (start)
        za_r <= 1'b0;
    else if (state == ST_LOOP_MUL2 && flag2 == 1'b1)
        za_r <= (d_r[M-1] == 1'b0) ? z_sqr4 : z_sqr1;
    else if (state == ST_ZB_ZERO && zb_zero == 1'b1)
        za_r <= XG ^ YG;
    else if (state == ST_MUL3 && flag2 == 1'b1)
        za_r <= z_mul1 ^ XG_SQR ^ YG;
    else if (state == ST_MUL4 && flag2 == 1'b1)
        za_r <= z_mul1;
    else if (state == ST_MUL5 && flag2 == 1'b1)
        za_r <= z_mul1 ^ YG;
end

always @ (posedge clk) begin
    if (start)
        xb_r <= XG;
    else if (state == ST_LOOP_MUL2 && flag2 == 1'b1)
        xb_r <= (d_r[M-1] == 1'b0) ? z_mul1 ^ z_mul2 : z_sqr3 ^ z_mul3;
    else if (state == ST_MUL1 && flag2 == 1'b1)
        xb_r <= z_mul2;
    else if (state == ST_MUL2 && flag2 == 1'b1)
        xb_r <= z_mul2;
end

always @ (posedge clk) begin
    if (start)
        zb_r <= 1'b1;
    else if (state == ST_LOOP_MUL2 && flag2 == 1'b1)
        zb_r <= (d_r[M-1] == 1'b0) ? z_sqr1 : z_sqr4;
end

always @ (posedge clk) begin
    if (start)
        t1_r <= 1'b0;
    else if (state == ST_LOOP_MUL2 && flag0 == 1'b1)
        t1_r <= z_mul1;
    else if (state == ST_MUL1 && flag2 == 1'b1)
        t1_r <= z_mul3;
end

always @ (posedge clk) begin
    if (start)
        t2_r <= 1'b0;
    else if (state == ST_LOOP_MUL2 && flag0 == 1'b1)
        t2_r <= z_mul2;
    else if (state == ST_INV && flag3 == 1'b1)
        t2_r <= z_inv;
end

always @ (posedge clk) begin
    if (start)
        t3_r <= 1'b0;
    else if (state == ST_LOOP_MUL2 && flag0 == 1'b1)
        t3_r <= z_mul3;
end

assign zb_zero = (zb_r == 1'b0) ? 1'b1 : 1'b0;

assign a_sqr1 = (cnt == 1'b0) ? z_mul1 ^ z_mul2 : t1_r ^ t2_r;
assign a_sqr2 = (cnt == 1'b0) ?
                ((d_r[M-1] == 1'b0) ? za_r : zb_r) :
                ((d_r[M-1] == 1'b0) ? xa_r : xb_r);
assign a_sqr3 = z_sqr2;
assign a_sqr4 = t3_r;

assign start_mul1 = ((state == ST_LOOP_MUL1 || state == ST_LOOP_MUL2 || state == ST_MUL1 || state == ST_MUL2
                    || state == ST_MUL3 || state == ST_MUL4 || state == ST_MUL5) && (flag0 == 1'b1)) ? 1'b1 : 1'b0;
assign a_mul1 = (state == ST_LOOP_MUL1) ? xa_r :
                (state == ST_LOOP_MUL2) ? XG :
                (state == ST_MUL1) ? xa_r :
                (state == ST_MUL2) ? xa_r :
                (state == ST_MUL3) ? xa_r ^ XG :
                (state == ST_MUL4) ? xa_r ^ XG :
                XG_INV;
assign b_mul1 = (state == ST_LOOP_MUL1) ? zb_r :
                (state == ST_LOOP_MUL2) ? z_sqr1 :
                (state == ST_MUL1) ? zb_r :
                (state == ST_MUL2) ? t2_r :
                (state == ST_MUL3) ? xb_r ^ XG :
                za_r;

assign start_mul2 = ((state == ST_LOOP_MUL1 || state == ST_LOOP_MUL2 || state == ST_MUL1 || state == ST_MUL2)
                    && (flag0 == 1'b1)) ? 1'b1 : 1'b0;
assign a_mul2 = (state == ST_LOOP_MUL1) ? xb_r :
                (state == ST_LOOP_MUL2) ? z_mul1 :
                xb_r;
assign b_mul2 = (state == ST_LOOP_MUL1) ? za_r :
                (state == ST_LOOP_MUL2) ? z_mul2 :
                (state == ST_MUL1) ? za_r :
                t2_r;

assign start_mul3 = ((state == ST_LOOP_MUL1 || state == ST_LOOP_MUL2 || state == ST_MUL1)
                    && (flag0 == 1'b1)) ? 1'b1 : 1'b0;
assign a_mul3 = (state == ST_LOOP_MUL1) ? ((d_r[M-1] == 1'b0) ? xa_r : xb_r) :
                (state == ST_LOOP_MUL2) ? B :
                za_r;
assign b_mul3 = (state == ST_LOOP_MUL1) ? ((d_r[M-1] == 1'b0) ? za_r : zb_r) :
                (state == ST_LOOP_MUL2) ? z_sqr3 :
                zb_r;

assign start_inv = (state == ST_INV && flag0 == 1'b1) ? 1'b1 : 1'b0;
assign a_inv = t1_r;

assign x = xa_r;
assign y = za_r;


// Instances
f2m_sqr #(
    .M              (M),
    .FX             (FX)
) u1_f2m_sqr (
    .a              (a_sqr1),
    .z              (z_sqr1)
);

f2m_sqr #(
    .M              (M),
    .FX             (FX)
) u2_f2m_sqr (
    .a              (a_sqr2),
    .z              (z_sqr2)
);

f2m_sqr #(
    .M              (M),
    .FX             (FX)
) u3_f2m_sqr (
    .a              (a_sqr3),
    .z              (z_sqr3)
);

f2m_sqr #(
    .M              (M),
    .FX             (FX)
) u4_f2m_sqr (
    .a              (a_sqr4),
    .z              (z_sqr4)
);

f2m_mul #(
    .M              (M),
    .FX             (FX),
    .NUM_SEG        (NUM_CYCLE_MUL)
) u1_f2m_mul (
    .clk            (clk),
    .rst_n          (rst_n),
    .clr            (clr),
    .start          (start_mul1),
    .a              (a_mul1),
    .b              (b_mul1),
    .done           (),
    .z              (z_mul1)
);

f2m_mul #(
    .M              (M),
    .FX             (FX),
    .NUM_SEG        (NUM_CYCLE_MUL)
) u2_f2m_mul (
    .clk            (clk),
    .rst_n          (rst_n),
    .clr            (clr),
    .start          (start_mul2),
    .a              (a_mul2),
    .b              (b_mul2),
    .done           (),
    .z              (z_mul2)
);

f2m_mul #(
    .M              (M),
    .FX             (FX),
    .NUM_SEG        (NUM_CYCLE_MUL)
) u3_f2m_mul (
    .clk            (clk),
    .rst_n          (rst_n),
    .clr            (clr),
    .start          (start_mul3),
    .a              (a_mul3),
    .b              (b_mul3),
    .done           (),
    .z              (z_mul3)
);

f2m_inv #(
    .M              (M),
    .FX             (FX)
) u_f2m_inv (
    .clk            (clk),
    .rst_n          (rst_n),
    .clr            (clr),
    .start          (start_inv),
    .a              (a_inv),
    .done           (),
    .z              (z_inv)
);


endmodule
