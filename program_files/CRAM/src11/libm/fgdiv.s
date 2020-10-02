;	FLOAT DIVIDE IN MEMORY
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	c_fgdiv
	xref	c_fdiv, c_lgop
	.dcall	"28,0,c_fgdiv"
;
c_fgdiv:
	pshx			; save FP
	ldx	#c_fdiv		; function address
	jmp	c_lgop		; execute
;
	end
