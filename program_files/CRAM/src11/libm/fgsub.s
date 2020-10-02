;	FLOAT SUBSTRACT IN MEMORY
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	c_fgsub
	xref	c_fsub, c_lgop
	.dcall	"24,0,c_fgsub"
;
c_fgsub:
	pshx			; save FP
	ldx	#c_fsub		; function address
	jmp	c_lgop		; execute
;
	end
