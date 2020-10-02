;	CHARACTER FILL BUFFER
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_memset
	.dcall	"6,4,_memset"
;
_memset:
	pshx			; save FP
	tsx			; use X to address stack
	ldy	6,x		; count
	beq	fin		; null, return pointer
	ldx	4,x		; X is the filling char
	xgdx			; X is the string pointer, B is char
	pshx			; save for result
bcl:
	stab	0,x		; fill up
	inx			; next byte
	dey			; count down
	bne	bcl		; and loop
	pula			; restore pointer
	pulb
fin:
	pulx			; restore FP
	rts			; and return
;
	end
