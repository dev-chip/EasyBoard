;	TEST FOR PRINTABLE
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_isprint
	.dcall	"2,0,_isprint"
;
_isprint:
	clra		; for result
	cmpb	#' '
	blo	paok
	cmpb	#$7F
	blo	ok
paok:
	clrb
ok:
	rts
;
	end
