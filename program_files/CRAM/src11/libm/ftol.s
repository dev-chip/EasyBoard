;	FLOAT TO LONG/SHORT INTEGER CONVERSION
;	Copyright (c) 1995 by COSMIC Software
;	- operand in 2,X and D
;
	xdef	c_ftol, c_ftoi
	.dcall	"10,0,c_ftoi"
	.dcall	"10,0,c_ftol"
;
c_ftoi:
c_ftol:
	pshx			; save registers
	pshy
	pshb			; copy operand
	psha
	ldx	2,x
	pshx
	tsx			; stack address
	ldd	0,x
	beq	rfin		; nul, finished
	lsld			; exponent in A
	suba	#127		; remove offset
	bpl	valid		; test underflow
zero:
	clra
	clrb
	std	2,x		; clear result
	std	0,x
rfin:
	ldy	0,x		; to be compatible
	ldx	6,x		; load FP
	bra	fini		; and exit
valid:
	cmpa	#55		; (32 + 23)
	bpl	zero		; test overflow
	clr	0,x		; prepare resul
	bset	1,x,#$80	; set hidden bit
	suba	#23		; result ok if exponent = 23
	beq	signe		; ok, continue
	bpl	posit		; left shift
bc1:
	cmpa	#-7		; fast shift
	bpl	slo
	ldab	2,x
	stab	3,x
	ldab	1,x
	stab	2,x
	clr	1,x
	adda	#8
	bra	bc1
slo:
	tsta
	beq	signe		; finished
sbcl:
	lsr	1,x		; slow shift
	ror	2,x
	ror	3,x
	inca
	bne	sbcl
	bra	signe		; ready for sign
posit:
	cmpa	#8		; fast shift
	bmi	plo
	ldab	1,x
	stab	0,x
	ldab	2,x
	stab	1,x
	ldab	3,x
	stab	2,x
	clr	3,x
	suba	#8
	bra	posit
plo:
	tsta
	beq	signe		; finished
pbcl:
	lsl	3,x		; slow shift
	rol	2,x
	rol	1,x
	rol	0,x
	deca
	bne	pbcl
signe:
	ldy	0,x		; MSW
	ldd	2,x		; LSW
	ldx	6,x		; load FP
	brclr	2,x,#$80,fini	; sign ok, exit
	coma			; else invert result
	comb
	xgdy
	coma
	comb
	xgdy
	addd	#1
	bcc	fini
	iny
fini:
	sty	2,x
	pulx			; restore registers
	pulx
	puly
	pulx
	rts			; and return
;
	end
