//==============================================================================
// f2m_sqr.v
//
// Squaring over F_{2^m}.
//------------------------------------------------------------------------------
// Copyright (c) 2022 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module f2m_sqr #(
    parameter M = 163,              // degree of f(x)
    parameter FX = 163'hc9          // binary representation of f(x)
)
(
    // Data interface
    input [M-1:0] a,                // input polynomial a(x)
    output reg [M-1:0] z            // output a(x)^2 mod f(x)
);

// Local signals
wire [M-1:0] xpow [M-2:0];          // xpow(i) = x^(M+i) mod f(x), i = 0,...,M-2
genvar i;
reg [2*M-2:0] a_sqr;
integer j1, j2;


// Parameter xpow computation
generate
    assign xpow[0] = FX;
    for (i = 1; i <= M-2; i = i + 1) begin : gen_xpow
        assign xpow[i] = {xpow[i-1][M-2:0], 1'b0} ^ (FX & {M{xpow[i-1][M-1]}});
    end
endgenerate


// Squaring computation
always @ (*) begin
    a_sqr = 1'b0;
    for (j1 = 0; j1 <= M-1; j1 = j1 + 1) begin
        a_sqr[2 * j1] = a[j1];
    end
end

always @ (*) begin
    z = a_sqr[M-1:0];
    for (j2 = M; j2 <= 2*M-2; j2 = j2 + 1) begin
        if (j2 % 2 == 0)
            z = z ^ (xpow[j2 - M] & {M{a_sqr[j2]}});
    end
end


endmodule
