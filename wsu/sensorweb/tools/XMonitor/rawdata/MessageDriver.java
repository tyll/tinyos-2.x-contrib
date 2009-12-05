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
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */
package rawdata;

import Config.OasisConstants;
import java.util.*;
//import javax.mail.Message;
import rpc.message.*;
import xml.RemoteObject.StreamDataObject;
import xml.Parser.*;

public class MessageDriver implements MessageListener {

	//YFH:Checking: use nodeID as array index directly to speed up the updation
	long[] HighestSeqNo = new long[OasisConstants.MAX_NODE_NUM];
	int lastrow = 0;
	int total = 0;
	int unknowntotal = 0;
	MoteIF mote;
	MessagePanel panel;
	public static long startTime;

	 public static XMLMessageParser xmp;
	// Message temp;
	public ArrayList ApplicationTypeArray = new ArrayList();

	public MessageDriver(MoteIF _mote, MessagePanel _panel,XMLMessageParser xmp ) {
		startTime = System.currentTimeMillis();
		mote = _mote;
		panel = _panel;
		this.xmp = xmp;
		//Resigster for Unknown Message
		//RouteBeaconMsg msg = new RouteBeaconMsg();
		//msg.amTypeSet(OasisConstants.ANY_TYPE_MSG);
		//mote.registerListener(msg, this);

		//Only register AM_Type msgs


		mote.registerListener("general", this);
		mote.registerListener("beacon", this);
		mote.registerListener("timeSync", this);
		mote.registerListener("rawdata",this);
		mote.registerListener("report",this);
		for (int i = 0; i < OasisConstants.MAX_NODE_NUM; i++) {
			HighestSeqNo[i] = -1;
		}
	}



	public void messageReceived(String typeName, Vector streamEvent) {
		//System.out.println(typeName);

		int sender = -1;
		long recv_seqNo = 0;
		//CreateNewTableLine(typeName, streamEvent);
		if (panel.ctlbt_status == true) {
			//Updata MsgTable when ctlbt is in 'play' status
			Object[] newrow = CreateNewTableLine(typeName, streamEvent);
			//System.out.println(newrow.toString());
			if (newrow != null) {
				//System.out.println(newrow.toString());
				AppendTable(newrow, typeName, streamEvent);
			}
			else{
				// System.out.println("newrow null");
			}
		}

		if (typeName.equalsIgnoreCase("general")) {

			sender = ((Integer) (((StreamDataObject) streamEvent.get(0)).data.get(0))).intValue();
					//YFHCheck:
			if (sender < 0 || sender >= OasisConstants.MAX_NODE_NUM) {
				System.out.println("Dropping message: in MessageDriver.messageReceived(): senderID Error!"+sender);
				return;
			}
			recv_seqNo = new Integer((Integer) (((StreamDataObject) streamEvent.get(3)).data.get(0))).intValue();
			if ((HighestSeqNo[sender] < recv_seqNo) ||
					(Math.abs(HighestSeqNo[sender] - recv_seqNo) > OasisConstants.RESET_PERIOD)) {
				HighestSeqNo[sender] = recv_seqNo;
					}

		}

	}



	public Object[] CreateNewTableLine(String typeName, Vector streamEvent) {
		String Ncontents, Acontents, Econtents, Dcontents;
		int sender = -1;
		Object[] ret = null;
		double time = (double) (System.currentTimeMillis() - startTime) / 1000.0;


		if (typeName.equalsIgnoreCase("general")) {
			//System.out.println(typeName+" CreateNewTableLine");
			sender = ((Integer) (((StreamDataObject) streamEvent.get(0)).data.get(0))).intValue();
			int networkType = ((Integer) (((StreamDataObject) streamEvent.get(1)).data.get(0))).intValue();
			int appType = ((Integer) (((StreamDataObject) streamEvent.get(2)).data.get(0))).intValue();
			int seq = ((Integer) (((StreamDataObject) streamEvent.get(3)).data.get(0))).intValue();
			long timestamp = ((Integer) (((StreamDataObject) streamEvent.get(4)).data.get(0))).intValue();
			int linksource = ((Integer) (((StreamDataObject) streamEvent.get(6)).data.get(0))).intValue();
			int size = ((Integer) (((StreamDataObject) streamEvent.get(5)).data.size()));
			//System.out.println("seq:"+seq);
			byte[] msgdata = new byte[size];
			/*
			int tmp = 0;
			for (int i = 0; i < size; i++) {
				tmp = ((Integer) (((StreamDataObject) streamEvent.get(5)).data.get(i))).intValue();
				msgdata[2 * i] = (byte) (tmp >> 8);
				msgdata[2 * i + 1] = (byte) ((tmp << 8) >> 8);
				//System.out.print(receivedData[i] +" ");
			}
			int start = 0;
			int end = size * 2;
			String data = "", current = "";
			for (int tt = start; tt < end; tt++) {
				//current = Integer.toHexString((int)msgdata[tt]);
				current = Integer.toHexString((int) msgdata[tt]);
				int len = current.length();
				if (len < 2) {
					data += "0x0" + current + " ";
				} else {
					current = current.substring(len - 2, len);
					data += ("0x" + current + " ");
				}
			}
			*/
			//System.err.println(typeName+" " + data);
			//	Object [] newRow21 = {" "+time, " "+sender, " "+networkType, NMsg.toString()+"  "+AMsg.toString()+"  "+data};
			Object[] newRow21 = {" " + time, " " + sender, " " + networkType,xmp.getValue(typeName,streamEvent)};

			return newRow21;
		}
		if (typeName.equalsIgnoreCase("beacon")) {


			//System.out.println("receive AM_BEACONMSG");
			int source = ((Integer) (((StreamDataObject) streamEvent.get(0)).data.get(0))).intValue();
			int networkType = ((Integer) (((StreamDataObject) streamEvent.get(1)).data.get(0))).intValue();
			int parent = ((Integer) (((StreamDataObject) streamEvent.get(2)).data.get(0))).intValue();
			int parent_dup = ((Integer) (((StreamDataObject) streamEvent.get(3)).data.get(0))).intValue();
			int cost = ((Integer) (((StreamDataObject) streamEvent.get(4)).data.get(0))).intValue();
			int hopcount = ((Integer) (((StreamDataObject) streamEvent.get(5)).data.get(0))).intValue();

			String res = source +
				" " + networkType +
				" " + parent +
				" " + parent_dup +
				" " + cost +
				" " + hopcount;
			Object[] newRow21 = {" " + time, " " + sender, " " + networkType, xmp.getValue(typeName,streamEvent)};
			return newRow21;


		}
		if (typeName.equalsIgnoreCase("timeSync")) {

			//System.out.println("receive AM_TIMESYNCMSG");

			sender = ((Integer) (((StreamDataObject) streamEvent.get(0)).data.get(0))).intValue();
			int size = ((Integer) (((StreamDataObject) streamEvent.get(1)).data.size()));
			byte[] msgdata = new byte[size * 2];
			int tmp = 0;
			for (int i = 0; i < size; i++) {
				tmp = ((Integer) (((StreamDataObject) streamEvent.get(5)).data.get(i))).intValue();
				msgdata[2 * i] = (byte) (tmp >> 8);
				msgdata[2 * i + 1] = (byte) ((tmp << 8) >> 8);
				//System.out.print(receivedData[i] +" ");
			}
			Object[] ftspMsg = {" " + time, " " + sender, " " + typeName,xmp.getValue(typeName,streamEvent)};
			return ftspMsg;

		}
		if (typeName.equalsIgnoreCase("report")) {

			//System.out.println("receive AM_TIMESYNCMSG");

			sender = ((Integer) (((StreamDataObject) streamEvent.get(0)).data.get(0))).intValue();
			int size = ((Integer) (((StreamDataObject) streamEvent.get(6)).data.size()));
			int[] msgdata = new int[size];
			int tmp = 0;
			for (int i = 0; i < size; i++) {
				tmp = ((Integer) (((StreamDataObject) streamEvent.get(6)).data.get(i))).intValue();
				msgdata[i] = tmp;
				//System.out.print(receivedData[i] +" ");
			}
			Object[] ftspMsg = {" " + time, " " + sender, " " + typeName,xmp.getValue(typeName,streamEvent)};
			return ftspMsg;

		}
		else {
			//(typeName.equalsIgnoreCase("rawdata"))

			int size = ((Integer)(streamEvent.get(0))).intValue();
			byte[] msgdata = new byte[size];
			
			for (int i = 0; i < size; i++) {
				msgdata[i] = (byte)((Byte)(streamEvent.get(i+1))).byteValue();
			}
       	int start = 0;
			int end = size;

			String data = "", current = "";
			for (int tt = start; tt < end; tt++) {
				//current = Integer.toHexString((int)msgdata[tt]);
				current = Integer.toHexString((int) msgdata[tt]);
				int len = current.length();
				if (len < 2) {
					data += "0x0" + current + " ";
				} else {
					current = current.substring(len - 2, len);
					data += ("0x" + current + " ");
				}
			}

			Object[] ftspMsg = {" " + time, " UNKNOWN" , "UNKNOWN("+size+")",xmp.getValue(typeName,streamEvent)};
			return ftspMsg;

		}


	}



	public void AppendTable(Object[] newrow, String typeName, Vector streamEvent) {
		int sender = -1;
		Integer type = null;
		long recv_seqNo = 0;
		boolean DISPLAY = false;
		int msgtype = -1;
		int filterType = -1;
		//System.out.println("appendtable");
		//Get more info about received msg for additional checking
		if (typeName.equalsIgnoreCase("general")) {
			sender = ((Integer) (((StreamDataObject) streamEvent.get(0)).data.get(0))).intValue();
			msgtype = ((Integer) (((StreamDataObject) streamEvent.get(1)).data.get(0))).intValue();
			//8/15/2008 filterType = NetworkMsg.AM_TYPE;
			filterType = ((Integer) (((StreamDataObject) streamEvent.get(2)).data.get(0))).intValue();
			//8/15/2008 End
		}
		if (typeName.equalsIgnoreCase("beacon")) {

			sender = ((Integer) (((StreamDataObject) streamEvent.get(0)).data.get(0))).intValue();
			msgtype = ((Integer) (((StreamDataObject) streamEvent.get(1)).data.get(0))).intValue();
			filterType = OasisConstants.NW_BEACONMSG;
		}

		if (typeName.equalsIgnoreCase("tinyeSync")) {
			sender = ((Integer) (((StreamDataObject) streamEvent.get(0)).data.get(0))).intValue();
			filterType = OasisConstants.AM_TIMESYNCMSG;
		}

		if (typeName.equalsIgnoreCase("rawdata")) {
			sender = OasisConstants.UNKNOWN_ID;
			filterType = OasisConstants.AM_UNKNOWN;
		}
		//System.out.println(panel.FILTMSG+" "+DISPLAY);
		if (panel.FILTMSG == false) {
			DISPLAY = true;
		} else {
			DISPLAY = false;
			int i = 0;
			//8/12/2008 Andy Add the Type Filter
			//System.out.println(panel.filtNode[i] + " " + panel.filtType[j]);
			//8/15/2008 int j = 0; -> move this statement inside the while loop
			while (panel.filtNode[i] != -1) {
				int j = 0;
				while (panel.filtType[j] != -1) {
					//System.out.println(panel.filtNode[i] );

					if (sender == panel.filtNode[i] && filterType == panel.filtType[j] ||
							(sender == panel.filtNode[i] && panel.filtType[j] == MessagePanel.NO_FILTER) ||
							(filterType == panel.filtType[j] && panel.filtNode[i] == MessagePanel.NO_FILTER)) {
						DISPLAY = true;
						break;
							}
					j++;
				}
				i++;
			}

		}

		//Pass the msg filter
		if (DISPLAY) {
			//Manage the tablemodel & rawdata buffer
			//28/8/2008 Andy Fix the problem when the rawData buffer is full
			try {
			int pos = panel.rawDataList.getSize()-1;
				if (lastrow == OasisConstants.MSG_BUFFER_SIZE) {
					//remove msg from table
					panel.tablemodel.removeRow(panel.tablemodel.getRowCount()-1);//remove(0);
					//remove msg type from buffer
					panel.msgtypeListModel.removeElementAt(panel.msgtypeListModel.getSize()-1);
					//remove msg from msg buffer
					panel.rawDataList.removeElementAt(panel.rawDataList.getSize()-1);//remove(0);
				}
			} catch (Exception e) {
			}
			//28/8/2008 End

			//Save the raw data in MsgBuffer
		//	int pos = panel.rawDataList.getSize();
			String raw_data = getRawData(typeName, streamEvent);
			//panel.rawDataList.add(pos, raw_data);
			panel.rawDataList.insertElementAt(raw_data,0);
			//Check missing or duplicate for DataMsg
			type = new Integer(-1);
			//if (msgtype == OasisConstants.NW_DATA) {
			type = new Integer(checkMsg(typeName, streamEvent));
			// }
			
			//panel.msgtypeListModel.add(pos, type);
      panel.msgtypeListModel.insertElementAt(type,0);
			//Append new row into the table
			//YFH: decide whether need to display first
			/*9/29/2008 Andy Append new message at the top
				panel.tablemodel.addRow(newrow);
				*/
			panel.tablemodel.insertRow(0, newrow);
			lastrow = panel.tablemodel.getRowCount();
		}
	}

	public int checkMsg(String typeName, Vector streamEvent) {
		if (typeName.equalsIgnoreCase("general") == false) {
			return -1;
		}


		int moteID = -1;
		long recv_seqNo;
		long diff;
		int type;


		moteID = ((Integer) (((StreamDataObject) streamEvent.get(0)).data.get(0))).intValue();
		recv_seqNo = ((Integer) (((StreamDataObject) streamEvent.get(3)).data.get(0))).intValue();
		if(OasisConstants.DEBUG){
			//System.out.println("moteID"+moteID);
			//System.out.println("pre recv_seqNo"+HighestSeqNo[moteID]);
			//System.out.println("recv_seqNo"+recv_seqNo);

		}
		if (HighestSeqNo[moteID] == -1) {
			HighestSeqNo[moteID] = recv_seqNo;
			return OasisConstants.NORM;   //normal pkt;
		}

		diff = recv_seqNo - HighestSeqNo[moteID];
		if (diff > 1) {
			type = OasisConstants.MISS;  //pkt after a missing gap
			//HighestSeqNo[moteID] = recv_seqNo;
		} else {
			if (diff < 1) {
				type = OasisConstants.DUP; //duplicated pkt
			} else {
				type = OasisConstants.NORM;
				//HighestSeqNo[moteID] = recv_seqNo;
			}
		}

		return type;
	}


	public String getRawData(String typeName, Vector streamEvent) {


		String data = typeName + ": ";
		Iterator it = streamEvent.iterator();
		//System.out.println("streamEvent: "+streamEvent.size()+" "+it.hasNext());


		int count = 0;
		if(typeName.equalsIgnoreCase("rawdata")){
			while(it.hasNext()){
				data+=" "+it.next();

			}

		}
		else{
			while (it.hasNext()) {
				//System.out.println("ss ");
				StreamDataObject curS = (StreamDataObject) it.next();
				data += curS.name + " " + curS.data.size() + "\n";
				//System.out.print(((count++) % streamEvent.size()) + " name: " + curS.name + " size: " + curS.data.size() + " value: ");
				Iterator resIt = curS.data.iterator();
				while (resIt.hasNext()) {
					// System.out.print((Integer) resIt.next() + " ");
					data += ((Integer) resIt.next() + " ");
				}
				// System.out.println();
			}
		}


		data += "\n";


		return (data);
	}

	/**YFH: Refer to Message.java
	 * Read the length bit unsigned little-endian int at offset
	 * @param offset bit offset where the unsigned int starts
	 * @param length bit length of the unsigned int
	 * @exception ArrayIndexOutOfBoundsException for invalid offset, length
	 */



}

