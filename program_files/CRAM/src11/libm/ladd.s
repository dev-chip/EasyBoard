;	LONG ADDITION
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
; 	- 2nd operand address in Y
;
	xdef	c_ladd
	.dcall	"4,0,c_ladd"
;
c_ladd:
	addd	2,y		; add LSW
	pshb			; save result
	psha
	ldd	2,x		; add MSW
	adcb	1,y		; with carry
	adca	0,y
	std	2,x
	pula			; restore LSW
	pulb
	rts			; and return
;
	end
