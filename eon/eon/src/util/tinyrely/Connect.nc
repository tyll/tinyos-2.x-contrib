includes TinyRely;

interface Connect
{
  
  command uint8_t connect(uint16_t addr);

  event result_t connectDone(uint16_t addr, 
			     uint8_t uid, 
			     uint8_t connid, 
			     relyresult success); 

  /*
    signalled when an incoming connection request is made and is
    basically asking the program whether or not it wants to accept
    this connection.  If return RELY_OK, the connection is accepted
    and connid should be used to refer to the connection.  If you return
    anything else, then the connection is rejected and connid becomes
    meaningless.
  */
  event relyresult accept(uint16_t srcaddr, uint8_t connid);

  command result_t close(uint8_t connid);


}
