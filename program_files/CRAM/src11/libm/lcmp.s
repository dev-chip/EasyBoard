;	LONG COMPARE
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	xdef	c_lcmp
	.dcall	"4,0,c_lcmp"
;
c_lcmp:
	pshx			; save FP
	ldx	2,x		; MSW
	cpx	0,y		; compare MSW
	bne	depil		; not equal, ok
	cpd	2,y		; compare LSW
	xgdx			; save value
	clv			; no overflow
	tpa			; set flags in A
	bhs	clear		; no carry, reset N
	oraa	#$08		; set N flag
	bra	ok		; and continue
clear:
	anda	#$F7		; clear N flag
ok:
	tap			; restore flags
	xgdx			; restore register
depil:
	pulx			; restore FP
	rts			; and return
;
	end
