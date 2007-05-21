
/**
 * @author David Moss
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */
 
module ExtendedByteP {
  provides {
    interface ParameterStorage as ByteStorage[uint8_t parameterOffset];
  }
}

implementation {

  /***************** ByteStorage Commands ****************/
  /**
   * Get the data from the correct location from an extended structure
   * @param *extendedParameters Location of the extended structure array
   *     in the struct of interest
   */
  command void *ByteStorage.load[uint8_t parameterOffset](
      void *extendedParameters) {
    return (extendedParameters + parameterOffset);
  }
  
  /**
   * Set the data in the correct location in an extended structure
   * @param *extendedParameters Location of the extended structure array
   *     in the struct of interest
   * @param *parameter the parameter to store
   */
  command void ByteStorage.store[uint8_t parameterOffset](
      void *extendedParameters, void *parameter) {
    memcpy(extendedParameters + parameterOffset, parameter, 1);
  }
}

