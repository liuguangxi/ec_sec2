/*
 *==============================================================================
 * gen_tc_sect283k1.gp
 *
 * Generate test case for sect283k1.
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
 * Elliptic curve domain parameters of sect283k1
 */
Sect283k1Param() = {
    my(m, ffx, a, b, ec, xg, yg, g, n);
    m = 283;
    ffx = ffgen((x^283 + x^12 + x^7 + x^5 + 1)*Mod(1, 2));
    a = Hex2Ff("000000000000000000000000000000000000000000000000000000000000000000000000", ffx);
    b = Hex2Ff("000000000000000000000000000000000000000000000000000000000000000000000001", ffx);
    ec = ellinit([ffx^0, a, 0*ffx, 0*ffx, b]);
    xg = Hex2Ff("0503213F78CA44883F1A3B8162F188E553CD265F23C1567A16876913B0C2AC2458492836", ffx);
    yg = Hex2Ff("01CCDA380F1C9E318D90F95D07E5426FE87E45C0E8184698E45962364E34116177DD2259", ffx);
    g = [xg, yg];
    n = Hex2Dec("01FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9AE2ED07577265DFF7F94451E061E163C61");
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
 * Generate test case of sect283k1
 */
{
setrand(42);

P283k1 = Sect283k1Param();
Ncase = 1000;
for (i = 1, 5,
    PrintTc(P283k1[1], P283k1[5], P283k1[6], i);
    PrintTc(P283k1[1], P283k1[5], P283k1[6], P283k1[7] - i);
);
for (i = 1, Ncase - 10,
    d = random(P283k1[7] - 1) + 1;    /* [1, n-1] */
    PrintTc(P283k1[1], P283k1[5], P283k1[6], d);
);

quit;
}
