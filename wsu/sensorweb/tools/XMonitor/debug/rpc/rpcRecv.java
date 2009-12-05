/**
 * Copyright (C) 2006 WSU All Rights Reserved
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE WASHINGTON STATE UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE WASHINGTON 
 * STATE UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE WASHINGTON STATE UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE WASHINGTON STATE UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */


/** 
 *
 * 
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */

package debug.rpc;

import debug.rpc.*;
import com.oasis.message.*;
import Config.*;

import net.tinyos.message.*;
import net.tinyos.util.*;

import org.apache.log4j.*;

import java.io.*; 
import java.text.*;
import java.util.*;
import java.net.*;

public class rpcRecv implements MessageListener {    
  private MoteIF moteIF;
  private int spAddr;
  private HashMap idTable = new HashMap();

  public rpcRecv(int p_spAddr, MoteIF p_moteIF) {
     spAddr = p_spAddr;
     moteIF = p_moteIF;
     moteIF.registerListener(new NetworkMsg(), this);
	 //8/5/2007
	 moteIF.registerListener(new CasCtrlMsg(), this);
  }


  public void registerListener(int id, MessageListener m) {
    HashSet listenerSet = (HashSet) idTable.get(new Integer(id));    
    if (listenerSet == null) {
		listenerSet = new HashSet();
		idTable.put(new Integer(id), listenerSet);
    }
    listenerSet.add(m);
  }


  public void deregisterListener(int id, MessageListener m) {
    HashSet listenerSet = (HashSet) idTable.get(new Integer(id));    
    if (listenerSet == null) {
	throw new IllegalArgumentException("No listeners registered for message type "+id);
    }
    listenerSet.remove(m);
  }


  synchronized public void messageReceived(int to, Message m) {
	if (to != spAddr && to != MoteIF.TOS_BCAST_ADDR && to != OasisConstants.UART_ADDRESS) {
		return;
	}

	HashSet listenerSet = null;

	switch (m.amType())
	{
	case NetworkMsg.AM_TYPE:
		NetworkMsg NMsg = new NetworkMsg(m.dataGet());
		listenerSet = (HashSet) idTable.get(new Integer(NMsg.get_type()));
		NMsg = null;
		break;
	case CasCtrlMsg.AM_TYPE:
		listenerSet = (HashSet) idTable.get(new Integer(m.amType()));
		break;
	default:
		//unregistered msgs
	}

	if (listenerSet == null) {
	   return;
	}
	
	for(Iterator it = listenerSet.iterator(); it.hasNext(); ) {
	  MessageListener ml = (MessageListener) it.next();
	  ml.messageReceived(to, m);
	}
  }

}
