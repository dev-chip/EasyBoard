;	TEST FOR DIGIT
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_isdigit
	.dcall	"2,0,_isdigit"
;
_isdigit:
	clra		; for result
	cmpb	#'0'
	blo	paok
	cmpb	#'9'+1
	blo	ok
paok:
	clrb
ok:
	rts
;
	end
