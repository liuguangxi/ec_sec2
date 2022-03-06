//==============================================================================
// sect571r1_pt_mul.v
//
// Elliptic curve point multiplication of SEC 2 sect571r1.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module sect571r1_pt_mul (
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
localparam B = 571'h2f40e7e2221f295de297117b7f3d62f5c6a97ffcb8ceff1cd6ba8ce4a9a18ad84ffabbd8efa59332be7ad6756a66e294afd185a78ff12aa520e4de739baca0c7ffeff7f2955727a;        // coefficient b of E
localparam XG = 571'h303001d34b856296c16c0d40d3cd7750a93d1d2955fa80aa5f40fc8db7b2abdbde53950f4c0d293cdd711a35b67fb1499ae60038614f1394abfa3b4c850d927e1e7769c8eec2d19;       // x coordinate of G
localparam YG = 571'h37bf27342da639b6dccfffeb73d69d78c6c27a6009cbbca1980f8533921e8a684423e43bab08a576291af8f461bb2a8b3531d2f0485c19b16e2f1516e23dd3c1a4827af1b8ac15b;       // y coordinate of G
localparam XG_SQR = 571'h332c62051a9053b19ce51d1fbb262d4f3cbc5f77cabeb39a55e2fb862f4ee865b3a1ed6584596657601326eec265ca2351c7b2b8c2205d040dec8048c03a467ad8c1847803ecb79;   // squaring of x coordinate of G
localparam XG_INV = 571'h122ee2893da130d4552a8066bbcce2d9dc0be8e9f9e34ba6b84985441e599019e99dbedff4077c8e391ae1a1ce129301045438bf2ee5129d258eaf9c076d8a891de6bc9bed9b794;   // inversion of x coordinate of G
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
