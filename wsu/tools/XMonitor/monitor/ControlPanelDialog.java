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

import SensorwebObject.Rpc.rpcPanel;
import java.awt.*;
import javax.swing.*;
import javax.swing.border.TitledBorder;

//import debug.rpc.rpcPanel;


//8/6/2007
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.Component;
import rpc.message.MoteIF;
import xml.Parser.XMLMessageParser;


public class ControlPanelDialog extends JFrame
{

	//public Vector nodeID;
	boolean singlenode;
	//public static NescApp app;

	public SensorwebObject.Rpc.rpcPanel  cPanel = null;

        public debug.rpc.rpcPanel dPanel = null;


        private MoteIF mote;
	//8/6/2007
	private GridBagLayout layout;
	private GridBagConstraints constraints;
	private JFrame main ;


	SymAction lSymAction = new SymAction();
	SymChange lSymChange = new SymChange();

    
   
	public ControlPanelDialog(  XMLMessageParser xmp,MoteIF mote)
	{

		//mote = _mote;

		//nodeID = _nodeID;
		//this.main = main;
                this.mote = mote;
		//System.err.println("controlpaneldialog");
		JPanel logPanel = new JPanel();
		TitledBorder paneEdge = BorderFactory.createTitledBorder("Action & Response :");
		logPanel.setBorder(paneEdge);
		logPanel.setLayout(new BorderLayout());
                logPanel.setVisible(true);


		JTextArea actionLog = new JTextArea(" ",30,60);
		actionLog.setEditable(false);
		logPanel.add(actionLog);
		logPanel.add(new JScrollPane(actionLog), BorderLayout.CENTER);

		//Add Remote Control panel
		JPanel nrpcPanel = new JPanel();
		nrpcPanel.setLayout(new BorderLayout());
		TitledBorder nrpcPaneEdge = BorderFactory.createTitledBorder("Remote Control");
		nrpcPanel.setBorder(nrpcPaneEdge);
		cPanel = new rpcPanel(xmp, mote,actionLog, this.main);
		cPanel.setControlPanelDialog(this);
		nrpcPanel.add("Center", cPanel);
		
		//Set layout
		layout = new GridBagLayout();
		setLayout(layout);
		constraints = new GridBagConstraints();
		constraints.fill = GridBagConstraints.HORIZONTAL;
		addComponent(nrpcPanel, 0, 0, 1, 3);
		//addComponent(progPanel, 4, 0, 1, 2);
		constraints.fill = GridBagConstraints.BOTH;
		constraints.weightx = 1000;
		constraints.weighty = 100;

		addComponent(logPanel, 6, 0, 1, 7);
        
	}



	//8/6/2007
	private void addComponent(Component component,
		                      int row, int column, int width, int height)
	{
		constraints.gridx = column;
		constraints.gridy = row;
		constraints.gridwidth = width;
		constraints.gridheight = height;
		layout.setConstraints(component, constraints);
		add(component);
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

	public void makeRPC_Panel(int width, int height) {
		// TODO Auto-generated method stub

	}



}
