package com.rincon.blackbookbridge.bfilewritebridge;

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



import com.rincon.blackbookbridge.TinyosError;
import com.rincon.util.Util;

public class BFileWriteArgParser implements BFileWrite_Events {

	/** Transceiver communication with the mote */
	private BFileWrite bFileWrite;
	
	public BFileWriteArgParser(String[] args, int destination) {
		bFileWrite = new BFileWrite();
		bFileWrite.addListener(this);
		
		if(args.length < 1) {
			reportError("Not enough arguments");
		}
		
		if(args[0].toLowerCase().matches("-open")) {
			if (args.length > 2) {
				bFileWrite.open(destination, args[1], Util.parseLong(args[2]));
			} else {
				reportError("Missing parameter(s)");
			}
			
		} else if(args[0].toLowerCase().matches("-close")) {
			bFileWrite.close(destination);
			
		} else if(args[0].toLowerCase().matches("-save")) {
			bFileWrite.save(destination);
			
		} else if(args[0].toLowerCase().matches("-append")) {
			// We can append any length of data we want,
			// but since our TOS_Msg can only hold so many bytes,
			// we'll stick with that maximum.  And because we
			// can only type characters into the command line, we'll
			// stick with that too.  Keep in mind, for testing purposes,
			// it would also be easy to have an argument to this command
			// line function to say how many bytes to append.
			if (args.length > 1) {
				int length = args[1].length();
				if(length >= BFileWriteMsg.totalSize_byteArray()) {
					length = BFileWriteMsg.totalSize_byteArray();
				}
				bFileWrite.append(destination, Util.stringToData(args[1]), length);
				
			} else {
				reportError("Missing parameter(s)");
			}
			
		} else if(args[0].toLowerCase().matches("-getremaining")) {
			System.out.println(bFileWrite.getRemaining(destination) + " bytes available for writing");
			System.exit(0);
			
		} else if(args[0].toLowerCase().matches("-isopen")) {
			if(bFileWrite.isOpen(destination)) {
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
		usage += "  BFileWrite\n";
		usage += "\t-open <filename>\n";
		usage += "\t-isopen\n";
		usage += "\t-close\n";
		usage += "\t-save\n";
		usage += "\t-append <written data>\n";
		usage += "\t-getRemaining\n";
		return usage;
	}
	

	/***************** BFileWrite Events ****************/
	public void bFileWrite_opened(long len, TinyosError error) {
		System.out.print("BFileWrite opened ");
		if(error.wasSuccess()) {
			System.out.println("SUCCESS: " + len + " bytes");
		} else {
			System.out.println("FAIL");
		}
		System.exit(0);
	}

	public void bFileWrite_closed(TinyosError error) {
		System.out.print("Closed ");
		if(error.wasSuccess()) {
			System.out.println("SUCCESS");
		} else {
			System.out.println("FAIL");
		}
		System.exit(0);
		
	}

	public void bFileWrite_saved(TinyosError error) {
		System.out.print("BFileWrite save ");
		if(error.wasSuccess()) {
			System.out.println("SUCCESS");
		} else {
			System.out.println("FAIL");
		}
		System.exit(0);
	}

	public void bFileWrite_appended(int amountWritten, TinyosError error) {
		System.out.print("BFileWrite append ");
		
		if(error.wasSuccess()) {
			System.out.println("SUCCESS: " + amountWritten + " bytes");
		} else {
			System.out.println("FAIL");
		}
		System.exit(0);
	}
	
}
