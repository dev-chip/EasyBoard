;	FLOAT MULTIPLY IN MEMORY
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	c_fgmul
	xref	c_fmul, c_lgop
	.dcall	"26,0,c_fgmul"
;
c_fgmul:
	pshx			; save FP
	ldx	#c_fmul		; function address
	jmp	c_lgop		; execute
;
	end
