;	SCAN STRING FOR CHARACTER IN SET
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_strpbrk
	.dcall	"6,2,_strpbrk"
;
_strpbrk:
	pshx			; save FP
	tsx			; use X to address stack
	xgdy			; Y is the first pointer
	ldx	4,x		; X is the second pointer
bcl1:
	ldab	0,y		; loop until end of string
	beq	fin1		; nul reached
	pshx			; save it for reuse
bcl2:
	ldaa	0,x		; loop until end of string
	beq	fin2		; nul reached
	inx			; prepare next byte
	cba			; are they equal ?
	bne	bcl2		; no, loop
	xgdy			; return current first pointer
	pulx			; clean stack
	pulx			; restore FP
	rts
fin2:
	pulx			; restore start value
	iny			; next byte
	bra	bcl1		; and loop
fin1:
	clra			; null result
	clrb
	pulx			; restore FP
	rts			; and return
;
	end
