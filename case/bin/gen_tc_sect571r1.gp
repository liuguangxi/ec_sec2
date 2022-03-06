/*
 *==============================================================================
 * gen_tc_sect571r1.gp
 *
 * Generate test case for sect571r1.
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
 * Elliptic curve domain parameters of sect571r1
 */
Sect571r1Param() = {
    my(m, ffx, a, b, ec, xg, yg, g, n);
    m = 571;
    ffx = ffgen((x^571 + x^10 + x^5 + x^2 + 1)*Mod(1, 2));
    a = Hex2Ff("000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001", ffx);
    b = Hex2Ff("02F40E7E2221F295DE297117B7F3D62F5C6A97FFCB8CEFF1CD6BA8CE4A9A18AD84FFABBD8EFA59332BE7AD6756A66E294AFD185A78FF12AA520E4DE739BACA0C7FFEFF7F2955727A", ffx);
    ec = ellinit([ffx^0, a, 0*ffx, 0*ffx, b]);
    xg = Hex2Ff("0303001D34B856296C16C0D40D3CD7750A93D1D2955FA80AA5F40FC8DB7B2ABDBDE53950F4C0D293CDD711A35B67FB1499AE60038614F1394ABFA3B4C850D927E1E7769C8EEC2D19", ffx);
    yg = Hex2Ff("037BF27342DA639B6DCCFFFEB73D69D78C6C27A6009CBBCA1980F8533921E8A684423E43BAB08A576291AF8F461BB2A8B3531D2F0485C19B16E2F1516E23DD3C1A4827AF1B8AC15B", ffx);
    g = [xg, yg];
    n = Hex2Dec("03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE661CE18FF55987308059B186823851EC7DD9CA1161DE93D5174D66E8382E9BB2FE84E47");
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
 * Generate test case of sect571r1
 */
{
setrand(42);

P571r1 = Sect571r1Param();
Ncase = 1000;
for (i = 1, 5,
    PrintTc(P571r1[1], P571r1[5], P571r1[6], i);
    PrintTc(P571r1[1], P571r1[5], P571r1[6], P571r1[7] - i);
);
for (i = 1, Ncase - 10,
    d = random(P571r1[7] - 1) + 1;    /* [1, n-1] */
    PrintTc(P571r1[1], P571r1[5], P571r1[6], d);
);

quit;
}
