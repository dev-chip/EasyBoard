;	MOVE SP FORWARD
;	Copyright (c) 1995 by COSMIC Software
;	- byte offset after the call
;
	xdef	c_msps
	.dcall	"2,0,c_msps"
;
c_msps:
	puly			; return address
	pshx			; save FP
	tsx			; stack address
	xgdx			; in D to calculate
	addb	0,y		; add offset
	adca	#0		; propagate carry
	xgdx			; new SP in X
	std	0,x		; save D here
	pula			; restore FP
	pulb			; in D
	txs			; SP in place
	pulx			; restore D in X
	xgdx			; restore registers
	jmp	1,y		; and return
;
	end
