;	FUNCTION ENTRY - SET UP FP
;	Copyright (c) 1995 by COSMIC Software
;	- byte size just after the call
;
	xdef	c_ents
;
c_ents:
	puly			; return address in Y
	pshx			; old FP onto the stack
	tsx			; set current SP
	xgdx			; in D
	subb	0,y		; compute new value
	sbca	#0		; byte offset
	tsx			; stack address
	dex			; X point return SP
	xgdx			; X = FP, D = return SP
	txs			; SP in place
	std	0,x		; return SP in place
	jmp	1,y		; and that's ok
;
	end
