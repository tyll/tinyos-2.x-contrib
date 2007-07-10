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
 * 
 *
 * @author Sarah Bergbreiter
 * Last modified 10/24/2003
 */
package BeepDiffusion;

import net.tinyos.util.*;
import java.io.*;
import java.util.Properties;
import net.tinyos.message.*;

public class BeepDiffusion implements MessageListener {
    static Properties p = new Properties();
        
    public static final short TOS_BCAST_ADDR = (short) 0xffff;
    public static final short MAX_NODES = 8;

    public static short tickLength;
    public static short numPackets;
    public static short packetsReceived[] = new short[MAX_NODES];
	
    public static void usage() {
	System.err.println("Usage: java BeepDiffusion.BeepDiffusion"+
			   " <command> [arguments]");
	System.err.println("\twhere <command> and [arguments] may be one of the following:");
	System.err.println("\t\ttick_length [tickLength (ms)]");
	System.err.println("\t\tgo");
    }
    public static void tickLengthUsage() {
	System.err.println("Usage: java BeepDiffusion.BeepDiffusion"
			   + " tick_length [time_ms]");
    }

    public static void main(String[] argv) throws IOException {
	String cmd;

	if (argv.length < 1) {
	    usage();
	    System.exit(-1);
	}

	cmd = argv[0];

	if (cmd.equals("tick_length") && argv.length != 2) {
	    tickLengthUsage();
	    System.exit(-1);
	}
	
	BeepDiffusionResetMsg packet = new BeepDiffusionResetMsg();
	short tickLength = 1000;
	if (cmd.equals("tick_length")) {
	    tickLength = (short)Integer.parseInt(argv[1]);
	} else if (cmd.equals("go")) {
	    tickLength = -1;
	}
	packet.set_tickLength(tickLength);
	    
	try {
	    System.err.print("Sending payload: ");
	  		
	    for (int i = 0; i < packet.dataLength(); i++) {
		System.err.print(Integer.toHexString(packet.dataGet()[i] & 0xff)+ " ");
	    }
	    System.err.println();

	    MoteIF mote = new MoteIF(PrintStreamMessenger.err);

	    mote.send(TOS_BCAST_ADDR, packet);

	    System.exit(0);

	} catch(Exception e) {
	    e.printStackTrace();
	}      

    }

    public void messageReceived(int dest_addr, Message m) {
    }
}

