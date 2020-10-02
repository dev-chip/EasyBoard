;	TEST FOR CONTROL
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_iscntrl
	.dcall	"2,0,_iscntrl"
;
_iscntrl:
	clra		; for result
	cmpb	#' '
	blo	ok
	cmpb	#$7F
	bne	paok
ok:
	incb
	rts
paok:
	clrb
	rts
;
	end
