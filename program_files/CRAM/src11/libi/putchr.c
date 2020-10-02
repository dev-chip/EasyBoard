/*	PUT A CHARACTER TO SCI OUTPUT
 *	Copyright (c) 1995 by COSMIC Software
 */
#include <io.h>

#define TRDE	0x80

/*	output a character
 */
int putchar(char c)
	{
	for (;;)
		{
		while (!(SCSR & TRDE))
			;
		SCDR = c;
		if (c == '\n')
			c = '\r';
		else
			break;
		}
	return (c);
	}
