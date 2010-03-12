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


//Not Done yet

package rpc.packet;

import java.util.*;
import java.io.*;

/**
 * Read packets from a database. Unfinished.
 */
class DBSource extends AbstractSource {
    private DBReader dbReader;

    /**
     * Packetizers are built using the makeXXX methods in BuildSource
     */
    DBSource(String user, String pass, boolean postgresSql) {
	super("db@" + user);
        dbReader = new DBReader(user, pass, postgresSql);
    }

    protected void openSource() throws IOException {
	if (!dbReader.Connect()) {
	    throw new IOException("database connection failed");
	}
    }

    protected void closeSource() { 
	dbReader.Close();
    }

    protected byte[] readSourcePacket() throws IOException {
	java.sql.Timestamp lastTimestamp = null;
	java.sql.Timestamp crrntTimestamp = null;

	byte[] packet = dbReader.NextPacket();
	crrntTimestamp = dbReader.GetTimestamp ();
	if (packet == null || crrntTimestamp == null) {
	    throw new IOException("database packet read failed");
	}
	lastTimestamp = crrntTimestamp;

	int sleep = (int)(crrntTimestamp.getTime() - lastTimestamp.getTime());
	if (sleep > 0) {
	    message("Sleeping for: " + sleep);
	    try { Thread.currentThread().sleep (sleep); }
	    catch (Exception e) { }
	}

        return packet;
    }
}
