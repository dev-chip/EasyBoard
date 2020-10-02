;	NEGATE A DOUBLE
;	Copyright (c) 1995 by COSMIC Software
;	- operand address in Y
;
	xdef	c_dneg
	.dcall	"4,0,c_dneg"
;
c_dneg:
	psha			; save registers
	pshb
	ldd	0,y		; test zero
	beq	ok		; yes, no change
	eora	#$80		; invert sign bit
	staa	0,y		; and store
ok:
	pula			; restore register
	pulb
	rts			; and return
;
	end
