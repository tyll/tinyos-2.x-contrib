package com.rincon.blackbookbridge.bdictionarybridge;

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


public class BDictionary_Constants {

  public static final short CMD_OPEN = 0;
  public static final short REPLY_OPEN = 1;
  public static final short CMD_ISOPEN = 2;
  public static final short REPLY_ISOPEN = 3;
  public static final short CMD_CLOSE = 4;
  public static final short REPLY_CLOSE = 5;
  public static final short CMD_GETFILELENGTH = 6;
  public static final short REPLY_GETFILELENGTH = 7;
  public static final short CMD_GETTOTALKEYS = 8;
  public static final short REPLY_GETTOTALKEYS = 9;
  public static final short CMD_INSERT = 10;
  public static final short REPLY_INSERT = 11;
  public static final short CMD_RETRIEVE = 12;
  public static final short REPLY_RETRIEVE = 13;
  public static final short CMD_REMOVE = 14;
  public static final short REPLY_REMOVE = 15;
  public static final short CMD_GETFIRSTKEY = 16;
  public static final short REPLY_GETFIRSTKEY = 17;
  public static final short CMD_GETLASTKEY = 18;
  public static final short REPLY_GETLASTKEY = 19;
  public static final short CMD_GETNEXTKEY = 20;
  public static final short REPLY_GETNEXTKEY = 21;
  public static final short CMD_ISFILEDICTIONARY = 22;
  public static final short REPLY_ISFILEDICTIONARY = 23;
  public static final short EVENT_OPENED = 24;
  public static final short EVENT_CLOSED = 25;
  public static final short EVENT_INSERTED = 26;
  public static final short EVENT_RETRIEVED = 27;
  public static final short EVENT_REMOVED = 28;
  public static final short EVENT_NEXTKEY = 29;
  public static final short EVENT_FILEISDICTIONARY = 30;
  public static final short EVENT_TOTALKEYS = 31;

  
}
