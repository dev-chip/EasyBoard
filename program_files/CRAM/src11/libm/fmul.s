;	FLOAT MULTIPLY
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	xdef	c_fmul
	.dcall	"16,0,c_fmul"
;
c_fmul:
	pshx			; save FP
	pshx			; scratch
	pshx
	pshx
	pshb			; copy operand
	psha
	ldx	2,x
	pshx
	tsx			; stack address
	ldd	0,y		; test zero
	beq	zero		; yes, clear
	ldd	0,x
	bne	panul		; no, continu
zero:
	ldx	10,x		; load FP
	std	2,x		; store result
	bra	fini		; and exit
panul:
	ldx	2,y		; copy 2nd operand
	pshx
	ldx	0,y
	pshx
	tsx
	bset 	5,x,#$80	; set hidden bit
	lsld			; align exponent in A
ifdef CHKEXP
	suba	#127		; remove offset
else
	suba	#126		; remove offset - 1
endif
	staa	8,x		; store
	ldd	0,x		; 2nd exponent
	bset	1,x,#$80	; set hidden bit
	lsld			; align exponent in A
ifdef CHKEXP
	suba	#127		; remove offset
	adda	8,x		; add exponent
	bvc	ovok		; if no overflow, continue
	bpl	ovzero		; underflow
	ldaa	#$7F		; saturate and continue
ovok:
	adda	#128		; restore offset + 1
else
	adda	8,x		; add (with only one offset)
endif
	staa	8,x		; store exponent
	ldaa	1,x		; multiply MSB
	ldab	5,x
	mul
	std	9,x		; store result
	ldaa	3,x		; multiply LSB
	ldab	7,x
	mul
	staa	13,x		; store only MSB
	clra			; clear remaining result bytes
	clrb
	std	11,x
	ldaa	1,x		; 2nd level (1)
	ldab	6,x
	bsr	cniv2
	ldaa	2,x		; 2nd level (2)
	ldab	5,x
	bsr	cniv2
	ldaa	1,x		; 3rd level (1)
	ldab	7,x
	bsr	cniv3
	ldaa	2,x		; 3rd level (2)
	ldab	6,x
	bsr	cniv3
	ldaa	3,x		; 3rd level (3)
	ldab	5,x
	bsr	cniv3
	ldaa	2,x		; 4th level (1)
	ldab	7,x
	bsr	cniv4
	ldaa	3,x		; 4th level (2)
	ldab	6,x
	bsr	cniv4
	ldab	9,x		; test hidden bit
	bmi	padec		; normalize ok
	lsl	12,x		; shift left result
	rol	11,x
	rol	10,x
	rolb
	dec	8,x		; update exponent
ifdef CHKEXP
	ldaa	8,x		; get exponent
	cmpa	#$FF		; check underflow
	bne	padec
ovzero:
	clra			; clear result
	clrb
	std	0,x		; store LSW
	bra	rokv		; and exit
endif
padec:
	lslb			; remove hidden bit
	ldaa	4,x		; compute result sign
	eora	0,x
	lsla			; sign -> C
	ldaa	8,x		; exponent
	rora			; align
	rorb
	std	4,x		; and store
	ldd	10,x		; LSW
	brclr	12,x,#$80,rok	; simple round up
	orab	#1
rok:
	std	0,x		; save here
	ldd	4,x		; load MSW
rokv:
	ldx	14,x		; load FP
	std	2,x		; MSW in place
	pula			; LSW
	pulb			; in place
	pulx
fini:
	pulx
	pulx
	pulx			; clean-up stack
	pulx
	pulx
	pulx			; restore FP
	rts			; and return
;
;	routines for multiply
;
cniv2:
	mul
	addd	10,x
	std	10,x
	bcc	fin
fin2:
	inc	9,x
fin:
	rts
;
cniv3:
	mul
	addd	11,x
	std	11,x
	bcc	fin
fin3:
	inc	10,x
	beq	fin2
	rts
;
cniv4:
	mul
	addd	12,x
	std	12,x
	bcc	fin
	inc	11,x
	beq	fin3
	rts
;
	end
