package com.rincon.progress.standalone;

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


import com.rincon.progress.MoteProgressListener;
import com.rincon.progress.MoteProgressProvider;

import net.tinyos.message.MoteIF;
import net.tinyos.util.Messenger;

public class StandaloneProgressIndicator implements MoteProgressListener {

	/** Communication with the mote */
	private MoteIF comm = new MoteIF((Messenger) null);
		
	/** The object that provides progress updates */
	private MoteProgressProvider progressProvider;
	
	/** CLI output for the transfer progress */
	private CliTransferProgress cliOutput;
	
	/**
	 * Constructor
	 *
	 */
	public StandaloneProgressIndicator() {
		progressProvider = new MoteProgressProvider(comm);
		progressProvider.addListener(this, 0xD0);
	}
	
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		new StandaloneProgressIndicator();
	}


	public void update(long completed, long total) {
		if(cliOutput == null) {
			cliOutput = new CliTransferProgress(total);
		}
		
		cliOutput.update(completed);
		
		if(completed == total) {
			cliOutput = null;
		}
	}

}
