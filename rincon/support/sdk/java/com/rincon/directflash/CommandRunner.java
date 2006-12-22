package com.rincon.directflash;

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

import com.rincon.directflash.messages.ViewerMsg;
import com.rincon.directflash.receive.FlashViewerEvents;
import com.rincon.directflash.receive.FlashViewerReceiver;
import com.rincon.directflash.send.FlashViewerSender;

public class CommandRunner implements FlashViewerEvents, FlashRunnerInterface {


	/** Receiving Mechanism */
	private FlashViewerReceiver receiver = new FlashViewerReceiver();
	
	/** Sending mechanism */
	private FlashViewerSender mote = new FlashViewerSender();
	
	/** Total range of data to read */
	private long totalRange;
	
	/** Current range of data to read */
	private int focusedRange;
	
	/** Current address to start reading from */
	private long focusedAddress;
	
	/** The address we started reading from */
	private long startAddress;
	
	/** The mote we're communicating with right now */
	private int focusedMote;
	
	/** Method to output data */
	private DataOutput output = new DataOutput();
	
	/**
	 * Constructor
	 *
	 */
	public CommandRunner() {
		receiver.addListener(this);
	}

	/**
	 * Read some arbitrary range of values from the flash
	 */
	public void read(long address, long range, int moteID) {
		totalRange = range;
		startAddress = address;
		focusedAddress = address;
		focusedMote = moteID;
		if(range > ViewerMsg.totalSize_data()) {
			focusedRange = ViewerMsg.totalSize_data();
		} else {
			focusedRange = (int) range;
		}
		
		System.out.println("0x" + Long.toHexString(startAddress) + " to 0x" + Long.toHexString(startAddress + totalRange));
		System.out.println("_________________________________________________");
		
		mote.read(address, focusedRange, focusedMote);
		
	}

	/**
	 * Write data to the flash
	 */
	public void write(long address, short[] buffer, int length, int moteID) {
		mote.write(address, buffer, length, moteID);	
	}

	/**
	 * Erase data from the flash
	 */
	public void erase(int sector, int moteID) {
		mote.erase(sector, moteID);
	}

	/**
	 * Mount to a volume id
	 */
	public void crc(long address, int length, int moteID) {
		mote.crc(address, length, moteID);
	}

	/**
	 * Commit to flash
	 */
	public void flush(int moteID) {
		mote.flush(moteID);
	}

	/**
	 * Ping the FlashViewer component on the mote.
	 */
	public void ping(int moteID) {
		mote.ping(moteID);
	}

	
	/**
	 * Read is complete
	 */
	public void readDone(long address, short[] buffer, int length, boolean success) {
		output.output(buffer, length);
		
		if(!success) {
			System.out.println("Failure to read data at " + Long.toHexString(address));
			System.exit(1);
		}
		
		focusedAddress += length;
		if(focusedAddress < startAddress + totalRange) {
			if(((startAddress + totalRange) - focusedAddress) > ViewerMsg.totalSize_data()) {
				focusedRange = ViewerMsg.totalSize_data();
			} else {
				focusedRange = (int) ((startAddress + totalRange) - focusedAddress);
			}
			mote.read(focusedAddress, focusedRange, focusedMote);
		} else {
			output.flush();
			System.exit(0);
		}
	}

	/**
	 * Write is complete
	 */
	public void writeDone(long address, short[] buffer, int length, boolean success) {
		if(success) {
			System.out.print("SUCCESS: ");
		} else {
			System.out.print("FAIL: ");
		}
		
		System.out.println(length + " bytes written to 0x" + Long.toHexString(address).toUpperCase());
		System.exit(0);
	}

	/**
	 * Erase is complete
	 */
	public void eraseDone(int sector, boolean success) {
		if(success) {
			System.out.print("SUCCESS: ");
		} else {
			System.out.print("FAIL: ");
		}
		
		System.out.println("Sector " + sector + " erase complete");
		System.exit(0);
	}


	/**
	 * Flush is complete
	 */
	public void flushDone(boolean success) {
		if(success) {
			System.out.print("SUCCESS: ");
		} else {
			System.out.print("FAIL: ");
		}
		
		System.out.println("Flush complete");
		System.exit(0);
		
	}
	
	/**
	 * Ping is complete
	 */
	public void pong() {
		System.out.println("Pong! The mote has FlashViewer installed.");
		System.exit(0);
	}

	public void crcDone(int crc, boolean success) {
		if(success) {
			System.out.print("SUCCESS: ");
		} else {
			System.out.print("FAIL: ");
		}
		
		System.out.println("CRC is 0x" + Integer.toHexString(crc).toUpperCase());
		System.exit(0);
	}

}
