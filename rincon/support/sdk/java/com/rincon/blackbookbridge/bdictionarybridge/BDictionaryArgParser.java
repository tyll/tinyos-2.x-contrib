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


import com.rincon.util.DataOutput;
import com.rincon.util.Util;
import com.rincon.blackbookbridge.TinyosError;
import com.rincon.blackbookbridge.bdictionarybridge.BDictionaryMsg;

public class BDictionaryArgParser implements BDictionary_Events {

	/** Transceiver communication with the mote */
	private BDictionary bDictionary;
	
	/**
	 * Constructor
	 * @param args
	 */
	public BDictionaryArgParser(String[] args, int destination) {
		bDictionary = new BDictionary();
		bDictionary.addListener(this);
		
		if(args.length < 1) {
			reportError("Not enough arguments");
		}
		
		if(args[0].toLowerCase().matches("-open")) {
			if (args.length > 2) {
				bDictionary.open(destination, args[1], Util.parseInt(args[2]));
			} else {
				reportError("Missing parameter(s)");
			}
			
		} else if(args[0].toLowerCase().matches("-close")) {
			bDictionary.close(destination);
			
		} else if(args[0].toLowerCase().matches("-insert")) {
			if (args.length > 3) {
				if(Util.parseShort(args[3]) > BDictionaryMsg.totalSize_byteArray()) {
					reportError("Cannot fit value size + " + Util.parseShort(args[3]) + " into a single UART message with data size " + BDictionaryMsg.totalSize_byteArray());
				}
				bDictionary.insert(destination, Util.parseLong(args[1]), Util.stringToData(args[2]), Util.parseShort(args[3]));
			} else {
				reportError("Missing parameter(s)");
			}
			
		} else if(args[0].toLowerCase().matches("-retrieve")) {
			if(args.length > 1) {
				bDictionary.retrieve(destination, Util.parseLong(args[1]));
			} else {
				reportError("Missing parameter(s)");
			}
			
		} else if(args[0].toLowerCase().matches("-remove")) {
			if(args.length > 1) {
				bDictionary.remove(destination, Util.parseLong(args[1]));
			} else {
				reportError("Missing parameter(s)");
			}
			
		} else if(args[0].toLowerCase().matches("-gettotalkeys")) {
			bDictionary.getTotalKeys(destination);
			
		} else if(args[0].toLowerCase().matches("-getfirstkey")) {
			bDictionary.getFirstKey(destination);
			
		} else if(args[0].toLowerCase().matches("-getnextkey")) {
			if(args.length > 1) {
				bDictionary.getNextKey(destination, Util.parseLong(args[1]));
			} else {
				reportError("Missing parameter(s)");
			}
			
		} else if(args[0].toLowerCase().matches("-getlastkey")) {
			bDictionary.getLastKey(destination);
			
		} else if(args[0].toLowerCase().matches("-isdictionary")) {
			if(args.length > 1) {
				bDictionary.isFileDictionary(destination, args[1]);
			} else {
				reportError("Missing parameter(s)");
			}
			
		} else if(args[0].toLowerCase().matches("-isopen")) {
			if(bDictionary.isOpen(destination)) {
				System.out.println("File is open");
			} else {
				System.out.println("File is not open");
			}
			System.exit(0);
		
		} else if(args[0].toLowerCase().matches("-getfilelength")) {
			System.out.println(bDictionary.getFileLength(destination) + " bytes");
			System.exit(0);
			
		} else {
			reportError("Unknown argument: " + args[0]);
		}
	}
	
	private void reportError(String error) {
		System.err.println(error);
		System.err.println(getUsage());
		System.exit(1);
	}
	
	
	public static String getUsage() {
		String usage = "";
		usage += "  BDictionary\n";
		usage += "\t-open <filename> <minimum size>\n";
		usage += "\t-isOpen\n";
		usage += "\t-close\n";
		usage += "\t-insert <key> <value> <length>\n";
		usage += "\t-retrieve <key>\n";
		usage += "\t-remove <key>\n";
		usage += "\t-getTotalKeys\n";
		usage += "\t-getFirstKey\n";
		usage += "\t-getNextKey <current key>\n";
		usage += "\t-getLastKey\n";
		usage += "\t-isDictionary <filename>\n";
		usage += "\t-getFileLength\n";
		return usage;
	}
	
	

	/***************** BDictionary Events ****************/
	public void bDictionary_opened(long totalSize, long remainingBytes, TinyosError error) {
		System.out.print("BDictionary opened ");
		if(error.wasSuccess()) {
			System.out.println("SUCCESS: " + totalSize + " bytes");
		} else {
			System.out.println("FAIL");
		}
		System.exit(0);	
	}

	public void bDictionary_closed(TinyosError error) {
		System.out.print("Closed ");
		if(error.wasSuccess()) {
			System.out.println("SUCCESS");
		} else {
			System.out.println("FAIL");
		}
		System.exit(0);
	}

	public void bDictionary_inserted(long key, short[] value, int valueSize, TinyosError error) {
		System.out.print("BDictionary inserted ");
		if(error.wasSuccess()) {
			System.out.println("SUCCESS: Key 0x" + Long.toHexString(key).toUpperCase() + " Inserted");
		} else {
			System.out.println("FAIL");
		}
		System.exit(0);
	}

	public void bDictionary_retrieved(long key, short[] value, int valueSize, TinyosError error) {
		System.out.print("BDictionary retrieved ");
		if(error.wasSuccess()) {
			System.out.println("SUCCESS");
			DataOutput output = new DataOutput();
			output.output(value, valueSize);
			output.flush();

		} else {
			System.out.println("FAIL");
		}
		System.exit(0);
				
	}

	public void bDictionary_removed(long key, TinyosError error) {
		System.out.print("BDictionary removed ");
		if(error.wasSuccess()) {
			System.out.println("SUCCESS: Key 0x" + Long.toHexString(key).toUpperCase() + " Removed");
		} else {
			System.out.println("FAIL");
		}
		System.exit(0);
	}

	public void bDictionary_nextKey(long nextKey, TinyosError error) {
		System.out.print("BDictionary next key ");
		if(error.wasSuccess()) {
			System.out.println("SUCCESS: Next Key is 0x" + Long.toHexString(nextKey).toUpperCase());
		} else {
			System.out.println("FAIL");
		}
		System.exit(0);
	}

	public void bDictionary_fileIsDictionary(boolean isDictionary, TinyosError error) {
		System.out.print("BDictionary fileIsDictionary ");
		if(error.wasSuccess()) {
			System.out.print("SUCCESS: File ");
			if(isDictionary) {
				System.out.print("is");
			} else {
				System.out.print("is NOT");
			}
			System.out.println(" a dictionary file.");
		} else {
			System.out.println("FAIL");
		}
		
		System.exit(0);
	}

	public void bDictionary_totalKeys(int totalKeys) {
		System.out.println("BDictionary total keys " + totalKeys);
		System.exit(0);
	}

}
