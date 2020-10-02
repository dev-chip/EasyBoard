;	FLOAT COMPARE
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	xdef	c_fcmp
	.dcall	"5,0,c_fcmp"
;
c_fcmp:
	pshx			; save FP
	psha			; save MSB
	ldx	2,x		; load MSW
	cpx	0,y		; compare MSW
	bne	chks		; not equal, test signs
	cpd	2,y		; compare LSW
	beq	fini		; equal, finished
	clv			; no overflow with unsigned compare
	tpa			; condition codes
	bhs	uok		; unsigned -> signed conversion
	oraa	#$08		; set sign bit
	bra	chk
uok:
	anda	#$F7		; reset sign bit
	bra	chk
chks:
	tpa			; condition codes
chk:
	xgdx			; test if both signs negative
	anda	0,y
	xgdx
	bpl	sok		; no, test is valid
	eora	#$08		; else invert sign bit
sok:
	tap			; restore condition codes
fini:
	pula			; restore registers
	pulx
	rts			; and return
;
	end
