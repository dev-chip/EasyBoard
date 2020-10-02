;	FUNCTION ENTRY WITH LONG ARGUMENT - SETUP FP
;	Copyright (c) 1995 by COSMIC Software
;	- byte offset after the call
;
	xdef	c_kenls
;
c_kenls:
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
	subb	0,y		; compute new SP
	sbca	#0		; byte offset
	xgdx			; X = FP, D = return SP
	txs			; SP in place
	std	0,x		; return SP in place
	jmp	1,y		; and that's ok
;
	end
