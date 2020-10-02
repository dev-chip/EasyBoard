;	LONG DIVIDE/REMAINDER
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	xdef	c_ldiv, c_ludv, c_lmod, c_lumd
	xdef	c_divl
	.dcall	"16,0,c_ldiv"
	.dcall	"16,0,c_lmod"
	.dcall	"14,0,c_ludv"
	.dcall	"14,0,c_lumd"
;
;	unsigned division
;
c_ludv:
	pshx			; save FP
	bsr	copy		; setup workspace
	tsx			; stack address
	clr	7,x		; clear sign flag
findiv:
	bsr	ldiv		; execute division
	ldy	0,x		; quotient MSW
	ldd	2,x		; quotient LSW
ferm:
        tst     7,x             ; change sign ?
        beq     fok             ; no, ok
        bsr    chsdy           ; else change sign
fok:
	xgdx			; clean-up stack
	addd	#8
	xgdx
	txs
	pulx			; restore FP
	sty	2,x		; store result
	rts			; and return
;
;	unsigned remainder
;
c_lumd:
	pshx			; save FP
	bsr	copy		; setup workspace
	tsx			; stack address
	clr	7,x		; clear sign flag
finres:
	bsr	ldiv		; execute division
	xgdy			; remainder MSW in Y
	ldd	4,x		; remainder LSW
	bra	ferm		; common ending
;
;	setup workspace and copy operand
;
copy:
	pshx			; open space
	pshb			; copy operand
	psha
	ldx	2,x		; pds forts
	pshx
	tsx			; stack address
	ldx	6,x		; return address
	jmp	0,x		; and branch
;
;	long division (X) / (Y)
;	- quotient in 0,X and 2,X
;	- remainder in D and 4,X
;
c_divl:
ldiv:
	ldd	0,y		; optimize ?
	bne	full		; no, full division
	ldd	2,y		; test division by zero
	beq	fini		; zero, exit
	std	4,x		; keep value
	ldd	0,x		; optimize ?
	xgdx			; exchange pointers
	xgdy			; and preserve
	xgdx			; value
	bne	demi		; no opt, half division
	ldd	2,y		; 1st LSW
	ldx	4,y		; 2nd LSW
	idiv			; division 16/16
	stx	2,y		; store quotient
	std	4,y		; remainder LSW
	clra			; clear MSW
	clrb
	std	0,y		; of quotient
restor:
	xgdx			; restore
	xgdy			; pointers
	xgdx
fini:
	rts			; and return
demi:
	ldx	4,y		; divisor LSW
	idiv			; division 16H/16
	pshx			; save quotient MSW
	ldx	4,y		; divisor LSW
	fdiv			; divide remainder
	std	0,y		; keep remainder
	ldd	2,y		; dividend LSW
	stx	2,y		; store quotient LSW
	ldx	4,y		; divisor LSW
	idiv			; divide LSW's
	xgdx			; accumulate quotient
	addd	2,y
	std	2,y		; store result
	xgdx			; restore values
	pulx			; quotient MSW
	bcc	quok		; no carry, skip
	inx			; propagate carry
quok:
	addd	0,y		; accumulate remainder
	stx	0,y		; store quotient MSW
	bcs	over		; too large, subtract
	cpd	4,y		; compare with divisor
	blo	remok		; less than, remainder ok
over:
	subd	4,y		; remove divisor
	ldx	2,y		; increment
	inx			; quotient
	stx	2,y		; LSW
	bne	remok		; if any,
	ldx	0,y		; propagate carry
	inx			; on MSW
	stx	0,y		; store quotient MSW
remok:
	std	4,y		; store remainder LSW
	clra			; clear remainder MSW
	clrb
	bra	restor		; restore pointers and return
full:
	ldaa	#16		; loop counter
	staa	6,x		; in memory
	ldd	0,x		; result MSW
	std	4,x		; in place
	clra
	clrb			; clear result
bcl:
	lsl	3,x		; shift the whole buffer
	rol	2,x
	rol	5,x
	rol	4,x
	rolb
	rola
	cpd	0,y		; compare MSW
	blo	decpt		; less, next loop
	beq	suite		; equal, compare LSW
	std	0,x		; keep result
	ldd	4,x		; subtract LSW
	subd	2,y
soust:
	std	4,x
	ldd	0,x		; subtract MSW
	sbcb	1,y
	sbca	0,y		; keep result here
	inc	3,x		; set result bit
	bra	decpt		; and next loop
suite:
	std	0,x		; save result
	ldd	4,x		; load LSW
	subd	2,y		; subtract
	bhs	soust		; positive, continue
	ldd	0,x		; else load MSW
decpt:
	dec	6,x		; count down
	bne	bcl		; and loop back
	clr	0,x		; clear quotient MSW
	clr	1,x
	rts			; and return
;
;	negate D+Y
;
chsdy:
	xgdy			; start with MSW
	coma			; invert
	comb
	xgdy			; then LSW
	coma			; invert
	comb
	addd	#1		; add one to negate
	bcc	noc		; no carry, exit
	iny			; update MSW
noc:
	rts			; and return
;
;	signed division
;
c_ldiv:
	pshx			; save FP
	bsr	copy		; setup workspace
	tsx			; stack address
	clr	7,x		; clear sign flag
	ldd	0,x		; test sign
	bpl	pok1		; positive, ok
	bsr	chspx		; else negate
	com	7,x		; and remember
pok1:
	ldd	2,y		; load operand
	ldy	0,y		; and test sign
	bpl	pok2		; positive, ok
	bsr	chsdy		; else negate
	com	7,x		; and remember
pok2:
	pshb			; stack value
	psha
	pshy
	tsy			; stack address
	bra	findiv		; and operate
;
;	signed remainder
;
c_lmod:
	pshx			; save FP
	bsr	copy		; setup workspace
	tsx			; stack address
	clr	7,x		; clear sign flag
	ldd	0,x		; test sign
	bpl	pok3		; positive, ok
	bsr	chspx		; else negate
	com	7,x		; and remember
pok3:
	ldd	2,y		; load operand
	ldy	0,y		; and test sign
	bpl	pok4		; positive, ok
	bsr	chsdy		; else negate (no remember)
pok4:
	pshb			; stack value
	psha
	pshy
	tsy			; stack address
	bra	finres		; and operate
;
;	negate long at X
;
chspx:
	coma			; invert MSW
	comb			; (0,X already in D)
	com	2,x		; negate LSW
	neg	3,x
	bne	chok
	inc	2,x
	bne	chok
	addd	#1		; update MSW
chok:
	std	0,x		; store MSW
	rts			; and return
;
	end
