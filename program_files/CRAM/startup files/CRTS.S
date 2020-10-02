;	C STARTUP FOR MC68HC11
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	_exit, __stext
	xref	_main, __memory, __stack
;
	switch	.bss
__sbss:
	switch	.text
__stext:
	clra			; reset the bss
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
