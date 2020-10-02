;	LONG TO DOUBLE CONVERSION
;	Copyright (c) 1995 by COSMIC Software
;	- operand in 2,X and D
;	- result address in Y
;
	xdef	c_ltod
	.dcall	"8,0,c_ltod"
;
c_ltod:
	pshx			; save registers
	pshb			; copy operand
	psha
	ldx	2,x
	pshx
	tsx			; stack address
	std	4,y		; copy mantissa
	ldd	0,x		; test against zero
	bne	panul
	tst	2,x
	bne	panil
	tst	3,x
	bne	panil
	std	0,y		; clear result
	std	2,y
	std	6,y
	bra	fini		; and exit
panil:
	tsta			; test sign
panul:
	bpl	posit		; positive, ok
	coma			; else negate
	comb
	com	4,y
	neg	5,y
	bne	posit
	inc	4,y
	bne	posit
	addd	#1
posit:
	std	2,y		; store result
	clr	6,y		; clear LSW
	clr	7,y
	ldab	#36		; starting exponent
drap:
	tst	2,y		; if nul, fast shift
	bne	dlent		; else slow
	ldaa	3,y		; fast byte shift
	staa	2,y
	ldaa	4,y
	staa	3,y
	ldaa	5,y
	staa	4,y
	clr	5,y
	subb	#8		; update counter
	bra	drap		; loop again
dlent:
	clra			; firts byte
decal:
	decb			; update exponent
	lsl	5,y		; left shift
	rol	4,y
	rol	3,y
	rol	2,y
	rola
	bita	#$10		; test hidden bit
	beq	decal		; loop back
	anda	#$0F		; reset exponent bits
	staa	1,y		; store first byte
	clra			; compute exponent
	addd	#1023		; add offset
	lsld			; align
	lsld
	lsld
	lsld
	brclr	0,x,#$80,sok	; positive, ok
	oraa	#$80		; else set sign bit
sok:
	orab	1,y		; merge mantissa bits
	std	0,y		; and store result
fini:
	pulx			; clean stack
	pula			; restore registers
	pulb
	pulx
	rts			; and return
;
	end
