/*
* Copyright (c) 2006 Stanford University.
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
* - Neither the name of the Stanford University nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/ 
/**
 * @brief Driver module for the OmniVision OV7649 Camera
 * @author
 *		Andrew Barton-Sweeney (abs@cs.yale.edu)
 *		Evan Park (evanpark@gmail.com)
 */
/**
 * @brief Ported to TOS2
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */ 
module HplSCCBReliableM
{
  provides {
    interface HplSCCB[uint8_t id];
  }

  uses interface HplSCCB as actualHplSCCB;
  uses interface Leds;
}
implementation
{
  // Number of times to retry an sccb communication
#define SCCB_MAX_RETRIES 5

  //----------------------------------------------------------------------------
  // StdControl - Simply pass through to Sccb StdControl
  //----------------------------------------------------------------------------
  command error_t HplSCCB.init[uint8_t id]() {
    return call actualHplSCCB.init();
  }


  //----------------------------------------------------------------------------
  // Sccb Interface Implementation
  //----------------------------------------------------------------------------
  command error_t HplSCCB.three_write[uint8_t id](uint8_t data, uint8_t address) {
    uint8_t sccb_data = 0x00;
    error_t sccb_result;
    uint8_t i;

    sccb_result = FAIL;
    for (i = 0; i < SCCB_MAX_RETRIES; i++) {
      // Write data and read it back
      call actualHplSCCB.three_write(data, address);
      call actualHplSCCB.two_write(address);
      call actualHplSCCB.read(&sccb_data);

      // Check data for integrity
      if (sccb_data == data) {
        sccb_result = SUCCESS;
        break;
      }
    }
    if (sccb_result == FAIL)
      call Leds.led0On();
    else if (data != 0)
      call Leds.led1On();
    // Inform the calling layer if we fail
    return sccb_result;
  }

  command error_t HplSCCB.two_write[uint8_t id](uint8_t address) {
    return call actualHplSCCB.two_write(address);
  }

  command error_t HplSCCB.read[uint8_t id](uint8_t* data) {
    return call actualHplSCCB.read(data);
  }
}

