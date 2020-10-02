;	EEPROM WRITE ROUTINES
;	Copyright (c) 1995 by COSMIC Software
;	- eeprom address in Y
;	- value in D and 2,X for longs
;
	xdef	c_eewrc, c_eewrw, c_eewrl
	.dcall	"5,0,c_eewrc"
	.dcall	"10,0,c_eewrw"
	.dcall	"10,0,c_eewrl"
	xdef	_eepera
	.dcall	"5,0,_eepera"
;
;	the following values have to be modified
;	depending on the processor type and speed
;
PPROG:	equ	$103B		; control register
EBASE:	equ	$B600		; eeprom starting address
TWAIT:	equ	$0D06		; wait value for 10ms @2Mhz
;
;	eeprom erase
;
_eepera:
	ldy	#EBASE		; eeprom base address
	des			; for return
	ldaa	#6		; bulk/erase
	bra	prog		; and go...
;
;	program one byte
;
c_eewrc:
	cmpb	0,y		; already there ?
	beq	fin		; yes, exit
	psha			; save register
	tba			; copy value
	anda	0,y		; is erase needed ?
	cba
	beq	suite		; no, direct programming
	ldaa	#$16		; erase/byte
	staa	PPROG
	stab	0,y		; store
	ldaa	#$17		; erase/program
	staa	PPROG
	bsr	waitcl		; wait 10 ms
	cmpb	#$FF		; is value FF ?
	beq	fini		; yes, finished
suite:
	ldaa	#2		; write/byte
prog:
	staa	PPROG
	stab	0,y		; store byte
	inca			; write(bulk)/program
	staa	PPROG		; -> 3 (or 7)
	bsr	waitcl		; wait 10 ms
fini:
	pula			; restore register
fin:
	rts			; and return
;
;	program one word
;
c_eewrw:
	pshy			; save pointer
	pshb			; save LSB
	bra	wrd		; and continue
;
;	program a double word
;
c_eewrl:
	pshy			; save pointer
	pshb			; save LSB
	ldab	2,x		; load MSB
	bsr	c_eewrc		; write it
	iny
	ldab	3,x		; next byte
	bsr	c_eewrc		; write it
	iny
wrd:
	tab			; next byte
	bsr	c_eewrc		; write it
	iny
	pulb			; last byte
	bsr	c_eewrc		; write it
	puly			; restore pointer
	rts			; and return
;
;	wait 10 ms
;
waitcl:
	pshx			; save register
	ldx	#TWAIT		; count value
wbcl:
	dex			; count down
	bne	wbcl		; and loop back
	clra			; reset
	staa	PPROG		; register
	pulx			; restore register
	rts			; and return
;
	end
