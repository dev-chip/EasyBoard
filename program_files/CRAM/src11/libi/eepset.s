;	CHARACTER FILL BUFFER IN EEPROM
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_eepset
	xref	c_eewrc
	.dcall	"8,4,__eepset"
;
_eepset:
	pshx			; save FP
	tsx			; use X to address stack
	ldy	6,x		; count
	beq	fini		; null, return pointer
	xgdy			; Y is destination, D is count
	ldx	4,x		; X is the filling char
	xgdx			; X is the count, B is char
	pshy			; save for result
bcl:
	jsr	c_eewrc		; fill up
	iny			; next byte
	dex			; count down
	bne	bcl		; and loop
	pula			; restore pointer
	pulb
fini:
	pulx			; restore FP
	rts			; and return
;
	end
