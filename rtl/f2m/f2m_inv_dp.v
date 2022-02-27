//==============================================================================
// f2m_inv_dp.v
//
// Datapath of inversion over F_{2^m}.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module f2m_inv_dp #(
    parameter M = 163,              // degree of f(x)
    parameter D_WIDTH = 9           // data width of counter d
)
(
    // Data interface
    input [M:0] r_i,                // input polynomial r(x)
    input [M:0] s_i,                // input polynomial s(x)
    input [M:0] u_i,                // input polynomial u(x)
    input [M:0] v_i,                // input polynomial v(x)
    input [D_WIDTH-1:0] d_i,        // input counter d
    output reg [M:0] r_o,           // output polynomial r(x)
    output reg [M:0] s_o,           // output polynomial s(x)
    output reg [M:0] u_o,           // output polynomial u(x)
    output reg [M:0] v_o,           // output polynomial v(x)
    output reg [D_WIDTH-1:0] d_o    // output counter d
);

// Local signals
reg [M:0] r1;
reg [M:0] s1;
reg [M:0] u1;
reg [M:0] v1;
reg [D_WIDTH-1:0] d1;


// Computation
always @ (*) begin
    if (r_i[M] == 1'b0) begin
        r1 = {r_i[M-1:0], 1'b0};
        u1 = {u_i[M-1:0], 1'b0};
        s1 = s_i;
        v1 = v_i;
        d1 = d_i + 1'b1;
    end
    else begin
        if (d_i == 1'b0) begin
            r1 = (s_i[M] == 1'b1) ? {s_i[M-1:0] ^ r_i[M-1:0], 1'b0} : {s_i[M-1:0], 1'b0};
            u1 = (s_i[M] == 1'b1) ? {v_i[M-1:0] ^ u_i[M-1:0], 1'b0} : {v_i[M-1:0], 1'b0};
            s1 = r_i;
            v1 = u_i;
            d1 = 1'b1;
        end
        else begin
            r1 = r_i;
            u1 = {1'b0, u_i[M:1]};
            s1 = (s_i[M] == 1'b1) ? {s_i[M-1:0] ^ r_i[M-1:0], 1'b0} : {s_i[M-1:0], 1'b0};
            v1 = (s_i[M] == 1'b1) ? v_i ^ u_i : v_i;
            d1 = d_i - 1'b1;
        end
    end
end

always @ (*) begin
    if (r1[M] == 1'b0) begin
        r_o = {r1[M-1:0], 1'b0};
        u_o = {u1[M-1:0], 1'b0};
        s_o = s1;
        v_o = v1;
        d_o = d1 + 1'b1;
    end
    else begin
        r_o = r1;
        u_o = {1'b0, u1[M:1]};
        s_o = (s1[M] == 1'b1) ? {s1[M-1:0] ^ r1[M-1:0], 1'b0} : {s1[M-1:0], 1'b0};
        v_o = (s1[M] == 1'b1) ? v1 ^ u1 : v1;
        d_o = d1 - 1'b1;
    end
end


endmodule
