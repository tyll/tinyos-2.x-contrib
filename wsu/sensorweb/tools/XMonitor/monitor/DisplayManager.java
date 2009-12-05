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
 * 1. This class creates a thread that runs in the background and refreshes 
 *    the screen periodically (mainly refresh topology page)
 * 2. It manages all node painters and edge painters
 * 3. It is also listening to all user actions on the topology panel of MainFrame
 *    and provides response to them:
 * 	  a. right click: Display control panel to send cmds for the nearest node
 *    b. left click: allow the network status to be displayed for the nearest node
 * 4. It is a NodePainter itself too, and paint the basic shape of the node
 *
 * Original version by:
 *    @author Wei Hong
 * Modified by:
 *    @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package monitor;

import Config.OasisConstants;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.Insets;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;
import monitor.Dialog.ActivePanel;
import monitor.Dialog.StandardDialog;
import monitor.PacketAnalyzer.*;
import monitor.event.*;
import monitor.util.*;
import oscope.ControlPanel;





public class DisplayManager implements java.awt.event.MouseListener, 
                                       java.awt.event.MouseMotionListener,
									   Runnable, 
									   NodePainter, EdgePainter, 
									   NodeEventListener, EdgeEventListener, 
									   NodeClickedEventListener, 
									   EdgeClickedEventListener, 
									   NodeDialogContributor, 
									   EdgeDialogContributor
{
    //public static MoteIF mote;
    public static Hashtable colorTable = new Hashtable();
	
	//these vectors hold all people that want to paint 
	//on the edge, nodes, or over the entire screen
    protected Vector nodePainters;
    protected Vector edgePainters;
    protected Vector screenPainters;

	//these vectors contain all people who want to add to 
	//the node/edge properties dialog
	//Note: unused functions for current version.
    protected Vector nodeDialogContributors;
    protected Vector edgeDialogContributors;

	//these vectors contain all the registered listeners 
	//for node and edge click events
    protected Vector NodeClickedEventListeners;
    protected Vector EdgeClickedEventListeners;

	//these hashtables hold nodeInfo and edgeInfo objects,
	//which hold display information about specific nodes and edges 
	//(e.g. color, image)
    protected static Hashtable proprietaryNodeInfo;
    protected static TwoKeyHashtable proprietaryEdgeInfo;

	//these variables describe how the mouse interacts with the network
    boolean selectMode;
    boolean handMode;
    boolean zoomMode; 

    //dchi - added this because when the user drags then unclicks the mouse, 
	//make sure it doesn't think it was a mouse click
    boolean dragging = false;
    
    private boolean stopped = false;

    int pressedXCoord=-1;
    int pressedYCoord=-1;
    protected static long refreshRate;  //time to sleep
    double zoomFactor;

	//Note: adjust it to make sure CPU usage is not too high
	//this is the number of milliseconds that 
	//it waits before redrawing the screen again
	public static final int MIN_REFRESH_RATE = 500;   

    //the thread that runs in the background 
	//and refreshes the screen periodically
    protected static Thread refreshScreenThread;
	private boolean initialPhaseComplete = false;
	private javax.swing.Timer timer = new javax.swing.Timer(1000, 
    new ActionListener() {
      public void actionPerformed(ActionEvent e) {
			timerfire();
		  }
		}
	  );
	
	public void timerfire(){
		initialPhaseComplete = true;
	}

	/**
	 * CONSTRUCTOR
	 */
	DisplayManager()
	{
		
		//mote = MainClass.mainFrame.mote;

		nodePainters = new Vector();
		edgePainters = new Vector();
		screenPainters = new Vector();
		nodeDialogContributors = new Vector();
		edgeDialogContributors = new Vector();
		NodeClickedEventListeners = new Vector();
		EdgeClickedEventListeners = new Vector();	
		proprietaryNodeInfo = new Hashtable();
		proprietaryEdgeInfo = new TwoKeyHashtable();

		//register to recieve all mouse clicks on the display panel
		MainClass.mainFrame.GetGraphDisplayPanel().addMouseListener(this);
		MainClass.mainFrame.GetGraphDisplayPanel().addMouseMotionListener(this);
		
		//register myself to paint nodes and display info panels
		this.AddNodePainter(this);

		//register myself to recieve NodeClickedEvents and EdgeClickedEvents
		this.AddNodeDialogContributor(this);
		this.AddEdgeDialogContributor(this);

		selectMode=true;
		handMode=false;
		zoomMode=false;

		refreshRate = MIN_REFRESH_RATE;   

        //this thread runs continually in the background to redraw the screen
        //System.err.println("Starting DisplayManager thread...");
		refreshScreenThread = new Thread(this);
		try{
			//refreshScreenThread.setPriority(Thread.MIN_PRIORITY);
			refreshScreenThread.start(); 
		}
		catch(Exception e){e.printStackTrace();}

		timer.start();
    }


  	/**
	 * Thread commands
	 *
	 */
    public void start(){ 
	try { 
	    System.err.println("Starting DisplayManager thread...");
	    refreshScreenThread = new Thread(this);
	    refreshScreenThread.start();
	} catch (Exception e) { e.printStackTrace(); }
    }

    // public void stop(){ try{ refreshScreenThread.stop();} catch(Exception e){e.printStackTrace();}}
    public static void sleep(long p){
		try{ 
			refreshScreenThread.sleep(p);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
    public static void setPriority(int p) {
		try{
			refreshScreenThread.setPriority(p);
		} catch(Exception e){
			e.printStackTrace();
		}
	}    

 
  	/**
	 * Run
	 *
     * this function runs in the background and repaints the screen
     * at the user determined refresh rate
	 */
    public void run(){
		while(!stopped)
			try
			{
				sleep(refreshRate);
				RefreshScreenNow();		
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
    }


  /**
   * Refresh screen
   *
   * this function will redraw the main screen with all nodes 
   * and edges in current positions
   */
   public static void RefreshScreenNow(){
		synchronized (MainClass.mainFrame) {
			MainClass.mainFrame.repaint();
		}
    }



	/**
	 * MOUSE CLICKED
	 */
    public void mouseClicked(MouseEvent e){}
    public void mouseClickedCustom(MouseEvent e){
		if (javax.swing.SwingUtilities.isLeftMouseButton(e)) {
			LocationAnalyzer.NodeInfo nodeLocationInfo= 
				                      FindNearestNode(e.getX(), e.getY());
			if(nodeLocationInfo == null) {
				return;
			}

			TriggerNodeClickedEvent(nodeLocationInfo.GetNodeNumber());  
			
			//Toggle the display of Status Items
			SensorAnalyzer.NodeInfo nodeInfo = 
				      (SensorAnalyzer.NodeInfo)SensorAnalyzer.proprietaryNodeInfo.
				               get(nodeLocationInfo.GetNodeNumber());
			nodeInfo.STATUS_MODE = !nodeInfo.STATUS_MODE;
	        
			//Note: unused now
			//DisplayNodePropertyDialog(nodeLocationInfo.GetNodeNumber());

		} else if (javax.swing.SwingUtilities.isRightMouseButton(e)) {
			LocationAnalyzer.NodeInfo nodeLocationInfo= 
				                      FindNearestNode(e.getX(), e.getY());
			if(nodeLocationInfo == null){
				return;
			}

			//Display control panel to send cmds for this node
            /*
            if (nodeLocationInfo.GetNodeNumber().intValue() != OasisConstants.BASE_ID){
				if (MainFrame.rpcApp != null){	   
					if(OasisConstants.DEBUG==true)System.err.println("DisplayControlPanel not implemented");				  
					//DisplayControlPanel(nodeLocationInfo.GetNodeNumber());
					MainClass.mainFrame.focusedNode = nodeLocationInfo.GetNodeNumber();
				}
				else{
					JOptionPane.showMessageDialog(null,
							"Please specify xml file to enable Remote Control first!",
							"WARNING",
							JOptionPane.INFORMATION_MESSAGE);
				}
			}
             * */
             

		} else {
			LocationAnalyzer.EdgeInfo edgeLocationInfo = 
				                      FindNearestEdge(e.getX(), e.getY());
			TriggerEdgeClickedEvent(edgeLocationInfo.GetSourceNodeNumber(), 
				                    edgeLocationInfo.GetDestinationNodeNumber());
			//Note: unused now
		    //DisplayEdgePropertyDialog(edgeLocationInfo.GetSourceNodeNumber(), 
			//                      edgeLocationInfo.GetDestinationNodeNumber());
		}
    }


	/**
	 * DISPLAY NODE CONTROL DIALOG
	 */
    protected void DisplayControlPanel(Integer pNodeNumber)
    {
		//show Control Panel for this node
		ControlPanelDialog CDialog;	
	    
		//make sure when the user clicks a node, 
		//only one dialog box to be shown up
		NodeInfo nodeInfo = (NodeInfo)proprietaryNodeInfo.get(pNodeNumber);
		if (nodeInfo.GetDialogShowing()) {
			JOptionPane.showMessageDialog(null, "already exists " + pNodeNumber);
		} 		
		else if ( MainClass.mainFrame.menuItemSendRPC.isEnabled()) {
			try {
				Vector moteID = new Vector();
				moteID.add(pNodeNumber);
				if(OasisConstants.DEBUG==true)System.err.println("ControlPanelDialog not implemented");				  
					  
                //CDialog = new ControlPanelDialog(moteID, mote, MainClass.mainFrame.rpcApp );
				//MainClass.mainFrame.menuItemSendRPC.setEnabled(false);
				
                nodeInfo.SetDialogShowing (true);
				//CDialog.show();
			}
			catch (java.lang.Exception e) {
			}
		}
    } 


	/**
	 * FIND NEAREST NODE
	 */
    public LocationAnalyzer.NodeInfo FindNearestNode(int x, int y)
    {
		LocationAnalyzer.NodeInfo selectedNode = null;
		LocationAnalyzer.NodeInfo tempNode = null;
		double dist = Double.MAX_VALUE;
		double bestdist = Double.MAX_VALUE;
		double xDist, yDist;
		GraphDisplayPanel display = MainClass.mainFrame.GetGraphDisplayPanel();
		for(Enumeration nodes = MainClass.locationAnalyzer.GetNodeInfo(); nodes.hasMoreElements();) 
			{
			tempNode = (LocationAnalyzer.NodeInfo)nodes.nextElement();
			//			synchronized(tempNode)
			//			{
			xDist = Math.pow(display.ScaleNodeXCoordToScreenCoord(tempNode.GetX()) - x,2.0);
			yDist = Math.pow(display.ScaleNodeYCoordToScreenCoord(tempNode.GetY()) - y,2.0);
			dist = Math.sqrt(xDist + yDist);
			//			}
			if (dist < bestdist) {
				selectedNode = tempNode;
				bestdist = dist;
			}
			}
		return selectedNode;
    }


	/**
	 * FIND NEAREST EDGE
	 */
    public LocationAnalyzer.EdgeInfo FindNearestEdge(int x, int y)
    {
	LocationAnalyzer.EdgeInfo selectedEdge = null;
	LocationAnalyzer.EdgeInfo tempEdge = null;
	double dist = Double.MAX_VALUE;
	double bestdist = Double.MAX_VALUE;
	GraphDisplayPanel display = MainClass.mainFrame.GetGraphDisplayPanel();

	for(Enumeration edges = MainClass.locationAnalyzer.GetEdgeInfo(); edges.hasMoreElements();) 
	    {
		double x1, y1, x2, y2, xCenter, yCenter;
		tempEdge = (LocationAnalyzer.EdgeInfo)edges.nextElement();
		//		synchronized(tempEdge)
		//		{
		Integer sourceNodeNumber = tempEdge.GetSourceNodeNumber();
		Integer destinationNodeNumber = tempEdge.GetDestinationNodeNumber();
		x1=MainClass.locationAnalyzer.GetX(sourceNodeNumber);
		y1=MainClass.locationAnalyzer.GetY(sourceNodeNumber);
		x2=MainClass.locationAnalyzer.GetX(destinationNodeNumber);
		y2=MainClass.locationAnalyzer.GetY(destinationNodeNumber);
		xCenter= display.ScaleNodeXCoordToScreenCoord((x1 + x2)/2);
		yCenter= display.ScaleNodeYCoordToScreenCoord((y1 + y2)/2);
		dist = Math.sqrt(Math.pow(xCenter-x,2) + Math.pow(yCenter-y,2));
		if (dist < bestdist) {
		    selectedEdge = tempEdge;
		    bestdist = dist;
		}
		//	}
	    }
	return selectedEdge;
    }


   /**
    *  PAINT related functions
	*
	*/
    public void PaintUnderScreen(Graphics g)
    {
		ScreenPainter screenPainter;
		for(Enumeration painters = screenPainters.elements(); painters.hasMoreElements();) 
		{
			screenPainter = (ScreenPainter)painters.nextElement();
			screenPainter.PaintScreenBefore(g);
		}
    }

    public void PaintOverScreen(Graphics g)
    {
		ScreenPainter screenPainter;
		for(Enumeration painters = screenPainters.elements(); painters.hasMoreElements();) 
		{
			screenPainter = (ScreenPainter)painters.nextElement();
			screenPainter.PaintScreenAfter(g);
		}
    }

    public void PaintAllNodes(Integer pNodeNumber, 
		                      int x1, int y1, int x2, int y2, Graphics g)
    {
		NodePainter nodePainter;
		NodeInfo displayInfo = (NodeInfo)proprietaryNodeInfo.get(pNodeNumber);
		if( (displayInfo == null) || (displayInfo.GetDisplayThisNode() == false) )
			return;
		for(Enumeration painters = nodePainters.elements(); painters.hasMoreElements();) 
		{
			nodePainter = (NodePainter)painters.nextElement();
            if(OasisConstants.DEBUG == true){
                   // System.out.println(pNodeNumber);
            }
			nodePainter.PaintNode(pNodeNumber, x1, y1, x2, y2, g);
		}
    }

    public void PaintAllEdges(Integer pSourceNodeNumber,
		                      Integer pDestinationNodeNumber, 
		                      int x1, int y1, int x2, int y2, Graphics g)
    {
		EdgePainter edgePainter;
		NodeInfo sourceDisplayInfo = (NodeInfo)proprietaryNodeInfo.
			                                     get(pSourceNodeNumber);
		NodeInfo destinationDisplayInfo= (NodeInfo)proprietaryNodeInfo.
			                                     get(pDestinationNodeNumber);
		if( (sourceDisplayInfo == null) 
				|| (destinationDisplayInfo == null) 
				|| (sourceDisplayInfo.GetDisplayThisNode() == false) 
				|| (destinationDisplayInfo.GetDisplayThisNode() == false)) 
			return;
		for(Enumeration painters = edgePainters.elements(); painters.hasMoreElements();) 
		{
		
			edgePainter = (EdgePainter)painters.nextElement();
			edgePainter.PaintEdge(pSourceNodeNumber, 
				                  pDestinationNodeNumber,
				                  x1, y1, x2, y2, g);
		}
    }

    public void PaintNode(Integer pNodeNumber, 
		                  int x1, int y1, int x2, int y2, Graphics g)
    {
		NodeInfo nodeInfo = (NodeInfo)proprietaryNodeInfo.get(pNodeNumber);
		double brightnessPercent = 50.0;
		int colorMode = 0;

		if (initialPhaseComplete && pNodeNumber.intValue() != 126)
		{
			timer.stop();
			Double moteExisted = (Double)DisplayManager.colorTable.get(pNodeNumber);
			//System.out.println(moteExisted);
			if (moteExisted == null)
			{
				if (nodeInfo.sendingStatus == 0)
				{
						nodeInfo.sendingStatus = 1;
						String temp = monitor.Util.getDateTime() +" : Node " + pNodeNumber.intValue() + " stop sending out message";
						try
						{
							//MainClass.eventLogger.write(temp +". Email to all clients \n");
							//MainClass.eventLogger.flush();			
							//System.out.println(temp + ". Email to all clients");
							//Util.sendEmail("Sensorweb Alert"+" : Node " + moteNo.intValue() + " stop sending out message", temp);
						}
						catch (Exception ex)
						{
							ex.printStackTrace();
						}
				}
			}
		}

		 Enumeration enm = DisplayManager.colorTable.keys();
		 while (enm.hasMoreElements()) {
			Integer moteNo = (Integer)enm.nextElement();
			
			if (moteNo.intValue() == pNodeNumber.intValue()){
				brightnessPercent =((Double)DisplayManager.colorTable.get(moteNo)).doubleValue() ;
				//System.out.println(brightnessPercent);
				if (brightnessPercent > ControlPanel.THRESHOLD){
					colorMode = 1;
				}
				else {
					colorMode = 0;
					if (nodeInfo.sendingStatus == 0)
					{
						nodeInfo.sendingStatus = 1;
						/*
						String temp = com.oasis.monitor.Util.getDateTime() +" : Node " + pNodeNumber.intValue() + " stop sending out message";
						try
						{
							Util.sendEmail("Sensorweb Alert", temp);
						}
						catch (Exception ex)
						{
							ex.printStackTrace();
						}
						*/
					}
				}
				//brightnessPercent = (brightnessPercent / (OasisConstants.MAX_VALUE_DATA - OasisConstants.MIN_VALUE_DATA));
				//color = (int)(brightnessPercent * (255-50) + 50);
				//color = (int)(brightnessPercent * 255);
				//System.out.println(pNodeNumber + " " + brightnessPercent + " " + color);
			}
		 }
		//Paint Node
		if (pNodeNumber == MainFrame.focusedNode) {
			//g.setColor(new Color(color, color, 0));
		} else {
			//g.setColor(new Color(0, 153, 102));  
			if (colorMode == 1)
				g.setColor(new Color(0, 255, 255));  
			else {
				g.setColor(new Color(255, 255, 0));  
			}
		}
		//Paint PC node
		Integer pcNode = new Integer(OasisConstants.UART_ADDRESS);
		if (pNodeNumber.intValue() == OasisConstants.UART_ADDRESS){
			g.setColor(new Color(0,0,255));
		}
		//Paint Sinks
		if (pcNode.equals(ObjectMaintainer.getParent(pNodeNumber))){
			if (colorMode == 1)
				g.setColor(new Color(0, 255, 255));  
			else {
				g.setColor(new Color(255, 255, 0));  
			}
		}

	
		

		//System.out.println("paintNode="+pNodeNumber.intValue());
		//if(ObjectMaintainer.isBase(pNodeNumber)){
			//YFH: debug
			//g.setColor(new Color(255, 0, 0));
			//g.fillRect(x1-1, y1-1, x2-x1+2, y2-y1+2);
			//System.out.println("create base image!node="+pNodeNumber.intValue());
			//g.drawImage(nodeInfo.GetImage(), x1, y1, x2-x1+100, y2-y1+100, null);
		//}
		//else {
		   g.fillOval(x1, y1, x2-x1, y2-y1);
		//}

		//Paint Label
		if(nodeInfo.GetDisplayNodeNumber() == true ) {
			g.setColor(MainFrame.labelColor);
			g.setFont(MainFrame.boldFont);
			String s = pNodeNumber.toString();
			g.drawString(s, (x1+x2)/2, y2-(y2-y1)/4 - 20);
		}
    }


    public void PaintEdge(Integer pSourceNodeNumber, 
		                  Integer pDestinationNodeNumber, 
		                  int x1, int y1, int x2, int y2, Graphics g)
    {		
        	System.out.print(pSourceNodeNumber+ "  ");
	 	System.out.println(pDestinationNodeNumber);
		g.setColor(Color.red);
		Util.drawArrow(g, x1, y1, x2, y2,1);
    }
	
	
	//this function adds the node dialog contributors
    public  void AddNodeDialogContributor(NodeDialogContributor pContributor)
    {
	nodeDialogContributors.add(pContributor);
    }

    public  void RemoveNodeDialogContributor(NodeDialogContributor pContributor)
    {
	nodeDialogContributors.remove(pContributor);
    }

    //this function adds the edge dialog contributors
    public  void AddEdgeDialogContributor(EdgeDialogContributor pContributor)
    {
	edgeDialogContributors.add(pContributor);
    }

    public  void RemoveEdgeDialogContributor(EdgeDialogContributor pContributor)
    {
	edgeDialogContributors.remove(pContributor);
    }

    //this function adds the nodeclicked Listeners
    public  void AddNodeClickedEventListener(NodeClickedEventListener pListener)
    {
	NodeClickedEventListeners.add(pListener);
    }

    public  void RemoveNodeClickedEventListener(NodeClickedEventListener pListener)
    {
	NodeClickedEventListeners.remove(pListener);
    }

    //this function adds the edge clicked Listeners
    public  void AddEdgeClickedEventListener(EdgeClickedEventListener pListener)
    {
	EdgeClickedEventListeners.add(pListener);
    }

    public  void RemoveEdgeClickedEventListener(EdgeClickedEventListener pListener)
    {
	EdgeClickedEventListeners.remove(pListener);
    }


    //*************************************************************
    //*************************************************************
    //this is where we register the node, edge and screen painters
    //*************************************************************
    //*************************************************************

    public void AddNodePainter(NodePainter painter)
    {
	nodePainters.add(painter);//add the painters to the painter list
    }

    public void RemoveNodePainter(NodePainter painter)
    {
	nodePainters.remove(painter);//add the painters to the painter list
    }

    public void AddEdgePainter(EdgePainter painter)
    {
	edgePainters.add(painter);//add the painters to the painter list
    }

    public void RemoveEdgePainter(EdgePainter painter)
    {
	edgePainters.remove(painter);//add the painters to the painter list
    }

    public void AddScreenPainter(ScreenPainter painter)
    {
	screenPainters.add(painter);//add the painters to the painter list
    }

    public void RemoveScreenPainter(ScreenPainter painter)
    {
	screenPainters.remove(painter);//add the painters to the painter list
    }





    // dchi - only way to access the nodeinfo for call from tabbedDialog
    public void ChangeNodeColor(Integer pNodeNumber) {
		NodeInfo nodeInfo = (NodeInfo)proprietaryNodeInfo.get(pNodeNumber);
		nodeInfo.SetColor(Color.green);
    }

    public void SetDialogShowing(Integer pNodeNumber, boolean isShowing) {
		NodeInfo nodeInfo = (NodeInfo)proprietaryNodeInfo.get(pNodeNumber);
		nodeInfo.SetDialogShowing(isShowing);
    }



	//MOUSE DRAGGED
    //Note: even though using this method instead of my custom method would 
	//      make the graphics look better, I use a custom mouse dragged method 
	//      because otherwise handling all the events overwhelms the system 
	//      and all the nodes might time-out

	public void mouseDragged(MouseEvent e){
		dragging = true;  
		mouseDraggedCustom (pressedXCoord, pressedYCoord, e);
		pressedXCoord = e.getX();
		pressedYCoord = e.getY();
		// DrawCoords(e);
    }
    

	public void mouseDraggedCustom(int startX, int startY, MouseEvent e){
		if (javax.swing.SwingUtilities.isLeftMouseButton(e)) {
				DragNearestNode(startX, startY, e);
		}
    }


    public void mouseEntered(MouseEvent e)
    {
    }

    public void mouseExited(MouseEvent e)
    {        
		//leave these lines if you don't want the custom mouse click to fire 
		//after the mouse has left and re-entered the screen
		//pressedXCoord = -1;
		//pressedYCoord = -1;
    }

    //this function triggers an event for a mouse press
    public void mousePressed(MouseEvent e)
    {
		pressedXCoord = e.getX();
		pressedYCoord = e.getY();
    }

    public void mouseReleased(MouseEvent e)
    {
		if((pressedXCoord == -1) || (pressedYCoord == -1)) {
			return;
		}

		int x = e.getX();
		int y = e.getY();

		if((pressedXCoord == x) && (pressedYCoord == y)){ //if a mouse click
			// this check is necessary because when the user drags 
			// and then releases the mouse
			// don't want the screen to pop up
			if (!dragging)
				mouseClickedCustom(e);
		}
		else {    
			//if it was a drag, pass the original coords and the final coords
			mouseDraggedCustom(pressedXCoord, pressedYCoord, e);
		}
		pressedXCoord = -1;//reset
		pressedYCoord = -1;

		dragging = false;
    }

    public void mouseMoved(MouseEvent e)
    {
		// DrawCoords(e);
    }


    //------------------------------------------------------------------------
    //*****---TRIGGER NODE CLICKED EVENT---******//
    //this function sends an event to all node clicked listeners
    protected void TriggerNodeClickedEvent(Integer pNodeNumber)
    {
		for(int index = 0; index < NodeClickedEventListeners.size(); index++)
	    {
			NodeClickedEvent e = new NodeClickedEvent(this, pNodeNumber,
				                           Calendar.getInstance().getTime());
			((NodeClickedEventListener)NodeClickedEventListeners.
				                           get(index)).NodeClicked(e);
	    }
    }
    //*****---TRIGGER NODE CLICKED EVENT---******//
    //------------------------------------------------------------------------


    //------------------------------------------------------------------------
    //*****---TRIGGER EDGE CLICKED EVENT---******//
    //this function sends an event to all edge-clicked listeners
    protected void TriggerEdgeClickedEvent(Integer pSourceNodeNumber,
		                                   Integer pDestinationNodeNumber)
    {
		for(int index = 0; index < EdgeClickedEventListeners.size(); index++)
		{
			EdgeClickedEvent e = new EdgeClickedEvent(this, 
										  pSourceNodeNumber, 
										  pDestinationNodeNumber, 
										  Calendar.getInstance().getTime());
			((EdgeClickedEventListener)EdgeClickedEventListeners.
				                          get(index)).EdgeClicked(e);
		}
    }
    //*****---TRIGGER EDGE CLICKED EVENT---******//
    //------------------------------------------------------------------------


    //------------------------------------------------------------------------
    //*****---DRAG NEAREST NODE---******//
    //when in select mode, the mouse draw will drag the nearest node with it
    public void DragNearestNode(int startX, int startY, MouseEvent e)
    {
		LocationAnalyzer.NodeInfo selectedNode = FindNearestNode(startX, startY);

		if(selectedNode!=null) {   
			//7/13/2007 YFH 
			if (selectedNode.GetFixed()) {
				return;
			}
			selectedNode.SetX(MainClass.mainFrame.GetGraphDisplayPanel().
				            ScaleScreenXCoordToNodeCoord(e.getX()).doubleValue());
			selectedNode.SetY(MainClass.mainFrame.GetGraphDisplayPanel().
				            ScaleScreenYCoordToNodeCoord(e.getY()).doubleValue());
			this.RefreshScreenNow();
		}
    }
    //*****---DRAG NEAREST NODE---******//
    //------------------------------------------------------------------------


    //------------------------------------------------------------------------
    //*****---SCROLL WITH MOUSE DRAG---******//
    //when in hand mode, the mouse draw will scroll the screen
    public void ScrollWithMouseDrag(int startX, int startY, MouseEvent e)
    {
		int endX = e.getX();
		int endY = e.getY();
		Point currentPosition = MainClass.mainFrame.GetMainScrollPane().
											   getViewport().getViewPosition();
		Point newPosition = new Point(currentPosition.x +(endX-startX), 
			                          currentPosition.y +(endY-startY));
		MainClass.mainFrame.GetMainScrollPane().getViewport().
			                          setViewPosition(newPosition);
    }
    //*****---SCROLL WITH MOUSE DRAG---******//
    //------------------------------------------------------------------------


    //------------------------------------------------------------------------
    //*****---ZOOM TO MOUSE DRAG RECTANGLE---******//
    //when in zoom mode, the mouse drag will zoom to the selected rectangle
    public void ZoomToMouseDragRectangle(int startX, int startY, MouseEvent e)
    {
		int x,y, width, height;
		double scale;
		Dimension graphPanelSize = MainClass.mainFrame.
			                           GetGraphDisplayPanel().getSize();
		Dimension scrollPaneSize = MainClass.mainFrame.
			                           GetMainScrollPane().getSize();
		int endX = e.getX();
		int endY = e.getY();

        //use the edge of the rectangle that is longer in proportion 
		//that the proportion of the window size
		if(startX < endX)
			{
			x = startX;
			width = endX-startX;
			}
		else
			{
			x = endX;
			width = startX - endX;
			}
		if(startY < endY)
			{
			y = startY;
			height = endY-startY;
			}
		else
			{
			y = endY;
			height = startY - endY;
			}
		if( (height==0) || (width==0)) return;

        //zoom so that the longer of the width/height of the new rectangle 
		//is in view (Since the rect will not be the same proportion as the window)
        if(width/height > graphPanelSize.getWidth()/graphPanelSize.getHeight())
			{
			scale = scrollPaneSize.getWidth()/width;
			}
		else
			{
			scale = scrollPaneSize.getHeight()/height;
			}
		scale = scale*MainClass.displayManager.GetScaleFactor();
		this.MultiplyGraphDisplayPanelSize(scale);
		MainClass.mainFrame.GetMainScrollPane().
			                    getViewport().setViewPosition(new Point(x,y));
    }                                            
    //*****---ZOOM TO MOUSE DRAG RECTANGLE---******//
    //------------------------------------------------------------------------



    //------------------------------------------------------------------------
    //*****---DISPLAY EDGE PROPERTY DIALOG---******//
    //this function displays the dialog showing all edge properties
   /* protected void DisplayEdgePropertyDialog(Integer pSourceNodeNumber, 
		                                     Integer pDestinationNodeNumber)
    {
		TabbedDialog edgeDialog = new TabbedDialog("Edge Properties");		
		ActivePanel currentPanel;

		for(Enumeration e = edgeDialogContributors.elements(); e.hasMoreElements();)
		{
			currentPanel = ((EdgeDialogContributor)e.nextElement()).
				GetProprietaryEdgeInfoPanel(pSourceNodeNumber, pDestinationNodeNumber);
			if(currentPanel != null)//if you don't have proprietary info, return a null panel
			{
				if(currentPanel.GetCancelInfoDialog())
				{
					//if you don't want a node dialog to show up, 
					//return an Active Component with this set to true
					return;
				}
				edgeDialog.AddActivePanel(currentPanel.GetTabTitle(),currentPanel);
				}
			}
		edgeDialog.setModal(false);
		edgeDialog.show();
    }*/
    //*****---DISPLAY EDGEPROPERTY DIALOG---******//
    //------------------------------------------------------------------------

	//-----------------------------------------------------------------------
	//*****---MultiplyGraphDisplayPanelSize---******//
    public static void MultiplyGraphDisplayPanelSize(double factor)
    {
		Insets inset = MainClass.mainFrame.GetMainScrollPane().getInsets();	 
		Dimension d = MainClass.mainFrame.GetMainScrollPane().getSize();	
		int x = (int)( (d.width-(inset.left+inset.right))*factor);
		int y = (int)( (d.height-(inset.top+inset.bottom))*factor);
		MainClass.mainFrame.GetGraphDisplayPanel().setSize(new Dimension(x, y));//this line makes the scroll pane put scroll bars if necessary
		MainClass.mainFrame.GetGraphDisplayPanel().setPreferredSize(new Dimension(x, y));//this line changes the size, and the node coordinates are automatically rescaled
		MainClass.mainFrame.GetMainScrollPane().setViewportView(MainClass.mainFrame.GetGraphDisplayPanel());//this line allows the scroll pane to reevaluate whether scroll bars are needed
    }
    //*****---MultiplyGraphDisplayPanelSize---******//
    //-----------------------------------------------------------------------


  //------------------------------------------------------------------------
  //*****---GET/SET FUNCTIONS---******//
    public  static double GetScaleFactor()
    {
	Dimension d1 = MainClass.mainFrame.GetMainScrollPane().getSize();	
	Insets inset = MainClass.mainFrame.GetMainScrollPane().getInsets();	 
	Dimension d2 = MainClass.mainFrame.GetGraphDisplayPanel().getSize();	
	return (d2.getHeight()+(inset.top+inset.bottom))/d1.getHeight();
    }

    public  static long GetRefreshRate(){return refreshRate;}
    public  static void SetRefreshRate(long pRefreshRate){refreshRate = pRefreshRate;	}

    public boolean GetSelectMode(){return selectMode;}
    public boolean GetHandMode(){return handMode;}
    public boolean GetZoomMode(){return zoomMode;}

    public void SetSelectMode(boolean b){selectMode=b;}
    public void SetHandMode(boolean b){handMode=b;}
    public void SetZoomMode(boolean b){zoomMode=b;}

    public NodeInfo GetNodeInfo(Integer nodeNumber){return (NodeInfo)proprietaryNodeInfo.get(nodeNumber);}
    public EdgeInfo GetEdgeInfo(Integer sourceNumber, Integer destinationNumber){return (EdgeInfo)proprietaryEdgeInfo.get(sourceNumber,destinationNumber);}
    public Enumeration GetNodeInfo(){return proprietaryNodeInfo.elements();}
    public Enumeration GetEdgeInfo(){return proprietaryEdgeInfo.elements();}

    //*****---GET/SET FUNCTIONS---******//
    //------------------------------------------------------------------------



  //------------------------------------------------------------------------
  //*****---Node Created---******//
  //this function defines what you do when a new node is created
    public synchronized void NodeCreated(NodeEvent e)
    {
		proprietaryNodeInfo.put(e.GetNodeNumber(), new NodeInfo(e));
    }
    //*****---Node Created---******//
    //------------------------------------------------------------------------


    //------------------------------------------------------------------------
    //*****---Node Deleted---******//
    //this function defines what you do when a new node is deleted
    public synchronized void NodeDeleted(NodeEvent e)
    {
        //you probably want to delete the info pbject 
		//to track the data of this new node
		Integer deletedNodeNumber = e.GetNodeNumber();
		proprietaryNodeInfo.remove(deletedNodeNumber);
    }
    //*****---Node Deleted---******//
    //------------------------------------------------------------------------


    //------------------------------------------------------------------------
    //*****---Edge Created---******//
    //this function defines what you do when a new edge is created
    public synchronized void EdgeCreated(EdgeEvent e)
    {
		Integer sourceNodeNumber = e.GetSourceNodeNumber();
		//you probably want to create a new info pbject 
		//to track the data of this new node
		Integer destinationNodeNumber = e.GetDestinationNodeNumber();
		proprietaryEdgeInfo.put(sourceNodeNumber, 
			                    destinationNodeNumber, 
			                    new EdgeInfo(sourceNodeNumber, destinationNodeNumber));
    }
    //*****---Edge Created---******//
    //------------------------------------------------------------------------


    //------------------------------------------------------------------------
    //*****---Edge Deleted---******//
    //this function defines what you do when a new edge is deleted
    public synchronized void EdgeDeleted(EdgeEvent e)
    {
	Integer sourceNodeNumber = e.GetSourceNodeNumber();
	Integer destinationNodeNumber = e.GetDestinationNodeNumber();//you probably want to create a new info pbject to track the data of this new node
	proprietaryEdgeInfo.remove(sourceNodeNumber, destinationNodeNumber);
    }
    //*****---EdgeDeleted---******//
    //------------------------------------------------------------------------



    //------------------------------------------------------------------------
    //*****---GRAPHICS COMMANDS---******//
    public void NodeClicked(NodeClickedEvent e){}
    public void EdgeClicked(EdgeClickedEvent e){}

    public ActivePanel GetProprietaryNodeInfoPanel(Integer pNodeNumber)
    {
		ProprietaryNodeInfoPanel panel = new ProprietaryNodeInfoPanel(
			                    (NodeInfo)proprietaryNodeInfo.get(pNodeNumber));
		return (ActivePanel)panel;
    }

    public ActivePanel GetProprietaryEdgeInfoPanel(Integer pSourceNodeNumber, 
		                                           Integer pDestinationNodeNumber) 
    {
		return null;
		/*  ProprietaryNodeInfoPanel panel = new ProprietaryNodeInfoPanel(
		       (NodeInfo)proprietaryNodeInfo.get(pEdge.GetSource().GetNodeNumber()));
			return (ActivePanel)panel;*/
    }

    public void ShowPropertiesDialog() 
    {
		StandardDialog newDialog = new StandardDialog(new DisplayPropertiesPanel());
		newDialog.show();
    }
    //*****---GRAPHICS COMMANDS---******//
    //------------------------------------------------------------------------





    //*********************************************************
    //NODE INFO CLASS
    //this class should hold any special information you hold about the
    //node, for example time created or a history of the number of packets
    //forwarded through this mote or whetever it is you are studying
    public class NodeInfo
    {
		protected Integer nodeNumber;
		protected ImageIcon imageHelper;
		protected Image image;
		  
		protected Color nodeColor;
		protected boolean isShowing;
		  
		protected double imageWidth, imageHeight;
		protected boolean displayThisNode;
		protected boolean displayNodeNumber;
		protected boolean fitOnScreen;
		protected String infoString;
		protected int sendingStatus;

		public NodeInfo(NodeEvent e) {
			nodeNumber = e.GetNodeNumber(); 
		  
			nodeColor = Color.green;
			isShowing = false;

			imageHelper = new ImageIcon("images/base.gif","images/base.gif");
			image = imageHelper.getImage();

			//note that this width and height is in node coordinates 
			//(hence it scales automatically with the size of the network, 
			// but must be initialized properly)
			imageWidth = 5;
			imageHeight = 5;
			displayThisNode = true;
			displayNodeNumber = true;
			fitOnScreen = true;
			sendingStatus = 0;
		}


	public void SetColor(Color newColor) {nodeColor = newColor;}
	public Color GetColor() { return nodeColor;}
      
	public void SetDialogShowing (boolean value) {
	    isShowing = value;
	}
	public boolean GetDialogShowing () {
	    return isShowing;
	}
      
	public Integer GetNodeNumber(){return nodeNumber;}
	public  ImageIcon GetImageHelper(){ return imageHelper;}
	public  Image GetImage(){ return image;}
	public  double GetImageWidth(){ 
	    return imageWidth;}
	public  double GetImageHeight(){ return imageHeight;}
	public  boolean GetDisplayThisNode(){ return displayThisNode;}
	public  boolean GetDisplayNodeNumber(){ return displayNodeNumber;}
	public  boolean GetFitOnScreen(){ return fitOnScreen;}

	public  void SetImageHelper(ImageIcon pImageHelper){  imageHelper =pImageHelper;}
	public  void SetImage(Image pImage){  image =pImage;}
	public  void SetImageWidth(double w){  imageWidth = w;}
	public  void SetImageHeight(double h){  imageHeight = h;}
	public  void SetDisplayThisNode(boolean pDisplay){  displayThisNode=pDisplay;}
	public  void SetDisplayNodeNumber(boolean pDisplayNumber){  displayNodeNumber=pDisplayNumber;}
	public  void SetFitOnScreen(boolean pFit){  fitOnScreen=pFit;}
    }
    //NODE INFO
    //*********************************************************


    //*********************************************************
    //EDGEINFO
    //this class should hold any special information you hold about the
    //edge, for example time created or a history of the number of packets
    //forwarded over this edge or whetever it is you are studying
    public class EdgeInfo
    {
		protected Integer sourceNodeNumber;
		protected Integer destinationNodeNumber;

		public EdgeInfo(Integer pSourceNodeNumber, Integer pDestinationNodeNumber)
		{
			sourceNodeNumber = pSourceNodeNumber;
			destinationNodeNumber = pDestinationNodeNumber;
		}


		public Integer GetSourceNodeNumber(){return sourceNodeNumber;}		
		public Integer GetDestinationNodeNumber(){return destinationNodeNumber;}		
    }
    //EDGE INFO
    //*********************************************************


    //*********************************************************
    //PROPRIETARY NODE INFO DISPLAY PANEL
    //This class is an ActivePanel and should have all the information
    //in GUI form that this class stores with respect to nodes
    //It should be return with GetProprietaryNodeInfoPanel and it will be displayed
    //with all the other packet analyzer proprietary info when a node is clicked.
    public class ProprietaryNodeInfoPanel extends monitor.Dialog.ActivePanel
    {
	NodeInfo nodeInfo;

	public ProprietaryNodeInfoPanel(NodeInfo pNodeInfo)
	{
	    tabTitle = "Display";
	    nodeInfo = pNodeInfo;
	    //{{INIT_CONTROLS
	    setLayout(null);
	    Insets ins = getInsets();
	    setSize(500,500);
	    JLabel3.setText("Image Width");
	    add(JLabel3);
	    JLabel3.setBounds(36,48,84,24);
	    JLabel4.setText("Image Height");
	    add(JLabel4);
	    JLabel4.setBounds(36,72,75,24);
	    JTextField1.setNextFocusableComponent(JTextField2);
	    JTextField1.setToolTipText("The scale of the coordinate system is determined by the user, and scaled automatically by the system to fit to the screen");
	    JTextField1.setText("1.5");
	    add(JTextField1);
	    JTextField1.setBounds(120,48,87,18);
	    JTextField2.setNextFocusableComponent(JCheckBox1);
	    JTextField2.setToolTipText("The scale of the coordinate system is determined by the user, and scaled automatically by the system to fit to the screen");
	    JTextField2.setText("3.2");
	    add(JTextField2);
	    JTextField2.setBounds(120,72,87,18);
	    JLabel1.setText("Image");
	    add(JLabel1);
	    JLabel1.setBounds(36,24,84,24);
	    JTextField3.setNextFocusableComponent(JTextField1);
	    JTextField3.setText("image/base.gif");
	    add(JTextField3);
	    JTextField3.setBounds(84,24,162,18);
	    JCheckBox1.setNextFocusableComponent(JCheckBox2);
	    JCheckBox1.setSelected(true);
	    JCheckBox1.setToolTipText("Check this if you want this node to appear on the screen");
	    JCheckBox1.setText("Display This Node");
	    add(JCheckBox1);
	    JCheckBox1.setBounds(36,96,123,21);
	    JCheckBox2.setNextFocusableComponent(JCheckBox3);
	    JCheckBox2.setSelected(true);
	    JCheckBox2.setToolTipText("This should be checked if you want this node to be fit onto the screen");
	    JCheckBox2.setText("Fit To Screen");
	    add(JCheckBox2);
	    JCheckBox2.setBounds(36,120,123,21);
	    JCheckBox3.setNextFocusableComponent(JTextField3);
	    JCheckBox3.setSelected(true);
	    JCheckBox3.setToolTipText("This should be checked if you want the number of the node to be drawn on the screen");
	    JCheckBox3.setText("Display Node Number");
	    add(JCheckBox3);
	    JCheckBox3.setBounds(36,144,123,21);
	    JButton1.setToolTipText("Click this button to see the image that is typed above");
	    JButton1.setText("Preview");
	    add(JButton1);
	    JButton1.setBounds(168,108,84,27);
	    JPanel1.setLayout(null);
	    add(JPanel1);
	    JPanel1.setBounds(36,165,153,126);
	    //}}

	    //{{REGISTER_LISTENERS
	    SymAction lSymAction = new SymAction();
	    JButton1.addActionListener(lSymAction);
	    //}}
	}

	//{{DECLARE_CONTROLS
	javax.swing.JLabel JLabel3 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel4 = new javax.swing.JLabel();
	javax.swing.JTextField JTextField1 = new javax.swing.JTextField();
	javax.swing.JTextField JTextField2 = new javax.swing.JTextField();
	javax.swing.JLabel JLabel1 = new javax.swing.JLabel();
	javax.swing.JTextField JTextField3 = new javax.swing.JTextField();
	javax.swing.JCheckBox JCheckBox1 = new javax.swing.JCheckBox();
	javax.swing.JCheckBox JCheckBox2 = new javax.swing.JCheckBox();
	javax.swing.JCheckBox JCheckBox3 = new javax.swing.JCheckBox();
	javax.swing.JButton JButton1 = new javax.swing.JButton();
	javax.swing.JPanel JPanel1 = new javax.swing.JPanel();
	//}}

	public void ApplyChanges()
	{
	    nodeInfo.SetImageWidth(Double.parseDouble(JTextField1.getText()));
	    nodeInfo.SetImageHeight(Double.parseDouble(JTextField2.getText()));
	    nodeInfo.SetDisplayThisNode(JCheckBox1.isSelected());
	    nodeInfo.SetFitOnScreen(JCheckBox2.isSelected());
	    nodeInfo.SetDisplayNodeNumber(JCheckBox3.isSelected());
	    nodeInfo.SetImageHelper(new ImageIcon(JTextField3.getText(),JTextField3.getText()));
	    nodeInfo.SetImage(nodeInfo.GetImageHelper().getImage());
	}

	public void InitializeDisplayValues()
	{
	    JTextField3.setText(nodeInfo.GetImageHelper().getDescription());
	    JTextField1.setText(String.valueOf(nodeInfo.GetImageWidth()));
	    JTextField2.setText(String.valueOf(nodeInfo.GetImageHeight()));
	    JCheckBox1.setSelected(nodeInfo.GetDisplayThisNode());
	    JCheckBox2.setSelected(nodeInfo.GetFitOnScreen());
	    JCheckBox3.setSelected(nodeInfo.GetDisplayNodeNumber());
	}

	class SymAction implements java.awt.event.ActionListener
	{
	    public void actionPerformed(java.awt.event.ActionEvent event)
	    {
		Object object = event.getSource();
		if (object == JButton1)
		    JButton1_actionPerformed(event);
	    }
	}

	void JButton1_actionPerformed(java.awt.event.ActionEvent event)
	{
	    // to do: code goes here.

	    JButton1_actionPerformed_Interaction1(event);
	}

	void JButton1_actionPerformed_Interaction1(java.awt.event.ActionEvent event)
	{
	    try {
		ImageIcon imageIcon = new ImageIcon(JTextField3.getText());
		Image tempImage = imageIcon.getImage();
		Graphics g = this.getGraphics();
		Dimension d = JPanel1.getSize();
		int width = (int)(MainClass.mainFrame.GetGraphDisplayPanel().GetXScale()*Double.parseDouble(JTextField1.getText()));
		int height = (int)(MainClass.mainFrame.GetGraphDisplayPanel().GetYScale()*Double.parseDouble(JTextField2.getText()));
		g.drawImage(tempImage, 36,144, width, height, null);
	    } catch (java.lang.Exception e) {
	    }
	}
    }  
	//PROPRIETARY NODE INFO DISPLAY PANEL
    //*********************************************************



  //***********************************************************************
  //Class DisplayPropertiesPanel
  //This panel will be shown in a dialog when the users clicks the right menu
    public static class DisplayPropertiesPanel extends ActivePanel
    {

	public DisplayPropertiesPanel()
	{
	    tabTitle = "Display Properties";
	    modal=true;
	    //{{INIT_CONTROLS
	    setLayout(null);
	    //			Insets ins = getInsets();
	    setSize(280,114);
	    JLabel1.setToolTipText("This is the number of times the screen will be magnified");
	    JLabel1.setText("ZoomX:");
	    add(JLabel1);
	    JLabel1.setBounds(24,12,48,24);
	    JComboBox1.setEditable(true);
	    JComboBox1.setToolTipText("This is the number of times the screen will be magnified");
	    JComboBox1.addItem(new Double(1.0));
	    JComboBox1.addItem(new Double(1.5));
	    JComboBox1.addItem(new Double(2.0));
	    JComboBox1.addItem(new Double(2.5));
	    JComboBox1.addItem(new Double(3.0));
	    add(JComboBox1);
	    JComboBox1.setBounds(144,12,108,24);
	    JLabel2.setToolTipText("Times are listed in milliseconds");
	    JLabel2.setText("Screen Refresh Rate:");
	    add(JLabel2);
	    JLabel2.setBounds(24,48,132,24);
	    JLabel4.setText("msec");
	    add(JLabel4);
	    JLabel4.setFont(new Font("Dialog", Font.BOLD, 9));
	    JLabel4.setBounds(204,48,24,24);
	    JSlider1.setMinimum(100);
	    JSlider1.setMaximum(10000);
	    JSlider1.setToolTipText("Slide this to change the refresh rate");
	    JSlider1.setValue(1500);
	    add(JSlider1);
	    JSlider1.setBounds(60,84,216,21);
	    JLabel3.setText("jlabel");
	    add(JLabel3);
	    JLabel3.setFont(new Font("Dialog", Font.BOLD, 16));
	    JLabel3.setBounds(156,48,51,27);
	    JComboBox1.setSelectedIndex(0);
	    //}}

	    //{{REGISTER_LISTENERS
	    SymChange lSymChange = new SymChange();
	    JSlider1.addChangeListener(lSymChange);
	    SymAction lSymAction = new SymAction();
	    //}}
	}

	//{{DECLARE_CONTROLS
	javax.swing.JLabel JLabel1 = new javax.swing.JLabel();
	javax.swing.JComboBox JComboBox1 = new javax.swing.JComboBox();
	javax.swing.JLabel JLabel2 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel4 = new javax.swing.JLabel();
	javax.swing.JSlider JSlider1 = new javax.swing.JSlider();
	javax.swing.JLabel JLabel3 = new javax.swing.JLabel();
	//}}


        @Override
	public void ApplyChanges()
	{
	    MainClass.displayManager.MultiplyGraphDisplayPanelSize( Double.parseDouble(JComboBox1.getSelectedItem().toString()));
	    MainClass.displayManager.SetRefreshRate(JSlider1.getValue());
	}

	public void InitializeDisplayValues()
	{
	    double factor = MainClass.displayManager.GetScaleFactor();
	    JComboBox1.setSelectedItem(new Double(factor));
	    JSlider1.setValue((int)MainClass.displayManager.GetRefreshRate());
	    JLabel3.setText(String.valueOf(MainClass.displayManager.GetRefreshRate()));
	}


	class SymChange implements javax.swing.event.ChangeListener
	{
	    public void stateChanged(javax.swing.event.ChangeEvent event)
	    {
		Object object = event.getSource();
		if (object == JSlider1)
		    JSlider1_stateChanged(event);
	    }
	}

	void JSlider1_stateChanged(javax.swing.event.ChangeEvent event)
	{
	    // to do: code goes here.

	    JSlider1_stateChanged_Interaction1(event);
	}

	class SymAction implements java.awt.event.ActionListener
	{
	    public void actionPerformed(java.awt.event.ActionEvent event)
	    {
	    }
	}

	void JSlider1_stateChanged_Interaction1(javax.swing.event.ChangeEvent event)
	{
	    try {
		// convert int->class java.lang.String
		JLabel3.setText(java.lang.String.valueOf(JSlider1.getValue()));
	    } catch (java.lang.Exception e) {
	    }
	}
    }//end of class


    public void stopDisplayThread()
    {
		stopped = true;
    }
}
