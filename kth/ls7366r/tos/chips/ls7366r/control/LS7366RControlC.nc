/*
 * Copyright (c) 2010, KTH Royal Institute of Technology
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions 
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright 
 *   notice, this list of conditions and the following disclaimer in the 
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the KTH Royal Institute of Technology nor the names 
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY 
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */
/**
 * Wiring for the LS7366RControl component
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version $Revision$ $Date$
 */

#include "LS7366R.h"
#include "IEEE802154.h"

configuration LS7366RControlC {

  provides{
	  interface Resource;
	  interface LS7366RConfig;
	  interface LS7366RReceive; 
  }
 
}


implementation {
  

  components LS7366RControlP;
  Resource = LS7366RControlP;
  LS7366RConfig = LS7366RControlP;
  LS7366RReceive = LS7366RControlP;
		  
  components MainC;
  MainC.SoftwareInit -> LS7366RControlP;

  components HplLS7366RPinsC as Pins;
  LS7366RControlP.SS -> Pins.SS;
  LS7366RControlP.SOMI -> Pins.SOMI;


  components new LS7366RSpiC() as Spi;
  LS7366RControlP.SpiResource -> Spi;
  
  components BusyWaitMicroC as BusyWait;
  LS7366RControlP.BusyWait -> BusyWait;

  // registers
  LS7366RControlP.MDR0 -> Spi.MDR0;
  LS7366RControlP.MDR1 -> Spi.MDR1;
  LS7366RControlP.DTR -> Spi.DTR;
  LS7366RControlP.CNTR -> Spi.CNTR;
  LS7366RControlP.OTR -> Spi.OTR;
  LS7366RControlP.STR -> Spi.STR;
  
  // strobe
  LS7366RControlP.LDOTR -> Spi.LDOTR;
  LS7366RControlP.CLRCNTR -> Spi.CLRCNTR;
  
  components new LS7366RSpiC() as SyncSpiC;
  LS7366RControlP.SyncResource -> SyncSpiC;

}

