;	MATH ASSIST FUNCTIONS
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	__addexp
	xdef	__poly
	xdef	__unpack
	xref	c_dmul, c_dadd
	.dcall	"4,12,__addexp"
	.dcall	"6,14,__poly"
	.dcall	"2,0,__unpack"
	include	"macro.h11"
;
;	double _addexp(d, n)	add to binary exponent
__addexp:
	pshx			; save FP
	tsy			; use Y to address stack
	ldx	4,y		; result address
	ldd	6,y		; exponent
	beq	zero		; nul, out
	lsrd			; shift 4 bits
	lsrd
	lsrd
	lsrd
	anda	#7		; mask sign
	addd	14,y		; add exponent
	bgt	ok
	clra			; underflow
	clrb
	std	0,x
	std	2,x
	std	4,x
	std	6,x
	pulx			; restore FP
	rts
ok:
	cpd	#2047
	ble	ovok		; no overflow
	ldd	#2047		; yes, saturate
ovok:
	lsld			; alignment
	lsld
	lsld
	lsld
	stab	0,x		; temp. storage
	ldab	7,y
	andb	#$0F		; mask 4 high bits
	orab	0,x		; insert
zero:
	std	0,x		; and store
	ldd	8,y
	std	2,x
	ldd	10,y
	std	4,x
	ldd	12,y
	std	6,x
	pulx			; restore FP
	rts
;
;	double _poly(d, table, n)	compute polynomial
__poly:
	pshx			; save FP
	tsx			; use X to address stack
	ldy	4,x		; result address
	ldab	#6		; move it to double address
	abx
	pshx			; save pointer
	ldx	8,x		; array address
	ldd	0,x		; copy first element
	std	0,y		; in the result area
	ldd	2,x
	std	2,y
	ldd	4,x
	std	4,y
	ldd	6,x
	std	6,y
	pulx			; restore pointer
	ldd	8,x		; array pointer
bcl:
	xgdx			; double address
	jsr	c_dmul		; multiply
	xgdx			; array address
	addd	#8		; next element
	jsr	c_dadd		; addition
	dec	11,x		; count
	bne	bcl		; and loop
	pulx			; restore FP
	rts			; and return
;
;	int _unpack(pd)	unpack binary exponent
__unpack:
	xgdy			; first arg in D
	ldd	0,y		; exponent
	beq	uzero
	lsrd			; align
	lsrd
	lsrd
	lsrd
	anda	#7		; remove sign
	subd	#1022		; remove offset
	bclr	0,y,#$7F
	bclr	1,y,#$F0
	bset	0,y,#$3F
	bset	1,y,#$E0
uzero:
	rts
;
	end
