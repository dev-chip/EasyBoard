;	EEPROM BIT FIELD WRITE
;	Copyright (c) 1995 by COSMIC Software
;	- value in D
;	- bit field address in Y
;	- mask after the call
;
	xdef	c_eewbfb
	xref	c_eewrc
	.dcall	"10,0,c_eewbfb"
;
c_eewbfb:
	pshx			; save FP
	tsx			; stack address
	psha			; save register
	ldx	2,x		; return address
	ldaa	0,x		; load mask
bcl:
	lsra			; align
	bcs	fin		; finished
	lslb			; shift value
	bra	bcl		; and loop back
fin:
	andb	0,x		; mask for insert
	ldaa	0,x		; reload mask
	coma			; invert it
	anda	0,y		; merge remaining part
	aba
	tab			; in B for
	jsr	c_eewrc		; writing
	pula
	pulx			; restore FP
	puly			; return address
	jmp	1,y		; and return
;
	end
