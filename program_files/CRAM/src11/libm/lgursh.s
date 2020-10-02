;	UNSIGNED LONG RIGHT SHIFT
;	Copyright (c) 1995 by COSMIC Software
;	- operand address in Y
;	- count in D
;
	xdef	c_lgursh
	.dcall	"2,0,c_lgursh"
;
c_lgursh:
	cmpb	#8		; fast shift ?
	blo	pat		; no, slow
	ldaa	2,y
	staa	3,y
	ldaa	1,y
	staa	2,y
	ldaa	0,y
	staa	1,y
	clr	0,y
	subb	#8		; update counter
	bne	c_lgursh
pat:
	tstb			; test counter
	beq	fini		; nul, no more shift
	ldaa	0,y		; load first byte
decal:
	lsra			; unsigned right shift
	ror	1,y
	ror	2,y
	ror	3,y
	decb			; count down
	bne	decal		; and loop back
	staa	0,y		; store first byte
fini:
	rts			; and return
;
	end
