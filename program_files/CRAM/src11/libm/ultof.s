;	UNSIGNED LONG TO FLOAT CONVERSION
;	Copyright (c) 1995 by COSMIC Software
;	- operand in 2,X and D
;
	xdef	c_ultof
	.dcall	"8,0,c_ultof"
;
c_ultof:
	pshx			; save FP
	pshb			; copy operand
	psha
	ldx	2,x
	pshx
	tsx			; stack address
	ldd	0,x		; test against zero
	bne	panul
	tst	2,x
	bne	panul
	tst	3,x
	beq	fini		; nul, finished
panul:
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
	bra	panor		; finished
decal:
	ldab	#23		; startin exponent
bclb:
	incb			; update exponent
	lsra
	ror	1,x		; right shift
	ror	2,x
	ror	3,x
	tsta			; test MSB
	bne	bclb		; and loop back
	tba			; exponent in A
	ldab	1,x		; load first byte
panor:
	lslb			; remove hidden bit
	adda	#127		; add offset
	lsrd			; align exponent
fini:
	ldx	4,x		; load FP
	std	2,x		; store MSW
	pulx			; clean-up stack
	pula			; restore
	pulb			; MSW
	pulx			; restore FP
	rts			; and return
;
	end
