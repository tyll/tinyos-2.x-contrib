/**
* Wiring for MDA3XXDigOutputC component.
* 
* @author Christopher Leung
* @author Charles Elliott
* @modified Feb 27, 2009
*/

configuration MDA3XXADCC {
	provides interface MDA300ADC;
}
implementation {
	components LedsC, NoLedsC;	
	
	components new Atm128I2CMasterC() as I2C;
	
	components MDA3XXADCP;
	
	MDA300ADC = MDA3XXADCP.MDA300ADC;
	
	MDA3XXADCP.Leds -> LedsC.Leds;
	
	MDA3XXADCP.I2CPacket -> I2C.I2CPacket;
	MDA3XXADCP.Resource -> I2C.Resource;
}
