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


import com.csvreader.*;
import java.util.*;

/*
	This class lets the user store the data gathered by the
	network in a csv file. The filename is choosen with 
	the date.
	
	TODO :	
	BUG :
*/

public class Logger {
	private CsvWriter csvWriter;
	private boolean logging;
	private long startTime;
	private String [] record;
	private Date date;
	
	private boolean modeAutoRecorded, modeSleepingRecorded, samplingPeriodRecorded;
	private boolean thresholdRecorded, sleepDutyCycleRecorded, awakeDutyCycleRecorded;
	private boolean readingRecorded, countRecorded, qualityRecorded;
	private boolean parentIdRecorded, lastTimeSeenRecorded;
	
	private int nbFieldsRecorded;
	final static int MIN_NB_FIELDS = 3;
	
	public Logger() {
		logging = false;
		date = new Date();
		startTime = date.getTime();
		modeAutoRecorded = false;			modeSleepingRecorded = false;
		samplingPeriodRecorded = false;		thresholdRecorded = false;
		sleepDutyCycleRecorded = false;		awakeDutyCycleRecorded = false;
		readingRecorded = true;				countRecorded = false;
		qualityRecorded = false;			parentIdRecorded = false;
		lastTimeSeenRecorded = false;
	}
	
	/*
		This function starts the logging process and
		creates a file with the date, and time.
	*/
	
	public void startLogging() {
		date = new Date();
		String filename = "Octopus_Log_" + date.toString() + ".csv";
		filename = filename.replaceAll(":", "-");
		filename = filename.replaceAll(" ", "_");
		startTime = date.getTime();
		startLogging(filename);
	}
	
	/*
		This function uses a filename and creates the file
		whith the headers necessary.
	*/
	
	private void startLogging(String filename) {
		if (!logging) {
			csvWriter = new CsvWriter(filename);
			nbFieldsRecorded = MIN_NB_FIELDS;
			if (modeAutoRecorded) nbFieldsRecorded++;
			if (modeSleepingRecorded) nbFieldsRecorded++;
			if (samplingPeriodRecorded) nbFieldsRecorded++;
			if (thresholdRecorded) nbFieldsRecorded++;
			if (sleepDutyCycleRecorded) nbFieldsRecorded++;
			if (awakeDutyCycleRecorded) nbFieldsRecorded++;
			if (readingRecorded) nbFieldsRecorded++;
			if (countRecorded) nbFieldsRecorded++;
			if (qualityRecorded) nbFieldsRecorded++;
			if (parentIdRecorded) nbFieldsRecorded++;
			if (lastTimeSeenRecorded) nbFieldsRecorded++;
			
			int i = 2;
			record = new String [nbFieldsRecorded];
			record[0] = "Mote Id"; record[1] = "Time in ms"; record[i++] = "Hops";
			if (modeAutoRecorded) record[i++] = "Mode Auto(1) Or Query(0)";
			if (modeSleepingRecorded) record[i++] = "Mode Sleeping(1) Or Awake(0)";
			if (samplingPeriodRecorded) record[i++] = "Sampling Period (in ms)";
			if (thresholdRecorded) record[i++] = "Threshold"; /// in % ???
			if (sleepDutyCycleRecorded) record[i++] = "Sleep Duty Cycle";
			if (awakeDutyCycleRecorded) record[i++] = "Awake Duty Cycle";
			if (readingRecorded) record[i++] = "Reading";
			if (countRecorded) record[i++] = "Count";
			if (qualityRecorded) record[i++] = "Quality";
			if (parentIdRecorded) record[i++] = "Parent Id" ;
			if (lastTimeSeenRecorded) record[i++] = "Last Time Seen (in ms)";
			
			try {
				//csvWriter.writeComment("File used to store data gathered by Octopus");
				csvWriter.writeRecord(record);
				csvWriter.flush();
				Util.debug("Start logging in " + filename);
			} catch (Exception e) { e.printStackTrace();}
			logging = true;
		} else
			Util.debug("startLogging called without a call to stopLogging before !");
	}
	
	/*
		This function closes the file and reset the
		Logger system.
	*/
	
	public void stopLogging() {
		if (logging) {
			csvWriter.close();
			logging = false;
			Util.debug("Logging stopped");
		}
	}

	/*
		This function adds a record to the file only if
		the logging process is on.
	*/
	
	public void addRecord(Mote mote) {
		if (!logging) 
			return;
		date = new Date();
		int i;
		for (i=0;i<nbFieldsRecorded; i++)
			record[i] = "";
		i = 0;
		record[i++] = ""+mote.getMoteId(); 
		record[i++] = ""+(date.getTime()-startTime);
		record[i++] = ""+mote.getHops();
		if (modeAutoRecorded) record[i++] = "" + mote.isInModeAuto();
		if (modeSleepingRecorded) record[i++] = "" + mote.isSleeping();
		if (samplingPeriodRecorded) record[i++] = "" + mote.getSamplingPeriod();
		if (thresholdRecorded) record[i++] = "" + mote.getThreshold();
		if (sleepDutyCycleRecorded) record[i++] = "" + mote.getSleepDutyCycle();
		if (awakeDutyCycleRecorded) record[i++] = "" + mote.getAwakeDutyCycle();
		//xg 20090413 reading data
		//if (readingRecorded) record[i++] = "" + mote.getReading();
		if (readingRecorded) record[i++] = "" + mote.get_reading()[0];
		
		
		if (countRecorded) record[i++] = "" + mote.getCount();
		if (qualityRecorded) record[i++] = "" + mote.getQuality();
		if (parentIdRecorded) record[i++] = "" + mote.getParentId();
		if (lastTimeSeenRecorded) record[i++] = "" + mote.getLastTimeSeen();
		try {
			csvWriter.writeRecord(record);
			String s = "";
			for (i=0;i<nbFieldsRecorded; i++)
				s = s.concat(record[i] + ", ");
		} catch (Exception e) { e.printStackTrace();}
	}
	
	// accessors
	public void setModeAutoRecorded(boolean b) { modeAutoRecorded = b;}
	public void setModeSleepingRecorded(boolean b) { modeSleepingRecorded = b;}
	public void setSamplingPeriodRecorded(boolean b) { samplingPeriodRecorded = b;}
	public void setThresholdRecorded(boolean b) { thresholdRecorded = b;}
	public void setSleepDutyCycleRecorded(boolean b) { sleepDutyCycleRecorded = b;}
	public void setAwakeDutyCycleRecorded(boolean b) { awakeDutyCycleRecorded = b;}
	public void setReadingRecorded(boolean b) { readingRecorded = b;}
	public void setCountRecorded(boolean b) { countRecorded = b;}
	public void setQualityRecorded(boolean b) { qualityRecorded = b;}
	public void setParentIdRecorded(boolean b) { parentIdRecorded = b;}
	public void setLastTimeSeenRecorded(boolean b) { lastTimeSeenRecorded = b;}
}
