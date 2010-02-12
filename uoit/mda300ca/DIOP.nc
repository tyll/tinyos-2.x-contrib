/**
* DIOP module passes commands between the DigOutput and Read interfaces
* 
* @author Charles Elliott
* @modified Feb 27, 2009
*/

module DIOP {
  provides 
  {
	interface Read<uint8_t>;
  }
  uses
  {
	interface DigOutput as Digital;
  }
}
implementation
{
	command error_t Read.read() {    
    return call Digital.requestRead();
	}	
  
	event void Digital.readyToRead (){
		uint8_t val;
		val = call Digital.read();
		signal Read.readDone(SUCCESS, val);
	}
	
	default event void Read.readDone(error_t result, uint8_t val) { }
	
	event void Digital.readyToSet(){}
	
}
