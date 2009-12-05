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
 * This is class which handles all RpcResponseMsgs
 *
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package debug.rpc;

import com.oasis.message.*;
import Config.*;
import monitor.*;

import net.tinyos.message.*;
import net.tinyos.util.*;

import java.util.Vector;
import java.util.Enumeration;

import java.io.*; 
import java.util.*;
import java.text.*;
import java.io.File;

import java.awt.*;
import java.applet.Applet;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;


public class rpcMessageDriver implements MessageListener
{
	public static NescApp app;
	Enumeration e, ed;
	int NodeId;
	String name;
	RpcCommandMsg cmd;
	Vector recvlist = new Vector();
	//Vector waitlist = new Vector();

	String returnValue = "";
	String returnValueLog = "";
	// static FileWriter eventLogger;

	int currentTransID = -1;

	public rpcMessageDriver(NescApp app){
		this.app = app;
		
		/*
	    OasisConstants oasisConstants = new OasisConstants();
		
	     try {
		  eventLogger = new FileWriter(OasisConstants.EventLogger, true);
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		*/


	};

	public void messageReceived(int to, Message m) 
	{
		String response = null;
		String responseLog = null;
		NetworkMsg NMsg = null;
		ApplicationMsg AMsg = null;
		RpcResponseMsg RRMsg = null;
		Rpc.StructArgs waitCmd = null;
		int tempAddr = 0;
		returnValue = "Return : Wrong XML";
		returnValueLog = "Return : Wrong XML";
		
		//Message Check: to avoid crashed message 
		if (m.dataLength() < (RpcResponseMsg.DEFAULT_MESSAGE_SIZE
							 +ApplicationMsg.DEFAULT_MESSAGE_SIZE
							+NetworkMsg.DEFAULT_MESSAGE_SIZE)){
			System.out.println("Dropping message: in rpcPanel.messageReceived(): dataLength = "+m.dataLength());
			return;
		}
		
		NescDecls.nescType nesctype = new NescDecls.nescType();
		NescDecls.nescStruct nescstruct = new NescDecls.nescStruct();

		NMsg = new NetworkMsg(m.dataGet());
		AMsg = new ApplicationMsg(m.dataGet(), NMsg.offset_data(0));
		RRMsg = new RpcResponseMsg(m.dataGet(), NMsg.offset_data(0)+ AMsg.offset_data(0));

		//Discard message with lower transID (older ones)
		/*int newID = RRMsg.get_transactionID();

		if ( newID >= currentTransID) {
			currentTransID = newID;
		}
		else{
			return;
		}*/

		//Check for duplication & update recvlist 
		boolean recv = updateRecvList(RRMsg);
		
		//Display new response msg
		if ((!recv)) {
			int id = RRMsg.get_commandID();
			response = "From [ "+RRMsg.get_sourceAddress()+" ] "+ new Date()+ " CmdID="+id+ ", "
					   + getErrorType(RRMsg.get_errorCode())+ " \n";  
			responseLog = "From [ "+RRMsg.get_sourceAddress()+" ] "+ " CmdID="+id+ ", "
					   + getErrorType(RRMsg.get_errorCode())+ " \n";  
			
					
			if (RRMsg.get_errorCode() != OasisConstants.RPC_WRONG_XML_FILE ){
				//Interpret Return Value 
				
				returnValue = "Return : 0";
					returnValueLog = "		Return : 0";

				if (RRMsg.get_dataLength()>0){
					byte [] msgdata = m.dataGet();
					int start = NMsg.offset_data(0)+AMsg.offset_data(0)+RRMsg.offset_data(0);
					int end = m.dataLength();
					int at=0, len=0;
					boolean ramSymbol = false;

					waitCmd = app.rpcs.findRpcFunc(id);

					NescApp.getType(waitCmd.responseType, nesctype);
					returnValue = "Return : ";
					returnValueLog = "		Return : ";
					
					if (nesctype.nesctype == null) {
						
						NescApp.getStruct(waitCmd.responseType, nescstruct);
						if (nescstruct.nesctype == null) {
							System.out.println("In rpcPanel.messageReceived(): Error: Unknown Return Type!");
							//System.exit(0);
						}
						//if returnType is nescStruct
						else{
							
							if((waitCmd.name).equals("RamSymbolsM.peek")) 
								ramSymbol = true;
							interpStructReturn(msgdata, start, nescstruct.nesctype, ramSymbol);
			
							
						}
						
					}
					//if returnType is nescType
					else{		
						if (nesctype.size != RRMsg.get_dataLength()){
							System.out.println("In rpcPanel.messageReceived(): Error: not a simple Type!");
						}
						else{
							at = start;
							len = nesctype.size;

							long tempValue = Util.mBytes2Value(msgdata, at, len, nesctype._conversionstring);
							returnValue += tempValue;
							returnValueLog += tempValue;
						}
					}
				}
			}
			
			
			//Write to Action Panel
			rpcPanel.actionLog.append(response + returnValue +"\n");
			//Write into log file
			rpcPanel.writeLog(response + returnValue +"\n");
			
			String logOutput = monitor.Util.getDateTime()   + " : " + "RESPONSE: " + response + returnValue;
			try {
					MainClass.eventLogger.write( logOutput +"\n");
					MainClass.eventLogger.flush();			
					System.out.println(logOutput);
				}
			catch (Exception ex){}
			
		}
	}


	public void interpStructReturn(byte [] msgdata, int start, String name, boolean ramSymbol)
	{
		int tempAddr = 0;
		long tempValue = 0;
		int at=0, len=0;
		NescDecls.nescType mytype = new  NescDecls.nescType();
		NescDecls.nescStruct pstruct = new NescDecls.nescStruct();
		NescApp.getStruct(name, pstruct);

		
		Vector plist = new Vector();
		Vector pname = new Vector();
		Enumeration e, ee, te, fe;
	
		
		if (!pstruct.values.isEmpty()) {
			
			ee = pstruct.fields.elements();
			for (e = pstruct.values.elements(); e.hasMoreElements(); ) {
				plist.clear();
				pname.clear();
				NescDecls._ParamField field = (NescDecls._ParamField)ee.nextElement();
				
				at = field.bitOffset/8 + start;
				len = field.bitSize/8;

				//System.out.println(field.name);
				
				NescDecls._ParamTuple p = (NescDecls._ParamTuple)e.nextElement();
				//System.out.println(field.name + " : " + len + " : " +  ramSymbol);
				//System.out.println(start + " : " + at);
				
				//Specific for Peek():
				if (ramSymbol && (at-start)==0){
					NescApp.getType(p.type.typename, mytype);							
					tempValue = Util.mBytes2Value(msgdata, at, len, mytype._conversionstring);
					tempAddr = (int)tempValue;
				}

				//System.out.println(len);
				
				//Interpret data portion from returned symbol value
				if (ramSymbol && len == RamSymbols.ramSymbol_t.MAX_RAM_SYMBOL_SIZE){
					//get symbol struct based on memAddress
					
					RamSymbols.RamArgs ramArgs = app.ramsymbols.findRamSymbol(tempAddr);
					interpStructReturn(msgdata, at, ramArgs.name, false);
					break;
				}

				//recursively interperate this field of the struct
				plist = ParamEditor.getParamList(p);
				
				for (te = plist.elements(); te.hasMoreElements(); ) {
					ParamEditor._TableParam tp = (ParamEditor._TableParam)te.nextElement();
					pname.addElement(name+"."+tp.Tname);
				}

				int at2 = at, len2 = 0;
				te = pname.elements();
				for (fe = plist.elements(); fe.hasMoreElements();) {

					//System.out.println( RamSymbols.ramSymbol_t.MAX_RAM_SYMBOL_SIZE);

					//System.out.println(ramSymbol + );
					
					if (ramSymbol && len != RamSymbols.ramSymbol_t.MAX_RAM_SYMBOL_SIZE) {
						
						ParamEditor._TableParam fp = (ParamEditor._TableParam)fe.nextElement();
						at2 += len2;
						len2 = app.getsize(fp.Ttype);
						NescApp.getType(fp.Ttype, mytype);
					
						long tempValue2 = Util.mBytes2Value(msgdata, at2, len2, mytype._conversionstring);

						String returnString = ((String)(te.nextElement())+" = "+tempValue2+", ");	
						
						returnValue += returnString;	
						
						returnValueLog += returnString;	
						

						
					} else{
					
						ParamEditor._TableParam fp = (ParamEditor._TableParam)fe.nextElement();
						//at2 += len2;
						at2 = at + fp.byteOffset/8;
						len2 = app.getsize(fp.Ttype);
						NescApp.getType(fp.Ttype, mytype);
						
						//System.out.println(fp.Tname + " : " + fp.Ttype + " : " + fp.byteOffset);

						//System.out.println(msgdata.length + "   " + at2 + "    " + len2 );
					
						long tempValue2 = Util.mBytes2Value(msgdata, at2, len2, mytype._conversionstring);

						String returnString = (" \n"+(String)(te.nextElement())+" = "+tempValue2);
						
						returnValue += returnString;	
						returnValueLog += returnString;	
					}
				}
			}
		}
	}


	public boolean updateRecvList(RpcResponseMsg rMsg)
	{
		boolean recvd = false;

		//Check duplication first
		Enumeration e;
		for (e = recvlist.elements(); e.hasMoreElements(); ) {
			RpcResponseMsg inlist = (RpcResponseMsg)e.nextElement();
			if (cmpRecvMsg(rMsg, inlist)) {
				recvd = true;
				break;
			}
		}		
		if (!recvd) {
			recvlist.addElement(rMsg);
		}
		return recvd;
	}


	/**
	 * @return   true if m1 and m2 are same
	 *           false  o.w.
	 */
	public boolean cmpRecvMsg(RpcResponseMsg m1, RpcResponseMsg m2)
	{
		boolean ret = false;
		if ((m1.get_commandID() == m2.get_commandID())
			&& (m1.get_transactionID() == m2.get_transactionID())
			&& (m1.get_sourceAddress() == m2.get_sourceAddress())
		   )
		{
			ret = true;
		}

		return ret;
	} 


	/*public Rpc.StructArgs checkWaitList(Message m)
	{
		Rpc.StructArgs cmd = null;
		return cmd;
	}*/



	/**
	 * Register sentout RpcCommands as the reference to get returnType 
	 */
   /* public void appendWaitList(int nodeId, String _name, RpcCommandMsg _cmd)
	{
		//Check duplication first
		Enumeration e;
		boolean found = false;
		_WaitCmd wc = new _WaitCmd(nodeId, _name, _cmd);
		for (e = waitlist.elements(); e.hasMoreElements(); ) {
			_WaitCmd inlist = (_WaitCmd)e.nextElement();
			if (cmpWaitCmd(wc, inlist)) {
				found = true;
				break;
			}
		}
		
		//Append to waitlist if not found
		if (!found) {
			waitlist.addElement(wc);		
		}
	}*/


	/**
	 * @return   true if c1 and c2 are same
	 *           false  o.w.
	 */
	/*public boolean cmpWaitCmd(_WaitCmd c1, _WaitCmd c2)
	{
		boolean ret = false;
		if ((c1.cmdMsg.get_commandID() == c2.cmdMsg.get_commandID())
			//&& (c1.cmdMsg.get_transactionID() == c2.cmdMsg.get_transactionID())
		   // && (cl.nodeId == c2.nodeId)
		   )
		{
			ret = true;
		}

		return ret;
	} */


	public String getErrorType(int errorCode)
	{
		String errorType = null;
		switch (errorCode)
		{
		case OasisConstants.RPC_SUCCESS:
			errorType = "RPC_SUCCESS";
			break;
		case OasisConstants.RPC_GARBAGE_ARGS:
			errorType = "RPC_GARBAGE_ARGS";
			break;
		case OasisConstants.RPC_RESPONSE_TOO_LARGE:
			errorType = "RPC_RESPONSE_TOO_LARGE";
			break;
		case OasisConstants.RPC_PROCEDURE_UNAVAIL:
			errorType = "RPC_PROCEDURE_UNAVAIL";
			break;
		case OasisConstants.RPC_SYSTEM_ERR:
			errorType = "RPC_SYSTEM_ERR";
			break;
		case OasisConstants.RPC_WRONG_XML_FILE:
			errorType = "RPC_WRONG_XML_FILE";
			break;
		default:
			errorType = "UNKNOWN_TYPE_ERR";
			break;		
		}
		return errorType;
	}



}


