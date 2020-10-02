/*	SCALE DOUBLE EXPONENT
 *	Copyright (c) 1995 by COSMIC Software
 */
double ldexp(double d, int n)
	{
	extern double _addexp();

	return (_addexp(n, d));
	}
