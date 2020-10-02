;	FLOAT DIVIDE
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	xdef	c_fdiv
	.dcall	"18,0,c_fdiv"
;
c_fdiv:
	pshx			; save FP
	pshx			; scratch
	pshx
	pshx
	pshb			; copy 1st operand
	psha
	ldx	2,x
	pshx
	tsx			; stack address
	ldd	0,x		; test zero
	beq	zero
	ldd	0,y
	bne	panul
zero:
	ldx	10,x		; old FP
	std	2,x
	pulx
	pulx
	bra	fini		; and exit
panul:
	ldx	2,y		; copy 2nd operand
	pshx
	pshb
	psha
	tsx			; stack address
	lsld			; 2nd exponent in A
ifdef CHKEXP
	suba	#127		; remove offset
endif
	staa	11,x		; store
	ldd	4,x		; 1st exponent
	lsld			; in A
ifdef CHKEXP
	suba	#127		; remove offset
	suba	11,x		; subtract
	bvc	ovok		; no overflow, continue
	bpl	unflow		; underflow
	ldaa	#$7F		; else saturate
ovok:
else
	suba	11,x		; subtract
endif
	adda	#127		; add offset removed by subtract
	staa	13,x		; saved here
	bset	1,x,#$80	; set hidden bits
	ldd	4,x
	orab	#$80
	eora	0,x		; compute result sign
	staa	12,x		; saved here
	ldaa	#24		; loop counter
	staa	11,x		; set in memory
	clra
	staa	0,x		; for compares
bcl:
	lsl	10,x		; shift result
	rol	9,x
	rol	8,x
	cpd	0,x
	bmi	pasub		; less, continue
	beq	next		; equal, test LSW
	std	4,x		; save MSW
	ldd	6,x		; else start subtract
	subd	2,x
	bra	sok
next:
	std	4,x		; save MSW
	ldd	6,x
	subd	2,x		; compare LSW (prepare subtract)
	bhs	sok		; ok, store result
	ldd	4,x		; reload MSW
	bra	pasub		; and continue
sok:
	std	6,x		; store LSW
	ldd	4,x		; compute MSW
	sbcb	1,x
	sbca	0,x
	inc	10,x		; set result bit
pasub:
	lsl	7,x		; shift operand
	rol	6,x
	rolb
	rola
	dec	11,x		; count down
	bne	bcl		; and loop back
	ldd	9,x		; store LSW
	std	6,x
	ldaa	13,x		; exponent
	ldab	8,x		; test normalize
	bmi	panor		; ok, continue
	lsl	7,x		; shift
	rol	6,x
	rolb			; one shift is enough
	deca			; update exponent
ifdef CHKEXP
	cmpa	#$FF		; if underflow
	bne	panor
unflow:
	clra			; clear result
	clrb
	std	6,x		; store LSW
	bra	okv		; and exit
endif
panor:
	lslb			; align
	lsl	12,x		; get sign
	rora			; in place
	rorb			; align result
okv:
	ldx	14,x		; load FP
	std	2,x		; and store MSW
	pulx			; clean-up stack
	pulx
	pulx
	pula			; LSW
	pulb
fini:
	pulx			; complete clean-up
	pulx
	pulx
	pulx			; restore FP
	rts			; and return
;
	end
