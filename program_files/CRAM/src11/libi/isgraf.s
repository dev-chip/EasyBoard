;	TEST FOR GRAPHIC
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_isgraph
	.dcall	"2,0,_isgraph"
;
_isgraph:
	clra		; for result
	cmpb	#' '
	bls	paok
	cmpb	#$7F
	blo	ok
paok:
	clrb
ok:
	rts
;
	end
