; 	DOUBLE MULTIPLY
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand address in Y
;	- 2nd operand address in D
;
	xdef c_dmul
	.dcall	"30,0,c_dmul"
;
c_dmul:
	pshx			; save registers
	tsx			; X points the stack
	xgdx			; open workspace
	pshx			; save 2nd pointer
	subd	#26
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
ifdef CHKEXP
	lsld			; remove sign
	andb	#$E0		; mask mantissa
	subd	#32736		; minus offset (1023 << 5)
else
	andb	#$F0		; mask mantissa
	subd	#16368		; minus offset (1023 << 4)
endif
	std	8,x		; store
	ldd	0,x		; 2nd exponent
	bset	1,x,#$10	; set hidden bit
	bclr	1,x,#$E0	; reset exponent bits
ifdef CHKEXP
	lsld			; remove sign
	andb	#$E0		; mask mantissa
	subd	#32736		; remove offset (1023 << 5)
	addd	8,x		; addition
	bvc	ovok		; no overflow, continue
	bmi	ovflow		; if underflow
	clra
	clrb			; clear result
	bra	zero		; and exit
ovflow:
	ldd	#$7FE0		; else saturate exponent
ovok:
	addd	#32736		; restore offset
	lsrd			; align exponent
else
	andb	#$F0		; mask mantissa
	addd	8,x		; addition (with only one offset)
endif
	std	8,x		; store exponent
	ldaa	1,x		; multiply MSB
	ldab	1,y
	mul
	std	10,x		; store result
	clra			; clear the rest
	clrb
	std	12,x
	std	14,x
	std	16,x
	std	18,x
	std	20,x
	std	22,x
	ldaa	1,x		; 2nd level (1)
	ldab	2,y
	jsr	cniv2
	ldaa	2,x		; 2nd level (2)
	ldab	1,y
	jsr	cniv2
	ldaa	1,x		; 3rd level (1)
	ldab	3,y
	jsr	cniv3
	ldaa	2,x		; 3rd level (2)
	ldab	2,y
	jsr	cniv3
	ldaa	3,x		; 3rd level (3)
	ldab	1,y
	jsr	cniv3
	ldaa	1,x		; 4th level (1)
	ldab	4,y
	jsr	cniv4
	ldaa	2,x		; 4th level (2)
	ldab	3,y
	jsr	cniv4
	ldaa	3,x		; 4th level (3)
	ldab	2,y
	jsr	cniv4
	ldaa	4,x		; 4th level (4)
	ldab	1,y
	jsr	cniv4
	ldaa	1,x		; 5th level (1)
	ldab	5,y
	jsr	cniv5
	ldaa	2,x		; 5th level (2)
	ldab	4,y
	jsr	cniv5
	ldaa	3,x		; 5th level (3)
	ldab	3,y
	jsr	cniv5
	ldaa	4,x		; 5th level (4)
	ldab	2,y
	jsr	cniv5
	ldaa	5,x		; 5th level (5)
	ldab	1,y
	jsr	cniv5
	ldaa	1,x		; 6th level (1)
	ldab	6,y
	jsr	cniv6
	ldaa	2,x		; 6th level (2)
	ldab	5,y
	jsr	cniv6
	ldaa	3,x		; 6th level (3)
	ldab	4,y
	jsr	cniv6
	ldaa	4,x		; 6th level (4)
	ldab	3,y
	jsr	cniv6
	ldaa	5,x		; 6th level (5)
	ldab	2,y
	jsr	cniv6
	ldaa	6,x		; 6th level (6)
	ldab	1,y
	jsr	cniv6
	ldaa	1,x		; 7th level (1)
	ldab	7,y
	jsr	cniv7
	ldaa	2,x		; 7th level (2)
	ldab	6,y
	jsr	cniv7
	ldaa	3,x		; 7th level (3)
	ldab	5,y
	jsr	cniv7
	ldaa	4,x		; 7th level (4)
	ldab	4,y
	jsr	cniv7
	ldaa	5,x		; 7th level (5)
	ldab	3,y
	jsr	cniv7
	ldaa	6,x		; 7th level (6)
	ldab	2,y
	jsr	cniv7
	ldaa	7,x		; 7th level (7)
	ldab	1,y
	jsr	cniv7
	ldaa	2,x		; 8th level (1)
	ldab	7,y
	jsr	cniv8
	ldaa	3,x		; 8th level (2)
	ldab	6,y
	jsr	cniv8
	ldaa	4,x		; 8th level (3)
	ldab	5,y
	jsr	cniv8
	ldaa	5,x		; 8th level (4)
	ldab	4,y
	jsr	cniv8
	ldaa	6,x		; 8th level (5)
	ldab	3,y
	jsr	cniv8
	ldaa	7,x		; 8th level (6)
	ldab	2,y
	jsr	cniv8
	ldaa	3,x		; 9th level (1)
	ldab	7,y
	jsr	cniv9
	ldaa	4,x		; 9th level (2)
	ldab	6,y
	jsr	cniv9
	ldaa	5,x		; 9th level (3)
	ldab	5,y
	jsr	cniv9
	ldaa	6,x		; 9th level (4)
	ldab	4,y
	jsr	cniv9
	ldaa	7,x		; 9th level (5)
	ldab	3,y
	jsr	cniv9
	ldaa	4,x		; 10th level (1)
	ldab	7,y
	jsr	cniv10
	ldaa	5,x		; 10th level (2)
	ldab	6,y
	jsr	cniv10
	ldaa	6,x		; 10th level (3)
	ldab	5,y
	jsr	cniv10
	ldaa	7,x		; 10th level (4)
	ldab	4,y
	jsr	cniv10
	ldaa	5,x		; 11th level (1)
	ldab	7,y
	jsr	cniv11
	ldaa	6,x		; 11th level (2)
	ldab	6,y
	jsr	cniv11
	ldaa	7,x		; 11th level (3)
	ldab	5,y
	jsr	cniv11
	ldaa	6,x		; 12th level (1)
	ldab	7,y
	jsr	cniv12
	ldaa	7,x		; 12th level (2)
	ldab	6,y
	jsr	cniv12
	ldaa	7,x		; 13th level (1)
	ldab	7,y
	jsr	cniv13
	ldaa	#4		; shift count
	brclr	10,x,#2,padec	; test hidden bit
	ldd	8,x		; update exponent
	addd	#$10		; +1 (shifted)
ifdef CHKEXP
	bpl	ovnok		; if overflow
	ldd	#$7FF0		; saturate exponent
ovnok:
endif
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
	mul
	addd	11,x
	std	11,x
	bcc	fin
fin2:
	inc	10,x
fin:
	rts
;
cniv3:
	mul
	addd	12,x
	std	12,x
	bcc	fin
fin3:
	inc	11,x
	beq	fin2
	rts
;
cniv4:
	mul
	addd	13,x
	std	13,x
	bcc	fin
fin4:
	inc	12,x
	beq	fin3
	rts
;
cniv5:
	mul
	addd	14,x
	std	14,x
	bcc	fin
fin5:
	inc	13,x
	beq	fin4
	rts
;
cniv6:
	mul
	addd	15,x
	std	15,x
	bcc	fin
fin6:
	inc	14,x
	beq	fin5
	rts
;
cniv7:
	mul
	addd	16,x
	std	16,x
	bcc	fin
fin7:
	inc	15,x
	beq	fin6
	rts
;
cniv8:
	mul
	addd	17,x
	std	17,x
	bcc	fin
fin8:
	inc	16,x
	beq	fin7
	rts
;
cniv9:
	mul
	addd	18,x
	std	18,x
	bcc	fin
fin9:
	inc	17,x
	beq	fin8
	rts
;
cniv10:
	mul
	addd	19,x
	std	19,x
	bcc	fin
fin10:
	inc	18,x
	beq	fin9
	rts
;
cniv11:
	mul
	addd	20,x
	std	20,x
	bcc	fin
fin11:
	inc	19,x
	beq	fin10
	rts
;
cniv12:
	mul
	addd	21,x
	std	21,x
	bcc	fin
fin12:
	inc	20,x
	beq	fin11
	rts
;
cniv13:
	mul
	addd	22,x
	std	22,x
	bcc	fin
	inc	21,x
	beq	fin12
	rts
;
	end
