;	CONVERT TO UPPER
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_toupper
	.dcall	"2,0,_toupper"
;
_toupper:
	clra		; for result
	cmpb	#'a'
	blo	paok
	cmpb	#'z'
	bhi	paok
	subb	#'a'-'A'
paok:
	rts
;
	end
