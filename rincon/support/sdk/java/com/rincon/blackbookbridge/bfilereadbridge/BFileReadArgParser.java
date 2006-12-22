package com.rincon.blackbookbridge.bfilereadbridge;

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


import com.rincon.util.DataOutput;
import com.rincon.util.Util;
import com.rincon.blackbookbridge.TinyosError;

public class BFileReadArgParser implements BFileRead_Events {

	/** Transceiver communication with the mote */
	private BFileRead bFileRead;
	
	/**
	 * Constructor
	 * @param args
	 */
	public BFileReadArgParser(String[] args, int destination) {
		bFileRead = new BFileRead();
		bFileRead.addListener(this);
		
		if(args.length < 1) {
			reportError("Not enough arguments");
		}
		
		if(args[0].toLowerCase().matches("-open")) {
			if (args.length > 1) {
				bFileRead.open(destination, args[1]);
			} else {
				reportError("Missing parameter(s)");
			}
			
		} else if(args[0].toLowerCase().matches("-close")) {
			bFileRead.close(destination);
			
		} else if(args[0].toLowerCase().matches("-read")) {
			// Keep in mind that a message can only hold so many bytes
			// and the TestBlackbook app on the mote will automatically
			// adjust to the correct size for a reply.
			if (args.length > 1) {
				bFileRead.read(destination, Util.parseShort(args[1]));
			} else {
				reportError("Missing parameter(s)");
			}
			
		} else if(args[0].toLowerCase().matches("-seek")) {
			if (args.length > 1) {
				if(bFileRead.seek(destination, Util.parseLong(args[1])).wasSuccess()) {
					System.out.println("Now at address 0x" + Long.toHexString(Util.parseLong(args[1])));
				} else {
					System.out.println("FAIL");
				}
				System.exit(0);
				
			} else {
				reportError("Missing parameter(s)");
			}
			
		} else if(args[0].toLowerCase().matches("-skip")) {
			if (args.length > 1) {
				if(bFileRead.skip(destination, Util.parseInt(args[1])).wasSuccess()) {
					System.out.println("Skipped " + Util.parseInt(args[1]) + " [bytes]");
				} else {
					System.out.println("FAIL");
				}
				System.exit(0);
				
			} else {
				reportError("Missing parameter(s)");
			}
			
		} else if(args[0].toLowerCase().matches("-getremaining")) {
			System.out.println(bFileRead.getRemaining(destination) + " bytes remaining");
			System.exit(0);
			
		} else if(args[0].toLowerCase().matches("-isopen")) {
			if(bFileRead.isOpen(destination)) {
				System.out.println("File is open");
			} else {
				System.out.println("File is not open");
			}
			System.exit(0);
			
		} else {
			System.err.println("Unknown argument: " + args[0]);
			System.err.println(getUsage());
			System.exit(1);
		}
	}
	
	private void reportError(String error) {
		System.err.println(error);
		System.err.println(getUsage());
		System.exit(1);
	}
	
	public static String getUsage() {
		String usage = "";
		usage += "  BFileRead\n";
		usage += "\t-open <filename>\n";
		usage += "\t-isOpen\n";
		usage += "\t-close\n";
		usage += "\t-read <amount>\n";
		usage += "\t-seek <address>\n";
		usage += "\t-skip <amount>\n";
		usage += "\t-getRemaining\n";
		return usage;
	}
	
	
	/***************** BFileRead Events ***************/
	public void opened(String fileName, long amount, boolean result) {

	}


	public void closed(boolean result) {

	}


	public void readDone(short[] dataBuffer, int amount, boolean result) {

	}

	public void bFileRead_opened(long amount, TinyosError error) {
		System.out.print("BFileRead opened ");
		if(error.wasSuccess()) {
			System.out.println("SUCCESS: " + amount + " bytes");
		} else {
			System.out.println("FAIL");
		}
		System.exit(0);
		
	}

	public void bFileRead_closed(TinyosError error) {
		System.out.print("Closed ");
		if(error.wasSuccess()) {
			System.out.println("SUCCESS");
		} else {
			System.out.println("FAIL");
		}
		System.exit(0);
	}

	public void bFileRead_readDone(short[] data, int amount, TinyosError error) {
		System.out.print("BFileRead readDone ");
		if(error.wasSuccess()) {
			System.out.println("SUCCESS: " + amount + " bytes read\n");
			DataOutput output = new DataOutput();
			output.output(data, amount);
			output.flush();
			
		} else {
			System.out.println("FAIL");
		}
		System.exit(0);
	}

}
