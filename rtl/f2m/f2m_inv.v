//==============================================================================
// f2m_inv.v
//
// Inversion over F_{2^m}.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module f2m_inv #(
    parameter M = 163,              // degree of f(x)
    parameter FX = 163'hc9          // binary representation of f(x)
)
(
    // System signals
    input clk,                      // system clock
    input rst_n,                    // system asynchronous reset, active low
    input clr,                      // synchronous clear

    // Data interface
    input start,                    // computation start
    input [M-1:0] a,                // input polynomial a(x)
    output reg done,                // computation done
    output [M-1:0] z                // output a(x)^(-1) mod f(x)
);

// Local parameters
localparam CNT_WIDTH = $clog2(M);
localparam D_WIDTH = $clog2(2*M+1);


// Local signals
reg en;
reg [CNT_WIDTH-1:0] cnt;
reg [M:0] r_r;
reg [M:0] s_r;
reg [M:0] u_r;
reg [M:0] v_r;
reg [D_WIDTH-1:0] d_r;
wire [M:0] r;
wire [M:0] s;
wire [M:0] u;
wire [M:0] v;
wire [D_WIDTH-1:0] d;


// Inversion computation
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt <= 1'b0;
    else if (clr | start)
        cnt <= 1'b0;
    else if (en)
        cnt <= cnt + 1'b1;
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
        en <= 1'b0;
    else if (clr)
        en <= 1'b0;
    else if (start)
        en <= 1'b1;
    else if (cnt == M - 1)
        en <= 1'b0;
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)
        done <= 1'b0;
    else if (clr | start)
        done <= 1'b0;
    else if (cnt == M - 1)
        done <= 1'b1;
end

always @ (posedge clk) begin
    if (start)
        r_r <= a;
    else if (en)
        r_r <= r;
end

always @ (posedge clk) begin
    if (start)
        s_r <= {1'b1, FX};
    else if (en)
        s_r <= s;
end

always @ (posedge clk) begin
    if (start)
        u_r <= 1'b1;
    else if (en)
        u_r <= u;
end

always @ (posedge clk) begin
    if (start)
        v_r <= 1'b0;
    else if (en)
        v_r <= v;
end

always @ (posedge clk) begin
    if (start)
        d_r <= 1'b0;
    else if (en)
        d_r <= d;
end

assign z = u_r[M-1:0];


// Instances
f2m_inv_dp #(
    .M              (M),
    .D_WIDTH        (D_WIDTH)
) u_f2m_inv_dp (
    .r_i            (r_r),
    .s_i            (s_r),
    .u_i            (u_r),
    .v_i            (v_r),
    .d_i            (d_r),
    .r_o            (r),
    .s_o            (s),
    .u_o            (u),
    .v_o            (v),
    .d_o            (d)
);


endmodule
