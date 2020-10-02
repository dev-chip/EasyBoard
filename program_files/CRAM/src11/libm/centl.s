;	FUNCTION ENTRY - SET UP FP
;	Copyright (c) 1995 by COSMIC Software
;	- word size after the call
;
	xdef	c_entl
;
c_entl:
	puly			; return address in Y
	pshx			; old FP onto the stack
	tsx			; current stack pointer
	xgdx			; in D
	subd	0,y		; compute new value
	tsx			; stack address
	dex			; X point return SP
	xgdx			; X = FP, D = return SP
	txs			; SP in place
	std	0,x		; return SP in place
	jmp	2,y		; and that's ok
;
	end
