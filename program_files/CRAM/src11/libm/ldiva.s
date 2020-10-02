;	LONG DIVIDE/REMAINDER WITH ALU
;	Copyright (c) 1995 by COSMIC Software
;	- 1st operand in 2,X and D
;	- 2nd operand address in Y
;
	include	"alu.mac"
	xdef	c_ldiva, c_ludva, c_lmoda, c_lumda
	xdef	c_divla
	.dcall	"16,0,c_ldiva"
	.dcall	"16,0,c_lmoda"
	.dcall	"16,0,c_ludva"
	.dcall	"16,0,c_lumda"
;
;	unsigned division
;
c_ludva:
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
c_lumda:
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
c_divla:
ldiv:
	ldd	0,x		; load dividend
	std	CH		; in coprocessor
	ldd	2,x
	std	CL
	alu	U_IDIV		; setup division 32 / 16
	ldd	0,y		; divisor MSW
	bne	full		; no, 32 / 32
	ldd	2,y		; divisor
	std	AREG		; start division
	aluw			; wait for completion
	ldd	CH		; copy result
	std	0,x		; in memory
	ldd	CL
	std	2,x
	ldd	BREG		; copy remainder
	std	4,x
	clrd			; clear MSW of remainder
	rts			; and return
full:
	std	AREG		; main division with MSW
	aluw			; wait for completion
	ldd	CH		; get quotient MSW
	std	2,x		; save it
	alu	U_MAC		; prepare multiply and accumulate
	ldd	CL		; set quotient LSW
	std	AREG		; to multiplier
	ldd	BREG		; set remainder
	std	CL		; to 32 bit value
	clrd			; complete
	std	CH		; value
	std	0,x		; and result MSW
	ldd	0,y		; load divisor MSW
	bsr	wneg		; operate and negate result
	ldd	2,x		; get back quotient
	std	AREG		; to multiply
	ldd	2,y		; with divisor LSW
	bsr	wneg		; operate and negate result
	ldd	CL		; start copying result
	std	4,x
	ldd	CH		; test sign
	bpl	dok		; positive, ok
again:
	ldd	2,x		; decrement
	subd	#1		; quotient
	std	2,x
	ldd	4,x		; add to remainder
	addd	2,y		; divisor LSW
	std	4,x
	ldd	CH		; and MSW
	adcb	1,y
	adca	0,y
	std	CH		; store and test sign
	bmi	again		; loop if negative
dok:
	rts			; and return
;
;	start, wait and negate result
;
wneg:
	std	BREG		; start multiply and accu
	aluw			; wait for completion
	ldd	CH		; negate result
	coma
	comb
	std	CH
	ldd	CL		; invert LSW
	coma
	comb
	addd	#1		; plus one
	std	CL
	bcc	wok		; propagate carry
	ldd	CH		; on MSW
	addd	#1
	std	CH
wok:
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
c_ldiva:
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
c_lmoda:
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
