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
 * @author Bret Hull
 * @author David Gay
 */

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;
import java.util.ArrayList;

public class CameraGUI implements MessageListener, Messenger {
    MoteIF mote; 		// For talking to the antitheft root node

    /* Various swing components we need to use after initialisation */
    JFrame frame;		// The whole frame
    JTextArea mssgArea;		// The message area
    JTextField fieldInterval;	// The requested check interval

    /* The checkboxes for the requested settings */
    JCheckBox clearAfterSave, isColor, saveBytes;

    public CameraGUI(boolean connect) {
	    try {
	    	guiInit();
		}
		catch(Exception e) {
		    e.printStackTrace();
		    System.exit(2);
		}
		if (!connect)
			return;
		
		try {
		    /* Setup communication with the mote and request a messageReceived
		       callback when an AlertMsg is received */
		    mote = new MoteIF(this);
		    mote.registerListener(new Frame_partMsg(), this);
		}
		catch(Exception e) {
		    e.printStackTrace();
		    System.exit(2);
		}
    }

    /* Build up the GUI using Swing magic. Nothing very exciting here - the
       BagPanel class makes the code a bit cleaner/easier to read. */
    private void guiInit() throws Exception {
	JPanel mainPanel = new JPanel(new BorderLayout());
	mainPanel.setMinimumSize(new Dimension(500, 250));
	mainPanel.setPreferredSize(new Dimension(500, 300));

	/* The message area */
	JScrollPane mssgPanel = new JScrollPane();
	mssgPanel.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
	mssgPanel.setAutoscrolls(true);
	mssgArea = new JTextArea();
	mssgArea.setFont(new java.awt.Font("Monospaced", Font.PLAIN, 20));
	mainPanel.add(mssgPanel, BorderLayout.CENTER);
	mssgPanel.getViewport().add(mssgArea, null);
	
	/* The button area */
	BagPanel buttonPanel = new BagPanel();
	GridBagConstraints c = buttonPanel.c;

	c.fill = GridBagConstraints.HORIZONTAL;
	c.gridwidth = GridBagConstraints.REMAINDER;

	buttonPanel.makeLabel("Controls", JLabel.CENTER);
	c.gridwidth = GridBagConstraints.RELATIVE;
	clearAfterSave = buttonPanel.makeCheckBox("Clear", false);
	c.gridwidth = GridBagConstraints.REMAINDER;
	isColor = buttonPanel.makeCheckBox("Color", false);
	c.gridwidth = GridBagConstraints.REMAINDER;
	saveBytes = buttonPanel.makeCheckBox("Save Bytes Only", false);
	buttonPanel.makeSeparator(SwingConstants.HORIZONTAL);

	buttonPanel.makeLabel("Interval", JLabel.CENTER);
	fieldInterval = buttonPanel.makeTextField(10, null);
	fieldInterval.setText(Integer.toString(0));

	ActionListener settingsAction = new ActionListener() {
		public void actionPerformed(ActionEvent e) {
		    save();
		}
	    };
	buttonPanel.makeButton("Save", settingsAction);

	mainPanel.add(buttonPanel, BorderLayout.EAST);

	/* The frame part */
	frame = new JFrame("CameraGUI");
	frame.setSize(mainPanel.getPreferredSize());
	frame.getContentPane().add(mainPanel);
	frame.setVisible(true);
	frame.addWindowListener(new WindowAdapter() {
		public void windowClosing(WindowEvent e) { System.exit(0); }
	    });
    }

    /* Add a message to the message area, auto-scroll to end */
    public synchronized void message(String s) {
	mssgArea.append(s + "\n");
	mssgArea.setCaretPosition(mssgArea.getDocument().getLength());
    }

    /* Popup an error message */
    void error(String msg) {
	JOptionPane.showMessageDialog(frame, msg, "Error",
				      JOptionPane.ERROR_MESSAGE);
    }

    final static int MAX_X = 320;
    final static int MAX_Y = 240;
    
    ArrayList<short[]> data = new ArrayList<short[]>();
    boolean is_picture_color = false;
    
    public void save(){
    	is_picture_color = isColor.isSelected();
    	try{
	    	String file_name = "C:\\cygwin\\tmp\\picture_" + System.currentTimeMillis();
	    	OutputStreamWriter writer = null;
	    	String pgmHeader =  "P2\r\n" +
	    						MAX_X+" "+MAX_Y+"\r\n"+
	        					"255\r\n";
	    	String ppmHeader =  "P3\r\n" +
	    						MAX_X+" "+MAX_Y+"\r\n"+
								"63\r\n";
	    		
	    	if (saveBytes.isSelected())
	    	{
	    		writer = new OutputStreamWriter(new FileOutputStream(file_name+".bytes"));
	    	}
	    	else
	    	{
		    	if (!is_picture_color)
		    	{
		    		writer = new OutputStreamWriter(new FileOutputStream(file_name+".pgm"));
		    		writer.write(pgmHeader);
		    	}
		    	else
		    	{
		    		writer = new OutputStreamWriter(new FileOutputStream(file_name+".ppm"));
		    		writer.write(ppmHeader);
		    	}
	    	}
	    	
	        int cnt_row=1;
	        int red_byte=0;
	        int blue_byte = 0;
	        int green_byte = 0;
	        
	        boolean is_first_byte = true;
	        for (int i=0; i<data.size(); i++)
	        	for (int j=0; j<64; j++){
	        		int curr_byte = (data.get(i)[j]&0xFF); 
	        		
	        		//writerAll.write((curr_byte&0xFF)+" ");

	    	    	if (saveBytes.isSelected())
        				writer.write((curr_byte&0xFF)+" ");
	    	    	else if (!is_picture_color){
        				writer.write((curr_byte&0xFF)+" ");
		        		if (++cnt_row >= MAX_X){
		        			cnt_row = 0;
		        			writer.write("\r\n");
		        		}
        			}
        			else
        			{

		        		if (is_first_byte){
		        			is_first_byte = false;
		        			blue_byte = (curr_byte & 0x1F);
		        			green_byte = (curr_byte & 0xE0);
		        			green_byte = (green_byte >> 5);
		        		}
		        		else{
		        			red_byte = (curr_byte >> 3);
		        			int green_byte_tmp = (curr_byte & 0x7);
		        			green_byte_tmp <<= 3;
		        			green_byte |= green_byte_tmp;
		        			
		        			//red_byte <<=1;
		        			//blue_byte <<=1;
		        			green_byte >>= 1;
	        				if (is_picture_color)
	        				{
	        					writer.write((red_byte&0xFF)+" "+(green_byte&0xFF)+" "+(blue_byte&0xFF)+" ");
		        				if (++cnt_row >= MAX_X){
				        			cnt_row = 0;
				        			writer.write("\r\n");
				        		}
	        				}
			        		is_first_byte = true;
		        		}
        			}
	        	}
	        writer.flush();
	        writer.close();
    	}
    	catch(Exception e){System.out.println(e);}
    	
        if (clearAfterSave.isSelected()){
	        data = new ArrayList<short[]>();
        }
    }
    
    /* Message received from mote network. Update message area if it's
       a theft message. */
    
    public void messageReceived(int dest_addr, Message msg) {
		if (msg instanceof Frame_partMsg) {
		    Frame_partMsg fpMsg = (Frame_partMsg)msg;
		    String str = "Msg ID " + fpMsg.get_part_id();
		    while (fpMsg.get_part_id()>=data.size())
		    	data.add(data.size(),new short[64]);
		    	
		    data.add(fpMsg.get_part_id(), fpMsg.get_buf());
			message(str);
		}
    }
    
    public void load(String filename){
    	try{
    		BufferedReader r = new BufferedReader(new FileReader(filename));
    		String line = r.readLine();//header line 1
    		line = r.readLine();//header line 2
    		line = r.readLine();//header line 3
    		line = r.readLine();//header line 4
    		line = r.readLine();
			int i=0, j=0;
			short[] values = new short[64];
    		while (line != null) 
    		{
    			java.util.StringTokenizer t = new java.util.StringTokenizer(line);
    			while (t.hasMoreTokens())
    			{
        			String id_str = t.nextToken();
	    			if (id_str.length() != 0)
	    			{
	    				values[i++]=Short.parseShort(id_str);
	    				if (i==64)
	    				{
						    Frame_partMsg fpMsg = new Frame_partMsg();
						    fpMsg.set_part_id(j);
						    fpMsg.set_buf(values);
						    this.messageReceived(0, fpMsg);
							i=0;
							j++;
							values = new short[64];
	    				}
	    			}
    			}
	    		line = r.readLine();
    		}
    	}catch(Exception e){System.out.println("CameraGUI.load():"+e.toString());}
    	
    }

    /* Just start the app... */
    public static void main(String[] args) {
    	CameraGUI me = new CameraGUI(true);
    	//me.load("c:\\cygwin\\tmp\\results\\captured_bytes.ppm");
    	//me.load("c:\\cygwin\\tmp\\c.ppm");
    }
}
