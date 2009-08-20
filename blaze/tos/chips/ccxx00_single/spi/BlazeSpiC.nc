/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */


#include "Blaze.h"

/**
 * CCxx00 SPI bus wiring
 * @author Jared Hill
 * @author David Moss
 */
 
configuration BlazeSpiC {

  provides interface RadioInit;
  provides interface ChipSpiResource;
  
  // commands
  provides interface BlazeStrobe as SIDLE;
  provides interface BlazeStrobe as SNOP;
  provides interface BlazeStrobe as STX;
  provides interface BlazeStrobe as SFTX;
  provides interface BlazeStrobe as SRX;
  provides interface BlazeStrobe as SFRX;
  provides interface BlazeStrobe as SRES;
  provides interface BlazeStrobe as SFSTXON;
  provides interface BlazeStrobe as SXOFF;
  provides interface BlazeStrobe as SCAL;
  provides interface BlazeStrobe as SWOR;
  provides interface BlazeStrobe as SPWD;
  provides interface BlazeStrobe as SWORRST;
  
  // registers 
  provides interface BlazeRegister as IOCFG2;
  provides interface BlazeRegister as IOCFG1;
  provides interface BlazeRegister as IOCFG0;
  provides interface BlazeRegister as FIFOTHR;
  provides interface BlazeRegister as SYNC1;
  provides interface BlazeRegister as SYNC0;
  provides interface BlazeRegister as PKTLEN;
  provides interface BlazeRegister as PKTCTRL1;
  provides interface BlazeRegister as PKTCTRL0;
  provides interface BlazeRegister as ADDR;
  provides interface BlazeRegister as CHANNR;
  provides interface BlazeRegister as FSCTRL1;
  provides interface BlazeRegister as FSCTRL0;
  provides interface BlazeRegister as FREQ2;
  provides interface BlazeRegister as FREQ1;
  provides interface BlazeRegister as FREQ0;
  provides interface BlazeRegister as MDMCFG4;
  provides interface BlazeRegister as MDMCFG3;
  provides interface BlazeRegister as MDMCFG2;
  provides interface BlazeRegister as MDMCFG1;
  provides interface BlazeRegister as MDMCFG0;
  provides interface BlazeRegister as DEVIATN;
  provides interface BlazeRegister as MCSM2;
  provides interface BlazeRegister as MCSM1;
  provides interface BlazeRegister as MCSM0;
  provides interface BlazeRegister as FOCCFG;
  provides interface BlazeRegister as BSCFG;
  provides interface BlazeRegister as AGCTRL2;
  provides interface BlazeRegister as AGCTRL1;
  provides interface BlazeRegister as AGCTRL0;
  provides interface BlazeRegister as WOREVT1;
  provides interface BlazeRegister as WOREVT0;
  provides interface BlazeRegister as WORCTRL;
  provides interface BlazeRegister as FREND1;
  provides interface BlazeRegister as FREND0;
  provides interface BlazeRegister as FSCAL3;
  provides interface BlazeRegister as FSCAL2;
  provides interface BlazeRegister as FSCAL1;
  provides interface BlazeRegister as FSCAL0;
  provides interface BlazeRegister as RCCTRL1;
  provides interface BlazeRegister as RCCTRL0;
  provides interface BlazeRegister as FSTEST;
  provides interface BlazeRegister as PTEST;
  provides interface BlazeRegister as AGCTEST;
  provides interface BlazeRegister as TEST2;
  provides interface BlazeRegister as TEST1;
  provides interface BlazeRegister as TEST0;
  provides interface BlazeRegister as PARTNUM;
  provides interface BlazeRegister as VERSION;
  provides interface BlazeRegister as FREQEST;
  provides interface BlazeRegister as LQI;
  provides interface BlazeRegister as RSSI;
  provides interface BlazeRegister as MARCSTATE;
  provides interface BlazeRegister as WORTIME1;
  provides interface BlazeRegister as WORTIME0;
  provides interface BlazeRegister as PKTSTATUS;
  provides interface BlazeRegister as VCO_VC_DAC;
  provides interface BlazeRegister as TXBYTES;
  provides interface BlazeRegister as RXBYTES;
  provides interface BlazeRegister as RXREG;
  provides interface BlazeRegister as TXREG;
  provides interface BlazeRegister as PA;
  
  // fifos
  provides interface BlazeFifo as RXFIFO;
  provides interface BlazeFifo as TXFIFO;
  provides interface BlazeFifo as PATABLE;
  
  //radio control
  provides interface RadioStatus;

}

implementation {
  
  components BlazeSpiP,
      BlazeSpiWireC;
      
  RadioInit = BlazeSpiWireC;
  ChipSpiResource = BlazeSpiWireC;
  
  // commands
  SIDLE = BlazeSpiWireC.Strobe[ BLAZE_SIDLE ];
  SNOP = BlazeSpiWireC.Strobe[ BLAZE_SNOP ];
  SFRX = BlazeSpiWireC.Strobe[ BLAZE_SFRX ];
  SFTX = BlazeSpiWireC.Strobe[ BLAZE_SFTX ];
  SRX = BlazeSpiWireC.Strobe[ BLAZE_SRX ];
  STX = BlazeSpiWireC.Strobe[ BLAZE_STX ];
  SRES = BlazeSpiWireC.Strobe[ BLAZE_SRES ];
  SFSTXON = BlazeSpiWireC.Strobe[ BLAZE_SFSTXON ];
  SXOFF = BlazeSpiWireC.Strobe[ BLAZE_SXOFF ];
  SCAL = BlazeSpiWireC.Strobe[ BLAZE_SCAL ];
  SWOR = BlazeSpiWireC.Strobe[ BLAZE_SWOR ];
  SPWD = BlazeSpiWireC.Strobe[ BLAZE_SPWD ];
  SWORRST = BlazeSpiWireC.Strobe[ BLAZE_SWORRST ];
  
  // registers
  IOCFG2 = BlazeSpiWireC.Reg[ BLAZE_IOCFG2];
  IOCFG1 = BlazeSpiWireC.Reg[ BLAZE_IOCFG1 ];
  IOCFG0 = BlazeSpiWireC.Reg[ BLAZE_IOCFG0 ];
  FIFOTHR = BlazeSpiWireC.Reg[ BLAZE_FIFOTHR ];
  SYNC1 = BlazeSpiWireC.Reg[ BLAZE_SYNC1 ];
  SYNC0 = BlazeSpiWireC.Reg[ BLAZE_SYNC0 ];
  PKTLEN = BlazeSpiWireC.Reg[ BLAZE_PKTLEN ];
  PKTCTRL1 = BlazeSpiWireC.Reg[ BLAZE_PKTCTRL1 ];
  PKTCTRL0 = BlazeSpiWireC.Reg[ BLAZE_PKTCTRL0 ];
  ADDR = BlazeSpiWireC.Reg[ BLAZE_ADDR ]; 
  CHANNR = BlazeSpiWireC.Reg[ BLAZE_CHANNR ];
  FSCTRL1 = BlazeSpiWireC.Reg[ BLAZE_FSCTRL1 ];
  FSCTRL0 = BlazeSpiWireC.Reg[ BLAZE_FSCTRL0 ];
  FREQ2 = BlazeSpiWireC.Reg[ BLAZE_FREQ2 ]; 
  FREQ1 = BlazeSpiWireC.Reg[ BLAZE_FREQ1 ]; 
  FREQ0 = BlazeSpiWireC.Reg[ BLAZE_FREQ0 ];
  MDMCFG4 = BlazeSpiWireC.Reg[ BLAZE_MDMCFG4 ]; 
  MDMCFG3 = BlazeSpiWireC.Reg[ BLAZE_MDMCFG3 ]; 
  MDMCFG2 = BlazeSpiWireC.Reg[ BLAZE_MDMCFG2 ]; 
  MDMCFG1 = BlazeSpiWireC.Reg[ BLAZE_MDMCFG1 ]; 
  MDMCFG0 = BlazeSpiWireC.Reg[ BLAZE_MDMCFG0 ]; 
  DEVIATN = BlazeSpiWireC.Reg[ BLAZE_DEVIATN ]; 
  MCSM2 = BlazeSpiWireC.Reg[ BLAZE_MCSM2 ]; 
  MCSM1 = BlazeSpiWireC.Reg[ BLAZE_MCSM1 ]; 
  MCSM0 = BlazeSpiWireC.Reg[ BLAZE_MCSM0 ]; 
  FOCCFG = BlazeSpiWireC.Reg[ BLAZE_FOCCFG ];
  BSCFG = BlazeSpiWireC.Reg[ BLAZE_BSCFG ]; 
  AGCTRL2 = BlazeSpiWireC.Reg[ BLAZE_AGCTRL2 ]; 
  AGCTRL1 = BlazeSpiWireC.Reg[ BLAZE_AGCTRL1 ]; 
  AGCTRL0 = BlazeSpiWireC.Reg[ BLAZE_AGCTRL0 ]; 
  WOREVT1 = BlazeSpiWireC.Reg[ BLAZE_WOREVT1 ]; 
  WOREVT0 = BlazeSpiWireC.Reg[ BLAZE_WOREVT0 ]; 
  WORCTRL = BlazeSpiWireC.Reg[ BLAZE_WORCTRL ]; 
  FREND1 = BlazeSpiWireC.Reg[ BLAZE_FREND1 ]; 
  FREND0 = BlazeSpiWireC.Reg[ BLAZE_FREND0 ]; 
  FSCAL3 = BlazeSpiWireC.Reg[ BLAZE_FSCAL3 ]; 
  FSCAL2 = BlazeSpiWireC.Reg[ BLAZE_FSCAL2 ]; 
  FSCAL1 = BlazeSpiWireC.Reg[ BLAZE_FSCAL1 ]; 
  FSCAL0 = BlazeSpiWireC.Reg[ BLAZE_FSCAL0 ]; 
  RCCTRL1 = BlazeSpiWireC.Reg[ BLAZE_RCCTRL1 ]; 
  RCCTRL0 = BlazeSpiWireC.Reg[ BLAZE_RCCTRL0 ]; 
  FSTEST = BlazeSpiWireC.Reg[ BLAZE_FSTEST ];
  PTEST = BlazeSpiWireC.Reg[ BLAZE_PTEST ]; 
  AGCTEST = BlazeSpiWireC.Reg[ BLAZE_AGCTEST ];
  TEST2 = BlazeSpiWireC.Reg[ BLAZE_TEST2 ]; 
  TEST1 = BlazeSpiWireC.Reg[ BLAZE_TEST1 ]; 
  TEST0 = BlazeSpiWireC.Reg[ BLAZE_TEST0 ]; 
  PARTNUM = BlazeSpiWireC.Reg[ BLAZE_PARTNUM ];
  VERSION = BlazeSpiWireC.Reg[ BLAZE_VERSION ];
  FREQEST = BlazeSpiWireC.Reg[ BLAZE_FREQEST ];
  LQI = BlazeSpiWireC.Reg[ BLAZE_LQI ]; 
  RSSI = BlazeSpiWireC.Reg[ BLAZE_RSSI ];
  MARCSTATE = BlazeSpiWireC.Reg[ BLAZE_MARCSTATE ]; 
  WORTIME1 = BlazeSpiWireC.Reg[ BLAZE_WORTIME1 ]; 
  WORTIME0 = BlazeSpiWireC.Reg[ BLAZE_WORTIME0 ]; 
  PKTSTATUS = BlazeSpiWireC.Reg[ BLAZE_PKSTATUS ]; 
  VCO_VC_DAC = BlazeSpiWireC.Reg[ BLAZE_VCO_VC_DAC ];
  TXBYTES = BlazeSpiWireC.Reg[ BLAZE_TXBYTES ]; 
  RXBYTES = BlazeSpiWireC.Reg[ BLAZE_RXBYTES ]; 
  RXREG = BlazeSpiWireC.Reg[ BLAZE_RXFIFO ];
  TXREG = BlazeSpiWireC.Reg[ BLAZE_TXFIFO ];
  PA = BlazeSpiWireC.Reg[ BLAZE_PATABLE ];
  
  // fifos
  RXFIFO = BlazeSpiWireC.Fifo[ BLAZE_RXFIFO ];
  TXFIFO = BlazeSpiWireC.Fifo[ BLAZE_TXFIFO ];
  PATABLE = BlazeSpiWireC.Fifo[ BLAZE_PATABLE ];

  //radio control
  RadioStatus = BlazeSpiWireC.RadioStatus;

}

