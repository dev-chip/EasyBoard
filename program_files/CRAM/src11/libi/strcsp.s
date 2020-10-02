;	STRING END OF SPAN SEARCH
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_strcspn
	.dcall	"6,2,_strcspn"
;
_strcspn:
	pshx			; save FP
	tsy			; use X to address stack
	ldx	4,y		; X is the second pointer
	std	4,y		; save for compute index
	xgdy			; Y is the first pointer
bcl1:
	ldab	0,y		; loop until end of string
	beq	fin1		; nul reached
	pshx			; save it for reuse
bcl2:
	ldaa	0,x		; loop until end of string
	beq	fin2		; nul reached
	inx			; prepare next byte
	cba			; are they equal ?
	bne	bcl2		; no, loop2
fin2:
	pulx			; restore start value
	tsta			; retest last value
	bne	fin1
	iny			; next byte
	bra	bcl1		; and loop
fin1:
	tsx			; address stack
	xgdy			; current first pointer
	subd	4,x		; compute index
	pulx			; restore FP
	rts			; and return
;
	end
