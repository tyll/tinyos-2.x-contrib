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
 * Set up communication module for sending rpc commands
 * and receiving rpc responses
 *
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package debug.rpc;

import Config.*;

import net.tinyos.message.*;
import net.tinyos.util.*;


public class RoutingMessages
{

	static public MoteIF moteif;
	static public rpcSend sendComm;
	static public rpcRecv receiveComm;
	static public int returnAddress;
	static public int address;


	public RoutingMessages(MoteIF moteif)
	{
		this.moteif = moteif;
		address = MoteIF.TOS_BCAST_ADDR;

		//Set up Send Interface
		sendComm = new rpcSend(OasisConstants.AM_RPCCASTMSG, moteif);

		//Set up Recv Interface
		receiveComm = new rpcRecv(OasisConstants.BASE_ID, moteif);

		//Set return address
		returnAddress = OasisConstants.ROOT_ID;
		
	}

}


