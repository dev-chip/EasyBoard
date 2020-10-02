;	INTEGER LEFT SHIFT
;	Copyright (c) 1995 by COSMIC Software
;	- value in D
;	- count in Y
;
	xdef	c_ilsh
	.dcall	"2,0,c_ilsh"
;
c_ilsh:
	cpy	#8		; fast shift ?
	blo	pat		; no, slow
	tba			; 8-bit shift
	clrb
	xgdy			; update count
	subb	#8		; one byte enough
	xgdy
pat:
	cpy	#0		; count zero ?
	beq	padec		; yes, exit
bcl:
	lsld			; left shift
	dey			; count down
	bne	bcl		; and loop back
padec:
	rts			; return
;
	end
