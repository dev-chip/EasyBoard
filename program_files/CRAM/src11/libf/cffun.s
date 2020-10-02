;	MATH ASSIST FUNCTIONS
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	__addexp
	xdef	__poly
	xdef	__unpack
	xref	c_fmul, c_fadd
	.dcall	"6,4,__addexp"
	.dcall	"12,6,__poly"
	.dcall	"4,0,__unpack"
	include	"macro.h11"
;
;	float _addexp(n, f)	add to binary exponent
__addexp:
	pshx			; save FP
	pshx			; space for D
	tsx			; use X to address stack
	std	0,x		; save exponent
	ldd	6,x		; test float
	beq	zero		; nul, out
	lsld			; shift to align
	tab
	clra
	addd	0,x		; add exponent
	bgt	ok
	clra			; underflow
	clrb
	ldy	#0
	bra	fini
ok:
	cpd	#255
	ble	ovok		; no overflow
	ldab	#255		; yes, saturate
ovok:
	tba
	clrb
	lsrd			; alignment
	bclr	7,x,#$80	; reset bit pour insertion
	orab	7,x		; insert
zero:
	xgdy			; in place for return
	ldd	8,x		; low word
fini:
	pulx			; clean stack
	pulx			; restore FP
	sty	2,x		; store result
	rts			; and return
;
;	float _poly(table, n, f)	compute polynomial
__poly:
	pshx			; save FP
	pshx			; interm. result
	pshx
	pshx
	tsx
	xgdy			; pointer to array
	ldd	0,y		; copy first element
	std	2,x		; in the result area
	ldd	2,y
	std	4,x
	ldab	#4		; adjust pointer
	aby			; to next element
	sty	0,x		; save pointer
	tsy			; take stack address in Y
	ldab	#12		; move it to double address
	aby
bcl:
	ldd	4,x		; result value
	sty	4,x		; save float address
	jsr	c_fmul		; multiply
	ldy	0,x		; array element
	jsr	c_fadd		; addition
	ldy	4,x		; take back float address
	std	4,x		; save value
	ldd	0,x		; update array
	addd	#4		; to next value
	std	0,x
	dec	11,x		; count
	bne	bcl		; and loop
	pulx			; clean stack
	puly			; restore result
	puld
	pulx			; restore FP
	sty	2,x		; store result
	rts			; and return
;
;	int _unpack(pd)		unpack binary exponent
__unpack:
	pshx			; save FP
	xgdx			; first arg in D
	ldd	0,x		; exponent
	beq	uzero
	lsld			; align
	tab
	clra
	subd	#126		; remove offset
	bclr	0,x,#$40	; update exponent
	bset	0,x,#$3F
	bclr	1,x,#$80
uzero:
	pulx			; restore FP
	rts			; and return
;
	end
