//==============================================================================
// sect283r1_pt_mul.v
//
// Elliptic curve point multiplication of SEC 2 sect283r1.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module sect283r1_pt_mul (
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
localparam B = 283'h27b680ac8b8596da5a4af8a19a0303fca97fd7645309fa2a581485af6263e313b79a2f5;        // coefficient b of E
localparam XG = 283'h5f939258db7dd90e1934f8c70b0dfec2eed25b8557eac9c80e2e198f8cdbecd86b12053;       // x coordinate of G
localparam YG = 283'h3676854fe24141cb98fe6d4b20d02b4516ff702350eddb0826779c813f0df45be8112f4;       // y coordinate of G
localparam XG_SQR = 283'h4b8f3a3a54246da95174108b93cd81c4737040cde4c31576a1856a1c20a87fd32798b3a;   // squaring of x coordinate of G
localparam XG_INV = 283'h7ba4d2655470fdd937954c1041ed1a140e38f0f57279e7c1ef6e8870297765e9d0fc95a;   // inversion of x coordinate of G
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
