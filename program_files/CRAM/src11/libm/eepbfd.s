;	EEPROM BIT FIELD WORD WRITE
;	Copyright (c) 1995 by COSMIC Software
;	- value in D
;	- bit field address in Y
;	- mask after the call
;
	xdef	c_eewbfd
	xref	c_eewrw
	.dcall	"18,0,c_eewbfb"
;
c_eewbfd:
	pshx			; save FP
	pshb			; save value
	psha
	tsx			; stack address
	ldx	4,x		; return address
	ldx	0,x		; load mask
	pshx			; save it
	tsx
	ldd	0,x		; reload mask
bcl:
	lsra			; shift to
	rorb			; align
	bcs	fin		; finished
	lsl	3,x		; shift value
	rol	2,x
	bra	bcl		; loop back
fin:
	ldd	2,x		; reload value
	anda	0,x		; mask for insert
	andb	1,x
	std	2,x		; store
	ldd	0,x		; load mask
	coma			; invert it
	comb
	anda	0,y		; merge with remaining
	andb	1,y
	oraa	2,x
	orab	3,x
	jsr	c_eewrw		; write
	pulx			; clean-up stack
	pulx
	pulx			; restore FP
	puly			; return address
	jmp	2,y		; and return
;
	end
