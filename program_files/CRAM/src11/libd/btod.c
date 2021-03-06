/*	BUFFER TO DOUBLE CONVERSION
 *	Copyright (c) 1995 by COSMIC Software
 */
#include <ctype.h>
#include <float.h>

#define ND	(sizeof(int) == 2 ? 4 : 8)
#define IX	(sizeof(int) == 2 ? 3 : 4)

int _btod(char *is, int n, double *pdnum)
	{
	extern int _ntens;
	extern double _dtens[], _dtento(), _addexp();
	char *s, eminus, minus;
	int exp, ne, nx, x;
	double d;

	s = is;
	minus = 0;
	while (0 < n && isspace(*s))
		++s, --n;
	if (n == 0)
		;
	else if (*s == '+')
		++s, --n;
	else if (*s == '-')
		{
		++s, --n;
		++minus;
		}
	d = 0;
	exp = 0;
	ne = 0;
	for (x = 0, nx = 0; 0 < n && isdigit(*s); ++s, --n)
		if (ne == 0 && *s == '0')
			;
		else if (ne < DBL_DIG)
			{
			++ne;
			if (nx == ND)
				{
				d = d * _dtens[IX] + x;
				x = 0, nx = 0;
				}
			x = x * 10 + *s - '0';
			++nx;
			}
		else
			++exp;
	if (0 < n && *s == '.')
		for (++s, --n; 0 < n && isdigit(*s); ++s, --n)
			if (ne == 0 && *s == '0')
				--exp;
			else if (ne < DBL_DIG)
				{
				++ne;
				--exp;
				if (nx == ND)
					{
					d = d * _dtens[IX] + x;
					x = 0, nx = 0;
					}
				x = x * 10 + *s - '0';
				++nx;
				}
	if (nx == 0)
		;
	else if (x == 0)
		exp += nx;
	else
		d = _dtento(&d, nx) + x;
	if (0 < n && (*s == 'e' || *s == 'E'))
		{
		++s, --n;
		eminus = 0;
		if (n == 0)
			;
		else if (*s == '+')
			++s, --n;
		else if (*s == '-')
			{
			++s, --n;
			++eminus;
			}
		for (x = 0; 0 < n && isdigit(*s); ++s, --n)
			if (x < (1 << (_ntens + 1)))
				x = x * 10 + *s - '0';
		exp += eminus ? -x : x;
		}
	if (0 < n && (*s == 'l' || *s == 'L'))
		++s;
	if (ne == 0)
		;
	else if (ne + exp <= (1 << (_ntens - 1)))
		d = _dtento(&d, exp);
	else
		{
		x = _unpack(&d);
		d = _addexp(_dtento(&d, exp), x);
		}
	*pdnum = (minus ? -d : d);
	return (s - is);
	}
