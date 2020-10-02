;	LONG BINARY XOR IN MEMORY
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	c_lgxor
	.dcall	"2,0,c_lgxor"
;
c_lgxor:
	eorb	3,y		; Xor LSW
	eora	2,y
	std	2,y		; store LSW
	ldd	2,x		; Xor MSW
	eorb	1,y
	eora	0,y
	std	0,y		; store MSW
	rts			; and return
;
	end
