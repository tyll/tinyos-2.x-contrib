/* Copyright (c) 2007, Tor Petterson <motor@diku.dk>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 *  - Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *  - Neither the name of the University of Copenhagen nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
  @author Tor Petterson <motor@diku.dk>
*/

interface HplHcs08Spi 
{
  async command void enable();
  async command void disable();
  async command uint8_t get();
  async command bool isEmpty();
  async command bool isReady();
  async command void enableRecieveInterrupt();
  async command void disableRecieveInterrupt();
  async command void enableTransmitInterrupt();
  async command void disableTransmitInterrupt();
  async command void msbFirst();
  async command void lsbFirst();
  async command bool isLsbFirst();
  async command void masterMode();
  async command void slaveMode();
  async command bool isMasterMode();
  async command void clockPolarityHigh();
  async command void clockPolarityLow();
  async command bool isClockPolarityLow();
  async command void phaseEdge();
  async command void phaseMiddle();
  async command bool isPhaseEdge();
  async command void setSpeed(uint8_t ratePrescaleDiv, uint8_t rateDiv);
  async command uint8_t getRatePrescaleDiv();
  async command uint8_t getRateDiv();
  async command error_t send(uint8_t byte);
  async event void TransmitBufferEmpty();
  async event void RecievedByte(uint8_t byte);
}

