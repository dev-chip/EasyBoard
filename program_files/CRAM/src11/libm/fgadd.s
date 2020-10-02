;	FLOAT ADD IN MEMORY
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	c_fgadd
	xref	c_fadd, c_lgop
	.dcall	"24,0,c_fgadd"
;
c_fgadd:
	pshx			; save FP
	ldx	#c_fadd		; function address
	jmp	c_lgop		; execute
;
	end
