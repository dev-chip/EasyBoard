/*	FORMATTED OUTPUT TO INTERNAL BUFFER
 *	Copyright (c) 1995 by COSMIC Software
 */
int vsprintf(char *s, char *fmt, void *args)
	{
	*s = '\0';
	return (_print(&s, fmt, args));
	}
