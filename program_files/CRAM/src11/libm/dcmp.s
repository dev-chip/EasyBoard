;	DOUBLE COMPARE
;	Copyright (c) 1995 by COSMIC Software
; 	- 1st operand address in Y
; 	- 2nd operand address in D
;
	xdef c_dcmp
	.dcall	"4,0,c_dcmp"
;
c_dcmp:
	pshx			; save registers
	xgdx			; 2nd operand address in X
	ldd	0,y		; compare MSW
	cpd	0,x
	bne	chks		; not equal, signed test
	ldd	2,y
	cpd	2,x
	bne	chku		; not equal, unsigned test
	ldd	4,y
	cpd	4,x
	bne	chku
	ldd	6,y		; compare LSW
	cpd	6,x
	beq	fini		; equal, finished
chku:
	clv			; no overflow with unsigned
	tpa			; condition codes
	bhs	noch		; unsigned -> signed
	oraa	#$08		; set sign bit
	bra	chk
noch:
	anda	#$F7		; reset sign bit
	bra	chk
chks:
	tpa			; condition codes
chk:
	ldab	0,y		; test if both negative
	andb	0,x
	bpl	pos		; no, test is valid
	eora	#$08		; else invert sign bit
pos:
	tap			; restore condition codes
fini:
	xgdx			; restore registers
	pulx
	rts			; and return
;
	end
