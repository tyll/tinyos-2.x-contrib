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

public class Util {

	
	/**
	 * Turn an array of short[]'s to a String
	 * 
	 * @param data
	 * @return
	 */
	public static String dataToString(short[] data) {
		String returnString = "";

		for (int i = 0; i < data.length; i++) {
			returnString += (char) data[i];
		}
		return returnString;
	}

	/**
	 * Turn a string into a short[] array of data
	 * @param string
	 * @return
	 */
	public static short[] stringToData(String string) {
		char[] charData = string.toCharArray();
		short[] returnData = new short[charData.length];
		
		
		for(int i = 0; i < charData.length; i++) {
			returnData[i] = (short) charData[i];
		}
		
		return returnData;
	}
	
	/**
	 * Attempt to decode the int value, and deal with any illegible remarks.
	 * 
	 * @param intString
	 * @return
	 */
	public static int parseInt(String intString) {
		try {
			return Integer.decode(intString).intValue();
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
		return 0;
	}

	/**
	 * Attempt to decode the long value, and deal with any illegible remarks.
	 * 
	 * @param longString
	 * @return
	 */
	public static long parseLong(String longString) {
		try {			
			return Long.decode(longString).longValue();
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}

		return 0;
	}

	/**
	 * Attempt to decode the short value, and deal with any illegible remarks.
	 * 
	 * @param shortString
	 * @return
	 */
	public static short parseShort(String shortString) {
		try {			
			return Short.decode(shortString).shortValue();
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}

		return 0;
	}
	
	/**
	 * Convert some data to a filename
	 * @param data
	 * @return
	 */
	public static String dataToFilename(short[] data) {
		String returnString = "";
		
		for(int i = 0; i < data.length; i++) {
			returnString += (char) data[i];
		}
		return returnString;
	}

	/**
	 * Takes a filename string and converts it to a 14 element
	 * filename short array
	 * @param s
	 * @return
	 */
	public static short[] filenameToData(String filename, int maxLength) {
		short[] returnData = new short[maxLength];
		char[] charData = filename.toCharArray();
		
		for(int i = 0; i < charData.length && i < maxLength; i++) {
			returnData[i] = (short) charData[i];
		}
		
		for(int i = charData.length; i < maxLength; i++) {
			returnData[i] = 0;
		}
		
		return returnData;
	}

	
	/**
	 * Turn an array of shorts into an array of bytes
	 * @param shortData
	 * @return
	 */
	public static byte[] shortsToBytes(short[] shortData, int length) {
		byte[] byteData = new byte[length];
		for(int i = 0; i < length; i++) {
			byteData[i] = (byte) shortData[i];
		}
		
		return byteData;
	}
	

	/**
	 * Convert a byte array to short array.
	 * @param byteData
	 * @return
	 */
	public static short[] bytesToShorts(byte[] byteData) {
		short[] shortData = new short[byteData.length];
		for(int i = 0; i < byteData.length; i++) {
			shortData[i] = (short) byteData[i];
		}
		
		return shortData;
	}

	/**
	 * Truncate an array of shorts to a specified size
	 * @param value
	 * @param size
	 * @return the truncated array of shorts
	 */
	public static short[] truncate(short[] value, int maxSize) {
		int actualSize = maxSize;
		if(actualSize > value.length) {
			actualSize = value.length;
		}
		short[] returnValue = new short[actualSize];
		for(int i = 0; i < actualSize; i++) {
			returnValue[i] = value[i];
		}
		return returnValue;
	}

}
