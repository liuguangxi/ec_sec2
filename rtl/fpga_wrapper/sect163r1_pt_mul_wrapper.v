//==============================================================================
// sect163r1_pt_mul_wrapper.v
//
// Wrapper of module sect163r1_pt_mul.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module sect163r1_pt_mul_wrapper (
    // System signals
    input clk,                      // system clock
    input test_i,                   // test input
    output test_o                   // test output
);

// Local signals
wire rst_n;                         // input pin
wire clr;                           // input pin
wire start;                         // input pin
wire [162:0] d;                     // input pin
wire done;                          // output pin
wire [162:0] x;                     // output pin
wire [162:0] y;                     // output pin
wire [165:0] word_o;
wire [326:0] word_i;


// Assignments
assign {rst_n, clr, start, d} = word_o;
assign word_i = {done, x, y};


// Instances
Synthesis_Harness_Input #(
    .WORD_WIDTH     (166)
) u_shi (
    .clock          (clk),
    .clear          (1'b0),
    .bit_in         (test_i),
    .bit_in_valid   (1'b1),
    .word_out       (word_o)
);

Synthesis_Harness_Output #(
    .WORD_WIDTH     (327)
) u_sho (
    .clock          (clk),
    .clear          (1'b0),
    .word_in        (word_i),
    .word_in_valid  (1'b1),
    .bit_out        (test_o)
);

sect163r1_pt_mul u_sect163r1_pt_mul (
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
