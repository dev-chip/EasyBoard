/*	CONVERT BUFFER TO INTEGER
 *	Copyright (c) 1995 by COSMIC Software
 */
#include <ctype.h>

int atoi(char *nptr)
	{
	int num;
	char sig;

	while (isspace(*nptr))
		++nptr;
	sig = *nptr;
	if (sig == '+' || sig == '-')
		++nptr;
	for (num = 0; isdigit(*nptr); ++nptr)
		num = num * 10 + (*nptr - '0');
	return ((sig == '-') ? -num : num);
	}
