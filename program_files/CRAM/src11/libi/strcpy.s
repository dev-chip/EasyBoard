;	STRING COPY
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_strcpy
	.dcall	"6,2,_strcpy"
;
_strcpy:
	pshx			; save FP
	tsx			; use X to address stack
	ldy	4,x		; Y is the source pointer
	xgdx			; X is the dest. pointer
	pshx			; save it as return value
bcl:
	ldab	0,y		; take and
	stab	0,x		; put
	beq	fin		; nul reached
	inx			; next byte
	iny
	bra	bcl		; and loop
fin:
	pula			; restore return value
	pulb
	pulx			; restore FP
	rts			; and return
;
	end
