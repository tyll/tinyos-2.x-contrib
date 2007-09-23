/*
 * Copyright (c) 2006-7 Stanford University.
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
 * - Neither the name of the Stanford University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * Java-side application for getting data from the noise sampling
 * application.
 * 
 *
 * @author Phil Levis <pal@cs.berkeley.edu>
 * @date August 12 2005
 */

import java.io.*;
//import java.io.IOException;

import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

public class RssiSample implements MessageListener {

  private MoteIF moteIF;
  public FileOutputStream outputFile;
  public PrintStream output;
  
  public RssiSample(MoteIF moteIF) {
    this.moteIF = moteIF;

	//added by Hyungjune Lee
	try {
	    this.outputFile = new FileOutputStream("Noise.txt");
	    this.output = new PrintStream(outputFile);
	    this.output.println("# Noise data with 1KHz sampling by Hyungjune Lee (abbado@stanford.edu)");
	    this.output.println("# Note that RSSI values do not have the RSSI offset value included.");
	    this.output.println("# Please consult the CC2420 data sheet for how to obtain this value.");
	    this.output.println("# It is typically -45.");
	    this.output.println();
	    this.output.println("# [Node Id] [Sequence No] [RSSI(dBm)]");
	    this.output.println("");
	}
	catch(IOException e) {
	    System.err.println("Exception thrown when creating a file. Exiting.");
	    System.err.println(e);
	}
	this.moteIF.registerListener(new RssiSampleMsg(), this);
  }
    
  public void sendPackets() {
    int counter = 0;
    RssiSampleMsg payload = new RssiSampleMsg();
    
    try {
      while (true) {
	System.out.println("Sending packet " + counter);
	payload.set_seqNo(counter);
	moteIF.send(0, payload);
	counter++;
	try {Thread.sleep(1000);}
	catch (InterruptedException exception) {}
      }
    }
    catch (IOException exception) {
      System.err.println("Exception thrown when sending packets. Exiting.");
      System.err.println(exception);
    }
  }

  public void messageReceived(int to, Message message) {
    RssiSampleMsg msg = (RssiSampleMsg)message;
    //System.out.println("SeqNo=" + msg.get_seq() + ", Rssi=" + msg.get_rssi());

	//modified by Hyungjune Lee	
	try {
	    int rssiVal = (int)((byte)msg.get_rssiVal());
	    output.println(msg.get_nodeId()+ " " + msg.get_seqNo() + " " + rssiVal);
	}
	catch (Exception e){
	 System.err.println("Exception thrown when writing the outputs. Exiting.");
	 System.err.println(e);
	}
  }
  
  private static void usage() {
    System.err.println("usage: RssiSample [-comm <source>]");
  }
  
  public static void main(String[] args) throws Exception {
    String source = null;
    if (args.length == 2) {
      if (!args[0].equals("-comm")) {
	usage();
	System.exit(1);
      }
      source = args[1];
    }
    else if (args.length != 0) {
      usage();
      System.exit(1);
    }
    
    PhoenixSource phoenix;
    
    if (source == null) {
      phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
    }
    else {
      phoenix = BuildSource.makePhoenix(source, PrintStreamMessenger.err);
    }

    MoteIF mif = new MoteIF(phoenix);
    RssiSample serial = new RssiSample(mif);
    //serial.sendPackets();
  }


}
