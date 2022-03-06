/*
 *==============================================================================
 * gen_tc_sect571k1.gp
 *
 * Generate test case for sect571k1.
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
 * Elliptic curve domain parameters of sect571k1
 */
Sect571k1Param() = {
    my(m, ffx, a, b, ec, xg, yg, g, n);
    m = 571;
    ffx = ffgen((x^571 + x^10 + x^5 + x^2 + 1)*Mod(1, 2));
    a = Hex2Ff("000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", ffx);
    b = Hex2Ff("000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001", ffx);
    ec = ellinit([ffx^0, a, 0*ffx, 0*ffx, b]);
    xg = Hex2Ff("026EB7A859923FBC82189631F8103FE4AC9CA2970012D5D46024804801841CA44370958493B205E647DA304DB4CEB08CBBD1BA39494776FB988B47174DCA88C7E2945283A01C8972", ffx);
    yg = Hex2Ff("0349DC807F4FBF374F4AEADE3BCA95314DD58CEC9F307A54FFC61EFC006D8A2C9D4979C0AC44AEA74FBEBBB9F772AEDCB620B01A7BA7AF1B320430C8591984F601CD4C143EF1C7A3", ffx);
    g = [xg, yg];
    n = Hex2Dec("020000000000000000000000000000000000000000000000000000000000000000000000131850E1F19A63E4B391A8DB917F4138B630D84BE5D639381E91DEB45CFE778F637C1001");
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
 * Generate test case of sect571k1
 */
{
setrand(42);

P571k1 = Sect571k1Param();
Ncase = 1000;
for (i = 1, 5,
    PrintTc(P571k1[1], P571k1[5], P571k1[6], i);
    PrintTc(P571k1[1], P571k1[5], P571k1[6], P571k1[7] - i);
);
for (i = 1, Ncase - 10,
    d = random(P571k1[7] - 1) + 1;    /* [1, n-1] */
    PrintTc(P571k1[1], P571k1[5], P571k1[6], d);
);

quit;
}
