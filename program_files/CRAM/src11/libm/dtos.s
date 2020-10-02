;	STACK A DOUBLE
;	Copyright (c) 1995 by COSMIC Software
;	- operand address in Y
;
	xdef	c_dtos
;
c_dtos:
	ldd	4,y
	pshb			; copy
	psha
	ldd	2,y
	pshb
	psha
	ldd	0,y
	pshb
	psha
	pshx			; room for return
	pshx			; save FP
	tsx			; address stack
	ldd	10,x		; return address
	std	2,x		; in place
	ldd	6,y
	std	10,x
	pulx			; restore FP
	rts			; and return
;
	end
