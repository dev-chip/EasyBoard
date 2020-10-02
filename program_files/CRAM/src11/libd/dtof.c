/*	CONVERT DOUBLE TO STRING IN F-FORMAT
 *	Copyright (c) 1995 by COSMIC Software
 */
#include <float.h>

int _dtof(char *is, double *pd, int p, int g)
	{
	char *q, *s, *m;
	int exp;
	char keep;
	double d;
	char buf[DBL_DIG+2];

	s = is;
	d = *pd;
	if (d < 0)
		{
		d = -d;
		*s++ = '-';
		}
	m = &buf[DBL_DIG];
	exp = _norm(q = buf, &d, DBL_DIG + 1);
	keep = exp + g;
	if (keep > DBL_DIG)
		keep = DBL_DIG;
	exp += _round(q, DBL_DIG + 1, keep);
	if (exp > p)
		{
		q += exp - p;
		exp = p;
		}
	if (exp <= 0)
		*s++ = '0';
	else
		{
		keep = exp;
		do
			*s++ = (q < m) ? *q++ : '0';
		while (--keep);
		}
	keep = g;
	if (keep > 0)
		*s++ = '.';
	for (; exp < 0 && keep > 0; ++exp, --keep)
		*s++ = '0';
	for (; keep > 0; --keep)
		*s++ = (q < m) ? *q++ : '0';
	return (s - is);
	}
