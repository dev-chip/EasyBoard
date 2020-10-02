;	WINDOW INITIALIZATION FOR 68HC11K4
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	__wsetup
	xref	__wbase
;
PGAR:	equ	$2D	; Port G Assignment Register
MMSIZ:	equ	$56	; Memory Size Register
MMWBR:	equ	$57	; Memory Window Base Register
;
;	_wsetup()
;
__wsetup:
	ldd	#__wbase	; window base address
	lsra			; align upper bits
	lsra			; for window #1
	lsra			; base address
	lsra
	staa	MMWBR		; init window base
	ldd	#$013F		; all address bits used
	stab	PGAR		; for extended addressing
	staa	MMSIZ		; window #1 is 8K
	rts
;
	end
