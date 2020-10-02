;	LONG BINARY AND
;	Copyright (c) 1995 by COSMIC Software
;
	xdef	c_lgand
	.dcall	"2,0,c_lgand"
;
c_lgand:
	andb	3,y		; And LSW
	anda	2,y
	std	2,y		; store LSW
	ldd	2,x		; And MSW
	andb	1,y
	anda	0,y
	std	0,y		; store MSW
	rts			; and return
;
	end
