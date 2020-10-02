;	DOUBLE ADDITION/SUBSTRACTION
;	Copyright (c) 1995 by COSMIC Software
;	- first operand address in Y
;	- second operand address in D
;
	xdef c_dadd, c_dsub
	.dcall	"19,0,c_dadd"
	.dcall	"19,0,c_dsub"
;
;	double addition
;
c_dadd:
	pshx			; save register
	pshb			; save second address
	psha
	pshx			; open working space
	pshx
	pshx
	pshx
	pshx
	tsx			; X points at working space
	pshy			; save first address
	xgdy			; Y points at the second operand
	ldd	6,y		; copy in scratch
	std	6,x
	ldd	4,y
	std	4,x
	ldd	2,y
	std	2,x
	ldd	0,y
contin:
	std	0,x
	puly			; Y points at the first operand
	des			; scratch cell
	bsr	calcul		; operate
	ins
	pulx			; clean-up stack
	pulx
	pulx
	pulx
	pulx
	pula			; restore pointer
	pulb
	pulx			; restore register
	rts			; and return
;
;	double subtract
;
c_dsub:
	pshx			; save registers
	pshb			; save pointer
	psha
	pshx			; open working space
	pshx
	pshx
	pshx
	pshx
	tsx			; X points at working space
	pshy			; save first address
	xgdy			; Y points at the second operand
	ldd	6,y		; copy in scratch
	std	6,x		; with inverted sign
	ldd	4,y
	std	4,x
	ldd	2,y
	std	2,x
	ldd	0,y
	beq	contin		; if not zero,
	eora	#$80		; invert sign
	bra	contin		; continue
;
;	addition/subtract operation
;	- Y points at 1st operand and result
;	- X points at 2nd operand and scratch
;
calcul:
	ldd	0,x		; test against zero
	beq	fini		; nothing else to do
	ldd	0,y
	bne	pan1
recop:
	ldd	0,x		; simple copy
	std	0,y
	ldd	2,x
	std	2,y
	ldd	4,x
	std	4,y
	ldd	6,x
	std	6,y
fini:
	rts			; that's it
pan1:
	dex			; scratch cell
	lsla			; sign in C
	ror	0,x		; inject sign
	lsra			; restore value
	lsrd			; and align exponent
	lsrd
	lsrd
	lsrd
	std	9,x		; copy first exponent
	ldd	1,x		; second operand
	lsla			; sign in C
	ror	0,x		; inject sign
	inx			; restore X
	lsra			; restore value
	lsrd			; and align exponent
	lsrd
	lsrd
	lsrd
	subd	8,x		; subtract exponents
	beq	padec		; equal, no shift
	bpl	posit		; positive, shift first operand
	cpd	#-52		; test overflow
	bmi	fini		; 2nd null, exit
	ldaa	1,x		; first byte in A
	anda	#$0F		; reset exponent bits
	oraa	#$10		; inject hidden bit
bdec:
	cmpb	#-16		; fast shift
	bhi	bdec8		; try byte shift
	pshb			; save counter
	staa	1,x		; save MSB
	ldd	4,x		; shift
	std	6,x		; word
	ldd	2,x
	std	4,x
	ldaa	1,x
	staa	3,x
	clra
	staa	2,x
	pulb			; get back counter
	addb	#16		; update count
	bne	bdec		; and continue
	bra	bok		; zero, terminate
bdec8:
	cmpb	#-8		; byte shift
	bhi	bdecs		; slow shift
	pshb			; save counter
	staa	1,x		; save MSB
	ldd	5,x		; shift
	std	6,x		; byte
	ldd	3,x
	std	4,x
	ldd	1,x
	std	2,x
	clra
	pulb			; get back counter
	addb	#8		; update count
	beq	bok		; zero terminate
bdecs:
	lsra			; right shift
	ror	2,x
	ror	3,x
	ror	4,x
	ror	5,x
	ror	6,x
	ror	7,x
	incb			; count up
	bne	bdecs		; and loop back
bok:
	staa	1,x		; store result
	bclr	1,y,#$F0	; reset 1st operand bits
	bset	1,y,#$10	; set hidden bit on 1st operand
	bra	oper		; and execute operation
posit:
	cpd	#52		; test overflow
	bpl	recop		; 1st null, copy 2nd operand
	pshb			; saved to restore exponent
	addd	8,x		; compute back
	std	8,x		; result exponent
	pulb			; restore
	ldaa	1,y		; first byte in A
	anda	#$0F		; reset exponent bits
	oraa	#$10		; set hidden bit
adec:
	cmpb	#16		; fast shift
	blo	adec8		; try byte shift
	pshb			; save counter
	staa	1,y		; save MSB
	ldd	4,y		; shift
	std	6,y		; word
	ldd	2,y
	std	4,y
	ldaa	1,y
	staa	3,y
	clra
	staa	2,y
	pulb			; get back counter
	subb	#16		; update count
	bne	adec		; and continue
	bra	aok		; zero, terminate
adec8:
	cmpb	#8		; byte shift
	blo	adecs		; slow shift
	pshb			; save counter
	staa	1,y		; save MSB
	ldd	5,y		; shift
	std	6,y		; byte
	ldd	3,y
	std	4,y
	ldd	1,y
	std	2,y
	clra
	pulb			; get back counter
	subb	#8		; update count
	beq	aok		; zero terminate
adecs:
	lsra			; right shift
	ror	2,y
	ror	3,y
	ror	4,y
	ror	5,y
	ror	6,y
	ror	7,y
	decb			; count down
	bne	adecs		; and loop back
aok:
	staa	1,y		; store result
	bra	poper		; and execute operation
padec:
	bclr	1,y,#$F0	; reset exponent bits
	bset	1,y,#$10	; set hidden bit
poper:
	bclr	1,x,#$F0	; reset exponent bits
	bset	1,x,#$10	; set hidden bits
oper:
	ldd	6,y		; prepare LSW
	dex
	lsl	0,x		; signs
	inx
	bvs	soust		; subtract if they differ
addit:
	addd	6,x		; addition through 53 bits
	std	6,y
	ldd	4,y
	adcb	5,x
	adca	4,x
	std	4,y
	ldd	2,y
	adcb	3,x
	adca	2,x
	std	2,y
	ldab	1,y		; propagate carry
	adcb	1,x
	bitb	#$20		; test overflow
	beq	relres		; no carry, finished
	lsrb			; shift
	ror	2,y
	ror	3,y
	ror	4,y
	ror	5,y
	ror	6,y
	ror	7,y
	inc	9,x		; update exponent
	bne	relres
	inc	8,x
ifdef CHKEXP
	brclr	8,x,#8,relres	; if overflow
	ldaa	#7
	staa	8,x		; saturate
	ldaa	#$FF
	staa	9,x
endif
relres:
	bra	restit		; restore exponent
soust:
	subd	6,x		; subtract on 53 bits
	std	6,y
	ldd	4,y
	sbcb	5,x
	sbca	4,x
	std	4,y
	ldd	2,y
	sbcb	3,x
	sbca	2,x
	std	2,y
	ldab	1,y
	sbcb	1,x		; propagate carry
	bpl	nok		; if negative, invert result
	dex
	com	0,x		; invert sign of result
	inx
	comb
	com	2,y
	com	3,y
	com	4,y
	com	5,y
	com	6,y
	neg	7,y
	bne	nok
	inc	6,y
	bne	nok
	inc	5,y
	bne	nok
	inc	4,y
	bne	nok
	inc	3,y
	bne	nok
	inc	2,y
	bne	nok
	incb
nok:
	tstb			; test zero
	bne	snorm		; not nul, ok
	ldd	2,y		; test if result nul ?
	bne	fnorm		; no, continue
	ldd	4,y		; test if result nul ?
	bne	fnorm		; no, continue
	ldd	6,y		; test if result nul ?
	bne	fnorm		; no, continue
	std	0,y		; yes, complete zero
	rts			; and return
fnorm:
	clrb			; restore MSB
fnorm1:
	ldaa	2,y		; fast shift
	bne	snorm		; no, slow shift
	ldd	8,x		; update exponent
	subd	#8
	std	8,x
	ldd	3,y		; byte shift
	std	2,y
	ldd	5,y
	std	4,y
	ldaa	7,y
	clrb
	std	6,y
	bra	fnorm1		; and continue
snorm:
	bitb	#$10
	bne	restit		; normalize ok
	ldaa	9,x		; exponent LSB
norm:
	suba	#1		; decrement exponent LSB
	bcc	noc		; (carry not set by a deca)
	dec	8,x		; decrement exponent
noc:
	lsl	7,y
	rol	6,y
	rol	5,y
	rol	4,y
	rol	3,y
	rol	2,y
	rolb
	bitb	#$10		; test hidden bit
	beq	norm		; no, loop back
	staa	9,x
restit:
	andb	#$0F		; remove hidden bit
	stab	1,y		; store result
	ldd	8,x		; exponent
	lsld			; aligned
	lsld
	lsld
	lsld
	orab	1,y
	lsla
	dex
	lsl	0,x		; sign of result in C
	inx
	rora			; insert sign
	std	0,y		; final store
	rts			; and return
;
	end
