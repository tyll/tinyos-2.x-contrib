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

import Config.OasisConstants;
import java.util.*;
import java.io.*;


import Config.*;
import rpc.util.Messenger;

abstract public class StreamByteSource implements ByteSource, Runnable
{
	public final static int CONNECTED = 0;
	public final static int DISCONNECTED = 1;
	public final static int INIT = 2;
    protected InputStream is;
    protected OutputStream os;
    private boolean opened;
    private int numberOfPacketRead = 0;
    protected Messenger messages;
    protected String name;
	protected static long alarmCheckRate = 5000;
	protected boolean comPortHasStarted = false;
	protected int previousStatus = INIT;
    protected Date timeLastSeen;
	protected long comExpiredTime = 180000;
	protected long currentTime;
	protected Thread alarmCheckTimer;

    protected StreamByteSource() {

		alarmCheckTimer = new Thread(this);
		try{
		  alarmCheckTimer.setPriority(Thread.MIN_PRIORITY);
		  alarmCheckTimer.start(); // call run()
		}
		catch(Exception e){e.printStackTrace();}
		RestartStreamByteSource restartSBS = new RestartStreamByteSource(this);
		restartSBS.start();
    }

    abstract protected void openStreams() throws IOException;
    abstract protected void closeStreams() throws IOException;

    public void open() throws IOException {
	try{
	openStreams();
	opened = true;
    }
	catch (IOException ex){
		close();
	}
    }

    public void close() {
	if (opened) {
	    opened = false;
	    try { 
		os.close(); 
		is.close();
		closeStreams();
	    }
	    catch (Exception e) { }
	}
    }

    public byte readByte() throws IOException {
	int serialByte;
	//System.out.println(numberOfPacketRead);//xg 1/27/2009 debug
	if (!opened)
	    throw new IOException("not open");

	try {
	    serialByte = is.read();
	}
	catch (IOException e) {
	    serialByte = -1;
	}

	if (serialByte == -1) {
	    close();
	    throw new IOException("read error");
	}
	comPortHasStarted = true;
	previousStatus = CONNECTED;
	timeLastSeen = new Date();

	numberOfPacketRead++;
	return (byte)serialByte;
    }

    public void writeBytes(byte[] bytes) throws IOException {
	if (!opened)
	    throw new IOException("not open");

	try {
	    os.write(bytes);
	    os.flush();
	}
	catch (IOException e) {
	    close();
	    throw new IOException("write error");
	}
    }

    public int getnPacketsRead(){
		return numberOfPacketRead;
    }

    public void setMessenger(Messenger messages){
		this.messages = messages;
    }

    public void setName(String name){
		this.name = name;
    }

    public void message(String s) {
	if (messages != null)
	    messages.message(s);
    }

	public void run()
	{
		while(true) {
		  alarm();
		  try {
			alarmCheckTimer.sleep(alarmCheckRate);
		  }
		  catch(Exception e){e.printStackTrace();}
		  }
	 }

	 public void alarm(){
		try
		{
			if (comPortHasStarted)
			{
				currentTime = Calendar.getInstance().getTime().getTime();
				if (currentTime - timeLastSeen.getTime() > comExpiredTime){
					if (previousStatus == CONNECTED)
					{
						String title = "SerialForwarder: " + name + " disconnected";  
						System.out.println(title);
						monitor.Util.sfSendEmail(title,title);
						previousStatus = DISCONNECTED;
					}
				}
				else {
					if (previousStatus == DISCONNECTED)
					{
						String title = "SerialForwarder: " + name + " connected";  
						System.out.println(title);
						monitor.Util.sfSendEmail(title,title);
						previousStatus = CONNECTED;
					}
				}
			}
		}
		catch (Exception ex)
		{
		}
		
	 }
	

	//Andy: Watchdog checks every 10 seconds if the number of packetRead does not change --> connection has problems
    private class RestartStreamByteSource extends Thread{

		private int tempNoPacketsRead = 0;
		private StreamByteSource streamByteSource;
		private boolean sbsStarted = false;
		private FileWriter serialPortLogger;

		public RestartStreamByteSource(StreamByteSource streamByteSource){
			this.streamByteSource = streamByteSource;
			//Create a log file
			try {
				//System.out.println(OASIS_HOME);
				//System.out.println(OasisConstants.SFLogger);
				//String s = "z:/oasis";
				//OasisConstants.SFLogger = s + OasisConstants.SFLogger;
			  new OasisConstants();	//xg 1/27/2009 avoid env problem when run sf of tinyos-1.x
			  serialPortLogger = new FileWriter(OasisConstants.SFLogger, true);
			}
			catch (IOException e) {
				e.printStackTrace();
			}
		}
			
		public void run() {
		 	while (true){
				try {
		 			if (streamByteSource.getnPacketsRead() != tempNoPacketsRead){
						tempNoPacketsRead = streamByteSource.getnPacketsRead();
						this.sleep(60000);
		 			}	
					else {
						if (!opened){
							this.sleep(60000);
							continue;
						}	
						
						if (sbsStarted){
							tempNoPacketsRead = 0;
							streamByteSource.close();
							streamByteSource.open();
							//Print the restart information to SerialForwarder
							streamByteSource.message("SerialPort " + name + " restarts at " + new Date());
							//Andy29/7/2008
							String logOutput = monitor.Util.getDateTime()   + " : " +  "JAVA: " + name  +  " closes and restarts the connection ";
								try {
									serialPortLogger.write(logOutput +"\n");
									serialPortLogger.flush();	
									System.out.println(logOutput);
								}
								catch (Exception ex){}

							this.sleep(60000);
						}
						else{ 
							this.sleep(60000);
							sbsStarted = true;
						}
					}
				}
				catch(Exception ex){
					ex.printStackTrace();
				}
		 	}
	}
    }
}
