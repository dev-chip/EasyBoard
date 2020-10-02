;	LONG MULTIPLICATION
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	xdef	c_lmul
	.dcall	"12,0,c_lmul"
;
c_lmul:
	pshx			; save FP
	pshb			; stack operand
	psha
	ldx	2,x
	pshx
	pshx			; scratch 
	pshx
	tsx			; stack address
;
	ldaa	7,x		; LL * LL
	ldab	3,y
	mul
	std	2,x
;
	ldaa	5,x		; HL * LL
	ldab	3,y
	mul
	std	0,x
	ldaa	6,x		; LH * LH
	ldab	2,y
	mul
	addd	0,x
	std	0,x
	ldaa	7,x		; LL * HL
	ldab	1,y
	mul
	addd	0,x
	std	0,x
;
	ldaa	7,x		; LL * LH
	ldab	2,y
	mul
	addd	1,x
	std	1,x
	bcc	noc1
	inc	0,x
noc1:
	ldaa	6,x		; LH * LL
	ldab	3,y
	mul
	addd	1,x
	std	1,x
	bcc	noc2
	inc	0,x
noc2:
	ldaa	7,x
	ldab	0,y
	mul
	addb	0,x
	stab	0,x
	ldaa	6,x
	ldab	1,y
	mul
	addb	0,x
	stab	0,x
	ldaa	5,x
	ldab	2,y
	mul
	addb	0,x
	stab	0,x
	ldaa	4,x
	ldab	3,y
	mul
	addb	0,x
	stab	0,x
	puly			; load result
	pula
	pulb
	pulx
	pulx
	pulx			; restore FP
	sty	2,x		; store MSW
	rts			; and return
;
	end
