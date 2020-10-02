;	VERIFY CHECKSUM
;	Copyright (c) 1999 by COSMIC Software
;
	xdef	__checksum
	xref	__ckdesc__
	.dcall	"2,0,__checksum"
;
__checksum:
	ldx	#__ckdesc__	; descriptor address
	clrb			; crc accumulator
bcld:
	ldaa	0,x		; descriptor flag
	beq	find		; end of list, exit
	bpl	noseg		; check for page info
	inx			; skip it
	inx
noseg:
	ldy	1,x		; code address
bclc:
	addb	#$80		; rotate
	rolb			; crc
	eorb	0,y		; accumulate
	iny			; next byte
	cpy	3,x		; check end of block
	bne	bclc		; no, continue
	xgdx
	addd	#5		; skip to next descriptor
	xgdx
	bra	bcld		; and continue
find:
	comb			; invert value
	eorb	1,x		; result should be zero
	rts			; and return
;
	end
