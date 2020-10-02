;	INTEGER TO FLOAT CONVERSION
;	Copyright (c) 1995 by COSMIC Software
;	- operand in D
;
	xdef	c_itof
	.dcall	"6,0,c_itof"
;
c_itof:
	pshx			; save FP
	pshx			; scratch
	tsx			; stack address
	std	0,x		; store and test value
	beq	fini		; nul, exit
	bpl	posit		; positive, ok
	nega			; else invert value
	negb
	sbca	#0
posit:
	clr	1,x		; clear result
	tsta			; test MSB
	bne	panul		; not nul, 16-bit shifts
	ldaa	#127+7		; start exponent
	bra	comm		; and continue
panul:
	stab	1,x
	tab			; MSB in B
	ldaa	#127+15		; start exponent
comm:
	tstb			; normalized ?
	bmi	panor		; yes, continue
bcl:
	deca			; update exponent
	lsl	1,x		; shift value
	rolb
	bpl	bcl		; and loop again
panor:
	lslb
	lsrd			; exponent ready
	brclr	0,x,#$80,sok	; positive, ok
	oraa	#$80		; set sign bit
sok:
	ldx	2,x		; load FP
	std	2,x		; store MSW
	ins
	pula			; complete LSW
	clrb
	pulx
	rts			; and return
fini:
	clr	1,x		; clear result
	bra	sok		; and exit
;
	end
