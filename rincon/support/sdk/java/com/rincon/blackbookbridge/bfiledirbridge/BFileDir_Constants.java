package com.rincon.blackbookbridge.bfiledirbridge;

/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
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


public class BFileDir_Constants {

  public static final short CMD_GETTOTALFILES = 0;
  public static final short REPLY_GETTOTALFILES = 1;
  public static final short CMD_GETTOTALNODES = 2;
  public static final short REPLY_GETTOTALNODES = 3;
  public static final short CMD_GETFREESPACE = 4;
  public static final short REPLY_GETFREESPACE = 5;
  public static final short CMD_CHECKEXISTS = 6;
  public static final short REPLY_CHECKEXISTS = 7;
  public static final short CMD_READFIRST = 8;
  public static final short REPLY_READFIRST = 9;
  public static final short CMD_READNEXT = 10;
  public static final short REPLY_READNEXT = 11;
  public static final short CMD_GETRESERVEDLENGTH = 12;
  public static final short REPLY_GETRESERVEDLENGTH = 13;
  public static final short CMD_GETDATALENGTH = 14;
  public static final short REPLY_GETDATALENGTH = 15;
  public static final short CMD_CHECKCORRUPTION = 16;
  public static final short REPLY_CHECKCORRUPTION = 17;
  public static final short EVENT_CORRUPTIONCHECKDONE = 18;
  public static final short EVENT_EXISTSCHECKDONE = 19;
  public static final short EVENT_NEXTFILE = 20;

  
}
