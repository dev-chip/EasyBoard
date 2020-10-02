;	EEPROM DOUBLE WRITE
;	Copyright (c) 1995 by COSMIC Software
;	- destination address in Y
;	- source address in D
;
	xdef	c_eewrd
	xref	c_eewrc
	.dcall	"13,0,c_eewrd"
;
c_eewrd:
	pshx			; save registers
	pshy
	pshb
	psha
	xgdx			; X points operand
	ldaa	#8		; loop count
bcl:
	ldab	0,x		; read byte
	jsr	c_eewrc		; eeprom write
	inx			; next byte
	iny			; next byte
	deca			; count down
	bne	bcl		; and loop
	pula			; restore registers
	pulb
	puly
	pulx
	rts			; and return
;
	end
