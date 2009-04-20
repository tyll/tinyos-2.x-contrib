#ifndef __M16C62PTIMER_H__
#define __M16C62PTIMER_H__
/*
 * Precations when using Timer A1 and Timer A2.
 * Read hardware manual page 139.
 *
 * Precations when using Timer B2.
 * Read hardware manual page 156.
 */

enum
{
  TMR_TIMER_MODE,
  TMR_COUNTER_MODE,
  TMR_ONE_SHOT_MODE
};


/* Timer mode */
typedef struct
{
  uint8_t output_pulse:1; // TAiMR: MR0 . TAiOUT pin is a pulse output pin if bit is set. No effect on TimerB.
  uint8_t gate_func:2;    // TAiMR: MR1, MR2 [ NO_GATE | TAiIN_LOW | TAiIN_HIGH ] . No effect on TimerB.
  uint8_t count_src:2;    // T*iMR: TCK0, TCK1 [ F1_2 | F8 | F32 | FC32 ]
} st_timer;

// "gate_func"
enum
{
  M16C_TMR_TMR_GF_NO_GATE    = 0x0,
  M16C_TMR_TMR_GF_TAiIN_LOW  = 0x2,
  M16C_TMR_TMR_GF_TAiIN_HIGH = 0x3
};


/* TimerA Counter mode */
typedef struct
{
  uint8_t two_phase_pulse_mode:1;   // Use two phase mode, only availible for timers A2, A3 and A4, will be ignored else.
  // Flags active in two-phase mode
  uint8_t two_phase_processing:1;   // TAiMR: TCK1 [ NORMAL | MULTIPLY_BY_4 ] Only active for Timer A3.

  // Flags active when not using two-phase mode.
  uint8_t output_pulse:1;           // TAIMR: MR0 . TAiOUT is N-channel open drain output when bit is set.
  uint8_t count_rising_edge:1;      // TAiMR: MR1 . Active when event_trigger = TAiIN
  uint8_t up_down_switch:1;         // TAiMR: MR2 [ UDF | TAiOUT ]
  uint8_t up_count:1;               // UDF: TAiUD . Active when up_down_switch = UDF
  uint8_t event_source:2;           // ONSF/TRGS: TAiTG [ TAiIN | TB2 | TA_PREV | TA_NEXT ]

  // Flags active in both modes
  uint8_t operation_type:1;         // TAiMR: TCK0 [ RELOAD | FREE_RUN ]
} sta_counter;

// "operation_type"
enum
{
  M16C_TMR_CTR_OT_RELOAD   = 0x0,
  M16C_TMR_CTR_OT_FREE_RUN = 0x1
};

// "up_down_switch"
enum
{
  M16C_TMR_CTR_UDS_UDF    = 0x0,
  M16C_TMR_CTR_UDS_TAiOUT = 0x1
};

// "two_phase_processing"
enum
{
  M16C_TMR_CTR_TPP_NORMAL        = 0x0,
  M16C_TMR_CTR_TPP_MULTIPLY_BY_4 = 0x1
};


/* TimerA one shot mode. */
typedef struct
{
  uint8_t output_pulse:1;           // TAiMR: MR0 . TAiOUT pin is a pulse output pin if bit is set.
  uint8_t ext_trigger_rising_edge:1;// TAiMR: MR1 . Trigger on rising edge of input signal to TAiIN if bit is set. Active when TAiTG = 00b.
  uint8_t trigger:1;                // TAiMR: MR2 [ TAiOS | TAiTG ]
  uint8_t count_src:2;              // TAiMR: TCK0, TCK1 [ F1_2 | F8 | F32 | FC32 ]
  uint8_t TAiTG_trigger_source:2;   // ONSF/TRGS: TAiTG [ TAiIN | TB2 | TA_PREV | TA_NEXT ]. Active if trigger = TAiTG
} sta_one_shot;

// "trigger"
enum
{
  M16C_TMRA_OS_T_TAiOS = 0x00,
  M16C_TMRA_OS_T_TAiTG = 0x01
};



/* TimerB Counter mode. */
typedef struct
{
  uint8_t count_polarity:2;   // TBiMR: MR0, MR1 [ EXT_FALLING_EDGE | EXT_RISING_EDGE | EXT_BOTH ] . Effective if event_source = TBiIN.
  uint8_t event_source:1;     // TBiMR: TCK1 [ TBiIN | TBj ] . j = i-1, except j = 2 if i = 0 and j = 5 if i = 3.
} stb_counter;

// "counter_polarity"
enum
{
  M16C_TMRB_CTR_CP_EXT_FALLING_EDGE = 0x0,
  M16C_TMRB_CTR_CP_EXT_RISING_EDGE  = 0x1,
  M16C_TMRB_CTR_CP_EXT_BOTH         = 0x2,
};

// "event_source"
enum
{
  M16C_TMRB_CTR_ES_TBiIN = 0x0,
  M16C_TMRB_CTR_ES_TBj   = 0x1
};


/* Common settings */

// TimerA One Shot "TAiTG_trigger_source" , TimerA Counter "event_source"
enum
{
  M16C_TMRA_TES_TAiIN   = 0x0,
  M16C_TMRA_TES_TB2     = 0x1,
  M16C_TMRA_TES_TA_PREV = 0x2,
  M16C_TMRA_TES_TA_NEXT = 0x3
};

// TimerA/B, TimerA One Shot : "count_src"
enum 
{
  M16C_TMR_CS_F1_2 = 0x0,
  M16C_TMR_CS_F8   = 0x1,
  M16C_TMR_CS_F32  = 0x2,
  M16C_TMR_CS_FC32 = 0x3
};

#endif  // __M16C62PTMR_H__
