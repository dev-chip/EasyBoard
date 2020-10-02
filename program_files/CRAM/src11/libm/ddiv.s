;	DOUBLE DIVIDE
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand address in Y
;	- 2nd operand address in D
;
	xdef	c_ddiv
	.dcall	"26,0,c_ddiv"
;
c_ddiv:
	pshx			; save registers
	tsx			; open workspace
	xgdx
	pshx			; save 2nd pointer
	subd	#20
	xgdx
	txs
	pshy			; save 1st pointer
	ldy	18,x		; 2nd operand
	ldd	0,y		; copy
	std	0,x
	ldd	2,y
	std	2,x
	ldd	4,y
	std	4,x
	ldd	6,y
	std	6,x
	puly			; 1st operand
	ldd	0,y		; test zero
	beq	zero
	ldd	0,x
	bne	panul
zero:
	std	6,y
	std	4,y
	std	2,y
	bra	fini		; and that's it
panul:
ifdef CHKEXP
	lsld			; remove sign
	andb	#$E0		; reset mantissa
	subd	#32736		; minus offset (1023 << 5)
else
	andb	#$F0		; reset mantissa
endif
	std	16,x		; store it
	ldd	0,y		; 1st exponent
ifdef CHKEXP
	lsld			; remove sign
	andb	#$E0		; reset mantissa
	subd	#32736		; minus offset (1023 << 5)
	subd	16,x		; subtract
	bvc	ovok		; no overflow, continue
	bpl	unflow		; underflow
	ldd	#$7FE0		; else saturate
ovok:
	addd	#32736		; restore offset
	lsrd			; align exponent
else
	andb	#$F0		; reset mantissa
	subd	16,x		; subtract
	addd	#16368		; add offset killed by subtract
	anda	#$7F		; reset sign
endif
	std	16,x		; store in scratch
	bclr	1,x,#$F0	; reset mantissa bits
	bclr	1,y,#$F0
	bset	1,x,#$10	; set hidden bits
	bset	1,y,#$10
	ldaa	0,y		; sign of result
	eora	0,x
	bpl	pok		; positive, ok
	bset	16,x,#$80
pok:
	ldaa	#53		; shift count
	staa	8,x		; in memory
	ldd	1,y		; load MSW
bcl:
	lsl	15,x		; shift result
	rol	14,x
	rol	13,x
	rol	12,x
	rol	11,x
	rol	10,x
	rol	9,x
	cpd	1,x		; compare MSW
	bmi	pasub		; less, continue
	beq	autre		; equal, test LSW
	std	1,y		; save MSW
soust:
	ldab	7,y		; else start subtract
	subb	7,x
	bra	stor
pasub0:
	ldd	1,y		; reload MSW
	bra	pasub		; and continue
autre:
	std	1,y		; save MSW
	ldd	3,y
	cpd	3,x		; compare next
	blo	pasub0		; nothing more
	bne	soust		; not equal, subtract
	ldd	5,y		; idem...
	cpd	5,x
	blo	pasub0
	bne	soust
	ldab	7,y		; last byte
	subb	7,x
	blo	pasub0
stor:
	stab	7,y		; store LSB
	ldd	5,y		; compute MSW
	sbcb	6,x
	sbca	5,x
	std	5,y
	ldd	3,y
	sbcb	4,x
	sbca	3,x
	std	3,y
	ldd	1,y
	sbcb	2,x
	sbca	1,x		; result kept in D
	inc	15,x		; set result bit
pasub:
	lsl	7,y		; shift operand
	rol	6,y
	rol	5,y
	rol	4,y
	rol	3,y
	rolb
	rola
	dec	8,x		; count down
	bne	bcl		; and loop
	ldd	14,x		; store LSW
	std	6,y
	ldd	12,x
	std	4,y
	ldd	10,x
	std	2,y
	ldaa	16,x		; exponent MSB
	ldab	9,x		; test normalized
	bitb	#$10
	bne	panor		; ok, continue
	lsl	7,y		; else shift
	rol	6,y
	rol	5,y
	rol	4,y
	rol	3,y
	rol	2,y
	rolb			; one shift enough
ifdef CHKEXP
	bita	#$7F		; test underflow
	bne	unok
	brclr	17,x,#$F0,unflow
	bra	unok
unflow:
	clra			; clear result
	clrb
	bra	zero		; and exit
unok:
endif
	pshb			; save
	ldab	17,x
	subd	#$10		; update exponent (1 << 4)
	stab	17,x
	pulb
panor:
	andb	#$0F		; mask exponent
	orab	17,x		; insert exponent
fini:
	std	0,y		; and store
	ldab	#18		; clean-up stack
	abx
	txs
	pula			; restore registers
	pulb
	pulx
	rts			; and return
;
	end
