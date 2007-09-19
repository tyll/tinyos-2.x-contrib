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
import javax.swing.event.*;
import java.awt.*;
import java.awt.geom.*;
import java.awt.event.*;
import java.util.LinkedList;
import java.util.Iterator;
import java.util.Date;
import java.io.*;

/*
	This class is used to display the reading value
	of the motes.
	birth is the date of the oldest ReadingRecordList
	moteRecordList is a LinkedList of ReadingRecordList Objects
	of the motes that are displayed on the chart.
	Each time a mote adds a record, the function paintUpdate()
	is called and the graph is completed. The function paint() is
	only called by Java when the frame needs to be redrawn.
	
	TODO :
			add text feature (moteid)
	BUG :
*/
class ChartPanel extends JPanel {
	private LinkedList moteRecordList;
	private int currentTime=0;				// to change
	private final static int VIRTUAL_0_X = 50;
	private final static int VIRTUAL_0_Y = 30;
	private Date birth;
	private int timeScale;
	
	private static Color [] colorArray;
	
	public ChartPanel() {
		moteRecordList = new LinkedList();
		birth = new Date();
		timeScale = 100;// the time duration in seconds showed on the graph
		colorArray = new Color[10];
		colorArray[0] = Color.black;
		colorArray[1] = Color.red;
		colorArray[2] = Color.blue;
		colorArray[3] = Color.yellow;
		colorArray[4] = Color.pink;
		colorArray[5] = Color.green;
		colorArray[6] = Color.blue;
		colorArray[7] = Color.red;
		colorArray[8] = Color.black;
		colorArray[9] = Color.yellow;
	}

	/*
		This function is called when just an update is needed
		to avoid use a lot of CPU cycles.
	*/
	
	public void paintUpdate() {
		if (isShowing()) {
			Graphics2D g2 = (Graphics2D) this.getGraphics();
			ReadingRecordList readingRecordList;
			for (Iterator it=moteRecordList.listIterator(0); it.hasNext(); ) {
				readingRecordList = (ReadingRecordList)it.next();
				drawEndLine(readingRecordList, g2);
			}
		}
	}
	
	/*
		This function is called either by Java, when the frame
		needs to be repainted, or by a thread when new data is
		received and needs to be added
	*/
	
	public void paint(Graphics g) {
		Graphics2D g2 = (Graphics2D) g;
		// we draw first a white area
		Dimension d = getSize();
		g2.setPaint(Color.white);
		g2.fill(new Rectangle2D.Double(0, 0, d.width, d.height));
		// next we draw the lines for the coordinates
		g2.setPaint(Color.black);
		BasicStroke stroke = new BasicStroke(2.0f);
		g2.setStroke(stroke);
		g2.draw(new Line2D.Double(VIRTUAL_0_X-10, d.height-VIRTUAL_0_Y, d.width-10, d.height-VIRTUAL_0_Y));
		g2.draw(new Line2D.Double(d.width-10, d.height-VIRTUAL_0_Y, d.width-10-5, d.height-VIRTUAL_0_Y-5)); // arrow
		g2.draw(new Line2D.Double(d.width-10, d.height-VIRTUAL_0_Y, d.width-10-5, d.height-VIRTUAL_0_Y+5)); // arrow
		g2.draw(new Line2D.Double(VIRTUAL_0_X, d.height-VIRTUAL_0_Y+10, VIRTUAL_0_X, 10));
		g2.draw(new Line2D.Double(VIRTUAL_0_X, 10, VIRTUAL_0_X-3, 10+5)); // arrow
		g2.draw(new Line2D.Double(VIRTUAL_0_X, 10, VIRTUAL_0_X+3, 10+5)); // arrow
		// ... and the ticks on the Y line
		for (int i=0; i<65535; i+=2000) {
			if (i%2000==0)
				g2.draw(new Line2D.Double(VIRTUAL_0_X-2, toVirtualY(i), VIRTUAL_0_X+2, toVirtualY(i)));
			if (i%10000==0) {
				g2.draw(new Line2D.Double(VIRTUAL_0_X-5, toVirtualY(i), VIRTUAL_0_X+5, toVirtualY(i)));
				g2.drawString(""+i, 5, toVirtualY(i)+6);
			}
		}
		// ... and the ticks on the X line
		int currentTime = getCurrentTime();
		if (currentTime < 100) {
			timeScale = 100;	// 100 sec
			for (int i=0; i<timeScale; i+=10) {
				if (i%(10)==0)		// tiny tick every 10 sec.
					g2.draw(new Line2D.Double(timeToVirtualX(i), d.height-VIRTUAL_0_Y-2, 
						timeToVirtualX(i), d.height-VIRTUAL_0_Y+2));
				if (i%(60)==0) {	// medium tick plus text every minute
					g2.draw(new Line2D.Double(timeToVirtualX(i), d.height-VIRTUAL_0_Y-2, 
						timeToVirtualX(i), d.height-VIRTUAL_0_Y+2));
					g2.drawString(""+i, timeToVirtualX(i), d.height-VIRTUAL_0_Y+25);
				}
			}
		} else if (currentTime < 1200) {
			timeScale = 1200; // 20 min
			for (int i=0; i<timeScale; i+=60) {
				if (i%(60)==0)		// tiny tick every minute
					g2.draw(new Line2D.Double(timeToVirtualX(i), d.height-VIRTUAL_0_Y-2, 
						timeToVirtualX(i), d.height-VIRTUAL_0_Y+2));
				if (i%(300)==0) {	// medium tick plus text every 5 min.
					g2.draw(new Line2D.Double(timeToVirtualX(i), d.height-VIRTUAL_0_Y-2, 
						timeToVirtualX(i), d.height-VIRTUAL_0_Y+2));
					g2.drawString(""+(i/60), timeToVirtualX(i), d.height-VIRTUAL_0_Y+25);
				}
			}
		} else {
			timeScale = 7200; // 2h
			for (int i=0; i<timeScale; i+=300) {
				if (i%(300)==0)		// tiny tick every 5 min.
					g2.draw(new Line2D.Double(timeToVirtualX(i), d.height-VIRTUAL_0_Y-2, 
						timeToVirtualX(i), d.height-VIRTUAL_0_Y+2));
				if (i%(1800)==0) {	// medium tick plus text every 30 min.
					g2.draw(new Line2D.Double(timeToVirtualX(i), d.height-VIRTUAL_0_Y-2, 
						timeToVirtualX(i), d.height-VIRTUAL_0_Y+2));
					g2.drawString(""+(i/300), timeToVirtualX(i), d.height-VIRTUAL_0_Y+25);
				}
			}
		}
		// ... and the mote values
		ReadingRecordList readingRecordList;
		for (Iterator it=moteRecordList.listIterator(0); it.hasNext(); ) {
			readingRecordList = (ReadingRecordList)it.next();
			drawLine(readingRecordList, g2);
		}
		// ... and the labels "time" and "reading"
		g2.setPaint(Color.blue);
		g2.drawString("Time (in s)", d.width-80, d.height-10);
		g2.drawString("Sensor", 5, 20);
		g2.drawString("Value", 5, 30);
	}
	
	/*
		Functions used to translate a sensor value in
		virtual value that can be displayed on the screen.
		Real		Virtual X		Virtual Y
		====		=========		=========
		0			VIRTUAL_0_X		d.heigth-VIRTUAL_0_Y
		65535						20
		timeScale	d.width-20
	*/
	
	public int timeToVirtualX(int x) {
		Dimension d = getSize();
		return (d.width-20-VIRTUAL_0_X)*x/timeScale + VIRTUAL_0_X;
	}
	
	public int toVirtualY(int y) {
		Dimension d = getSize();
		return d.height - (d.height-20-VIRTUAL_0_Y)*y/65535-VIRTUAL_0_Y;
	}
	
	/*
		This function draws a line using a ReadingRecordList 
		to get data.
	*/
	
	private synchronized void drawLine(ReadingRecordList list, Graphics2D g2) {
		g2.setPaint(colorArray[list.mote.getMoteId()%10]);
		BasicStroke stroke = new BasicStroke(2.0f);
		g2.setStroke(stroke);
		ReadingRecord record;
		int x, y;
		if (list.size() == 0)
			return;
		int old_x = timeToVirtualX(((ReadingRecord)list.getFirst()).time);
		int old_y = toVirtualY(((ReadingRecord)list.getFirst()).reading);
		for (Iterator it=list.listIterator(1); it.hasNext(); ) {
			try {
				record = (ReadingRecord)it.next();
				x = timeToVirtualX(record.time);
				y = toVirtualY(record.reading);
				g2.draw(new Line2D.Double( old_x, old_y, x, y));
				old_x = x; old_y = y;
			} catch (Exception e) { e.printStackTrace();}
		}
	}
	
	/*
		This function draws the end of a line using a 
		ReadingRecordList to get data.
	*/
	
	private synchronized void drawEndLine(ReadingRecordList list, Graphics2D g2) {
		g2.setPaint(colorArray[list.mote.getMoteId()%10]);
		BasicStroke stroke = new BasicStroke(2.0f);
		g2.setStroke(stroke);
		ReadingRecord record;
		if (list.size()<2)
			return;
		int old_x = timeToVirtualX(((ReadingRecord)list.get(list.size()-2)).time);
		int old_y = toVirtualY(((ReadingRecord)list.get(list.size()-2)).reading);
		int x = timeToVirtualX(((ReadingRecord)list.getLast()).time);
		int y = toVirtualY(((ReadingRecord)list.getLast()).reading);
		g2.draw(new Line2D.Double( old_x, old_y, x, y));
	}
	
	/*
		This function gets the biggest time between the moment when
		the application was started and the last reading received, for
		each mote. The value returned is in seconds.
	*/
	
	public synchronized int getCurrentTime() {
		ReadingRecordList readingRecordList;
		long biggestTime = 0;
		for (Iterator it=moteRecordList.listIterator(0); it.hasNext(); ) {
			readingRecordList = (ReadingRecordList)it.next();
			if (readingRecordList.mote.getLastTimeSeen() - birth.getTime() > biggestTime)
				biggestTime = readingRecordList.mote.getLastTimeSeen() - birth.getTime();
		}
		return (int)(biggestTime/1000);
	}
	
	/*
		This function adds a new record.
		The function runs through a linked list of every record, 
		If the mote is the one to update, then a new ReadingRecord is added.
	*/
	
	public synchronized void addRecord(Mote mote) {
		ReadingRecordList readingRecordList;
		for (Iterator it=moteRecordList.listIterator(0); it.hasNext(); ) {	// we run through the linked list
			readingRecordList = (ReadingRecordList)it.next();
			if (readingRecordList.getMoteId() == mote.getMoteId()) {	// if the mote is selected and exists yet
				readingRecordList.addRecord();
				break;
			}
		}
		paintUpdate();
	}
	
	public synchronized void addMote(Mote mote) {
		if (mote!=null)
			if (!moteIsSelected(mote)) {
				if (moteRecordList.size()==0)
					birth = new Date();
				int currentTime = getCurrentTime();
				moteRecordList.add(new ReadingRecordList(mote, currentTime));
			}
		paintUpdate();
	}
	
	public synchronized void deleteMote(Mote mote) {
		ReadingRecordList readingRecordList;
		if (mote!=null) {
			for (Iterator it=moteRecordList.listIterator(0); it.hasNext(); ) {
				readingRecordList = (ReadingRecordList)it.next();
				if (mote.getMoteId() == readingRecordList.getMoteId())
					it.remove();
			}
		}
		repaint();
	}
	
	public synchronized void deleteMotes() {
		moteRecordList.clear();
		repaint();
	}
	
	public synchronized boolean moteIsSelected(Mote mote) {
		ReadingRecordList readingRecordList;
		if (mote!=null) {
			for (Iterator it=moteRecordList.listIterator(0); it.hasNext(); ) {
				readingRecordList = (ReadingRecordList)it.next();
				if (mote.getMoteId() == readingRecordList.getMoteId())
					return true;
			}
		}
		return false;
	}
}


