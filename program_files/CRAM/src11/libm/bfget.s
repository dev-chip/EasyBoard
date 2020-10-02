;	GET A LONG BITFIELD
;	Copyright (c) 1998 by COSMIC Software
;	- raw value in D and 2,X
;	- mask follows the call
;
	xdef	c_bfget
	.dcall	"12,0,c_bfget"
;
c_bfget:
	pshy			; save register
	ldy	2,x		; load MSW
	pshx			; save register
	tsx			; use X to address stack
	ldx	4,x		; mask address
	pshb			; save LSW
	psha
	ldd	2,x		; stack mask MSW
	pshb
	psha
	ldd	0,x		; stack mask MSW
	pshb
	psha
	xgdx			; address in D
	addd	#4		; skip mask in code
	tsx
	std	10,x		; update return address
	ldd	4,x		; get back LSW
	brset	3,x,#1,gok	; no shift if bit 0 set
gbcl:
	xgdy			; shift right MSW
	lsrd
	xgdy	
	rora			; rotate right LSW
	rorb
	lsr	0,x		; shift right mask
	ror	1,x
	ror	2,x
	ror	3,x
	brclr	3,x,#1,gbcl	; until bit 0 set
gok:
	xgdy			; adjust MSW
	anda	0,x
	andb	1,x
	xgdy			; adjust LSW
	anda	2,x
	andb	3,x
	pulx			; clean stack
	pulx
	pulx
	pulx
	sty	2,x		; store MSW
	puly			; restore register
	rts			; and return
;
	end
