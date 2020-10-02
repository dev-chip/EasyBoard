;	BUFFER COPY TO EEPROM
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_eepcpy
	xref	c_eewrc
	.dcall	"9,4,_eepcpy"
;
_eepcpy:
	pshx			; save FP
	tsx			; use X to address stack
	ldy	6,x		; count
	bne	ok		; not nul, ok
	pulx			; return dest in D
	rts
ok:
	ldx	4,x		; X is the source pointer
	xgdy			; Y is the dest. pointer
	pshy			; save it as return value
rst:
	psha			; save count high byte
	tba			; low count in A
bcl:
	ldab	0,x		; take and
	jsr	c_eewrc		; program it
	iny			; next byte
	inx
	deca			; decrement low byte count
	bne	bcl		; not nul, ok
	clrb			; reset count in B
	pula			; take back high count
	deca			; decrement
	bpl	rst		; high byte cross 0 ?
fin:
	pula			; restore return value
	pulb
	pulx			; restore FP
	rts			; and return
;
	end
