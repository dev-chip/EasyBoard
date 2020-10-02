;	BUFFER COPY WITH OVERLAY CHECK
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_memmove
	.dcall	"7,4,_memmove"
;
_memmove:
	pshx			; save FP
	tsx			; use X to address stack
	ldy	6,x		; count
	pshb			; save address
	psha			; for return
	cpd	4,x		; compare dest addr to source addr
	bhi	back		; higher, copy backward
	ldx	4,x		; source pointer in X
	xgdy			; dest pointer in Y
	tstb			; if low count is nul
	beq	high		; skip first loop
rst:
	psha			; save high count
bcl:
	ldaa	0,x		; take and
	staa	0,y		; put
	iny			; next byte
	inx
	decb			; decrement low byte count
	bne	bcl		; not nul, loop
	pula			; take back high count
high:
	deca			; decrement high byte count
	bpl	rst		; loop if not cross zero
fin:
	pula			; restore return
	pulb			; value
	pulx			; restore FP
	rts			; and return
back:
	addd	6,x		; add count to pointer
	xgdy			; dest ptr in Y
	ldd	4,x		; src pointer
	addd	6,x		; move to the end
	ldx	6,x		; take back count
	xgdx			; src ptr in X
	tstb			; if low count is nul
	beq	highb		; skip first loop
rstb:
	psha			; save high count
bclb:
	dex			; move pointers back
	dey
	ldaa	0,x		; take and
	staa	0,y		; put
	decb			; decrement high byte count
	bne	bclb		; not nul, loop
	pula			; take back high count
highb:
	deca			; decrement high byte count
	bpl	rstb		; loop if not cross zero
	bra	fin		; common end
;
	end
