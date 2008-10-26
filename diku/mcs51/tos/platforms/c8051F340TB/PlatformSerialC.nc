
/*
 * Copyright (c) 2008 Polaric
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
 * - Neither the name of Polaric nor the names of its contributors may
 *   be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL POLARIC OR ITS CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * PlatformSerialC
 * The purpose of this configuration is to fake a UartStream interface using
 * SerialByteComm. 
 *
 * It is unclear which is /the/ TinyOS serial interface,
 * SerialByteComm is covered by TEP113, while UartStream is covered by
 * TEP117. TEP117 does not specify a configuration that provides the
 * interface. On the otherhand TEP117 states that the platform must
 * provide SerialByteComm through UartC.
 *
 * There seems to be a consensus between current platforms to provice
 * a configuration of this name with at least two interface StdControl
 * and UartStream. Further it seems that StdControl handles enabling
 * or disabling the uart and updating the power state. This is /not/
 * faked and may fail horribly.
 *
 */

/**
 * @Author Martin Leopold <leopold@polaric.dk>
 */

configuration PlatformSerialC {
  provides interface StdControl;
  provides interface UartStream;
}
implementation {
  components new SerialByteCommToUartStreamC() as FakeUart,
    UartC as RealUart;

  UartStream = FakeUart.UartStream;
  StdControl = RealUart.StdControl;
  RealUart.SerialByteComm <- FakeUart.SerialByteComm;
}
