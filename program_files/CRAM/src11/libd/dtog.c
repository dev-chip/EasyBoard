/*	CONVERT DOUBLE TO STRING IN E-FORMAT OR F-FORMAT
 *	Copyright (c) 1995 by COSMIC Software
 */
#include <string.h>

int _dtog(char *is, double *pd, int p, int g, int strip)
	{
	char *q, *t;
	int i, exp;
	char buf[2], *s;

	exp = _norm(buf, pd, 2);
	if (!g)
		g = 1;
	if (exp > g || exp < -3)	/* E-FORMAT */
		{
		i = _dtoe(is, pd, 1, g);
		if (!strip)
			return (i);
		s = is + i;
		if (!(t = memchr(is, 'e', i)))
			t = s;
		q = t - 1;
		if (*q != '0')
			return (i);
		while (*q == '0')
			--q;
		if (*q != '.')
			++q;
		while (t <= s)
			*q++ = *t++;
		return (q - is - 1);
		}
	else	/* F-FORMAT */
		{
		i = _dtof(is, pd, p, g);
		for (s = is + i - 1; i && *s; --s, --i)
			if (*s == '0')
				*s = '\0';
			else
				{
				if (*s == '.' && strip)
					*s = '\0', --i;
				break;
				}
		return (i);
		}
	}
