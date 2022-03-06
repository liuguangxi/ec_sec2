/*
 *==============================================================================
 * gen_tc_sect409k1.gp
 *
 * Generate test case for sect409k1.
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
 * Elliptic curve domain parameters of sect409k1
 */
Sect409k1Param() = {
    my(m, ffx, a, b, ec, xg, yg, g, n);
    m = 409;
    ffx = ffgen((x^409 + x^87 + 1)*Mod(1, 2));
    a = Hex2Ff("00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", ffx);
    b = Hex2Ff("00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001", ffx);
    ec = ellinit([ffx^0, a, 0*ffx, 0*ffx, b]);
    xg = Hex2Ff("0060F05F658F49C1AD3AB1890F7184210EFD0987E307C84C27ACCFB8F9F67CC2C460189EB5AAAA62EE222EB1B35540CFE9023746", ffx);
    yg = Hex2Ff("01E369050B7C4E42ACBA1DACBF04299C3460782F918EA427E6325165E9EA10E3DA5F6C42E9C55215AA9CA27A5863EC48D8E0286B", ffx);
    g = [xg, yg];
    n = Hex2Dec("7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5F83B2D4EA20400EC4557D5ED3E3E7CA5B4B5C83B8E01E5FCF");
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
 * Generate test case of sect409k1
 */
{
setrand(42);

P409k1 = Sect409k1Param();
Ncase = 1000;
for (i = 1, 5,
    PrintTc(P409k1[1], P409k1[5], P409k1[6], i);
    PrintTc(P409k1[1], P409k1[5], P409k1[6], P409k1[7] - i);
);
for (i = 1, Ncase - 10,
    d = random(P409k1[7] - 1) + 1;    /* [1, n-1] */
    PrintTc(P409k1[1], P409k1[5], P409k1[6], d);
);

quit;
}
