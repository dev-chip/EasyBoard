;	LONG SUBSTRACT
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	xdef	c_lsub
	.dcall	"4,0,c_lsub"
;
c_lsub:
	subd	2,y		; subtract LSW
	pshb			; save result
	psha
	ldd	2,x		; subtract MSW
	sbcb	1,y		; with carry
	sbca	0,y
	std	2,x		; store MSW
	pula			; restore LSW
	pulb
	rts			; and return
;
	end
