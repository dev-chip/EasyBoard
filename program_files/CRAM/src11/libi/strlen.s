;	STRING LENGTH
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_strlen
	.dcall	"6,0,_strlen"
;
_strlen:
	pshx			; save FP
	xgdx			; X is pointer
	pshx			; save start value
	dex			; for first time
bcl:
	inx			; next byte
	ldab	0,x		; look for the nul
	bne	bcl		; loop if not found
	xgdx			; pointer in D
	tsx			; address stack
	subd	0,x		; substract starting address
	pulx			; clean stack
	pulx			; restore FP
	rts			; and return
;
	end
