;	TEST FOR PUNCTUATION
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_ispunct
	.dcall	"2,0,_ispunct"
;
_ispunct:
	clra		; for result
	cmpb	#' '
	bls	paok
	cmpb	#'0'
	blo	ok
	cmpb	#'9'
	bls	paok
	cmpb	#'A'
	blo	ok
	cmpb	#'Z'
	bls	paok
	cmpb	#'a'
	blo	ok
	cmpb	#'z'
	bls	paok
	cmpb	#$7F
	blo	ok
paok:
	clrb
ok:
	rts
;
	end
