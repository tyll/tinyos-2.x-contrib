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
/* Authors:  David Gay  <dgay@intel-research.net>
 *           Intel Research Berkeley Lab
 *
 */
/**
 * @author David Gay <dgay@intel-research.net>
 * @author Intel Research Berkeley Lab
 */
package rpc.message;

import rpc.util.*;
import rpc.packet.*;
import java.io.*;
import xml.Parser.XMLMessageParser;

/**
 * MoteIF provides an application-level Java interface for receiving 
 * messages from, and sending messages to, a mote through a serial port, 
 * TCP connection, or some other means of connectivity. Generally this
 * is used to write Java programs that connect over a TCP or serial port
 * to communicate with a TOSBase or GenericBase mote.
 *
 * The default way to use MoteIF is to create an instance of this class
 * and then register one or more MessageListener objects that will 
 * be invoked when messages arrive. For example:
 * <pre>
 *   MoteIF mif = new MoteIF();
 *   mif.registerListener(new FooMsg(), this);
 *   
 *   // Invoked when a message arrives
 *   public void messageReceived(int toaddr, Message msg) { ... }
 * </pre>
 * The default MoteIF constructor uses the MOTECOM environment
 * variable to determine how the Java application connects to the mote.
 * For example, a MOTECOM setting of "serial@COM1" connects to a base
 * station using the serial port on COM1.
 *
 * You can also send messages through the base station mote using
 * <tt>MoteIF.send()</tt>.
 * 
 * @see rpc.packet.BuildSource
 * @author	David Gay
 */
public class MoteIF extends Thread {

    /** The destination address for a broadcast. */
    public static final int TOS_BCAST_ADDR = 0xffff;
    static final int ANY_GROUP_ID = -1;
    protected PhoenixSource source;
    protected Sender sender;
    protected Receiver receiver;
    protected int groupId;
    //xiaogang for xml paser
    XMLMessageParser xmp;

    public void setXmp(XMLMessageParser xmp) {
        this.xmp = xmp;
    }

    /**
     * Create a new mote interface to packet source specified using the 
     * MOTECOM environment variable. Status and error messages will
     * be printed to System.err.
     */
//    public MoteIF() {
//      init(BuildSource.makePhoenix(rpc.util.PrintStreamMessenger.err),
//	  ANY_GROUP_ID);
//    }
    public MoteIF(XMLMessageParser xmp) {
        setXmp(xmp);
        init(BuildSource.makePhoenix(rpc.util.PrintStreamMessenger.err),
                ANY_GROUP_ID);
    }

    /**
     * Create a new mote interface to packet source specified using the 
     * MOTECOM environment variable. Status and error messages will
     * be printed to System.err.
     *
     * @param messages where to send status messages (null means no messages)
     */
    public MoteIF(Messenger messages) {
        init(BuildSource.makePhoenix(messages), ANY_GROUP_ID);
    }

    /**
     * Create a new mote interface to packet source specified using the 
     * MOTECOM environment variable. Status and error messages will
     * be printed to System.err.
     *
     * This constructor is only useful if you expect to be using a
     * TransparentBase base station (which does not filter or set group ids),
     * or if you're using the old GenericBase (which requires the host to
     * specify the same group id as used for sending messages through 
     * GenericBase).
     *
     * @param messages where to send status messages (null means no messages)
     * @param gid group id of messages to listen to. If set to -1,
     *   receive all group ID's, and disable sending of messages.
     * @deprecated gid only needed with GenericBase or TransparentBase.
     */
    public MoteIF(Messenger messages, int gid) {
        init(BuildSource.makePhoenix(messages), gid);
    }

    /**
     * Create a new mote interface to an arbitrary packet source. The
     * packet source is started if necessary. 
     *
     * @param source packet source to use
     */
    public MoteIF(PhoenixSource source) {
        init(source, ANY_GROUP_ID);
    }

    /**
     * Create a new mote interface to an arbitrary packet source for a
     * specific group id. The packet source is started if necessary.
     *
     * This constructor is only useful if you expect to be using a
     * TransparentBase base station (which does not filter or set group ids),
     * or if you're using the old GenericBase (which requires the PC to
     * specify the same group id as used for the GenericBase)
     *
     * Note: The returned MoteIF need not be started (it is a thread
     * for legacy reasons only)
     *
     * @param source packet source to use
     * @param gid group id of messages to listen to. If set to -1,
     *   receive all group ID's, and disable sending of messages.
     * @deprecated gid only needed with GenericBase or TransparentBase.
     */
    public MoteIF(PhoenixSource source, int gid) {
        init(source, gid);
    }

    /**********************************************************************/
    private void init(PhoenixSource source, int gid) {
        this.source = source;
        // Start source if it isn't started yet
        
        groupId = gid;
        receiver = new Receiver(source, groupId);
        receiver.setXmp(xmp);
        sender = new Sender(source, groupId);
				//start();
				    }
		public void start(){
		try {
            source.start();
        } catch (IllegalThreadStateException e) {
        }
        try {
            source.awaitStartup();
        } catch (IOException e) {
            e.printStackTrace();
        }

		}

    /**
     * Return this MoteIF's group id
     * @return The group id, -1 for "promiscuous receive" (and send
     *   with arbitrary group id - this will only work with the new
     *   TOSBase base station)
     */
    public int getGroupId() {
        return groupId;
    }

    /**
     * @return this MoteIF's source 
     */
    public PhoenixSource getSource() {
        return source;
    }

    /**
     * Send m to moteId via this mote interface
     * @param moteId message destination
     * @param m message
     * @exception IOException thrown if message could not be sent
     */
   

    synchronized public void send(byte[] packetData) throws IOException {
        sender.send(packetData);
    }

    /**
     * Register a listener for given messages type. m should be an instance
     * of a subclass of Message (generated by mig). When a message of the
     * corresponding type is received, a new instance of m's class is 
     * created with the received message as data. This message is then 
     * passed to the given MessageListener. 
     * 
     * Note that multiple MessageListeners can be registered for the same
     * message type, and in fact each listener can use a different template
     * type if it wishes (the only requirement is that m.getType() matches
     * the received message). 
     *
     * @param m message template specifying which message to receive
     * @param l listener to which received messages are dispatched
     */
   
    synchronized public void registerListener(String m, MessageListener l) {
        receiver.registerListener(m, l);
    }

    /**
     * Deregister a listener for a given message type.
     * @param m message template specifying which message to receive
     * @param l listener to which received messages are dispatched
     */
   

    synchronized public void deregisterListener(String m, MessageListener l) {
        receiver.deregisterListener(m, l);
    }

    ////////////////  DEPRECATED ROUTINES /////////////////
    /** The maximum message size that can be sent.
     * @deprecated This is relatively meaningless as a PacketSource
     *   can be created for any desired packet size
     *   (and, worse, the constructors below may assign this static field)
     */
    public static int maxMessageSize;// = new BaseTOSMsg().totalSize_data();
    /** The default TinyOS packet size.
     * @deprecated With the new PacketSource frameworks, applications
     *   should not be worrying about packet sizes
     */
    public static int defaultPacketSize;// = BaseTOSMsg.offset_strength();

    // The size difference between payload and packet size
    // (senders need to know the full packet size)
    private static int headerOverhead;// = defaultPacketSize - maxMessageSize;


//    static {
//        MessageFactory mf = new MessageFactory();
//        TOSMsg msg = mf.createTOSMsg(10);
//        maxMessageSize = msg.totalSize_data();
//        try {
//            java.lang.reflect.Method m = msg.getClass().getMethod("offset_strength", null);
//            Integer i = (Integer) m.invoke(msg, null);
//            defaultPacketSize = i.intValue();//msg.offset_strength();
//        } catch (Exception e) {
//            defaultPacketSize = 288 / 8;
//        }
//        headerOverhead = defaultPacketSize - maxMessageSize;
//    }
    SerialStub sfw;

    /**
     * Create a new mote interface to SerialForwarder at host:port for
     * group id gid. The returned MoteIF (a thread object) should be
     * started if any messages are to be received.
     * @param host host of the SerialForwarder
     * @param port port of the SerialForwarder
     * @param gid group id of messages to listen to. If set to -1,
     *   receive all group ID's, and disable sending of messages.
     * @exception IOException thrown if SerialForwarder cannot be reached
     * @deprecated Use BuildSource.makeSF(host, port) instead
     */
    public MoteIF(String host, int port, int gid) throws Exception {
        this(host, port, gid, maxMessageSize, true);
    }

    /**
     * Create a new mote interface to an arbitrary SerialStub with
     * group id gid. The returned MoteIF (a thread object) should be
     * started if any messages are to be received.
     * @param stub Stub to use for communication to serial port or SerialForwarder
     * @param gid group id of messages to listen to. If set to -1,
     *   receive all group ID's, and disable sending of messages.
     * @exception IOException thrown if SerialForwarder cannot be reached
     * @deprecated Use BuildSource.makeSerial(comport, baudrate) instead
     */
    public MoteIF(SerialStub stub, int gid) throws Exception {
        this(stub, gid, maxMessageSize, true);
    }

    /**
     * Create a new mote interface to an arbitrary SerialStub for
     * group id gid. The returned MoteIF (a thread object) should be
     * started if any messages are to be received.
     * @param stub Stub to use for communication to serial port or SerialForwarder
     * @param gid group id of messages to listen to. If set to -1,
     *   receive all group ID's, and disable sending of messages.
     * @param msg_size The maximum message size this application will need to send
     * @exception IOException thrown if SerialForwarder cannot be reached
     * @deprecated Use BuildSource.makeSerial(comport, baudrate) instead - msg_size and checkCrc are no longer needed
     * 
     */
    public MoteIF(SerialStub stub, int gid, int msg_size, boolean checkCrc) throws Exception {
        maxMessageSize = msg_size;
        sfw = stub;
        sfw.Open();

        groupId = gid;

        receiver = new Receiver(sfw, groupId, checkCrc);
        if (groupId != -1) {
            sender = new Sender(sfw, groupId, maxMessageSize + headerOverhead);
        }
    }

    /**
     * Create a new mote interface to SerialForwarder at host:port for
     * group id gid. The returned MoteIF (a thread object) should be
     * started if any messages are to be received.
     * @param host host of the SerialForwarder
     * @param port port of the SerialForwarder
     * @param gid group id of messages to listen to. If set to -1,
     *   receive all group ID's, and disable sending of messages.
     * @param msg_size The maximum message size this application will need to send
     *                 Note that the serial forwarded must have been initialized with at least 
     *                 this message size as well.
     * @exception IOException thrown if SerialForwarder cannot be reached
     * @deprecated Use BuildSource.makeSF(host, port) instead - msg_size and checkCrc are no longer needed
     */
    public MoteIF(String host, int port, int gid, int msg_size, boolean checkCrc) throws Exception {
        this(new SerialForwarderStub(host, port, msg_size + headerOverhead),
                gid, msg_size, checkCrc);
    }

    /**
     * Body of this thread. Repeatedly reads and dispatches messages from
     * the SerialForwarder 
     * @deprecated No thread is needed for MoteIF when PhoenixSource is used
     */
    public void run() {
        // This does nothing with PhoenixSources (which have their own
        // thread)
        if (sfw != null) {
            try {
                sfw.Read();
            } catch (IOException e) {
                e.printStackTrace();
                System.exit(2);
            }
        }
    }
}
