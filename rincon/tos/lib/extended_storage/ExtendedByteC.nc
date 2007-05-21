
/**
 * @author David Moss
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */
 
generic configuration ExtendedByteC(char extensionId[]) {
  provides {
    interface ParameterStorage as ByteStorage;
  }
}

implementation {
  components ExtendedByteP;
  
  enum {
    PARAMETER_OFFSET = unique(extensionId),
  };
  
  ByteStorage = ExtendedByteP.ByteStorage[PARAMETER_OFFSET];
  
}


