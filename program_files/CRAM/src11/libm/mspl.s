;	MOVE SP FORWARD
;	Copyright (c) 1995 by COSMIC Software
;	- word size after the call
;
	xdef	c_mspl
	.dcall	"2,0,c_mspl"
;
c_mspl:
	puly			; return address
	pshx			; save FP
	tsx			; stack address
	xgdx			; in D to compute
	addd	0,y		; add offset
	xgdx			; new SP in X
	std	0,x		; save D here
	pula			; load FP
	pulb			; in D
	txs			; SP in place
	pulx			; restore D in X
	xgdx			; restore registers
	jmp	2,y		; and return
;
	end
