/*	ALLOCATE NELEM TIMES ELSIZE BYTES
 *	Copyright (c) 1995 by COSMIC Software
 */
#include <stdlib.h>

void *calloc(unsigned int nelem, unsigned int size)
	{
	void *p;

	size *= nelem;
	if (p = malloc(size))
		memset(p, 0, size);
	return (p);
	}
