;	DOUBLE TO LONG/SHORT INTEGER CONVERSION
;	Copyright (c) 1995 by COSMIC Software
;	- operand address in Y
;	- result in 2,X and D
;
	xdef	c_dtol, c_dtoi
	.dcall	"12,0,c_dtoi"
	.dcall	"12,0,c_dtol"
;
c_dtoi:
c_dtol:
	pshx			; save registers
	pshx			; scratch
	pshx
	pshx			; 4 bytes workspace
	pshx
	tsx			; stack address
	ldd	6,y		; copy double
	std	6,x		; in workspace
	ldd	4,y
	std	4,x
	ldd	2,y
	std	2,x
	ldd	0,y
	std	0,x		; test exponent
	beq	zero		; null, finished
	anda	#$7F		; clear sign
	lsrd			; align exponent
	lsrd
	lsrd
	lsrd			; exponent in D
	subd	#1023		; remove offset
	bpl	valid		; no underflow
zero:
	clra
	clrb
	std	6,x		; zero result
	std	4,x
	bra	fini		; and exit
valid:
	cpd	#84		; (32 + 52)
	bpl	zero		; test overflow
	bclr	1,x,#$F0	; prepare value for shift
	bset	1,x,#$10	; set hidden bit
	tba			; exponent in A
	suba	#52		; result ok if exponent = 52
	beq	signe		; ok, continue
	bpl	posit		; left shift
bc1:
	cmpa	#-7		; fast shift
	bpl	slo
	ldab	6,x
	stab	7,x
	ldab	5,x
	stab	6,x
	ldab	4,x
	stab	5,x
	ldab	3,x
	stab	4,x
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
	lsr	3,x		; slow shift
	ror	4,x
	ror	5,x
	ror	6,x
	ror	7,x
	inca
	bne	sbcl
	bra	signe		; ready for sign
posit:
	cmpa	#8		; fast shift
	bmi	plo
	ldab	5,x
	stab	4,x
	ldab	6,x
	stab	5,x
	ldab	7,x
	stab	6,x
	clr	7,x
	suba	#8
	bra	posit
plo:
	tsta
	beq	signe		; finished
pbcl:
	lsl	7,x		; slow shift
	rol	6,x
	rol	5,x
	rol	4,x
	deca
	bne	pbcl
signe:
	brclr	0,x,#$80,fini	; sign ok, finished
	com	4,x		; else invert result
	com	5,x
	com	6,x
	neg	7,x
	bne	fini
	ldd	5,x
	addd	#1
	std	5,x
	bcc	fini
	inc	4,x
fini:
	ldd	4,x		; load MSW
	ldx	8,x		; reload FP
	std	2,x		; in place
	pulx			; cleanup stack
	pulx
	pulx
	pula			; LSW in place
	pulb
	pulx			; restore FP
	rts			; and return
;
	end
