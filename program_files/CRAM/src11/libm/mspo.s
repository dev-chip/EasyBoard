;	MOVE SP BACKWARD
;	Copyright (c) 1995 by COSMIC Software
;	- byte size after the call
;
	xdef	c_mspo
;
c_mspo:
	tsy			; stack address
	xgdy			; in D
	puly			; return address
	addd	0,y		; add offset
	xgdy			; transfer new SP
	tys			; in place
	xgdy			; return address in Y
	jmp	2,y		; and return
;
	end
