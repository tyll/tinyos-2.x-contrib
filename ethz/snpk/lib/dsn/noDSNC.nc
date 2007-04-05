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
	
	DSN = DSNP.DSN;
	Init = DSNP.Init;
	DSNP.setAmAddress -> ActiveMessageAddressC;
	
}

