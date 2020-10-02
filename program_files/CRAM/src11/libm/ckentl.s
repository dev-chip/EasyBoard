;	FUNCTION ENTRY WITH ARGUMENT - SET UP FP
;	Copyright (c) 1995 by COSMIC Software
;	- word size after the call
;
	xdef c_kentl, c_kenlt
;
c_kenlt:
	puly			; return address in Y
	pshx			; save old FP
	pshb			; save byte argument
	tsx			; return SP value
	bra	suite		; common ending
c_kentl:
	puly			; return address in Y
	pshx			; save old FP
	pshb			; save word argument
	tsx			; return SP value
	psha			; second byte from argument
suite:
	xgdx			; return SP in D
	tsx			; current stack pointer
	xgdx			; in D
	subd	0,y		; compute new stack pointer
	xgdx			; X = FP, D = return SP
	txs			; SP in place
	std	0,x		; return SP in place
	jmp	2,y		; and that's ok
;
	end
