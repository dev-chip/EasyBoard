;	STACK POINTER CHECKING
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	c_check
	.dcall	"6,0,c_check"
;
c_check:
	pshx			; save X
	pshx			; scratch
	tsx			; stack address
	stx	0,x		; saved in the scratch
	xgdy			; load offset
	addd	0,x		; compute target SP
;
; compare here to the minimum stack value, and if ok...
;
	pulx			; clean up stack
	pulx			; restore FP
	xgdy			; restore D
	rts			; and return
;
; otherwise, the behaviour is application dependant.
;
	end
