package com.rincon.directflash.receive;

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


import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.rincon.directflash.ViewerCommands;
import com.rincon.directflash.messages.ViewerMsg;

import net.tinyos.message.Message;
import net.tinyos.message.MessageListener;
import net.tinyos.message.MoteIF;
import net.tinyos.util.Messenger;

public class FlashViewerReceiver implements MessageListener {

	/** List of FileTransferEvents listeners */
	private static List listeners = new ArrayList();
	
	/** Communication with the mote */
	private static MoteIF comm = new MoteIF((Messenger) null);


	/**
	 * Constructor
	 *
	 */
	public FlashViewerReceiver() {
		comm.registerListener(new ViewerMsg(), this);
	}
	
	/**
	 * Add a FileTransferEvents listener
	 * @param listener
	 */
	public void addListener(FlashViewerEvents listener) {
		if(!listeners.contains(listener)) {
			listeners.add(listener);
		}
	}
	
	/**
	 * Remove a FileTransferEvents listener
	 * @param listener
	 */
	public void removeListener(FlashViewerEvents listener) {
		listeners.remove(listener);
	}
	
	
	/**
	 * Received a ViewerMsg from UART
	 */
	public void messageReceived(int to, Message m) {
		ViewerMsg inMsg = (ViewerMsg) m;
		
		switch(inMsg.get_cmd()) {
		case ViewerCommands.REPLY_FLUSH:
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).flushDone(true);
			}
			break;
		
		case ViewerCommands.REPLY_FLUSH_CALL_FAILED:
			System.err.println("Command immediately failed");
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).flushDone(false);
			}
			break;
		
		case ViewerCommands.REPLY_FLUSH_FAILED:
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).flushDone(false);
			}
			break;
			
		case ViewerCommands.REPLY_ERASE:
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).eraseDone((int)inMsg.get_addr(), true);
			}
			break;
			
		case ViewerCommands.REPLY_ERASE_CALL_FAILED:
			System.err.println("Command immediately failed");
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).eraseDone((int)inMsg.get_addr(), false);
			}
			break;
		
		case ViewerCommands.REPLY_ERASE_FAILED:
			System.err.println("Command immediately failed");
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).eraseDone((int)inMsg.get_addr(), false);
			}
			break;
			
		case ViewerCommands.REPLY_CRC:
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).crcDone(inMsg.get_len(), true);
			}
			break;
			
		case ViewerCommands.REPLY_CRC_CALL_FAILED:
			System.err.println("Command immediately failed");
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).crcDone(inMsg.get_len(), false);
			}
			break;
			
			
		case ViewerCommands.REPLY_CRC_FAILED:
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).crcDone(inMsg.get_len(), false);
			}
			break;
		
		case ViewerCommands.REPLY_READ:
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).readDone(inMsg.get_addr(), inMsg.get_data(), inMsg.get_len(), true);
			}
			break;
			
		case ViewerCommands.REPLY_READ_CALL_FAILED:
			System.err.println("Command immediately failed");
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).readDone(inMsg.get_addr(), inMsg.get_data(), inMsg.get_len(), false);
			}
			break;
			
		case ViewerCommands.REPLY_READ_FAILED:
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).readDone(inMsg.get_addr(), inMsg.get_data(), inMsg.get_len(), false);
			}
			break;
			
		case ViewerCommands.REPLY_WRITE:
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).writeDone(inMsg.get_addr(), inMsg.get_data(), inMsg.get_len(), true);
			}
			break;
			
		case ViewerCommands.REPLY_WRITE_CALL_FAILED:
			System.err.println("Command immediately failed");
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).writeDone(inMsg.get_addr(), inMsg.get_data(), inMsg.get_len(), false);
			}
			break;
			
		case ViewerCommands.REPLY_WRITE_FAILED:
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).writeDone(inMsg.get_addr(), inMsg.get_data(), inMsg.get_len(), false);
			}
			break;
			
		case ViewerCommands.REPLY_PING:
			for(Iterator it = listeners.iterator(); it.hasNext(); ) {
				((FlashViewerEvents) it.next()).pong();
			}
			break;
			
		default:
			System.err.println("Unrecognized FlashViewer message received (cmd " + inMsg.get_cmd() + ")");
			
		}
	}

}
