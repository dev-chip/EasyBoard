;	STRING CATENATION
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_strcat
	.dcall	"6,2,_strcat"
;
_strcat:
	pshx			; save FP
	tsx			; use X to address stack
	ldy	4,x		; Y is the source pointer
	xgdx			; X is the dest. pointer
	pshx			; save it as return value
	dex			; for first time
bcl1:
	inx			; next byte
	ldab	0,x		; search dest nul
	bne	bcl1		; loop if not found
bcl2:
	ldab	0,y		; take and
	stab	0,x		; put
	beq	fin		; nul reached
	inx			; next byte
	iny
	bra	bcl2		; and loop
fin:
	pula			; restore return value
	pulb
	pulx			; restore FP
	rts			; and return
;
	end
