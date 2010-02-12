#ifndef _MDA300_H
#define _MDA300_H

#define UQ_ADC_RESOURCE "mts300.ADC"
#define UQ_DIO_RESOURCE "mts300.DIO"
#define UQ_SHT15_RESOURCE "mts300.SHT15"
#define UQ_ARBITER_RESOURCE "mts300.arbiter"

enum
{
  TOS_SHT15_DATA_POT_ADDR = 0x5A,
  TOS_SHT15_CLK_POT_ADDR = 0x58,
};

// debug leds
//#define _DEBUG_LEDS
#ifdef _DEBUG_LEDS
#define DEBUG_LEDS(X)         X.DebugLeds -> LedsC
#else
#define DEBUG_LEDS(X)         X.DebugLeds -> NoLedsC
#endif
#endif /* _MDA300_H */

