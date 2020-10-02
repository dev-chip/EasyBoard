;	STRUCTURE COPY
;	Copyright (c) 1995 by COSMIC Software
;	- source address in D
;	- destination address in Y
;	- word size after the call
;
	xdef	c_movstw
	.dcall	"6,0,c_movstw"
;
c_movstw:
	pshx			; save FP
	pshy			; save destination pointer
	tsx			; address stack
	ldx	4,x		; return address
	ldx	0,x		; structure size
	xgdx			; source address in X
	tstb			; test LSB
	beq	next		; nul, skip
bcla:
	psha			; stack counter MSB
bclb:
	ldaa	0,x		; copy source
	staa	0,y		; to destination
	inx			; increment
	iny			; pointers
	decb			; count down
	bne	bclb		; and loop back
	pula			; restore counter MSB
next:
	deca			; count down
	bpl	bcla		; and loop back
	tsx			; address stack
	ldd	4,x		; return address
	addd	#2		; skip size
	std	4,x		; in place
	puly			; restore pointer
	pulx			; restore FP
	rts			; and return
;
	end
