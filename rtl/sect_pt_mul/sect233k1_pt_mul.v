//==============================================================================
// sect233k1_pt_mul.v
//
// Elliptic curve point multiplication of SEC 2 sect233k1.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module sect233k1_pt_mul (
    // System signals
    input clk,                      // system clock
    input rst_n,                    // system asynchronous reset, active low
    input clr,                      // synchronous clear

    // Data interface
    input start,                    // computation start
    input [232:0] d,                // input scalar
    output done,                    // computation done
    output [232:0] x,               // output x coordinate of d*G
    output [232:0] y                // output y coordinate of d*G
);

// Local parameters
localparam M = 233;                 // degree of f(x)
localparam FX = 233'h4000000000000000001;       // binary representation of f(x)
localparam B = 233'h1;              // coefficient b of E
localparam XG = 233'h17232ba853a7e731af129f22ff4149563a419c26bf50a4c9d6eefad6126;       // x coordinate of G
localparam YG = 233'h1db537dece819b7f70f555a67c427a8cd9bf18aeb9b56e0c11056fae6a3;       // y coordinate of G
localparam XG_SQR = 233'h113bcafec38a1e9f284bec901039e7f0d4bc3b7a1ebd2526abed8419d31;   // squaring of x coordinate of G
localparam XG_INV = 233'h1ecb92776d0fb3dec476585b9065724ef7e1966bf54a850e5cbddaa1be6;   // inversion of x coordinate of G
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
