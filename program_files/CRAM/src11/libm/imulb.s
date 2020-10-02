;	INTEGER MULTIPLY BY A BYTE CONSTANT
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in D
;	- 2nd operand after the call
;
	xdef	c_imulb
	.dcall	"5,0,c_imulb"
;
c_imulb:
	pshx			; save FP
	pshb			; keep LSB
	tsx			; stack address
	ldx	3,x		; byte address
	ldab	0,x		; load byte
	mul			; multiply MSB
	pula			; restore LSB
	pshb			; save result MSB
	ldab	0,x		; reload byte
	mul			; multiply LSB
	tsx			; stack address
	adda	0,x		; complete result
	inc	4,x		; increment
	bne	ok		; return
	inc	3,x		; address
ok:
	ins			; clean stack
	pulx			; restore FP
	rts			; and return
;
	end
