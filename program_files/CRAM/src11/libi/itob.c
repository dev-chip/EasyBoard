/*	CONVERT INT AND LONG TO BUFFER
 *	Copyright (c) 1995 by COSMIC Software
 */
static const char digstr[] = {"0123456789abcdefghijklmnopqrstuvwxyz"};

#define ND (int)(sizeof(digstr) - 1)

/*	convert short integer
 */
int _itob(char *is, int val, int ibase)
	{
	char *s, *p;
	struct {
		unsigned int uval;
		unsigned int base;
		unsigned int rem;
		} v;
	char c;

	if (ibase < -ND || ND < ibase)
		return (0);
	v.base = (ibase < 0) ? -ibase : ibase;
	if (v.base <= 1)
		v.base = 10;
	s = is;
	if (ibase <= 0 && val < 0)
		{
		val = -val;
		*s++ = '-';
		}
	v.uval = val;
	p = s;
	do	{
		_udiv(&v);
		*s++ = digstr[v.rem];
		} while (v.uval);
	v.uval = s - is;
	while (p < --s)
		{
		c = *p;
		*p++ = *s;
		*s = c;
		}
	return (v.uval);
	}

/*	convert long integer
 */
int _ltob(char *is, long *pval, int ibase)
	{
	char *s, *p;
	struct {
		unsigned long uval;
		unsigned int base;
		unsigned int rem;
		} v;
	char c;

	if (ibase < -ND || ND < ibase)
		return (0);
	v.base = (ibase < 0) ? -ibase : ibase;
	if (v.base <= 1)
		v.base = 10;
	s = is;
	if (*pval < 0 && ibase <= 0)
		{
		v.uval = -*pval;
		*s++ = '-';
		}
	else
		v.uval = *pval;
	p = s;
	do	{
		_uldiv(&v);
		*s++ = digstr[v.rem];
		} while (v.uval);
	v.base = s - is;
	while (p < --s)
		{
		c = *p;
		*p++ = *s;
		*s = c;
		}
	return (v.base);
	}
