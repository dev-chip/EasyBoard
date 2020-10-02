/*	FORMATTED READ FROM STRING
 *	Copyright (c) 1995 by COSMIC Software
 */
int sscanf(char *s, char *fmt, char *arg)
	{
	return (_scan(s, fmt, &arg));
	}
