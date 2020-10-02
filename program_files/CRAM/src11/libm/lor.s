;	LONG BINARY OR
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	xdef	c_lor
	.dcall	"4,0,c_lor"
;
c_lor:
	orab	3,y		; Or LSW
	oraa	2,y
	pshb			; save LSW
	psha
	ldd	2,x		; Or MSW
	orab	1,y
	oraa	0,y
	std	2,x		; store MSW
	pula			; restore LSW
	pulb
	rts			; and return
;
	end
