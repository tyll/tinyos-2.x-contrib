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
 *
 * This class is the message listener based on MoteIF interface.
 * 1. It receives all messages registered in MoteIF
 *    including known/unknown messages
 * 2. Whenever a message is received, its contents will be displayed
 *    in the Message Table in Message Frame;
 * 3. Whenever a message is received, the corresponding raw data 
 *    (without the TOS_MSG Header) will be recorded in a ListModel;
 *
 * @author Xiaogang Yang <gavinxyang@gmail.com>
 */
package HE;

import Config.OasisConstants;
import java.util.*;
//import javax.mail.Message;
import rpc.message.*;
import xml.RemoteObject.StreamDataObject;
import xml.Parser.*;

public class HEDriver implements MessageListener {

    //YFH:Checking: use nodeID as array index directly to speed up the updation
    long[] HighestSeqNo = new long[OasisConstants.MAX_NODE_NUM];
    int lastrow = 0;
    int total = 0;
    int unknowntotal = 0;
    MoteIF mote;
    HEPanel panel;
    public static long startTime;
    public static XMLMessageParser xmp;
    // Message temp;
    public ArrayList ApplicationTypeArray = new ArrayList();

    public HEDriver(MoteIF _mote, HEPanel _panel, XMLMessageParser xmp) {
        startTime = System.currentTimeMillis();
        mote = _mote;
        panel = _panel;
        this.xmp = xmp;
        mote.registerListener("general", this);
    }

    public void messageReceived(String typeName, Vector streamEvent) {


        if (typeName.equalsIgnoreCase("general")) {

           // Integer sender = ((Integer) (((StreamDataObject) streamEvent.get(5)).data.get(0))).intValue();
            //YFHCheck:
	   int value = ((Integer) (((StreamDataObject) streamEvent.get(5)).data.get(0))).intValue() ;
	    int V=(int)(value/1000000);		
	    int Y=(int)((value-V*1000000)/1000);
            int	X=(int)(value%1000);
            //V=100<<24|V<<16|V<<8|V;
            panel.update(X,Y,V);
            //System.out.println(sender);
            //System.out.println(X+" "+Y+" "+V);
            
        }

    }
}

