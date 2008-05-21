module ActiveMessageTestC
{
  uses
  {
    interface Boot;
    interface Receive as Receive1;
    interface Receive as Snoop1;
    interface AMSend as Send1;
    interface Receive as Receive2;
    interface Receive as Snoop2;
    interface AMSend as Send2;
    interface SplitControl as AMControl;
    interface Packet;
    interface AMPacket;
    interface StdControl as ConsoleControl;
    interface ConsoleInput as In;
    interface ConsoleOutput as Out;
  }
}
implementation
{
  message_t txBuf;
  bool locked;
  bool first;
  bool addr = FALSE;
  uint8_t addrpos;
  uint8_t parseChar(uint8_t byte);
  uint16_t address;
  
  void printPackage(message_t *msg, void* payload, uint8_t len);
  void handler(uint8_t);
  
  event void Boot.booted()
  {
  	call ConsoleControl.start();
  	
    call AMControl.start();
  }
  
  event void AMControl.startDone(error_t res)
  {
  	uint8_t i, *ptr;
  	
  	call Packet.clear(&txBuf);
  	ptr = (uint8_t*)call Packet.getPayload(&txBuf, NULL);
  	for(i=0; i< call Packet.maxPayloadLength(); i++)
  	  *(ptr+i) = i;
  	
  	call Out.print("\nActive Message Test.\n");
  	call Out.print("Input a followed by an address in four digits hex\n");
  	call Out.print("to send a package of type ");
  	call Out.printBase10uint8(TESTER_MSG1);
  	call Out.print("\n");
  	call Out.print("Input b followed by an address in four digits hex\n");
  	call Out.print("to send a package of type ");
  	call Out.printBase10uint8(TESTER_MSG2);
  	call Out.print("\n");
  }
  
  async event void In.get(uint8_t data) 
  {
    if(!locked)
      handler(data);
  }
    
  event message_t* Receive1.receive(message_t* bufPtr, 
				   void* payload, uint8_t len) 
  {
  	call Out.print("Receive for type ");
  	call Out.printBase10uint8(TESTER_MSG1);
  	call Out.print(" received package:\n");
    printPackage(bufPtr, payload, len);
    return bufPtr;
  }
  
  event message_t* Snoop1.receive(message_t* bufPtr, 
				   void* payload, uint8_t len) 
  {
  	call Out.print("Snoop for type ");
  	call Out.printBase10uint8(TESTER_MSG1);
  	call Out.print(" snooped package:\n");
    printPackage(bufPtr, payload, len);
    return bufPtr;
  }
  
   event message_t* Snoop2.receive(message_t* bufPtr, 
				   void* payload, uint8_t len) 
  {
  	call Out.print("Snoop for type ");
  	call Out.printBase10uint8(TESTER_MSG2);
  	call Out.print(" snooped package:\n");
    printPackage(bufPtr, payload, len);
    return bufPtr;
  }
  
  event message_t* Receive2.receive(message_t* bufPtr, 
				   void* payload, uint8_t len) 
  {
  	call Out.print("Receive for type ");
  	call Out.printBase10uint8(TESTER_MSG2);
  	call Out.print(" Received package:\n");
    printPackage(bufPtr, payload, len);
    return bufPtr;
  }
  
  void printPackage(message_t *msg, void* payload, uint8_t len)
  {
  	mc13192_metadata_t *metadata = (mc13192_metadata_t *)((uint8_t *)msg->footer + sizeof(mc13192_footer_t));
  	call Out.print("Radio reveived bytes:");
  	call Out.printBase10uint8(metadata->receivedBytes);
  	call Out.print("\n");
  	//call Out.print("Hex dump of header: ");
  	//call Out.dumpHex((msg->data - sizeof(mc13192_header_t)), sizeof(mc13192_header_t), " : ");
  	call Out.print("From ");
  	call Out.printBase10uint8(call AMPacket.source(msg));
  	call Out.print("\n");
  	call Out.print("To ");
  	call Out.printBase10uint8(call AMPacket.destination(msg));
  	call Out.print("\n");
  	call Out.print("Type ");
  	call Out.printBase10uint8(call AMPacket.type(msg));
  	call Out.print("\n");
  	
  	call Out.print("\n");
  	call Out.print("Payload length: ");
  	call Out.printBase10uint8(len);
  	call Out.print("\nHex dump of payload: ");
  	call Out.dumpHex(payload, len, " : ");
  	call Out.print("\n\n");
 }
 
  void handler(uint8_t data)
  {
  	uint8_t tmp;
  	
  	if(addr)
  	{
  	  if(addrpos == 3)
  	  {
  	    tmp = parseChar(data);
  	    if(tmp > 0xF)
  	    {
  	      call Out.print("Failed to read address.\n");
  	      addr = FALSE;
  	      return;
  	    }
  	    address |= ((uint16_t)tmp);
  	    addr = FALSE;
  	    call Out.print("sending to 0x");
  	    call Out.printHexword(address);
  	    call Out.print(" type ");
  	    if(first)
  	    {
  	      call Out.printBase10uint8(TESTER_MSG1);
  	      call Out.print("\n");
  	      locked = TRUE;
  	      call Send1.send(address, &txBuf, call Packet.maxPayloadLength());
  	    }
  	    else
  	    {
  	      call Out.printBase10uint8(TESTER_MSG2);
  	      call Out.print("\n");
  	      locked = TRUE;
  	      call Send2.send(address, &txBuf, call Packet.maxPayloadLength());
  	    }
  	  }
  	  if(addrpos == 2)
  	  {
  	    tmp = parseChar(data);
  	    if(tmp > 0xF)
  	    {
  	      call Out.print("Failed to read address.\n");
  	      addr = FALSE;
  	      return;
  	    }
  	    address |= (((uint16_t)tmp) << 4);
  	    addrpos = 3;
  	  }
  	  if(addrpos == 1)
  	  {
  	    tmp = parseChar(data);
  	    if(tmp > 0xF)
  	    {
  	      call Out.print("Failed to read address.\n");
  	      addr = FALSE;
  	      return;
  	    }
  	    address |= (((uint16_t)tmp) << 8);
  	    addrpos = 2;
  	  }
  	  if(addrpos == 0)
  	  {
  	  	if(data == ' ')
  	  	  return;
  	    address = 0;
  	    tmp = parseChar(data);
  	    if(tmp > 0xF)
  	    {
  	      call Out.print("Failed to read address.\n");
  	      addr = FALSE;
  	      return;
  	    }
  	    address = (((uint16_t)tmp) << 12);
  	    addrpos = 1;
  	  } 
  	  return;
  	}
  	if(data == 'a')
  	{
  	  first = TRUE;
  	  addr=TRUE;
  	  addrpos=0;
  	}
  	if(data == 'b')
  	{
  	  first = FALSE;
  	  addr=TRUE;
  	  addrpos=0;
  	}
  }
  
  uint8_t parseChar(uint8_t byte)
  {
    switch(byte)
    {
      case '0': return 0;
      case '1': return 1;
      case '2': return 2;
      case '3': return 3;
      case '4': return 4;
      case '5': return 5;
      case '6': return 6;
      case '7': return 7;
      case '8': return 8;
      case '9': return 9;
      case 'a': return 0xA;
      case 'A': return 0xA;
      case 'b': return 0xB;
      case 'B': return 0xB;
      case 'c': return 0xC;
      case 'C': return 0xC;
      case 'd': return 0xD;
      case 'D': return 0xD;
      case 'e': return 0xE;
      case 'E': return 0xE;
      case 'f': return 0xF;
      case 'F': return 0xF;
      default:
        return 0xFF;
      }
    }

  event void Send1.sendDone(message_t* bufPtr, error_t error) { locked = FALSE; }
  
  event void Send2.sendDone(message_t* bufPtr, error_t error) { locked = FALSE; }
  
  event void AMControl.stopDone(error_t res) {}
}