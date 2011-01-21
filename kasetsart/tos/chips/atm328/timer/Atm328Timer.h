/*
 * This file contains the configuration constants for the Atmega328
 * clocks and timers.
 *
 * @author Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

#ifndef _H_Atm328Timer_h
#define _H_Atm328Timer_h

//====================== 8 bit Timers ==================================

/*************************************************************/
/* Timer0 Clock Source.  Page 110: ATmega48/88/168 (DOC8161) */
/*************************************************************/
enum {
  ATM328_T0_OFF         = 0x0,
  ATM328_T0_DIV_1       = 0x1,
  ATM328_T0_DIV_8       = 0x2,
  ATM328_T0_DIV_64      = 0x3,
  ATM328_T0_DIV_256     = 0x4,
  ATM328_T0_DIV_1024    = 0x5,
  ATM328_T0_EXT_FALLING = 0x6,
  ATM328_T0_EXT_RISING  = 0x7,
};

/*************************************************************/
/* Timer2 Clock Source.  Page 162: ATmega48/88/168 (DOC8161) */
/*************************************************************/
enum {
  ATM328_T2_OFF         = 0x0,
  ATM328_T2_NORMAL      = 0x1,
  ATM328_T2_DIVIDE_8    = 0x2,
  ATM328_T2_DIVIDE_32   = 0x3,
  ATM328_T2_DIVIDE_64   = 0x4,
  ATM328_T2_DIVIDE_128  = 0x5,
  ATM328_T2_DIVIDE_256  = 0x6,
  ATM328_T2_DIVIDE_1024 = 0x7,
};

/*****************************************************************/
/* TCCR0A - Timer/Counter Control Register A (DOC8161, page 106) */
/*****************************************************************/
typedef union
{
  uint8_t flat;
  struct {
    uint8_t wgm0  : 1;  //!< Waveform generation mode bit 0
    uint8_t wgm1  : 1;  //!< Waveform generation mode bit 1
    uint8_t na    : 2;  //!< Not used
    uint8_t com0b : 2;  //!< Compare match output B
    uint8_t com0a : 2;  //!< Compare match output A
  } bits;
} Atm328_TCCR0A_t;

/*******************************************************************/
/* TCCR0B - Timer/Counter 0 Control Register B (DOC8161, page 109) */
/*******************************************************************/
typedef union
{
  uint8_t flat;
  struct {
    uint8_t cs    : 3;  //!< Clock Source Select
    uint8_t wgm2  : 1;  //!< Waveform generation mode bit 2
    uint8_t na    : 2;  //!< Not used
    uint8_t foc0b : 1;  //!< Force output compare B
    uint8_t foc0a : 1;  //!< Force output compare A
  } bits;
} Atm328_TCCR0B_t;

/************************************************************************/
/* TIMSK0 - Timer/Counter 0 Interrupt Mask Register (DOC8161, page 111) */
/************************************************************************/
typedef union
{
  uint8_t flat;
  struct {
    uint8_t na     : 5;  //!< Not used
    uint8_t ocie0b : 1;  //!< TC0 output compare match B interrupt enable
    uint8_t ocie0a : 1;  //!< TC0 output compare match A interrupt enable
    uint8_t toie0  : 1;  //!< TC0 overflow interrupt enable
  } bits;
} Atm328_TIMSK0_t;

/***********************************************************************/
/* TIFR0 - Timer/Counter 0 Interrupt Flag Register (DOC8161, page 111) */
/***********************************************************************/
typedef union
{
  uint8_t flat;
  struct {
    uint8_t na    : 5;  //!< Not used
    uint8_t ocf0b : 1;  //!< TC0 output compare B match flag
    uint8_t ocf0a : 1;  //!< TC0 output compare A match flag
    uint8_t tov0  : 1;  //!< TC0 overflow flag
  } bits;
} Atm328_TIFR0_t;

/*******************************************************************/
/* TCCR2A - Timer/Counter 2 Control Register A (DOC8161, page 158) */
/*******************************************************************/
typedef union
{
  uint8_t flat;
  struct {
    uint8_t com2a : 2;  //!< Compare match output A mode
    uint8_t com2b : 2;  //!< Compare match output B mode
    uint8_t na    : 2;  //!< Not used
    uint8_t wgm21 : 1;  //!< Waveform generation mode bit 1
    uint8_t wgm20 : 1;  //!< Waveform generation mode bit 0
  } bits;
} Atm328_TCCR2A_t;

/*******************************************************************/
/* TCCR2B - Timer/Counter 2 Control Register B (DOC8161, page 161) */
/*******************************************************************/
typedef union
{
  uint8_t flat; struct {
    uint8_t foc2a : 1;  //!< Force output compare A
    uint8_t foc2b : 1;  //!< Force output compare B
    uint8_t na    : 2;  //!< Not used
    uint8_t wgm22 : 1;  //!< Waveform generation mode bit 2
    uint8_t cs2   : 3;  //!< Clock source
  } bits;
} Atm328_TCCR2B_t;

/************************************************************************/
/* TIMSK2 - Timer/Counter 2 Interrupt Mask Register (DOC8161, page 163) */
/************************************************************************/
typedef union
{
  uint8_t flat;
  struct {
    uint8_t na     : 5;  //!< Not used
    uint8_t ocie2b : 1;  //!< TC2 output compare match B interrupt enable
    uint8_t ocie2a : 1;  //!< TC2 output compare match A interrupt enable
    uint8_t toie2  : 1;  //!< TC2 overflow interrupt enable
  } bits;
} Atm328_TIMSK2_t;

/***********************************************************************/
/* TIFR2 - Timer/Counter 2 Interrupt Flag Register (DOC8161, page 163) */
/***********************************************************************/
typedef union
{
  uint8_t flat;
  struct {
    uint8_t na    : 5;  //!< Not used
    uint8_t ocf2b : 1;  //!< TC2 output compare B match flag
    uint8_t ocf2a : 1;  //!< TC2 output compare A match flag
    uint8_t tov2  : 1;  //!< TC2 overflow flag
  } bits;
} Atm328_TIFR2_t;

#endif //_H_Atm328Timer_h
