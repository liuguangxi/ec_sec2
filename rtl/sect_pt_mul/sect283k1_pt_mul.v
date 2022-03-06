//==============================================================================
// sect283k1_pt_mul.v
//
// Elliptic curve point multiplication of SEC 2 sect283k1.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module sect283k1_pt_mul (
    // System signals
    input clk,                      // system clock
    input rst_n,                    // system asynchronous reset, active low
    input clr,                      // synchronous clear

    // Data interface
    input start,                    // computation start
    input [282:0] d,                // input scalar
    output done,                    // computation done
    output [282:0] x,               // output x coordinate of d*G
    output [282:0] y                // output y coordinate of d*G
);

// Local parameters
localparam M = 283;                 // degree of f(x)
localparam FX = 283'h10a1;          // binary representation of f(x)
localparam B = 283'h1;              // coefficient b of E
localparam XG = 283'h503213f78ca44883f1a3b8162f188e553cd265f23c1567a16876913b0c2ac2458492836;       // x coordinate of G
localparam YG = 283'h1ccda380f1c9e318d90f95d07e5426fe87e45c0e8184698e45962364e34116177dd2259;       // y coordinate of G
localparam XG_SQR = 283'h23e5da79acfd5221dd36ca7c69942ffb878734e2caa6d3e3adc35bdb579e53dc448471e;   // squaring of x coordinate of G
localparam XG_INV = 283'h86d01d939cd7605f2b3d5ad73a0fd125ea2704121c958e7a820f5fe6e8962aea314d79;    // inversion of x coordinate of G
localparam NUM_CYCLE_MUL = 4;       // number of computation cycles minus 1 in f2m_mul module (= NUM_SEG)


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
