;	LONG DIVISION WITH QUOTIENT AND REMAINDER
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	__uldiv
	if	alu
	xref	c_divla
	else
	xref	c_divl
	endif
	.dcall	"14,0,__uldiv"
;
__uldiv:
	pshx			; save FP
	xgdx			; structure address
	pshx			; saved here
	pshx			; open workspace
	pshx
	ldd	0,x		; dividend
	ldx	2,x
	pshx			; on stack
	xgdx
	pshx
	clra
	clrb
	tsx			; stack address
	ldy	8,x		; structure address
	std	0,y		; prepare divisor
	ldd	4,y
	std	2,y
	if	alu
	jsr	c_divla		; operate
	else
	jsr	c_divl		; operate
	endif
	ldd	4,x		; remainder
	ldy	8,x		; structure address
	std	6,y		; in place
	pulx
	stx	0,y		; quotient
	pulx
	stx	2,y		; in place
	pulx			; clean-up stack
	pulx
	pulx
	pulx			; restore FP
	rts			; and return
;
	end
