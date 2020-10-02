/*	CONVERT DOUBLE TO FRACTION AND RETURN EXPONENT
 *	Copyright (c) 1995 by COSMIC Software
 */
#define ND	(sizeof(int) == 2 ? 4 : 8)
#define IX	(sizeof(int) == 2 ? 3 : 4)

int _norm(char *s, double *pd, int p)
	{
	extern double _dtens[], _dtento();
	int exp, dig, i;
	char j;
	double nd, d;
	union {
		double nd;
		struct {
			unsigned int n;
			unsigned int dv;
			unsigned int rem;
			} v;
		} u;
	char buf[ND];

	exp = 0;
	i = 0;
	if (d = *pd)
		{
		if (d < 0)
			d = -d;
		if (d < _dtens[0] || d > _dtens[IX])
			{
			u.nd = d;
			exp = ((_unpack(&u.nd) * 30103L) / 100000L);
			d = _dtento(&d, -exp);
			}
		exp += ND;
		u.v.dv = 10;
		for (; i < p && d; )	/* 1 <~ d && d <~ 10**ND */
			{
			dig = d;
			u.v.n = dig;
			j = ND - 1;
			do	{
				_udiv(&u.v);
				buf[j] = u.v.rem;
				}
			while ((signed char)(--j) >= 0);
			if (u.v.n)
				{
				*s++ = u.v.n + '0';
				++i;
				++exp;
				}
			for (j = 0; i < p && j < ND; ++j)
				if (i == 0 && buf[j] == 0)
					--exp;
				else
					{
					*s++ = buf[j] + '0';
					++i;
					}
			if (i < p)
				d = (d - dig) * _dtens[IX];
			}
		}
	for (; i < p; ++i)
		*s++ = '0';
	return (exp);
	}
