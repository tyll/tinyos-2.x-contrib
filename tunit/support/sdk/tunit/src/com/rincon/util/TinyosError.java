package com.rincon.util;

/*
 * Copyright (c) 2005-2007 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

public class TinyosError {
  
  /** TinyError definitions */
  public static final short SUCCESS = 0;
  public static final short FAIL = 1;
  public static final short ESIZE = 2;
  public static final short ECANCEL = 3;
  public static final short EOFF = 4;
  public static final short EBUSY = 5;
  public static final short EINVAL = 6;
  public static final short ERETRY = 7;
  public static final short ERESERVE = 8;
  public static final short NOTRECEIVED = 0xFF;
  
  /** The return error_t from TinyOS */
  private short myError;
  
  /**
   * Constructor
   * @param error
   */
  public TinyosError(short error) {
    myError = error;
  }
  
  /**
   * @return the error code
   */
  public short getError() {
    return myError;
  }
  
  /**
   * @return true if there was no error
   */
  public boolean wasSuccess() {
    return myError == SUCCESS;
  }
  
  /**
   * @return false if we didn't get a reply from the mote
   */
  public boolean wasDelivered() {
    return myError != NOTRECEIVED;
  }
}
