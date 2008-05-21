#include <mc13192Const.h>
module Mc13192SendReceiveTestC
{
  uses
  {
    interface SplitControl as RadioControl;
    interface StdControl as ConsoleControl;
    interface Timer<TMilli> as Timer;
    interface ConsoleInput as In;
    interface ConsoleOutput as Out;
    interface Send;
    interface Receive;
    interface Packet;
    interface Boot;
  }
}
implementation
{
  message_t txpacket;
  message_t *txPtr = &txpacket;
  uint8_t length;

  event void Boot.booted()
  {
  	call ConsoleControl.start();
    call RadioControl.start();
  }
  
  event void Timer.fired() 
  {
    if(call Send.send(txPtr, length) != SUCCESS)
      call Out.print("Failed to send\n");
  }
  
  event void RadioControl.startDone(error_t res) 
  {
  	uint8_t i, *ptr;
  	
  	call Packet.clear(txPtr);
  	ptr = (uint8_t*)call Packet.getPayload(txPtr, NULL);
  	for(i=0; i< call Packet.maxPayloadLength(); i++)
  	  *(ptr+i) = i;
  	length = call Packet.maxPayloadLength();
  	call Out.print("Mc13192SendReceive test program\n");
  	call Out.print("Input t to transmit packages and s to stop transmision.\n");
  	call Out.print("Input + and - to send larger/smaler packages\n");
  }
  
  event void RadioControl.stopDone(error_t res) {}
  
  event void Send.sendDone(message_t* msg, error_t error) 
  {
  	if(error == SUCCESS)
  	  call Out.print("Package sent.\n");
  	else
  	  call Out.print("Sending failed.");
  }
  
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len)
  {
  	mc13192_metadata_t *metadata = (mc13192_metadata_t *)((uint8_t *)msg->footer + sizeof(mc13192_footer_t));
  	call Out.print("Reveived package\n");
  	call Out.print("Radio reveived bytes:");
  	call Out.printBase10uint8(metadata->receivedBytes);
  	call Out.print("\n");
  	call Out.print("Hex dump of header: ");
  	call Out.dumpHex((msg->data - sizeof(mc13192_header_t)), sizeof(mc13192_header_t), " : ");
  	call Out.print("\n");
  	call Out.print("Payload length: ");
  	call Out.printBase10uint8(len);
  	call Out.print("\nHex dump of payload: ");
  	call Out.dumpHex(payload, len, " : ");
  	call Out.print("\n\n");
  	return msg;
  }
  
  task void printLength()
  {
      call Out.print("Now sending ");
      call Out.printBase10uint8(length);
      call Out.print(" bytes\n");
  }
  async event void In.get(uint8_t consoleData) 
  {
    if(consoleData == 't' || consoleData == 'T')
    {
      call Out.print("Transmitting.\n");
      call Timer.startPeriodic(1000);
    }
      
    if(consoleData == 's' || consoleData == 'S')
    {
      call Out.print("Stopping.\n");
      call Timer.stop();
    }
    if(consoleData == '+')
    {
      if(length < TOSH_DATA_LENGTH)
        length++;
      post printLength();
    }
    if(consoleData == '-')
    {
      if(length > 0)
        length--;
      post printLength();
    }
  }
  
}