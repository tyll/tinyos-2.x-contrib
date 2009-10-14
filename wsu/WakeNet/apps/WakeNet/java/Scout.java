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


import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;
import java.util.Date;

/*
	This class is a thread which is listening data coming
	from the serial port and updating the database.
	TODO :
*/

class Scout implements Runnable, MessageListener {
	private MoteIF gateway;
	private MoteDatabase moteDatabase;
	private Date date;
	private ConsolePanel consolePanel;
	private MapPanel mapPanel;
	private RequestPanel requestPanel;
	private Logger logger;
	private ChartPanel chartPanel;
	private OctopusSentMsg sMsg;
	private MsgSender sender;

	public Scout(MoteIF gateway, MoteDatabase moteDatabase, ConsolePanel consolePanel,
		MapPanel mapPanel, RequestPanel requestPanel,
		Logger logger, ChartPanel chartPanel, MsgSender sender) {
		this.gateway = gateway;
		this.moteDatabase = moteDatabase;
		this.consolePanel = consolePanel;
		this.mapPanel = mapPanel;
		this.requestPanel = requestPanel;
		this.logger = logger;
		this.chartPanel = chartPanel;
		this.sender = sender;
		sMsg = new OctopusSentMsg();
	}

	/*
		The thread just does a loop, sleeping and incrementing
		a counter with a frequency of 10 Hz (100 ms). The max
		values of the counters are defined to choose the frequency
		of repainting the mapPanel and chartPanel;
	*/

	public void run() {
		gateway.registerListener(new OctopusCollectedMsg(), this);
		int mapPanelCounter = 0;
		int chartPanelCounter = 0;
		while(true) {
			try {
				Thread.sleep(Util.SCOUT_SLEEP_PERIOD);
			} catch (Exception e) { e.printStackTrace();}
			mapPanelCounter++;
			if (mapPanelCounter>=10) {		// 1 sec
				mapPanel.repaint();
				mapPanelCounter=0;
			}
			chartPanelCounter++;
			if (chartPanelCounter>=100) {	// 10 secs
				chartPanel.repaint();
				chartPanelCounter=0;
			}
		}
    }

	/*
		This function waits until the mutex is free,
		to update the database.
	*/

	public void waitMutex() {
		try {
			while(!moteDatabase.getMutex())
				Thread.sleep(Util.MUTEX_WAIT_TIME_MS);
		} catch(Exception e) { e.printStackTrace();}
	}

	/*
		This function is called by Java when a message is received
		through the serial port.
	*/

	public void messageReceived(int dest_addr, Message msg) {
	
		if (msg instanceof OctopusCollectedMsg) {
			OctopusCollectedMsg collectedMsg = (OctopusCollectedMsg)msg;
			short reply = collectedMsg.get_reply();
			Mote localMote;
			localMote = moteDatabase.getMote(collectedMsg.get_moteId());
			// If the message is an automatic message
			waitMutex();
			//System.out.println("reply: "+collectedMsg.get_reply());
			if ((reply & Constants.REPLY_MASK) == Constants.NO_REPLY) {
				//consolePanel.append("Automatic Msg From Id=" + collectedMsg.get_moteId() + " [reading = " + collectedMsg.get_reading() + "]", Util.MSG_MESSAGE_RECEIVED);
					consolePanel.append(collectedMsg.toString(), Util.MSG_MESSAGE_RECEIVED);
				if(localMote != null) { 	// if the mote is in the database
					// we update the database
					localMote.setCount(collectedMsg.get_count());
					//xg 20090413 set different type data
					localMote.setActive(true);
					localMote.set_reading(collectedMsg.get_reading());
					//System.out.println(collectedMsg);
					/*if(reply == Constants.READING_TEMPERATURE)localMote.set_readTemperature(collectedMsg.get_reading());
					if(reply == Constants.READING_HUMIDITY)localMote.set_readHumidity(collectedMsg.get_reading());
					if(reply == Constants.READING_ACC)localMote.set_readAcc(collectedMsg.get_reading());
					if(reply == Constants.READING_LIGHT)localMote.set_readLight(collectedMsg.get_reading());
					if(reply == Constants.READING_DEFAULT)localMote.set_readDemo(collectedMsg.get_reading());
					if(reply == Constants.READING_ADC)localMote.set_readAdc(collectedMsg.get_reading());
					*/
					localMote.set_reading(reply,collectedMsg.get_reading());
		
					localMote.setParentId(collectedMsg.get_parentId());
					localMote.setQuality(collectedMsg.get_quality());
					date = new Date();
					localMote.setLastTimeSeen(date.getTime());
					logger.addRecord(localMote);
					//chartPanel.addRecord(localMote);
					//xg
					chartPanel.addRecord(localMote,reply);
					
				} else {					// if the mote is not in the database
					// we add the mote
					date = new Date();
					moteDatabase.addMote(new Mote(	collectedMsg.get_moteId(),
													collectedMsg.get_count(),
													collectedMsg.get_reading(),
													reply,
													collectedMsg.get_parentId(),
													collectedMsg.get_quality(),
													date.getTime()),sender);
					localMote = moteDatabase.getMote(collectedMsg.get_moteId());
					localMote.setActive(true);
					if (localMote != null) {
						logger.addRecord(localMote);
						chartPanel.addRecord(localMote,reply);
					}
					// and we eventually get its status // code to put in a function called also by a button
					if (Util.ASK_STATUS_OF_NEW_MOTE) {/*
						sender.add(collectedMsg.get_moteId(), (int)Constants.GET_SLEEP_DUTY_CYCLE_REQUEST,
							0, "Get SleepDutyCycle of new mote [Id="+collectedMsg.get_moteId()+"]");
						sender.add(collectedMsg.get_moteId(), (int)Constants.GET_AWAKE_DUTY_CYCLE_REQUEST,
							0, "Get SleepDutyCycle of new mote [Id="+collectedMsg.get_moteId()+"]");
						sender.add(collectedMsg.get_moteId(), (int)Constants.GET_THRESHOLD_REQUEST,
							0, "Get SleepDutyCycle of new mote[Id="+collectedMsg.get_moteId()+"]");
						sender.add(collectedMsg.get_moteId(), (int)Constants.GET_PERIOD_REQUEST,
							0, "Get SleepDutyCycle of new mote[Id="+collectedMsg.get_moteId()+"]");
						sender.add(collectedMsg.get_moteId(), (int)Constants.GET_STATUS_REQUEST,
							0, "Get Status of new mote[Id="+collectedMsg.get_moteId()+"]");*/
					}
				}
			// else if it's a reply
			} else {
				if(localMote == null) 		// if the mote is NOT in the database
					consolePanel.append("Reply from unknown mote id=" + collectedMsg.get_moteId(), Util.MSG_MESSAGE_RECEIVED);
				else {
					consolePanel.append("Reply from mote id=" + collectedMsg.get_moteId(), Util.MSG_MESSAGE_RECEIVED);
					localMote.setParentId(collectedMsg.get_parentId()); // to change (stack feature)
					localMote.setQuality(collectedMsg.get_quality());
					localMote.setLastTimeSeen(date.getTime());
					switch (reply & Constants.REPLY_MASK) {
						case (Constants.BATTERY_AND_MODE_REPLY):
							localMote.setBattery(collectedMsg.get_reading()[0]);
							if((reply & Constants.MODE_MASK) == Constants.MODE_AUTO) {
								localMote.setModeAuto();
							} else {
								localMote.setModeQuery();
							}
							if((reply & Constants.SLEEP_MASK) == Constants.SLEEPING) {
								localMote.setSleeping();
							} else {
								localMote.setAwake();
							}
							break;
						case (Constants.PERIOD_REPLY):
							localMote.setSamplingPeriod(collectedMsg.get_reading()[0]);
							break;
						case (Constants.THRESHOLD_REPLY):
							localMote.setThreshold(collectedMsg.get_reading()[0]);
							break;
						case (Constants.SLEEP_DUTY_CYCLE_REPLY):
							localMote.setSleepDutyCycle(collectedMsg.get_reading()[0]);
							break;
						case (Constants.AWAKE_DUTY_CYCLE_REPLY):
							localMote.setAwakeDutyCycle(collectedMsg.get_reading()[0]);
							break;
					}
				}
			}
			moteDatabase.releaseMutex();
			requestPanel.moteUpdatedEvent(localMote);
		}
	}
}
