package com.rincon.blackbookbridge.memorystick;

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


import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;

import com.rincon.blackbookbridge.bfilereadbridge.BFileReadMsg;
import com.rincon.blackbookbridge.TinyosError;
import com.rincon.blackbookbridge.bfiledeletebridge.BFileDelete;
import com.rincon.blackbookbridge.bfiledeletebridge.BFileDelete_Events;
import com.rincon.blackbookbridge.bfiledirbridge.BFileDir;
import com.rincon.blackbookbridge.bfiledirbridge.BFileDir_Events;
import com.rincon.blackbookbridge.bfilewritebridge.BFileWrite;
import com.rincon.blackbookbridge.bfilewritebridge.BFileWriteMsg;
import com.rincon.blackbookbridge.bfilewritebridge.BFileWrite_Events;
import com.rincon.blackbookbridge.bfilereadbridge.BFileRead;
import com.rincon.blackbookbridge.bfilereadbridge.BFileRead_Events;
import com.rincon.util.Util;

public class MemoryStick implements BFileRead_Events, BFileWrite_Events,
		BFileDelete_Events, BFileDir_Events {

	/** BFileRead Transceiver */
	private BFileRead bFileRead;

	/** BFileWrite Transceiver */
	private BFileWrite bFileWrite;

	/** BFileDelete Transceiver */
	private BFileDelete bFileDelete;

	/** BFileDir Transceiver */
	private BFileDir bFileDir;

	/** File Writer */
	private DataOutputStream out;

	/** File Reader */
	private DataInputStream in;

	/** The local file on the computer to interact with */
	private File localFile;
	
	/** True if we're writing to the flash from the computer */
	private boolean writing = false;

	/** The filename we're writing to on the mote */
	private String remoteFile;

	/** Write buffer */
	private byte[] writeBuffer;

	/** The amount of bytes transferred */
	private long transferred;

	/** Basic CLI Progress Bar */
	private TransferProgress progress;

	/** Destination address */
	private int destination;

	/**
	 * Main Method
	 * 
	 * @param args
	 */
	public static void main(String[] args) {
		new MemoryStick(args);
	}

	/**
	 * Constructor
	 * 
	 * @param args
	 */
	public MemoryStick(String[] args) {
		if (args.length < 1) {
			reportError("Not enough arguments");
		}

		int argIndex = 0;
		
		bFileDelete = new BFileDelete();
		bFileDir = new BFileDir();
		bFileRead = new BFileRead();
		bFileWrite = new BFileWrite();

		bFileDelete.addListener(this);
		bFileDir.addListener(this);
		bFileRead.addListener(this);
		bFileWrite.addListener(this);

		try {
			destination = Integer.decode(args[argIndex]).intValue();
			argIndex++;
		} catch (NumberFormatException e) {
			System.out.println("Using default destination address 0");
			destination = 0;
		}

		
		if (args[argIndex].equalsIgnoreCase("-get")) {
			writing = false;

			if (args.length >= argIndex + 1) {
				
				localFile = new File(args[(++argIndex)]);
				remoteFile = localFile.getName();
				if (args.length >= argIndex + 2) {
					if (args[(++argIndex)].equalsIgnoreCase("as")) {
						localFile = new File(args[(++argIndex)]);
					}
				}

				if (localFile.exists()) {
					System.err.println(localFile.getName()
							+ " already exists! Delete? (Y/N)");
					BufferedReader stdin = new BufferedReader(
							new InputStreamReader(System.in));
					try {
						String answer = stdin.readLine();
						System.out.println();
						if (answer.toUpperCase().startsWith("Y")) {
							localFile.delete();
						} else {
							System.exit(1);
						}

					} catch (IOException e) {
						e.printStackTrace();

					}
				}

				try {
					localFile.createNewFile();
					out = new DataOutputStream(new BufferedOutputStream(
							new FileOutputStream(localFile)));

					bFileRead.open(destination, remoteFile);

				} catch (IOException e) {
					e.printStackTrace();
				}

			} else {
				reportError("Not enough arguments");
			}
		} else if (args[argIndex].equalsIgnoreCase("-put")) {
			writing = true;

			if (args.length >= argIndex + 1) {
				localFile = new File(args[(++argIndex)]);
				remoteFile = localFile.getName();

				if (args.length >= argIndex + 2) {
					if (args[(++argIndex)].equalsIgnoreCase("as")) {
						remoteFile = args[(++argIndex)];
					}
				}

				if (!localFile.exists()) {
					reportError(localFile.getAbsolutePath()
							+ " does not exist!");
				}

				try {
					in = new DataInputStream(new FileInputStream(localFile));

				} catch (FileNotFoundException e) {
					e.printStackTrace();
				}

				writeBuffer = new byte[BFileWriteMsg.totalSize_byteArray()];
				bFileDir.checkExists(destination, remoteFile);

			} else {
				reportError("Not Enough Arguments");
			}

		} else if (args[argIndex].equalsIgnoreCase("-dir")) {
			System.out.println(bFileDir.getTotalFiles(destination)
					+ " total files:");
			bFileDir.readFirst(destination);

		} else if (args[argIndex].equalsIgnoreCase("-delete")) {
			if (args.length >= argIndex + 1) {
				bFileDelete.delete(destination, args[(++argIndex)]);

			} else {
				reportError("Not Enough Arguments");
			}

		} else if (args[argIndex].equalsIgnoreCase("-freespace")) {
			System.out.println(bFileDir.getFreeSpace(destination)
					+ " bytes available");
			System.exit(0);

		} else if (args[argIndex].equalsIgnoreCase("-iscorrupt")) {
			if (args.length >= argIndex + 1) {
				System.out
						.println("Please wait, this could take awhile for large files...");
				bFileDir.checkCorruption(destination, args[(++argIndex)]);

			} else {
				reportError("Not Enough Arguments");
			}
		} else {
			reportError("Unknown argument: " + args[argIndex]);
		}
	}

	private void reportError(String error) {
		System.err.println(error);
		System.err.println(getUsage());
		System.exit(1);
	}

	public static String getUsage() {
		String usage = "";
		usage += "  MemoryStick [addr] [command]\n";
		usage += "\t-get [filename on mote] [as <filename on computer>]\n";
		usage += "\t-put [filename on computer] [as <filename on mote>]\n";
		usage += "\t-dir\n";
		usage += "\t-delete [filename on mote]\n";
		usage += "\t-isCorrupt [filename on mote]\n";
		usage += "\t-freeSpace\n";
		return usage;
	}


	/**
	 * Write data from the local file to the mote
	 *
	 */
	private void write() {
		int appendAmount;
		try {
			if ((appendAmount = in.read(writeBuffer)) > 0) {
				bFileWrite.append(destination, Util.bytesToShorts(writeBuffer),
						appendAmount);

			} else {
				bFileWrite.close(destination);
			}

		} catch (IOException e) {
			System.err.println(e.getMessage());
			bFileWrite.close(destination);
		}
	}

	
	
	
	public void bFileRead_opened(long amount, TinyosError error) {
		if (!error.wasSuccess()) {
			reportError("Cannot open file");
		}

		transferred = 0;

		System.out.println("Getting " + amount + " [bytes]");
		progress = new TransferProgress(amount);
		bFileRead.read(destination, BFileReadMsg.totalSize_byteArray());
	}

	public void bFileRead_closed(TinyosError error) {
		System.out.println("\n");

		try {
			out.flush();
			out.close();
		} catch (IOException e) {
			System.err.println(e.getMessage());
		}

		System.out.println(localFile.length() + " bytes read into "
				+ localFile.getAbsolutePath());
		System.exit(0);
	}

	public void bFileRead_readDone(short[] data, int amount, TinyosError error) {
		transferred += amount;
		progress.update(transferred);
		if (amount > 0) {
			try {
				out.write(Util.shortsToBytes(data, amount));

			} catch (IOException e) {
				System.err.println(e.getMessage());
				bFileRead.close(destination);
			}

			bFileRead.read(destination, BFileReadMsg.totalSize_byteArray());

		} else {
			bFileRead.close(destination);
		}
	}

	public void bFileWrite_opened(long len, TinyosError error) {
		if (!error.wasSuccess()) {
			reportError("Cannot open file");
		}

		transferred = 0;

		System.out.println("Writing " + localFile.length() + " [bytes]");
		progress = new TransferProgress(localFile.length());
		write();
	}

	public void bFileWrite_closed(TinyosError error) {
		try {
			in.close();

		} catch (IOException e) {
			e.printStackTrace();
		}

		System.out.println(localFile.length() + " bytes written to "
				+ remoteFile);
		System.exit(0);
	}

	public void bFileWrite_saved(TinyosError error) {
	}

	public void bFileWrite_appended(int amountWritten, TinyosError error) {
		transferred += amountWritten;
		progress.update(transferred);
		write();
	}

	public void bFileDelete_deleted(TinyosError error) {
		if (error.wasSuccess()) {
			System.out.println("File deleted on mote.");
			if (writing) {
				bFileWrite.open(destination, remoteFile, localFile
						.length());

			} else {
				System.exit(0);
			}

		} else {
			System.out.println("Unable to delete file!");
			System.exit(0);
		}
	}

	public void bFileDir_corruptionCheckDone(String fileName,
			boolean isCorrupt, TinyosError error) {
		if (isCorrupt) {
			System.out.println("File is corrupted on flash!");
		} else {
			System.out.println("File is OK on flash!");
		}
		System.exit(0);
	}

	public void bFileDir_existsCheckDone(String fileName, boolean doesExist,
			TinyosError error) {
		// Here we are about to write a file to the mote,
		// and are checking to see if the file exists before
		// writing
		if (doesExist) {
			System.err.println(remoteFile.replaceAll(" ", "")
					+ " already exists on the mote! Delete? (Y/N)");
			BufferedReader stdin = new BufferedReader(new InputStreamReader(
					System.in));
			try {
				String answer = stdin.readLine();
				System.out.println();
				if (answer.equalsIgnoreCase("Y")) {
					bFileDelete.delete(destination, remoteFile);

				} else {
					System.exit(1);
				}

			} catch (IOException e) {
				e.printStackTrace();

			}
		} else {
			bFileWrite.open(destination, remoteFile, localFile.length());
		}

	}

	public void bFileDir_nextFile(String fileName, TinyosError error) {
		if (error.wasSuccess()) {
			System.out.println("\t" + fileName);
			bFileDir.readNext(destination, fileName);
		} else {
			System.exit(0);
		}
	}
}
