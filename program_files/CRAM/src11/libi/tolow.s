;	CONVERT TO LOWER
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_tolower
	.dcall	"2,0,_tolower"
;
_tolower:
	clra		; for result
	cmpb	#'A'
	blo	paok
	cmpb	#'Z'
	bhi	paok
	addb	#'a'-'A'
paok:
	rts
;
	end
