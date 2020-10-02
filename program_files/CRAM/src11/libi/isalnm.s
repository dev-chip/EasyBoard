;	TEST FOR ALPHANUMERIC
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_isalnum
	.dcall	"2,0,_isalnum"
;
_isalnum:
	clra		; for result
	cmpb	#'0'
	blo	paok
	cmpb	#'9'+1
	blo	ok
	cmpb	#'A'
	blo	paok
	cmpb	#'Z'+1
	blo	ok
	cmpb	#'a'
	blo	paok
	cmpb	#'z'+1
	blo	ok
paok:
	clrb
ok:
	rts
;
	end
