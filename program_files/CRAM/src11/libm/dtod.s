;	DOUBLE COPY
;	Copyright (c) 1995 by COSMIC Software
;	- source address in D
;	- destination address in Y
;
	xdef	c_dtod
	.dcall	"4,0,c_dtod"
;
c_dtod:
	pshx			; save register
	xgdx			; source in X
	ldd	6,x
	std	6,y		; copy...
	ldd	4,x
	std	4,y
	ldd	2,x
	std	2,y
	ldd	0,x
	std	0,y
	xgdx			; restore registers
	pulx			; with flags set
	rts			; and return
;
	end
