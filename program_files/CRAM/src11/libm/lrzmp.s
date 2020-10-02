;	COMPARE A LONG AGAINST ZERO
;	Copyright (c) 1995 by COSMIC Software
;	- operand in 2,X and D
;
	xdef	c_lrzmp
	.dcall	"4,0,c_lrzmp"
;
c_lrzmp:
	pshx			; save FP
	ldx	2,x		; test MSW
	bne	panul		; not nul, ok
	xgdx			; set LSW in X
	inx			; set only
	dex			; Z flag
	xgdx			; restore value
panul:
	pulx			; restore FP
	rts			; and return
;
	end
