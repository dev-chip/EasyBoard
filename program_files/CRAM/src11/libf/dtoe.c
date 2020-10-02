/*	CONVERT DOUBLE TO STRING IN E-FORMAT
 *	Copyright (c) 1995 by COSMIC Software
 */
#include <float.h>

int _dtoe(char *is, double *pd, int p, int g)
	{
	int i, j;
	char *s;
	int exp, rnd;
	union {
		double d;
		struct {
			unsigned int n;
			unsigned int dv;
			unsigned int rem;
			} v;
		} u;
	char buf[FLT_DIG+2];

	s = is;
	u.d = *pd;
	if (u.d < 0)
		{
		u.d = -u.d;
		*s++ = '-';
		}
	rnd = p + g;
	if (rnd > FLT_DIG)
		rnd = FLT_DIG;
	exp = _norm(buf, &u.d, rnd + 1);
	exp += _round(buf, rnd + 1, rnd);
	for (i = 0; i < rnd && i < p; ++i, --exp)
		*s++ = buf[i];
	for (; i < p; ++i, --exp)
		*s++ = '0';
	if (0 < g)
		{
		*s++ = '.';
		for (j = 0; j < g && i < rnd; ++i, ++j)
			*s++ = buf[i];
		for (; j < g; ++j)
			*s++ = '0';
		}
	*s++ = 'e';
	if (!u.d)
		exp = 0;
	if (exp < 0)
		{
		exp = -exp;
		*s++ = '-';
		}
	else
		*s++ = '+';
	u.v.n = exp;
	u.v.dv = 10;
	_udiv(&u.v);
	i = u.v.rem;
	if (exp >= 100)
		{
		_udiv(&u.v);
		*s++ = u.v.n + '0';
		j = u.v.rem;
		}
	else
		j = u.v.n;
	*s++ = j + '0';
	*s++ = i + '0';
	return (s - is);
	}
