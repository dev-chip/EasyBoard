;	BUFFER COPY
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_memcpy
	.dcall	"7,4,_memcpy"
;
_memcpy:
	pshx			; save FP
	tsx			; use X to address stack
	ldy	6,x		; count
	ldx	4,x		; X is the source pointer
	xgdy			; Y is the dest. pointer
	pshy			; save it as return value
	tstb			; is low count nul ?
	beq	high		; yes, skip first loop
rst:
	psha			; save count high byte
bcl:
	ldaa	0,x		; take and
	staa	0,y		; put
	iny			; next byte
	inx
	decb			; decrement low byte count
	bne	bcl		; not nul, ok
	pula			; take back high count
high:
	deca			; decrement count
	bpl	rst		; high byte cross 0 ?
fin:
	pula			; restore return value
	pulb
	pulx			; restore FP
	rts			; and return
;
	end
