
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
 */

module SampleForwardM
{
  provides interface Init;
  uses interface Boot;
  uses interface StdOut;

  uses interface SimpleMac;
  uses interface StdControl as SimpleMacControl;

  uses interface StdControl as AccelControl;
  uses interface ThreeAxisAccel;
}
implementation
{
  uint8_t transmitPackets[2][128];
  packet_t * transmitPacketPtr;
  uint8_t index, sample, packetNumber;
  bool on = TRUE;

#define TIMER_DELAY 10
#define SAMPLES 1

  command error_t Init.init() {

    TOS_NODE_ID = 0x0B0B;

    index = 0;
    sample = 0;
    packetNumber = 0;

    // initialize packet 0
    transmitPacketPtr = (packet_t *) transmitPackets[0];
    
    // Beacon packet
    transmitPacketPtr->length = 7 + SAMPLES * 6 + 2;
    transmitPacketPtr->fcf = 0x0000;
    transmitPacketPtr->data_seq_no = 0x00;
    transmitPacketPtr->dest = 0x000B;
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

    // initialize packet 1
    transmitPacketPtr = (packet_t *) transmitPackets[1];
    
    // Beacon packet
    transmitPacketPtr->length = 7 + SAMPLES * 6 + 2;
    transmitPacketPtr->fcf = 0x0000;
    transmitPacketPtr->data_seq_no = 0x00;
    transmitPacketPtr->dest = 0x000B;
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

    return SUCCESS;
  }

  event void Boot.booted() {

    call StdOut.print("Hello World\n\r");

    call AccelControl.start();

    call ThreeAxisAccel.setRange(ACCEL_RANGE_2x5G);

    call SimpleMac.setChannel(20);
    call SimpleMacControl.start();      

    call ThreeAxisAccel.getData();

//    call Alarm.start(TIMER_DELAY);
  }

  event error_t ThreeAxisAccel.dataReady(uint16_t x, uint16_t y, uint16_t z, uint8_t status) {
  
    transmitPacketPtr->data[sample * 6] = x >> 8;
    transmitPacketPtr->data[sample * 6 + 1] = x;
    transmitPacketPtr->data[sample * 6 + 2] = y >> 8;
    transmitPacketPtr->data[sample * 6 + 3] = y;
    transmitPacketPtr->data[sample * 6 + 4] = z >> 8;
    transmitPacketPtr->data[sample * 6 + 5] = z;

    call StdOut.printBase10uint16(x);
    call StdOut.print(" ");
    call StdOut.printBase10uint16(y);
    call StdOut.print(" ");
    call StdOut.printBase10uint16(z);
    call StdOut.print("\n\r");
    
//    sample++;
//    call StdOut.print("Storing sample: ");
//    call StdOut.printBase10uint8(sample);
//    call StdOut.print("\n\r");
    
//    if (sample == SAMPLES) {
        call SimpleMac.sendPacket(transmitPacketPtr);
//        index = (index == 0) ? 1 : 0;
//        transmitPacketPtr = (packet_t *) transmitPackets[index];
//        sample = 0;
//        packetNumber++;
//        transmitPacketPtr->data_seq_no = packetNumber;
//    }

//    call Alarm.start(TIMER_DELAY);
  
    return SUCCESS;
  }


  event void SimpleMac.sendPacketDone(packet_t *packet, error_t result)
  {
      if (result == SUCCESS) {
        call StdOut.print("Transmission done\r\n");
      } else {
        call StdOut.print("Transmission failed: ");
        call StdOut.printHex(result);
        call StdOut.print("\r\n");
      }

    call ThreeAxisAccel.getData();
    
    return;
  }
  
  event packet_t * SimpleMac.receivedPacket(packet_t *packet)
  {
    return packet;
  }

  uint8_t buffer;
  task void echoTask();

  async event void StdOut.get( uint8_t byte ) {
    buffer = byte;

    post echoTask();
  }

  uint16_t i;

  task void echoTask() {
    uint8_t tmp[2];

    atomic tmp[0] = buffer;
    tmp[1] = '\0';

    switch (tmp[0]) {

        case '\r':
            call StdOut.print("\n\r");
            break;

        default:
            call StdOut.print(tmp);
    }
  }

}

