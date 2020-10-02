;	DIVISION WITH QUOTIENT AND REMAINDER
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	__udiv
	.dcall	"4,0,__udiv"
;
__udiv:
	pshx			; save FP
	xgdy			; structure address
	ldd	0,y		; dividend
	ldx	2,y		; divisor
	idiv			; operate
	stx	0,y		; quotient
	std	4,y		; remainder
	pulx			; restore FP
	rts			; and return
;
	end
