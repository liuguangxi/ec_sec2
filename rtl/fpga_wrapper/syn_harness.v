//==============================================================================
// syn_harness.v
//
// Synthesis harness input and output logic.
//
// [Reference]
// http://fpgacpu.ca/fpga/Synthesis_Harness_Input.html
// http://fpgacpu.ca/fpga/Synthesis_Harness_Output.html
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module Register #(
    parameter WORD_WIDTH = 0,
    parameter RESET_VALUE = 0
)
(
    input clock,
    input clock_enable,
    input clear,
    input [WORD_WIDTH-1:0] data_in,
    output reg [WORD_WIDTH-1:0] data_out
);

initial begin
    data_out = RESET_VALUE;
end

always @ (posedge clock) begin
    if (clock_enable == 1'b1) begin
        data_out <= data_in;
    end
    if (clear == 1'b1) begin
        data_out <= RESET_VALUE;
    end
end

endmodule


module Multiplexer_Binary_Behavioural #(
    parameter WORD_WIDTH = 0,
    parameter ADDR_WIDTH = 0,
    parameter INPUT_COUNT = 0,
    // Do not set at instantiation
    parameter   TOTAL_WIDTH = WORD_WIDTH * INPUT_COUNT
)
(
    input [ADDR_WIDTH-1:0] selector,
    input [TOTAL_WIDTH-1:0] words_in,
    output reg [WORD_WIDTH-1:0] word_out
);

initial begin
    word_out = {WORD_WIDTH{1'b0}};
end

always @ (*) begin
    word_out = words_in[(selector * WORD_WIDTH) +: WORD_WIDTH];
end

endmodule


module Register_Pipeline #(
    parameter WORD_WIDTH = 0,
    parameter PIPE_DEPTH = 0,
    // Don't set at instantiation
    parameter TOTAL_WIDTH = WORD_WIDTH * PIPE_DEPTH,
    // concatenation of each stage initial/reset value
    parameter [TOTAL_WIDTH-1:0] RESET_VALUES = 0
)
(
    input clock,
    input clock_enable,
    input clear,
    input parallel_load,
    input [TOTAL_WIDTH-1:0] parallel_in,
    output reg [TOTAL_WIDTH-1:0] parallel_out,
    input [WORD_WIDTH-1:0] pipe_in,
    output reg [WORD_WIDTH-1:0] pipe_out
);

localparam WORD_ZERO = {WORD_WIDTH{1'b0}};

initial begin
    pipe_out = WORD_ZERO;
end

wire [WORD_WIDTH-1:0] pipe_stage_in [PIPE_DEPTH-1:0];
wire [WORD_WIDTH-1:0] pipe_stage_out [PIPE_DEPTH-1:0];

(* multstyle = "logic" *) // Quartus
(* use_dsp   = "no" *)    // Vivado

Multiplexer_Binary_Behavioural #(
    .WORD_WIDTH     (WORD_WIDTH),
    .ADDR_WIDTH     (1),
    .INPUT_COUNT    (2)
) pipe_input_select (
    .selector       (parallel_load),
    .words_in       ({parallel_in[0 +: WORD_WIDTH], pipe_in}),
    .word_out       (pipe_stage_in[0])
);

Register #(
    .WORD_WIDTH     (WORD_WIDTH),
    .RESET_VALUE    (RESET_VALUES[0 +: WORD_WIDTH])
) pipe_stage (
    .clock          (clock),
    .clock_enable   (clock_enable),
    .clear          (clear),
    .data_in        (pipe_stage_in[0]),
    .data_out       (pipe_stage_out[0])
);

always @ (*) begin
    parallel_out[0 +: WORD_WIDTH] = pipe_stage_out[0];
end

generate
    genvar i;

    for (i = 1; i < PIPE_DEPTH; i = i + 1) begin : pipe_stages
        (* multstyle = "logic" *) // Quartus
        (* use_dsp   = "no" *)    // Vivado

        Multiplexer_Binary_Behavioural #(
            .WORD_WIDTH     (WORD_WIDTH),
            .ADDR_WIDTH     (1),
            .INPUT_COUNT    (2)
        ) pipe_input_select (
            .selector       (parallel_load),
            .words_in       ({parallel_in[WORD_WIDTH*i +: WORD_WIDTH], pipe_stage_out[i-1]}),
            .word_out       (pipe_stage_in[i])
        );

        Register #(
            .WORD_WIDTH     (WORD_WIDTH),
            .RESET_VALUE    (RESET_VALUES[WORD_WIDTH*i +: WORD_WIDTH])
        ) pipe_stage (
            .clock          (clock),
            .clock_enable   (clock_enable),
            .clear          (clear),
            .data_in        (pipe_stage_in[i]),
            .data_out       (pipe_stage_out[i])
        );

        always @ (*) begin
            parallel_out[WORD_WIDTH*i +: WORD_WIDTH] = pipe_stage_out[i];
        end
    end
endgenerate

always @ (*) begin
    pipe_out = pipe_stage_out[PIPE_DEPTH-1];
end

endmodule


module Synthesis_Harness_Input #(
    parameter WORD_WIDTH = 0
)
(
    input clock,
    input clear,
    input bit_in,
    input bit_in_valid,
    output [WORD_WIDTH-1:0] word_out
);

localparam WORD_ZERO = {WORD_WIDTH{1'b0}};

// Vivado: don't put in I/O buffers, and keep netlists separate in synth and implementation.
(* IOB = "false" *)
(* DONT_TOUCH = "true" *)

// Quartus: don't use I/O buffers, and don't merge registers with others.
(* useioff = 0 *)
(* preserve *)

Register_Pipeline #(
    .WORD_WIDTH     (1),
    .PIPE_DEPTH     (WORD_WIDTH),
    .RESET_VALUES   (WORD_ZERO)
) shift_bit_into_word (
    .clock          (clock),
    .clock_enable   (bit_in_valid),
    .clear          (clear),
    .parallel_load  (1'b0),
    .parallel_in    (WORD_ZERO),
    .parallel_out   (word_out),
    .pipe_in        (bit_in),
    .pipe_out       ()
);

endmodule


module Synthesis_Harness_Output #(
    parameter WORD_WIDTH = 0
)
(
    input clock,
    input clear,
    input [WORD_WIDTH-1:0] word_in,
    input word_in_valid,
    output reg bit_out
);

localparam WORD_ZERO = {WORD_WIDTH{1'b0}};

initial begin
    bit_out = 1'b0;
end

wire [WORD_WIDTH-1:0] word_out;

// Vivado: don't put in I/O buffers, and keep netlists separate in synth and implementation.
(* IOB = "false" *)
(* DONT_TOUCH = "true" *)

// Quartus: don't use I/O buffers, and don't merge registers with others.
(* useioff = 0 *)
(* preserve *)

Register_Pipeline #(
    .WORD_WIDTH     (WORD_WIDTH),
    .PIPE_DEPTH     (1),
    .RESET_VALUES   (WORD_ZERO)
) word_register (
    .clock          (clock),
    .clock_enable   (word_in_valid),
    .clear          (clear),
    .parallel_load  (1'b0),
    .parallel_in    (WORD_ZERO),
    .parallel_out   (),
    .pipe_in        (word_in),
    .pipe_out       (word_out)
);

always @ (*) begin
    bit_out = ^word_out;
end

endmodule
