;	CHARACTER SEARCH IN A BUFFER
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_memchr
	.dcall	"4,4,_memchr"
;
_memchr:
	pshx			; save FP
	tsx			; use X to address stack
	ldy	6,x		; count
	beq	fin		; nul, exit
	ldx	4,x		; X is the searched char
	xgdx			; X is string, B is char	
bcl:
	cmpb	0,x		; is the same ?
	beq	fnd		; yes, exit
	inx			; next byte
	dey			; count down
	bne	bcl		; and loop
fin:
	ldx	#0		; return a null
fnd:
	xgdx			; pointer as result
	pulx			; restore FP
	rts			; and return
;
	end
