;	NEGATE A LONG
;	Copyright (c) 1995 by COSMIC Software
;	- operand in 2,X and D
;
	xdef	c_lneg
	.dcall	"2,0,c_lneg"
;
c_lneg:
	com	2,x		; invert MSW
	com	3,x
	coma			; invert LSW
	comb
	addd	#1		; add one to negate
	bcc	nok		; and propagate carry
	inc	3,x		; through MSW
	bne	nok
	inc	2,x
nok:
	rts			; return
;
	end
