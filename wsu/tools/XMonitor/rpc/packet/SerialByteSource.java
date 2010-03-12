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

import java.util.*;
import java.io.*;
//import javax.comm.*;
import gnu.io.*;

/**
 * A serial port byte source, with extra special hack to deal with
 * broken javax.comm implementations (IBM's javax.comm does not set the
 * port to raw mode, on Linux, at least in some implementations - call
 * an external program (tinyos-serial-configure) to "fix" this)
 */
public class SerialByteSource extends StreamByteSource implements SerialPortEventListener
{
    private SerialPort serialPort;
    private String portName;
    private int baudRate;

    public SerialByteSource(String portName, int baudRate) {
	this.portName = portName;
	this.baudRate = baudRate;
    }

    public void openStreams() throws IOException {
	CommPortIdentifier portId;
	try {
	    portId = CommPortIdentifier.getPortIdentifier(portName);
	}
	catch (NoSuchPortException e) {
	    throw new IOException("Invalid port. " + allPorts());
	}
	try {
	    serialPort = (SerialPort)portId.open("SerialByteSource",
						 CommPortIdentifier.PORT_SERIAL);
	}
	catch (PortInUseException e) {
	    throw new IOException("Port " + portName + " busy");
	}

	try {
	    serialPort.setFlowControlMode(SerialPort.FLOWCONTROL_NONE);
	    serialPort.setSerialPortParams(baudRate,
					   SerialPort.DATABITS_8,
					   SerialPort.STOPBITS_1,
					   SerialPort.PARITY_NONE);

	    serialPort.addEventListener(this);
	    serialPort.notifyOnDataAvailable(true);
	}
	catch (Exception e) {
	    serialPort.close();
	    throw new IOException("Couldn't configure " + portName);
	}

	// Try & run external program to setup serial port correctly
	// (necessary on Linux, IBM's javax.comm leaves port in cooked mode)
	try {
	    Runtime.getRuntime().exec("tinyos-serial-configure " + portName);
	}
	catch (IOException e) {
	    // If it fails, try the 2.x version
	    try {
		Runtime.getRuntime().exec("tos-serial-configure " + portName);
	    }
	    catch (IOException e2) { }
	}

	is = serialPort.getInputStream();
	os = serialPort.getOutputStream();
    }

    public void closeStreams() throws IOException {
	serialPort.close();
    }

    public String allPorts() {
	Enumeration ports = CommPortIdentifier.getPortIdentifiers();
	if (ports == null)
	    return "No comm ports found!";

	boolean  noPorts = true;
	String portList = "Known serial ports:\n";
	while (ports.hasMoreElements()) {
	    CommPortIdentifier port = (CommPortIdentifier)ports.nextElement();

	    if (port.getPortType() == CommPortIdentifier.PORT_SERIAL) {
		portList += "- " + port.getName() + "\n";
		noPorts = false;
	    }
	}
	if (noPorts)
	    return "No comm ports found!";
	else
	    return portList;
    }

    Object sync = new Object();

    public byte readByte() throws IOException {
	// On Linux at least, javax.comm input streams are not interruptible.
	// Make them so, relying on the DATA_AVAILABLE serial event.
	synchronized (sync) {
		//System.out.println(is+" readByte packet");//xg  1/27/2009 design to debug
		//while (is.available() == 0) {   
	    while (is==null||is.available() == 0) {		//xg 1/27/2009 avoid warning when is cannot read
	
		try {
		    sync.wait();
		}
		catch (InterruptedException e) {
		    close();
		    throw new IOException("interrupted");
		}
	    }
	}

	return super.readByte();
    }

    public void serialEvent(SerialPortEvent ev) {
	synchronized (sync) {
	    sync.notify();
	}
    }

}
