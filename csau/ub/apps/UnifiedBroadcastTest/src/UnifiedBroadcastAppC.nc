
/**
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   June 6 2010
 */

#include "UnifiedBroadcastApp.h"

configuration UnifiedBroadcastAppC {

} implementation {

	components
		MainC,
		LedsC,
		SerialActiveMessageC,
		ActiveMessageC,
		UnifiedBroadcastAppP as App;

	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.SerialControl -> SerialActiveMessageC;
	App.RadioControl -> ActiveMessageC;

	// Single send test
	components
      new PeriodicProtocolC(6, 512, FALSE, FALSE) as ProtocolOne,
      new PeriodicProtocolC(7, 1024, TRUE, FALSE) as ProtocolTwo,
      new PeriodicProtocolC(8, 2048, FALSE, FALSE) as ProtocolThree;

	// Urgent send test
	/*components
		new PeriodicProtocolC(6, 512, FALSE, TRUE) as ProtocolOne,
		new PeriodicProtocolC(7, 1024, FALSE, FALSE) as ProtocolTwo,
		new PeriodicProtocolC(8, 2048, FALSE, FALSE) as ProtocolThree;*/

	// Time test
	/*components
      new PeriodicProtocolC(6, 2048, FALSE, FALSE) as ProtocolOne,
      //new PeriodicProtocolC(7, 1024, FALSE, FALSE) as ProtocolTwo;
      new TimePeriodicProtocolC(8, 512) as ProtocolTwo;*/

    //    components SafeFailureHandlerC;

}
