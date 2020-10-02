;	UNSIGNED INT RIGHT SHIFT
;	Copyright (c) 1995 by COSMIC Software
;	- operand in D
;	- count in Y
;
	xdef	c_ursh
	.dcall	"2,0,c_ursh"
;
c_ursh:
	cpy	#8		; fast shift
	blo	pat		; no, slow
	tab
	clra
	xgdy
	subb	#8		; update counter
	xgdy
pat:
	cpy	#0		; test count
	beq	padec		; nul, no more shift
bcl:
	lsrd			; unsigned right shift
	dey			; count down
	bne	bcl		; and loop back
padec:
	rts			; return
;
	end
