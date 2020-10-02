/*	GET CHARACTER FROM SCI INPUT
 *	Copyright (c) 1995 by COSMIC Software
 */
#include <io.h>

#define RDRF	0x20

/*	read a character with echo
 */
int getchar(void)
	{
	char c;

	while (!(SCSR & RDRF))
		;
	c = SCDR;
	if (c == '\r')
		c = '\n';
	return (putchar(c));
	}
