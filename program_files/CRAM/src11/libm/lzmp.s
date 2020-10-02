;	COMPARE A LONG IN MEMORY AGAINST ZERO
;	Copyright (c) 1995 by COSMIC Software
;	- operand address in Y
;
	xdef	c_lzmp
	.dcall	"6,0,c_lzmp"
;
c_lzmp:
	pshb			; save register
	psha
	pshx			; save FP
	ldx	2,y		; load LSW
	ldd	0,y		; test MSW
	bne	panul		; not nul, ok
	inx			; set only
	dex			; Z flag
panul:
	pulx			; restore FP
	pula			; restore register
	pulb
	rts			; and return
;
	end
