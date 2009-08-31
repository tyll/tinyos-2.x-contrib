
/**
 * This makes the watchdog timer turn on only when the radio is on, and turn
 * off when the radio turns off.  This helps save energy when the platform
 * is not running radio stack code.
 * @author David Moss
 */
 
configuration RadioWatchdogC {
}

implementation {

  components BlazeInitC,
      DawgC;
  
  BlazeInitC.RadioBootstrapStdControl -> DawgC.StdControl;
  
}