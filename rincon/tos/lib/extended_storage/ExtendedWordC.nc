
/**
 * @author David Moss
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */
 
generic configuration ExtendedWordC(char extensionId[]) {
  provides {
    interface ParameterStorage as WordStorage;
  }
}

implementation {
  components ExtendedWordP;
  
  enum {
    PARAMETER_OFFSET = unique(extensionId),
    SECOND_BYTE = unique(extensionId),
  };
  
  WordStorage = ExtendedWordP.WordStorage[PARAMETER_OFFSET];
  
}

