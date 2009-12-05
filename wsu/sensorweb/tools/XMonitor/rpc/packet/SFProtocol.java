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
import java.net.*;
import rpc.message.*;

abstract public class SFProtocol extends AbstractSource
{
    // Protocol version, written at connection-open time
    // 2 bytes: first byte is always 'T', second byte is
    // protocol version
    // The actual protocol used will be min(my-version, other-version)
    // current protocols:
    // ' ': initial protocol, no further connection data, packets are
    //      1-byte length followed by n-bytes data
    //      If platform is unspecified by constructor, platform is
    //      the default platform.
    // '!': add platform exchange at connection time, packets are
    //      unchanged
    //      If platform is unspecified by constructor, platform is
    //      the platform returned at connection time (protocol error
    //      if that is the unknown platform)
   //final static byte VERSION[] = {'T', '!','U', ' '};
      final static byte VERSION1[] = {'T', '!'};
      final static byte VERSION2[] = {'U', ' '};
     int version; // The protocol version we're running (negotiated)

    protected InputStream is;
    protected OutputStream os;
    

    protected SFProtocol(String name) {
	this(name, Platform.unknown);
    }
    
    protected SFProtocol(String name, int plat) {
	super(name);
	platform=plat;
    }

    protected void openSource() throws IOException {
	// Assumes streams are open
	byte[] partner = readN(2);
	if(partner[0] == VERSION1[0]){
	System.out.println("serial forwarder version 1");
	os.write(VERSION1);
	//System.out.println((char)partner[0]+" "+(char)partner[1]+" "+(char)VERSION1[0]);
	
		if (!(partner[0] == VERSION1[0] && (partner[1] & 0xff) >= ' '))
		    throw new IOException("protocol error");
		  
		// Actual version is min received vs our version
	
		version = partner[1];
		if (VERSION1[1] < version)
		    version = VERSION1[1];
	
		// Any connection-time data-exchange goes here
	
		switch (version) {
		case ' ':
		    if (platform == Platform.unknown)
			platform = Platform.defaultPlatform;
		    break;
		case '!': 
		    byte f[]=new byte[4];
		    f[0] = (byte) (platform       & 0xff);
		    f[1] = (byte) (platform >> 8  & 0xff);
		    f[2] = (byte) (platform >> 16 & 0xff);
		    f[3] = (byte) (platform >> 24 & 0xff);
		    
		    os.write(f);
		    byte[] received = readN(4);
		    if (platform == Platform.unknown) {
			platform = received[0] & 0xff |
			    (received[1] & 0xff) << 8 |
			    (received[2] & 0xff) <<16 |
			    (received[3] & 0xff) <<24; 
			if (platform == Platform.unknown) {
			   // throw new IOException("connecting to unknown platform from " + this);
			}
		    }
		    break;
		}
	
	
	}
	
	if(partner[0] == VERSION2[0]){
	
		// Assumes streams are open
		System.out.println("serial forwarder version 2");
		os.write(VERSION2);
	// Check that it's a valid header (min version is ' ')
		if (partner[0] != VERSION2[0])
		    throw new IOException("protocol error");
		// Actual version is min received vs our version
		version = partner[1] & 0xff;
		int ourversion = VERSION2[1] & 0xff;
		if (ourversion < version)
		    version = ourversion;

		// Handle the different protocol versions (currently only one)
		// Any connection-time data-exchange goes here
		switch (version) {
		case ' ':
		    break;
		default:
		    throw new IOException("bad protocol version");
		}
	
	}
	
    }
	
    protected byte[] readSourcePacket() throws IOException {
	// Protocol is straightforward: 1 size byte, <n> data bytes
	byte[] size = readN(1);
	//System.out.println("SFP size: "+size);
	byte[] read = readN(size[0] & 0xff);
	
	return read;
    }

    protected byte[] readN(int n) throws IOException {
	byte[] data = new byte[n];
	int offset = 0;

	// A timeout would be nice, but there's no obvious way to
	// write it before java 1.4 (probably some trickery with
	// a thread and closing the stream would do the trick, but...)
	while (offset < n) {
	  int count = is.read(data, offset, n - offset);
	  //System.out.println("SFP count: "+count);
	  if (count == -1)
	    throw new IOException("end-of-stream");
	  offset += count;
	}
	
	return data;
    }

    protected boolean writeSourcePacket(byte[] packet) throws IOException {
	if (packet.length > 255)
	    throw new IOException("packet too long");
	//Dump.dump("SFProtocol writing", packet);
	os.write((byte)packet.length);
	os.write(packet);
	os.flush();
	return true;
    }
}
