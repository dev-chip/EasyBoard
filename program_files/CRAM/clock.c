#include <stdio.h> /* real time clock */
void timer(void);    /*Function Prototype for ISR*/
int hours, mins, secs, ticks, times;    /* GLOBAL VARIABLES FOR RETURNING 				VALUES*/
unsigned char *padr, *paddr, *tflg2, *pactl, *tmsk2;
void main()
{
/* Author Mr james Mccarren
Company: Staffordshire University
Functions used: None
Purpose: Simple Real time Clock
Version: 1.0
Modifications: None
*/
	padr = (unsigned char*)0x0;
	paddr = (unsigned char*)0x1;
	tmsk2 = (unsigned char*)0x24;
	tflg2 = (unsigned char*)0x25;
	pactl = (unsigned char*)0x26;
	*paddr = 0xff;   /*Port A all outputs*/
	*pactl = 0x03;   /*Set prescaler to maximum*/
	*tmsk2 = 0x40;   /*Enable RTI interrupt*/
	for (;;)
	{
		if (ticks == 0 && times == 0)         /*print out once a second*/
		{
			printf("%2d:%2d:%2d\r", hours, mins, secs);
			times = 1;
		}
		if (ticks == 1)
			times = 0;
	}
}

@interrupt void timer(void)
/* Author Mr james Mccarren
Company: Staffordshire University
Functions used: None
Purpose: Interrupt service program for real time clock
Version: 1.0
Modifications: None
*/
{
	ticks++;
	if (ticks == 30)
	{
		ticks = 0;
		secs++;
		if (*padr == 0)
		{
			*padr = 0xff;
		}
		else
		{
			*padr = 0x0;
		}
	}
	if (secs == 60)
	{
		secs = 0;
		mins++;
	}
	if (mins == 60)
	{
		mins = 0;
		hours++;
	}
	if (hours == 24)
	{
		hours = 0;
	}
	*tflg2 = 0x40;                      /*Reset RTI flag*/
}
