

/**
 * Initialize some registers on the radio
 * @author Jared Hill
 * @author David Moss
 */
 
interface RadioInit {

  command error_t init(uint8_t startAddr, uint8_t* initValues, uint8_t len);
  
  event void initDone();
  
}


