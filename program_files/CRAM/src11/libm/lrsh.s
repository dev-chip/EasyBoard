;	SIGNED LONG RIGHT SHIFT
;	Copyright (c) 1995 by COSMIC Software
;	- operand in 2,X and D
;	- count in Y
;
	xdef	c_lrsh
	.dcall	"3,0,c_lrsh"
;
c_lrsh:
	cpy	#8		; fast shift ?
	blo	pat		; no, slow
	psha
	ldab	2,x
	ldaa	3,x
	stab	3,x
	clr	2,x
	pulb
	brclr	3,x,#$80,ok	; propagate sign
	com	2,x
ok:
	xgdy
	subd	#8		; update counter
	xgdy
	bra	c_lrsh
pat:
	cpy	#0		; test counter
	beq	fini		; nul, no more shift
decal:
	asr	2,x		; signed left shift
	ror	3,x
	rora
	rorb
	dey			; count down
	bne	decal		; and loop back
fini:
	rts			; return
;
	end
