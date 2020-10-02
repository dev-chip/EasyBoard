;	ISUPPER
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_isupper
	.dcall	"2,0,_isupper"
;
_isupper:
	clra		; for result
	cmpb	#'A'
	blo	paok
	cmpb	#'Z'+1
	blo	ok
paok:
	clrb
ok:
	rts
;
	end
