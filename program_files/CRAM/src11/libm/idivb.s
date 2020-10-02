;	INTEGER DIVIDE/REMAINDER BY A BYTE
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in D
;	- 2nd operand in code
;
	xdef	c_idivb, c_imodb
	.dcall	"7,0,c_idivb"
	.dcall	"7,0,c_imodb"
;
;	signed division D / [PC]
;
c_idivb:
	pshx			; save FP
	psha			; keep sign
	tsta			; and test it
	bpl	sok1		; positive, continue
	bsr	chsig		; else change sign
sok1:
	tsx			; stack address
	ldx	3,x		; 2nd operand address
	ldx	0,x		; load operand
	xgdx			; 1st operand in X
	tab			; align and
	clra			; zero sign
	xgdx			; operands in place
	idiv			; division
	xgdx			; result in D
commun:
	tsx			; stack address
	inc	4,x		; increment
	bne	rok		; return
	inc	3,x		; address
rok:
	tst	0,x		; test result sign
	ins			; clean up stack
	pulx			; restore FP
	bpl	fins		; nothing else to do
chsig:
	nega			; invert value
	negb
	sbca	#0
fins:
	rts			; and return
;
;	signed remainder D / [PC]
;
c_imodb:
	pshx			; save FP
	psha			; keep sign
	tsta			; and test it
	bpl	sok2		; positive, continue
	bsr	chsig		; else change signe
sok2:
	tsx			; stack address
	ldx	3,x		; 2nd operand address
	ldx	0,x		; load operand
	xgdx			; 1st operand in X
	tab			; align and
	clra			; zero sign
	xgdx			; operands in place
	idiv			; division
	bra	commun		; common ending
;
	end
