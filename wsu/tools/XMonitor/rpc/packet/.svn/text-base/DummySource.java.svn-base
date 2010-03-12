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


package rpc.packet;

import java.io.*;

/**
 * "dummy" packet source
 */
class DummySource extends AbstractSource
{
    private byte[] dummyPacket = null;
    private int nReadDelay  = 1000;
    final static int dummySize = 4;

    /**
     * Packetizers are built using the makeXXX methods in BuildSource
     */
    DummySource() {
	super("dummy");
    }

    protected void openSource() {
        dummyPacket = new byte[dataOffset + dummySize];
        dummyPacket[0] = (byte)0x7E;

        for (int i = 1; i < dummyPacket.length - 2; i++)
	    dummyPacket[i] = (byte)i;
	dummyPacket[lengthOffset] = dummySize;
    }

    protected void closeSource() {
    }

    protected byte[] readSourcePacket() throws IOException {
	try {
	    Thread.currentThread ().sleep( nReadDelay );
	}
	catch (InterruptedException e ) {
	    throw new IOException("interrupted");
	}
	return dummyPacket;
    }
}
