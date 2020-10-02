;	C STARTUP FOR MC68HC11
;	Copyright (c) 1995 by COSMIC Software
;
;---------------------------------------------------------------*
;								*
;			CSTARTUP.S07				*
;								*
;  This module contains the 6301/68HC11 startup	routine and	*
;  must usually be tailored to suit special hardware needs 	*
;								*
;  Note:  The routine ?SEG_INIT_L07 is now included in CSTARTUP *
;	  The size of stack is set in the link-file		*
;	  The segment INTVEC is declared COMMON			*
;								*
;  Version:	3.30 [IHAW 11/Feb/92]				*
;  Revised:	3.31 [IHAW 07/Jul/92] Bug in stack init		*
;  Revised:	3.32 [IJAR 06/Mar/93] Startup code for K4 added *
;  Revised:	3.33 [JMC 10/02/99] Setup for SP hardware	*
;  Revised:	4.0 [JMC 10/02/16] Setup for EPROM	        *
;---------------------------------------------------------------*	
;---------------------------------------------------------------*
; Defining internal register address                            *
;---------------------------------------------------------------*
padr:	equ $00		;port A data register
padd:	equ $01 	;port A data direction register
pgdr:	equ $02 	;port G data register
pgddr:	equ $03 	;port G data direction register
pbdr:	equ $04 	;port B data register
pfdr:	equ $05 	;port F data register
pcdr:	equ $06 	;port C data register
pcddr:	equ $07 	;port C data direction register
pddr:	equ $08 	;port D data register
pdddr:	equ $09 	;port D data direction register
pedr:	equ $0A 	;port E data register
cforc:	equ $0b 	;Cforc register
oc1m:	equ $0c 	;output compare 1 mask
oc1d:	equ $0d 	;output compare 1 data
tcnt:	equ $0f 	;timer count both
tic1:	equ $11 	;Timer input capture 1 16 bits
tic2:	equ $13 	;Timer input capture 2 16 bits
tic3:	equ $15 	;Timer input capture 3 16 bits
toc1:	equ $17	 	;Timer output compare 1 16 bits
toc2:	equ $19 	;Timer output compare 2 16 bits
toc3:	equ $1b 	;Timer output compare 3 16 bits
toc4:	equ $1d 	;Timer output compare 4 16 bits
ti4o5:	equ $1f 	;Timer input capture 4 and output Compare 5 16 bits
tctl1:	equ $20 	;Timer control 1
tctl2:	equ $21 	;Timer control 2
tmsk1:	equ $22 	;Timer interrupt mask 1
tflg1:	equ $23 	;Timer	interrupt flag 1
tmsk2:	equ $24 	;Timer interrupt mask 2
tflg2:	equ $25 	;Timer interrupt flag 2
pactl:	equ $26 	;Pulse Accumlator Control
pacnt:	equ $27 	;Pulse Accumlator count
spcr:	equ $28 	;Synchronous comms control register
spsr:	equ $29 	;Synchronous comms status register
spdr:	equ $2a 	;Synchronous comms data register
baud:	equ $2b 	;baud rate
sccr1:	equ $2c 	;serial config 1
sccr2:	equ $2d 	;serial config 2
scsr:	equ $2e 	;serial status register
scdr:	equ $2f 	;serial data register
adctl:	equ $30 	;ADC control
adr1:	equ $31 	;ADC channel 1
adr2:	equ $32 	;ADC channel 2
adr3:	equ $33 	;ADC channel 3
adr4:	equ $34 	;ADC channel 4
bprot:	equ $35 	;Block protect EEPROM
opt2:	equ $38 	;System Configuration  Option 2
option:	equ $39 	;System Configuration Option 1
coprst:	equ $3a 	;COP Timer Arm/Reset
pprog:	equ $3b 	;EEPROM programming register
hprio:	equ $3c 	;Highest priority Interrupt register
init:	equ $3d 	;RAM and IO mapping
test1:	equ $3e 	;Factory test
config:	equ $3f 	;EEprom mapping ,COP and EEprom enable
csstrh:	equ $5c 	;Clock Stretching
csctl:	equ $5d 	;Chip select Control
csgadr:	equ $5e 	;General purpose chip select address register
csgsiz:	equ $5f 	;General purpose chip select size register

xdef	_exit, __stext
xref	_main, __memory, __idesc__, __stack
	switch	.bss
	switch	.bss
__sbss:
svx:
	dc.w	0
sve:
	dc.w	0
;---------------------------------------------------------------*
;  __stext - Where the program actually starts			*
;---------------------------------------------------------------*

	switch	.text
__stext:	LDAA  #$00     ;       
		STAA  $103D    ;init register  from Reset, this moves internal register at 0h
		ldaa  #$90
		staa  $39	;Power up ADC
		LDAA  #$00           
		STAA  csgsiz   ;Csgen enabled  External RAM chip set to 32K 
		LDAA  #$00           
		STAA  csgadr   ;Start address of Chip selects
		LDAA  #$05           
		STAA  csctl    ;Csprog enabled External Eprom set to 32K 
		LDS   #$03FF   ;stack at top of internal ram 
 		JSR   delay 	;WAIT 2X COUNT 17FA		
		jsr 	welcome		;Initialise Serial and do Welcome prompt here
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
		lds	#__stack	; initialize stack pointer to external RAM
		cli			;enable interrupts
		jsr	_main		; execute main
_exit: 		jsr bye			; exit stay here
end_loop:	BRA	end_loop
;---------------------------------------------------------------*
;  Welcome message		                                *			
;---------------------------------------------------------------*
welcome:	clr sccr1               ;8 bit data
  		ldaa #$30               ;
  		staa baud               ;9600 baud
  		ldaa #$0c               ;enable tx and Rx no interrupts
  		staa sccr2
		ldx #$0			;Base offset
wloop0:		brclr scsr,x,#$20,wloop1	;Branch to scon if no char rxd
		ldaa scdr
		bra wloop0		; Loop till no rxd chars		
wloop1:		bset sccr2,x,#$01
		bclr sccr2,x,#$01
		ldab #'B'
		jsr mputchar
		ldab #'o'
		jsr mputchar
		ldab #'o'
		jsr mputchar
		ldab #'t'
		jsr mputchar
		ldab #' '
		jsr mputchar
		ldab #'L'
		jsr mputchar
		ldab #'o'
		jsr mputchar
		ldab #'a'
		jsr mputchar
		ldab #'d'
		jsr mputchar
		ldab #'e'
		jsr mputchar
		ldab #'d'
		jsr mputchar
		ldab #$0a
		jsr mputchar
		ldab #$0d
		jsr mputchar
		rts
;---------------------------------------------------------------*
;  Exit message		                                        *			
;---------------------------------------------------------------*
bye:		ldab #'B'
		jsr mputchar
		ldab #'o'
		jsr mputchar
		ldab #'o'
		jsr mputchar
		ldab #'t'
		jsr mputchar
		ldab #' '
		jsr mputchar
		ldab #'S'
		jsr mputchar
		ldab #'t'
		jsr mputchar
		ldab #'o'
		jsr mputchar
		ldab #'p'
		jsr mputchar
		ldab #'p'
		jsr mputchar
		ldab #'e'
		jsr mputchar
		ldab #'d'
		jsr mputchar
		ldab #$0a
		jsr mputchar
		ldab #$0d
		jsr mputchar
		rts		

;---------------------------------------------------------------*
;  General purpose delay used for programming EEprom		*			
;---------------------------------------------------------------*
delay:
	PSHX   		;DELAY           
	LDX   #$0fff  	;Time delay for eeprom       
loop8: 	DEX     	;             
	BNE   loop8          
	PULX                 
	RTS   		; DELAY PROGRAM TO WAIT 
;---------------------------------------------------------------*
;  putchar machine function					*			
;---------------------------------------------------------------*
mputchar:	ldx #$0			;Base offset
		brclr scsr,x,#$20,scon	;Branch to scon if no char rxd
		ldaa scdr		;read rxd char
		cmpa #$13		;compare to Xoff
		bne scon		;if not carry on
scoff:		brclr scsr,x,#$20,*	;Wait for rxd char
		ldaa scdr		;read char
		cmpa #$11		;Is XON
		bne scoff		;repeat till XON
scon:		brclr scsr,x,#$80,*
		stab scdr		;send char in B
		rts
		end











