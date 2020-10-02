;	STRUCTURE COPY
;	Copyright (c) 1995 by COSMIC Software
;	- source address in D
;	- destination address in Y
;	- byte size after the call
;
	xdef	c_movstb
	.dcall	"6,0,c_movstb"
;
c_movstb:
	pshx			; save FP
	pshy			; save destination pointer
	tsx			; address stack
	ldx	4,x		; return address
	ldx	0,x		; structure size in A
	xgdx			; source address in X
bcl:
	ldab	0,x		; copy source
	stab	0,y		; to destination
	inx			; increment
	iny			; pointers
	deca			; count down
	bne	bcl		; and loop back
	tsx			; address stack
	ldd	4,x		; return address
	addd	#1		; skip size
	std	4,x		; in place
	puly			; restore pointer
	pulx			; restore FP
	rts			; and return
;
	end
