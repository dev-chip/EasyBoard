;	SHORT INTEGER TO LONG INTEGER CONVERSION
;	Copyright (c) 1995 by COSMIC Software
;	- operand in D
;
	xdef	c_itol
	.dcall	"3,0,c_itol"
;
c_itol:
	pshb			; save register
	clrb			; assume positive
	tsta			; test sign
	bpl	sok		; positive, ok
	comb			; else invert
sok:
	stab	2,x		; set MSW
	stab	3,x
	pulb			; restore register
	rts			; and return
;
	end
