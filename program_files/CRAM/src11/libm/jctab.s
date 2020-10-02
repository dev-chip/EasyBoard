;	BYTES SWITCH
;	Copyright (c) 1995 by COSMIC Software
;	- operand in D
;	- address list after the call
;
	xdef	c_jctab
;
c_jctab:
	puly			; table address
	aby			; compute vector
	aby			; address
	ldy	0,y		; load vector
	jmp	0,y		; and branch
;
	end
