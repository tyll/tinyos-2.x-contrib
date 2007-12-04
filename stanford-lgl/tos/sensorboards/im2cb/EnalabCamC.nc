configuration EnalabCamC
{
    provides interface Init;
    provides interface EnalabCam;
}
implementation
{
  components EnalabCamM; 
  Init = EnalabCamM;
  EnalabCam = EnalabCamM;
 
  components HplPXA27XQuickCaptIntC;
  EnalabCamM.CIF 		-> HplPXA27XQuickCaptIntC;
	
  components HplOV7649C, GeneralIOC;
  EnalabCamM.OV 		-> HplOV7649C;
  
  components SerialActiveMessageC as Serial, LedsC;
  EnalabCamM.Leds -> LedsC;
  EnalabCamM.DbgSend     -> Serial.AMSend[15];
  EnalabCamM.Packet -> Serial;
  
 }
