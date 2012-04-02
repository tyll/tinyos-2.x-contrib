
module PacketEnergyEstimatorP {
  provides interface PacketEnergyEstimator as Energy;
}

implementation {

  /*
   * In TOSSIM The split phase RADIO ON - DONE / RADIO OFF - DONE will occur at 
   * the same time. No need to track both of them
   */

  async command void Energy.poweron_start()
  {
	dbg("ENERGY_HANDLER","%lld,RADIO_STATE,ON\n", sim_time());
  }

  async command void Energy.poweroff_start()
  {
	dbg("ENERGY_HANDLER", "%lld,RADIO_STATE,RADIO,OFF\n", sim_time());
  }

  /*
   *   Send and Receive tracking
   *   TOSSIM (from my understanding) doesn't export the TX power so I'm 
   *   still wondering for a way to track it down...
   */ 


  async command void Energy.send_done(int dest, uint8_t len,sim_time_t state)
  {
	dbg("ENERGY_HANDLER", "%lld,RADIO_STATE,SEND_MESSAGE,OFF,DEST:%d,SIZE:%d\n", state + sim_time(), dest, len);
  }

  async command void Energy.send_busy(int dest, uint8_t len, int state) 
  {
	dbg("ENERGY_HANDLER", "%lld,RADIO_STATE,SEND_MESSAGE,ERROR,BUSY,DEST:%d,SIZE:%d\n",sim_time(),dest,len);
  }

  async command void Energy.send_start(int dest, uint8_t len, int dbpower)
  {
	dbg("ENERGY_HANDLER", "%lld,RADIO_STATE,SEND_MESSAGE,ON,DEST:%d,SIZE:%d,DB:%d\n", sim_time(),dest, len, dbpower);
  }


/*
 *   Is not really possible to track the start/end of receiving on TOSSIM
 *   (Maybe emulate at runtime with packet size ?)
 */

  async command void Energy.recv_done(int tome)
  {
	if ( sim_node() == tome || tome == 65535 )
		dbg("ENERGY_HANDLER", "%lld,RADIO_STATE,RECV_MESSAGE,DONE,DEST:%d\n",sim_time(),tome);
  }
}

    
