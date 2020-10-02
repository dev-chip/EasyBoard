;	LONG MULTIPLY IN MEMORY
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand address in Y
;	- 2nd operand in 2,X and D
;
	xdef	c_lgmul
	.dcall	"12,0,c_lgmul"
;
c_lgmul:
	pshx			; save FP
	pshb			; stack operand
	psha
	ldx	2,x
	pshx
	pshx			; scratch for result
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
	pulx			; load result
	stx	0,y
	pulx
	stx	2,y
	pulx
	pulx
	pulx			; restore FP
	rts			; and return
;
	end
