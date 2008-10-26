
/*
 * Copyright (c) 2007 University of Copenhagen
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
 * - Neither the name of University of Copenhagen nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
 * OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 *
 * @author Marcus Chang <marcus@diku.dk>
 * @author Martin Leopold <leopold@diku.dk>
 */

// Enable a bunch of output
#define DEBUG

module TestAppP {
    provides interface Init;
    uses interface Boot;
    uses interface Leds;
    uses interface StdOut;

    uses interface SimpleMac;
    uses interface StdControl as SimpleMacControl;

    uses interface HalFlash;

#ifdef __cc2430em__
  uses interface Read<int16_t> as Read;
  uses interface AdcControl;
#elif  __micro4__  
  uses interface Read<uint16_t> as Read;
#endif

}

implementation {

#ifdef __cc2430em__
#define BUTTON_PUSH         0x01
#define ADC_INPUT_ACC_X     0x04
#define ADC_INPUT_ACC_Y     0x05
#define ADC_INPUT_JOYSTICK  0x06
#define ADC_INPUT_POT       0x07
#define ADC_REF_AVDD        0x80
#define ADC_14_BIT          0x30
#endif

#ifdef __cc2430em__
#define FLASH_BASE   (uint8_t_xdata *) 0x7B00
#elif __micro4__
#define FLASH_BASE   (uint8_t *) 0xF100
#endif

/*****************************************************************************/ 
    mac_addr_t shortAddress;
    uint8_t transmitPacket[128];
    packet_t * transmitPacketPtr;
    bool echo = FALSE, filter = TRUE;
    bool radioOn = FALSE, receiverOn = FALSE, timerOn = FALSE;
    uint8_t channel;
    uint8_t sequence = 1;  
    const ieee_mac_addr_t * ieeeAddress;  
    task void sendPacketTask();
/*****************************************************************************/ 
    uint8_t source[256];
    uint8_t destination[256];
/*****************************************************************************/ 
    bool ledOn = FALSE;
  
  /**********************************************************************
   ** Init/Boot
   **********************************************************************/
  command error_t Init.init() {
        uint16_t i;
    
    shortAddress = TOS_NODE_ID;
    transmitPacketPtr = (packet_t *) transmitPacket;
    
    // Beacon packet
    transmitPacketPtr->length = 127; //7 + 118 + 2;
    transmitPacketPtr->fcf = 0x0000;
    transmitPacketPtr->data_seq_no = sequence++;
    transmitPacketPtr->dest = 0xFFFF;
    transmitPacketPtr->src = 0;
    
    /*          // 118 bytes
      for (i = 0; i < 118; i++)
      {
      transmitPacketPtr->data[i] = i;
      }
    */
    // 2 bytes
    transmitPacketPtr->fcs.rssi = 0;
    transmitPacketPtr->fcs.correlation = 0;


        for (i = 0; i < 256; i++) {        
            source[i] = i;
        }
    
    return SUCCESS;
  }
  
  event void Boot.booted() {    
    call Leds.led0Off();
    call Leds.led1Off();
    
    call StdOut.print("Program initialized\n\r");

    channel = 11;
    call SimpleMac.setChannel(channel);

    call StdOut.print("Channel : ");
    call StdOut.printBase10uint8(channel);
    call StdOut.print("\n\r");

    radioOn = TRUE;
    receiverOn = TRUE;
    call SimpleMacControl.start();      

#ifdef __cc2430em__
    call AdcControl.enable(ADC_REF_AVDD, ADC_14_BIT, BUTTON_PUSH);
#endif
  }
    

    /**************************************************************************
    ** Read comething
    **************************************************************************/
    uint8_t counter = 0;

#ifdef __cc2430em__
  event void Read.readDone( error_t result, int16_t val ) 
#elif  __micro4__
  event void Read.readDone( error_t result, uint16_t val )
#endif
  {
    if (counter != 0) {
      call Read.read();    
      counter++;
    } else {
      counter = 0;
    }
#ifdef DEBUG
    call StdOut.print("Val: ");
#ifdef __cc2430em__
    call StdOut.printBase10int16(val);
#elif __micro4__
    call StdOut.printBase10uint16(val);
#endif
    call StdOut.print("\n\r");
#endif    
  }


  /**********************************************************************
   ** SimpleMac
   **********************************************************************/

  task void sendPacketTask() 
  {    
    call SimpleMacControl.start();
    call SimpleMac.sendPacket(transmitPacketPtr);
    call SimpleMacControl.stop();
  }
    
  event void SimpleMac.sendPacketDone(packet_t *packet, error_t result)
  {
#ifdef DEBUG
    if (result == SUCCESS) {
      call StdOut.print("Transmission done\r\n");
    } else {
      call StdOut.print("Transmission failed: ");
      call StdOut.printHex(result);
      call StdOut.print("\r\n");
      }
#endif    
    return;
  }
  
  event packet_t * SimpleMac.receivedPacket(packet_t *packet)
  {
    uint8_t i;
#ifdef DEBUG    
    call StdOut.print("Received packet: ");
    call StdOut.printHex(packet->length);
    call StdOut.print(" ");
    call StdOut.printHexword(packet->fcf);
    call StdOut.print(" ");
    call StdOut.printHex(packet->data_seq_no);
    call StdOut.print(" ");
    call StdOut.printHexword(packet->dest);
    call StdOut.print(" ");
    call StdOut.printHexword(packet->src);
    call StdOut.print(" ");
    
    for (i = 0; i < packet->length - 9; i++)
    {
      call StdOut.printHex(packet->data[i]);
      call StdOut.print(" ");
    }
    
    call StdOut.printHex(packet->fcs.rssi);
    call StdOut.print(" ");
    call StdOut.printHex(packet->fcs.correlation);
    call StdOut.print("\r\n");
#endif
            
    return packet;
  }

  /**********************************************************************
   ** StdOut
   **********************************************************************/
  uint8_t keyBuffer;
  uint16_t i = 0;
  task void consoleTask();
    
  async event void StdOut.get(uint8_t data) {
        
    keyBuffer = data;
#ifdef DEBUG
    call Leds.led0Toggle();
#endif    
    post consoleTask();
  }

  task void consoleTask() 
  {
    uint16_t j;
        uint8_t * ptr;
    uint8_t data[2], tmp;
        
    atomic data[0] = keyBuffer;

    switch (data[0]) {
    case '\r': 
      call StdOut.print("\r\n");
      break;

                case 'l':
                      if (ledOn) {
                        ledOn = FALSE;
                        call StdOut.print("Led off\n\r");
                        call Leds.led0Off();
                      } else {
                        ledOn = TRUE;
                        call StdOut.print("Led on\n\r");
                        call Leds.led0On();
                      }
                      break;

/*****************************************************************************/
                case 'q':
                      transmitPacketPtr->data_seq_no = sequence++;
#ifdef DEBUG
                      call StdOut.print("Transmitting packet: ");
                      call StdOut.dumpHex(transmitPacket, 18, " ");
                      call StdOut.print("\r\n");
#endif
                      call SimpleMac.sendPacket(transmitPacketPtr);
                      break;

                case 'w':
                      if (radioOn) {
                        radioOn = FALSE;
                        receiverOn = FALSE;
                        call StdOut.print("Radio turned off\r\n");
                        call SimpleMacControl.stop();
                      } else {
                        radioOn = TRUE;
                        receiverOn = TRUE;
                        call StdOut.print("Radio turned on\r\n");
                        call SimpleMacControl.start();      
                      }
                      break;

                case 'e':
                      if (!radioOn) {

                        call StdOut.print("Radio is off\r\n");

                      } else if (receiverOn) {
                        receiverOn = FALSE;
                        call StdOut.print("Receiver turned off\r\n");
                        call SimpleMac.rxDisable();
                      } else {
                        receiverOn = TRUE;
                        call StdOut.print("Receiver turned on\r\n");
                        call SimpleMac.rxEnable();
                      }
                      break;

                case 'a':
                      channel = (channel == 26) ? 11 : channel + 1;

                      call StdOut.print("Channel : ");
                      call StdOut.printBase10uint8(channel);
                      call StdOut.print("\n\r");

                      call SimpleMac.setChannel(channel);
                      break;

                case 's':
                      channel = (channel == 11) ? 26 : channel - 1;

                      call StdOut.print("Channel : ");
                      call StdOut.printBase10uint8(channel);
                      call StdOut.print("\n\r");      

                      call SimpleMac.setChannel(channel);
                      break;

/*****************************************************************************/
            case 'r':
              call HalFlash.read(destination, FLASH_BASE, 256);
#ifdef DEBUG                                
              for (j = 0; j < 0x0100; j++) {
                call StdOut.printHex(destination[j]);
              }
              call StdOut.print("\n\r");
#endif                
              break;

            case 't':
#ifdef DEBUG
              call StdOut.print("Writing segment\n\r");            
#endif
              call HalFlash.write(source, FLASH_BASE, 256);
              break;

            case 'y':
#ifdef DEBUG
              call StdOut.print("Erasing segment\n\r");            
#endif
              call HalFlash.erase(FLASH_BASE);
              break;
/*****************************************************************************/
            case 'u':

#ifdef DEBUG
              call StdOut.print("Reading adc\n\r");            
#endif
              call Read.read();    
              break;
/*****************************************************************************/
          case 'p':
	    transmitPacketPtr->length = transmitPacketPtr->length==127 ? 13 : 127;
 	    call StdOut.print("Length now: ");
	    call StdOut.printBase10uint8(transmitPacketPtr->length);
	    call StdOut.print("\n\r");
	    break;

    default:
      data[1] = '\0';
      call StdOut.print(data);
      break;
    }

  }



}
