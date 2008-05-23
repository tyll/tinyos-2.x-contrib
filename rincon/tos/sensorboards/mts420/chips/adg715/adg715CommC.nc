/*
 * Copyright (c) 2008 Rincon Research Corporation
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

/**
 * The adg715 chip has 8 channels that are controlled through the I2C
 * bus.  This configuration provides 8 Channel interfaces corresponding
 * to the 8 physical channels on the chip.  This implementation is
 * specific to the mts420CA sensorboard and the adg715 that connects
 * the communication wires.
 * 
 * @author Danny Park
 */
 
configuration adg715CommC {
  provides {
    
    /** Connects USART1_TXD to GPS_RX */
    interface Channel as ChannelGpsRx;
    
    /** Connects USART1_RXD to GPS_TX */
    interface Channel as ChannelGpsTx;
    
    /** Connects USART1_CLK to Pressure_SCLK */
    interface Channel as ChannelPressureClock;
    
    /** Connects USART1_TX to Pressure_DOUT */
    interface Channel as ChannelPressureRx;
    
    /** Connects USART1_RX to Pressure_DIN */
    interface Channel as ChannelPressureTx;
    
    /** Pins not connected for channel 6 on this chip */
    interface Channel as Channel6CommNull;
    
    /** Connects PW3 to Humidity_SCK */
    interface Channel as ChannelHumidityClock;
    
    /** Connects INT3 to Humidity_DATA */
    interface Channel as ChannelHumidityData;
  }
}
implementation {
  components new HplAdg715C(FALSE, TRUE);
  
  ChannelGpsRx         = HplAdg715C.Channel1;
  ChannelGpsTx         = HplAdg715C.Channel2;
  ChannelPressureClock = HplAdg715C.Channel3;
  ChannelPressureRx    = HplAdg715C.Channel4;
  ChannelPressureTx    = HplAdg715C.Channel5;
  Channel6CommNull     = HplAdg715C.Channel6;
  ChannelHumidityClock = HplAdg715C.Channel7;
  ChannelHumidityData  = HplAdg715C.Channel8;
}
