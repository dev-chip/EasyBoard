;	UNSIGNED LONG TO DOUBLE CONVERSION
;	Copyright (c) 1995 by COSMIC Software
;	- operand in 2,X and D
;	- result address in Y
;
	xdef	c_ultod
	.dcall	"8,0,c_ultod"
;
c_ultod:
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
	bne	panul
	tst	3,x
	bne	panul
	std	0,y		; clear result
	std	2,y
	std	6,y
	bra	fini		; and exit
panul:
	std	2,y		; store
	clr	6,y		; reset LSW
	clr	7,y
	ldab	#36		; starting exponent
drap:
	tst	2,y		; if nul, fast shift
	bne	dlent		; else slow shift
	ldaa	3,y		; fast byte shift
	staa	2,y
	ldaa	4,y
	staa	3,y
	ldaa	5,y
	staa	4,y
	clr	5,y
	subb	#8
	bra	drap		; loop again
dlent:
	clra			; clear first byte
decal:
	decb			; update exponent
	lsl	5,y		; left shift
	rol	4,y
	rol	3,y
	rol	2,y
	rola
	bita	#$10		; test hidden bit ?
	beq	decal		; no, loop back
	anda	#$0F		; reset exponent bits
	staa	1,y		; store first byte
	clra			; complete exponent
	addd	#1023		; add offset
	lsld			; align
	lsld
	lsld
	lsld
	orab	1,y		; merge mantissa bits
	std	0,y		; store result
fini:
	pulx			; clean-up stack
	pula			; restore registers
	pulb
	pulx
	rts			; and return
;
	end
