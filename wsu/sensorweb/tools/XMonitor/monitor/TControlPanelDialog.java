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
 * This class is the control panel for remote control and remote programming.
 *
 * whenever the control panel button in the toolbar of topology
 * panel is clicked or any node is right clicked.
 *
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package monitor;

import com.oasis.message.*;
import Config.*;
import monitor.GraphDisplayPanel;
import monitor.Dialog.*;
import debug.rpc.*;

import net.tinyos.message.MoteIF;

import java.util.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.JDialog;
import javax.swing.border.TitledBorder;

//8/6/2007
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.Component;

public class TControlPanelDialog extends javax.swing.JDialog
{
	public static MoteIF mote;
	public Vector nodeID;
	boolean singlenode;
	public static NescApp app;

	public rpcPanel  cPanel = null;

	//8/6/2007
	private GridBagLayout layout;
	private GridBagConstraints constraints;


	SymAction lSymAction = new SymAction();
	SymChange lSymChange = new SymChange();

	public TControlPanelDialog(Vector _nodeID, MoteIF _mote, NescApp _app)
	{
		super (MainClass.mainFrame);
		setDefaultCloseOperation(javax.swing.JFrame.DISPOSE_ON_CLOSE);

		//this setting makes sure you can click on other things
		setModal(true);  //YFH
		setSize(700,750);
	 	setResizable(false); 
		setLocationRelativeTo(null);

		mote = _mote;
		app = _app;
		nodeID = _nodeID;

		if (nodeID.size() == 1){
			int moteNo = Integer.parseInt(nodeID.get(0).toString());
			if (moteNo ==  OasisConstants.ALL_NODES){
				setTitle("RPC Panel for All Nodes");
				singlenode = false;
			}
			else {
			setTitle("RPC Panel for Node #"+nodeID);
			singlenode = true;
			}
		}
		else {
			String listOfmote = "";
			for (int i = 0 ; i <nodeID.size(); i++){
				int moteNo = Integer.parseInt(nodeID.get(i).toString());
				listOfmote +=  " Node # " + moteNo;
				singlenode = false;			
			}
			setTitle("Control Panel for " + listOfmote);
		}

        	//add Log panel
		JPanel logPanel = new JPanel();
		TitledBorder paneEdge = BorderFactory.createTitledBorder("Action & Response :");
		logPanel.setBorder(paneEdge);
		logPanel.setLayout(new BorderLayout());
		
		JTextArea actionLog = new JTextArea(" ",3,3);
		actionLog.setEditable(false);
		logPanel.add(actionLog);
		logPanel.add(new JScrollPane(actionLog), BorderLayout.CENTER);


		//Add Remote Control panel
		JPanel nrpcPanel = new JPanel();
		nrpcPanel.setLayout(new BorderLayout());
		TitledBorder nrpcPaneEdge = BorderFactory.createTitledBorder("Remote Control");
		nrpcPanel.setBorder(nrpcPaneEdge);
		cPanel = new rpcPanel(MainClass.mainFrame, app, nodeID, actionLog);
		cPanel.setTControlPanelDialog(this);
		nrpcPanel.add("Center", cPanel);
		layout = new GridBagLayout();
		getContentPane().setLayout(layout);
		constraints = new GridBagConstraints();
		constraints.fill = GridBagConstraints.HORIZONTAL;
		addComponent(nrpcPanel, 0, 0, 1, 3);
		//addComponent(progPanel, 4, 0, 1, 2);
		constraints.fill = GridBagConstraints.BOTH;
		constraints.weightx = 1000;
		constraints.weighty = 100;
		addComponent(logPanel, 6, 0, 1, 7);



		addWindowListener(new java.awt.event.WindowAdapter() {
			public void windowClosed(WindowEvent e) {
	            this_windowClosed(e);

			}
		});
	}


	//Andy 8/1/2008
	protected JRootPane createRootPane() {
		    ActionListener actionListener = new ActionListener() {
		      public void actionPerformed(ActionEvent actionEvent) {
		        dispose();
		      }
		    };
		    JRootPane rootPane = new JRootPane();
		    KeyStroke stroke = KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0);
		    rootPane.registerKeyboardAction(actionListener, stroke, JComponent.WHEN_IN_FOCUSED_WINDOW);
		    return rootPane;
		  }
	//8/1/2008 End
	
	
	//8/6/2007
	private void addComponent(Component component, 
		                      int row, int column, int width, int height)
	{
		constraints.gridx = column;
		constraints.gridy = row;
		constraints.gridwidth = width;
		constraints.gridheight = height;
		layout.setConstraints(component, constraints);
		getContentPane().add(component);
	}


	void this_windowClosed(WindowEvent e) {
		try{
			MainFrame.menuItemSendRPC.setEnabled(true);
			app.comm.receiveComm.deregisterListener(OasisConstants.NW_RPCR, cPanel.listener);
			if (nodeID.size() != 1 || singlenode == true) {
				for (int i = 0 ; i <nodeID.size(); i++){
					int moteNo = Integer.parseInt(nodeID.get(i).toString());
					DisplayManager.NodeInfo nodeInfo = 
						 (DisplayManager.NodeInfo)DisplayManager.
						         proprietaryNodeInfo.get(new Integer(moteNo));
					nodeInfo.SetDialogShowing (false);
				
					//Change the color of focusnode back
					MainFrame.focusedNode = null;
				}
			}
		}
		catch (Exception ex){}
	}

	class SymAction implements java.awt.event.ActionListener
	{
		public void actionPerformed(java.awt.event.ActionEvent event)
		{
			Object object = event.getSource();
		}

	}

	class SymChange implements javax.swing.event.ChangeListener
	{
		public void stateChanged(javax.swing.event.ChangeEvent event)
		{
			Object object = event.getSource();
			//deal with changes
		}
	}


	
}
