//==============================================================================
// sect163r2_pt_mul.v
//
// Elliptic curve point multiplication of SEC 2 sect163r2.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module sect163r2_pt_mul (
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
localparam B = 163'h20a601907b8c953ca1481eb10512f78744a3205fd;          // coefficient b of E
localparam XG = 163'h3f0eba16286a2d57ea0991168d4994637e8343e36;         // x coordinate of G
localparam YG = 163'hd51fbc6c71a0094fa2cdd545b11c5c0c797324f1;          // y coordinate of G
localparam XG_SQR = 163'h306a6acf3dd8897a3d9e4a9f616eacd08a9d2564b;     // squaring of x coordinate of G
localparam XG_INV = 163'h3c8c172e24598e90b9542e6b8f6571f54be572b50;     // inversion of x coordinate of G
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
