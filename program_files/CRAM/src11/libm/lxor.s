;	LONG BINARY XOR
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	xdef	c_lxor
	.dcall	"4,0,c_lxor"
;
c_lxor:
	eorb	3,y		; Xor LSW
	eora	2,y
	pshb			; save LSW
	psha
	ldd	2,x		; Xor MSW
	eorb	1,y
	eora	0,y
	std	2,x		; store MSW
	pula			; restore LSW
	pulb
	rts			; and return
;
	end
