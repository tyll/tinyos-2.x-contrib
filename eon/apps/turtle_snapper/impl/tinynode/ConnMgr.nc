




interface ConnMgr {

	//report a beacon received
  command result_t beacon(uint16_t addr, uint16_t delay);

  command uint16_t getDelayToBase(bool shortcircuit);
  command uint16_t getDelayToBaseThroughAddr(uint16_t addr, bool shortcircuit);
  command uint8_t getConnectionRank(uint16_t addr, uint16_t *delay);
  
  //for accounting purposes only
  //these allow us to see how much we used each connection event
   command result_t sentPacket(uint16_t toaddr);
   command result_t recvedPacket(uint16_t fromaddr); 
   //basically lock the radio.  Prevent multiple Tx/Rx paths from operating simultaneously
   //we don't want to fight ourselves.
   command result_t lock();
   command result_t unlock();
   
   command result_t radioHi(); //put the radio into HPL mode
   command result_t radioLo(); //put the radio into LPL mode
   
   //semaphore semantics--off off on = still off!
   command result_t radioOff(); //turn the radio off
   command result_t radioOn();  //turn the radio on
  
  
}

