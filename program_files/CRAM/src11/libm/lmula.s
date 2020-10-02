;	LONG MULTIPLICATION WITH ALU
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	include	"alu.mac"
	xdef	c_lmula
	.dcall	"4,0,c_lmula"
;
c_lmula:
	pshd			; save LSW1
	clr	ALUC		; unsigned multiply
	std	AREG		; A = LSW1
	ldd	0,y
	bne	mulok		; not nul, operate
	std	CL		; clear result
	ldd	2,y		; prepare LSW2
	bra	next		; and continue
mulok:
	std	BREG		; B = MSW2 and start
	ldd	2,y		; prepare LSW2
	aluw			; operation complete
next:
	std	AREG		; A = LSW2
	alu	U_MAC		; multiply and add
	ldd	2,x
	beq	nomul		; zero, skip
	std	BREG		; B = MSW1 and start
	aluw			; wait completion
nomul:
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
	std	2,x		; MSW
	ldd	CL		; LSW
	rts			; and return
;
	end
