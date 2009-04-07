/**
 * The M16c/62p hardware timer configuration used by Mulle
 * together with the RF230 chip.
 * 
 * STOP MODE ENABLED:
 *   TA4 generates a 16 bit TRF230 counter.
 *   TB5 generates a 16 bit TRF230 alarm.
 *
 * STOP MODE DISABLED:
 *   TA4 generates TMicro tics.
 *   TA3 is a 16 bit alarm that counts tics from TA4.
 *

 * @author Henrik Makitaavola
 */
#ifndef __RF230TIMERCONFIG_H__
#define __RF230TIMERCONFIG_H__

// No stop mode.
#define ALARM_MICRO16_SOURCE TimerA4
#define ALARM_MICRO16_SOURCE_CTRL TimerA4Ctrl
#define ALARM_MICRO16 TimerA3
#define ALARM_MICRO16_CTRL TimerA3Ctrl
// End

// Stop mode enabled.
#define COUNTER_RF23016 TimerA4
#define COUNTER_RF23016_CTRL TimerA4Ctrl
#define ALARM_RF23016 TimerB5
#define ALARM_RF23016_CTRL TimerB5Ctrl
// End

#endif  // __RF230TIMERCONFIG_H__
