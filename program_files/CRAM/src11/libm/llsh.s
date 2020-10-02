;	LONG LEFT SHIFT
;	Copyright (c) 1995 by COSMIC Software
;	- operand in 2,X and D
;	- count in Y
;
	xdef	c_llsh
	.dcall	"3,0,c_llsh"
;
c_llsh:
	cpy	#8		; fast shift ?
	blo	pat		; no, slow
	pshb
	ldab	3,x
	stab	2,x
	staa	3,x
	pula
	clrb
	xgdy
	subd	#8		; update counter
	xgdy
	bra	c_llsh		; and loop back
pat:
	cpy	#0		; test counter
	beq	fini		; nul, no more shift
decal:
	lslb			; left shift
	rola
	rol	3,x
	rol	2,x
	dey			; count down
	bne	decal		; loop back
fini:
	rts			; and return
;
	end
