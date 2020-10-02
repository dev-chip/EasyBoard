; 	DOUBLE MULTIPLY WITH ALU
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand address in Y
;	- 2nd operand address in D
;
	include	"alu.mac"
	xdef	c_dmula
	.dcall	"30,0,c_dmula"
;
c_dmula:
	pshx			; save registers
	tsx			; X points the stack
	xgdx			; open workspace
	pshx			; save 2nd pointer
	subd	#24
	xgdx
	txs			; update stack pointer
	pshy			; save 1st pointer
	ldy	24,x		; 2nd operand
	ldd	0,y		; copy 2nd operand
	std	0,x
	ldd	2,y
	std	2,x
	ldd	4,y
	std	4,x
	ldd	6,y
	std	6,x
	puly			; Y points 1st operand
	ldd	0,x		; test zero
	beq	zero		; yes, zero result
	ldd	0,y
	bne	panul		; no, continue
zero:
	std	0,y		; store zeroes
	std	2,y
	std	4,y
	std	6,y
	bra	fini		; and finish
panul:
	bset 	1,y,#$10	; set hidden bit
	bclr	1,y,#$E0	; reset exponent bits
	andb	#$F0		; mask mantissa
	subd	#16368		; minus offset (1023 << 4)
	std	8,x		; store
	ldd	0,x		; 2nd exponent
	bset	1,x,#$10	; set hidden bit
	bclr	1,x,#$E0	; reset exponent bits
	andb	#$F0		; mask mantissa
	addd	8,x		; addition (with only one offset)
	std	8,x		; store exponent
	clr	ALUC		; prepare unsigned multiply
	ldd	1,x		; multiply MSW
	std	AREG
	ldd	1,y
	std	BREG		; start multiply
	ldaa	7,x		; continue with LSB
	ldab	7,y
	mul
	std	22,x		; store result
	aluw			; wait for result
	ldd	CH
	std	10,x		; store result
	ldd	CL
	std	12,x
	clra			; clear the rest
	clrb
	std	14,x
	std	16,x
	std	18,x
	std	20,x
	ldd	1,x		; 2nd level (1)
	std	AREG
	ldd	3,y
	jsr	cniv2
	ldd	3,x		; 2nd level (2)
	std	AREG
	ldd	1,y
	jsr	cniv2
	ldd	1,x		; 3rd level (1)
	std	AREG
	ldd	5,y
	jsr	cniv3
	ldd	3,x		; 3rd level (2)
	std	AREG
	ldd	3,y
	jsr	cniv3
	ldd	5,x		; 3rd level (3)
	std	AREG
	ldd	1,y
	jsr	cniv3
	ldd	1,x		; 4th level (1)
	std	AREG
	ldaa	7,y
	clrb
	jsr	cniv4
	ldd	3,x		; 4th level (2)
	std	AREG
	ldd	5,y
	jsr	cniv4
	ldd	5,x		; 4th level (3)
	std	AREG
	ldd	3,y
	jsr	cniv4
	ldaa	7,x		; 4th level (4)
	clrb
	std	AREG
	ldd	1,y
	jsr	cniv4
	ldd	3,x		; 5th level (1)
	std	AREG
	ldaa	7,y
	clrb
	jsr	cniv5
	ldd	5,x		; 5th level (2)
	std	AREG
	ldd	5,y
	jsr	cniv5
	ldaa	7,x		; 5th level (3)
	clrb
	std	AREG
	ldd	1,y
	jsr	cniv5
	ldd	5,x		; 6th level (1)
	std	AREG
	ldaa	7,y
	jsr	cniv6
	ldd	5,y		; 6th level (2)
	std	AREG
	ldaa	7,x
	jsr	cniv6
	ldaa	#4		; shift count
	brclr	10,x,#2,padec	; test hidden bit
	ldd	8,x		; update exponent
	addd	#$10		; +1 (shifted)
	std	8,x
	ldaa	#3		; only two shifts
padec:
	ldab	10,x
dbcl:
	lsl	17,x		; left shift
	rol	16,x
	rol	15,x
	rol	14,x
	rol	13,x
	rol	12,x
	rol	11,x
	rolb
	deca
	bne	dbcl
	andb	#$0F		; mask exponent
	orab	9,x		; insert exponent
	stab	1,y		; final store
	ldab	0,x		; compute sign of result
	eorb	0,y
	ldaa	8,x		; exponent MSB
	lsla
	lslb			; sign in C
	rora			; inject
	staa	0,y		; final store
	ldd	11,x		; of full result
	std	2,y
	ldd	13,x
	std	4,y
	ldd	15,x
	std	6,y
fini:
	ldab	#24		; clean-up
	abx			; stack
	txs
	pula			; restore registers
	pulb
	pulx
	rts			; and return
;
;	routines for the veeeeery long multiply
;
cniv2:
	std	BREG		; start multiply
	ldd	14,x		; prepare value
	aluw			; wait for result
	addd	CL		; accumulate
	std	14,x
	ldd	CH
fin2:
	adcb	13,x
	adca	12,x
	std	12,x
	bcc	fin
	inc	11,x
	bne	fin
	inc	10,x
fin:
	rts
;
cniv3:
	std	BREG		; start multiply
	ldd	16,x		; prepare value
	aluw			; wait for result
	addd	CL		; accumulate
	std	16,x
	ldd	CH
fin3:
	adcb	15,x
	adca	14,x
	std	14,x
	bcc	fin
	ldd	#0		; keep carry
	bra	fin2		; and continue
;
cniv4:
	std	BREG		; start multiply
	ldd	18,x		; prepare value
	aluw			; wait for result
	addd	CL		; accumulate
	std	18,x
	ldd	CH
fin4:
	adcb	17,x
	adca	16,x
	std	16,x
	bcc	fin
	ldd	#0		; keep carry
	bra	fin3		; and continue
;
cniv5:
	std	BREG		; start multiply
	ldd	20,x		; prepare value
	aluw			; wait for result
	addd	CL		; accumulate
	std	20,x
	ldd	CH
fin5:
	adcb	19,x
	adca	18,x
	std	18,x
	bcc	fin
	ldd	#0		; keep carry
	bra	fin4		; and continue
;
cniv6:
	clrb
	std	BREG		; start multiply
	ldd	22,x		; prepare value
	aluw			; wait for result
	addd	CL		; accumulate
	std	22,x
	ldd	CH
	adcb	21,x
	adca	20,x
	std	20,x
	bcc	fin
	ldd	#0		; keep carry
	bra	fin5		; and continue
;
	end
