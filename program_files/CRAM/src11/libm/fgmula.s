;	FLOAT MULTIPLY IN MEMORY WITH ALU
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	c_fgmula
	xref	c_fmula, c_lgop
	.dcall	"26,0,c_fgmula"
;
c_fgmula:
	pshx			; save FP
	ldx	#c_fmula	; function address
	jmp	c_lgop		; execute
;
	end
