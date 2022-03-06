//==============================================================================
// sect571k1_pt_mul.v
//
// Elliptic curve point multiplication of SEC 2 sect571k1.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module sect571k1_pt_mul (
    // System signals
    input clk,                      // system clock
    input rst_n,                    // system asynchronous reset, active low
    input clr,                      // synchronous clear

    // Data interface
    input start,                    // computation start
    input [570:0] d,                // input scalar
    output done,                    // computation done
    output [570:0] x,               // output x coordinate of d*G
    output [570:0] y                // output y coordinate of d*G
);

// Local parameters
localparam M = 571;                 // degree of f(x)
localparam FX = 571'h425;           // binary representation of f(x)
localparam B = 571'h1;              // coefficient b of E
localparam XG = 571'h26eb7a859923fbc82189631f8103fe4ac9ca2970012d5d46024804801841ca44370958493b205e647da304db4ceb08cbbd1ba39494776fb988b47174dca88c7e2945283a01c8972;       // x coordinate of G
localparam YG = 571'h349dc807f4fbf374f4aeade3bca95314dd58cec9f307a54ffc61efc006d8a2c9d4979c0ac44aea74fbebbb9f772aedcb620b01a7ba7af1b320430c8591984f601cd4c143ef1c7a3;       // y coordinate of G
localparam XG_SQR = 571'h1f69630df2af4fb3d1be179f2b7737b5735f9f2bf16cf254dc1f3bcba1cec52d3c4f12da632296541c6db2b575be14d924bbb6c482b7815f1840bbdf036824dd8fc00f40fc07b03;   // squaring of x coordinate of G
localparam XG_INV = 571'h78ec6e73b25a57e889bc828cf60cd244e361957532f61a9792b791e0235f99e496d3b30f7c9568d44de8278f1c18ac8a5e73464fef0b1dc684662c93f54d8a4a8c46955aaf6e4ac;   // inversion of x coordinate of G
localparam NUM_CYCLE_MUL = 9;       // number of computation cycles minus 1 in f2m_mul module (= NUM_SEG)


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
