/*	FORMATTED OUTPUT
 *	Copyright (c) 1995 by COSMIC Software
 */
int printf(char *fmt, void *args)
	{
	return (_print(0, fmt, &args));
	}
