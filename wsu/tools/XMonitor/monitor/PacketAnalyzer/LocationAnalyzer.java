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
 * It is a NodePainter and EdgePainter, 
 * and it deals with the following infomation:
 *
 * 1.  NodeInfo: determine the location of a node
 *     1) if a location file is provided, get location from the file;
 *     2) o.w., randomly set coordinates of a node
 *     Note: if it is set, it can display coordinates of a node.
 *
 * 2.  EdgeInfo: draw & maintain links
 *     1) Determine the color of the edge based on link-quality
 *        Whenever receives a EVENT_TYPE_ROUTING event msg, 
 *        get and set link-quality;
 *     2) Maintain links
 *        redraw the link whenever the screen is refreshed
 *
 * Original version by:
 *	  @author Wei Hong
 * Modified by:
 *    @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */
package monitor.PacketAnalyzer;

import SensorwebObject.TwoKeyHashtable;
import monitor.Util;
import monitor.MainFrame;


import java.util.*;
import java.awt.*;
import monitor.Dialog.ActivePanel;
import monitor.MainClass;
import monitor.event.EdgeClickedEvent;
import monitor.event.EdgeEvent;
import monitor.event.NodeClickedEvent;
import monitor.event.NodeEvent;
import xml.RemoteObject.StreamDataObject;

public class LocationAnalyzer extends PacketAnalyzer implements java.lang.Runnable {

    Thread estimateLocationThread;
    protected static Hashtable proprietaryNodeInfo;
    protected static TwoKeyHashtable proprietaryEdgeInfo;
    public static int quality = 0;

    public LocationAnalyzer() {
        this.register("location");
        //define hashtables to hold my proprietary information
        proprietaryNodeInfo = new Hashtable();
        proprietaryEdgeInfo = new TwoKeyHashtable();

        //register to hear new node and edge events
        MainClass.objectMaintainer.AddNodeEventListener(this);
        MainClass.objectMaintainer.AddEdgeEventListener(this);

        //register to be a node and edge painter
        MainClass.displayManager.AddNodePainter(this);
        MainClass.displayManager.AddEdgePainter(this);
    }

    /**
     * Update links according to NetworkMsg received
     *
     */
    

    public void PacketReceived(String typeName, Vector streamEvent) {
        //System.out.println(typeName);

        EdgeInfo edgeInfo;
        Integer sourceNodeNumber = null;
        Integer destinationNodeNumber = null;

        //quality++;
        //Check corrupted packet based on moteID [0,255]
        Integer currentNodeNo = new Integer((Integer) (((StreamDataObject) streamEvent.get(0)).data.get(0)));
        Integer parentaddr = new Integer((Integer) (((StreamDataObject) streamEvent.get(1)).data.get(0)));
        //System.out.println("currentNodeNo" + currentNodeNo);
        //System.out.println("parentaddr" + parentaddr);

        if (currentNodeNo.intValue() < 0 || currentNodeNo.intValue() > 255) {
            return;
        }
        if (parentaddr.intValue() < 0 || parentaddr.intValue() > 255) {
            return;
        }

        sourceNodeNumber = new Integer(currentNodeNo);



        int size = (Integer) (((StreamDataObject) streamEvent.get(2)).data.size());
        //System.out.println(size);

        if (size < 7) {
            return;
        }
        String contents = "";
        Iterator resIt = ((StreamDataObject) streamEvent.get(2)).data.iterator();

        while (resIt.hasNext()) {
            //System.out.print((Integer) resIt.next() + " ");
            contents += (char) (((Integer) resIt.next()).intValue());
        }

        //System.out.println(contents);
        if ((contents.substring(0, 7)).equals("parent:")) {
            //test validation of numbers
            String parentStr = contents.substring(7, size);
            System.out.println("parentStr=" + parentStr + ", substr(0,1)=" + parentStr.substring(0, 0) + ", 0=" + Integer.parseInt("0") + ", 9=" + Integer.parseInt("9"));
            if (Integer.parseInt(parentStr.substring(0, 1)) < Integer.parseInt("0") || Integer.parseInt(parentStr.substring(0, 1)) > Integer.parseInt("9")) {
                System.out.println("Warning: get messy string of EventReport...ignore it");
            //EMsg = null;
            } else {
                int parent = Integer.parseInt(parentStr);
                destinationNodeNumber = new Integer(parent);

                edgeInfo = (EdgeInfo) proprietaryEdgeInfo.get(sourceNodeNumber, destinationNodeNumber);

            }/* */
        }

    }

    public void run() {
        //this function will do all background work for location estimation
        //in general, this would include mass springs or boltzman machine
        //type activity
        while (true) {
            try {
                estimateLocationThread.sleep(100);
            } catch (Exception e) {
                e.printStackTrace();
            }

            // just randomly assign locations
            NodeInfo currentNode;
            for (Enumeration nodes = GetNodeInfo(); nodes.hasMoreElements();) {
                currentNode = (NodeInfo) nodes.nextElement();
                synchronized (currentNode) {
                    if (currentNode.GetFixed() == false) {
                        currentNode.SetX(Math.random());
                        currentNode.SetY(Math.random());
                    }
                }
            }
        }
    }

    public void NodeCreated(NodeEvent e) {
        Integer nodeNumber = e.GetNodeNumber();
        proprietaryNodeInfo.put(nodeNumber, new NodeInfo(nodeNumber));
    }

    public void NodeDeleted(NodeEvent e) {
        Integer nodeNumber = e.GetNodeNumber();
        proprietaryNodeInfo.remove(nodeNumber);
    }

    public void EdgeCreated(EdgeEvent e) {
        Integer sourceNodeNumber = e.GetSourceNodeNumber();
        Integer destinationNodeNumber = e.GetDestinationNodeNumber();
        proprietaryEdgeInfo.put(sourceNodeNumber, destinationNodeNumber,
                new EdgeInfo(sourceNodeNumber, destinationNodeNumber));

    }

    public void EdgeDeleted(EdgeEvent e) {
        Integer sourceNodeNumber = e.GetSourceNodeNumber();
        Integer destinationNodeNumber = e.GetDestinationNodeNumber();
        proprietaryEdgeInfo.remove(sourceNodeNumber, destinationNodeNumber);
    }

    public void NodeClicked(NodeClickedEvent e) {
    }

    public void EdgeClicked(EdgeClickedEvent e) {
    }

    /**
     * Display Coordination Label of Node
     *
     */
    public void PaintNode(Integer pNodeNumber,
            int x1, int y1, int x2, int y2, Graphics g) {
        NodeInfo nodeInfo = (NodeInfo) proprietaryNodeInfo.get(pNodeNumber);
        if (nodeInfo == null) {
            return;
        }

        if (nodeInfo.GetDisplayCoords() == true) {
            String temp = String.valueOf(nodeInfo.GetX());
            String text = temp.substring(0, Math.min(4, temp.length()));
            text = text.concat(",");
            temp = String.valueOf(nodeInfo.GetY());
            text = text.concat(temp.substring(0, Math.min(4, temp.length())));
            //g.setColor(Color.black);
            g.setColor(Color.red);
            g.drawString(text, x1, y1);
        }
    }

    /**
     * Draw Link with the color determined by link quality
     * Display the Length of the Link
     *
     */
    public void PaintEdge(Integer pSourceNodeNumber,
            Integer pDestinationNodeNumber,
            int screenX1, int screenY1, int screenX2, int screenY2,
            Graphics g) {

        EdgeInfo edgeInfo = (EdgeInfo) proprietaryEdgeInfo.get(pSourceNodeNumber, pDestinationNodeNumber);
        if (edgeInfo == null) {
            return;
        }

        if (edgeInfo.GetRoutingPath()) {
            g.setColor(edgeInfo.GetEdgeColor());
            Util.drawArrow(g, screenX1, screenY1, screenX2, screenY2, 3);
        }

        if (edgeInfo.GetDisplayLength() == true) {
            String temp = String.valueOf(this.GetDistance(pSourceNodeNumber,
                    pDestinationNodeNumber));
            String text = temp.substring(0, Math.min(3, temp.length()));
            text = text.concat(",");
            double x1 = GetX(pSourceNodeNumber);
            double y1 = GetY(pSourceNodeNumber);
            double x2 = GetX(pDestinationNodeNumber);
            double y2 = GetY(pDestinationNodeNumber);
            temp = String.valueOf(Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2)));
            //put both estimated and real distances
            text = text.concat(temp.substring(0, Math.min(3, temp.length())));
            g.setColor(Color.black);
            g.drawString(text, (screenX2 + screenX1) / 2, (screenY2 + screenY1) / 2);
        }

    }

    public double GetDistance(Integer sourceNodeNumber, Integer destinationNodeNumber) {
        EdgeInfo edgeInfo = (EdgeInfo) proprietaryEdgeInfo.get(sourceNodeNumber, destinationNodeNumber);
        if (edgeInfo != null) {
            return edgeInfo.GetDistance();
        } else {
            return Double.NaN;
        }
    }

    public double GetX(Integer nodeNumber) {
        NodeInfo nodeInfo = (NodeInfo) proprietaryNodeInfo.get(nodeNumber);
        if (nodeInfo != null) {
            return nodeInfo.GetX();
        } else {
            return Double.NaN;
        }
    }

    public double GetY(Integer nodeNumber) {
        NodeInfo nodeInfo = (NodeInfo) proprietaryNodeInfo.get(nodeNumber);
        if (nodeInfo != null) {
            return nodeInfo.GetY();
        } else {
            return -1;
        }
    }

    /**
     * YFH: Add SetX, SetY, SetFixed to allow loading layout from a file
     */
    public void SetX(Integer nodeNumber, double x) {
        NodeInfo nodeInfo = (NodeInfo) proprietaryNodeInfo.get(nodeNumber);
        if (nodeInfo != null) {
            nodeInfo.SetX(x);
        }
    }

    public void SetY(Integer nodeNumber, double y) {
        NodeInfo nodeInfo = (NodeInfo) proprietaryNodeInfo.get(nodeNumber);
        if (nodeInfo != null) {
            nodeInfo.SetY(y);
        }
    }

    public void SetFixed(Integer nodeNumber, boolean fixed) {
        NodeInfo nodeInfo = (NodeInfo) proprietaryNodeInfo.get(nodeNumber);
        if (nodeInfo != null) {
            nodeInfo.SetFixed(fixed);
        }
    }

    public NodeInfo GetNodeInfo(Integer nodeNumber) {
        return (NodeInfo) proprietaryNodeInfo.get(nodeNumber);
    }

    public EdgeInfo GetEdgeInfo(Integer sourceNumber, Integer destinationNumber) {
        return (EdgeInfo) proprietaryEdgeInfo.get(sourceNumber, destinationNumber);
    }

    public Enumeration GetNodeInfo() {
        return proprietaryNodeInfo.elements();
    }

    public Enumeration GetEdgeInfo() {
        return proprietaryEdgeInfo.elements();
    }

    /**
     * NodeInfo Class:
     * Record location related info [X, Y] of a node
     *
     */
    public class NodeInfo {

        protected double x;
        protected double y;
        protected Integer nodeNumber;
        //determines if the node can move around automatically or not
        protected boolean fixed;
        //determines if the XY Coords should be drawn
        protected boolean displayCoords;

        public NodeInfo(Integer pNodeNumber) {
            nodeNumber = pNodeNumber;

            //7/13/2007 YFH: Initialize node position
            if (MainFrame.LAYOUT_MODE && (!MainClass.layoutInfo.isEmpty())) {
                boolean found = false;
                MainClass.LayoutInfo info = null;
                for (Enumeration e = MainClass.layoutInfo.elements(); e.hasMoreElements();) {
                    info = (MainClass.LayoutInfo) e.nextElement();
                    if (info.id == nodeNumber.intValue()) {
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    x = Math.random();
                    y = Math.random();
                    fixed = false;
                } else {
                    x = info.x;
                    y = info.y;
                    fixed = true;
                }
            } else {
                x = Math.random();
                y = Math.random();
                fixed = false;
            }
            displayCoords = false;//true;
        }

        public Integer GetNodeNumber() {
            return nodeNumber;
        }

        public double GetX() {
            return x;
        }

        public double GetY() {
            return y;
        }

        public boolean GetFixed() {
            return fixed;
        }

        public boolean GetDisplayCoords() {
            return displayCoords;
        }

        public void SetX(double pX) {
            x = pX;
        }

        public void SetY(double pY) {
            y = pY;
        }

        public void SetFixed(boolean pFixed) {
            fixed = pFixed;
        }

        public void SetDisplayCoords(boolean pDisplayCoords) {
            displayCoords = pDisplayCoords;
        }
    }

    /**
     * EdgeInfo Class:
     * Record distance and quality info of a node
     *
     */
    public class EdgeInfo {

        protected double distance;
        protected Integer sourceNodeNumber;
        protected Integer destinationNodeNumber;
        //determines if the length should be drawn
        protected boolean displayLength;
        protected boolean is_routing_path;
        protected double link_quality;

        EdgeInfo(Integer pSource, Integer pDestination) {
            sourceNodeNumber = pSource;
            destinationNodeNumber = pDestination;
            distance = .5;
            is_routing_path = true;
            displayLength = false;
            link_quality = -1.0;
        }

        public Integer GetSourceNodeNumber() {
            return sourceNodeNumber;
        }

        public Integer GetDestinationNodeNumber() {
            return destinationNodeNumber;
        }

        public double GetDistance() {
            return distance;
        }

        public void SetDistance(double pDistance) {
            distance = pDistance;
        }

        public boolean GetDisplayLength() {
            return displayLength;
        }

        public void SetDisplayLength(boolean pDisplayLength) {
            displayLength = pDisplayLength;
        }

        public boolean GetRoutingPath() {
            if (destinationNodeNumber.equals(ObjectMaintainer.getParent(sourceNodeNumber))) {
                return true;
            } else if (sourceNodeNumber.equals(ObjectMaintainer.getParent(destinationNodeNumber))) {
                return true;
            }

            return false;
        }

        public void SetLinkQuality(int quality) {
            if (quality == 255) {
                link_quality = -1.0;
            } else {
                link_quality = (quality * 1.0) / 100.0;
            }
        }

        public Color GetEdgeColor() {
            return Util.gradientColor(link_quality);
        }
    }


    //Note: unused functions below!
    @Override
    public ActivePanel GetProprietaryNodeInfoPanel(Integer pNodeNumber) {
        return new ProprietaryNodeInfoPanel((NodeInfo) proprietaryNodeInfo.get(pNodeNumber));
    }

    public ActivePanel GetProprietaryEdgeInfoPanel(Integer pSourceNodeNumber,
            Integer pDestinationNodeNumber) {
        return new ProprietaryEdgeInfoPanel((EdgeInfo) proprietaryEdgeInfo.get(pSourceNodeNumber, pDestinationNodeNumber));
    }

    public class ProprietaryNodeInfoPanel extends monitor.Dialog.ActivePanel {

        NodeInfo nodeInfo;

        public ProprietaryNodeInfoPanel(NodeInfo pNodeInfo) {
            tabTitle = "Location";
            nodeInfo = pNodeInfo;
            //{{INIT_CONTROLS
            setLayout(null);
            Insets ins = getInsets();
            setSize(247, 168);
            JLabel3.setText("X Coordinate");
            add(JLabel3);
            JLabel3.setBounds(36, 48, 84, 24);
            JLabel4.setText("Y Coordinate");
            add(JLabel4);
            JLabel4.setBounds(36, 72, 75, 24);
            JTextField1.setNextFocusableComponent(JTextField2);
            JTextField1.setToolTipText("The scale of the coordinate system is determined by the user, and scaled automatically by the system to fit to the screen");
            JTextField1.setText("1.5");
            add(JTextField1);
            JTextField1.setBounds(120, 48, 87, 18);
            JTextField2.setToolTipText("The scale of the coordinate system is determined by the user, and scaled automatically by the system to fit to the screen");
            JTextField2.setText("3.2");
            add(JTextField2);
            JTextField2.setBounds(120, 72, 87, 18);
            JCheckBox1.setToolTipText("Check this is you don\'t want the node to move around");
            JCheckBox1.setText("Fixed x/y Coordinates");
            add(JCheckBox1);
            JCheckBox1.setBounds(36, 96, 168, 24);
            JCheckBox2.setToolTipText("Check this is you want the coordinates to be displayed on the screen");
            JCheckBox2.setText("Display x/y Coordinates");
            add(JCheckBox2);
            JCheckBox2.setBounds(36, 120, 168, 24);
        //}}

        //{{REGISTER_LISTENERS
        //}}
        }

        //{{DECLARE_CONTROLS
        javax.swing.JLabel JLabel3 = new javax.swing.JLabel();
        javax.swing.JLabel JLabel4 = new javax.swing.JLabel();
        javax.swing.JTextField JTextField1 = new javax.swing.JTextField();
        javax.swing.JTextField JTextField2 = new javax.swing.JTextField();
        javax.swing.JCheckBox JCheckBox1 = new javax.swing.JCheckBox();
        javax.swing.JCheckBox JCheckBox2 = new javax.swing.JCheckBox();
        //}}

        public void ApplyChanges() {
            nodeInfo.SetX(Double.valueOf(JTextField1.getText()).doubleValue());
            nodeInfo.SetY(Double.valueOf(JTextField2.getText()).doubleValue());
            nodeInfo.SetFixed(JCheckBox1.isSelected());
            nodeInfo.SetDisplayCoords(JCheckBox2.isSelected());
        }

        public void InitializeDisplayValues() {
            JTextField1.setText(String.valueOf(nodeInfo.GetX()));
            JTextField2.setText(String.valueOf(nodeInfo.GetY()));
            JCheckBox1.setSelected(nodeInfo.GetFixed());
            JCheckBox2.setSelected(nodeInfo.GetDisplayCoords());
        }
    }

    public class ProprietaryEdgeInfoPanel extends monitor.Dialog.ActivePanel {

        EdgeInfo edgeInfo;

        public ProprietaryEdgeInfoPanel(EdgeInfo pEdgeInfo) {
            tabTitle = "Location";
            edgeInfo = pEdgeInfo;
            //{{INIT_CONTROLS
            setLayout(null);
            Insets ins = getInsets();
            setSize(247, 168);
            JLabel3.setText("Distance");
            add(JLabel3);
            JLabel3.setBounds(36, 48, 84, 24);
            JTextField1.setToolTipText("The scale of the coordinate system is determined by the user, and scaled automatically by the system to fit to the screen");
            JTextField1.setText("1.5");
            add(JTextField1);
            JTextField1.setBounds(120, 48, 87, 18);
            JCheckBox1.setToolTipText("Check this is you want the length of the edge to be displayed");
            JCheckBox1.setText("Display Length");
            add(JCheckBox1);
            JCheckBox1.setBounds(36, 66, 168, 24);
        //}}

        //{{REGISTER_LISTENERS
        //}}
        }

        //{{DECLARE_CONTROLS
        javax.swing.JLabel JLabel3 = new javax.swing.JLabel();
        javax.swing.JTextField JTextField1 = new javax.swing.JTextField();
        javax.swing.JCheckBox JCheckBox1 = new javax.swing.JCheckBox();
        //}}

        public void ApplyChanges() {
            edgeInfo.SetDistance(Double.parseDouble(JTextField1.getText()));
            edgeInfo.SetDisplayLength(JCheckBox1.isSelected());
        }

        public void InitializeDisplayValues() {
            JTextField1.setText(String.valueOf(edgeInfo.GetDistance()));
            JCheckBox1.setSelected(edgeInfo.GetDisplayLength());
        }
    }
}
