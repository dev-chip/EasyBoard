;	STRING COMPARE
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_strcmp
	.dcall	"4,2,_strcmp"
;
_strcmp:
	pshx			; save FP
	tsx			; use X to address stack
	xgdy			; Y is the first pointer
	ldx	4,x		; X is the second pointer
bcl:
	ldaa	0,y		; test end of first string
	beq	fin		; nul reached
	suba	0,x		; difference ?
	bne	diff		; yes, exit
	inx			; next byte
	iny
	bra	bcl		; and loop
fin:
	suba	0,x		; for a correct result
diff:
	clrb			; in case of null
	pulx			; restore FP
	rts			; and return
;
	end
