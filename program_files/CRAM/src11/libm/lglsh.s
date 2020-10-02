;	LONG LEFT SHIFT
;	Copyright (c) 1995 by COSMIC Software
;	- operand address in Y
;	- count in D
;
	xdef	c_lglsh
	.dcall	"2,0,c_lglsh"
;
c_lglsh:
	cmpb	#8		; fast shift ?
	blo	pat		; no, slow
	ldaa	1,y
	staa	0,y
	ldaa	2,y
	staa	1,y
	ldaa	3,y
	staa	2,y
	clr	3,y
	subb	#8		; update counter
	bne	c_lglsh		; and loop back
pat:
	tstb			; test counter
	beq	fini		; nul, no more shift
	ldaa	0,y		; load first byte
decal:
	lsl	3,y		; left shift
	rol	2,y
	rol	1,y
	rola
	decb			; count down
	bne	decal		; and loop back
	staa	0,y		; store first byte
fini:
	rts			; and return
;
	end
