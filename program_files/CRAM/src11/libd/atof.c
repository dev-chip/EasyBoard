/*	BUFFER TO DOUBLE CONVERSION
 *	Copyright (c) 1995 by COSMIC Software
 */
double atof(char *nptr)
	{
	double num;

	return (_btod(nptr, strlen(nptr), &num) ? num : 0.0);
	}
