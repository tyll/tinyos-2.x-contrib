
//provide compatibility with avr motes
//its useful to have a common timer interface

configuration SysTimeC
{
	provides
	{
		interface SysTime;
	}
}

implementation 
{
	components Main, SysTimeM, TimerC;

	SysTime	= SysTimeM;
	
	SysTimeM.LocalTime -> TimerC.LocalTime;
	Main.StdControl -> TimerC;
}
