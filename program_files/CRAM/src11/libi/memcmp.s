;	BUFFER COMPARE
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_memcmp
	.dcall	"5,4,_memcmp"
;
_memcmp:
	pshx			; save FP
	tsx			; use X to address stack
	xgdy			; Y is the first pointer
	ldd	6,x		; count
	ldx	4,x		; X is the second pointer
	tstb			; if low count nul
	beq	high		; skip first loop
stb:
	psha			; save high counter
bcl:
	ldaa	0,y		; load character
	suba	0,x		; difference ?
	bne	diff		; yes, exit
	inx			; next byte
	iny
	decb			; decrement count
	bne	bcl		; and loop
	pula			; take back high count
high:
	deca			; decrement count
	bpl	stb		; and loop
	clra			; compare was ok
	pulx			; restore FP
	rts
diff:
	rora			; sign is carry
	ins			; clean stack
	pulx			; restore FP
	rts			; and return
;
	end
