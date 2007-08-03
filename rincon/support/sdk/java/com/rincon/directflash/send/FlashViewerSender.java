package com.rincon.directflash.send;

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


import java.io.IOException;

import net.tinyos.message.Message;
import net.tinyos.message.MoteIF;
import net.tinyos.util.Messenger;

import com.rincon.directflash.ViewerCommands;
import com.rincon.directflash.messages.ViewerMsg;

public class FlashViewerSender implements FlashViewerCommands {
	
	/** Communication with the mote */
	/** Communication with the mote */
	private MoteIF comm = new MoteIF((Messenger) null);
	
	/** Command to send */
	private ViewerMsg command = new ViewerMsg();
	
	/**
	 * Send a message
	 * @param dest
	 * @param m
	 */
	private void send(int dest, Message m) {
		try {
			comm.send(dest, m);
		} catch (IOException e) {
			System.err.println("Couldn't contact the mote");
		}
	}
	
	
	public void read(long address, int length, int moteID) {
		command.set_addr(address);
		command.set_len(length);
		command.set_cmd(ViewerCommands.CMD_READ);
		send(moteID, command);
	}

	public void write(long address, short[] buffer, int length, int moteID) {
		command.set_addr(address);
		command.set_len(length);
		command.set_data(buffer);
		command.set_cmd(ViewerCommands.CMD_WRITE);
		send(moteID, command);
		
	}

	public void erase(int sector, int moteID) {
		command.set_addr(sector);
		command.set_cmd(ViewerCommands.CMD_ERASE);
		send(moteID, command);
		
	}

	public void crc(long address, int length, int moteID) {
		command.set_addr(address);
		command.set_len(length);
		command.set_cmd(ViewerCommands.CMD_CRC);
		send(moteID, command);
		
	}

	public void flush(int moteID) {
		command.set_cmd(ViewerCommands.CMD_FLUSH);
		send(moteID, command);
	}
	
	public void ping(int moteID) {
		command.set_cmd(ViewerCommands.CMD_PING);
		send(moteID, command);
	}
}
