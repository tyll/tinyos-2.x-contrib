configuration TestFireSimC { 
}

implementation {

	components TestFireSimP;
	
	components MainC;
	TestFireSimP.Boot->MainC;

	components SimFireC;
	TestFireSimP.SimFire -> SimFireC;

	components new TimerMilliC() as FireTimerC;
	TestFireSimP.FireTimer -> FireTimerC;

	components SimMoteP;
	TestFireSimP.SimMote -> SimMoteP;


}
