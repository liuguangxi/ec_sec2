/*
 *==============================================================================
 * f2m_mul.gp
 *
 * Multiplication over F_{2^m}.
 *------------------------------------------------------------------------------
 * Copyright (c) 2022 Guangxi Liu
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *==============================================================================
 */


/*
 * a(x) * b(x) mod f(x), reference implementation
 */
F2mMulRef(m, fx, ax, bx) = {
    return(ax * bx % fx);
}


/*
 * a(x) * b(x) mod f(x), hardware implementation
 * 1 <= num_seg <= m
 */
F2mMulHw(m, fx, ax, bx, num_seg) = {
    my(seg_bits, tot_bits, rx, zx, brx, bix);
    if (num_seg < 1 || num_seg > m, error("num_seg out of range"));

    seg_bits = ceil(m / num_seg);
    tot_bits = seg_bits * num_seg;
    rx = Mod(x^seg_bits, 2);
    zx = Mod(0, 2);
    brx = bx;
    for (i = 1, num_seg,
        bix = brx \ x^(tot_bits - seg_bits);
        zx = (zx * rx + ax * bix) % fx;
        brx = (brx + bix * x^(tot_bits - seg_bits)) * x^seg_bits;
    );
    return(zx);
}


/*
 * Examples
 */
{
M = 163;
Fx = Mod(x^163 + x^7 + x^6 + x^3 + 1, 2);

a = random(2^M);
b = random(2^M);
ax = Mod(Pol(binary(a)), 2);
bx = Mod(Pol(binary(b)), 2);

zx_ref = F2mMulRef(M, Fx, ax, bx);
zx_hw = F2mMulHw(M, Fx, ax, bx, 3);

if (zx_ref == zx_hw, print("OK"), print("ERROR"));
printf("a(x) = %x\n", fromdigits(lift(Vec(ax)), 2));
printf("b(x) = %x\n", fromdigits(lift(Vec(bx)), 2));
printf("z(x) = %x\n", fromdigits(lift(Vec(zx_ref)), 2));
}
