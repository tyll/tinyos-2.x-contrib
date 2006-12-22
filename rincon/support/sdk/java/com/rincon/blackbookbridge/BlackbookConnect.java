package com.rincon.blackbookbridge;

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


import com.rincon.blackbookbridge.bbootbridge.BBoot;
import com.rincon.blackbookbridge.bbootbridge.BBoot_Events;
import com.rincon.blackbookbridge.bcleanbridge.BClean;
import com.rincon.blackbookbridge.bcleanbridge.BClean_Events;
import com.rincon.blackbookbridge.bdictionarybridge.BDictionaryArgParser;
import com.rincon.blackbookbridge.bfiledeletebridge.BFileDeleteArgParser;
import com.rincon.blackbookbridge.bfiledirbridge.BFileDirArgParser;
import com.rincon.blackbookbridge.bfilereadbridge.BFileReadArgParser;
import com.rincon.blackbookbridge.bfilewritebridge.BFileWriteArgParser;

/*
 * Copyright (c) 2004-2006 Rincon Research Corporation.  
 * All rights reserved.
 * 
 * Rincon Research will permit distribution and use by others subject to
 * the restrictions of a licensing agreement which contains (among other things)
 * the following restrictions:
 * 
 *  1. No credit will be taken for the Work of others.
 *  2. It will not be resold for a price in excess of reproduction and 
 *      distribution costs.
 *  3. Others are not restricted from copying it or using it except as 
 *      set forward in the licensing agreement.
 *  4. Commented source code of any modifications or additions will be 
 *      made available to Rincon Research on the same terms.
 *  5. This notice will remain intact and displayed prominently.
 * 
 * Copies of the complete licensing agreement may be obtained by contacting 
 * Rincon Research, 101 N. Wilmot, Suite 101, Tucson, AZ 85711.
 * 
 * There is no warranty with this product, either expressed or implied.  
 * Use at your own risk.  Rincon Research is not liable or responsible for 
 * damage or loss incurred or resulting from the use or misuse of this software.
 */


public class BlackbookConnect implements BBoot_Events, BClean_Events {
	
	/** Boot Transceiver */
	private BBoot bBoot;
	
	/** BClean Transceiver */
	private BClean bClean;

	/**
	 * Main Method
	 * @param args
	 */
	public static void main(String[] args) {
		new BlackbookConnect(args);
	}

	
	/**
	 * Constructor
	 */
	public BlackbookConnect(String[] args) {
		bBoot = new BBoot();
		bBoot.addListener(this);
		
		bClean = new BClean();
		bClean.addListener(this);
		
		processArguments(args);
	}

	/**
	 * Process the command line arguments and send the
	 * commands to the mote for execution
	 * @param args
	 */
	private void processArguments(String[] args) {
		if(args.length < 2) {
			System.err.println("Not enough arguments!");
			usage();
			System.exit(1);
		}
		
		int destination = 0;
		try {
			destination = Integer.decode(args[0]).intValue();
		} catch (NumberFormatException e) {
			System.err.println("Missing destination address");
			usage();
			System.exit(1);
		}
		
		if(args[1].toLowerCase().matches("bdictionary")) {
			new BDictionaryArgParser(getSubArgs(args), destination);
			
		} else if(args[1].toLowerCase().matches("bfiledelete")) {
			new BFileDeleteArgParser(getSubArgs(args), destination);
			
		} else if(args[1].toLowerCase().matches("bfiledir")) {
			new BFileDirArgParser(getSubArgs(args), destination);
			
		} else if(args[1].toLowerCase().matches("bfileread")) {
			new BFileReadArgParser(getSubArgs(args), destination);
			
		} else if(args[1].toLowerCase().matches("bfilewrite")) {
			new BFileWriteArgParser(getSubArgs(args), destination);
			
		} else {
			System.err.println("Unknown Argument: " + args[1]);
			usage();
			System.exit(1);
		}
	}

	
	/**
	 * Print all argument parsers' command line usage
	 *
	 */
	private void usage() {
		System.out.println("\nBlackbook Usage:");
		System.out.println("com.rincon.blackbookbridge.BlackbookConnect [addr] [interface] -[command] <params>");
		System.out.println("_____________________________________");
		System.out.println(BDictionaryArgParser.getUsage());
		System.out.println(BFileDeleteArgParser.getUsage());
		System.out.println(BFileDirArgParser.getUsage());
		System.out.println(BFileReadArgParser.getUsage());
		System.out.println(BFileWriteArgParser.getUsage());
	}
	
	/** 
	 * Extract the sub-arguments for a given command
	 * @param args
	 * @return everything but the first index
	 */
	private String[] getSubArgs(String[] args) {
		String[] subArgs = new String[args.length - 2];
		
		for(int i = 0; i < args.length - 2; i++) {
			subArgs[i] = args[i+2];
		}
		
		return subArgs;
	}
	


	public void bBoot_booted(int totalNodes, short totalFiles, TinyosError error) {
		System.out.print("Blackbook Boot: ");
		if(error.wasSuccess()) {
			System.out.println("SUCCESS");
		} else {
			System.out.println("FAIL");
		}
		System.out.println("\t" + totalNodes + " nodes; " + totalFiles + " files.");
	}

	public void bClean_erasing() {
		System.out.println("Erasing Sector... Please wait.");
		
	}

	public void bClean_gcDone(boolean eraseBlocksErased) {
		System.out.println("Done Erasing Sectors");
		
	}


}
