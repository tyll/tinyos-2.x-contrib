/*
 * Copyright (c) 2008 Rincon Research Corporation
 * All rights reserved.
 *
 * Use, copying, modifying and distribution of this software and its 
 * documentation for any purpose is prohibited without written consent
 * by Rincon Research Corporation
 */
 

/**
 * @author David Moss
 */
 
configuration StringWriterC {
  provides {
    interface StringWriter;
  }
}

implementation {
  
  components StringWriterP;
  
  StringWriter = StringWriterP;
  
}

