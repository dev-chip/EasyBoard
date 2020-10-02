;	FLOAT MULTIPLY WITH ALU
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	include	"alu.mac"
	xdef	c_fmula
	.dcall	"16,0,c_fmula"
;
c_fmula:
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
	suba	#126		; remove offset
	staa	8,x		; store
	ldd	0,x		; 2nd exponent
	bset	1,x,#$80	; set hidden bit
	lsld			; align exponent in A
	adda	8,x		; add (with only one offset)
	staa	8,x		; store exponent
	clr	ALUC		; prepare multiplication
	ldd	1,x		; multiply MSW
	std	AREG
	ldd	5,x
	std	BREG		; start multiply
	ldaa	3,x		; continue with LSB
	ldab	7,x
	mul
	staa	13,x		; keep only MSB
	aluw			; wait for result now
	ldd	CH		; unload result
	std	9,x
	ldd	CL
	std	11,x
	ldd	1,x		; HW * LB
	std	AREG
	ldab	7,x
	bsr	multac		; multiply and accumulate
	ldd	5,x		; LB * HW
	std	AREG
	ldab	3,x
	bsr	multac
	ldab	9,x		; test hidden bit
	bmi	padec		; normalize ok
	lsl	12,x		; shift left result
	rol	11,x
	rol	10,x
	rolb
	dec	8,x		; update exponent
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
	ldx	14,x		; load FP
	std	2,x		; MSW in place
	pula			; LSW
	pulb			; in place
	pulx
fini:
	pulx
	pulx
	pulx			; clean up stack
	pulx
	pulx
	pulx			; restore FP
	rts			; and return
;
;	routine for multiply
;
multac:
	clra			; complete value
	std	BREG		; start multiply
	ldd	12,x		; prepare value
	aluw			; wait for result
	addd	CL		; accumulate result
	std	12,x
	ldd	CH
	adcb	11,x		; with carry
	adca	10,x
	std	10,x
	bcc	mok		; if any
	inc	9,x		; propagate carry
mok:
	rts
;
	end
