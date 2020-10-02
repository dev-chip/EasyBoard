;	LONG MULTIPLICATION IN MEMORY WITH ALU
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand address in Y
;	- 2nd operand in 2,X and D
;
	include	"alu.mac"
	xdef	c_lgmula
	.dcall	"4,0,c_lgmula"
;
c_lgmula:
	pshd			; save LSW1
	std	AREG		; A = LSW1
	alu	U_MUL		; multiply
	ldd	0,y
	std	BREG		; B = MSW2 and start
	ldd	2,y		; prepare LSW2
	aluw			; operation complete
	std	AREG		; A = LSW2
	alu	U_MAC		; multiply and add
	ldd	2,x
	std	BREG		; B = MSW1
	aluw			; wait completion
	ldd	CL		; move result LSW
	std	CH		; to result MSW
	clrd			; clear result LSW
	std	CL
	puld			; restore LSW1
	std	AREG		; A = LSW1
	ldd	2,y
	std	BREG		; B = LSW2 and start
	aluw			; operation complete
	ldd	CH		; set up result
	std	0,y		; MSW
	ldd	CL		; and
	std	2,y		; LSW
	ldd	AREG		; restore original value
	rts			; and return
;
	end
