;	UNSIGNED INT TO DOUBLE CONVERSION
;	Copyright (c) 1995 by COSMIC Software
;	- value in D
;	- result address in Y
;
	xdef	c_uitod
	.dcall	"6,0,c_uitod"
;
c_uitod:
	pshx			; save registers
	pshb
	psha
	tsx			; stack address
	clra
	clrb			; clear result
	std	0,y
	std	2,y
	std	4,y
	std	6,y
	ldd	0,x		; load value
	beq	fini		; nul, finished
	std	2,y		; store
	ldd	#20		; starting exponent
decal:
	decb			; update exponent
	lsl	3,y		; left shift
	rol	2,y
	rola
	bita	#$10		; test hidden bit
	beq	decal		; and loop back
	anda	#$0F		; reset exponent bits
	staa	1,y		; store byte
	clra
	addd	#1023		; add offset
	lsld			; align
	lsld
	lsld
	lsld
	orab	1,y
	std	0,y		; store result
fini:
	pula			; restore registers
	pulb
	pulx
	rts			; and return
;
	end
