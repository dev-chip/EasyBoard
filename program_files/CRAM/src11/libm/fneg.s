;	NEGATE A FLOAT
;	Copyright (c) 1995 by COSMIC Software
;	- operand in 2,X and D
;
	xdef	c_fneg
	.dcall	"4,0,c_fgneg"
;
c_fneg:
	pshb			; save register
	psha
	ldd	2,x		; test exponent
	beq	ok		; nul, exit
	eora	#$80		; invert sign
	staa	2,x		; and store
ok:
	pula			; restore register
	pulb
	rts			; and return
;
	end
