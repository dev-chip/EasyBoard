;	LONG DIVISION/REMAINDER IN MEMORY WITH ALU
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	c_lgdiva, c_lgudva, c_lgmoda, c_lgumda
	xref	c_ldiva, c_ludva, c_lmoda, c_lumda
	xref	c_lgop
	.dcall  "16,0,c_ldiva"
	.dcall  "16,0,c_lmoda"
	.dcall  "16,0,c_ludva"
	.dcall  "16,0,c_lumda"
;
c_lgdiva:
	pshx			; save FP
	ldx	#c_ldiva	; function address
	jmp	c_lgop		; execute
c_lgudva:
	pshx			; save FP
	ldx	#c_ludva	; function address
	jmp	c_lgop		; execute
c_lgmoda:
	pshx			; save FP
	ldx	#c_lmoda	; function address
	jmp	c_lgop		; execute
c_lgumda:
	pshx			; save FP
	ldx	#c_lumda	; function address
	jmp	c_lgop		; execute
;
	end
