;	INTEGER MULTIPLY BY 10
;	Copyright (c) 1995 by COSMIC Software
;	- operand in D
;
	xdef	c_imul10
	.dcall	"6,0,c_imul10"
;
c_imul10:
	pshx			; save FP
	pshb			; stack operand
	psha
	lsld			; multiply by 4
	lsld
	tsx			; stack address
	addd	0,x		; +1 -> 5
	lsld			; *2 -> 10
	pulx			; clean-up stack
	pulx			; restore FP
	rts			; and return
;
	end
