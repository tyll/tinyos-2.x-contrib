/**
* Wiring for MDA3XXDigOutputC component.
* 
* @author Christopher Leung
* @author Charles Elliott
* @modified Feb 27,2009
*/

configuration MDA3XXDigOutputC {
	provides interface DigOutput;
}
implementation {
	
	components new Atm128I2CMasterC() as I2C;
	
	components MDA3XXDigOutputP;
	
	DigOutput = MDA3XXDigOutputP.DigOutput;
		
	MDA3XXDigOutputP.I2CPacket -> I2C.I2CPacket;
	MDA3XXDigOutputP.Resource -> I2C.Resource;
}
