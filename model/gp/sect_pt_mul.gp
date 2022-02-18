/*
 *==============================================================================
 * sect_pt_mul.gp
 *
 * Elliptic curve point multiplication of SEC 2 F_{2^m} series.
 *
 * T = (m, f(x), a, b, G, n, h)
 * E : y^2 + x*y = x^3 + a*x^2 + b in F_{2^m}
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
 * Elliptic curve domain parameters of sect163k1
 */
Sect163k1Param() = {
    my(m, ffx, a, b, ec, xg, yg, g, n);
    m = 163;
    ffx = ffgen((x^163 + x^7 + x^6 + x^3 + 1)*Mod(1, 2));
    a = Hex2Ff("000000000000000000000000000000000000000001", ffx);
    b = Hex2Ff("000000000000000000000000000000000000000001", ffx);
    ec = ellinit([ffx^0, a, 0*ffx, 0*ffx, b]);
    xg = Hex2Ff("02FE13C0537BBC11ACAA07D793DE4E6D5E5C94EEE8", ffx);
    yg = Hex2Ff("0289070FB05D38FF58321F2E800536D538CCDAA3D9", ffx);
    g = [xg, yg];
    n = Hex2Dec("04000000000000000000020108A2E0CC0D99F8A5EF");
    if (ellisoncurve(ec, g) != 1, error("Invalid parameters"));
    if (ellorder(ec, g) != n, error("Invalid parameters"));
    return([m, ffx, a, b, ec, g, n]);
}


/*
 * Elliptic curve domain parameters of sect163r1
 */
Sect163r1Param() = {
    my(m, ffx, a, b, ec, xg, yg, g, n);
    m = 163;
    ffx = ffgen((x^163 + x^7 + x^6 + x^3 + 1)*Mod(1, 2));
    a = Hex2Ff("07B6882CAAEFA84F9554FF8428BD88E246D2782AE2", ffx);
    b = Hex2Ff("0713612DCDDCB40AAB946BDA29CA91F73AF958AFD9", ffx);
    ec = ellinit([ffx^0, a, 0*ffx, 0*ffx, b]);
    xg = Hex2Ff("0369979697AB43897789566789567F787A7876A654", ffx);
    yg = Hex2Ff("00435EDB42EFAFB2989D51FEFCE3C80988F41FF883", ffx);
    g = [xg, yg];
    n = Hex2Dec("03FFFFFFFFFFFFFFFFFFFF48AAB689C29CA710279B");
    if (ellisoncurve(ec, g) != 1, error("Invalid parameters"));
    if (ellorder(ec, g) != n, error("Invalid parameters"));
    return([m, ffx, a, b, ec, g, n]);
}


/*
 * Elliptic curve domain parameters of sect163r2
 */
Sect163r2Param() = {
    my(m, ffx, a, b, ec, xg, yg, g, n);
    m = 163;
    ffx = ffgen((x^163 + x^7 + x^6 + x^3 + 1)*Mod(1, 2));
    a = Hex2Ff("000000000000000000000000000000000000000001", ffx);
    b = Hex2Ff("020A601907B8C953CA1481EB10512F78744A3205FD", ffx);
    ec = ellinit([ffx^0, a, 0*ffx, 0*ffx, b]);
    xg = Hex2Ff("03F0EBA16286A2D57EA0991168D4994637E8343E36", ffx);
    yg = Hex2Ff("00D51FBC6C71A0094FA2CDD545B11C5C0C797324F1", ffx);
    g = [xg, yg];
    n = Hex2Dec("040000000000000000000292FE77E70C12A4234C33");
    if (ellisoncurve(ec, g) != 1, error("Invalid parameters"));
    if (ellorder(ec, g) != n, error("Invalid parameters"));
    return([m, ffx, a, b, ec, g, n]);
}


/*
 * Elliptic curve domain parameters of sect233k1
 */
Sect233k1Param() = {
    my(m, ffx, a, b, ec, xg, yg, g, n);
    m = 233;
    ffx = ffgen((x^233 + x^74 + 1)*Mod(1, 2));
    a = Hex2Ff("000000000000000000000000000000000000000000000000000000000000", ffx);
    b = Hex2Ff("000000000000000000000000000000000000000000000000000000000001", ffx);
    ec = ellinit([ffx^0, a, 0*ffx, 0*ffx, b]);
    xg = Hex2Ff("017232BA853A7E731AF129F22FF4149563A419C26BF50A4C9D6EEFAD6126", ffx);
    yg = Hex2Ff("01DB537DECE819B7F70F555A67C427A8CD9BF18AEB9B56E0C11056FAE6A3", ffx);
    g = [xg, yg];
    n = Hex2Dec("8000000000000000000000000000069D5BB915BCD46EFB1AD5F173ABDF");
    if (ellisoncurve(ec, g) != 1, error("Invalid parameters"));
    if (ellorder(ec, g) != n, error("Invalid parameters"));
    return([m, ffx, a, b, ec, g, n]);
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
 * Elliptic curve domain parameters of sect283r1
 */
Sect283r1Param() = {
    my(m, ffx, a, b, ec, xg, yg, g, n);
    m = 283;
    ffx = ffgen((x^283 + x^12 + x^7 + x^5 + 1)*Mod(1, 2));
    a = Hex2Ff("000000000000000000000000000000000000000000000000000000000000000000000001", ffx);
    b = Hex2Ff("027B680AC8B8596DA5A4AF8A19A0303FCA97FD7645309FA2A581485AF6263E313B79A2F5", ffx);
    ec = ellinit([ffx^0, a, 0*ffx, 0*ffx, b]);
    xg = Hex2Ff("05F939258DB7DD90E1934F8C70B0DFEC2EED25B8557EAC9C80E2E198F8CDBECD86B12053", ffx);
    yg = Hex2Ff("03676854FE24141CB98FE6D4B20D02B4516FF702350EDDB0826779C813F0DF45BE8112F4", ffx);
    g = [xg, yg];
    n = Hex2Dec("03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEF90399660FC938A90165B042A7CEFADB307");
    if (ellisoncurve(ec, g) != 1, error("Invalid parameters"));
    if (ellorder(ec, g) != n, error("Invalid parameters"));
    return([m, ffx, a, b, ec, g, n]);
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
 * Q = d * G in elliptic curve E(F_{2^m}), hardware implementation
 */
EllMulHw(m, ffx, b, g, d) = {
    my(xg, yg, vd, xa, za, xb, zb, t1, t2);

    xg = g[1]; yg = g[2];
    vd = vector(m);
    for (i = 1, m, vd[i] = d % 2; d \= 2);
    xa = ffx^0; za = 0*ffx;
    xb = xg; zb = ffx^0;
    for (i = 1, m,
        t1 = xa * zb;
        t2 = xb * za;
        if (vd[m - i + 1] == 0,
            zb = (t1 + t2)^2;
            xb = xg * zb + t1 * t2;
            t1 = xa * za;
            xa = xa^4 + b * za^4;
            za = t1^2;
            ,
            za = (t1 + t2)^2;
            xa = xg * za + t1 * t2;
            t1 = xb * zb;
            xb = xb^4 + b * zb^4;
            zb = t1^2;
        );
    );
    if (zb == 0,
        /* Only when d = n - 1 */
        xa = xg;
        za = xg + yg;
        ,
        t1 = za * zb;
        t2 = t1^(-1);
        xa = xa * zb * t2;
        xb = xb * za * t2;
        za = (xa + xg) * (xb + xg) + xg^2 + yg;
        za = za * (xa + xg);
        za = za * xg^(-1) + yg;
    );
    return([xa, za]);
}


/*
 * Examples of sect163k1
 */
{
P163k1 = Sect163k1Param();
d = random(P163k1[7] - 1) + 1;    /* [1, n-1] */

[xq_ref, yq_ref] = ellmul(P163k1[5], P163k1[6], d);
[xq_hw, yq_hw] = EllMulHw(P163k1[1], P163k1[2], P163k1[4], P163k1[6], d);

if (xq_ref == xq_hw && yq_ref == yq_hw, print("OK"), print("ERROR"));
printf("d = %x\n", d);
printf("x = %x\n", Ff2Dec(xq_ref));
printf("y = %x\n", Ff2Dec(yq_ref));
}


/*
 * Examples of sect163r1
 */
{
P163r1 = Sect163r1Param();
d = random(P163r1[7] - 1) + 1;    /* [1, n-1] */

[xq_ref, yq_ref] = ellmul(P163r1[5], P163r1[6], d);
[xq_hw, yq_hw] = EllMulHw(P163r1[1], P163r1[2], P163r1[4], P163r1[6], d);

if (xq_ref == xq_hw && yq_ref == yq_hw, print("OK"), print("ERROR"));
printf("d = %x\n", d);
printf("x = %x\n", Ff2Dec(xq_ref));
printf("y = %x\n", Ff2Dec(yq_ref));
}


/*
 * Examples of sect163r2
 */
{
P163r2 = Sect163r2Param();
d = random(P163r2[7] - 1) + 1;    /* [1, n-1] */

[xq_ref, yq_ref] = ellmul(P163r2[5], P163r2[6], d);
[xq_hw, yq_hw] = EllMulHw(P163r2[1], P163r2[2], P163r2[4], P163r2[6], d);

if (xq_ref == xq_hw && yq_ref == yq_hw, print("OK"), print("ERROR"));
printf("d = %x\n", d);
printf("x = %x\n", Ff2Dec(xq_ref));
printf("y = %x\n", Ff2Dec(yq_ref));
}


/*
 * Examples of sect233k1
 */
{
P233k1 = Sect233k1Param();
d = random(P233k1[7] - 1) + 1;    /* [1, n-1] */

[xq_ref, yq_ref] = ellmul(P233k1[5], P233k1[6], d);
[xq_hw, yq_hw] = EllMulHw(P233k1[1], P233k1[2], P233k1[4], P233k1[6], d);

if (xq_ref == xq_hw && yq_ref == yq_hw, print("OK"), print("ERROR"));
printf("d = %x\n", d);
printf("x = %x\n", Ff2Dec(xq_ref));
printf("y = %x\n", Ff2Dec(yq_ref));
}


/*
 * Examples of sect233r1
 */
{
P233r1 = Sect233r1Param();
d = random(P233r1[7] - 1) + 1;    /* [1, n-1] */

[xq_ref, yq_ref] = ellmul(P233r1[5], P233r1[6], d);
[xq_hw, yq_hw] = EllMulHw(P233r1[1], P233r1[2], P233r1[4], P233r1[6], d);

if (xq_ref == xq_hw && yq_ref == yq_hw, print("OK"), print("ERROR"));
printf("d = %x\n", d);
printf("x = %x\n", Ff2Dec(xq_ref));
printf("y = %x\n", Ff2Dec(yq_ref));
}


/*
 * Examples of sect239k1
 */
{
P239k1 = Sect239k1Param();
d = random(P239k1[7] - 1) + 1;    /* [1, n-1] */

[xq_ref, yq_ref] = ellmul(P239k1[5], P239k1[6], d);
[xq_hw, yq_hw] = EllMulHw(P239k1[1], P239k1[2], P239k1[4], P239k1[6], d);

if (xq_ref == xq_hw && yq_ref == yq_hw, print("OK"), print("ERROR"));
printf("d = %x\n", d);
printf("x = %x\n", Ff2Dec(xq_ref));
printf("y = %x\n", Ff2Dec(yq_ref));
}


/*
 * Examples of sect283k1
 */
{
P283k1 = Sect283k1Param();
d = random(P283k1[7] - 1) + 1;    /* [1, n-1] */

[xq_ref, yq_ref] = ellmul(P283k1[5], P283k1[6], d);
[xq_hw, yq_hw] = EllMulHw(P283k1[1], P283k1[2], P283k1[4], P283k1[6], d);

if (xq_ref == xq_hw && yq_ref == yq_hw, print("OK"), print("ERROR"));
printf("d = %x\n", d);
printf("x = %x\n", Ff2Dec(xq_ref));
printf("y = %x\n", Ff2Dec(yq_ref));
}


/*
 * Examples of sect283r1
 */
{
P283r1 = Sect283r1Param();
d = random(P283r1[7] - 1) + 1;    /* [1, n-1] */

[xq_ref, yq_ref] = ellmul(P283r1[5], P283r1[6], d);
[xq_hw, yq_hw] = EllMulHw(P283r1[1], P283r1[2], P283r1[4], P283r1[6], d);

if (xq_ref == xq_hw && yq_ref == yq_hw, print("OK"), print("ERROR"));
printf("d = %x\n", d);
printf("x = %x\n", Ff2Dec(xq_ref));
printf("y = %x\n", Ff2Dec(yq_ref));
}


/*
 * Examples of sect409k1
 */
{
P409k1 = Sect409k1Param();
d = random(P409k1[7] - 1) + 1;    /* [1, n-1] */

[xq_ref, yq_ref] = ellmul(P409k1[5], P409k1[6], d);
[xq_hw, yq_hw] = EllMulHw(P409k1[1], P409k1[2], P409k1[4], P409k1[6], d);

if (xq_ref == xq_hw && yq_ref == yq_hw, print("OK"), print("ERROR"));
printf("d = %x\n", d);
printf("x = %x\n", Ff2Dec(xq_ref));
printf("y = %x\n", Ff2Dec(yq_ref));
}


/*
 * Examples of sect409r1
 */
{
P409r1 = Sect409r1Param();
d = random(P409r1[7] - 1) + 1;    /* [1, n-1] */

[xq_ref, yq_ref] = ellmul(P409r1[5], P409r1[6], d);
[xq_hw, yq_hw] = EllMulHw(P409r1[1], P409r1[2], P409r1[4], P409r1[6], d);

if (xq_ref == xq_hw && yq_ref == yq_hw, print("OK"), print("ERROR"));
printf("d = %x\n", d);
printf("x = %x\n", Ff2Dec(xq_ref));
printf("y = %x\n", Ff2Dec(yq_ref));
}


/*
 * Examples of sect571k1
 */
{
P571k1 = Sect571k1Param();
d = random(P571k1[7] - 1) + 1;    /* [1, n-1] */

[xq_ref, yq_ref] = ellmul(P571k1[5], P571k1[6], d);
[xq_hw, yq_hw] = EllMulHw(P571k1[1], P571k1[2], P571k1[4], P571k1[6], d);

if (xq_ref == xq_hw && yq_ref == yq_hw, print("OK"), print("ERROR"));
printf("d = %x\n", d);
printf("x = %x\n", Ff2Dec(xq_ref));
printf("y = %x\n", Ff2Dec(yq_ref));
}


/*
 * Examples of sect571r1
 */
{
P571r1 = Sect571r1Param();
d = random(P571r1[7] - 1) + 1;    /* [1, n-1] */

[xq_ref, yq_ref] = ellmul(P571r1[5], P571r1[6], d);
[xq_hw, yq_hw] = EllMulHw(P571r1[1], P571r1[2], P571r1[4], P571r1[6], d);

if (xq_ref == xq_hw && yq_ref == yq_hw, print("OK"), print("ERROR"));
printf("d = %x\n", d);
printf("x = %x\n", Ff2Dec(xq_ref));
printf("y = %x\n", Ff2Dec(yq_ref));
}
