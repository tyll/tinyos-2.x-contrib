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


import java.util.LinkedList;
import java.util.Iterator;
import java.util.Date;

/*
	This class is a list that is dynamically created
	and records on the fly the data.
	The time is recorded in seconds !
	
	TODO :
			add the trim feature
*/

public class ReadingRecordList extends LinkedList{
	public Mote mote; 
	private Date birth;
	private int deltaTime;
	
	public ReadingRecordList(Mote mote, int deltaTime) {
		this.mote = mote;
		birth = new Date();
		this.deltaTime = deltaTime;
	}
	
	public int getMoteId() { return mote.getMoteId();}
	public void addRecord() {
		add(new ReadingRecord((int)(mote.getLastTimeSeen()-birth.getTime())/1000+deltaTime, mote.getReading()));
	}
}

class ReadingRecord {
	public int time;
	public int reading;
	
	public ReadingRecord(int time, int reading) {
		this.time = time;
		this.reading = reading;
	}
}