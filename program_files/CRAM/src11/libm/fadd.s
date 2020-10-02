;	FLOAT ADDITION/SUBSTRACT
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	xdef	c_fadd, c_fsub
	.dcall	"14,0,c_fadd"
	.dcall	"14,0,c_fsub"
;
;	float addition
;
c_fadd:
	pshx			; save FP
	pshx			; workspace
	pshb			; save D
	psha
	ldx	2,x
	pshx
	ldx	2,y		; copy operand
	pshx
	ldd	0,y
contin:
	pshb
	psha
	tsx			; workspace address in X
	bsr	calcul		; operate
	ldd	4,x		; MSW
	ldx	10,x		; load FP
	std	2,x		; MSW in place
	pulx			; restore registers
	pulx
	pulx
	pula			; MSB
	pulb			; LSB
	pulx
	pulx
	rts			; and return
;
;	float subtract
;
c_fsub:
	pshx			; save FP
	pshx			; workspace
	pshb			; save D
	psha
	ldx	2,x
	pshx
	ldx	2,y		; copy operand
	pshx
	ldd	0,y
	beq	contin		; nul, ok
	eora	#$80		; invert sign
	bra	contin		; and continue
;
;	add/subtract operation
;
calcul:
	ldd	0,x		; test operands against zero
	beq	fini		; nothing else to do
pan0:
	ldd	4,x
	bne	pan1
recop:
	ldd	0,x		; simple copy
	std	4,x
	ldd	2,x
	std	6,x
fini:
	rts			; and return
pan1:
	ldd	4,x		; sign + exponent
	lsld			; align, sign -> C
	ror	8,x		; inject sign
	staa	9,x		; copy 1st exponent
	ldd	0,x		; sign + exponent
	lsld			; align, sign -> C
	ror	8,x		; inject sign
	tab			; keep 2nd exponent
	subb	9,x		; subtract exponents
	beq	padec		; nul, no shift
	bhi	posit		; positive, shift 1st operand
	cmpb	#-23		; test overflow
	blo	fini		; 2nd nul, exit
	ldaa	1,x		; first byte in B
	oraa	#$80		; set hidden bit
	cmpb	#-16		; fast shift
	bhi	bdec		; no, try byte
	staa	3,x		; store shifted
	clra			; complete
	staa	2,x		; result
	addb	#16		; update count
	bne	bdecs		; slow shift
	bra	bok		; zero, terminate
bdec:
	cmpb	#-8		; byte shift
	bhi	bdecs		; no, slow shift
	stab	1,x		; keep counter
	ldab	2,x		; complete word
	std	2,x		; and store shifted
	clra			; complete result
	ldab	1,x		; get back counter
	addb	#8		; update
	beq	bok		; zero, terminate
bdecs:
	lsra			; right shift
	ror	2,x
	ror	3,x
	incb			; count up
	bne	bdecs		; and loop back
bok:
	staa	1,x		; store result
	bra	oper0		; and operate
posit:
	cmpb	#24		; test overflow
	bhs	recop		; yes, copy 2nd operand
	staa	9,x		; result exponent
	ldaa	5,x		; first byte in B
	oraa	#$80		; set hidden bit
	cmpb	#16		; fast shift
	blo	adec		; no use slow
	staa	7,x		; store shifted
	clra			; complete
	staa	6,x		; result
	subb	#16		; update count
	bne	adecs		; slow shift
	bra	aok		; zero, terminate
adec:
	cmpb	#8		; fast shift
	blo	adecs		; no use slow
	stab	5,x		; keep counter
	ldab	6,x		; complete word
	std	6,x		; and store shifted
	clra			; complete result
	ldab	5,x		; get back counter
	subb	#8		; update
	beq	aok		; zero, terminate
adecs:
	lsra			; right shift
	ror	6,x
	ror	7,x
	decb			; count down
	bne	adecs		; and loop back
aok:
	staa	5,x		; store result
	bset	1,x,#$80	; set hidden bit on 2nd operand
	bra	oper		; and operate
padec:
	bset	1,x,#$80	; set hidden bits
oper0:
	bset	5,x,#$80
oper:
	ldd	6,x		; load LSW
	lsl	8,x		; signs
	bvs	soust		; subtract if they differ
	addd	2,x		; addition on 24 bits
	std	6,x
	ldaa	9,x		; load exponent
	ldab	5,x		; propagate carry
	adcb	1,x
	bcc	restit		; no carry, finished
	rorb			; shift with inject
	ror	6,x
	ror	7,x
	inca			; update
ifdef CHKEXP
	bne	restit		; if overflow
	deca			; saturate
endif
	bra	restit		; restore result
soust:
	subd	2,x		; subtract on 24 bits
	std	6,x
	ldab	5,x
	sbcb	1,x		; propagate carry
	bcc	sok		; if carry, invert result
	com	8,x		; invert result sign
	comb
	coma
	neg	7,x
	bne	sok0
	inca
	bne	sok0
	incb
sok0:
	staa	6,x
sok:
	tstb			; test zero
	bne	norm		; not nul, ok
	ldd	6,x		; test result nul ?
	bne	nok		; no, continue
	std	4,x		; yes, complete zero
	rts			; and return
nok:
	clrb			; MSB
norm:
	ldaa	9,x		; exponent
	tstb
	bmi	restit		; test normalize
	bne	norms		; slow shift
	suba	#8		; update
	staa	9,x		; exponent
	ldab	6,x		; load MSB
	ldaa	7,x		; shift last
	staa	6,x		; byte and
	clr	7,x		; complete result
	bra	norm		; and continue
norms:
	deca			; decrement exponent
	lsl	7,x
	rol	6,x
	rolb
	bpl	norms		; and loop again
restit:
	lslb			; remove hidden bit
	lsl	8,x		; result sign in C
	rora
	rorb			; inject and align
	std	4,x		; final store
	rts			; and return
;
	end
