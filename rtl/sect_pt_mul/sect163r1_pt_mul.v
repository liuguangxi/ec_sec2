//==============================================================================
// sect163r1_pt_mul.v
//
// Elliptic curve point multiplication of SEC 2 sect163r1.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module sect163r1_pt_mul (
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
localparam B = 163'h713612dcddcb40aab946bda29ca91f73af958afd9;          // coefficient b of E
localparam XG = 163'h369979697ab43897789566789567f787a7876a654;         // x coordinate of G
localparam YG = 163'h435edb42efafb2989d51fefce3c80988f41ff883;          // y coordinate of G
localparam XG_SQR = 163'h44c23088e1c4c59c9ff4273ffb10db5daa44bf95;      // squaring of x coordinate of G
localparam XG_INV = 163'h2d2d447511f3798538ad32245fec70b1a63030bb5;     // inversion of x coordinate of G
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
