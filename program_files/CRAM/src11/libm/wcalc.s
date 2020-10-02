;	WINDOW MANAGEMENT FOR 68HC11C0
;	Copyright (c) 1995 by COSMIC Software
;	- this module has to be in a common area
;
	xdef	c_wsavc, c_wcalc, c_descc, c_wretc
;
;	window register
;
MXADR:	equ	$44
;
;	save previous descriptor and open space on the stack
;
c_wsavc:
	puly			; return address
	ldd	c_descc		; pointer to descriptor
	pshb			; save it
	psha			; for return
	pshx			; room for return address
	ldd	MXADR		; save mapping register
	pshb			; bank info MSB
	sts	c_descc		; new pointer to current desc.
	psha			; bank info LSB
	jmp	0,y		; and return
;
;	call a function through gate pointed by y
;
c_wcalc:
	pshx			; save registers
	pshb
	psha
	tsx			; stack address
	ldd	4,x		; return address
	ldx	c_descc		; get descriptor pointer
	std	2,x		; save in descriptor
	ldd	#c_wretc	; return address
	tsx			; to be stored
	std	4,x		; in the stack
	ldd	0,y		; target address MSB
	subb	2,y		; subtract page extension
	sbca	#0		; propagate carry
	ldy	2,y		; target address
	std	MXADR		; set mapping register
	pula			; restore
	pulb			; registers
	pulx
	jmp	0,y		; and go
;
;	return from a windowed call
;
c_wretc:
	pshx			; room for return address
	pshx			; save registers
	pshb
	psha
	ldx	c_descc		; pointer to descriptor
	ldd	0,x		; previous bank
	std	MXADR		; in place
	ldd	2,x		; return address
	ldx	4,x		; previous descriptor
	stx	c_descc		; in place
	tsx			; stack address
	std	4,x		; return address in place
	pula			; restore registers
	pulb
	pulx
	rts			; and return
;
	switch	.bss
c_descc:
	dc.w	0
;
	end
