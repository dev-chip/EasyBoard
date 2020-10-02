/*	FORMATTED OUTPUT
 *	Copyright (c) 1995 by COSMIC Software
 */
int vprintf(char *fmt, void *args)
	{
	return (_print(0, fmt, args));
	}
