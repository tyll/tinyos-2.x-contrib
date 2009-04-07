/*
 * Copyright (c) 2003, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 */
/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/* Authors:  David Gay  <dgay@intel-research.net>
 *           Intel Research Berkeley Lab
 *           Janos Sallai <janos.sallai@vanderbilt.edu>
 *           Vanderbilt University
 *
 */


/* This code is borrowed from net.tinyos.message.Message.java and modified such that all methods are static.
 */

package net.tinyos.mcenter;

public class Marshaller {

	
	  // Check that length bits from offset are in bounds
	  private static void checkBounds(byte[] ba, int offset, int length) {
	    if (offset < 0 || length <= 0 || offset + length > (ba.length * 8))
	      throw new ArrayIndexOutOfBoundsException(
	          "Marshaller.checkBounds: bad offset (" + offset + ") or length ("
	              + length + "), for ba.length " + ba.length);
	  }

	  // Check that value is valid for a bitfield of length length
/*	  private static void checkValue(int length, long value) {
	    if (length != 64 && (value < 0 || value >= 1L << length))
	      throw new IllegalArgumentException("Marshaller.checkValue: bad length ("
	          + length + " or value (" + value + ")");
	  }
*/
	  // Unsigned byte read
	  public static int ubyte(byte[] ba, int offset) {
	    int val = ba[offset];

	    if (val < 0)
	      return val + 256;
	    else
	      return val;
	  }

	  // ASSUMES: little endian bits & bytes for the methods without BE, and
	  // big endian bits & bytes for the methods with BE

	  /**
	   * Read the length bit unsigned little-endian int at offset
	   * 
	   * @param offset
	   *          bit offset where the unsigned int starts
	   * @param length
	   *          bit length of the unsigned int
	   * @exception ArrayIndexOutOfBoundsException
	   *              for invalid offset, length
	   */
	  public static long getUIntElement(byte[] ba, int offset, int length) {
	    checkBounds(ba, offset, length);

	    int byteOffset = offset >> 3;
	    int bitOffset = offset & 7;
	    int shift = 0;
	    long val = 0;

	    // all in one byte case
	    if (length + bitOffset <= 8)
	      return (ubyte(ba, byteOffset) >> bitOffset) & ((1 << length) - 1);

	    // get some high order bits
	    if (bitOffset > 0) {
	      val = ubyte(ba, byteOffset) >> bitOffset;
	      byteOffset++;
	      shift += 8 - bitOffset;
	      length -= 8 - bitOffset;
	    }

	    while (length >= 8) {
	      val |= (long) ubyte(ba,byteOffset++) << shift;
	      shift += 8;
	      length -= 8;
	    }

	    // data from last byte
	    if (length > 0)
	      val |= (long) (ubyte(ba,byteOffset) & ((1 << length) - 1)) << shift;

	    return val;
	  }

	  /**
	   * Set the length bit unsigned little-endian int at offset to val
	   * 
	   * @param offset
	   *          bit offset where the unsigned int starts
	   * @param length
	   *          bit length of the unsigned int
	   * @param val
	   *          value to set the bit field to
	   * @exception ArrayIndexOutOfBoundsException
	   *              for invalid offset, length
	   * @exception IllegalArgumentException
	   *              if val is an out-of-range value for this bitfield
	   */
	  public static  void setUIntElement(byte[] ba, int offset, int length, long val) {
	    checkBounds(ba, offset, length);
	    // checkValue(length, val);

	    int byteOffset = offset >> 3;
	    int bitOffset = offset & 7;
	    int shift = 0;

	    // all in one byte case
	    if (length + bitOffset <= 8) {
	      ba[byteOffset] = (byte) ((ubyte(ba, byteOffset) & ~(((1 << length) - 1) << bitOffset)) | val << bitOffset);
	      return;
	    }

	    // set some high order bits
	    if (bitOffset > 0) {
	      ba[byteOffset] = (byte) ((ubyte(ba, byteOffset) & ((1 << bitOffset) - 1)) | val << bitOffset);
	      byteOffset++;
	      shift += 8 - bitOffset;
	      length -= 8 - bitOffset;
	    }

	    while (length >= 8) {
	      ba[(byteOffset++)] = (byte) (val >> shift);
	      shift += 8;
	      length -= 8;
	    }

	    // data for last byte
	    if (length > 0)
	      ba[byteOffset] = (byte) ((ubyte(ba,byteOffset) & ~((1 << length) - 1)) | val >> shift);
	  }

	  /**
	   * Read the length bit signed little-endian int at offset
	   * 
	   * @param offset
	   *          bit offset where the signed int starts
	   * @param length
	   *          bit length of the signed int
	   * @exception ArrayIndexOutOfBoundsException
	   *              for invalid offset, length
	   */
	  public static long getSIntElement(byte[] ba, int offset, int length)
	      throws ArrayIndexOutOfBoundsException {
	    long val = getUIntElement(ba, offset, length);

	    if (length == 64)
	      return val;

	    if ((val & 1L << (length - 1)) != 0)
	      return val - (1L << length);

	    return val;
	  }

	  /**
	   * Set the length bit signed little-endian int at offset to val
	   * 
	   * @param offset
	   *          bit offset where the signed int starts
	   * @param length
	   *          bit length of the signed int
	   * @param value
	   *          value to set the bit field to
	   * @exception ArrayIndexOutOfBoundsException
	   *              for invalid offset, length
	   * @exception IllegalArgumentException
	   *              if val is an out-of-range value for this bitfield
	   */
	  public static void setSIntElement(byte[] ba, int offset, int length, long value)
	      throws ArrayIndexOutOfBoundsException {
	    if (length != 64 && value >= 1L << (length - 1))
	      throw new IllegalArgumentException();

	    if (length != 64 && value < 0)
	      value += 1L << length;

	    setUIntElement(ba, offset, length, value);
	  }

	  /**
	   * Read the length bit unsigned big-endian int at offset
	   * 
	   * @param offset
	   *          bit offset where the unsigned int starts. Note that these are
	   *          big-endian bit offsets: bit 0 is the MSB, bit 7 the LSB.
	   * @param length
	   *          bit length of the unsigned int
	   * @exception ArrayIndexOutOfBoundsException
	   *              for invalid offset, length
	   */
	  public static long getUIntBEElement(byte[] ba, int offset, int length) {
	    checkBounds(ba, offset, length);

	    int byteOffset = offset >> 3;
	    int bitOffset = offset & 7;
	    long val = 0;

	    // All in one byte case
	    if (length + bitOffset <= 8)
	      return (ubyte(ba,byteOffset) >> (8 - bitOffset - length))
	          & ((1 << length) - 1);

	    // get some high order bits
	    if (bitOffset > 0) {
	      length -= 8 - bitOffset;
	      val = (long) (ubyte(ba,byteOffset) & ((1 << (8 - bitOffset)) - 1)) << length;
	      byteOffset++;
	    }

	    while (length >= 8) {
	      length -= 8;
	      val |= (long) ubyte(ba,byteOffset++) << length;
	    }

	    // data from last byte
	    if (length > 0)
	      val |= ubyte(ba,byteOffset) >> (8 - length);

	    return val;
	  }

	  /**
	   * Set the length bit unsigned big-endian int at offset to val
	   * 
	   * @param offset
	   *          bit offset where the unsigned int starts. Note that these are
	   *          big-endian bit offsets: bit 0 is the MSB, bit 7 the LSB.
	   * @param length
	   *          bit length of the unsigned int
	   * @param val
	   *          value to set the bit field to
	   * @exception ArrayIndexOutOfBoundsException
	   *              for invalid offset, length
	   * @exception IllegalArgumentException
	   *              if val is an out-of-range value for this bitfield
	   */
	  public static void setUIntBEElement(byte[] ba, int offset, int length, long val) {
	    checkBounds(ba, offset, length);
	    // checkValue(length, val);

	    int byteOffset = offset >> 3;
	    int bitOffset = offset & 7;
//	    int shift = 0;

	    // all in one byte case
	    if (length + bitOffset <= 8) {
	      int mask = ((1 << length) - 1) << (8 - bitOffset - length);

	      ba[byteOffset] = (byte) ((ubyte(ba,byteOffset) & ~mask) | val << (8 - bitOffset - length));
	      return;
	    }

	    // set some high order bits
	    if (bitOffset > 0) {
	      int mask = (1 << (8 - bitOffset)) - 1;

	      length -= 8 - bitOffset;
	      ba[byteOffset] = (byte) (ubyte(ba,byteOffset) & ~mask | val >> length);
	      byteOffset++;
	    }

	    while (length >= 8) {
	      length -= 8;
	      ba[(byteOffset++)] = (byte) (val >> length);
	    }

	    // data for last byte
	    if (length > 0) {
	      int mask = (1 << (8 - length)) - 1;

	      ba[byteOffset] = (byte) ((ubyte(ba,byteOffset) & mask) | val << (8 - length));
	    }
	  }

	  /**
	   * Read the length bit signed big-endian int at offset
	   * 
	   * @param offset
	   *          bit offset where the signed int starts
	   * @param length
	   *          bit length of the signed int
	   * @exception ArrayIndexOutOfBoundsException
	   *              for invalid offset, length
	   */
	  public static long getSIntBEElement(byte[] ba, int offset, int length)
	      throws ArrayIndexOutOfBoundsException {
	    long val = getUIntBEElement(ba, offset, length);

	    if (length == 64)
	      return val;

	    if ((val & 1L << (length - 1)) != 0)
	      return val - (1L << length);

	    return val;
	  }

	  /**
	   * Set the length bit signed big-endian int at offset to val
	   * 
	   * @param offset
	   *          bit offset where the signed int starts
	   * @param length
	   *          bit length of the signed int
	   * @param value
	   *          value to set the bit field to
	   * @exception ArrayIndexOutOfBoundsException
	   *              for invalid offset, length
	   * @exception IllegalArgumentException
	   *              if val is an out-of-range value for this bitfield
	   */
	  public static void setSIntBEElement(byte[] ba, int offset, int length, long value)
	      throws ArrayIndexOutOfBoundsException {
	    if (length != 64 && value >= 1L << (length - 1))
	      throw new IllegalArgumentException();

	    if (length != 64 && value < 0)
	      value += 1L << length;

	    setUIntBEElement(ba, offset, length, value);
	  }

	  /**
	   * Read the 32 bit IEEE float at offset
	   * 
	   * @param offset
	   *          bit offset where the float starts
	   * @param length
	   *          is ignored
	   * @exception ArrayIndexOutOfBoundsException
	   *              for invalid offset
	   */
	  public static float getFloatElement(byte[] ba, int offset, int length)
	      throws ArrayIndexOutOfBoundsException {

	    return Float.intBitsToFloat((int) getUIntElement(ba, offset, 32));
	  }

	  /**
	   * Set the 32 bit IEEE float at offset to value
	   * 
	   * @param offset
	   *          bit offset where the float starts
	   * @param length
	   *          is ignored
	   * @param value
	   *          value to store in bitfield
	   * @exception ArrayIndexOutOfBoundsException
	   *              for invalid offset
	   */
	  public static void setFloatElement(byte[] ba, int offset, int length, float value)
	      throws ArrayIndexOutOfBoundsException {

	    // using SInt because floatToRawIntBits might return a negative value
	    setSIntElement(ba, offset, 32, Float.floatToRawIntBits(value));
	  }


	
	
}
