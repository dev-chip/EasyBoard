;	SEARCH FOR SUBSTRING
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_strstr
	.dcall	"8,2,_strstr"
;
_strstr:
	pshx			; save FP
	tsx			; use X to address stack
	ldy	4,x		; Y is the second pointer
	xgdx			; X is the first pointer
	clra			; for result
bcl1:
	ldab	0,x		; check end of string
	beq	fin		; yes, exit with null result
	pshx			; save pointers
	pshy
	bra	strt		; and start loop
bcl2:
	inx			; next byte
	iny
strt:
	ldab	0,y		; loop until
	beq	fin1		; end of string
	cmpb	0,x		; or a difference
	beq	bcl2		; no, continue
	puly			; restore pointers
	pulx
	inx			; prepare next substring
	bra	bcl1		; and loop back
fin1:
	pulx			; clean-up stack
	pulx			; restore starting pointer
	xgdx			; return value
fin:
	pulx			; restore FP
	rts			; and return
;
	end
