;	BOUNDED STRING COPY
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_strncpy
	.dcall	"5,4,_strncpy"
;
_strncpy:
	pshx			; save FP
	tsx			; use X to address stack
	ldy	6,x		; count
	ldx	4,x		; X is the source pointer
	xgdy			; Y is the dest. pointer
	pshy			; save it as return value
	tstb			; if low count nul
	beq	high		; skip first loop
rst:
	psha			; save count high byte
bcl:
	ldaa	0,x		; take and
	staa	0,y		; put
	beq	pay		; nul reached, stay here
	inx			; next byte
pay:
	iny
	decb			; decrement low byte count
	bne	bcl		; not nul, ok
	pula			; take back high count
high:
	deca
	bpl	rst		; high byte cross 0 ?
	pula			; restore return value
	pulb
	pulx			; restore FP
	rts			; and return
;
	end
