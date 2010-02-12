/**
* Wiring for SHT75_C component.
* 
* @author Charles Elliott
* @modified June 24, 2008
*/

configuration SHT75_C {
	provides interface SHT75Interface;
}
implementation {
	components new DigOutput() as DIO;
	components SHT75_P;
	SHT75Interface = SHT75_P.SHT75Interface;
	SHT75_P.DIO -> DIO;
}