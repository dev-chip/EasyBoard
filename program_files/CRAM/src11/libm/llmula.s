;	INTEGER MULTIPLY 16 x 16 -> 32 WITH ALU
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in D
;	- 2nd operand in Y
;
	include	"alu.mac"
	xdef	c_slmla, c_ulmla
	.dcall	"2,0,c_slmla"
	.dcall	"2,0,c_ulmla"
;
c_slmla:
	std	AREG		; A = 1st operand
	alu	S_MUL		; prepare signed multiply
	bra	comm		; continue
c_ulmla:
	std	AREG		; A = 1st operand
	alu	U_MUL		; unsigned multiply
comm:
	sty	BREG		; B = 2nd operand and start
	aluw			; wait completion
	ldd	CH		; load result
	std	2,x		; MSW
	ldd	CL		; LSW
	rts			; and return
;
	end
