;	BOUNDED STRING COMPARE
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_strncmp
	.dcall	"5,4,_strncmp"
;
_strncmp:
	pshx			; save FP
	tsx			; use X to address stack
	xgdy			; Y is the first pointer
	ldd	6,x		; count
	ldx	4,x		; X is the second pointer
	tstb			; if low count nul
	beq	high		; skip first loop
rst:
	psha			; save high counter
bcl:
	ldaa	0,y		; test end of first string
	suba	0,x		; difference ?
	bne	diff		; yes, exit
	ldaa	0,x		; test nul termination
	beq	diff		; yes, exit
	inx			; next byte
	iny
	decb			; decrement count
	bne	bcl		; and loop
	pula			; take back high count
high:
	deca			; decrement high byte
	bpl	rst		; and loop
	clra			; compare was ok
	pulx			; restore FP
	rts			; and return
diff:
	ins			; clean stack
	clrb			; needed if end reached
	pulx			; restore FP
	rts			; and return
;
	end
