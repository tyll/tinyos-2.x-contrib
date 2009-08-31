
configuration IntToHexStrC {
  provides {
    interface IntToHexStr;
  }
}

implementation {
  components IntToHexStrP,
      StringWriterC;
      
  IntToHexStr = IntToHexStrP;
  
  IntToHexStrP.StringWriter -> StringWriterC;
  
  components LedsC;
  IntToHexStrP.Leds -> LedsC;
  
}

