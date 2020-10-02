;	SETJMP AND LONGJUMP
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_longjmp, _setjmp
	.dcall	"2,2,_longjmp"
	.dcall	"2,0,_setjmp"
;
_longjmp:
	pulx			; flush return address
	pulx			; return value
	xgdx			; buffer address
	lds	2,x		; load SP
	std	2,x		; test return value
	bne	panul
	incb			; cannot be zero
panul:
	ldy	4,x		; new return address
	ldx	0,x		; load FP
	jmp	0,y		; and return
;
_setjmp:
	puly			; return address
	xgdy			; buffer address
	stx	0,y		; store FP
	sts	2,y		; store SP
	std	4,y		; store return address
	pshb			; replace it
	psha			; on the stack
	clra			; clear return value
	clrb
	rts			; and return
;
	end
