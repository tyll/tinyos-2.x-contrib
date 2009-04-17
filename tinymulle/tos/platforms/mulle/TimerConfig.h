/**
 * The M16c/62p hardware timer configuration used by Mulle.
 * 
 * STOP MODE ENABLED:
 *   TB0 bridges its tics from the RV8564 to TB2 in TMilli speed.
 *   TA0 and TA1 are used to create a 32 bit counter. TA0 counts
 *   tics from TB2 and TA1 counts TA0 underflows.
 *   TA2 and TA3 are used to create a 32 bit Alarm. TA2 counts
 *   tics from TB2 and TA3 counts TA3 underflows.
 *
 * STOP MODE DISABLED:
 *   TA1 generates TMilli tics.
 *   TA0 is a 16 bit counter that counts tics from TA1.
 *   TA2 is a 16 bit alarm that counts tics from TA1.
 *
 * ALWAYS USED:
 *  NOTE: These timers are turned off when the mcu goes into stop mode.
 *   TB3 generates TMicro tics.
 *   TB4 is a 16 bit TMicro counter that counts tics from TB3.
 *
 * @author Henrik Makitaavola
 */

#ifndef __TIMERCONFIG_H__
#define __TIMERCONFIG_H__

// Use hw timers alone.
#define MILLI32_SOURCE TimerA1
#define MILLI32_SOURCE_CTRL TimerA1Ctrl
#define COUNTER_MILLI32 TimerA0
#define COUNTER_MILLI32_CTRL TimerA0Ctrl
#define ALARM_MILLI32 TimerA2
#define ALARM_MILLI32_CTRL TimerA2Ctrl
// End

// Use the RV8564 chip to generate tics (stop mode enabled).
#define MILLI32_SOURCE1 TimerB0
#define MILLI32_SOURCE1_CTRL TimerB0Ctrl
#define MILLI32_SOURCE2 TimerB1
#define MILLI32_SOURCE2_CTRL TimerB1Ctrl
#define MILLI32_SOURCE3 TimerB2
#define MILLI32_SOURCE3_CTRL TimerB2Ctrl

#define COUNTER_MILLI32_LOW TimerA0
#define COUNTER_MILLI32_LOW_CTRL TimerA0Ctrl
#define COUNTER_MILLI32_HIGH TimerA1
#define COUNTER_MILLI32_HIGH_CTRL TimerA1Ctrl

#define ALARM_MILLI32_LOW TimerA2
#define ALARM_MILLI32_LOW_CTRL TimerA2Ctrl
#define ALARM_MILLI32_HIGH TimerA3
#define ALARM_MILLI32_HIGH_CTRL TimerA3Ctrl
// end

// Common settings.
#define COUNTER_MICRO16_SOURCE TimerB3
#define COUNTER_MICRO16_SOURCE_CTRL TimerB3Ctrl
#define COUNTER_MICRO16 TimerB4
#define COUNTER_MICRO16_CTRL TimerB4Ctrl
// end.
#endif  // __TIMERCONFIG_H__
