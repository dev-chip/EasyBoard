;	INTEGER ABSOLUTE VALUE
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_abs
	.dcall	"2,0,_abs"
;
_abs:
	tsta			; test sign
	bpl	posit		; positive, ok
	nega			; else
	negb			; negate
	sbca	#0
posit:
	rts			; and return
;
	end
