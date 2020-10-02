;	DOUBLE TO FLOAT CONVERSION
;	Copyright (c) 1995 by COSMIC Software
;	- double address in Y
;	- result in 2,X and D
;
	xdef	c_dtof
	.dcall	"8,0,c_dtof"
;
c_dtof:
	pshx			; scratch result
	pshx
	pshx			; save register
	tsx			; stack address
	ldd	0,y		; test zero
	bne	panul		; no, continue
zero:
	std	2,x		; yes, zeroe result
	std	4,x
	bra	fini		; that's it
panul:
	ldd	1,y		; copy mantissa
	oraa	#$10		; set hidden bit
	std	3,x
	ldd	3,y
	staa	5,x		; truncated mantissa
	ldaa	#3		; 3 left shifts
decal:
	lslb			; propagate LSB
	rol	5,x
	rol	4,x
	rol	3,x
	deca			; count down
	bne	decal		; and loop back
	stab	2,x		; keep to round up
	ldd	0,y		; exponent
	anda	#$7F		; reset sign
	lsrd			; 4 shifts
	lsrd
	lsrd
	lsrd
	subd	#896		; convert offsets
	tsta			; test overflow
	beq	nok		; no, ok
	clra
	clrb
	bra	zero		; yes, zeroe result
nok:
	ldaa	2,x 		; last byte
	bpl	rok		; no round up
	inc	5,x		; incremement and propagate
	bne	rok
	inc	4,x
	bne	rok
	inc	3,x
	bne	rok
	sec			; carry, shift
	ror	3,x
	ror	4,x
	ror	5,x
	incb			; update exponent
rok:
	ldaa	0,y		; result sign
	lsla			; in C
	rorb			; exponent + sign + C
	stab	2,x		; first byte in place
	bcs	fini		; test hidden bit
	bclr	3,x,#$80	; reset otherwise
fini:
	pulx			; restore FP
	pula
	pulb
	std	2,x		; MSW in place
	pula
	pulb			; LSW in place
	rts			; and return
;
	end
