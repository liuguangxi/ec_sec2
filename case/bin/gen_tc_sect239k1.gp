/*
 *==============================================================================
 * gen_tc_sect239k1.gp
 *
 * Generate test case for sect239k1.
 *------------------------------------------------------------------------------
 * Copyright (c) 2022 Guangxi Liu
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *==============================================================================
 */


/*
 * Hexadecimal to decimal converter
 */
Hex2Dec(data) = {
    my(v);
    v = Vec(Vecsmall(data));
    for (i = 1, #v,
        if (v[i] <= 57, v[i] -= 48, if (v[i] <= 70, v[i] -= 55, v[i] -= 87));
    );
    return(fromdigits(v, 16));
}


/*
 * Hexadecimal to F_{2^m} converter
 */
Hex2Ff(data, ffx) = {
    my(vb, len_vb, z);
    vb = binary(Hex2Dec(data));
    len_vb = #vb;
    z = 0*ffx + sum(i = 1, len_vb, vb[i] * ffx^(len_vb - i));
    return(z);
}


/*
 * F_{2^m} to decimal converter
 */
Ff2Dec(data) = {
    return(fromdigits(Vec(eval(Str(data))), 2));
}


/*
 * Elliptic curve domain parameters of sect239k1
 */
Sect239k1Param() = {
    my(m, ffx, a, b, ec, xg, yg, g, n);
    m = 239;
    ffx = ffgen((x^239 + x^158 + 1)*Mod(1, 2));
    a = Hex2Ff("000000000000000000000000000000000000000000000000000000000000", ffx);
    b = Hex2Ff("000000000000000000000000000000000000000000000000000000000001", ffx);
    ec = ellinit([ffx^0, a, 0*ffx, 0*ffx, b]);
    xg = Hex2Ff("29A0B6A887A983E9730988A68727A8B2D126C44CC2CC7B2A6555193035DC", ffx);
    yg = Hex2Ff("76310804F12E549BDB011C103089E73510ACB275FC312A5DC6B76553F0CA", ffx);
    g = [xg, yg];
    n = Hex2Dec("2000000000000000000000000000005A79FEC67CB6E91F1C1DA800E478A5");
    if (ellisoncurve(ec, g) != 1, error("Invalid parameters"));
    if (ellorder(ec, g) != n, error("Invalid parameters"));
    return([m, ffx, a, b, ec, g, n]);
}


/*
 * Print test case
 */
PrintTc(m, ec, g, d) = {
    my(xq, yq, str_fmt);
    [xq, yq] = ellmul(ec, g, d);
    str_fmt = strjoin(["%0", Str(ceil(m/4)), "x\n"]);
    printf(str_fmt, d);
    printf(str_fmt, Ff2Dec(xq));
    printf(str_fmt, Ff2Dec(yq));
    print();
}


/*
 * Generate test case of sect239k1
 */
{
setrand(42);

P239k1 = Sect239k1Param();
Ncase = 1000;
for (i = 1, 5,
    PrintTc(P239k1[1], P239k1[5], P239k1[6], i);
    PrintTc(P239k1[1], P239k1[5], P239k1[6], P239k1[7] - i);
);
for (i = 1, Ncase - 10,
    d = random(P239k1[7] - 1) + 1;    /* [1, n-1] */
    PrintTc(P239k1[1], P239k1[5], P239k1[6], d);
);

quit;
}
