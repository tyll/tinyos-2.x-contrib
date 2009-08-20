

/**
 * Interface to indicate when the radio is actually powered on and powered off,
 * to be used by an external module that might care to keep track of the 
 * actual radio duty cycle and on-time.
 * @author David Moss
 */
 
interface PowerNotifier {
  
  event void on();
  
  event void off();
  
}
