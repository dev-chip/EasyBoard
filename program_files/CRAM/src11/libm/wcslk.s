;	WINDOW MANAGEMENT FOR 68HC11K4 STATIC MODE
;	Copyright (c) 1998 by COSMIC Software
;	- this module has to be in a common area
;
	xdef	c_wssvk, c_wcslk
;
;	this symbol defines the window control register used
;
MMCR:	equ	$58		; MM1CR
;
;	save previous descriptor and open space on the stack
;
c_wssvk:
	ldd	c_desck		; pointer to descriptor
	std	3,y		; save it for return
	ldab	MMCR		; extention address
	stab	0,y		; save bank info
	sty	c_desck		; new pointer to current desc.
	rts			; and return
;
;	call a function through gate pointed by y
;
c_wcslk:
	pshx			; save registers
	pshb
	psha
	tsx			; stack address
	ldd	4,x		; return address
	ldx	c_desck		; get descriptor pointer
	std	1,x		; in descriptor
	ldd	#c_wretk	; return address
	tsx			; to be stored
	std	4,x		; in the stack
	ldab	1,y		; bank number
	ldy	2,y		; target address
	lslb			; align for X13 in bit 1
	stab	MMCR		; and switch bank
	pula			; restore
	pulb			; registers
	pulx
	jmp	0,y		; and go
;
;	return from a windowed call
;
c_wretk:
	pshx			; room for return address
	pshx			; save registers
	pshb
	psha
	ldx	c_desck		; pointer to descriptor
	ldab	0,x		; previous bank
	stab	MMCR		; in place
	ldd	1,x		; return address
	ldx	3,x		; previous descriptor
	stx	c_desck		; in place
	tsx			; stack address
	std	4,x		; return address in place
	pula			; restore registers
	pulb
	pulx
	rts			; and return
;
	switch	.bss
c_desck:
	dc.w	0
;
	end
