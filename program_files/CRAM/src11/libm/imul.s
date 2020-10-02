;	INTERGER MULTIPLY
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in D
;	- 2nd operand in Y
;
	xdef	c_imul
	.dcall	"8,0,c_imul"
;
c_imul:
	pshx			; save FP
	pshy			; save operands
	pshb
	psha
	tsx			; stack address
	ldab	3,x		; A=DH, B=XL
	mul			; B=RH
	stab	0,x		; store
	ldd	1,x		; A=DL, B=XH (clever, isnt it ?)
	mul			; B=RH
	addb	0,x		; accumulate with previous
	stab	0,x		; not yet finished
	ldaa	1,x		; A=DL
	ldab	3,x		; B=XL
	mul			; D=RHL
	adda	0,x		; complete  resul
	pulx			; clean-up stack
	pulx
	pulx			; restore FP
	rts			; and return
;
	end
