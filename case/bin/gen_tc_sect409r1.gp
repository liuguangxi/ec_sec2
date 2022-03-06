/*
 *==============================================================================
 * gen_tc_sect409r1.gp
 *
 * Generate test case for sect409r1.
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
 * Elliptic curve domain parameters of sect409r1
 */
Sect409r1Param() = {
    my(m, ffx, a, b, ec, xg, yg, g, n);
    m = 409;
    ffx = ffgen((x^409 + x^87 + 1)*Mod(1, 2));
    a = Hex2Ff("00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001", ffx);
    b = Hex2Ff("0021A5C2C8EE9FEB5C4B9A753B7B476B7FD6422EF1F3DD674761FA99D6AC27C8A9A197B272822F6CD57A55AA4F50AE317B13545F", ffx);
    ec = ellinit([ffx^0, a, 0*ffx, 0*ffx, b]);
    xg = Hex2Ff("015D4860D088DDB3496B0C6064756260441CDE4AF1771D4DB01FFE5B34E59703DC255A868A1180515603AEAB60794E54BB7996A7", ffx);
    yg = Hex2Ff("0061B1CFAB6BE5F32BBFA78324ED106A7636B9C5A7BD198D0158AA4F5488D08F38514F1FDF4B4F40D2181B3681C364BA0273C706", ffx);
    g = [xg, yg];
    n = Hex2Dec("010000000000000000000000000000000000000000000000000001E2AAD6A612F33307BE5FA47C3C9E052F838164CD37D9A21173");
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
 * Generate test case of sect409r1
 */
{
setrand(42);

P409r1 = Sect409r1Param();
Ncase = 1000;
for (i = 1, 5,
    PrintTc(P409r1[1], P409r1[5], P409r1[6], i);
    PrintTc(P409r1[1], P409r1[5], P409r1[6], P409r1[7] - i);
);
for (i = 1, Ncase - 10,
    d = random(P409r1[7] - 1) + 1;    /* [1, n-1] */
    PrintTc(P409r1[1], P409r1[5], P409r1[6], d);
);

quit;
}
