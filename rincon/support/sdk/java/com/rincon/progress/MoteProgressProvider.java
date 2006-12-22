package com.rincon.progress;

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

import com.rincon.progress.messages.ProgressMsg;
import net.tinyos.message.Message;
import net.tinyos.message.MessageListener;
import net.tinyos.message.MoteIF;

public class MoteProgressProvider implements MessageListener {
	
	/** Communications link with the mote */
	private MoteIF comm;
	
	/** List of FileTransferEvents listeners */
	private static List listeners = new ArrayList();

	/**
	 * Constructor
	 * @param communications
	 */
	public MoteProgressProvider (MoteIF communications) {
		comm = communications;
		comm.registerListener(new ProgressMsg(), this);
	}
	
	
	/**
	 * Message Receiver
	 */
	public void messageReceived(int to, Message m) {
		ProgressMsg inMsg = (ProgressMsg) m;
		
		MoteListenerRecord focusedRecord;
		for(Iterator it = listeners.iterator(); it.hasNext(); ) {
			focusedRecord = (MoteListenerRecord) it.next();
			if(focusedRecord.getAppId() == inMsg.get_appId()) {
				focusedRecord.getListener().update(inMsg.get_completed(), inMsg.get_total());
			}
		}
	}

	

	/**
	 * Add a MoteProgressListener
	 * @param listener
	 */
	public void addListener(MoteProgressListener listener, int applicationId) {
		MoteListenerRecord focusedRecord;
		for(Iterator it = listeners.iterator(); it.hasNext(); ) {
			focusedRecord = (MoteListenerRecord) it.next();
			if(focusedRecord.getListener() == listener && focusedRecord.getAppId() == applicationId) {
				// We already added this listener
				return;
			}
		}
		
		listeners.add(new MoteListenerRecord(listener, applicationId));
	}
	
	/**
	 * Remove a MoteProgressListener listener
	 * @param listener
	 */
	public void removeListener(MoteProgressListener listener, int applicationId) {
		MoteListenerRecord focusedRecord;
		for(Iterator it = listeners.iterator(); it.hasNext(); ) {
			focusedRecord = (MoteListenerRecord) it.next();
			if(focusedRecord.getListener() == listener && focusedRecord.getAppId() == applicationId) {
				listeners.remove(focusedRecord);
			}
		}
	}
}
