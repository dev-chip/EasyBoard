;	C STARTUP FOR MC68HC11
;	WITH AUTOMATIC DATA INITIALISATION
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_exit, __stext
	xref	_main, __memory, __idesc__, __stack
;
	switch	.bss
__sbss:
svx:
	dc.w	0
sve:
	dc.w	0
;
	switch	.text
__stext:
	ldx	#__idesc__	; descriptor address
	ldy	0,x		; start address of prom data
	inx			; skip address
	inx
ibcl:
	ldaa	0,x		; test flag byte
	beq	zbss		; no more segment
	bpl	nobk		; skip bank
	inx			; info
	inx			; if any
nobk:
	stx	svx		; save pointer
	ldd	3,x		; end address
	std	sve		; in memory
	ldx	1,x		; destination address
dbcl:
	ldab	0,y		; copy from prom
	stab	0,x		; to ram
	inx			; next byte
	iny
	cpy	sve		; last one ?
	bne	dbcl		; no, loop again
	ldx	svx		; reload pointer to desc
	ldab	#5		; size of one entry
	abx			; point to next entry
	bra	ibcl		; and loop
zbss:
	ldx	#__sbss		; start of bss
	bra	loop		; start loop
zbcl:
	staa	0,x		; clear byte
	inx			; next byte
loop:
	cpx	#__memory	; up to the end
	bne	zbcl		; and loop
	lds	#__stack	; initialize stack pointer
	jsr	_main		; execute main
_exit:
	bra	_exit		; and stay here
;
	end
