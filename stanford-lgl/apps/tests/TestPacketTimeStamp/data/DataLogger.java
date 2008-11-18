/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2007 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */


/**
 * @author Brano Kusy
 */

import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.PrintStream;
import java.util.HashMap;
import java.util.StringTokenizer;
import java.util.TreeMap;

import net.tinyos.message.*;
import net.tinyos.util.*;

public class DataLogger implements MessageListener {

    final int RX_ERROR=20;

	public class RunWhenShuttingDown extends Thread {
		TreeMap<Integer, NodeTimes> rx_nodes = new TreeMap<Integer, NodeTimes>();
		TreeMap<Integer, NodeTimes> tx_nodes = new TreeMap<Integer, NodeTimes>();
		public void run() 
		{ 
			System.out.println("\nError summary:\nTX/RX:\tErrB\tErrS\tAvgErrS\t \tErrB2\tErrS2\tAvgErrS2");
			for (TxRx id:rx_node_times.keySet())
			{
				NodeTimes rxval = rx_nodes.get(id.rx);
				NodeTimes txval = tx_nodes.get(id.tx);
				NodeTimes rxnew = rx_node_times.get(id);
				if (rxval==null)
				{
					rxval = new NodeTimes();
					rx_nodes.put(id.rx, rxval);
				}
				rxval.numBigErrors+=rxnew.numBigErrors;
				rxval.numSmallErrors+=rxnew.numSmallErrors;
				rxval.sumSmallErrors+=Math.abs(rxnew.sumSmallErrors);
					
				if (txval==null)
				{
					txval = new NodeTimes();
					tx_nodes.put(id.tx, txval);
				}
				txval.numBigErrors+=rxnew.numBigErrors;
				txval.numSmallErrors+=rxnew.numSmallErrors;
				txval.sumSmallErrors+=Math.abs(rxnew.sumSmallErrors);
					
				System.out.println(id+"\t "+rx_node_times.get(id));				
			}
			System.out.println("Summary of receivers (abs txrx errors):");
			for (Integer id:rx_nodes.keySet())
				System.out.println(id+"\t "+rx_nodes.get(id));				
			System.out.println("Summary of transmitters (abs txrx errors):");
			for (Integer id:tx_nodes.keySet())
				System.out.println(id+"\t "+tx_nodes.get(id));				

			if (outPoll!=null)
				outPoll.close();
			if (outReport!=null)
				outReport.close();
		} 
	}
	
	MoteIF mote; 

    void connect()
    {
		try {
		    mote = new MoteIF(PrintStreamMessenger.err);
		    mote.registerListener(new TimeStampPoll(), this);
		    mote.registerListener(new TimeStampPollReport(), this);
		    System.out.println("Connection ok!");

			String name=""+System.currentTimeMillis();
			outPoll = new PrintStream(new FileOutputStream(name+".poll"));
			outReport = new PrintStream(new FileOutputStream(name+".report"));
    		outPoll.println("#[SENDER_ID] [MSG_ID] [PREV_SEND_TIME]");
    		outReport.println("#[RECEIVER_ID] [SENDER_ID] [MSG_ID] [PREV_SEND_TIME] [RX_TIME]");
		}
		catch(Exception e) {
		    e.printStackTrace();
		    System.exit(2);
		}
    }
    PrintStream outPoll = null;
    PrintStream outReport = null;
    
    class NodeTimes {
    	TreeMap<Integer, Long> time = new TreeMap<Integer, Long>();//indexed by msg_id
        int numSmallErrors=0, numBigErrors=0,numSmallErrors2=0, numBigErrors2=0;
        double sumSmallErrors=0d,sumSmallErrors2=0d;
    	public String toString() {
    		return new String(numBigErrors+"\t"+numSmallErrors+"\t"
    							+((int)(sumSmallErrors*1000/numSmallErrors))/1000f+"\t \t"
    							+numBigErrors2+"\t"+numSmallErrors2+"\t"
    							+((int)(sumSmallErrors2*1000/numSmallErrors2))/1000f);
    	}
    }
    
    class TxRx {
    	Integer tx;
    	Integer rx;
    	public TxRx(int tx, int rx) { this.tx=tx; this.rx=rx;}
    	public String toString() {return new String(tx+"/"+rx);}
    	public boolean equals (Object o) {
    		if (o instanceof TxRx) {
				TxRx other = (TxRx) o;
				if (other.tx==tx && other.rx==rx)
					return true;
			}
    		return false;
    	}
    	public int hashCode() {
    		return tx.hashCode()+255*rx.hashCode(); 
    	}
    }
    
    HashMap<Integer,NodeTimes> tx_node_times = new HashMap<Integer,NodeTimes>();//indexed by tx_id
    HashMap<TxRx,NodeTimes> rx_node_times = new HashMap<TxRx,NodeTimes>();//indexed by tx_id,rx_id
    
    public DataLogger() {
		Runtime.getRuntime().addShutdownHook(new RunWhenShuttingDown());
    }

	public void writePoll(TimeStampPoll tsp)
	{
		outPoll.println(tsp.get_senderAddr()+" "+tsp.get_msgID()+" "+tsp.get_previousSendTime());
		outPoll.flush();
	}
	    
	public void findRxError (int txId, int rxId, int msgId)
	{
		NodeTimes rxTimes = rx_node_times.get(new TxRx(txId,rxId));
		NodeTimes txTimes = tx_node_times.get(txId);
		Integer prevMsgId = rxTimes.time.lowerKey(msgId);
		if (prevMsgId == null || !txTimes.time.containsKey(prevMsgId))
			return;
		Long rxTimePrev = rxTimes.time.get(prevMsgId);
		Long rxTime = rxTimes.time.get(msgId);
		Long txTimePrev = txTimes.time.get(prevMsgId);
		Long txTime = txTimes.time.get(msgId);
		
		int FILTER_RX_ID=9;
		
		if (rxTimePrev!=null&&rxTime!=null&&txTimePrev!=null&&txTime!=null)// && rxId==FILTER_RX_ID)
		{
		    double exp_rx_time = rxTimePrev+txTime-txTimePrev;
		    double rx_error = exp_rx_time-rxTime;
		    if (Math.abs(rx_error)>RX_ERROR){
		    	++rxTimes.numBigErrors;
		    	System.out.println("RXTX err: ids ["+txId+"->"+rxId+"  ], msg(prev) "+msgId+"("+prevMsgId+"), exp_time "+exp_rx_time+", time "+rxTime+" (error "+rx_error+")");
		    }
		    else {
		    	++rxTimes.numSmallErrors;
		    	rxTimes.sumSmallErrors+=rx_error;
			    //System.out.println("RXTX  ok: ids ["+txId+"->"+rxId+"  ], msg "+msgId+", exp_time "+exp_rx_time+", time "+rxTime+" (error "+rx_error+")");
		    }
		}
		for (TxRx txRxId:rx_node_times.keySet())
			if (txId==txRxId.tx && txRxId.rx>rxId)// && (rxId==FILTER_RX_ID||txRxId.rx==FILTER_RX_ID))
			{
				NodeTimes nt = rx_node_times.get(txRxId);
				if (nt!=null && nt.time.containsKey(prevMsgId)&& nt.time.containsKey(msgId)) 
				{
					Long rx2TimePrev = nt.time.get(prevMsgId);
					Long rx2Time = nt.time.get(msgId);
					
				    double exp_rx_time = rxTimePrev+rx2Time-rx2TimePrev;
				    double rx_error = Math.abs(exp_rx_time-rxTime);
				    if (rx_error>RX_ERROR-5){
				    	++rxTimes.numBigErrors2;
				    	System.out.println("RXRX err: ids ["+txRxId.tx+"->"+rxId+","+txRxId.rx+"], msg "+msgId+", exp_time "+exp_rx_time+", time "+rxTime+" (error "+rx_error+")");
				    }
				    else {
				    	++rxTimes.numSmallErrors2;
				    	rxTimes.sumSmallErrors2+=rx_error;
					    //System.out.println("RXRX  ok: ids ["+txRxId.tx+"->"+rxId+","+txRxId.rx+"], msg "+msgId+", exp_time "+exp_rx_time+", time "+rxTime+" (error "+rx_error+")");
				    }		
				}
			}

	}
	
	public void analyzeReprot(int txId, int rxId, int msgId, long tx_prev_time, long rx_time)
	{
		NodeTimes txTimes = tx_node_times.get(txId);
		NodeTimes rxTimes = rx_node_times.get(new TxRx(txId, rxId));
		if (txTimes == null) {
			txTimes = new NodeTimes();
			tx_node_times.put(txId, txTimes);			
		}
		if (rxTimes == null) {
			rxTimes = new NodeTimes();
			rx_node_times.put(new TxRx(txId,rxId),rxTimes);
		}
		
		txTimes.time.put(msgId-1, tx_prev_time);
		rxTimes.time.put(msgId, rx_time);
		
		//look at the error of the prev msg (tx sends tx_prev_time)
		if (rxTimes.time.containsKey(msgId-1))
			findRxError(txId, rxId, msgId-1);
	}
	    
    public void messageReceived(int dest_addr, Message msg) 
    {
		if (msg instanceof TimeStampPoll)
			writePoll((TimeStampPoll)msg);
		else if (msg instanceof TimeStampPollReport)
		{
			TimeStampPollReport tspr=(TimeStampPollReport)msg;
			int txId = tspr.get_senderAddr();
			int rxId = tspr.get_localAddr();
			int msgId = tspr.get_msgID();
			long tx_prev_time = tspr.get_previousSendTime();
			long rx_time = tspr.get_receiveTime();
			outReport.println(rxId+" "+txId+" "+msgId+" "+tx_prev_time+" "+rx_time);
			outReport.flush();

			analyzeReprot(txId, rxId, msgId, tx_prev_time, rx_time);
		}
    }
        
    void loadData(String filename) throws Exception
    {
    	FileReader myFile = new FileReader(filename);
    	BufferedReader myReader = new BufferedReader(myFile);
    	String fileLine;
    	while ( (fileLine = myReader.readLine()) != null )
    	{
    		if (!fileLine.startsWith("#"))
    		{
				  StringTokenizer tokenizer = new StringTokenizer(fileLine);
				  int rxId=Integer.parseInt(tokenizer.nextToken());
				  int txId=Integer.parseInt(tokenizer.nextToken());
				  int msgId=Integer.parseInt(tokenizer.nextToken());
				  long tx_prev_time=Long.parseLong(tokenizer.nextToken());
				  long rx_time=Long.parseLong(tokenizer.nextToken());
				  analyzeReprot(txId, rxId, msgId, tx_prev_time, rx_time);
    		}
    	}
    }
    /* If no params are given, app will start in the logging mode
     * Filename of a '.report' file can be given as a parameter
     * to execute error analysis on the previously saved data.
     */
    public static void main(String[] args) {
		DataLogger logger = new DataLogger();
    	if (args.length==0)
    		logger.connect();
    	else
    		try
	    	{
    			System.out.println("Reading file: "+args[0]+"\n");
    			logger.loadData(args[0]);
	    	} catch (Exception e) {
	    		e.printStackTrace();
	    	}
    }
}
