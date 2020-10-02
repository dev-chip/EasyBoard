/*	SET SYSTEM BREAK
 *	Copyright (c) 1995 by COSMIC Software
 */
#include <stdlib.h>

void *sbreak(unsigned int size)
	{
	extern char _memory;
	static char *_brk = NULL;	/* memory break */
	char *obrk, yellow[20];

	if (!_brk)
		_brk = &_memory;
	obrk = _brk;
	_brk += size;
	if (yellow <= _brk || _brk < &_memory)
		{
		_brk = obrk;
		return (NULL);
		}
	return (obrk);
	}
