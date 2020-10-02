;	ABSOLUTE VALUE OF A LONG INTEGER
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_labs
	.dcall	"2,0,_labs"
;
_labs:
	ldy	2,x		; MSW
	bpl	posit		; positive, ok
	coma			; else invert
	comb			; LSW
	xgdy			; take MSW
	coma			; invert
	comb
	iny			; increment LSW
	bne	ok		; if null
	addd	#1		; increment MSW
ok:
	xgdy			; restore order
	sty	2,x		; result in place
posit:
	rts			; and return
;
	end
