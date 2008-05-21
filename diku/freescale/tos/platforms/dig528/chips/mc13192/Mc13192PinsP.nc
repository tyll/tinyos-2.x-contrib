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


/**
 * @author Tor Petterson <motor@diku.dk>
 */
 
 module Mc13192PinsP
{
  uses interface HplHcs08GeneralIO as Reset;
  uses interface HplHcs08GeneralIO as RXTXEN;
  uses interface HplHcs08GeneralIO as ATTN;
  uses interface HplHcs08GeneralIO as AntCtrl;
  
  provides interface mc13192Pins;
  provides interface StdControl;
}
implementation
{
  command error_t StdControl.start()
  {
    call Reset.pullupOff();
    call Reset.clr();
    call Reset.makeOutput();
    call RXTXEN.clr();
    call RXTXEN.makeOutput();
    call ATTN.set();
    call ATTN.makeOutput();
    call AntCtrl.clr();
    call AntCtrl.makeOutput();
    
    return SUCCESS;
  }
  
  command error_t StdControl.stop()
  {
    return SUCCESS;
  }
  
  async command void mc13192Pins.setReset() { call Reset.set(); }
  async command void mc13192Pins.clrReset() { call Reset.clr(); }
  async command void mc13192Pins.setRXTXEN() { call RXTXEN.set(); }
  async command void mc13192Pins.clrRXTXEN() { call RXTXEN.clr(); }
  async command void mc13192Pins.setATTN() { call ATTN.set(); }
  async command void mc13192Pins.clrATTN() { call ATTN.clr(); }
  async command void mc13192Pins.setLNACtrl() { return; }
  async command void mc13192Pins.clrLNACtrl() { return; }
  async command void mc13192Pins.setAntCtrl() { call AntCtrl.set(); }
  async command void mc13192Pins.clrAntCtrl() { call AntCtrl.clr(); }
}