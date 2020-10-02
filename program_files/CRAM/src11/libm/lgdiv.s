;	LONG DIVISION/REMAINDER IN MEMORY
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	c_lgdiv, c_lgudv, c_lgmod, c_lgumd
	xref	c_ldiv, c_ludv, c_lmod, c_lumd
	xref	c_lgop
	.dcall  "26,0,c_lgdiv"
	.dcall  "26,0,c_lgmod"
	.dcall  "24,0,c_lgudv"
	.dcall  "24,0,c_lgumd"
;
c_lgdiv:
	pshx			; save FP
	ldx	#c_ldiv		; function address
	jmp	c_lgop		; execute
c_lgudv:
	pshx			; save FP
	ldx	#c_ludv		; function address
	jmp	c_lgop		; execute
c_lgmod:
	pshx			; save FP
	ldx	#c_lmod		; function address
	jmp	c_lgop		; execute
c_lgumd:
	pshx			; save FP
	ldx	#c_lumd		; function address
	jmp	c_lgop		; execute
;
	end
