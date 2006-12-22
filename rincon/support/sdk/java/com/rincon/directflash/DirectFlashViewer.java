package com.rincon.directflash;

import com.rincon.directflash.messages.ViewerMsg;
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

public class DirectFlashViewer {

	/** Object to run the commands */
	private CommandRunner runner = new CommandRunner();

	/*
	 * 	// Read the starting address
		if (argv.length > ++index) {
			startingAddress = parseLong(argv[index]);
		} else {
			reportError("Read requires a start address");
		}
		
		// Read the length
		if (argv.length > ++index) {
			packet.set_len(parseInt(argv[index]));
		} else {
			reportError("Data length required");
		}
		
		// Read the filename
		if (argv.length > ++index) {
			packet.set_data(stringToData(argv[index]));
		} else {
			reportError("Filename required");
		}
	 */
	
	
	/**
	 * Constructor
	 * @param args
	 */
	public DirectFlashViewer(String[] argv) {
		if (argv.length < 1) {
			reportError("No arguments found");
		}

		int index = 0;
		String cmd = argv[0];
		

		long startAddress = 0;
		int moteID = 0;
		long actualRange = 0;
		short volume = 0;
		short[] data = new short[ViewerMsg.totalSize_data()];
		
		// Find and set the default mote id
		if((moteID = parseInt(argv[0])) == -1) {
			moteID = 1;
		} else {
			if(argv.length > 1) {
				cmd = argv[1];
			} else {
				reportError("No command given");
			}
		}
		
		if(cmd.matches("-read")) {
			// Get the start address
			if (argv.length > ++index) {
				startAddress = parseLong(argv[index]);
			} else {
				reportError("Missing [start address]");
			}
			
			// Get the range
			if (argv.length > ++index) {
				actualRange = parseLong(argv[index]);
			} else {
				reportError("Missing [range]");
			}
			
			runner.read(startAddress, actualRange, moteID);
			

		} else if(cmd.matches("-write")) {

			// Get the start address
			if (argv.length > ++index) {
				startAddress = parseLong(argv[index]);
			} else {
				reportError("Missing [start address]");
			}
			
			char[] rawdata = null;
			if (argv.length > ++index) {
				rawdata = argv[index].toCharArray();
				data = new short[ViewerMsg.totalSize_data()];

				System.out.println("Writing data");
				for (int i = 0; i < data.length && i < rawdata.length; i++) {
					data[i] = (short) rawdata[i];
					System.out.print("0x" + Integer.toHexString((int) data[i])
							+ " ");
				}
				System.out.println();

			} else {
				reportError("Missing [data]");
			}
			
			runner.write(startAddress, data, rawdata.length, moteID);

			
		} else if(cmd.matches("-erase")) {
			// Get the start address
			if (argv.length > ++index) {
				startAddress = parseLong(argv[index]);
			} else {
				reportError("Missing [sector]");
			}
			
			runner.erase((int) startAddress, moteID);
			
			
		} else if(cmd.matches("-flush")) {
			runner.flush(moteID);
			
		} else if(cmd.matches("-crc")) {
			// Get the start address
			if (argv.length > ++index) {
				startAddress = parseLong(argv[index]);
			} else {
				reportError("Missing [start address]");
			}
			
			// Get the range
			if (argv.length > ++index) {
				actualRange = parseLong(argv[index]);
			} else {
				reportError("Missing [range]");
			}
			
			runner.crc(startAddress, (int)actualRange, moteID);
			
			
		} else if(cmd.matches("-ping")) {
			runner.ping(moteID);
			
		} else {
			reportError("No command given");
		}
	}
	
	/**
	 * Attempt to decode the int value, and deal with any illegible remarks.
	 * 
	 * @param intString
	 * @return
	 */
	public int parseInt(String intString) {
		try {
			return Integer.decode(intString).intValue();
		} catch (NumberFormatException e) {
			return -1;
		}
	}

	/**
	 * Attempt to decode the long value, and deal with any illegible remarks.
	 * 
	 * @param longString
	 * @return
	 */
	public long parseLong(String longString) {
		try {			
			return Long.decode(longString).longValue();
		} catch (NumberFormatException e) {
			reportError(e.getMessage());
		}

		return -1;
	}

	

	/**
	 * Takes a filename string and converts it to a 14 element
	 * filename short array
	 * @param s
	 * @return
	 */
	public short[] stringToData(String s) {
		int filenameLength = 14;
		short[] returnData = new short[filenameLength];
		char[] charData = s.toCharArray();
		
		for(int i = 0; i < charData.length && i < filenameLength; i++) {
			returnData[i] = (short) charData[i];
		}
		
		for(int i = charData.length; i < filenameLength; i++) {
			returnData[i] = 0;
		}
		
		return returnData;
	}
	
	
	/**
	 * Report the syntax error, print the usage, and exit.
	 * 
	 * @param error
	 */
	private void reportError(String error) {
		System.err.println(error);
		usage();
		System.exit(1);
	}

	/**
	 * Prints the usage for this application
	 * 
	 */
	private static void usage() {
		System.err.println("Usage: java com.rincon.directflash.DirectFlashViewer [mote] [command]");
		System.err.println("  COMMANDS");
		System.err.println("    -read [start address] [range]");
		System.err.println("    -write [start address] [" + ViewerMsg.totalSize_data() + " characters]");
		System.err.println("    -erase [sector]");
		System.err.println("    -flush");
		System.err.println("    -crc [start address] [range]");
		System.err.println("    -ping");
		System.err.println();
	}
	
	/**
	 * Main method
	 * @param args
	 */
	public static void main(String[] args) {
		new DirectFlashViewer(args);
	}
}
