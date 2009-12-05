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
 * This class is one of the PacketAnalyzer
 *
 * It is a NodePainter, and deals with the updation of status of node
 * Whenever receives a Network data msg:
 * 1. Draw double red circles to distinguish active node
 *    'active' means being able to send out Network messages
 * 2. Display Status Box if STATUS_MODE is true
 *    when the screan is refreshed
 *
 * Original version by:
 *	  @author Wei Hong
 * Modified by:
 *    @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */
package monitor.PacketAnalyzer;

import Config.OasisConstants;
import SensorwebObject.TwoKeyHashtable;
import monitor.MainFrame;


import java.util.*;
import java.awt.*;
import java.awt.event.*;
import monitor.Dialog.ActivePanel;
import monitor.Dialog.StandardDialog;
import monitor.MainClass;
import monitor.Util;
import monitor.event.NodeEvent;
import xml.RemoteObject.StreamDataObject;

/*-------------------------------------------------------------------*/
//import com.oasis.TCPserver.*;
/*-------------------------------------------------------------------*/
public class SensorAnalyzer extends PacketAnalyzer {

    public static Hashtable proprietaryNodeInfo;
    protected static TwoKeyHashtable proprietaryEdgeInfo;

    //Constants for the Calculation of Status
    public final int MAX_HOP = 10;
    public final int MAX_MSGRATE = 20;
    public final int MSG_MAP_LEN = 64;
    public final int TCPSERVER_MAX_SEQ = 65535;
    private static final long DECAY_THREAD_RATE = 5000;
    private Hashtable lastMsgCount = new Hashtable();
    private javax.swing.Timer timer = new javax.swing.Timer(20000,
            new ActionListener() {

                public void actionPerformed(ActionEvent e) {
                    timerfire();
                }
            });

    public void timerfire() {

        Enumeration enm = proprietaryNodeInfo.keys();
        while (enm.hasMoreElements()) {
            Integer moteNo = (Integer) enm.nextElement();
            NodeInfo currentNodeInfo = (NodeInfo) proprietaryNodeInfo.get(moteNo);
            if (!currentNodeInfo.hasNewMsg) {
                currentNodeInfo.hasNewMsg = true;


                if (currentNodeInfo.sendingStatus == 0 && moteNo.intValue() != 126) {
                    currentNodeInfo.sendingStatus = 1;
                    String temp = monitor.Util.getDateTime() + " : Node " + moteNo.intValue() + " stop sending out message";
                    try {

                        MainClass.eventLogger.write(temp + ". Email to all clients \n");
                        MainClass.eventLogger.flush();
                    //System.out.println(temp + ". Email to all clients");
                    //Util.sendEmail("Sensorweb Alert" +" : Node " + moteNo.intValue() + " stop sending out message" , temp);

                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                } else if (currentNodeInfo.sendingStatus == 1) {
                    currentNodeInfo.count++;
                    if (currentNodeInfo.count % 50 == 0) {
                        currentNodeInfo.sendingStatus = 0;
                    }
                }
            } else {
                currentNodeInfo.hasNewMsg = false;
                currentNodeInfo.count++;
            }
        }
    }

    /*-------------------------------------------------------------------*/
    //TCPserver server;/** add by PY */
	/*-------------------------------------------------------------------*/
    public SensorAnalyzer() {
        super();
        this.register("sensor");
        this.register("event");
        proprietaryNodeInfo = new Hashtable();
        proprietaryEdgeInfo = new TwoKeyHashtable();

        //register to be notified of nodes and edges being created or deleted
        MainClass.objectMaintainer.AddEdgeEventListener(this);
        MainClass.objectMaintainer.AddNodeEventListener(this);

        //add to node painter list in displaymanager
        AnalyzerDisplayEnable();

        /*-------------------------------------------------------------------*/
        //server = new TCPserver();/** add by py*/
		/*-------------------------------------------------------------------*/

        // Start decay thread
        new Thread(new DecayThread()).start();
        timer.start();
    }

    /**
     *  Periodically decay yield for each thread
     *
     */
    class DecayThread implements Runnable {

        public void run() {
            //System.err.println("Decay thread running...");
            while (true) {
                try {
                    Thread.currentThread().sleep(DECAY_THREAD_RATE);
                    Enumeration e = GetNodeInfo();
                    while (e.hasMoreElements()) {
                        NodeInfo ni = (NodeInfo) e.nextElement();
                        ni.decay();
                    }
                } catch (Exception e) {
                    // Ignore
                }
            }
        }
    }

    /**
     * Update Status of the node when receive EVENT/DATA massage
     *
     */
    

    @Override
    public synchronized void PacketReceived(String typeName, Vector streamEvent) {
        //System.out.println(typeName);

        Integer currentNodeNumber = new Integer((Integer) (((StreamDataObject) streamEvent.get(1)).data.get(0)));
        NodeInfo currentNodeInfo;
        // System.out.println("currentNodeNo" + currentNodeNumber);
        if ((currentNodeInfo = (NodeInfo) proprietaryNodeInfo.get(currentNodeNumber)) != null) {
            //Update Status of the node when receive EVENT/DATA massage
            currentNodeInfo.update(typeName, streamEvent);
        }

    }

    public synchronized void NodeCreated(NodeEvent e) {
        Integer newNodeNumber = e.GetNodeNumber();
        proprietaryNodeInfo.put(newNodeNumber, new NodeInfo(newNodeNumber));
    }

    public synchronized void NodeDeleted(NodeEvent e) {
        Integer deletedNodeNumber = e.GetNodeNumber();
        proprietaryNodeInfo.remove(deletedNodeNumber);
    }

    /**
     * NODE PAINTER
     * 1. Draw double red circles to distinguish active node
     *    'active' means being able to send out EVENT/DATA messages
     * 2. Display Status Box if STATUS_MODE is true
     *
     * this function is called by DisplayManager
     */
    public void PaintNode(Integer pNodeNumber,
            int x1, int y1, int x2, int y2, Graphics g) {

        NodeInfo nodeInfo = (NodeInfo) proprietaryNodeInfo.get(pNodeNumber);
        if (nodeInfo == null) {

            proprietaryNodeInfo.put(pNodeNumber, new NodeInfo(pNodeNumber));
            return;
        }

        nodeInfo.centerX = (x1 + x2) / 2;
        nodeInfo.centerY = (y1 + y2) / 2;
        //if (pNodeNumber.intValue() == 126)
        //System.out.println(nodeInfo.GetInfoString());
        //mark active node
        if (nodeInfo.active) {
            //g.setColor(Color.red);
            g.setColor(nodeInfo.activeColor);
            g.drawOval(x1, y1, x2 - x1, y2 - y1);
            g.drawOval(x1 + 3, y1 + 3, x2 - x1 - 6, y2 - y1 - 6);
        }

        //display status box
        if (OasisConstants.DEBUG == true) {
            //  System.out.println(pNodeNumber + " " + nodeInfo.STATUS_MODE);
        }
        if (nodeInfo.STATUS_MODE == true) {
            g.setColor(MainFrame.labelColor);
            g.setFont(MainFrame.bigFont);
            String s = nodeInfo.GetInfoString();
            g.drawString(s, (x1 + x2) / 2, y2 - (y2 - y1) / 4 + 20);

            //Disply sensor status
            Util.drawValueBar((x1 + x2) / 2, y2 - (y2 - y1) / 4 + 30,
                    "DataRate [/sec]:", (nodeInfo.msgRate),
                    (nodeInfo.msgRate) / (MAX_MSGRATE * 1.0), 0, g);
            Util.drawValueBar((x1 + x2) / 2, y2 - (y2 - y1) / 4 + 40,
                    "Pkt Loss:", (nodeInfo.numMissed),
                    nodeInfo.missRate, 1, g);
            Util.drawValueBar((x1 + x2) / 2, y2 - (y2 - y1) / 4 + 50,
                    "Pkt Duplicated:", (nodeInfo.numDuplicated),
                    nodeInfo.dupRate, 2, g);
            Util.drawValueBar((x1 + x2) / 2, y2 - (y2 - y1) / 4 + 60,
                    "Energy Consumed:", (nodeInfo.energy),
                    0, 3, g);
        //Util.drawValueBar((x1+x2)/2, y2-(y2-y1)/4 + 70,
        //		    "HopCount:", nodeInfo.hopCount,
        //	        (nodeInfo.hopCount)/(MAX_HOP*1.0),4, g);

        }
    }

    /**
     * SCREEN PAINTER
     *
     */
    public void PaintScreenBefore(Graphics g) {
        Dimension d = MainClass.mainFrame.GetGraphDisplayPanel().getSize();

        NodeInfo nodeInfo;
        int x = 0;
        int y = 0;
        int step = 10;
        int reading = 0;

        for (; x < d.width; x += step) {
            for (y = 0; y < d.height; y += step) {
                reading = 0;   //fixed dark background
                g.setColor(new Color(reading, reading, reading));
                g.fillRect(x, y, step, step);
            }
        }
    }

    public double distance(int x, int y, int x1, int y1) {
        return Math.sqrt((x - x1) * (x - x1) + (y - y1) * (y - y1));
    }

    public void PaintScreenAfter(Graphics g) {
        //paint something on the graphics object
    }

    public NodeInfo GetNodeInfo(Integer nodeNumber) {
        return (NodeInfo) proprietaryNodeInfo.get(nodeNumber);
    }

    public Enumeration GetNodeInfo() {
        return proprietaryNodeInfo.elements();
    }

    /**
     * NODE INFO CLASS
     * This class holds all status information about the node
     *
     */
    public class NodeInfo {

        protected ProprietaryNodeInfoPanel panel = null;
        protected Integer nodeNumber;
        //Sensor Reading, could be used for Demo purpose
        protected int value;
        protected Color activeColor = Color.red;
        protected int centerY;
        protected int centerX;
        protected String infoString;
        //Metrics to display
        protected double msgRate = 0;
        protected double missRate = 0,  dupRate = 0;
        protected double energy = 0;
        protected int link_quality;

        //Variables for calculation
        protected int lastMsgCount = 0;
        protected long lastTime;
        protected int AVERAGE_INTERVAL = 5000;
        protected boolean isDirectChild = false;
        protected boolean active = false;
        protected int firstSeq = 0,  lastSeq = 0,  hopCount = 0;
        protected int numMissed = 0,  numDuplicated = 0,  msgCount = 0,  nondupmsg = 0;
        protected int validMsgCount = 0;
        public long recvdMsgMap = 0;
        //public long startSeq, curSeq;
        public int startSeq = 0,  curSeq = 0;
        public int maxPos;
        public int true_missed = 0;
        public int temp_missed = 0;
        protected int lastHeard = 0;
        protected boolean justRestart = false;
        protected boolean hasNewMsg = true;
        protected int sendingStatus = 0;
        protected int count = 0;

        // Used to toggle the display of status box
        public boolean STATUS_MODE = true;

        public NodeInfo(Integer pNodeNumber) {
            lastTime = System.currentTimeMillis();
            nodeNumber = pNodeNumber;
            value = -1;
            infoString = "[none]";
            sendingStatus = 0;
        }

        // Decay current estimates if no msgs heard in last cycle
        public void decay() {
            if (active) {
                active = false;
                return;
            }

            long curtime = System.currentTimeMillis();
            if (curtime - lastTime >= AVERAGE_INTERVAL) {
                msgRate = (lastMsgCount * 1.0) / ((curtime - lastTime) * 1.0e-3);
                lastMsgCount = 0;
                lastTime = curtime;
            }
        }

        public Integer GetNodeNumber() {
            return nodeNumber;
        }

        public void SetPanel(ProprietaryNodeInfoPanel p) {
            panel = p;
        }

        public void SetNodeNumber(Integer pNodeNumber) {
            nodeNumber = pNodeNumber;
        }

        public int GetSensorValue() {
            return value;
        }

        public String GetInfoString() {
            return infoString;
        }

        //pos: rightmost is the pos 0
        public long bitSet(long msgMap, long pos) {
            long flag = (long) 1 << pos;
            msgMap = msgMap | flag;
            return msgMap;
        }

        public int bitClear(int msgMap, int pos) {
            /*#define reverse(x)                              \
            (x=x>>16|(0x0000ffff&x)<<16,            \
            x=(0xff00ff00&x)>>8|(0x00ff00ff&x)<<8, \
            x=(0xf0f0f0f0&x)>>4|(0x0f0f0f0f&x)<<4, \
            x=(0xcccccccc&x)>>2|(0x33333333&x)<<2, \
            x=(0xaaaaaaaa&x)>>1|(0x55555555&x)<<1)
             */

            return msgMap;
        }

        public int bitGet(long msgMap, long pos) {
            long map = msgMap;
            long mask = (long) 1 << pos;
            if ((map & mask) == 0) {
                return 0;
            } else {
                return 1;
            }
        }

        public int bitCount0(long msgMap, int from, int to) {
            long mask;
            long map;
            int numZero = 0;
            for (int i = from; i <= to; i++) {
                map = msgMap;
                mask = (long) 1 << i;
                if ((map & mask) == 0) {
                    numZero++;
                }
            }
            return numZero;
        }

        public long WindowShift(long msgMap, int count) {
            //shift out from the leftmost bit
            msgMap = msgMap >>> count;
            return msgMap;
        }

        //For debug seqNo round window
        public void WindowPrint(long msgMap) {
            long map;
            long flag;
            for (int i = MSG_MAP_LEN - 1; i >= 0; i--) {
                flag = (long) 1 << i;
                map = msgMap;
                map = map & flag;
                if (map == 0) {
                    System.out.print("0 ");
                } else {
                    System.out.print("1 ");
                }
                if ((i % 16) == 0) {
                    System.out.print("\n");
                }
            }

        }

        /**
         * Update status according to NW_DATA message
         * Mark node as active node whenever a message is received from this node
         *
         */
        //For SERVER_MODE = True
        

        public void update(String typeName, Vector streamEvent) {

            if (streamEvent == null) {
                return;
            }
            if (typeName.equalsIgnoreCase("sensor")) {
                hasNewMsg = true;
                //Check corrupted packet based on moteID [0,255]
                Integer currentNodeNo = new Integer(-1);
                Integer parentaddr = new Integer(-1);
                int typeInt;

                int seq = 0;
                typeInt = new Integer((Integer) (((StreamDataObject) streamEvent.get(0)).data.get(0)));
                    currentNodeNo = new Integer((Integer) (((StreamDataObject) streamEvent.get(1)).data.get(0)));
                    parentaddr = new Integer((Integer) (((StreamDataObject) streamEvent.get(2)).data.get(0)));
                    seq = (Integer) (((StreamDataObject) streamEvent.get(3)).data.get(0));
		    energy = (double)( ((Integer) (  ((StreamDataObject) streamEvent.get(4)).data.get(0)  )).intValue() );
                    if (OasisConstants.DEBUG) {
                        // System.out.println("currentNodeNo " + currentNodeNo);
                        //System.out.println("parentaddr " + parentaddr);
                        //System.out.println("seq " + seq);
                    }
                    if (currentNodeNo.intValue() < 0 || currentNodeNo.intValue() > 255) {
                        return;
                    }
                    if (parentaddr.intValue() < 0 || parentaddr.intValue() > 255) {
                        return;
                    }
                    int saddr = currentNodeNo;

                    NodeInfo ni = (NodeInfo) proprietaryNodeInfo.get(new Integer(saddr));
                    if (ni == null) {
                        System.out.println("ni");
                        return;
                    }
                    if (OasisConstants.DEBUG) {
                        // System.out.println("update : "+saddr);
                    }
                    // Mark node as active
                    active = true;

                    activeColor = Color.red;

                    // Update status
                    String info = "";
                    msgCount++;
                     if (OasisConstants.DEBUG && currentNodeNo == 0) {
                       // System.out.println("**************msgCount " + msgCount);
                    }
                    lastMsgCount++;
                    long curtime = System.currentTimeMillis();
                    if (curtime - lastTime >= AVERAGE_INTERVAL) {
                        msgRate = (lastMsgCount * 1.0) / ((curtime - lastTime) * 1.0e-3);
                        lastMsgCount = 0;
                        lastTime = curtime;
                    // System.out.println(msgRate);
                    }

                    //hopCount = 0;
                    curSeq = 0xffffffff & seq;


                    //curSeq = AMsg.get_seqno();
                    if (seq < MSG_MAP_LEN && !justRestart) {
                        justRestart = true;
                        String logOutput = "";
                        if (Math.abs(lastHeard - seq) > MSG_MAP_LEN) {
                            if (lastHeard < TCPSERVER_MAX_SEQ-MSG_MAP_LEN+1) {
                                logOutput = monitor.Util.getDateTime() + " : " + "JAVA: Mote " + saddr + " restarted. Previous sequence " + lastHeard + ". Current sequence " + seq;
                            } else {
                                logOutput = monitor.Util.getDateTime() + " : " + "JAVA: Mote " + saddr + " sequence round back. Previous sequence " + lastHeard + ". Current sequence " + seq;
                            }
                            try {
                                MainClass.eventLogger.write(logOutput + "\n");
                                MainClass.eventLogger.flush();
                                System.out.println(logOutput);
                            } catch (Exception ex) {
                            }
                        }

                    }
                    if (seq > MSG_MAP_LEN) {
                        justRestart = false;
                    }

                    if (OasisConstants.DEBUG && currentNodeNo == 0) {
                        //System.out.println("currentNodeNo " + currentNodeNo);
                        //System.out.println("parentaddr " + parentaddr);
                        //System.out.println("seq " + curSeq);
                    }

                    //YFH: Use MsgMap to Calc missed & duplicated Msgs

                    //First time of receiving msg from this node, or the node is restarted
                    //YFH: how about curSeq=0 pkt lost??
                   if (OasisConstants.DEBUG && currentNodeNo == 0 ) {
                                 //   System.out.println("curSeq " + curSeq);
                                 //   System.out.println("msgCount " + msgCount);
                        }
                        if (msgCount == 1 || ((curSeq == 0||(curSeq > 0 && curSeq < (MSG_MAP_LEN) ))  && startSeq > MSG_MAP_LEN && startSeq <(TCPSERVER_MAX_SEQ-MSG_MAP_LEN+1))) {
                    //if (msgCount == 1 || (curSeq == 0 && startSeq < (TCPSERVER_MAX_SEQ - MSG_MAP_LEN + 1))) {
                        //System.out.println("node"+saddr+" restart!  msgCount="+msgCount+"; curSeq="+curSeq);
                        //init variables for the first msg
                        startSeq = curSeq;
                        maxPos = 0;
                        recvdMsgMap = 1;  //mark the lowest bit
                        true_missed = 0;
                        temp_missed = 0;
                        numDuplicated = 0;
                        firstSeq = curSeq;
                        nondupmsg = 1;
                        
                        
                    } else {
                        //Sequence jump more than 1 bitmap window,
                        //probably packet corrupted or old packet come in after sequence round back. Both cases are not interested
                       /*
                        if (curSeq - startSeq > MSG_MAP_LEN * 20) {
                            return;
                        }*/
                       
                        if(curSeq<MSG_MAP_LEN && startSeq>=(TCPSERVER_MAX_SEQ-MSG_MAP_LEN+1)) {
                            startSeq = curSeq;
                            maxPos = 0;
                            recvdMsgMap = 1;
                            true_missed = 0;
                            temp_missed = 0;
                            numDuplicated = 0;
                            firstSeq = curSeq;
                        }
                        

                        int curPosition;
                        if (curSeq < MSG_MAP_LEN && startSeq >= (TCPSERVER_MAX_SEQ - MSG_MAP_LEN + 1))//round back,
                        {
                            curPosition = (int) (curSeq + TCPSERVER_MAX_SEQ + 1 - startSeq);
                        } else {
                            curPosition = (int) (curSeq - startSeq);
                        }
                        
                        
                        if (-curPosition > MSG_MAP_LEN*20){
								startSeq = curSeq;
								maxPos = 0;
								recvdMsgMap = 1;  
								firstSeq = curSeq;
							}
                        
                        
                         if (OasisConstants.DEBUG && currentNodeNo == 0 ) {
                                  //  System.out.println("curPosition " + curPosition);
                                   // System.out.println("recvdMsgMap " + Long.toBinaryString(recvdMsgMap));
                                }
                        //int curPosition = (int)(curSeq - startSeq);
                        if (curPosition >= 0) {
                            //curSeq is in current MsgMap window
                            if (curPosition < MSG_MAP_LEN) {
                                //check duplication
                                if (bitGet(recvdMsgMap, curPosition) == 1) {
                                    numDuplicated++;
                                } //mark for the new recvd pkt
                                else {
                                    recvdMsgMap = bitSet(recvdMsgMap, curPosition);
                                    if (curPosition > maxPos) {
                                        maxPos = curPosition;
                                    }
                                    nondupmsg++;
                                }
                            } //curSeq is out of current MsgMap window, need to shift window
                            else {// curpositon may >MSG_MAPC_LEN, need to move window
                                nondupmsg++;
                                //get # of bits need to shift
                                int newPosition = curPosition - MSG_MAP_LEN;
                                if (newPosition < MSG_MAP_LEN) {
                                    //count # of 0s in the left of window which will be shifted out
                                    true_missed += bitCount0(recvdMsgMap, 0, newPosition);
                                    recvdMsgMap = WindowShift(recvdMsgMap, newPosition + 1);
                                    startSeq += newPosition + 1;
                                    startSeq = startSeq % (65535);
                                    maxPos = MSG_MAP_LEN - 1;
                                    //mark for curSeq(in rightmost of the window)
                                    recvdMsgMap = bitSet(recvdMsgMap, MSG_MAP_LEN - 1);

                                } else {
                                    true_missed += bitCount0(recvdMsgMap, 0, MSG_MAP_LEN - 1);
                                    true_missed += (newPosition - MSG_MAP_LEN + 1);
                                    recvdMsgMap = bitSet(recvdMsgMap, MSG_MAP_LEN - 1);
                                    startSeq = curSeq - MSG_MAP_LEN + 1;
                                    maxPos = MSG_MAP_LEN - 1;
                                }
                            }
                            //count # of 0s in current MsgMap
                            temp_missed = bitCount0(recvdMsgMap, 0, maxPos);
                             if (OasisConstants.DEBUG && currentNodeNo == 0 ) {
                                 //   System.out.println("temp_missed " + temp_missed);
                                   // System.out.println("numDuplicated " + (numDuplicated));
                                }
                            //calc total missed msg for now
                            numMissed = true_missed + temp_missed;
                            missRate = (numMissed * 1.0) / ((nondupmsg * 1.0) + (numMissed * 1.0));
                            dupRate = (numDuplicated * 1.0) / (nondupmsg * 1.0);
                             if (OasisConstants.DEBUG && currentNodeNo == 0 ) {
                                  //  System.out.println("missRate " + missRate);
                                  //  System.out.println("dupRate " + dupRate);
                                }
                        } else {
                            //receives a very old pkt, do nothing
                        }
                    }


                    info = nondupmsg + " msgs ";
                    //System.out.println("node"+saddr+"update status");
                    this.infoString = info;
                    lastHeard = seq;
                //}
            }
            if (typeName.equalsIgnoreCase("event")) {
                int typeInt;
                System.out.println("event");
                int seq = 0;
                typeInt = new Integer((Integer) (((StreamDataObject) streamEvent.get(1)).data.get(0)));
                //if (typeInt == OasisConstants.NW_SNMS) {
                    active = true;
                    activeColor = Color.yellow;
                //}

            }
            try {
                NodeInfo pcNode = (NodeInfo) proprietaryNodeInfo.get(new Integer(OasisConstants.UART_ADDRESS));
                pcNode.active = true;
                pcNode.nondupmsg++;
                pcNode.infoString = pcNode.nondupmsg + " msgs ";
            } catch (Exception ex) {
            }
        /**/
        }
    }

    //Note: unused funtions below!
    @Override
    public ActivePanel GetProprietaryNodeInfoPanel(Integer pNodeNumber) {
        NodeInfo nodeInfo = (NodeInfo) proprietaryNodeInfo.get(pNodeNumber);
        if (nodeInfo == null) {
            return null;
        }
        ProprietaryNodeInfoPanel panel = new ProprietaryNodeInfoPanel(nodeInfo);
        return (ActivePanel) panel;
    }

    //PROPRIETARY NODE INFO DISPLAY PANEL
    //This class is an ActivePanel and should have all the information
    //in GUI form that this class stores with respect to nodes
    //It should be returned with GetProprietaryNodeInfoPanel and it will be displayed
    //with all the other packet analyzer proprietary info when a node is clicked.
    public class ProprietaryNodeInfoPanel extends monitor.Dialog.ActivePanel {

        NodeInfo nodeInfo;

        public ProprietaryNodeInfoPanel(NodeInfo pNodeInfo) {
            nodeInfo = pNodeInfo;

            nodeInfo.SetPanel(this);

            //tabTitle = "Sensor Value";//this will be the title of the tab
            setLayout(null);
            //			Insets ins = getInsets();
            setSize(307, 168);
            //JLabel3.setToolTipText("This text will appear with mouse hover over this component");
            JLabel3.setText("Node Number:");
            add(JLabel3);
            //JLabel3.setBounds(12,36,108,24);
            JLabel3.setBounds(12, 6, 108, 24);

            // JLabel4.setToolTipText("This is the value of NodeNumber");
            JLabel4.setText("text");
            add(JLabel4);
            //JLabel4.setBounds(12,60,108,24);
            JLabel4.setBounds(12, 26, 108, 24);

            //      JLabel5.setToolTipText("This text will appear with mouse hover over this component");
            JLabel5.setText("Sensor Reading:");
            add(JLabel5);
            //JLabel5.setBounds(12,84,108,24);
            JLabel5.setBounds(12, 54, 108, 24);

            //      JLabel6.setToolTipText("This is the value of Sensor Reading");
            JLabel6.setText("text");
            add(JLabel6);
            //JLabel6.setBounds(12,108,108,24);
            JLabel6.setBounds(12, 74, 108, 24);
        }

        public void panelClosing() {
            System.err.println("SensorAnalyzer: updating panel = null");
            nodeInfo.SetPanel(null);
        }
        javax.swing.JLabel JLabel3 = new javax.swing.JLabel();
        javax.swing.JLabel JLabel4 = new javax.swing.JLabel();
        javax.swing.JLabel JLabel5 = new javax.swing.JLabel();
        javax.swing.JLabel JLabel6 = new javax.swing.JLabel();

        public void ApplyChanges()//this function will be called when the apply button is hit
        {
            nodeInfo.SetNodeNumber(Integer.getInteger(JLabel4.getText()));
        }

        @Override
        public void InitializeDisplayValues()//this function will be called when the panel is first shown
        {
            JLabel4.setText(String.valueOf(nodeInfo.GetNodeNumber()));
            JLabel6.setText(String.valueOf(nodeInfo.GetSensorValue()));
        }
    }

    public void ShowPropertiesDialog() {
        StandardDialog newDialog = new StandardDialog(new DisplayPropertiesPanel(this));
        newDialog.show();
    }

    //PacketAnalyzerTemplatePropertiesPanel
    //This class is an ActivePanel and should have all the information
    //in GUI form that this class stores with respect to EDGES
    //It will be displayed automatically with ShowPropertiesDialog
    public class DisplayPropertiesPanel extends monitor.Dialog.ActivePanel {

        SensorAnalyzer analyzer;

        public DisplayPropertiesPanel(SensorAnalyzer pAnalyzer) {
            analyzer = pAnalyzer;
            tabTitle = "Light";//this will be the title of the tab
            setLayout(null);
            //			Insets ins = getInsets();
            setSize(307, 168);
            JLabel3.setToolTipText("This text will appear with mouse hover over this component");
            JLabel3.setText("Variable Name:");
            add(JLabel3);
            JLabel3.setBounds(12, 36, 108, 24);
            JLabel4.setToolTipText("This is the value of Variable Name");
            JLabel4.setText("text");
            add(JLabel4);
            JLabel4.setBounds(12, 60, 108, 24);
        }
        javax.swing.JLabel JLabel3 = new javax.swing.JLabel();
        javax.swing.JLabel JLabel4 = new javax.swing.JLabel();

        public void ApplyChanges()//this function will be called when the apply button is hit
        {
            //			analyzer.SetVariableName(Integer.getInteger(JLabel4.getText()).intValue());
        }

        public void InitializeDisplayValues()//this function will be called when the panel is first shown
        {
            //			JLabel4.setText(String.valueOf(analyzer.GetVariableName()));
        }
    }
}
