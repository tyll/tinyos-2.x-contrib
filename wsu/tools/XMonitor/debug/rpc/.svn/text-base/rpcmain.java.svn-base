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
 * This is the main class from where "main" is run.
 *
 * It remotely controls nodes in the WSN through RPC mechanism 
 * 1. Remote procudure calls
 * 2. RamSymbles inquiry and adjustment
 *
 * Note: refer to Marionette (designed by UCB) in python
 *
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package debug.rpc;

import Config.*;

import net.tinyos.util.*;
import net.tinyos.message.*;

import java.util.*;
import javax.swing.event.*;
import java.awt.event.*;
import java.beans.*;
import java.awt.*;
import java.io.*;
import javax.swing.*;
import javax.swing.border.TitledBorder;

public class rpcmain {
    static public JFrame mainFrame;
	public debug.rpc.rpcPanel panel;
	public JPanel log;
	static public JTextArea actionLog;
	
	//Xml file setting
	public static String XmlPath = ""; //null;
	public static NescApp app;
	Vector moteList = new Vector();

    public rpcmain(MoteIF m) { 
		super();
		OasisConstants oasisConstants = new OasisConstants();
		mainFrame = new JFrame("Sensorweb Remote Control");
		mainFrame.setSize(getSize());
		mainFrame.setIconImage(new ImageIcon(OasisConstants.IconFile).getImage());
		XmlPath = OasisConstants.XMLPath;
		System.out.println(XmlPath);
		//Set up NescApp for rpc
		app = new NescApp(XmlPath, m);

		//RPC Log SubPanel
		log = new JPanel();
		TitledBorder paneEdge = BorderFactory.createTitledBorder("Action & Response :");
		log.setBorder(paneEdge);
		log.setLayout(new BorderLayout());
		
		actionLog = new JTextArea(" ",3,3);
		actionLog.setEditable(false);
		log.add(actionLog);
		log.add(new JScrollPane(actionLog), BorderLayout.CENTER);

		moteList.add(new Integer(OasisConstants.ALL_NODES));
		panel = new debug.rpc.rpcPanel(mainFrame, app, moteList, actionLog);

		mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);	
		mainFrame.getContentPane().add("North", new JScrollPane(panel));
		mainFrame.getContentPane().add("Center", new JScrollPane(log));
		mainFrame.show();
		mainFrame.repaint(1000);

		mainFrame.addWindowListener(new WindowAdapter(){
										 public void windowClosing( WindowEvent wevent ){
											System.exit(0);
										 }
									 });
    }

    public rpcmain() { 
		this(new MoteIF((Messenger)null));
    }


    public static void main(String[] args) throws IOException {
		rpcmain rpcapp;
	    try {
		rpcapp = new rpcmain();

		} catch (Exception e) {
		  System.err.println("main() got exception: "+e);
		  e.printStackTrace();
		  System.exit(-1);
		}
    }

	
    public Dimension getSize()
	{
		return new Dimension(700, 500);
    }


}

