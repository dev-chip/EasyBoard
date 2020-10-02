;	LONG SWITCH
;	Copyright (c) 1995 by COSMIC Software
;	- value in 2,X and D
;	- table address after the call
;
	xdef	c_jltab
;
c_jltab:
	puly			; return address
	pshx			; save FP
	pshx			; scratch
	pshb			; save value
	psha
	ldx	2,x
	pshx
	ldx	0,y		; table address
	tsy			; stack address
index:
	ldd	0,x		; number of blocks
	beq	liste		; 0 => list
	ldd	2,y		; compare value
	subd	4,x		; with starting value
	std	4,y		; save here
	ldd	0,y		; compare MSW
	sbcb	3,x
	sbca	2,x
	bne	bsuiv		; not nul, next block
	tstb
	bne	bsuiv
	ldd	4,y		; compare result with
	cpd	0,x		; with number of entries
	bhs	bsuiv		; too high, next block
	xgdx			; compute
	addd	4,y		; vector
	addd	4,y		; address
	addd	#2		; align
	xgdx
ok:
	ldy	4,x		; load vector
	pulx			; clean-up stack
	pulx
	pulx
	pulx			; restore FP
	jmp	0,y		; and branch
bsuiv:
	ldd	0,x		; number of entries
	lsld			; compute
	std	4,y		; address of
	xgdx			; next block
	addd	4,y
	addd	#6		; skip three integers
	xgdx
	bra	index		; and try again
liste:
	ldd	2,x		; number of entries
	beq	ok		; no entry, default
encore:
	std	4,y		; store here
	ldd	2,y		; compare LSW
	subd	8,x
	bne	pok		; not found, next one
	ldd	0,y		; compare MSW
	subd	6,x
	beq	ok		; found, branch
pok:
	ldab	#6		; skip to
	abx			; next entry
	ldd	4,y		; get count
	subd	#1		; count down
	bne	encore		; and loop back
	bra	ok		; jump to default
;
	end
