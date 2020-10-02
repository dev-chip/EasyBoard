;	INTEGER MULTIPLY WITH ALU
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in D
;	- 2nd operand in Y
;
	include	"alu.mac"
	xdef	c_imula
	.dcall	"2,0,c_imula"
;
c_imula:
	clr	ALUC		; unsigned multiply
	std	AREG		; A = 1st operand
	sty	BREG		; B = 2nd operand and start
	aluw			; wait completion
	ldd	CL		; load result
	rts			; and return
;
	end
