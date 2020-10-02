;	SIGNED INTEGER RIGHT SHIFT
;	Copyright (c) 1995 by COSMIC Software
;	- value in D
;	- count in Y
;
	xdef	c_irsh
	.dcall	"2,0,c_irsh"
;
c_irsh:
	cpy	#8		; fast shift ?
	blo	pat		; no, slow
	tab			; 8-bit shift
	clra
	tstb			; propagate sign
	bpl	ok
	coma
ok:
	xgdy
	subb	#8		; update counter
	xgdy
pat:
	cpy	#0		; count zero ?
	beq	padec		; yes, exit
bcl:
	asra			; signed right shift
	rorb
	dey			; count down
	bne	bcl		; loop back
padec:
	rts			; and return
;
	end
