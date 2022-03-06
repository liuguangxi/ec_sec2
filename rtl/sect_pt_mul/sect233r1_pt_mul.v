//==============================================================================
// sect233r1_pt_mul.v
//
// Elliptic curve point multiplication of SEC 2 sect233r1.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module sect233r1_pt_mul (
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
localparam B = 233'h66647ede6c332c7f8c0923bb58213b333b20e9ce4281fe115f7d8f90ad;         // coefficient b of E
localparam XG = 233'hfac9dfcbac8313bb2139f1bb755fef65bc391f8b36f8f8eb7371fd558b;        // x coordinate of G
localparam YG = 233'h1006a08a41903350678e58528bebf8a0beff867a7ca36716f7e01f81052;       // y coordinate of G
localparam XG_SQR = 233'hdf363367f225632bf562e6f8871c6d98b537780dfad1f3b68accc9afab;    // squaring of x coordinate of G
localparam XG_INV = 233'hb8b6e54d512aed5603c814e5c97382778751a79bfa4a0ee8213d2f5b4;     // inversion of x coordinate of G
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
