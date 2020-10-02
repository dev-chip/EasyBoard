;	FLOAT TO DOUBLE CONVERSION
;	Copyright (c) 1995 by COSMIC Software
;	- float in 2,X and D
;	- result address in Y
;
	xdef	c_ftod
	.dcall	"9,0,c_ftod"
;
c_ftod:
	pshx			; save registers
	pshb			; copy 1st operand
	psha
	ldx	2,x
	pshx
	tsx			; stack address
	ldd	0,x		; test zero
	bne	panul		; no, continue
zero:
	std	0,y		; yes, zeroe result
	std	2,y
	std	4,y
	std	6,y
	bra	fini		; and exit
panul:
	clra			; clear result LSW
	clrb
	std	4,y
	std	6,y
	ldd	2,x		; copy mantissa
	std	2,y
	ldaa	1,x
	ldab	#3		; 3 right shifts
decal:
	lsra
	ror	2,y
	ror	3,y
	ror	4,y
	decb			; count down
	bne	decal		; and loop back
	psha			; keep in case of same address
	ldd	0,x		; exponent
	lsld			; aligned in A
	tab			; transfered to D
	clra
	addd	#896		; adjust offset
	lsld			; 4 shifts
	lsld
	lsld
	lsld
	brclr	0,x,#$80,sok	; positive, ok
	oraa	#$80		; else set sign
sok:
	std	0,y		; store
	pula			; complete result
	oraa	1,y		; insert
	staa	1,y		; and store
fini:
	pulx			; clean stack
	pula			; restore registers
	pulb
	pulx
	rts			; and return
;
	end
