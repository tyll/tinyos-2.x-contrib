/*
 * Copyright (c) 2007-2009 Intel Corporation
 * All rights reserved.

 * This file is distributed under the terms in the attached INTEL-LICENS
 * file. If you do not find this file, a copy can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
import net.tinyos.packet.*;
import net.tinyos.message.*;
import java.io.*;

class ReliableMoteIF extends MoteIF {
    /* For testing purposes. Remove the "true || " to test under packet loss */
    boolean flip() {
	return true || Math.random() > 0.2;
    }

    /* Build an object for performing reliable transmission via 'base' */
    public ReliableMoteIF(PhoenixSource base) {
        super(base);
        /* Register handler ('ackMsgReceived' method below) for receiving acks */
	super.registerListener
	    (new AckMsg(), new MessageListener() {
		 public void messageReceived(int to, Message m) {
		     if (flip())
			 ackMsgReceived((AckMsg)m);
		 }
	     });
    }

    /* Send side */
    /* --------- */

    private Object ackLock = new Object(); /* For synchronization with ack handler */
    private short sendCookie = 1; /* Next cookie to use in transmission */
    private boolean acked; /* Set by ack handler when ack received */
    private final static int offsetUserData = ReliableMsg.offset_data(0);

    /* Send message 'm' reliably with destination 'to' */
    public void send(int to, Message m) throws IOException {
        synchronized (ackLock) {
	    /* Build a reliable_msg_t packet with the current cookie and the payload in m, 
	     * total packet size is 'm.dataLength() + offsetUserData' */
	    ReliableMsg rmsg = new ReliableMsg(m.dataLength() + offsetUserData);
	    rmsg.set_cookie(sendCookie);
	    System.arraycopy(m.dataGet(), m.baseOffset(),
			     rmsg.dataGet(), offsetUserData,
			     m.dataLength());

	    /* Repeatedly transmit 'rmsg' until the ack handler tells us an ack is received. */
            acked = false;
            for (;;) {
                super.send(to, rmsg);
		try {
		    ackLock.wait(RelConstants.ACK_TIMEOUT);
		}
		catch (InterruptedException e) { }
                if (acked)
                    break;
		System.err.printf("retry\n");
            }
	    /* Pick a new cookie for the next transmission */
	    sendCookie = (short)((sendCookie * 3) & 0xff);
        }
    }

    /* Handler for ack messages. If we see an ack for the current transmission, notify the 'send' method. */
    void ackMsgReceived(AckMsg m) {
	synchronized (ackLock) {
	    if (m.get_cookie() == sendCookie) {
		acked = true;
		ackLock.notify();
	    }
	}
    }

    /* Receive side */
    /* ------------ */

    private Message template;
    private MessageListener listener;

    /* Build a reliable receive handler for 'template' messages */
    public void registerListener(Message m, MessageListener l) {
	template = m;
	listener = l;

        /* Register handler (reliableMsgReceived method below) for receiving reliable_msg_t messages */
	super.registerListener
	    (new ReliableMsg(),
	     new MessageListener() {
		 public void messageReceived(int to, Message m) {
		     if (flip())
			 reliableMsgReceived(to, (ReliableMsg)m);
		 }
	     });
    }

    private short recvCookie; /* Cookie of last received message */

    void reliableMsgReceived(int to, ReliableMsg rmsg) {
        /* Acknowledge all received messages */
        AckMsg ack = new AckMsg();
        ack.set_cookie(rmsg.get_cookie());
	try {
	    super.send(MoteIF.TOS_BCAST_ADDR, ack);
	}
	catch (IOException e) { 
	    /* The sender will retry and we'll re-ack if the send failed */
	}

        /* Don't notify user of duplicate messages */
        if (rmsg.get_cookie() != recvCookie) {
            recvCookie = rmsg.get_cookie();

            /* Extract payload from 'rmsg' and copy it into a copy of 'template'.
               The payload is all the data in 'rmsg' from 'offsetUserData' on */
            Message userMsg = template.clone(rmsg.dataLength() - offsetUserData);
            System.arraycopy(rmsg.dataGet(), rmsg.baseOffset() + offsetUserData,
                             userMsg.dataGet(), 0,
                             rmsg.dataLength() - offsetUserData);
            listener.messageReceived(to, userMsg);
        }
    }
}
