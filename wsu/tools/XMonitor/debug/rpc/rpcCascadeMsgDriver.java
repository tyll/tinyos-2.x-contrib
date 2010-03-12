//$Id$

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
 * Function Description:
 * This is class which handles all Cascade CtrlMsgs
 *
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package debug.rpc;

import debug.rpc.*;
import com.oasis.message.*;
import Config.*;

import net.tinyos.message.*;
import net.tinyos.util.*;

import java.util.Vector;
import java.util.Enumeration;

import java.io.*; 
import java.util.*;
import java.text.*;

import java.awt.*;
import java.applet.Applet;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;



public class rpcCascadeMsgDriver implements MessageListener
{
	public static NescApp app;

	public rpcCascadeMsgDriver(NescApp app){
		this.app = app;
	};

	public void messageReceived(int to, Message m) 
	{
		//Message Check: to avoid crashed message 
		if (m.dataLength() < (CasCtrlMsg.DEFAULT_MESSAGE_SIZE)){
			System.out.println("Dropping message: in rpcCascadeMsgDriver.messageReceived(): dataLength = "+m.dataLength());
			return;
		}



		//Get seqNo of requested cmd
		CasCtrlMsg CMsg = new CasCtrlMsg(m.dataGet());
		switch (CMsg.get_type())
		{
		case OasisConstants.TYPE_CASCADES_REQ:
//			processReqMsg(CMsg);
			break;
		
		default:
			break;
		}
	}


	public void processReqMsg(CasCtrlMsg CMsg) {
		int reqSeqNo = CMsg.get_dataSeq();
/*
		System.out.println("receive req msg for "+reqSeqNo+" from "+ CMsg.get_linkSource());

		//Check cmdRecord for requested cmd
		Message reqCmd = app.comm.sendComm.getCmdMsg(reqSeqNo);
		if (reqCmd != null) {
			app.comm.sendComm.send(reqCmd);
			
			System.out.println("send old msg "+reqSeqNo);

		}
		else {
			CasCtrlMsg noDataMsg = new CasCtrlMsg();
			noDataMsg.set_type((short)OasisConstants.TYPE_CASCADES_NODATA);
			noDataMsg.set_dataSeq(app.getSeqNo());
			noDataMsg.set_linkSource(OasisConstants.UART_ADDRESS);
			noDataMsg.set_parent(0);
			//Message newCmd = new Message(Message.DEFAULT_MESSAGE_SIZE
			//	                         +CasCtrlMsg.DEFAULT_MESSAGE_SIZE);
			//newCmd.dataSet(noDataMsg, newCmd.offset_data(0));
			//m.dataSet(noDataMsg, m.offset_data(0));

		System.out.println("send no data msg for "+reqSeqNo);



			app.comm.sendComm.send(noDataMsg);
		}
*/
	}
}


