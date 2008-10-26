
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
 * SerialByteCommToUartStreamC
 * 
 * This simple implementation wraps the TEP113 SerialByteComm to fake
 * a TEP117 UartStream interface.
 *
 */

/**
 * @Author Martin Leopold <leopold@polaric.dk>
 */

generic module SerialByteCommToUartStreamC() {
  provides interface UartStream;
  uses interface SerialByteComm;
} implementation {

  bool interrupt = TRUE;
  uint8_t *rx_buf=NULL, *rx_end;
  uint16_t rx_len;
  uint8_t *tx_buf=NULL, *tx_end;
  uint16_t tx_len;

  async command error_t UartStream.send( uint8_t* buf, uint16_t len ) {
    uint8_t res = SUCCESS;
    uint8_t out;

    if (len==0)
      return SUCCESS;

    atomic{
      if (tx_buf == NULL) {
        tx_buf = buf;
        tx_end = buf + len;
        tx_len = len;
        out = tx_buf[0];
        call SerialByteComm.put(out);
      } else {
        res = FAIL;
      }
    }
    if (res == SUCCESS) {
    }
    return res;
  }

  async command error_t UartStream.enableReceiveInterrupt() {
    uint8_t res = SUCCESS;
    atomic {
      if(rx_buf != NULL) {
        res = FAIL;
      } else {
        interrupt = TRUE;
        res = SUCCESS;
      }
    }
    return res;
  }
  async command error_t UartStream.disableReceiveInterrupt(){  interrupt = FALSE; return SUCCESS;  }
  async command error_t UartStream.receive( uint8_t* buf, uint16_t len ){
    error_t res = FAIL;

    atomic {
      if (!interrupt) {
        res = SUCCESS;
        rx_buf = buf;
        rx_end = buf + len;
        rx_len = len;
      }
    }
    return res;
  }

  /**
   * There is no way of sinalling that a reception was waiting or to
   * cancel a receive call - so concecutive calls overwrite previous
   * and can only be canceled by re-enabling "interrupts"
   */
  async event void SerialByteComm.get(uint8_t b){
    atomic {
      if (interrupt) {
        signal UartStream.receivedByte(b);
      } else {
        if (rx_buf != NULL) {
          (*rx_buf) = b;
          rx_buf++;
          if (rx_buf == rx_end) {
            signal UartStream.receiveDone((uint8_t*) rx_buf-rx_len, rx_len, SUCCESS);
            rx_buf = NULL;
          }
        }
      }
    }
  }

  async event void SerialByteComm.putDone(){
    atomic {
      if (tx_buf != NULL) {
        tx_buf++;
        if (tx_buf == tx_end) {
          signal UartStream.sendDone(tx_buf - tx_len, tx_len, SUCCESS);
          tx_buf = NULL;
        } else {
          call SerialByteComm.put(tx_buf[0]);
        }
      }
    }
  }

}
