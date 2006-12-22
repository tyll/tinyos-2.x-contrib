package com.rincon.blackbookbridge.bfiledirbridge;

import com.rincon.blackbookbridge.TinyosError;

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


public class BFileDirArgParser implements BFileDir_Events {

	/** Transceiver communication with the mote */
	private BFileDir bFileDir;

	/**
	 * Constructor
	 * 
	 * @param args
	 */
	public BFileDirArgParser(String[] args, int destination) {
		bFileDir = new BFileDir();
		bFileDir.addListener(this);
		
		if (args.length < 1) {
			reportError("Not enough arguments");
		}

		if (args[0].toLowerCase().matches("-gettotalfiles")) {
			System.out.println(bFileDir.getTotalFiles(destination)
					+ " total files");
			System.exit(0);

		} else if (args[0].toLowerCase().matches("-gettotalnodes")) {
			System.out.println(bFileDir.getTotalNodes(destination)
					+ " total nodes");
			System.exit(0);

		} else if (args[0].toLowerCase().matches("-checkexists")) {
			if (args.length > 1) {
				bFileDir.checkExists(destination, args[1]);
			} else {
				reportError("Missing parameter(s)");
			}

		} else if (args[0].toLowerCase().matches("-readfirst")) {
			bFileDir.readFirst(destination);

		} else if (args[0].toLowerCase().matches("-readnext")) {
			if (args.length > 1) {
				bFileDir.readNext(destination, args[1]);
			} else {
				reportError("Missing parameter(s)");
			}

		} else if (args[0].toLowerCase().matches("-getreservedlength")) {
			if (args.length > 1) {
				System.out.println(bFileDir.getReservedLength(destination,
						args[1])
						+ " bytes reserved");
				System.exit(0);

			} else {
				reportError("Missing parameter(s)");
			}

		} else if (args[0].toLowerCase().matches("-getdatalength")) {
			if (args.length > 1) {
				System.out.println(bFileDir.getDataLength(destination, args[1])
						+ " bytes");
				System.exit(0);

			} else {
				reportError("Missing parameter(s)");
			}

		} else if (args[0].toLowerCase().matches("-checkcorruption")) {
			if (args.length > 1) {
				bFileDir.checkCorruption(destination, args[1]);
			} else {
				reportError("Missing parameter(s)");
			}

		} else if (args[0].toLowerCase().matches("-getfreespace")) {
			System.out.println(bFileDir.getFreeSpace(destination)
					+ " bytes available");
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
		usage += "  BFileDir\n";
		usage += "\t-getTotalFiles\n";
		usage += "\t-getTotalNodes\n";
		usage += "\t-getFreeSpace\n";
		usage += "\t-checkExists <filename>\n";
		usage += "\t-readFirst\n";
		usage += "\t-readNext <current filename>\n";
		usage += "\t-getReservedLength <filename>\n";
		usage += "\t-getDataLength <filename>\n";
		usage += "\t-checkCorruption <filename>\n";
		return usage;
	}

	/** *************** BFileDir Events *************** */
	public void bFileDir_corruptionCheckDone(String fileName,
			boolean isCorrupt, TinyosError error) {
		System.out.print("BFileDir corruption check ");

		if (error.wasSuccess()) {
			System.out.print("SUCCESS: ");
			if (isCorrupt) {
				System.out.println("Corrupted!");
			} else {
				System.out.println("File OK");
			}
		} else {
			System.out.println("FAIL");
		}
		System.exit(0);
	}

	public void bFileDir_existsCheckDone(String fileName, boolean doesExist,
			TinyosError error) {
		System.out.print("BFileDir exists check ");
		if (error.wasSuccess()) {
			System.out.print("SUCCESS: ");
			if (doesExist) {
				System.out.println("File Exists");
			} else {
				System.out.println("File does not exist");
			}
		} else {
			System.out.println("FAIL");
		}
		System.exit(0);
	}

	public void bFileDir_nextFile(String fileName, TinyosError error) {
		System.out.print("BFileDir next file ");
		if (error.wasSuccess()) {
			System.out.println("SUCCESS: " + fileName);
		} else {
			System.out.println("FAIL: No next file");
		}
		System.exit(0);
	}
}