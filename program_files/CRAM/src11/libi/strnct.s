;	BOUNDED STRING CATENATION
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_strncat
	.dcall	"6,4,_strncat"
;
_strncat:
	pshx			; save FP
	tsx			; use X to address stack
	ldy	4,x		; source pointer
	ldx	6,x		; count
	beq	fin		; nul, exit
	xgdx			; X is the dest. pointer
	pshx			; save it as return value
	dex			; for first time
bcl1:
	inx			; next byte
	tst 	0,x		; search dest nul
	bne	bcl1		; loop if not
	tstb			; if low count nul
	beq	high		; skip first loop
rst:
	psha			; save counter high byte
bcl2:
	ldaa	0,y		; take and
	staa	0,x		; put
	inx			; next byte
	iny
	decb			; decrement count
	bne	bcl2
	pula			; restore high count
high:
	deca
	bpl	rst
	stab	0,x		; add a nul in dest.
	pula			; restore return value
	pulb
fin:
	pulx			; restore FP
	rts			; and return
;
	end
