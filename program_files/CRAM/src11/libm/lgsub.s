;	LONG SUBSTRACT IN MEMORY
;	Copyright (c) 1995 by COSMIC Software
;	soustraction de deux longs
;	- 1st operand address in Y
;	- 2nd operand in 2,X and D
;
	xdef	c_lgsub
	.dcall	"6,0,c_lgsub"
;
c_lgsub:
	pshx			; save FP
	pshb			; save register
	psha
	tsx			; stack address
	ldd	2,y		; compute LSW
	subd	0,x
	std	2,y
	pulx			; clean-up stack
	pulx			; restore FP
	ldd	0,y		; compute MSW
	sbcb	3,x		; with carry
	sbca	2,x
	std	0,y
	rts			; and return
;
	end
