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

package gui;

/**
 * @author Brano Kusy
 */

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;

import message.*;
import net.tinyos.message.*;
import net.tinyos.util.*;
import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

public class CameraGUI implements MessageListener, Messenger {
	
	//CONTROL VARIABLES
	boolean TEST=true;
	boolean PSNR=false;
	String img_path = "src/pictures/"; //where video frames and images will be saved
	String testFilePath="src/tests/"; //path where test logs will be saved. Be sure it exists!
	
    MoteIF mote; 		// For talking to the antitheft root node
    int BUFFER_SIZE=30;
    int START_READING=5;
    int DPCM_SEQ=20;
    int REP_TIME=500;
    int BUF_REFILLING_DIST=2;
    int FULL_FRAME_PERIOD=240;
    int PAYLOAD_LENGTH=40; // buffer length in photo messages
         /* Various swing components we need to use after initialization */
    JFrame frame;		// The whole frame
    JTextArea mssgArea;		// The message area
    JPanel mainPanel;
     //JTextField fieldInterval;	// The requested check interval
    
    int frameNum=0;
    int lastFrame=0;
    DisplayThread displayThread=null;
    ReceiverThread receiverThread=null;
    JFrame jFrame=null;
    int bufferCounter=0;
    String frameName=null;
    boolean threadRunning=false;
    private String[] frameBuffer=null;
    Thread dspTh=null;
    Thread rcvTh=null;
    // buffer check variables
    String lastPath=null;
    int readPos=0;
    int lastWrite=0;
    private boolean bufferReady=true;
    int diff=0;
	float perc;
	boolean threadStop=false;
	int photoLastPartId;
	boolean exitVar=false;
	int imgCounter=0;
	TimerTask dynTask;
	Timer timer;
	int deltaPercentage;
	double oldPerc;
	
	//PSNR
	double mse=0;
	double psnr=0;
	double avg_psnr=0;
	int count=0;
	
    //listeners
	Bigmsg_frame_partMsg bigMsgListener;
	Video_frame_partMsg videoMsgListener;
    ImgStatMsg imgStatListener;
    TimeTestMessage timeTestListener;
    PktTestMessage pktTestListener;
    QueueTestMessage queueTestListener;
    
    //test var
    long startTime=0;
    long stopTime=0;
    long simTime=0;
    long decompressionTime=0;
    String videoTestFile=null;
    String photoTestFile=null;
    long acquireTime=0;
    long processTime=0;
    long sendingTime=0;
    long photoSize=0;
    long sampleNum=0;
    long cameraPauseTime=0;
    ArrayList<Integer> bsQueue=new ArrayList<Integer>();
    ArrayList<Integer> bsDelta=new ArrayList<Integer>();
    ArrayList<Integer> iNodeTxPause=new ArrayList<Integer>();
    ArrayList<Integer> iNodeQueue=new ArrayList<Integer>();
    ArrayList<Integer> iNodeDelta=new ArrayList<Integer>();    
    Writer testFileWriter=null;
    int packetsLost=0;
    long bufferFillingTime=0;
    
	//file di log
	static PrintStream p_psnr;
	
	ArrayDelayAndFrameLoss arrayTest;
    
    
    /* The checkboxes for the requested settings */
    JCheckBox clearAfterSave, isColor, isVga, isJpeg,isDpcm, isDecompression;

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
	
	FileOutputStream fos_psnr = null;
	
	if (PSNR) {
		
		try {
			fos_psnr = new FileOutputStream(testFilePath+"psnr.txt",true);	
		} catch (FileNotFoundException e2) {
			e2.printStackTrace();
		}
		p_psnr = new PrintStream(fos_psnr);
	}	

	try {
	    /* Setup communication with the mote and request a messageReceived
	       callback when an AlertMsg is received */
		
	    
	    mote = new MoteIF(this);
	    System.out.println("Connecting to serial forwarder: ok");
	    bigMsgListener=new Bigmsg_frame_partMsg();
		videoMsgListener=new Video_frame_partMsg();
	    imgStatListener=new ImgStatMsg();
	    timeTestListener=new TimeTestMessage();
	    pktTestListener= new PktTestMessage();
	    queueTestListener= new QueueTestMessage();
	    photoLastPartId=255;
	    
	}
	catch(Exception e) {
	    error("connecting to serial forwarder");
	}
	
	arrayTest = new ArrayDelayAndFrameLoss();
	
    }

    /* Build up the GUI using Swing magic. Nothing very exciting here - the
       BagPanel class makes the code a bit cleaner/easier to read. */
    private void guiInit() throws Exception {
    
    mainPanel = new JPanel(new BorderLayout());
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
	isVga = buttonPanel.makeCheckBox("VGA", false);
	c.fill = GridBagConstraints.HORIZONTAL;
	c.gridwidth = GridBagConstraints.REMAINDER;
	isJpeg = buttonPanel.makeCheckBox("Jpeg", false);
	c.fill = GridBagConstraints.HORIZONTAL;
	c.gridwidth = GridBagConstraints.REMAINDER;
	isDecompression = buttonPanel.makeCheckBox("Decompress", false);	
	c.fill = GridBagConstraints.HORIZONTAL;
	c.gridwidth = GridBagConstraints.REMAINDER;
					   //buttonPanel.makeCheckBox("Clear", true);

	buttonPanel.makeSeparator(SwingConstants.HORIZONTAL);
	
	ActionListener getVideoAction = new ActionListener() {
		public void actionPerformed(ActionEvent e) {
			getVideo();
		 }
	    };
	buttonPanel.makeButton("Get Video", getVideoAction);

	clearAfterSave = new JCheckBox(); clearAfterSave.setSelected(true);
	
	ActionListener stopVideoAction = new ActionListener() {
		public void actionPerformed(ActionEvent e) {
		    stopVideo();
		}
	    };
	buttonPanel.makeButton("Stop Video", stopVideoAction);

	clearAfterSave = new JCheckBox(); clearAfterSave.setSelected(true);
				   //buttonPanel.makeCheckBox("Clear", true);
	
	ActionListener getImageAction = new ActionListener() {
		public void actionPerformed(ActionEvent e) {
		    getImage();
		}
	    };
	buttonPanel.makeButton("Get Image", getImageAction);
	clearAfterSave = new JCheckBox(); clearAfterSave.setSelected(true);

	buttonPanel.makeSeparator(SwingConstants.HORIZONTAL);
	
	ActionListener stopTestAction = new ActionListener() {
		public void actionPerformed(ActionEvent e) {
			stopTest();
		}
	    };
	buttonPanel.makeButton("Stop test", stopTestAction);
	clearAfterSave = new JCheckBox(); clearAfterSave.setSelected(true);

	buttonPanel.makeSeparator(SwingConstants.HORIZONTAL);
				   //buttonPanel.makeCheckBox("Clear", true);

//	buttonPanel.makeSeparator(SwingConstants.HORIZONTAL);

	//buttonPanel.makeLabel("Saved File Name:", JLabel.CENTER);
	//fieldInterval = buttonPanel.makeTextField(10, null);
	//fieldInterval.setText("src/pictures/");

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

    int max_x;
    int max_y;
    
    ArrayList<short[]> data = new ArrayList<short[]>();
    
    

    // GET IMAGE FUNCTION
    
    public void getImage() {
    	
    //initialize test environment  
	    if(TEST){
	    	startTime = System.currentTimeMillis();
	    	videoTestFile=null;
	    	photoTestFile=testFilePath+"photo_"+startTime+".txt";
	    	 try {
	    			testFileWriter = new OutputStreamWriter(new FileOutputStream(photoTestFile),"UTF-8");
	    		} catch (UnsupportedEncodingException e1) {
	    			// TODO Auto-generated catch block
	    			e1.printStackTrace();
	    		} catch (FileNotFoundException e1) {
	    			// TODO Auto-generated catch block
	    			e1.printStackTrace();
	    		}
	    	bsQueue=new ArrayList<Integer>();
	    	bsDelta=new ArrayList<Integer>();
	    	iNodeTxPause=new ArrayList<Integer>();
	    	iNodeQueue=new ArrayList<Integer>();
	    	iNodeDelta=new ArrayList<Integer>();
	    	try{
	    		mote.deregisterListener(timeTestListener, this);
	    	}catch(IllegalArgumentException e){
	    	    	//System.out.println("Catched-bigmsg on getphoto");
	    	}
	    	  try{
	    		  mote.deregisterListener(pktTestListener, this);
	    	}catch(IllegalArgumentException e){
    	    	//System.out.println("Catched-bigmsg on getphoto");
    	    }
	    	try{
	    		mote.deregisterListener(queueTestListener, this);
	    	} catch(IllegalArgumentException e){
    	    	//System.out.println("Catched-bigmsg on getphoto");
    	    }
	    	mote.registerListener(timeTestListener, this);
	    	mote.registerListener(pktTestListener, this);
	    	mote.registerListener(queueTestListener, this);
	}
	   
    // initialize received photo samples   
    sampleNum=0;
    
    // messages sent to the camera mote
	CmdMsg smsg = new CmdMsg();
	int cs = 0;
	
    try{
    	mote.deregisterListener(bigMsgListener, this);
    }
    catch(IllegalArgumentException e){
    	//System.out.println("Catched-bigmsg on getphoto");
    }
    try{
    	mote.deregisterListener(videoMsgListener, this);
    }
    catch(IllegalArgumentException e){
    	//System.out.println("Catched-video on getphoto");
    }
    try{
    	mote.deregisterListener(imgStatListener, this);
    }
    catch(IllegalArgumentException e){
    	//System.out.println("Catched-imgstat on getphoto");
    }
	mote.registerListener(bigMsgListener, this);
    mote.registerListener(imgStatListener, this);
    //mote.registerListener(timerListener, this);
	
	/* Build and send command message */
	if (isColor.isSelected()) {
	    cs = cs | 0x01;
	}
	if (isVga.isSelected()) {
	    cs = cs | 0x02;
	    max_x = 640;
	    max_y = 480;
	} else {
	    max_x = 320;
	    max_y = 240;
	}
	if (isJpeg.isSelected()) {
	    cs = cs | 0x04;
	} else if (isDecompression.isSelected()) {
		message("Decompress funziona solo se è stata selezionata anche l'opzione JPEG\n");
	}
	
	
	smsg.set_cmd((short)cs);
	try {
	    mote.send(MoteIF.TOS_BCAST_ADDR, smsg);
	}
	catch (IOException e) {
	    error("Cannot send message to mote");
	}
    }
    
    //stop test button handler
    private void stopTest(){
    	try {
    	mote.deregisterListener(pktTestListener, this);
		mote.deregisterListener(timeTestListener, this);
		mote.deregisterListener(queueTestListener, this);
    	}
    	catch (IllegalArgumentException ex) {
    		error ("stopTest: test listeners are not registered.");
    	}
		if(testFileWriter != null) {
				try {
					testFileWriter.close();
				} catch (IOException e) {
					error("stopTest: test log does not exist");
				}
		}		
    	
    }
    
    //GET VIDEO FUNCTION
    
    public void getVideo() {
    
    	
    // initialize test environment	  
	if(TEST){
			try{
				mote.deregisterListener(timeTestListener, this);
		    }
		    catch(IllegalArgumentException e){
		    	//System.out.println("Catched-time test listener on getvideo");
		    }
		    try{
		    	mote.deregisterListener(pktTestListener, this);
		    }
		    catch(IllegalArgumentException e){
		    	//System.out.println("Catched-pkt test listener on getvideo");
		    }
		    try{
		    	mote.deregisterListener(queueTestListener, this);
		    }
		    catch(IllegalArgumentException e){
		    	//System.out.println("Catched-queue test listener");
		    }
	  	mote.registerListener(timeTestListener, this);
	   	mote.registerListener(pktTestListener, this);
	   	mote.registerListener(queueTestListener, this);
	   	
	   	//initialize test variables
	   	startTime = System.currentTimeMillis();
	    bufferFillingTime=-startTime;
	    videoTestFile=testFilePath+"video_"+startTime+".txt";
	    photoTestFile=null;
	    sampleNum=0;
	    
	    try {
	    	testFileWriter = new OutputStreamWriter(new FileOutputStream(videoTestFile),"UTF-8");
	    } catch (UnsupportedEncodingException e1) {
		// 	TODO Auto-generated catch block
	    	e1.printStackTrace();
	    } catch (FileNotFoundException e1) {
		// 	TODO Auto-generated catch block
	    	e1.printStackTrace();
	    }
	    try {
	    	testFileWriter.write("\n");
	    	testFileWriter.write("StartTime: "+startTime+"\n");
	    	
	    } catch (IOException e1) {
	    	// TODO Auto-generated catch block
	    	e1.printStackTrace();
	    }
    }//test
	
	
	
	CmdMsg smsg = new CmdMsg();
	int cs = 0;
	max_x = 320;
	max_y = 240;
	
	//be sure unused listener are disabled
	try{

		mote.deregisterListener(bigMsgListener, this);
	}
	catch(IllegalArgumentException e){
		//System.out.println("Catched-bigmsgList on start");
	}
	try{
		mote.deregisterListener(videoMsgListener, this);
	}
	catch(IllegalArgumentException e){
		//System.out.println("Catched-video on start");
	}
	try{
		mote.deregisterListener(imgStatListener, this);
    }
    catch(IllegalArgumentException e){
    	//System.out.println("Catched-time test listener on getvideo");
    }
	if (PSNR) {
		 
		mote.registerListener(imgStatListener, this);
		
	}
	
    
	lastPath=null;
	readPos=0;
	lastWrite=0;
	bufferReady=true;
	diff=0;
	perc=0;
	threadStop=false;

	bufferCounter=0;
	threadStop=false;
	frameBuffer=new String[BUFFER_SIZE];
	
	//start the receiver and the display thread
	receiverThread=new ReceiverThread(this,mssgArea,mote,BUFFER_SIZE,START_READING,videoMsgListener,
							imgStatListener,DPCM_SEQ,videoTestFile,arrayTest,TEST,testFilePath);
	rcvTh=new Thread(receiverThread);
	displayThread=new DisplayThread(this,rcvTh,BUFFER_SIZE,FULL_FRAME_PERIOD,
						frameBuffer,videoTestFile,DPCM_SEQ,REP_TIME,arrayTest,TEST);
	dspTh=new Thread(displayThread);
	rcvTh.start();
	
	//start the dynamic regulation of the reproduction frame rate
	dynTask=new DynamicFrameRate(receiverThread, displayThread);
	timer=new Timer();

	//frame reception rate read every 5 secs
	timer.schedule(dynTask, 3000, 5000);
	
	//video start command
	cs = cs | 0x08;
	    
	smsg.set_cmd((short)cs);
	try {
	    mote.send(MoteIF.TOS_BCAST_ADDR, smsg);
	}
	catch (IOException e) {
	    error("Cannot send message to mote");
	}
    }

     //STOP VIDEO FUNCTION
    
    public void stopVideo() {

    	if(TEST){	
    		
    		stopTime = System.currentTimeMillis();
    		if(receiverThread != null)
    			packetsLost=receiverThread.getLostPackets();
    		
    		try {
    			testFileWriter.write("\n");
    			testFileWriter.write("StopTime: "+stopTime+"\n");
    			testFileWriter.write("TestTime: "+(stopTime-startTime)+"\n");
    			testFileWriter.write("TimeToDisplay: "+bufferFillingTime+"\n");
    			testFileWriter.write("\n");
    		} catch (Exception e1) {
    			error("Test log not ready for writing.");
    		}
    	}

    	CmdMsg smsg = new CmdMsg();
    	int cs = 0;
    	try{

    		mote.deregisterListener(bigMsgListener, this);
    	}
    	catch(IllegalArgumentException e){
    		//System.out.println("Catched-bigmsgList on stop");
    	}
    	try{
    		mote.deregisterListener(videoMsgListener, this);
    	}
    	catch(IllegalArgumentException e){
    		//System.out.println("Catched-videoList on stop");
    	}
    	try{	
    		mote.deregisterListener(imgStatListener, this);
    	}
    	catch(IllegalArgumentException e){
    		//System.out.println("Catched-imgstatList on stop");
    	}

    	//stop threads and dynamic frame timer
    	threadStop=true;
    	if (timer != null) {
    		timer.cancel();
    	}

    	cs = cs | 0x10;


    	smsg.set_cmd((short)cs);
    	try {
    		mote.send(MoteIF.TOS_BCAST_ADDR, smsg);
    	}
    	catch (IOException e) {
    		error("Cannot send message to mote");
    	}
    	if(frameBuffer!=null){

    		synchronized(frameBuffer){
    			frameBuffer.notifyAll();
    		}
    	}	
    }

    
    // save the received jpeg picture eventually decoding it
    public void save() {

    	String file_name;
    	file_name = img_path + "picture_PIC_" + System.currentTimeMillis();
    	try {

    		String decompressed_file_name;
    		decompressed_file_name = file_name;

    		if (isJpeg.isSelected())
    			file_name += ".bytes";
    		else if (!isColor.isSelected())
    			file_name += ".pgm";
    		else
    			file_name += "" +
    			".ppm";
    		FileOutputStream fostr = null;
    		try {
    			fostr = new FileOutputStream(file_name);
    		}
    		catch (Exception e){
    			message("Can't write " + file_name + " file!\nMake sure the dir exists!\n");
    			return;
    		};		

    		DataOutputStream stream = null;
    		OutputStreamWriter writer = null;
    		String pgmHeader =  "P2\r\n" + max_x + " " + max_y + "\r\n" + "255\r\n";
    		String ppmHeader =  "P3\r\n" + max_x + " " + max_y + "\r\n" + "255\r\n";

    		if (isJpeg.isSelected()) {
    			stream = new DataOutputStream(fostr);
    		} else {
    			writer = new OutputStreamWriter(fostr);
    			if (!isColor.isSelected())
    				writer.write(pgmHeader);
    			else
    				writer.write(ppmHeader);
    		}

    		int cnt_row = 1;
    		int red_byte = 0;
    		int blue_byte = 0;
    		int green_byte = 0;
    		int green_lo = 0;
    		int green_hi = 0;

    		boolean is_first_byte = true;
    		for (int i = 0; i < data.size(); i++) {
    			for (int j = 0; j < PAYLOAD_LENGTH; j++) {

    				int curr_byte = 0;

    				if (j < data.get(i).length)
    					curr_byte = (data.get(i)[j] & 0xFF);

    				else if (i == data.size() - 1)
    					break;

    				if (isJpeg.isSelected()) {
    					stream.writeByte(curr_byte);
    				} 
    				else if (!isColor.isSelected()) {
    					writer.write((curr_byte & 0xFF) + " ");


    					if (++cnt_row >= max_x){
    						cnt_row = 0;
    						writer.write("\r\n");
    					}
    				} else {
    					
    					if(TEST)
    					//test variable
    					decompressionTime=0;

    					if (is_first_byte) {
    						is_first_byte = false;
    						red_byte = (curr_byte & 0x1F);
    						green_lo = (curr_byte & 0xE0);
    						green_lo = ((green_lo >> 5) & 0x07);
    					} else {
    						blue_byte = ((curr_byte >> 3) & 0x1F);
    						green_hi = (curr_byte & 0x07);
    						green_hi = (green_hi << 3);
    						green_byte = (green_lo | green_hi);

    						red_byte <<= 3;
    						blue_byte <<= 3;
    						green_byte <<= 2;
    						writer.write((red_byte & 0xFF) + " " + (green_byte&0xFF) + " " + (blue_byte&0xFF) + " ");
    						if (++cnt_row >= max_x) {
    							cnt_row = 0;
    							writer.write("\r\n");
    						}
    						is_first_byte = true;
    					}
    				}
    			}
    		}
    		if (isJpeg.isSelected()){
    			stream.flush();
    			stream.close();
    			if (isDecompression.isSelected()) {

    				try {
    					Process p;
    					
    					if(TEST) decompressionTime=-System.currentTimeMillis();
    					
    					p = Runtime.getRuntime().exec("src/idctApp.exe " + file_name + " " + decompressed_file_name);
    					//System.out.println("Img counter: "+imgCounter);
    					//p = Runtime.getRuntime().exec("src/idctApp.exe " + file_name + " " + imgCounter);
    					//imgCounter++;
    					BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()));
    					String line=null;

    					while((line=input.readLine()) != null) {
    						System.out.println(line);
    					}

    					int exitVal = p.waitFor();
    					System.out.println("\nDecompression done without error\n");
    					//System.out.println("Decompression Exited with error code "+exitVal);
    					
    					if(TEST) decompressionTime+=System.currentTimeMillis();

    				} catch(Exception e) {
    					System.out.println(e.toString());
    					e.printStackTrace();
    				}
    			}
    		} else {
    			writer.flush();
    			writer.close();
    		}
    		message("Saved " + file_name + "file and cleared data structures.\nReady for the next command.");
    		System.out.println("Saved image in src/pictures");
    		System.out.println("\nThe system is ready for the next command");
    	}
    	catch(Exception e){System.out.println(e);}
    	
    	/*
    	if (clearAfterSave.isSelected()){
    		data = new ArrayList<short[]>();
    	}
    	*/
    	
    	//write test data    	
    	if(TEST){
    		stopTime= System.currentTimeMillis();
    		try {
    			testFileWriter.write("\n");
    			testFileWriter.write("SampleNum: "+sampleNum+"\n");
    			testFileWriter.write("Photo: "+file_name+"\n");
    			testFileWriter.write("Type: "+max_x+"x"+max_y+"\n");
    			testFileWriter.write("Size: "+photoSize+"\n");
    			testFileWriter.write("TransferTime: "+(stopTime-startTime)+"\n");
    			testFileWriter.write("AcquireTime: "+acquireTime+"\n");
    			testFileWriter.write("ProcessTime: "+processTime+"\n");
    			testFileWriter.write("SendingTime: "+sendingTime+"\n");
    			testFileWriter.write("DecompressionTime: "+decompressionTime+"\n");
    			testFileWriter.write("CameraPauseTime: "+cameraPauseTime+"\n");
    			for(int i=0;i<iNodeDelta.size();i++){
    				//  testFileWriter.write("IntermediateNodeTxPause: "+iNodeTxPause.get(i)+"\n");
    				//testFileWriter.write("IntermediateNodeDelta: "+iNodeDelta.get(i)+"\n");
    				testFileWriter.write("IntermediateNodeQueueSize: "+iNodeQueue.get(i)+"\n");
    			}
    			for(int i=0;i<bsQueue.size();i++){
    				//testFileWriter.write("BaseStationTxPause: "+iNodeTxPause.get(i)+"\n");
    				testFileWriter.write("BaseStationQueueSize: "+bsQueue.get(i)+"\n");
    				//testFileWriter.write("BaseStationDelta: "+bsDelta.get(i)+"\n");
    				testFileWriter.write("\n");
    			}
    		} catch (IOException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}

    	}

    }
    
    /* Message received from mote network. Update message area if it's
       a theft message. */
    
    short []getMsgBuf(Bigmsg_frame_partMsg msg) {
    	int length = msg.dataLength() - Bigmsg_frame_partMsg.offset_buf(0);
        short[] tmp = new short[length];
        
        for (int index0 = 0; index0 < length; index0++)
        {
        	tmp[index0] = msg.getElement_buf(index0);
        	//System.out.println("Elem: "+ index0 +"  val: "+tmp[index0]);
        }	
        return tmp;
    }
    
    public void messageReceived(int dest_addr, Message msg) {
    		
        
	if (msg instanceof Bigmsg_frame_partMsg) {
		//received a photo message
		Bigmsg_frame_partMsg fpMsg = (Bigmsg_frame_partMsg)msg;
		if (fpMsg.get_part_id() % 50 == 0)
	    message("Msg ID " + fpMsg.get_part_id());
	    
		if(fpMsg.get_part_id()!=photoLastPartId+1 && fpMsg.get_part_id()!=0 /*&& !exitVar*/) {
			System.out.println("ERROR: Packet lost! LastId: "+photoLastPartId+" "+fpMsg.get_part_id());
			return;
		}
		else photoLastPartId=fpMsg.get_part_id();
		
	    while (fpMsg.get_part_id() >= data.size())
		data.add(data.size(),new short[0]);
	    data.set(fpMsg.get_part_id(), getMsgBuf(fpMsg));
	    
	    if(fpMsg.get_part_id()==lastFrame) 	save();
	  
	    
	} else if (msg instanceof ImgStatMsg) {
	    ImgStatMsg isMsg = (ImgStatMsg)msg;
	    
	    if(PSNR){
	    	System.out.println("MSE: "+isMsg.get_data_size());
	    	mse=isMsg.get_data_size();
		    psnr= 10*Math.log10((65025)/(mse/(DisplayThread.WIDTH*DisplayThread.HEIGHT)));
		    System.out.println("Current PSNR: "+psnr);
		    count++;
		    avg_psnr=psnr+avg_psnr;
		    System.out.println("Average PSNR ( "+count+" samples): "+(avg_psnr/count));
		    //SCRIVERE SU UN FILE IL PSNR
		    p_psnr.println("Current PSNR: "+psnr);
		    p_psnr.println("Average PSNR ( "+count+" samples): "+(avg_psnr/count));
	    }
	    else {
	    	message("Image capture stats:");
	    	message("  img type: " + isMsg.get_type());
	    	message("  img width: " + isMsg.get_width());
	    	message("  img height: " + isMsg.get_height());
	    	message("  img size: " + isMsg.get_data_size());
	    	if(isMsg.get_data_size()%PAYLOAD_LENGTH !=0){
		    	
		    	lastFrame=(int) (isMsg.get_data_size()/PAYLOAD_LENGTH);
		    	message("  Num of packets: " + (lastFrame+1));
		    }
		    else{
		       	lastFrame=(int) (isMsg.get_data_size()/PAYLOAD_LENGTH)-1;
		    	message("  Num of packets int: " + (lastFrame+1));
		    }
	    }
	      
	    
	    
	}
	else if (msg instanceof PktTestMessage){
		
		PktTestMessage isMsg = (PktTestMessage)msg;
		System.out.println("PktTest message received: ");
		
	    exitVar=true;
	    
		try {
				testFileWriter.write("\n");
				testFileWriter.write("CameraRtxPkts: " + isMsg.get_rtx_camera_count()+"\n");
				testFileWriter.write("IntermediateRcvPkts: " + isMsg.get_rcv_inter_pkts()+"\n");
				testFileWriter.write("IntermediateRtxPkts: " + isMsg.get_rtx_inter_count()+"\n");
				testFileWriter.write("BsRcvPkts: " + isMsg.get_rcv_bs_pkts()+"\n");
				testFileWriter.write("NumberOfFrames: " + isMsg.get_frame_num()+"\n");
				testFileWriter.write("PacketsLost: " +packetsLost+"\n");
				testFileWriter.write("\n");
		}
	
		catch (IOException e) {
				// 	TODO Auto-generated catch block
				e.printStackTrace();
		}
		
		
	}
	else if (msg instanceof TimeTestMessage){
		
		TimeTestMessage isMsg = (TimeTestMessage)msg;
		//if video test is on
		if(photoTestFile==null){
			
			try {
				sampleNum=isMsg.get_id();
				testFileWriter.write("\n");
				testFileWriter.write("SampleNum: "+isMsg.get_id()+"\n");
				testFileWriter.write("AcquireTime: "+isMsg.get_acquire()+"\n");
				testFileWriter.write("ProcessTime: "+isMsg.get_process()+"\n");
				testFileWriter.write("SendingTime: "+isMsg.get_sending()+"\n");
				testFileWriter.write("FrameSize: "+isMsg.get_send_size()+"\n");
				testFileWriter.write("AcquirePeriod: "+isMsg.get_acq_period()+"\n");
				testFileWriter.write("cameraPauseTime: "+isMsg.get_pause_time()+"\n");
			    testFileWriter.write("\n");
			} catch (IOException e) {
				// 	TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		

		else{
				// testing the photo system
			    acquireTime=isMsg.get_acquire();
	            processTime=isMsg.get_process();
	            sendingTime=isMsg.get_sending();
	            photoSize=isMsg.get_send_size();
	            sampleNum=isMsg.get_id();
	            cameraPauseTime=isMsg.get_pause_time();

		}
	}
	else if (msg instanceof QueueTestMessage){
			
			QueueTestMessage isMsg = (QueueTestMessage)msg;
			
						
			if(photoTestFile==null && isMsg.get_queue_delta()==1){
				
				try {
					testFileWriter.write("\n");
					//testFileWriter.write("BaseStationTxPause: "+isMsg.get_tx_pause()+"\n");
					testFileWriter.write("BaseStationQueueSize: "+isMsg.get_queue_size()+"\n");
					//testFileWriter.write("BaseStationDelta: "+isMsg.get_queue_delta()+"\n");
				    testFileWriter.write("\n");
				} catch (IOException e) {
					// 	TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else if(photoTestFile==null && isMsg.get_queue_delta()==0){
				try {
					testFileWriter.write("\n");
					//testFileWriter.write("InterNodeTxPause: "+isMsg.get_tx_pause()+"\n");
					testFileWriter.write("InterNodeQueueSize: "+isMsg.get_queue_size()+"\n");
					//testFileWriter.write("InterNodeDelta: "+isMsg.get_queue_delta()+"\n");
				    testFileWriter.write("\n");
				    
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			
			}
			else if(isMsg.get_queue_delta()==1){
				bsQueue.add(isMsg.get_queue_size());
				bsDelta.add(isMsg.get_queue_delta());
				
			}
			else{
				iNodeQueue.add(isMsg.get_queue_size());
				iNodeDelta.add(isMsg.get_queue_delta());
				//iNodeTxPause.add(isMsg.get_tx_pause());
					
			
			}
		}
	
	
    }
    
    public void load(String filename) {
    	try {
    	BufferedReader r = new BufferedReader(new FileReader(filename));
	    String line = r.readLine();//header line 1
	    line = r.readLine(); //header line 2
	    line = r.readLine(); //header line 3
	    line = r.readLine(); //header line 4
	    line = r.readLine();
	    int i = 0, j = 0;
	   short[] values = new short[PAYLOAD_LENGTH];
	   
	    while (line != null) {
		java.util.StringTokenizer t = new java.util.StringTokenizer(line);
		while (t.hasMoreTokens()) {
		    String id_str = t.nextToken();
		    if (id_str.length() != 0) {
			values[i++] = Short.parseShort(id_str);
			if (i == PAYLOAD_LENGTH) {
			    Bigmsg_frame_partMsg fpMsg = new Bigmsg_frame_partMsg();
			    fpMsg.set_part_id(j);
			    fpMsg.set_buf(values);
			    this.messageReceived(0, fpMsg);
			    i = 0;
			    j++;
			   values = new short[PAYLOAD_LENGTH];
			   
			}
		    }
		}
		line = r.readLine();
	    }
    	}
	catch(Exception e) {
	    System.out.println("CameraGUI.load():" + e.toString());
	}
    }
    
    public synchronized boolean getThreadStop(){
    	return threadStop;
    }
    
    public void setBufferRefilling(int delta){
    	if(BUF_REFILLING_DIST>2 && delta<0) BUF_REFILLING_DIST--;
    	else if(BUF_REFILLING_DIST<8 && delta>0) BUF_REFILLING_DIST++;
    	System.out.println("BUF_REFILLING_DISTANCE: "+BUF_REFILLING_DIST);
    }

    //return the frame path
    //tunes the percentage used to control the frame rate reproduction
    public synchronized String getFrame(int pos){
    	
    	if(lastWrite==pos+1 || (lastWrite==0 && pos==BUFFER_SIZE-1)){
    		bufferReady=false;
			if(pos+1<BUFFER_SIZE)readPos=pos+1;
			else readPos=0;
			System.out.println("Stop display");
			displayThread.setBufferReady(false);
			
    	}
    	// SET PERCENTAGE 
    	if(lastWrite<=pos) {
    		deltaPercentage=pos-lastWrite;
			System.out.println("Delta: "+deltaPercentage);
		}
		else {
			deltaPercentage=pos-lastWrite+BUFFER_SIZE;
			System.out.println("Delta "+deltaPercentage);
		}
    	if(deltaPercentage<10){
    		oldPerc=0.5;
    		displayThread.setPercentage(0.5);
    	}
    	else if(oldPerc!=0.1){
    			oldPerc=0.1;
    			displayThread.setPercentage(0.1);
    	}
    
      	return frameBuffer[pos];
    }

    // saves the new frame path and checks the buffer status
    public synchronized void setFrame(int pos,String framePath){
    	
    	frameBuffer[pos]=framePath;
    	lastPath=framePath;
    	lastWrite=pos;
    	//System.out.println("SETFRAME: write pos: "+pos);
    	if(!bufferReady){
    		
    		if(readPos<=pos) {
				diff=pos-readPos;
			//	System.out.println("Read: "+readPos+" WritePos: "+pos+" diff: "+diff);
			}
			else {
				diff=pos-readPos+BUFFER_SIZE;
			//	System.out.println("Read: "+readPos+" Pos: "+pos+" diff: "+diff);
			}

			mssgArea.setText("");
			mssgArea.setCaretPosition(0);
			perc=(float)diff/BUF_REFILLING_DIST;
			message("Loading buffer "+(int)(perc*100)+"%\n");
			if(diff>=BUF_REFILLING_DIST) {
				bufferReady=true;
				displayThread.setBufferReady(true);
				synchronized(frameBuffer){
    				frameBuffer.notify();
    				}
				mssgArea.setText("");
				mssgArea.setCaretPosition(0);
			}
			
    	}
    }

    //just starts the thread
    public synchronized void displayVideo(){
    	if(dspTh!=null){
    		bufferFillingTime+=System.currentTimeMillis();
    		mssgArea.setText("");
    		mssgArea.setCaretPosition(0);
    		dspTh.start();
    	}
    	else{
    		System.out.println("Video viewer not ready.");
    		return;
    	}
    }

    /* Just start the app... */
    public static void main(String[] args) {
    	CameraGUI me = new CameraGUI(true);
    }
}
