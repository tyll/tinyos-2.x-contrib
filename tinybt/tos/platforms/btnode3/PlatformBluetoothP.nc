/**
 * Implementation of the Bluetooth Chip specific to Zeevo
 * 
 * @author Lee Seng Jea
 */
#include "btpackets.h"

module PlatformBluetoothP{
  provides {
    interface SplitControl as DeviceControl;
    interface BluetoothVendor;
    
  } 
  uses {
    interface GeneralIO as BTPower;
    interface GeneralIO as BTReset;
    interface Timer<TMilli> as Timer;
    interface Boot;
  }
}
implementation {
  command error_t DeviceControl.start() {
    if (call BTPower.get()) { 
    signal DeviceControl.startDone(SUCCESS);
    return SUCCESS;
    }
    call BTReset.clr();
    call Timer.startOneShot(500);
    return SUCCESS;
  }
  command error_t DeviceControl.stop() {
    if (! (call BTPower.get())) {
      signal DeviceControl.stopDone(SUCCESS);
    return SUCCESS;
    }
    call BTPower.clr();
    call BTReset.clr();
    signal DeviceControl.stopDone(SUCCESS);
    return SUCCESS;
  }
  event void Boot.booted() {
    call BTPower.makeOutput();
    call BTReset.makeOutput();
    call BTPower.clr();
    call BTReset.clr();
  }
  event void Timer.fired(){
   if (!(call BTPower.get())) {
     call BTPower.set();
     call Timer.startOneShot(500);
   }
   else if (!(call BTReset.get())) {
     call BTReset.set();
     call Timer.startOneShot(3000);
   }
   else{
     signal DeviceControl.startDone(SUCCESS);
   }

  }
  command error_t BluetoothVendor.setPacket(gen_pkt *pkt, uint16_t opcode) {
    // This is unique to Zeevo;
    //     Command Format:      |OGF + OCF|PLEN|8 DATABITS|1 STOPBIT|NO PARITY|BAUDRATE|TEMPORARY CHANGE|
    uint8_t esr_set_baud_rate[]={0x0f,0xfc,0x05, 0x03     , 0x00    , 0x00    , 0x06   , 0x00           };
    switch(opcode) {
    case cmd_opcode_pack(OGF_VENDOR_SPECIFIC, 0x0000):
    pkt->start = pkt->end - sizeof(esr_set_baud_rate);
    memcpy(pkt->start, esr_set_baud_rate, sizeof(esr_set_baud_rate));
    return SUCCESS;
	case cmd_opcode_pack(OGF_HOST_CTL, OCF_WRITE_PAGE_TIMEOUT):
	
	case cmd_opcode_pack(OGF_HOST_CTL, OCF_WRITE_SCAN_ENABLE):
	case cmd_opcode_pack(OGF_HOST_CTL, OCF_SET_FLOW_CONTROL):
	case cmd_opcode_pack(OGF_HOST_CTL, OCF_WRITE_INQUIRY_MODE):
	case cmd_opcode_pack(OGF_HOST_CTL, OCF_WRITE_INQUIRY_SCAN_TYPE):    
    return FAIL;
    }
  }
}
