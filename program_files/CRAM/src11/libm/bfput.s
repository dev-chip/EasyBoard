;	STORE A LONG BITFIELD
;	Copyright (c) 1998 by COSMIC Software
;	- value in D and 2,X
;	- address in Y
;	- mask follows the call
;
	xdef	c_bfput
	.dcall	"12,0,c_bfput"
;
c_bfput:
	pshy			; save address
	ldy	2,x		; load MSW
	pshx			; save register
	tsx			; X address stack
	pshb			; save LSW
	psha
	ldx	4,x		; mask address
	ldd	2,x		; stack mask
	pshb
	psha
	ldd	0,x
	pshb
	psha
	xgdx			; address in D
	addd	#4		; skip mask
	tsx
	std	10,x		; update return address
	brset	3,x,#1,pok	; no shift if bit 0 set
	ldd	2,x		; load mask LSW
pbcl:
	lsl	5,x		; shift left LSW
	rol	4,x
	xgdy
	rolb			; rotate left MSW
	rola
	xgdy
	lsrd			; shift right mask LSW
	bitb	#1
	beq	pbcl		; until bit 0 set
pok:
	ldd	8,x		; bitfield address
	xgdy			; in Y and MSW in D
	eorb	1,y		; insert bitfield
	eora	0,y
	andb	1,x
	anda	0,x
	eorb	1,y
	eora	0,y
	std	0,y		; MSW in place
	ldd	4,x		; load LSW
	eorb	3,y		; insert bitfield
	eora	2,y
	andb	3,x
	anda	2,x
	eorb	3,y
	eora	2,y
	std	2,y		; LSW in place
	pulx			; clean stack
	pulx
	pulx
	pulx
	puly			; get back pointer
	rts			; and return
;
	end
