
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
 * This interface describes a lowest common denominator for UART
 * control.  It does not provide more exotic features such as
 * different input and output speed, flow control, etc.
 *
 * Each platform provides the tos_uart.h file that defines the allowed
 * values for each particular platform - this will generate a compile
 * time error if an application attempts to use a non supported UART
 * setting.
 * 
 * @author Martin Leopold <leopold@polaric.dk>
 *
 */

#include <serial.h>


interface SerialControl {
  async command error_t setFlow(bool f);
  async command bool getFlow();

  async command error_t setRate(ser_rate_t b);
  async command ser_rate_t getRate();

  async command error_t setParity(ser_parity_t);
  async command ser_parity_t getParity();

  async command error_t setDataBits(ser_data_bits_t);
  async command ser_data_bits_t getDataBits();

  async command error_t setStopBits(ser_stop_bits_t);
  async command ser_stop_bits_t getStopBits();
}
