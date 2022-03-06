//==============================================================================
// sect409k1_pt_mul.v
//
// Elliptic curve point multiplication of SEC 2 sect409k1.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module sect409k1_pt_mul (
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
localparam B = 409'h1;              // coefficient b of E
localparam XG = 409'h60f05f658f49c1ad3ab1890f7184210efd0987e307c84c27accfb8f9f67cc2c460189eb5aaaa62ee222eb1b35540cfe9023746;        // x coordinate of G
localparam YG = 409'h1e369050b7c4e42acba1dacbf04299c3460782f918ea427e6325165e9ea10e3da5f6c42e9c55215aa9ca27a5863ec48d8e0286b;       // y coordinate of G
localparam XG_SQR = 409'h4f116a845dbecf0cb02a9c30ad51e279c6e27685a471902edec4a1095745c17f3ee88035e15eaa5782daf7d44b02a48d9f329e;    // squaring of x coordinate of G
localparam XG_INV = 409'h11f2a80b9f0d6b74642c7e43ae0a0ac075c83f4c75dedb788caaf17981fded5dd6da98aa0a0132d58a6fa5035baeaf05894a298;   // inversion of x coordinate of G
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
