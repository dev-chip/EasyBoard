;	UNSIGNED LONG RIGHT SHIFT
;	Copyright (c) 1995 by COSMIC Software
;	- operand in 2,X and D
; 	- count in Y
;
	xdef	c_lursh
	.dcall	"3,0,c_lursh"
;
c_lursh:
	cpy	#8		; fast shift ?
	blo	pat		; no, slow
	psha
	ldab	2,x
	ldaa	3,x
	stab	3,x
	clr	2,x
	pulb
	xgdy
	subd	#8		; update counter
	xgdy
	bra	c_lursh
pat:
	cpy	#0		; test counter
	beq	fini		; nul, no more shift
decal:
	lsr	2,x		; signed right shift
	ror	3,x
	rora
	rorb
	dey			; count down
	bne	decal		; loop back
fini:
	rts			; and return
;
	end
