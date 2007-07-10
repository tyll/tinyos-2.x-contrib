/*
 * Authors:		Sarah Bergbreiter
 * Date last modified:  10/3/03
 *
 * SlotRing Interface -- provides an interface for keeping track of
 * currently connected neighbors and keeping the same neighborhood
 * table across those neighbors.  This interface also provides events
 * to higher level components to let it know when its slot time
 * occurs.
 *
 */


interface SlotRing {


  /**
   *  Add a neighbor
   * 
   *  @param id New neighbor id
   *
   *  @return none
   **/
  command result_t addNeighbor(int16_t id);

  /**
   *  Remove a neighbor
   * 
   *  @param id neighbor id
   *
   *  @return none
   **/
  command result_t removeNeighbor(int16_t id);

  /**
   *  Check if id is currently a neighbor
   * 
   *  @param id neighbor id
   *
   *  @return position in table if is neighbor, -1 otherwise
   **/
  command int8_t isNeighbor(int16_t id);

  /**
   *  Return the number of current neighbors
   *
   *  @return number of neighbors
   **/
  command uint8_t numNeighbors();

  /**
   *  Clear the neighbor list
   * 
   *  @return none
   **/
  command result_t clearNeighbors();

  /**
   *  Copy the neighbor list
   * 
   *  @return none
   **/
  command result_t copyNeighbors(int16_t* table);

  /**
   *  Set a new tick length
   * 
   *  @param tickLength new tick length
   *
   *  @return none
   **/
  command result_t setTickLength(int16_t tickLength);

  /**
   *  An event sent when this motes slot period is
   *  beginning.
   *
   *  @param slotPosition Current slot number
   *
   *  @return none
   **/
  event result_t startSlotPeriod(uint8_t slotPosition);

  /**
   *  An event sent when this motes slot period is
   *  over.
   *
   *  @param slotPosition Current slot number
   *
   *  @return none
   **/
  event result_t endSlotPeriod(uint8_t slotPosition);


}










