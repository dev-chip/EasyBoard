;	CHARACTER REVERSE SEARCH IN A STRING
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_strrchr
	.dcall	"6,2,_strrchr"
;
_strrchr:
	pshx			; save FP
	xgdx			; X is the string pointer
	clra			; scratch for result
	psha			; default value is null
	psha
	tsy			; use Y to address stack
	ldab	7,y		; B is the searched char
bcl:
	ldaa	0,x		; test nul
	beq	fin		; nul reached
	cba			; is the same ?
	bne	diff		; no, next
	stx	0,y		; save pointer
diff:
	inx			; next byte
	bra	bcl		; and loop
fin:
	pula			; restore result
	pulb
	pulx			; restore FP
	rts			; and return
;
	end
