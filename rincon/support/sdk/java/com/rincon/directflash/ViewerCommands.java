package com.rincon.directflash;

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

public class ViewerCommands {

	public static final short CMD_READ = 0;
	public static final short CMD_WRITE = 1; 
	public static final short CMD_ERASE = 2;
	public static final short CMD_FLUSH = 4;
	public static final short CMD_PING = 5;
	public static final short CMD_CRC = 6;
	
	public static final short REPLY_READ = 10;
	public static final short REPLY_WRITE = 11;
	public static final short REPLY_ERASE = 12;
	public static final short REPLY_FLUSH = 14;
	public static final short REPLY_PING = 15;
	public static final short REPLY_CRC = 16;
	
	public static final short REPLY_READ_CALL_FAILED = 20;
	public static final short REPLY_WRITE_CALL_FAILED = 21;
	public static final short REPLY_ERASE_CALL_FAILED = 22;
	public static final short REPLY_FLUSH_CALL_FAILED = 24;
	public static final short REPLY_CRC_CALL_FAILED = 26;
	
	public static final short REPLY_READ_FAILED = 30;
	public static final short REPLY_WRITE_FAILED = 31;
	public static final short REPLY_ERASE_FAILED = 32;
	public static final short REPLY_FLUSH_FAILED = 34;
	public static final short REPLY_CRC_FAILED = 36;
	
}