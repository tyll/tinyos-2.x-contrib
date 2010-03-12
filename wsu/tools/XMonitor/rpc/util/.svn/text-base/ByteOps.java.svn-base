// $Id$

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
/**
 * ByteOps.java
 *
 * This class bring together all byte manipulation routines used elsewhere in the
 * program.
 *
 * @author Eugene Shvets
 */

package rpc.util;

public final class ByteOps {
	
    /**
     * Combines two bytes into an unsigned int
     *  @param hibyte is the most significant byte of the integer
     *  @param lowbyte is the least significant byte
     */
    public static int makeInt(byte lowbyte, byte hibyte) {
	return unsign(lowbyte) + (unsign(hibyte) << 8);
    }
	
    /**
     * Combines four bytes into an unsigned long
     */
    public static long makeLong(byte lsb, byte b2, byte b3, byte msb) {
	return unsign(lsb) + (unsign(b2) << 8) +
	    (unsign(b3) << 16) + (unsign(msb) << 24);
		
    }
    
    /* Given a byte, convert it to an unsigned int in the range 0 - 255*/
    public static int unsign(byte b) {
	if (b < 0) return (int)(b & 0x7f) + 128;
	else return (int)b;
    }
    /*
      public static int unsign(int b) {
      if (b < 0) return (int)((b & 0x7f)) + 128;
      else return (int)b;
      }*/
}

