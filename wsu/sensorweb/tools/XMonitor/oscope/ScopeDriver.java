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
 * This class serves as the interface between the MoteIF and the GraphPanel.  
 *
 * Original version by:
 *    @author moteiv.com
 * Modified by:
 *    @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */
package oscope;

import Config.OasisConstants;
import SensorwebObject.Rpc.Util;
import java.awt.geom.Point2D;
import java.io.*;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;
import monitor.DisplayManager;
import monitor.MainFrame;
import rpc.message.*;
import xml.RemoteObject.StreamDataObject;

public class ScopeDriver implements MessageListener {

	public MoteIF mote;
	public GraphPanel panel;
	private ControlPanel ctrPanel;
	private static final boolean VERBOSE = false;
	public static boolean firstMessage = false;
	public short[] reading;
	private double x_lookupValueHead;
	private double x_lookupValueTail;
	private double y_lookupValueMax;
	private double y_lookupValueMin;
	private Hashtable moteIDList;
	private int NoOfMote = 0;
	private ExpiredDataTimer expiredDataTimer;

	//init refreshcount for refreshscreen control
	int refreshcount = 0;
	// We store different scope channels in a hashtable that's indexed by the
	// legend string.     
	Hashtable t = new Hashtable();
	public static long startTime;

	public ScopeDriver(MoteIF _mote, GraphPanel _panel) {
		mote = _mote;
		panel = _panel;
		panel.setXLabel("[ Y = Sensor Value ]     v.s.   [ X = Time (ms) ]");
		x_lookupValueHead = -1.0e8;
		x_lookupValueTail = 1.0e8;
		y_lookupValueMax = -1.0e8;
		y_lookupValueMin = 1.0e8;
		moteIDList = new Hashtable();
		//mote.registerListener(new Message(), this);
		mote.registerListener("general", this);


		startTime = System.currentTimeMillis();
		reading = new short[OasisConstants.MAX_SIZE_READING];
		expiredDataTimer = new ExpiredDataTimer(this);
		expiredDataTimer.start();
	}

	/**
	 * This is the handler invoked when a  msg is received.
	 */


	public void messageReceived(String typeName, Vector streamEvent) {
		int moteID = new Integer((Integer) (((StreamDataObject) streamEvent.get(0)).data.get(0)));
		int type = new Integer((Integer) (((StreamDataObject) streamEvent.get(2)).data.get(0)));
		long timestamp = new Integer((Integer) (((StreamDataObject) streamEvent.get(4)).data.get(0)));
		int size = ((Integer) (((StreamDataObject) streamEvent.get(5)).data.size()));
		int[] receivedData = new int[size];
		int tmp=0;
		for (int i = 0; i < size; i++) {
			tmp =  ((Integer) (((StreamDataObject) streamEvent.get(5)).data.get(i))).intValue();
			receivedData[i] = (int) (tmp);
			//System.out.print(receivedData[i] +" ");
		}
		dataReceived(moteID, type, timestamp, receivedData, 0, size);
	}

	/**
	 * Message handler for data messages. 
	 */


	public void dataReceived(int moteID, int type, long timestamp, int[] receivedData, int start, int end) {
		boolean foundPlot = false;
		boolean messageAccepted = false;
		int packetNum;
		long startTimeCalculation;
		double pointX = 0.0, delta_X, interval = 0.0;
		Channel channel;
		double data = 0.0;
		int tt;
		int noDataSample = 0;
		double averageData = 0.0;
		double maxData = 0.0;
		boolean nodeExist = false;


		//avoid crash msg

		Integer currentType = (Integer) Channel.availableType.get(new Integer(type));
		if (currentType == null) {
			Channel.availableType.put(new Integer(type), new Integer(type));
		}


		channel = findChannel(moteID);
		channel.addNewDataChannel(type);

		//get data string
		int[] msgdata = receivedData;
		//startTimeCalculation = (long)Util.startTimeCalculation(msgdata, start, 4);
		startTimeCalculation = (long)Util.startTimeCalculation(timestamp);
		//System.out.println("startTimeCalculation " + startTimeCalculation);
		interval = (double) Util.sInterval;
		String realTime = Util.sMinute + ":" + Util.sSecond + ":" + Util.sMilisecond;
		//if (type == 0 && moteID ==10)
			//System.out.println(realTime);
		//Start Log to database
		//End Log to database

		if (!channel.isTypeActive(type)) {

			return;
		}
		if (ControlPanel.TIMETYPE == OasisConstants.RTC_TIME) {
			//throw out the data that is outdated
			if (channel.getstartTimeCalculation(type) > startTimeCalculation) {
				if (startTimeCalculation <= 5000.0 && channel.getstartTimeCalculation(type) >= 3500000.0) {
					channel.setstartTimeCalculation(startTimeCalculation, type);
				} else {
					return;
				}
			} else {
				channel.setstartTimeCalculation(startTimeCalculation, type);
			}
			//caculate the position of time
			pointX = startTimeCalculation;
			//System.out.println("pointX: "+pointX);
			delta_X = interval;
			for (tt = start; tt <= end - 1; tt++) {
				noDataSample++;
				//data = (double) Util.mBytes2Value(msgdata, tt, 2, 'H');
				data = msgdata[tt];
				if (maxData < data) {
					maxData = data;
				}
				averageData += data;
				if (tt == start) {
					//Reset Y-xle:
					panel.customize_Y(data);
				}
				//pointX+=delta_X;
				Point2D newPoint = new Point2D.Double(pointX, data);
				// System.err.println(delta_X+" "+newPoint.toString());
				pointX += delta_X;
				if (pointX <= channel.getXLookupValue(type)) {
					if (pointX <= 5000.0 && channel.getXLookupValue(type) >= 3500000.0) {
						channel.setXLookupValue(pointX, type);
					} else {
						continue;
					}
				}
				//after generate the point, add it into the channel
				channel.addPoint(newPoint, type);
				//constrict the range of y , signal
				if (data < y_lookupValueMin) {
					y_lookupValueMin = data;
				}
				if (data > y_lookupValueMax) {
					y_lookupValueMax = data;
				}
				messageAccepted = true;
			}
			averageData = averageData / noDataSample;
		}

		if (ControlPanel.TIMETYPE == OasisConstants.PC_TIME) {

			/*
				 if (channel.getstartTimeCalculation(type) > startTimeCalculation) {
				 return;
				 }
				 */
			if (channel.getPCFirstMessage(type)) {
				pointX = System.currentTimeMillis() - startTime;
				channel.setstartTimeCalculation(startTimeCalculation, type);
				channel.setPCFirstMessage(false, type);
				channel.setStartPCTime((long) pointX, type);
			} else {
				//pointX = channel.getStartPCTime(type) + (startTimeCalculation - channel.getstartTimeCalculation(type));
				pointX = System.currentTimeMillis() - startTime;
			}
			//System.out.println("pointX: "+pointX);
			delta_X = interval;
			for (tt = start; tt <= end - 1; tt++) {
				noDataSample++;
				//data = (double) Util.mBytes2Value(msgdata, tt, 2, 'H');
				data = msgdata[tt];
				if (maxData < data) {
					maxData = data;
				}
				averageData += data;
				if (tt == start) {
					//Reset Y-xle:
					panel.customize_Y(data);
				}

				//pointX+=delta_X;
				Point2D newPoint = new Point2D.Double(pointX, data);
				//System.err.println(type+" "+delta_X+" "+newPoint.toString());

				pointX += delta_X;

				if (pointX < channel.getXLookupValue(type)) {
					continue;
				}


				channel.addPoint(newPoint, type);
				//System.out.println("add new Point"+pointX+" at type: "+type);
				if (data < y_lookupValueMin) {
					y_lookupValueMin = data;
				}
				if (data > y_lookupValueMax) {
					y_lookupValueMax = data;
				}
				messageAccepted = true;
			}
			averageData = averageData / noDataSample;
		}

		//System.out.println(averageData + " " + noDataSample);
		Enumeration enm = DisplayManager.colorTable.keys();
		while (enm.hasMoreElements()) {
			Integer moteNo = (Integer) enm.nextElement();
			if (moteNo.intValue() == moteID) {
				DisplayManager.colorTable.remove(moteNo);
				DisplayManager.colorTable.put(new Integer(moteID), new Double(averageData));
				//DisplayManager.colorTable.put(new Integer(moteID),new Double(maxData));
				nodeExist = true;
				break;
			}
		}

		if (!nodeExist) {
			DisplayManager.colorTable.put(new Integer(moteID), new Double(maxData));
		}
		//if time beyond the channel time range, reset it

		if (pointX > channel.getXLookupValue(type)) {
			channel.setXLookupValue(pointX, type);
		}

		if (messageAccepted && moteIDList.get(new Integer(moteID)) == null) {
			moteIDList.put(new Integer(moteID), new Integer(1));
		}


		if (firstMessage) {
			//System.out.println("ScopeDriver");
			Enumeration k = t.keys();
			//calculateLookupValue();

			panel.reset(x_lookupValueTail, x_lookupValueHead, y_lookupValueMin, y_lookupValueMax);
			firstMessage = false;
			NoOfMote = 0;
		}
		//repaint frequency
		refreshcount++;
		if (refreshcount == OasisConstants.OSCOPE_REFRESH_RATE) {
			refreshcount = 0;
			panel.repaint();  //repaint once for each packet
		}
		//force repaint
		if (MainFrame.forceResetPanel) {
			MainFrame.forceResetPanel = false;
			this.calculateLookupValue();
			//System.out.println(this.getX_lookupValueTail()+" "+this.getX_lookupValueHead()+" "+this.getY_lookupValueMin()+" "+this.getY_lookupValueMax());
			panel.reset(this.getX_lookupValueTail(), this.getX_lookupValueHead(), this.getY_lookupValueMin(), this.getY_lookupValueMax());
			panel.repaint();
		}
		//
		if (MainFrame.firstSwitch) {
			if (ctrPanel != null) {
				MainFrame.firstSwitch = false;
			}
			ctrPanel.predefineLegendEdit();
		}



	}

	public void insertValueToDatabase(long timestamp, double value, int type, int moteID, String realTime) {
		//ADOConnection.insertValueToDatabase(timestamp, value, type, moteID, realTime);
	}

	/**************************************Andy for database*************************************
	//Change X-xle to base on time (millisecond)
	public double adjustPointX()
	{
	//8/1/2007 YFH: temp adjust
	double adjust = 10.0;
	double delta_X = 0.0;
	switch (ControlPanel.TYPE) {
	case OasisConstants.TYPE_DATA_SEISMIC:
	delta_X = 1.0*OasisConstants.SEISMIC_DATA_RATE/adjust;
	break;
	case OasisConstants.TYPE_DATA_INFRASONIC:
	delta_X = 1.0*OasisConstants.INFRASONIC_DATA_RATE/adjust;
	break;
	case OasisConstants.TYPE_DATA_LIGHTNING:
	delta_X = 1.0*OasisConstants.LIGHTNING_DATA_RATE/adjust;
	break;
	case OasisConstants.TYPE_DATA_GPS:
	delta_X = 1.0*OasisConstants.GPS_DATA_RATE/adjust;
	break;
	}
	return delta_X;
	}


	private void logTimeDataToDatabase(int type,int hour, int minute, int second, int milisecond, int sequenceNo)
	{

	switch (type) {
	case OasisConstants.TYPE_DATA_SEISMIC:
	ADOConnection.insertSeismicRTC(hour,minute,second,milisecond,sequenceNo);
	break;
	case OasisConstants.TYPE_DATA_INFRASONIC:
	ADOConnection.insertInfrasonicRTC(hour,minute,second,milisecond,sequenceNo);
	break;
	case OasisConstants.TYPE_DATA_LIGHTNING:
	ADOConnection.insertLightningRTC(hour,minute,second,milisecond,sequenceNo);
	break;
	case OasisConstants.TYPE_DATA_GPS:
	ADOConnection.insertGPSRTC(hour,minute,second,milisecond);
	break;
	}
	}


	private void logSensingDataToDatabase(int type,Message msg,NetworkMsg m ,ApplicationMsg AMsg)
	{
	int moteID = m.get_source();

	//get data string
	byte [] msgdata = msg.dataGet();
	int start = m.offset_data(0)+AMsg.offset_data(0);
	int end = msg.dataLength();
	int tt;
	String data = "";

	for (tt=start; tt<=end-1; tt=tt+2) {
	data += "" + (double)com.oasis.rpc.Util.mBytes2Value(msgdata, tt, 2, 'H');
	}

	switch (type) {
	case OasisConstants.TYPE_DATA_SEISMIC:
	ADOConnection.insertSeismic(moteID, data);
	break;
	case OasisConstants.TYPE_DATA_INFRASONIC:
	ADOConnection.insertInfrasonic(moteID, data);
	break;
	case OasisConstants.TYPE_DATA_LIGHTNING:
	ADOConnection.insertLightning(moteID, data);
	break;
	case OasisConstants.TYPE_DATA_GPS:
	ADOConnection.insertGPS(moteID, data);
	break;
	}
	}


private void logDataToDatabaseAccordingToSequence(int type,int sequenceNo, int data)
{

	switch (type) {
		case OasisConstants.TYPE_DATA_SEISMIC:
			ADOConnection.insertSeismic(sequenceNo, data);
			break;
		case OasisConstants.TYPE_DATA_INFRASONIC:
			ADOConnection.insertInfrasonic(sequenceNo, data);
			break;
		case OasisConstants.TYPE_DATA_LIGHTNING:
			ADOConnection.insertLightning(sequenceNo, data);
			break;
		case OasisConstants.TYPE_DATA_GPS:
			ADOConnection.insertGPS(sequenceNo, data);
			break;
	}
}
*/
/**************************************Andy for database******************************************/
public void setControlPanel(ControlPanel ctrPanel) {
	this.ctrPanel = ctrPanel;
}

/**
 * Derive the canonical legend string based on the mote ID and channel
 * ID.  The legend string also used as a key to look up the channel. 
 */
public String makeLegendString(int moteID) {
	return "Mote " + moteID;
}

/**
 * Recover the channel based on the mote ID and channel ID.
 */
public Channel findChannel(int moteID) {
	boolean foundPlot = false;
	int i;
	String legend = makeLegendString(moteID);
	Channel c = (Channel) t.get(legend);
	if (c == null) {
		//System.out.println("Creating Channel for "+legend);
		c = new Channel();
		c.setGraphPanel(panel);
		c.setDataLegend(legend);
		c.setActive(true);
		if (panel.getNumChannels() == 0) {
			c.setMaster(true);
		}
		t.put(legend, c);
		panel.addChannel(c);
	}
	return c;
}

/**YFH: Refer to Message.java
 * Read the length bit unsigned little-endian int at offset
 * @param offset bit offset where the unsigned int starts
 * @param length bit length of the unsigned int
 * @exception ArrayIndexOutOfBoundsException for invalid offset, length
 */

// Currently non-functional b/c of switch to 2D point data
void load_data() {
	/*JFileChooser	file_chooser = new JFileChooser();
		File		loadedFile;
		FileReader	dataIn;
		String		lineIn;
		int		retval,chanNum,numSamples;
		boolean		keepReading;

		retval = file_chooser.showOpenDialog(null);
		if( retval == JFileChooser.APPROVE_OPTION ) {
		try {
		loadedFile = file_chooser.getSelectedFile();
		System.out.println( "Opened file: "+loadedFile.getName() );
		dataIn = new FileReader( loadedFile );
		keepReading = true;
		chanNum = numSamples = -1;
		while( keepReading ) {
		lineIn = read_line( dataIn );
		if( lineIn == null )
		keepReading = false;
		else if( !lineIn.startsWith( "#" ) ) {
		if( chanNum == -1 ) {
		try {
		chanNum = Integer.parseInt( lineIn.substring(0,lineIn.indexOf(" ")) );
		numSamples = Integer.parseInt( lineIn.substring(lineIn.indexOf(" ")+1,lineIn.length()) );
		data[chanNum] = new Vector2();
		System.out.println( ""+chanNum+" "+numSamples+"\n" );
		} catch (NumberFormatException e) {
		System.out.println("File is invalid." );
		System.out.println(e);
		}
		} else {
		try {
		numSamples--;
		if( numSamples <= 0 )
		numSamples = chanNum = -1;
		} catch (NumberFormatException e) {
		System.out.println("File is invalid." );
		System.out.println(e);
		}
		}
		}
		}
		dataIn.close();
		} catch( IOException e ) {
		System.out.println( e );
		}
		}*/
}

String read_line(FileReader dataIn) {
	StringBuffer lineIn = new StringBuffer();
	int c, readOne;

	try {
		while (true) {
			c = dataIn.read();
			if (c == -1 || c == '\n') {
				if (lineIn.toString().length() > 0) {
					return lineIn.toString();
				} else {
					return null;
				}
			} else {
				lineIn.append((char) c);
			}
		}
	} catch (IOException e) {
	}
	return lineIn.toString();
}

public double getX_lookupValueHead() {
	return x_lookupValueHead;
}

public double getX_lookupValueTail() {
	return x_lookupValueTail;
}

public double getY_lookupValueMin() {
	return y_lookupValueMin;
}

public double getY_lookupValueMax() {
	return y_lookupValueMax;
}

public void calculateLookupValue() {
	Enumeration e = t.keys();
	double leftMostHead = 0;
	double rightMostHead = 0;
	String firstElement = "";
	while (e.hasMoreElements()) {
		firstElement = (String) e.nextElement();
		Channel firstChannel = (Channel) t.get(firstElement);
		boolean foundChannel = false;

		Enumeration k = Channel.availableType.keys();
		while (k.hasMoreElements()) {
			Integer type = (Integer) k.nextElement();
			if (firstChannel.isTypeActive(type.intValue())) {
				leftMostHead = firstChannel.getXLookupValue(type.intValue());
				rightMostHead = firstChannel.getXLookupValue(type.intValue());
				foundChannel = true;
				break;
			}
		}

		if (foundChannel) {
			break;
		}
	}

	Enumeration k = t.keys();
	while (k.hasMoreElements()) {
		String key = (String) k.nextElement();
		Channel c = (Channel) t.get(key);

		Enumeration k1 = Channel.availableType.keys();
		while (k1.hasMoreElements()) {
			Integer type = (Integer) k1.nextElement();
			if (c.isTypeActive(type.intValue())) {
				if (leftMostHead >= c.getXLookupValue(type.intValue())) {
					leftMostHead = c.getXLookupValue(type.intValue());
				}
				if (c.getXLookupValue(type.intValue()) >= rightMostHead) {
					rightMostHead = c.getXLookupValue(type.intValue());
					resetMasterChannel(key);
				}
			}
		}
	}
	x_lookupValueTail = leftMostHead;
	x_lookupValueHead = rightMostHead;
	//System.out.println("Reach Reset " + x_lookupValueHead + " " + x_lookupValueTail+" "+y_lookupValueMin+" "+y_lookupValueMax);

	if (x_lookupValueTail == x_lookupValueHead) {
		resetMasterChannel(firstElement);
	}

}

public void resetMasterChannel(String _key) {
	Enumeration k = t.keys();
	while (k.hasMoreElements()) {
		String key = (String) k.nextElement();
		Channel c = (Channel) t.get(key);
		if (key == _key) {
			c.setMaster(true);
		} else {
			c.setMaster(false);
		}
	}
}

public void resetChannel() {
	x_lookupValueHead = -1.0e8;
	x_lookupValueTail = 1.0e8;
	y_lookupValueMax = -1.0e8;
	y_lookupValueMin = 1.0e8;
	firstMessage = true;
	NoOfMote = moteIDList.size();
	moteIDList.clear();
}

public Vector resetMoteList() {
	Vector moteList = new Vector();
	moteList.add("All mote");
	Enumeration k = t.keys();
	while (k.hasMoreElements()) {
		moteList.add((String) k.nextElement());
	}
	return moteList;
}

public void resetFirstMessage() {
	Enumeration k = t.keys();
	while (k.hasMoreElements()) {
		String key = (String) k.nextElement();
		Channel c = (Channel) t.get(key);

		Enumeration k1 = Channel.availableType.keys();
		while (k1.hasMoreElements()) {
			Integer type = (Integer) k1.nextElement();
			if (c.isTypeActive(type.intValue())) {
				c.setPCFirstMessage(true, type.intValue());
				c.setStartPCTime(0, type.intValue());
				c.setXLookupValue(0, type.intValue());
			}
		}
	}
}

private class ExpiredDataTimer extends Thread {

	private Hashtable channelList = new Hashtable();
	private ScopeDriver scopeDriver;

	public ExpiredDataTimer(ScopeDriver _scopeDriver) {
		scopeDriver = _scopeDriver;
	}

	public void run() {
		/*
			 while (true){
			 try {
			 Enumeration k = t.keys();
			 while (k.hasMoreElements()) {
			 String key = (String) k.nextElement();
			 Channel channel = (Channel)t.get(key);
			 Hashtable dataChannel = channel.getDataChannel();
			 Enumeration k1 = dataChannel.keys();
			 while (k1.hasMoreElements()) {
			 Integer type = (Integer) k1.nextElement();
			 DataChannel currentChannel = (DataChannel)(dataChannel.get(type));
			 if (channelList.get(currentChannel) ==  null){
			 channelList.put(currentChannel,new Double(currentChannel.getXLookupValue()));
			 }
			 else{
			 Double tempXLookupValue = (Double)channelList.get(currentChannel);
			 if (tempXLookupValue.doubleValue()  == currentChannel.getXLookupValue()){
			 channelList.remove(currentChannel);
			 t.remove(channel.dataLegend);
			 panel.removeChannel(channel);
			 }
			 else if (tempXLookupValue.doubleValue()   != currentChannel.getXLookupValue()){
			 channelList.remove(currentChannel);
			 channelList.put(currentChannel,new Double(currentChannel.getXLookupValue()));
			 }
			 }
			 }
			 }
			 this.sleep(30000);
			 }
			 catch(Exception ex){
			 }
			 }
			 */
	}
}
}
