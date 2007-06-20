#include <AM.h>
#include "DSN.h"

configuration noDSNC
{
	provides interface DSN;	
}
implementation
{
	components ActiveMessageAddressC;
	components noDSNP as DSNP;
	components RealMainP;
	
	RealMainP.PlatformInit -> DSNP.NodeIdInit;
	DSN = DSNP.DSN;
	DSNP.setAmAddress -> ActiveMessageAddressC;
	
}

