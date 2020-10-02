;	ISLOWER
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_islower
	.dcall	"2,0,_islower"
;
_islower:
	clra		; for result
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
