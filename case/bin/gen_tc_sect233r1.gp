/*
 *==============================================================================
 * gen_tc_sect233r1.gp
 *
 * Generate test case for sect233r1.
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
 * Elliptic curve domain parameters of sect233r1
 */
Sect233r1Param() = {
    my(m, ffx, a, b, ec, xg, yg, g, n);
    m = 233;
    ffx = ffgen((x^233 + x^74 + 1)*Mod(1, 2));
    a = Hex2Ff("000000000000000000000000000000000000000000000000000000000001", ffx);
    b = Hex2Ff("0066647EDE6C332C7F8C0923BB58213B333B20E9CE4281FE115F7D8F90AD", ffx);
    ec = ellinit([ffx^0, a, 0*ffx, 0*ffx, b]);
    xg = Hex2Ff("00FAC9DFCBAC8313BB2139F1BB755FEF65BC391F8B36F8F8EB7371FD558B", ffx);
    yg = Hex2Ff("01006A08A41903350678E58528BEBF8A0BEFF867A7CA36716F7E01F81052", ffx);
    g = [xg, yg];
    n = Hex2Dec("01000000000000000000000000000013E974E72F8A6922031D2603CFE0D7");
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
 * Generate test case of sect233r1
 */
{
setrand(42);

P233r1 = Sect233r1Param();
Ncase = 1000;
for (i = 1, 5,
    PrintTc(P233r1[1], P233r1[5], P233r1[6], i);
    PrintTc(P233r1[1], P233r1[5], P233r1[6], P233r1[7] - i);
);
for (i = 1, Ncase - 10,
    d = random(P233r1[7] - 1) + 1;    /* [1, n-1] */
    PrintTc(P233r1[1], P233r1[5], P233r1[6], d);
);

quit;
}
