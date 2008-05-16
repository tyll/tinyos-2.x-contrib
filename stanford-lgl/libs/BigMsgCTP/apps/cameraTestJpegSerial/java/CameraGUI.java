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
 * @author Brano Kusy
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
    JCheckBox clearAfterSave, isColor, isCompression;

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
		    System.out.print("connecting to serial forwarder: failed");
		    mote = new MoteIF(this);
			System.out.println("\b\b\b\b\b\bok    ");
		    mote.registerListener(new Bigmsg_frame_partMsg(), this);
		    mote.registerListener(new ImgStatMsg(), this);
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
	isColor = buttonPanel.makeCheckBox("Color Image", false);
	c.fill = GridBagConstraints.HORIZONTAL;
	c.gridwidth = GridBagConstraints.REMAINDER;
	isCompression = buttonPanel.makeCheckBox("Jpeg", false);
	c.fill = GridBagConstraints.HORIZONTAL;
	c.gridwidth = GridBagConstraints.REMAINDER;
	ActionListener getImageAction = new ActionListener() {
		public void actionPerformed(ActionEvent e) {
		    getImage();
		}
	    };
	buttonPanel.makeButton("Get Image", getImageAction);

	clearAfterSave = new JCheckBox(); clearAfterSave.setSelected(true);
				   //buttonPanel.makeCheckBox("Clear", true);

	buttonPanel.makeSeparator(SwingConstants.HORIZONTAL);

	buttonPanel.makeLabel("Saved File Name:", JLabel.CENTER);
	fieldInterval = buttonPanel.makeTextField(10, null);
	fieldInterval.setText("c:\\tmp\\imote2\\");

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
    
    long currentTime;
    
    public void getImage() { 
    	currentTime=System.currentTimeMillis();
		CmdMsg smsg = new CmdMsg();
	
		/* Build and send command message */
		if (     !isColor.isSelected() && !isCompression.isSelected())
		    smsg.set_cmd((short)0);
		else if ( isColor.isSelected() && !isCompression.isSelected())
		    smsg.set_cmd((short)1);
		else if (!isColor.isSelected() && isCompression.isSelected())
		    smsg.set_cmd((short)2);
		else if ( isColor.isSelected() && isCompression.isSelected())
		    smsg.set_cmd((short)3);
		try {
		    mote.send(MoteIF.TOS_BCAST_ADDR, smsg);
		}
		catch (IOException e) {
		    error("Cannot send message to mote");
		}
    }

    public void save(){
    	try{
	    	String file_name;
			file_name = fieldInterval.getText()+"picture_" + System.currentTimeMillis();
	    	if (isCompression.isSelected())
	    		file_name += ".bytes";
	    	else if (!isColor.isSelected())
				file_name += ".pgm";
	    	else
	    		file_name += ".ppm";
		    FileOutputStream fostr=null;
			try{
				fostr=new FileOutputStream(file_name);
			}
			catch (Exception e){
				message("Can't write "+file_name+" file!\nMake sure the dir exists!\n");
				return;
			};
				
			
    		DataOutputStream stream = null;
    		OutputStreamWriter writer = null;
	    	String pgmHeader =  "P2\r\n" +
	    						MAX_X+" "+MAX_Y+"\r\n"+
	        					"255\r\n";
	    	String ppmHeader =  "P3\r\n" +
	    						MAX_X+" "+MAX_Y+"\r\n"+
								"63\r\n";
	    		
	    	if (isCompression.isSelected())
	    		stream = new DataOutputStream(fostr);
	    	else
	    	{
	    		writer = new OutputStreamWriter(fostr);
		    	if (!isColor.isSelected())
		    		writer.write(pgmHeader);
		    	else
		    		writer.write(ppmHeader);
	    	}
	    	
	        int cnt_row=1;
	        int red_byte=0;
	        int blue_byte = 0;
	        int green_byte = 0;
	        
	        boolean is_first_byte = true;
	        for (int i=0; i<data.size(); i++)
	        	for (int j=0; j<64; j++){
	        		int curr_byte = 0;
	        		
	        		if (j<data.get(i).length)
	        			curr_byte=(data.get(i)[j]&0xFF);
	        		else if ( i==data.size()-1 )
	        			break;
	        		
	    	    	if (isCompression.isSelected()){
	    	    		stream.writeByte(curr_byte);
	    	    	}
	    	    	else if (!isColor.isSelected()){
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
        					writer.write((red_byte&0xFF)+" "+(green_byte&0xFF)+" "+(blue_byte&0xFF)+" ");
	        				if (++cnt_row >= MAX_X){
			        			cnt_row = 0;
			        			writer.write("\r\n");
			        		}
			        		is_first_byte = true;
		        		}
        			}
	        	}
	        
	    	if (isCompression.isSelected()){
	    		stream.flush();
	    		stream.close();
	    	}
	    	else
	    	{
	    		writer.flush();
	    		writer.close();
	    	}
			message("Saved "+file_name+"file and cleared data structures.\nReady for the next img.");
    	}
    	catch(Exception e){System.out.println(e);}
    	
        if (clearAfterSave.isSelected()){
	        data = new ArrayList<short[]>();
        }
    }
    
    /* Message received from mote network. Update message area if it's
       a theft message. */
    
    short []getMsgBuf(Bigmsg_frame_partMsg msg)
    {
    	int length =	msg.dataLength()-Bigmsg_frame_partMsg.offset_buf(0);
        short[] tmp = new short[length];
        for (int index0 = 0; index0 < length; index0++)
            tmp[index0] = msg.getElement_buf(index0);
        return tmp;
    }
    
    public void messageReceived(int dest_addr, Message msg) {
		if (msg instanceof Bigmsg_frame_partMsg) {
			Bigmsg_frame_partMsg fpMsg = (Bigmsg_frame_partMsg)msg;
		    if (fpMsg.get_part_id()%50==0)
		    	message("Msg ID " + fpMsg.get_part_id());
		    while (fpMsg.get_part_id()>=data.size())
		    	data.add(data.size(),new short[0]);
		    data.set(fpMsg.get_part_id(), getMsgBuf(fpMsg));
		}
		else if (msg instanceof ImgStatMsg) 
		{
			ImgStatMsg isMsg = (ImgStatMsg)msg;
			message("Image capture stats:");
			message("  timeAcq: "+isMsg.get_timeAcq()+
					"\t timeProc: "+isMsg.get_timeProc());
			message("  img type: "+isMsg.get_type());
			message("  img width: "+isMsg.get_width());
			message("  img height: "+isMsg.get_height());
			message("  img size: "+isMsg.get_data_size());
			message("time total: "+(isMsg.get_timeAcq()+isMsg.get_timeProc()));
			message("time java: "+(System.currentTimeMillis()-currentTime)+"\n");
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
	    					Bigmsg_frame_partMsg fpMsg = new Bigmsg_frame_partMsg();
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
