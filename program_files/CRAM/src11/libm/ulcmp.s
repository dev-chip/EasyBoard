;	LONG COMPARE UNSIGNED
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	xdef	c_ulcmp
	.dcall	"4,0,c_ulcmp"
;
c_ulcmp:
	pshx			; save FP
	ldx	2,x		; MSW
	cpx	0,y		; compare MSW
	bne	depil		; not equal, ok
	cpd	2,y		; compare LSW
depil:
	pulx			; restore FP
	rts			; and return
;
	end
