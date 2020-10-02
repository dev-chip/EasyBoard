;	LONG OPERATION IN MEMORY
;	Copyright (c) 1995 by COSMIC Software
;	- function address in X
;	- 1st operand address in Y
;	- 2nd operand in D and 2,X (saved)
;
	xdef	c_lgop
;
c_lgop:
	pshx			; room for MSW
	pshy			; save pointer
	pshx			; room for internal return
	pshx			; call address in place
	tsx			; stack address
	ldy	8,x		; load FP
	std	8,x		; LSW in place
	ldd	2,y		; load MSW
	std	6,x		; in place
	ldd	#retour		; internal return address
	std	2,x		; in place
	ldx	4,x		; operand address
	ldd	0,x		; load 2nd operand MSW
	std	2,y
	ldd	2,x		; load 2nd operand LSW
	tsx			; stack address
	xgdx			; compute
	addd	#6		; operand address
	xgdy			; in Y
	xgdx			; restore FP and D
	rts			; function call
retour:
	puly			; result address
	std	2,y		; copy result LSW
	ldd	2,x		; copy result MSW
	std	0,y		; in place
	pula			; restore
	pulb			; operand
	std	2,x
	pula
	pulb
	rts			; and return
;
	end
