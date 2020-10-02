;	TEST FOR HEXADECIMAL
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_isxdigit
	.dcall	"2,0,_isxdigit"
;
_isxdigit:
	clra		; for result
	cmpb	#'0'
	blo	paok
	cmpb	#'9'+1
	blo	ok
	cmpb	#'A'
	blo	paok
	cmpb	#'F'+1
	blo	ok
	cmpb	#'a'
	blo	paok
	cmpb	#'f'+1
	blo	ok
paok:
	clrb
ok:
	rts
;
	end
