;	UNSIGNED INT TO FLOAT CONVERSION
;	Copyright (c) 1995 by COSMIC Software
;	- value in D
;	- result address on the stack
;
	xdef	c_uitof
	.dcall	"6,0,c_uitof"
;
c_uitof:
	pshx			; save FP
	pshx			; scratch
	tsx			; stack address
	std	0,x		; save and test value
	beq	fini		; nul, finished
	clr	1,x		; clear first byte
	tsta			; test MSB
	bne	panul		; not nul, 16 bits shift
	ldaa	#127+7		; starting exponent
	bra	comm		; proceed
panul:
	stab	1,x		; store first byte
	tab			; set MSB in B
	ldaa	#127+15		; starting exponent
comm:
	tstb			; normalized ?
	bmi	panor		; yes, continue
bcl:
	deca			; update exponent
	lsl	1,x		; shift left
	rolb
	bpl	bcl		; and loop back
panor:
	lslb
	lsrd			; exponent ready
sok:
	ldx	2,x		; load FP
	std	2,x		; store MSW
	ins
	pula			; restore LSB
	clrb			; complete result
	pulx			; restore FP
	rts			; and return
fini:
	clr	1,x		; clear result
	bra	sok		; and complete result
;
	end
