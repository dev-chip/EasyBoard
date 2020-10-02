;	LONG ADDITION IN MEMORY
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand address in Y
;	- 2nd operand in 2,X and D
;
	xdef	c_lgadd
	.dcall	"2,0,c_lgadd"
;
c_lgadd:
	addd	2,y		; add LSW
	std	2,y		; store LSW
	ldd	2,x		; add MSW
	adcb	1,y		; with carry
	adca	0,y
	std	0,y		; store MSW
	rts			; and return
;
	end
