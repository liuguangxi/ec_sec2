//==============================================================================
// sect239k1_pt_mul.v
//
// Elliptic curve point multiplication of SEC 2 sect239k1.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module sect239k1_pt_mul (
    // System signals
    input clk,                      // system clock
    input rst_n,                    // system asynchronous reset, active low
    input clr,                      // synchronous clear

    // Data interface
    input start,                    // computation start
    input [238:0] d,                // input scalar
    output done,                    // computation done
    output [238:0] x,               // output x coordinate of d*G
    output [238:0] y                // output y coordinate of d*G
);

// Local parameters
localparam M = 239;                 // degree of f(x)
localparam FX = 239'h4000000000000000000000000000000000000001;      // binary representation of f(x)
localparam B = 239'h1;              // coefficient b of E
localparam XG = 239'h29a0b6a887a983e9730988a68727a8b2d126c44cc2cc7b2a6555193035dc;      // x coordinate of G
localparam YG = 239'h76310804f12e549bdb011c103089e73510acb275fc312a5dc6b76553f0ca;      // y coordinate of G
localparam XG_SQR = 239'h3c3e838af38497537a481cc7945af8d36a0e5486d7f06b6cf3e13a1ef99b;  // squaring of x coordinate of G
localparam XG_INV = 239'h742f119ea71524979524c0c5d545eaa801e6d7dee1c7583debc936bc8a90;  // inversion of x coordinate of G
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
