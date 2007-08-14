module TestAppP {
    provides interface Init;
    uses interface Boot;
    uses interface Timer<TMilli>;
    uses interface Leds;
    uses interface StdOut;
    uses interface SimpleMac;
    uses interface StdControl as SimpleMacControl;
    uses interface LocalTime<TMicro>;
}

implementation {

 
  mac_addr_t shortAddress;
  uint8_t transmitPacket[128];
  packet_t * transmitPacketPtr;
  bool echo = FALSE, filter = TRUE;
  bool radioOn = FALSE, receiverOn = FALSE, timerOn = FALSE;

  uint8_t channel;
  uint8_t sequence = 1;
  
  const ieee_mac_addr_t * ieeeAddress;
  
  task void sendPacketTask();
  
  /**********************************************************************
   ** Init/Boot
   **********************************************************************/
  command error_t Init.init() {
    
    shortAddress = TOS_NODE_ID;
    transmitPacketPtr = (packet_t *) transmitPacket;
    
    // Beacon packet
    transmitPacketPtr->length = 9; //7 + 118 + 2;
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
    
    return SUCCESS;
  }
  
  event void Boot.booted() {    
    call Leds.led1On();
    
    call StdOut.print("Program initialized\n\r");

    channel = 11;
    call SimpleMac.setChannel(channel);

    call StdOut.print("Channel : ");
    call StdOut.printBase10uint8(channel);
    call StdOut.print("\n\r");

    radioOn = TRUE;
    receiverOn = TRUE;
    call SimpleMacControl.start();      
    //call Timer.start(TIMER_REPEAT, 1000);
  }
    

  ///////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////
  event void Timer.fired()
  {
    
    if (radioOn) {
      radioOn = FALSE;
      receiverOn = FALSE;
      call SimpleMacControl.stop();
      call StdOut.print("Radio turned off\r\n");
    } else {
      radioOn = TRUE;
      receiverOn = TRUE;
      call SimpleMacControl.start();        
      call StdOut.print("Radio turned on\r\n");
    }
    // post sendPacketTask();
    
  }

  
  /**********************************************************************
   ** CC2420
   **********************************************************************/

  task void sendPacketTask() 
  {    
    call SimpleMacControl.start();
    call SimpleMac.sendPacket(transmitPacketPtr);
    call SimpleMacControl.stop();
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
    
    return;
  }
  
  event packet_t * SimpleMac.receivedPacket(packet_t *packet)
  {
    uint8_t i;
    
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

    call Leds.led0Toggle();

    post consoleTask();
  }

  task void consoleTask() 
  {
    uint8_t data[2];
        
    atomic data[0] = keyBuffer;

    switch (data[0]) {
    case '\r': 
      call StdOut.print("\r\n");
      break;

    case 't':
      transmitPacketPtr->data_seq_no = sequence++;

      call StdOut.print("Transmitting packet: ");
            
      call StdOut.dumpHex(transmitPacket, 18, " ");
      call StdOut.print("\r\n");

      call SimpleMac.sendPacket(transmitPacketPtr);

      break;
    case 'r':
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
    case 's':
      if (radioOn) {
    radioOn = FALSE;
    receiverOn = FALSE;
    call SimpleMacControl.stop();
    call StdOut.print("Radio turned off\r\n");
      } else {
    radioOn = TRUE;
    receiverOn = TRUE;
    call SimpleMacControl.start();      
    call StdOut.print("Radio turned on\r\n");
      }
            
      break;
    case 'a':

      shortAddress = *(call SimpleMac.getAddress());

      call StdOut.print("Short address: ");
      call StdOut.printHexword(shortAddress);
      call StdOut.print("\r\n");
            
      break;
    case 'b':
      shortAddress = TOS_NODE_ID;
            
      call StdOut.print("Set shortAddress: ");
      call StdOut.printHexword(TOS_NODE_ID);
      call StdOut.print("\r\n");

      call SimpleMac.setAddress(&shortAddress);
            
      break;

    case 'c':

      if (filter) {
    filter = FALSE;
    call StdOut.print("Address filtering off\r\n");
    call SimpleMac.addressFilterDisable();
      } else {
    filter = TRUE;
    call StdOut.print("Address filtering on\r\n");
    call SimpleMac.addressFilterEnable();
      }

      break;
    case 'd':

      ieeeAddress = call SimpleMac.getExtAddress();
            
      call StdOut.print("Extended address: ");
      call StdOut.dumpHex((uint8_t *) ieeeAddress, 8, " ");
      call StdOut.print("\r\n");

      break;

    case 'e':
      if (echo) {
    echo = FALSE;
    call StdOut.print("Echo off\r\n");
      } else {
    echo = TRUE;
    call StdOut.print("Echo on\r\n");
      }
            
      break;

    case 'm':
      if (timerOn) {
    timerOn = FALSE;
    call Timer.stop();
      } else {
    timerOn = TRUE;
    call Timer.startPeriodic(1000);
      }
            
      break;

    case '+':
      channel = (channel == 26) ? 11 : channel + 1;

      call StdOut.print("Channel : ");
      call StdOut.printBase10uint8(channel);
      call StdOut.print("\n\r");

      call SimpleMac.setChannel(channel);

      break;

    case '-':
      channel = (channel == 11) ? 26 : channel - 1;

      call StdOut.print("Channel : ");
      call StdOut.printBase10uint8(channel);
      call StdOut.print("\n\r");      

      call SimpleMac.setChannel(channel);

      break;

    default:
      data[1] = '\0';
      call StdOut.print(data);
      break;
    }

  }



}


