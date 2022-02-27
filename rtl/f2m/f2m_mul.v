//==============================================================================
// f2m_mul.v
//
// Multiplication over F_{2^m}.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module f2m_mul #(
    parameter M = 163,              // degree of f(x)
    parameter FX = 163'hc9,         // binary representation of f(x)
    parameter NUM_SEG = 3           // number of segment with M, range [1, M]
)
(
    // System signals
    input clk,                      // system clock
    input rst_n,                    // system asynchronous reset, active low
    input clr,                      // synchronous clear

    // Data interface
    input start,                    // computation start
    input [M-1:0] a,                // input polynomial a(x)
    input [M-1:0] b,                // input polynomial b(x)
    output reg done,                // computation done
    output [M-1:0] z                // output a(x) * b(x) mod f(x)
);

// Local parameters
localparam SEG_BITS = (M % NUM_SEG == 0) ? (M / NUM_SEG) : (M / NUM_SEG + 1);
localparam TOT_BITS = SEG_BITS * NUM_SEG;
localparam CNT_WIDTH = $clog2(NUM_SEG);


// Local signals
wire [M-1:0] xpow [SEG_BITS-1:0];      // xpow(i) = x^(M+i) mod f(x), i = 0,...,SEG_BITS-1
genvar i;
reg en;
reg [CNT_WIDTH-1:0] cnt;
reg [M-1:0] a_r;
reg [TOT_BITS-1:0] b_r;
wire [SEG_BITS-1:0] b_seg;
wire [M+SEG_BITS-1:0] z_mul_r;
reg [M+SEG_BITS-1:0] a_mul_b;
integer j1, j2;
wire [M+SEG_BITS-1:0] z_sum;
reg [M-1:0] z_red;
reg [M-1:0] z_r;


// Parameter xpow computation
generate
    assign xpow[0] = FX;
    for (i = 1; i <= SEG_BITS-1; i = i + 1) begin : gen_xpow
        assign xpow[i] = {xpow[i-1][M-2:0], 1'b0} ^ (FX & {M{xpow[i-1][M-1]}});
    end
endgenerate


// Multiplication computation
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt <= 1'b0;
    else if (clr | start)
        cnt <= 1'b0;
    else if (en)
        cnt <= cnt + 1'b1;
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
        en <= 1'b0;
    else if (clr)
        en <= 1'b0;
    else if (start)
        en <= 1'b1;
    else if (cnt == NUM_SEG - 1)
        en <= 1'b0;
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
        done <= 1'b0;
    else if (clr | start)
        done <= 1'b0;
    else if (cnt == NUM_SEG - 1)
        done <= 1'b1;
end

always @ (posedge clk) begin
    if (start)
        a_r <= a;
end

always @ (posedge clk) begin
    if (start)
        b_r <= b;
    else if (en)
        b_r <= b_r << SEG_BITS;
end

assign b_seg = b_r[TOT_BITS-1:TOT_BITS-SEG_BITS];
assign z_mul_r = z_r << SEG_BITS;

always @ (*) begin
    a_mul_b = 1'b0;
    for (j1 = 0; j1 <= SEG_BITS-1; j1 = j1 + 1) begin : gen_a_mul_b
        reg [M+SEG_BITS-1:0] t;
        t = (a_r & {M{b_seg[j1]}}) << j1;
        a_mul_b = a_mul_b ^ t;
    end
end

assign z_sum = z_mul_r ^ a_mul_b;

always @ (*) begin
    z_red = z_sum[M-1:0];
    for (j2 = M; j2 <= M+SEG_BITS-1; j2 = j2 + 1) begin
        z_red = z_red ^ (xpow[j2 - M] & {M{z_sum[j2]}});
    end
end

always @ (posedge clk) begin
    if (start)
        z_r <= 1'b0;
    else if (en)
        z_r <= z_red;
end

assign z = z_r;


endmodule
