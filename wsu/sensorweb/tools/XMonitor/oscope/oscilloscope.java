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
 * It simulates the function of a oscilloscope to display received data message.
 * It watches NM_DATA message defined in OasisType.h
 *
 * Original version by:
 *    @author Jason Hill and Eric Heien
 * Modified by:
 *    @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package oscope;



import Config.OasisConstants;
import java.io.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import monitor.MainClass;
import rpc.message.MoteIF;

public class oscilloscope {

    JFrame mainFrame;
    GraphPanel panel;
    ControlPanel controlPanel;
    ScopeDriver driver;
    JPanel contentPane;

    public oscilloscope(MoteIF m) { 
		super();
		mainFrame = new JFrame("Sensorweb Data Display");
		contentPane = new JPanel(new BorderLayout());
		panel = new GraphPanel(); 
		controlPanel = new ControlPanel(panel);
		driver = new ScopeDriver(m, panel);
		controlPanel.setScopeDriver(driver);
		contentPane.add("Center", panel); 
		contentPane.add("South", controlPanel); 
		
		mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);	
		mainFrame.setSize(java.awt.Toolkit.getDefaultToolkit().getScreenSize());
		//mainFrame.setExtendedState(java.awt.Frame.MAXIMIZED_BOTH);

		mainFrame.setIconImage(new ImageIcon(OasisConstants.IconFile).getImage());
		mainFrame.getContentPane().add("Center", new JScrollPane(contentPane));
		//mainFrame.show();
		mainFrame.setVisible(true);
		
		mainFrame.addWindowListener
			(
			 new WindowAdapter()
			 {
				 public void windowClosing    ( WindowEvent wevent )
				 {
				 System.exit(0);
				 }
			 }
			 );
    }

    public oscilloscope() { 
		this(new MoteIF(MainClass.xmp));
    }


    public static void main(String[] args) throws IOException {
		oscilloscope app;
		try {
			app = new oscilloscope();
		} catch (Exception e) {
		  System.err.println("main() got exception: "+e);
		  e.printStackTrace();
		  System.exit(-1);
		}
	
    }

}

