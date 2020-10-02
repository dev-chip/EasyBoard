;	LONG TO FLOAT CONVERSION
;	Copyright (c) 1995 by COSMIC Software
;	- operand in 2,X and D
;
	xdef	c_ltof
	.dcall	"8,0,c_ltof"
;
c_ltof:
	pshx			; save FP
	pshb			; copy operand
	psha
	ldx	2,x
	pshx
	tsx			; stack address
	ldd	0,x		; test against zero
	bne	panul
	tst	2,x
	bne	panil
	tst	3,x
	beq	fini		; nul, exit
panil:
	tsta			; test sign
panul:
	bpl	posit		; positive, ok
	coma			; else negate
	comb
	com	2,x
	neg	3,x
	bne	posit
	inc	2,x
	bne	posit
	addd	#1
posit:
	tsta			; test MSB
	bne	decal
	ldaa	#23		; starting exponent
	tstb			; test hidden bit
	bmi	panor		; normalize ok
bcla:
	deca			; update exponent
	lsl	3,x
	rol	2,x		; left shift
	rolb
	bpl	bcla		; loop back
	bra	panor		; and exit
decal:
	stab	1,x		; store in place
	ldab	#23		; starting exponent
bclb:
	incb			; update exponent
	lsra
	ror	1,x		; right shift
	ror	2,x
	ror	3,x
	tsta			; first byte nul ?
	bne	bclb		; no, loop back
	tba			; exponent in A
	ldab	1,x		; load first mantissa byte
panor:
	lslb			; remove hidden bit
	adda	#127		; add offset
	lsrd			; align exponent
fini:
	ldx	4,x		; load FP
	brclr	2,x,#$80,sok	; positive, ok
	oraa	#$80		; else set sign bit
sok:
	std	2,x		; store result
	pulx			; clean stack
	pula			; restore
	pulb			; LSW
	pulx			; restore FP
	rts			; and return
;
	end
