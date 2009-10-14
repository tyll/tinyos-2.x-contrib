// $Id$

/*									tab:4
 * Copyright (c) 2007 University College Dublin.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice and the following
 * two paragraphs appear in all copies of this software.
 *
 * IN NO EVENT SHALL UNIVERSITY COLLEGE DUBLIN BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF 
 * UNIVERSITY COLLEGE DUBLIN HAS BEEN ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * UNIVERSITY COLLEGE DUBLIN SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND UNIVERSITY COLLEGE DUBLIN HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS.
 *
 * Authors:	Raja Jurdak, Antonio Ruzzelli, and Samuel Boivineau
 * Date created: 2007/09/07
 *
 */

/**
 * @author Raja Jurdak, Antonio Ruzzelli, and Samuel Boivineau
 */


import java.util.*;
import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

/*
	This class is a thread that manages a queue. The thread
	sends messages and eventually waits a while, depending
	of the option choosed by the user.
	
	TODO :
*/
public class MsgSender extends Thread {
	private LinkedList queue;
	private MessageToSend msgToSend;
	private MoteIF gateway;
	private ConsolePanel consolePanel;
	
	public MsgSender(MoteIF gateway, ConsolePanel consolePanel) {
		queue = new LinkedList();
		this.gateway = gateway;
		this.consolePanel = consolePanel;
	}
	
	/*
		The thread either executes tasks or sleep.
	*/
	
	public void run() {
		while(true) {
			if (queue.isEmpty())
				try {Thread.sleep(20);} catch (Exception e) { e.printStackTrace();}
			else {
				try {
					msgToSend = (MessageToSend) queue.remove(0);
					gateway.send(msgToSend.sMsg.get_targetId(), msgToSend.sMsg);
					consolePanel.append(msgToSend.string, Util.MSG_MESSAGE_SENT);
					Thread.sleep(Util.SENDER_WAIT_TIME);
				} catch (Exception e) { e.printStackTrace();}
			} 
		}
    }
	
	/*
		This function adds in the queue the messages to send
	*/

	public void add(int targetId, int request, int parameters, String string) {
		OctopusSentMsg o = new OctopusSentMsg();
		o.set_request((short)request);
		o.set_targetId(targetId);
		o.set_parameters(parameters);
		queue.add(new MessageToSend(o, string));
	}
}

/*
	This class is composed of the message to send, and
	a string that is sent to the consolePanel.
*/

class MessageToSend {
	public OctopusSentMsg sMsg;
	public String string;
	
	public MessageToSend(OctopusSentMsg sMsg, String string) {
		this.string = string;
		this.sMsg = sMsg;
	}
}
