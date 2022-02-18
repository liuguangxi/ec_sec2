/*
 *==============================================================================
 * f2m_inv.gp
 *
 * Inversion over F_{2^m}.
 *------------------------------------------------------------------------------
 * Copyright (c) 2022 Guangxi Liu
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *==============================================================================
 */


/*
 * a(x)^(-1) mod f(x), a(x) != 0, reference implementation
 */
F2mInvRef(m, fx, ax) = {
    return(1 / ax % fx);
}


/*
 * a(x)^(-1) mod f(x), a(x) != 0, hardware implementation
 */
LShift(m, ax) = (ax + polcoef(ax, m) * x^m) * x;

RShift(ax) = (ax + polcoef(ax, 0)) / x;

F2mInvHw(m, fx, ax) = {
    my(sx, rx, ux, vx, d, rx_old, ux_old, zx);

    sx = fx; rx = ax;
    ux = Mod(1, 2); vx = Mod(0, 2);
    d = 0;
    for (i = 1, 2 * m,
        if (lift(polcoef(rx, m)) == 0,
            rx = LShift(m, rx);
            ux = LShift(m, ux);
            d++;
            ,
            rx_old = rx; ux_old = ux;
            if (d == 0,
                if (lift(polcoef(sx, m)) == 1,
                    rx = LShift(m, sx + rx);
                    ux = LShift(m, vx + ux);
                    ,
                    rx = LShift(m, sx);
                    ux = LShift(m, vx);
                );
                sx = rx_old; vx = ux_old;
                d = 1;
                ,
                ux = RShift(ux);
                if (lift(polcoef(sx, m)) == 1,
                    sx = LShift(m, sx + rx);
                    vx = vx + ux_old;
                    ,
                    sx = LShift(m, sx);
                );
                d--;
            );
        );
    );
    zx = ux + polcoef(ux, m) * x^m;
    return(zx);
}


/*
 * Examples
 */
{
M = 163;
Fx = Mod(x^163 + x^7 + x^6 + x^3 + 1, 2);

a = random(2^M - 1) + 1;    /* a != 0 */
ax = Mod(Pol(binary(a)), 2);

zx_ref = F2mInvRef(M, Fx, ax);
zx_hw = F2mInvHw(M, Fx, ax);

if (zx_ref == zx_hw, print("OK"), print("ERROR"));
printf("a(x) = %x\n", fromdigits(lift(Vec(ax)), 2));
printf("z(x) = %x\n", fromdigits(lift(Vec(zx_ref)), 2));
}
