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
 * This is the parent class to all PacketAnalyzers
 *
 * It registers all the message types for MoteIF interface, 
 * which will be analyzed by PacketAnalyzers
 *
 * Original version by:
 *    @author Kamin Whitehouse <kamin@cs.berkeley.edu>
 * Modified by:
 *    @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package monitor.PacketAnalyzer;

import monitor.util.ScreenPainter;
import monitor.util.EdgeDialogContributor;
import monitor.util.NodeDialogContributor;
import monitor.util.EdgePainter;
import monitor.util.NodePainter;


import java.awt.*;
import java.util.Vector;
import monitor.*;
import monitor.Dialog.ActivePanel;
import monitor.event.*;
import rpc.message.*;

public abstract class PacketAnalyzer implements MessageListener, 
                                                PacketEventListener,
												NodeClickedEventListener, 
												EdgeClickedEventListener, 
												NodeEventListener, 
												EdgeEventListener, 
												NodePainter, 
												EdgePainter, 
												ScreenPainter, 
												NodeDialogContributor, 
												EdgeDialogContributor
{
	public PacketAnalyzer() {
		//Specify the Message Type defined in OasisType.h
		//MainClass.getMoteIF().registerListener(new Message(), this);
        //MainClass.getMoteIF().registerListener(typeName, this);
    }
    public void register(String typeName){
        MainClass.getMoteIF().registerListener(typeName, this);
    }
    
    // For MessageListener
    
    public void messageReceived(String typeName,Vector m) {
		this.PacketReceived(typeName,m);
	}

	
    public  void PacketReceived(String typeName,Vector m) { }

    public  void NodeCreated(NodeEvent e) { }

    public  void NodeDeleted(NodeEvent e) { }

    public  void EdgeCreated(EdgeEvent e) { }

    public  void EdgeDeleted(EdgeEvent e) { }

    public  void NodeClicked(NodeClickedEvent e) { }

    public  void EdgeClicked(EdgeClickedEvent e) { }

    public void PaintNode(Integer pNodeNumber, 
		                  int x1, int y1, int x2, int y2, 
		                  Graphics g) { }

    public void PaintEdge(Integer pSourceNodeNumber, 
		                  Integer pDestinationNodeNumber, 
		                  int screenX1, int screenY1, 
		                  int screenX2, int screenY2, 
		                  Graphics g) { }

    public void PaintScreenBefore(Graphics g) { }

    public void PaintScreenAfter(Graphics g) { }

    public ActivePanel GetProprietaryNodeInfoPanel(Integer nodeNumber) { 
		return null;
    }

    public ActivePanel GetProprietaryEdgeInfoPanel(Integer source, 
		                                           Integer destination) {
		return null;
    }

    public void AnalyzerDisplayEnable() {
		//paint on the screen over the edges and nodes
		MainClass.displayManager.AddScreenPainter(this);

		//register myself to be able to contribute to the node/edge properties panel
		MainClass.displayManager.AddNodeDialogContributor(this);
		MainClass.displayManager.AddEdgeDialogContributor(this);

		MainClass.displayManager.AddNodePainter(this);
    }

    public void AnalyzerDisplayDisable() {
		//paint on the screen over the edges and nodes
		MainClass.displayManager.RemoveScreenPainter(this);

		//register myself to be able to contribute to the node/edge properties panel
		MainClass.displayManager.RemoveNodeDialogContributor(this);
		MainClass.displayManager.RemoveEdgeDialogContributor(this);

		MainClass.displayManager.RemoveNodePainter(this);
    }

    
}
