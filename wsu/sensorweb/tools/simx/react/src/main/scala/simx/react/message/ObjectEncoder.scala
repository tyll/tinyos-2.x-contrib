package simx.react.message

class IncompletePartial(expected: Int, found: Int) extends Exception {
  override def toString = "Incomplete fixed data: " + found + "/" + expected
}

/*
 * Massage a variable-length ending into and out of messages.
 */
abstract trait ObjectEncoder {
  
  /*
   * Length of fixed header.
   */
  val fixedLength: Int
  
  /*
   * Message AM type.
   */
  val AM_TYPE: Int
  
  /*
   * Extracts / creates fixed header
   */
  def fixed(data: Array[Byte]): Array[Byte] = { 
    if (data.length >= fixedLength) {
      data.subArray(0, fixedLength)
    } else if (data.length > 0) {
      throw new IncompletePartial(fixedLength, data.length)
    } else {
      emptyFixed
    }
  }
 
  def emptyFixed = new Array[Byte](fixedLength)
  
  def variable(data: Array[Byte]): Array[Byte] = {
    if (data.length > fixedLength) {
      data.subArray(fixedLength, data.length)
    } else {
      noVariable
    }
  }
  
  def noVariable = new Array[Byte](0)
    
}
