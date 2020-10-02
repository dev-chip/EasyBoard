;	INTEGER DIVIDE/REMAINDER WITH ALU
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in D
;	- 2nd operand in Y
;
	include	"alu.mac"
	xdef	c_idiva, c_imoda
	.dcall	"4,0,c_idiva"
	.dcall	"4,0,c_imoda"
;
;	signed division D/Y
;
c_idiva:
	bsr	sdiv		; signed division
	ldd	CL		; get quotient
	rts			; and return
;
;	signed remainder D/Y
;
c_imoda:
	bsr	sdiv		; signed division
	ldd	BREG		; get remainder
	rts			; and return
;
sdiv:
	std	CL		; set dividend LSW
	alu	S_IDIV		; division
	clrb			; prepare sign extension
	tsta			; test value
	bpl	sok		; positive, ok
	comb			; else set to FF
sok:
	tba			; set up
	std	CH		; dividend MSW
	sty	AREG		; set divisor and start
	aluw			; wait for completion
	rts			; and return
;
	end
