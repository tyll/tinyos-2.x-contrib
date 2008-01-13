/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved.
 *  This code funded by TX State San Marcos University. BSD license full text at:
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * by John Griessen <john@ecosensory.com>
 * Rev 1.0 14 Dec 2007
 */
#ifndef READMOISTURESENSORS_H
#define READMOISTURESENSORS_H

enum {
  ALWAYS_SHUTOFF_MILLI = 180,    // a2d reading delta t after sensors powered.
  ECH2O_WARMUP_MILLI = 80,    // a2d reading delta t after sensors powered.
  TIMER_PERIOD_MILLI = 1000,   // a2d reading period.
//  AM_MOISTURESENSORSMSG is an active message type.  Depends on Makefile
//  BUILD_EXTRA_DEPS=MoistureSensorsMsg.class
//  MoistureSensorsMsg.class:  MoistureSensorsMsg.java
//  and MoistureSensorsMsg.java:
//  see tos/types/AM.h for other basic definitions related.
  AM_MOISTURESENSORSMSG = 6,
  TOS_NODEID = 22
};
typedef nx_struct MoistureSensorsMsg {
  nx_uint16_t nodeid;
  nx_uint16_t adc00; // bank 0, channel 0
  nx_uint16_t adc01; // bank 0, channel 1
  nx_uint16_t adc02; // bank 0, channel 2
  nx_uint16_t adc03; // bank 0, channel 3
  nx_uint16_t adc04; // bank 0, channel 4
  nx_uint16_t adc05; // bank 0, channel 5
  nx_uint16_t adc10; // bank 1, channel 0
  nx_uint16_t adc11; // bank 1, channel 1
  nx_uint16_t adc12; // bank 1, channel 2
  nx_uint16_t adc13; // bank 1, channel 3
  nx_uint16_t adc14; // bank 1, channel 4
  nx_uint16_t adc15; // bank 1, channel 5
  nx_uint16_t timestamp;
} MoistureSensorsMsg;
#endif
