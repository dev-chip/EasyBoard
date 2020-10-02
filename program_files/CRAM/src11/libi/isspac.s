;	TEST FOR SPACE
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_isspace
	.dcall	"2,0,_isspace"
;
_isspace:
	clra		; for result
	cmpb	#9	; TAB
	blo	paok
	cmpb	#13	; CR
	bls	ok
	cmpb	#' '
	bne	paok
ok:
	incb
	rts
paok:
	clrb
	rts
;
	end
