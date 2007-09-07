
interface ChannelMonitor {

  async command void check();
  
  async event void free();
  
  async event void busy();
  
  async event void error();
  
  async command void setCheckLength( uint16_t t_ms );
  
  async command uint16_t getCheckLength();
}


