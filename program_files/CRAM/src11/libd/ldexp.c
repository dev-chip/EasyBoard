/*	SCALE DOUBLE EXPONENT
 *	Copyright (c) 1995 by COSMIC Software
 */
double ldexp(double d, int n)
	{
	extern double _addexp(double, int);

	return (_addexp(d, n));
	}
