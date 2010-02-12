/**
* Wiring for DIOC component.
* 
* @author Charles Elliott
* @modified Feb 27, 2009
*/

generic configuration DIOC() {
  provides interface Read<uint8_t>;
  //provides interface DigOutput as Digital;
}
implementation { 
components DIOP;
	//MDA3XXDigOutputC;

  Read = DIOP.Read; 
  //Digital = MDA3XXDigOutputC.DigOutput;
}
