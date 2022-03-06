//==============================================================================
// sect409r1_pt_mul.v
//
// Elliptic curve point multiplication of SEC 2 sect409r1.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module sect409r1_pt_mul (
    // System signals
    input clk,                      // system clock
    input rst_n,                    // system asynchronous reset, active low
    input clr,                      // synchronous clear

    // Data interface
    input start,                    // computation start
    input [408:0] d,                // input scalar
    output done,                    // computation done
    output [408:0] x,               // output x coordinate of d*G
    output [408:0] y                // output y coordinate of d*G
);

// Local parameters
localparam M = 409;                 // degree of f(x)
localparam FX = 409'h8000000000000000000001;    // binary representation of f(x)
localparam B = 409'h21a5c2c8ee9feb5c4b9a753b7b476b7fd6422ef1f3dd674761fa99d6ac27c8a9a197b272822f6cd57a55aa4f50ae317b13545f;         // coefficient b of E
localparam XG = 409'h15d4860d088ddb3496b0c6064756260441cde4af1771d4db01ffe5b34e59703dc255a868a1180515603aeab60794e54bb7996a7;       // x coordinate of G
localparam YG = 409'h61b1cfab6be5f32bbfa78324ed106a7636b9c5a7bd198d0158aa4f5488d08f38514f1fdf4b4f40d2181b3681c364ba0273c706;        // y coordinate of G
localparam XG_SQR = 409'h188e88c610a11288121252dfcf683dd74cf67946c4a015f5c5f9d9a065e545d1d04a939ea58333ac0fcb1b2e5cfbde9e11ce6b5;   // squaring of x coordinate of G
localparam XG_INV = 409'hcca19639ff35877d254197212cc4ef529bc12a2b9ec9729744ec362d4b2f5576c434c75a7b4a77d03503022ba9d65cf3c173b8;    // inversion of x coordinate of G
localparam NUM_CYCLE_MUL = 6;       // number of computation cycles minus 1 in f2m_mul module (= NUM_SEG)


// Instance
sect_pt_mul #(
    .M              (M),
    .FX             (FX),
    .B              (B),
    .XG             (XG),
    .YG             (YG),
    .XG_SQR         (XG_SQR),
    .XG_INV         (XG_INV),
    .NUM_CYCLE_MUL  (NUM_CYCLE_MUL)
) u_sect_pt_mul (
    .clk            (clk),
    .rst_n          (rst_n),
    .clr            (clr),
    .start          (start),
    .d              (d),
    .done           (done),
    .x              (x),
    .y              (y)
);


endmodule
