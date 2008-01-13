/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 *  This code funded by TX State San Marcos University.  BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * by John Griessen <john@ecosensory.com>
 * Rev 1.0 14 Dec 2007
 */
//  A2d12ch.h
//#ifndef A2D12CH_H
//#define A2D12CH_H

#define BUFFER_SIZE 6   //reconciled with other uses of a2d12ch
#define JIFFIES 0
//default config data
//
#define CONFIG_VREF  REFVOLT_LEVEL_2_5, SHT_SOURCE_ACLK, SHT_CLOCK_DIV_1, SAMPLE_HOLD_4_CYCLES, SAMPCON_SOURCE_SMCLK, SAMPCON_CLOCK_DIV_1

#define CHANNEL1 INPUT_CHANNEL_A0, REFERENCE_VREFplus_AVss
#define CHANNEL2 INPUT_CHANNEL_A1, REFERENCE_VREFplus_AVss
#define CHANNEL3 INPUT_CHANNEL_A2, REFERENCE_VREFplus_AVss
#define CHANNEL4 INPUT_CHANNEL_A3, REFERENCE_VREFplus_AVss
#define CHANNEL5 INPUT_CHANNEL_A4, REFERENCE_VREFplus_AVss
#define CHANNEL6 INPUT_CHANNEL_A5, REFERENCE_VREFplus_AVss
#define CHANNEL7 INPUT_CHANNEL_A6, REFERENCE_VREFplus_AVss
#define CHANNEL8 INPUT_CHANNEL_A7, REFERENCE_VREFplus_AVss


