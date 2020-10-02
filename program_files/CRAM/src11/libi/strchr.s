;	CHARACTER SEARCH IN A STRING
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_strchr
	.dcall	"4,2,_strchr"
;
_strchr:
	pshx			; save FP
	tsx			; use X to address stack
	ldx	4,x		; B will be the searched char
	xgdx			; X is the string pointer
bcl:
	ldaa	0,x		; test nul
	beq	fin		; nul reached
	inx			; prepare for next byte
	cba			; is the same ?
	bne	bcl		; no, loop
	dex			; replace correct value
	xgdx			; result is current pointer
	pulx			; restore FP
	rts			; and return
fin:
	clrb			; complete the null result
	pulx			; restore FP
	rts			; and return
;
	end
