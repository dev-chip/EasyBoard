/*	OBTAIN HIGH PRECISION MODULUS
 *	Copyright (c) 1995 by COSMIC Software
 */
int _fmod(double *pd, double div)
	{
	extern double _addexp(double, int);
	char neg;
	int dchar, i, n, nchar;
	double t;

	if (div < 0)
		div = -div;
	else if (div == 0)
		return (0);
	neg = 0;
	if (*pd < 0)
		{
		*pd = -*pd;
		++neg;
		}
	t = div;
	dchar = _unpack(&t);
	n = 0;
	for (;;)
		{
		if (*pd == 0)
			return (neg ? -n : n);
		t = *pd;
		nchar = _unpack(&t);
		for (i = nchar - dchar; ; --i)
			if (i < 0)
				{
				t = _addexp(div, -1);	/* right underflow */
				if (t < *pd)
					{
					*pd -= div;
					++n;
					}
				if (neg)
					{
					n = -n;
					*pd = -*pd;
					}
				return (n);
				}
			else
				{
				t = _addexp(div, i);
				if (t <= *pd)
					{
					*pd -= t;
					if (i < 16)
						n |= (1 << i);
					break;
					}
				}
		}
	}
