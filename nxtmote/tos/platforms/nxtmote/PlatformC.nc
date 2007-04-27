/*
 * Copyright (c) 2005-2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/**
 * Dummy implementation to support the null platform.
 */

/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */

configuration PlatformC { 
  provides interface Init;
}
implementation {
  components PlatformP;
  Init = PlatformP;
  
  /* command error_t PInit.init() {
    unsigned long* PIOPER_ = (unsigned long*)0xFFFFF400;
    unsigned long* PIOOER_ =  (unsigned long*)0xFFFFF410;
    unsigned long* PIOCODR_ =  (unsigned long*)0xFFFFF434;	
    unsigned long LEDVAL_ =  (unsigned long)0x00000002;  

    *PIOPER_ = LEDVAL_;
    *PIOOER_ = LEDVAL_;
    *PIOCODR_ = LEDVAL_;
    return SUCCESS;
  } */
  
  
}
