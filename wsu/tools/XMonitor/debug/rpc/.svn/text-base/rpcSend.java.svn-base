
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
 * @author Fenghua Yuan
 */

package debug.rpc;

import com.oasis.message.*;
import Config.*;

import net.tinyos.message.*;
import net.tinyos.util.*;

import org.apache.log4j.*;

import java.io.*; 
import java.text.*;
import java.util.*;

public class rpcSend {
  static int id;
/* Yang
  //8/5/2007 For Cascade
  static public Message [] cmdRecord;
  static public int headIndex;
*/
  static MoteIF moteIF;
  boolean sentOK = true;

  public rpcSend(int id) {
    try {
      moteIF = new MoteIF();

    } catch (Exception e) {
      System.out.println("ERROR: Couldn't contact serial forwarder.");
      System.exit(1);
    }
    this.id = id;
/*	//8/5/2007 
	 cmdRecord = new Message[OasisConstants.MAX_CMD_RECORD_NUM];
	 headIndex = 0;
*/
  }

  public rpcSend(int id, MoteIF p_moteIF) {
      this.id = id;
      moteIF = p_moteIF;
/*	//8/5/2007 
	 cmdRecord = new Message[OasisConstants.MAX_CMD_RECORD_NUM];
	 headIndex = 0;*/
  }


  //Pack RpcCommandMsg into AM_NETWORKMSG
  static public void sendRpc(int seqno, Message msg, int msgSize) 
  {
		RpcCommandMsg RCMsg = (RpcCommandMsg)msg;
		
    		//Fill in ApplicationMsg with payload as RpcCommandMsg
		ApplicationMsg AMsg = new ApplicationMsg(ApplicationMsg.DEFAULT_MESSAGE_SIZE 
			                                     + msgSize);
		AMsg.set_type((short)OasisConstants.TYPE_SNMS_RPCCOMMAND); 
		AMsg.set_length((short)msgSize);
		AMsg.set_seqno((short)seqno);
		AMsg.dataSet(RCMsg, AMsg.offset_data(0));
/*
		//Fill in CasDataMsg with payload as ApplicationMsg
		CasDataMsg CMsg= new CasDataMsg(CasDataMsg.DEFAULT_MESSAGE_SIZE 
			                            + ApplicationMsg.DEFAULT_MESSAGE_SIZE 
			                            + msgSize);
		CMsg.set_CMAu(0);
		CMsg.set_seq((short)seqno);
		CMsg.dataSet(AMsg, CMsg.offset_data(0));
*/
		//Fill in NetworkMsg with payload as CasDataMsg
		NetworkMsg	NMsg = new NetworkMsg(NetworkMsg.DEFAULT_MESSAGE_SIZE 
//			                              + CasDataMsg.DEFAULT_MESSAGE_SIZE 
			                              + ApplicationMsg.DEFAULT_MESSAGE_SIZE 
			                              + msgSize);
		NMsg.set_linksource(0);
		NMsg.set_dest(MoteIF.TOS_BCAST_ADDR);
		NMsg.set_source(0);
		NMsg.set_type((short)OasisConstants.NW_RPCC);
		NMsg.set_ttl((byte)0);
		NMsg.set_qos((byte)0);
		NMsg.set_seqno((short)seqno);
		NMsg.dataSet(AMsg, NMsg.offset_data(0));
       
		//Reset amType of NetworkMsg by force 
		//[keep the format for NetworkMsg, but use a new amType]
		NMsg.amTypeSet(id);
		//seqno++;
		
		/********************Andy****************************
		ApplicationMsg AMsg = new ApplicationMsg(ApplicationMsg.DEFAULT_MESSAGE_SIZE 
			                                     + msgSize);
		AMsg.set_type((short)0); 
		AMsg.set_length((short)0);
		AMsg.set_seqno((short)0);
		AMsg.dataSet(RCMsg, AMsg.offset_data(0));

		//Fill in CasDataMsg with payload as ApplicationMsg
		CasDataMsg CMsg= new CasDataMsg(CasDataMsg.DEFAULT_MESSAGE_SIZE 
			                            + ApplicationMsg.DEFAULT_MESSAGE_SIZE 
			                            + msgSize);
		CMsg.set_CMAu(0);
		CMsg.set_seq(0);
		CMsg.dataSet(AMsg, CMsg.offset_data(0));

		//Fill in NetworkMsg with payload as CasDataMsg
		NetworkMsg	NMsg = new NetworkMsg(NetworkMsg.DEFAULT_MESSAGE_SIZE 
			                              + CasDataMsg.DEFAULT_MESSAGE_SIZE 
			                              + ApplicationMsg.DEFAULT_MESSAGE_SIZE 
			                              + msgSize);
		NMsg.set_linksource(0);
		NMsg.set_dest(0);
		NMsg.set_source(0);
		NMsg.set_type((short)0);
		NMsg.set_ttl((byte)0);
		NMsg.set_qos((byte)0);
		NMsg.set_seqno((short)0);
		NMsg.dataSet(CMsg, NMsg.offset_data(0));
       
		//Reset amType of NetworkMsg by force 
		//[keep the format for NetworkMsg, but use a new amType]
		NMsg.amTypeSet(id);
		
		********************Andy***************************/
		send(NMsg);  


  }

  
  //Send out RpcCommand by Simple Bcast
 static public void send(Message m) {
    try {
      moteIF.send(MoteIF.TOS_BCAST_ADDR, m);
	  //System.out.println("Send out rpc command....");
	 
	  //8/5/2007
	  //Keep record for recently sent cmd msg
//	 insertCmdRecord(m);

	} catch (IOException e) {
      //e.printStackTrace();
      System.out.println("ERROR: Can't send message");
      System.exit(1);
    } catch (Exception e) {
     // e.printStackTrace();
    }
  }

/*
  static public void insertCmdRecord(Message m){
	int i;
	boolean found = false;
	
	if (m.amType() == OasisConstants.AM_CASCTRLMSG) {
		return;
	}


	NetworkMsg NMsg = new NetworkMsg(m.dataGet());
	CasDataMsg CMsg = new CasDataMsg(m.dataGet(), NMsg.offset_data(0));

	for (i=0; i<OasisConstants.MAX_CMD_RECORD_NUM; i++) {
		if (cmdRecord[i] == null)
		{
			break;
		}
		NetworkMsg nMsg = new NetworkMsg(cmdRecord[i].dataGet());
		CasDataMsg cMsg = new CasDataMsg(cmdRecord[i].dataGet(), nMsg.offset_data(0));
		if (CMsg.get_seq() == cMsg.get_seq()) {
			found = true;
			break;
		}
	}

	if (found != true) {
		cmdRecord[headIndex] = m;
		headIndex = (headIndex +1)%OasisConstants.MAX_CMD_RECORD_NUM;
	}
  }

  static public Message getCmdMsg(int seqNo){
	int i;
	for (i=0; i<OasisConstants.MAX_CMD_RECORD_NUM; i++)	{
		if (cmdRecord[i] == null)
		{
			return cmdRecord[i];
		}
		NetworkMsg nMsg = new NetworkMsg(cmdRecord[i].dataGet());
		CasDataMsg cMsg = new CasDataMsg(cmdRecord[i].dataGet(), nMsg.offset_data(0));
		if (seqNo == cMsg.get_seq()) {
			return cmdRecord[i];
		}
	}
	return null;
  }

*/
}
