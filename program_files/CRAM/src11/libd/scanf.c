/*	FORMATTED READ FROM INPUT
 *	Copyright (c) 1995 by COSMIC Software
 */
int scanf(char *fmt, void *arg)
	{
	return (_scan(0, fmt, &arg));
	}
