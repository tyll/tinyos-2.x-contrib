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


import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;
import java.util.Date;

/*
	This class is the main class, and is the only one that
	should be called by the final user.
	All the panels are created and added into a JFrame. The
	threads are also created and started.
	
	TODO :
*/
public class OctopusGui extends JFrame implements WindowListener {
	private static MoteIF gateway;
	private static MoteDatabase moteDatabase;
	private static ConsolePanel consolePanel;
	private static RequestPanel requestPanel;
	private static MapPanel mapPanel;
	private static ChartPanel chartPanel;
	private static LegendPanel legendPanel;
	private static Logger logger;
	private static MsgSender sender;
	
	private static OctopusGui frame = new OctopusGui("Octopus");

	public OctopusGui (String s) { super(s);}
	
	private static void createAndShowGUI() {
		
		gateway = new MoteIF();
		if (gateway == null) {
			Util.debug("gateway returned null");
			System.exit(-1);
		}
		consolePanel = new ConsolePanel();
		logger = new Logger();
		moteDatabase = new MoteDatabase(consolePanel);
		chartPanel = new ChartPanel();
		sender = new MsgSender(gateway, consolePanel);
		requestPanel = new RequestPanel(moteDatabase, chartPanel, sender);
		mapPanel = new MapPanel(moteDatabase, requestPanel);
		legendPanel = new LegendPanel(mapPanel, logger);
		Thread scout = new Thread(new Scout(gateway, moteDatabase, consolePanel, 
			mapPanel, requestPanel, logger, chartPanel, sender));
		
		JTabbedPane rightTabbedPanel = new JTabbedPane();
		rightTabbedPanel.addTab("Requests", null, requestPanel,
                  "Send requests over the network");
		JTabbedPane leftTabbedPanel = new JTabbedPane();
		leftTabbedPanel.addTab("Network Map", null, mapPanel,
                  "Display a map of the network");
		leftTabbedPanel.addTab("Network Chart", null, chartPanel,
                  "Display a chart of the sensor values of the network");
		rightTabbedPanel.addTab("Legend", null, legendPanel,
                  "Choose how to display the network");
		
		frame.getContentPane().setLayout(new GridBagLayout());
		GridBagConstraints c = new GridBagConstraints();
		c.insets = new Insets(5,5,5,5);
		c.fill = GridBagConstraints.BOTH; c.weighty = 1; c.weightx = 1;
		c.gridx = 0; c.gridy = 0; c.gridwidth = 1; c.gridheight = 1; c.anchor = GridBagConstraints.FIRST_LINE_START;
		frame.getContentPane().add(leftTabbedPanel, c);
		leftTabbedPanel.setPreferredSize(new Dimension(600,100));
		
		c.fill = GridBagConstraints.HORIZONTAL; c.weighty = 0; c.weightx = 1;
		c.gridx = 0; c.gridy = 1; c.gridwidth = 1; c.anchor = GridBagConstraints.LAST_LINE_START;
		frame.getContentPane().add(consolePanel, c);
		
		c.fill = GridBagConstraints.VERTICAL; c.weighty = 1; c.weightx = 0;
		c.gridx = 1; c.gridy = 0; c.gridheight = 2; c.anchor = GridBagConstraints.LINE_END;
		frame.getContentPane().add(rightTabbedPanel, c);
		
        scout.start();
		sender.start();
		
        //Display the window.
		try { // Set System L&F
			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());			// System Theme
			//UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());	// Metal Theme
			//UIManager.setLookAndFeel("com.sun.java.swing.plaf.motif.MotifLookAndFeel");
		} catch (Exception e) { e.printStackTrace();}
		frame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
		SwingUtilities.updateComponentTreeUI(frame);
        frame.pack();
        frame.setVisible(true);
		frame.addWindowListener(frame);
    }
	
	public void windowOpened(WindowEvent e) {}
	public void windowClosing(WindowEvent e) {
		logger.stopLogging();
		Util.debug("Closing Octopus ...");
		frame.dispose();
		System.exit(0);
	}
	public void windowClosed(WindowEvent e) {}
	public void windowIconified(WindowEvent e) {}
	public void windowDeiconified(WindowEvent e) {}
	public void windowActivated(WindowEvent e) {}
	public void windowDeactivated(WindowEvent e) {}

    /* Just start the app... */
	public static void main(String[] args) {
        //Schedule a job for the event-dispatching thread:
        //creating and showing this application's GUI.
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                createAndShowGUI();
            }
        });
    }

}
