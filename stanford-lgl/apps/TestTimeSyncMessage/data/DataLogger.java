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
 * Copyright (c) 2002-2007 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */


/**
 * @author Brano Kusy
 */

import java.io.FileOutputStream;
import java.io.PrintStream;
import net.tinyos.message.*;
import net.tinyos.util.*;

public class DataLogger implements MessageListener {
	public class RunWhenShuttingDown extends Thread { 
		public void run() 
		{ 
			System.out.println("Control-C caught. Shutting down...");
			if (outPoll!=null)
				outPoll.close();
			if (outReport!=null)
				outReport.close();
		} 
	}
	
	MoteIF mote; 		// For talking to the antitheft root node

    void connect()
    {
		try {
		    //System.out.print("connecting to serial forwarder: failed");
		    //mote = new MoteIF(this);
		    //System.out.println("\b\b\b\b\b\bok    ");
		    mote = new MoteIF(PrintStreamMessenger.err);
		    mote.registerListener(new TimeSyncPoll(), this);
		    mote.registerListener(new TimeSyncPollReport(), this);
		    System.out.println("Connection ok!");
		}
		catch(Exception e) {
		    e.printStackTrace();
		    System.exit(2);
		}
    }
    PrintStream outPoll = null;
    PrintStream outReport = null;
    
    public DataLogger() {
		connect();
		Runtime.getRuntime().addShutdownHook(new RunWhenShuttingDown());
		String name=""+System.currentTimeMillis();
		try
		{
			outPoll = new PrintStream(new FileOutputStream(name+".poll"));
			outReport = new PrintStream(new FileOutputStream(name+".report"));
    		//outPoll.println("#[SENDER_ID] [MSG_ID]");
    		//outReport.println("#[RECEIVER_ID] [SENDER_ID] [MSG_ID] [RX_TIME]");
		}
		catch (Exception e)
		{
			System.out.println("DataLogger.DataLogger(): "+e.toString());
		}
    }

	public void writePoll(TimeSyncPoll tsp)
	{
		outPoll.println(tsp.get_senderAddr()+" "+tsp.get_msgID()+" "+tsp.get_sendTime());
		outPoll.flush();
	}
	    
	public void writeReprot(TimeSyncPollReport tspr)
	{
		outReport.println(tspr.get_localAddr()+" "+tspr.get_senderAddr()+" "+tspr.get_msgID()+" "+tspr.get_receiveTime());
		outReport.flush();
	}
	    
    public void messageReceived(int dest_addr, Message msg) 
    {
		if (msg instanceof TimeSyncPoll)
			writePoll((TimeSyncPoll)msg);
		else if (msg instanceof TimeSyncPollReport)
			writeReprot((TimeSyncPollReport)msg);
    }
        
    /* Just start the app... */
    public static void main(String[] args) {
    	new DataLogger();
    }

}
