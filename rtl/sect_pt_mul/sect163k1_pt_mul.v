//==============================================================================
// sect163k1_pt_mul.v
//
// Elliptic curve point multiplication of SEC 2 sect163k1.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module sect163k1_pt_mul (
    // System signals
    input clk,                      // system clock
    input rst_n,                    // system asynchronous reset, active low
    input clr,                      // synchronous clear

    // Data interface
    input start,                    // computation start
    input [162:0] d,                // input scalar
    output done,                    // computation done
    output [162:0] x,               // output x coordinate of d*G
    output [162:0] y                // output y coordinate of d*G
);

// Local parameters
localparam M = 163;                 // degree of f(x)
localparam FX = 163'hc9;            // binary representation of f(x)
localparam B = 163'h1;              // coefficient b of E
localparam XG = 163'h2fe13c0537bbc11acaa07d793de4e6d5e5c94eee8;         // x coordinate of G
localparam YG = 163'h289070fb05d38ff58321f2e800536d538ccdaa3d9;         // y coordinate of G
localparam XG_SQR = 163'h6710bd85f2b559b085dc2832e086f4a4c7ef8d0be;     // squaring of x coordinate of G
localparam XG_INV = 163'h63f514f39f4587684f96c8dd6558e69339a1efed9;     // inversion of x coordinate of G
localparam NUM_CYCLE_MUL = 3;       // number of computation cycles minus 1 in f2m_mul module (= NUM_SEG)


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
