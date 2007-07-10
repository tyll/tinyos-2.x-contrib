/*
*
* Whisker Demo for use with PlayerStage and SimulatorM
*
*/

configuration WhiskerDemo {
}

implementation {
  components MainC, WhiskerC, SimulatorC;
  components new TimerMilliC() as RunForever;

  WhiskerC -> MainC.Boot;
  WhiskerC.Robot -> SimulatorC;
  WhiskerC.Timer -> RunForever;
}
