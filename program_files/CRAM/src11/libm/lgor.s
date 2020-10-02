;	LONG BINARY OR IN MEMORY
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	c_lgor
	.dcall	"2,0,c_lgor"
;
c_lgor:
	orab	3,y		; Or LSW
	oraa	2,y
	std	2,y		; store LSW
	ldd	2,x		; Or MSW
	orab	1,y
	oraa	0,y
	std	0,y		; store MSW
	rts			; and return
;
	end
