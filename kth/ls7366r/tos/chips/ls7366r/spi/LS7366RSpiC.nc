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
 * Wiring for the LS7366RSpi component
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version $Revision$ $Date$
 */

generic configuration LS7366RSpiC() {

  provides interface Resource;
  provides interface ChipSpiResource;

  // registers
  provides interface LS7366RRegister as MDR0;
  provides interface LS7366RRegister as MDR1;
  provides interface LS7366RRegister as DTR;
  provides interface LS7366RRegister as CNTR;
  provides interface LS7366RRegister as OTR;
  provides interface LS7366RRegister as STR;
  
  provides interface LS7366RStrobe as LDOTR;
  provides interface LS7366RStrobe as CLRCNTR;


}

implementation {

  enum {
    CLIENT_ID = unique( "LS7366RSpi.Resource" ),
  };
  
  components HplLS7366RPinsC as Pins;
  components LS7366RSpiWireC as Spi;
  
  ChipSpiResource = Spi.ChipSpiResource;
  Resource = Spi.Resource[ CLIENT_ID ];

  // registers
  MDR0 = Spi.Reg[ LS7366R_REG_MDR0 ];
  MDR1 = Spi.Reg[ LS7366R_REG_MDR1 ];
  DTR = Spi.Reg[ LS7366R_REG_DTR ];
  CNTR = Spi.Reg[ LS7366R_REG_CNTR ];
  OTR = Spi.Reg[ LS7366R_REG_OTR ];
  STR = Spi.Reg[ LS7366R_REG_STR ];
  
  // strobe
  LDOTR = Spi.Strobe[ LS7366R_OP_LOAD | LS7366R_REG_OTR ];
  CLRCNTR = Spi.Strobe[ LS7366R_OP_CLR | LS7366R_REG_CNTR ];

}

