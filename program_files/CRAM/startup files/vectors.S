;	C Vector file FOR MC68HC11
	xdef	 __vectorbase
	xref	__vector0,__vector1,__vector2,__vector3,__vector4
	xref	__vector5,__vector6,__vector7,__vector8,__vector9
	xref	__vector10,__vector11,__vector12,__vector13,__vector14
	xref	__vector15,__vector16,__vector17,__vector18,__vector19
	xref	__vector20
	switch	.text
__vectorbase:

	dc.w	__vector20
	dc.w	__vector19
	dc.w	__vector18
	dc.w	__vector17
	dc.w	__vector16
	dc.w	__vector15
	dc.w	__vector14
	dc.w	__vector13
	dc.w	__vector12
	dc.w	__vector11
	dc.w	__vector10
	dc.w	__vector9
	dc.w	__vector8
	dc.w	__vector7
	dc.w	__vector6
	dc.w	__vector5
	dc.w	__vector4
	dc.w	__vector3
	dc.w	__vector2
	dc.w	__vector1
	dc.w	__vector0	
	end
