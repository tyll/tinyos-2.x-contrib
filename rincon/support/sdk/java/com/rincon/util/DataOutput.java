package com.rincon.util;

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


import java.io.File;
import java.util.Arrays;


public class DataOutput {

	/** True if we save to a file, False if we print to screen */
	private boolean toFile = false;

	/** File to dump the image to */
	private File outFile;

	/** The index we're writing to the screen */
	private int screenIndex = 0;

	/** Characters get printed at the end of every row */
	private char[] characterView = new char[0x16];

	/** Keep track of multi-messaged debug numbers */
	private boolean numberNext = false;

	/** Keep track of multi-messaged hex debug number formatting */
	private boolean hex = false;

	/**
	 * Method to output data either to the screen in a nice format, or to a
	 * binary file
	 * 
	 * @param data
	 * @param
	 */
	public void output(short[] data, int length) {
		// Print nicely to the screen
		for (int i = 0; i < length; i++) {
			characterView[screenIndex] = (char) data[i];

			// Here's where we do our formatting
			if (screenIndex == 8) {
				// New 8-bit column space
				System.out.print("  ");
			}

			if (screenIndex > 15) { // used to be 15
				// Print out the character view and start a new line
				dumpCharacters();
				System.out.println();
				screenIndex = 0;
			}

			if (Integer.toHexString(data[i]).length() < 2) {
				// Numbers 0-F only prints 1 character instead of 2.
				System.out.print("0");
			}
			System.out.print(Integer.toHexString(data[i]).toUpperCase() + " ");
			screenIndex++;
		}
	}

	private String resultToString(int result) {
		if (result == 0) {
			return "STORAGE_OK";
		} else if (result == 1) {
			return "STORAGE_FAIL";
		} else if (result == 2) {
			return "STORAGE_INVALID_SIGNATURE";
		} else if (result == 3) {
			return "STORAGE_INVALID_CRC";
		}
		return "INVALID RETURN CODE";
	}

	/**
	 * Turn an array of short[]'s to a String
	 * 
	 * @param data
	 * @return
	 */
	private String dataToString(short[] data) {
		String returnString = "";

		for (int i = 0; i < data.length; i++) {
			returnString += (char) data[i];
		}
		return returnString;
	}

	/**
	 * Dump the character representation of the last line to the screen
	 * 
	 */
	private void dumpCharacters() {
		System.out.print("  |  ");
		for (int charIndex = 0; charIndex < characterView.length; charIndex++) {
			if (charIndex == 8) {
				// 8-bit character column space
				System.out.print("  ");
			}
			System.out.print(characterView[charIndex]);
		}
		Arrays.fill(characterView, ' ');
	}

	/**
	 * Flush out the remaining data
	 * 
	 */
	public void flush() {
		// to screen
		for (int i = screenIndex; i < 16; i++) {
			System.out.print("   ");
			if (i == 8) {
				// column
				System.out.print("  ");
			}
		}
		dumpCharacters();
		System.out.println();
	}
}
