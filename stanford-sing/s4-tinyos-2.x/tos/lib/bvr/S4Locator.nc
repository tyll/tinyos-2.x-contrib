
includes S4;

/*Interface that a locator may provide, for retrieving the local node's 
  coordinates*/

/* Currently it is not safe in that the application could change the
   buffer, but it saves memory, keeping only one copy of the coordinates.*/


interface S4Locator {
   /** 
    * Provides the coordinates of the local node
    *
    * @param coords Pointer to coordinates
    * @return SUCCESS if coordinates are valid, FAIL otherwise
    */
   command error_t getCoordinates(Coordinates * coords);

   /**
    * Signals when the coordinates have changed, so that the user 
    * is advised to request them again when needed.
    * 
    * @return Should always return SUCCESS
    */
   event error_t statusChanged();
   
  /* Returns my distance to the dest */
  
  
  /*command error_t getDistance(Coordinates * dest, uint16_t * distance);*/  //Qasim Mansoor 1/15/2007
 
}
