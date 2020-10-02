;	LONG BINARY AND
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	xdef	c_land
	.dcall	"4,0,c_land"
;
c_land:
	andb	3,y		; And LSW
	anda	2,y
	pshb			; save value
	psha
	ldd	2,x		; And MSW
	andb	1,y
	anda	0,y
	std	2,x
	pula			; restore LSW
	pulb
	rts			; and return
;
	end
