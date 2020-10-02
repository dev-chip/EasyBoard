;	EEPROM STRUCTURE WRITE
;	Copyright (c) 1995 by COSMIC Software
;	- source address in D
;	- eeprom address in Y
;	- word size after the call
;
	xdef	c_eewstr
	xref	c_eewrc
	.dcall	"9,0,c_eewstr"
;
c_eewstr:
	pshx			; save FP
	tsx			; stack address
	ldx	2,x		; return address
	ldx	0,x		; structure size
	xgdx			; source address in X
	tstb			; test LSB
	beq	next		; nul, skip
bcla:
	psha			; save counter MSB
	tba			; copy counter
bclb:
	ldab	0,x		; source byte
	jsr	c_eewrc		; eeprom write
	inx			; increment
	iny			; pointers
	deca			; count down
	bne	bclb		; and loop back
	pula			; restore MSB
	clrb			; clear LSB
next:
	deca			; count down
	bpl	bcla		; and loop back
	pulx			; restore FP
	puly			; return address
	jmp	2,y		; and return
;
	end
