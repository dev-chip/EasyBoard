;	FUNCTION ENTRY WITH ARGUMENT - SETUP FP
;	Copyright (c) 1995 by COSMIC Software
;	- byte offset after the call
;
	xdef c_kents, c_kenst
;
c_kenst:
	puly			; return address in Y
	pshx			; save old FP
	pshb			; save byte argument
	tsx			; return SP value
	bra	suite		; common ending
c_kents:
	puly			; return address in Y
	pshx			; save old FP
	pshb			; save word argument
	tsx			; return SP value
	psha			; second byte from argument
suite:
	xgdx			; return SP in D
	tsx			; current stack pointer
	xgdx			; in D
	subb	0,y		; compute new SP
	sbca	#0		; byte offset
	xgdx			; X = FP, D = return SP
	txs			; SP in place
	std	0,x		; return SP in place
	jmp	1,y		; and that's ok
;
	end
