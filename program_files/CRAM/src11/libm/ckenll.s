;	FUNCTION ENTRY WITH LONG ARGUMENT - SETUP FP
;	Copyright (c) 1995 by COSMIC Software
;	- word offset after the call
;
	xdef	c_kenll
;
c_kenll:
	puly			; return address in Y
	pshx			; save old FP
	pshb			; save argument LSW
	psha			; second byte from argument
	ldd	2,x		; load argument MSW
	tsx			; prepare stack pointer
	inx			; aligned properly
	xgdx			; return SP in D
	pshx			; save argument MSW
	tsx			; current stack pointer
	xgdx			; in D
	subd	0,y		; compute new SP
	xgdx			; X = FP, D = return SP
	txs			; SP in place
	std	0,x		; return SP in place
	jmp	2,y		; and that's ok
;
	end
