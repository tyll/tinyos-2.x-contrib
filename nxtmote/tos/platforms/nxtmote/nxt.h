#ifndef __NXT_H__
#define __NXT_H__

//// m_shed.h ////
/* Defines related to I2c   */
#define   BYTES_TO_TX                   8
#define   BYTES_TO_RX                   12

enum
{
  NOS_OF_AVR_OUTPUTS  = 4,
  NOS_OF_AVR_BTNS     = 4,
  NOS_OF_AVR_INPUTS   = 4
};

typedef   struct
{
  UWORD   AdValue[NOS_OF_AVR_INPUTS];
  UWORD   Buttons;
  UWORD   Battery;
}IOFROMAVR;

typedef   struct
{
  UBYTE   Power;
  UBYTE   PwmFreq;
  SBYTE   PwmValue[NOS_OF_AVR_OUTPUTS];
  UBYTE   OutputMode;
  UBYTE   InputPower;
}IOTOAVR;

//extern    IOTOAVR IoToAvr;
//extern    IOFROMAVR IoFromAvr;
IOTOAVR   IoToAvr;
IOFROMAVR IoFromAvr;

#endif //__NXT_H__
