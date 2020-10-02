;	EEPROM LONG BITFIELD WRITE
;	Copyright (c) 1998 by COSMIC Software
;	- value in D and 2,X
;	- address in Y
;	- mask follows the call
;
	xdef	c_eewbfx
	xref	c_eewrd
	.dcall	"25,0,c_eewrd"
;
c_eewbfx:
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
	std	10,x
	brset	3,x,#1,pok	; no shift if bit 0 set
	ldd	2,x		; mask LSW (not nul)
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
	xgdy			; in Y, MSW in D
	eorb	1,y		; insert bitfield
	eora	0,y
	andb	1,x
	anda	0,x
	eorb	1,y
	eora	0,y
	jsr	c_eewrd		; program MSW
	ldd	4,x		; get back LSW
	iny			; align pointer
	iny
	eorb	1,y		; insert bitfield
	eora	0,y		; align pointer
	andb	1,x
	anda	0,x
	eorb	1,y
	eora	0,y
	jsr	c_eewrd		; program LSW
	pulx			; clean stack
	pulx
	pulx
	pulx
	puly			; restore register
	rts			; and return
;
	end
