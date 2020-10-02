;	INTEGER DIVIDE/REMAINDER
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in D
;	- 2nd operand in Y
;
	xdef	c_idiv, c_imod
	.dcall	"7,0,c_idiv"
	.dcall	"7,0,c_imod"
;
;	signed division D/Y
;
c_idiv:
	pshx			; save FP
	des			; scratch cell
	tsx			; stack address
	staa	0,x		; keep and test sign
	bpl	sok1		; positive, continue
	bsr	chsig		; else change sign
sok1:
	xgdx			; 1st operand in X
	xgdy			; 2nd operand in D
	tsta			; stack address in Y
	bpl	sok2		; positive, continue
	bsr	chsig		; else change sign
	com	0,y		; and remember
sok2:
	xgdx			; operands in place
	idiv			; division
	xgdx			; result in D
commun:
	tst	0,y		; test result sign
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
;	signed remainder D/Y
;
c_imod:
	pshx			; save FP
	des			; scratch cell
	tsx			; stack address
	staa	0,x		; keep and test sign
	bpl	sok3		; positive, continue
	bsr	chsig		; else change sign
sok3:
	xgdx			; 1st operand in X
	xgdy			; 2nd operand in D
	tsta			; stack address in Y
	bpl	sok4		; positive, continue
	bsr	chsig		; else change sign (no remember)
sok4:
	xgdx			; operands in place
	idiv			; division
	bra	commun		; common ending
;
	end
