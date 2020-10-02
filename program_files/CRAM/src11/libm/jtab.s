;	SWITCH
;	Copyright (c) 1995 by COSMIC Software
;	- value in D
;	- table address after the call
;
	xdef	c_jtab
;
c_jtab:
	puly			; return address
	pshx			; save FP
	pshx			; scratch cell
	pshb			; save value
	psha
	ldx	0,y		; table address
	tsy			; stack address
index:
	ldd	0,x		; number of blocks
	beq	liste		; 0 => list
	ldd	0,y		; load value
	subd	2,x		; compare with starting value
	bmi	bsuiv		; negative, next block
	cpd	0,x		; compare with number of entries
	bhs	bsuiv		; too high, next block
	lsld			; compute vector
	std	2,y		; address
	xgdx
	addd	2,y
	xgdx
ok:
	ldy	4,x		; load vector
	pulx			; clean-up stack
	pulx
	pulx			; restore FP
	jmp	0,y		; and branch
bsuiv:
	ldd	0,x		; number of entries
	lsld			; compute address
	std	2,y		; of next block
	xgdx
	addd	2,y
	addd	#4		; skip two integers
	xgdx
	bra	index		; and try again
liste:
	ldd	2,x		; number of entries
	beq	ok		; no more, default
	ldy	0,y		; load value
	xgdy			; in D, count in Y
encore:
	cpd	6,x		; compare value
	beq	ok		; found, branch
	xgdx			; next entry
	addd	#4
	xgdx
	dey			; count down
	bne	encore		; and loop back
	bra	ok		; jump to default
;
	end
