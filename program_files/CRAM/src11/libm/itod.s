;	INTEGER TO DOUBLE CONVERSION
;	Copyright (c) 1995 by COSMIC Software
;	- operand in D
;	- result address in Y
;
	xdef	c_itod
	.dcall	"6,0,c_itod"
;
c_itod:
	pshx			; save registers
	pshb
	psha
	tsx			; stack address
	clra
	clrb			; reset result
	std	0,y
	std	2,y
	std	4,y
	std	6,y
	ldd	0,x		; load value
	beq	fini		; nul, exit
	bpl	posit		; positive, ok
	nega			; else invert
	negb
	sbca	#0
posit:
	std	2,y		; store
	ldd	#20		; start exponent
decal:
	decb			; update exponent
	lsl	3,y		; shift one bit left
	rol	2,y
	rola
	bita	#$10		; test hidden bit
	beq	decal		; not set, loop again
	anda	#$0F		; reset exponent bits
	staa	1,y		; store here
	clra
	addd	#1023		; add offset
	lsld			; align
	lsld
	lsld
	lsld
	brclr	0,x,#$80,sok	; sign positive, ok
	oraa	#$80		; else set sign bit
sok:
	orab	1,y
	std	0,y		; store result
fini:
	pula			; restore registers
	pulb
	pulx
	rts			; and return
;
	end
