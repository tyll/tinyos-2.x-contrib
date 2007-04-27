/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */
#ifndef INTERRUPT_TIMER_H
#define INTERRUPT_TIMER_H

void timer_init ( void );

extern volatile int count_timer0_interrupt;
extern volatile int count_timer1_interrupt;


#endif
