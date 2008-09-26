

//includes EEPROM;


interface ObjLog {

  /**
   * Appends bytes to the end of the log.  Will return <code>FAIL</code> 
   * on any of the following conditions.
   * <p>
   * <code>numbytes</code> is zero too large to fit on a page of flash (>250)
   * The flash is busy or a flash error occured
   *
   * @param data the data to be appended to the log
   * @param numbytes the number of bytes to be appended
   *
   * @return FAIL if the write cannot occur, SUCCESS otherwise
   */
  command result_t append(int logid, uint8_t *data, uint8_t numbytes);
  
  /**
   * Notification that a append command has been completed.
   * Signaled by <code>append()</code>.
   *
   * @param success SUCCESS if the append was successful
   *
   * @return ignored 
   */
  event result_t appendDone(int logid, result_t success);
  
  /**
   * Read the next chunk from the log
   *
   * @param buffer The buffer to read data into.
   * @return FAIL if the component is busy, SUCCESS otherwise.
   */
   
  command result_t read(int logid, bool *eol);
  
  /**
   * Signaled when a read completes. 
   * Note: <code>buffer</code> is not valid after return.  So, don't save it.
   * Instead copy out the data you need inside the event handler.
   *
   * @param buffer The buffer containing the read data.
   * @param numbytes the number of bytes read
   * @param success Whether the read was successful. If FAIL, the
   *   buffer data is invalid.
   * 
   */
  event result_t readDone(int logid, uint8_t *buffer, uint16_t numbytes, result_t success);
  
  /**
   * Set the current read position (relative to the start of the log)
   *
   * @param page the page (relative to the beginning of the log) to seek to.
   *
   * @return FAIL if the page is invalid, SUCCESS otherwise.
   */
  command result_t seek(int logid, uint16_t page);

  /**
  	* Delete the oldest page in the log.
	*
	*	@return FAIL if there is nothing to delete.
	*/
  command result_t deletePage(int logid);
  command result_t deleteAll(int logid);
  
  command uint16_t getNumPages(int logid);
  command uint16_t getReadPage(int logid);
  command uint16_t getReadOffset(int logid);
  
  command result_t tryCommit();
  
}

