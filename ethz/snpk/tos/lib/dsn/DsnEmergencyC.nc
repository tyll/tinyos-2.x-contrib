// Emergency logging
#include "DSN.h"
component DsnEmergencyC {
	provides interface DsnEmergency;
}
implementation {
#ifdef NODSN
#else
	components DSNC, DsnEmergencyP;
	components Counter32khz32C;
	components new CounterToLocalTimeC(T32khz);
	components new TimerMilliC() as EmergencyTimer;
		
	CounterToLocalTimeC.Counter->Counter32khz32C;
	
	DsnEmergencyP.LocalTime -> CounterToLocalTimeC;
	DsnEmergencyP.EmergencyTimer -> EmergencyTimer;
	DsnEmergencyP.DsnSend->DSNC;
#endif	
}
