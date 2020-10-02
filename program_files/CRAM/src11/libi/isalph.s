;	TEST FOR ALPHA
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_isalpha
	.dcall	"2,0,_isalpha"
;
_isalpha:
	clra		; for result
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
