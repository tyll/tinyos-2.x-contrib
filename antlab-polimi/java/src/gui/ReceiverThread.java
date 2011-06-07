package gui;

import java.io.DataOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.util.ArrayList;
import javax.swing.JTextArea;

import message.CmdMsg;
import message.ImgStatMsg;
import message.Video_frame_partMsg;
import net.tinyos.message.Message;
import net.tinyos.message.MessageListener;
import net.tinyos.message.MoteIF;
import net.tinyos.util.Messenger;

public class ReceiverThread implements Runnable,MessageListener, Messenger{
	
	//control varaibles
	int BUFFER_SIZE;
    int START_READING;
    int DPCM_SEQ;
    int PAYLOAD_LENGTH= Video_frame_partMsg.DATA_SIZE; //40;
    boolean TEST=false;
    String testFilePath= "";

	int bufferCounter=0;
    String frameName=null;
    boolean threadRunning=false;
     //String[] frameBuffer=null;
    //boolean received=false;
    ArrayList<short[]> data = null;
    ArrayList<short[]> dataSaved = null;
    //int frameNum=0;
    int lastFrame=0;
   // boolean record=false;
    String img_path = "src/pictures/";
    CameraGUI cameraObj=null;
    int pos=0;
    MoteIF mote; 
    JTextArea mssgArea;
    
    Video_frame_partMsg videoMsgListener;
    ImgStatMsg imgStatListener;
    int partIdCounter=0; // necessario per calcolare dinamicamente size dell'arraylist data.
    float perc=0;
    int lastFrameId=250;	
    boolean reSync=false; //per risparmiare un setFrame(pos,null) se il frame "intero" da risincronizzare non è il successivo a quello perso
    int lastPartId=0; // check sulla ricezione corretta delle parti
    boolean seqBroken=false;
    boolean waitReset=false;
    int brokenFrame=0;
    int lostPackets=0;
    String videoTestFile=null;
    String videoTestTimestamp=null;    
    Writer testFileWriter;
    long reSynchTime=0;
    long noErrorsTime=0;
    int receivedFrames=0;
    
    ArrayDelayAndFrameLoss arrayTest;
    long delayRX=0;
    int countFrame=0;
    int frameSize=0;
    int avg_frameSize=0;
    
	//file di log
	static PrintStream p_frameLoss;
	static PrintStream p_delayRX;  
	static PrintStream p_frameSize;
    
  //command type & msg
    int cs = 0; 
    CmdMsg smsg=null;    
    
    public ReceiverThread(CameraGUI cameraObj,JTextArea mssgArea,MoteIF mote,
    						int buffer_size,int start_reading,Video_frame_partMsg videoMsgListener,
    							ImgStatMsg imgStatListener,int dpcm_seq,String videoTestFile, 
    								ArrayDelayAndFrameLoss arrayTest, boolean TEST, String testFilePath){
    	this.cameraObj=cameraObj;
    	data=new ArrayList<short[]>();
    	this.mssgArea=mssgArea;
    	this.mote=mote;
    	pos=0;
    	this.testFilePath = testFilePath;
    	BUFFER_SIZE=buffer_size;
    	START_READING=start_reading;
    	this.videoMsgListener=videoMsgListener;
    	DPCM_SEQ=dpcm_seq;
    	lastFrameId=254; // to simulate correct reception of hte last sequence 
    	lastPartId=0;
    	lostPackets=0;
    	waitReset=false;
    	this .TEST=TEST;
    	   	
    	if(TEST){
    		this.arrayTest = arrayTest;
    		this.videoTestTimestamp=videoTestFile.substring(16, videoTestFile.length()-4);
    		this.videoTestFile=testFilePath+"video_"+videoTestTimestamp+"_resynch.txt";
    		FileOutputStream fos_frameLoss = null;
        	FileOutputStream fos_delayRX = null;
        	FileOutputStream fos_frameSize = null;
        	try {
        		fos_frameLoss = new FileOutputStream(testFilePath+"frameLoss.txt",true);	
        		fos_delayRX = new FileOutputStream(testFilePath+"delayRX.txt",true);	
        		fos_frameSize = new FileOutputStream(testFilePath+"frameSize.txt",true);	
        	} catch (FileNotFoundException e2) {
        		e2.printStackTrace();
        	}
        	p_frameLoss = new PrintStream(fos_frameLoss);
        	p_delayRX = new PrintStream(fos_delayRX);
        	p_frameSize = new PrintStream(fos_frameSize);
    	}
    	
    	    	
    } 
    
	@Override
	public void run() {
		System.out.print("Connecting to serial forwarder.");
		mote = new MoteIF(this);
		System.out.println("\nok");

		mote.registerListener(videoMsgListener, this);

		if(TEST){
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
				testFileWriter.write("VideoFile: "+videoTestTimestamp+"\n");
			} catch (IOException e4) {
				// 	TODO Auto-generated catch block
				e4.printStackTrace();
			}
			noErrorsTime=-System.currentTimeMillis();
		}//test

		while(!cameraObj.getThreadStop()){

			try {
				//sleeps before the next check of the thread_stop var status
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}//while

		//stops listener
		mote.deregisterListener(videoMsgListener, this);
		System.out.println("Packets lost: "+ lostPackets);

		if(TEST) {
				p_frameLoss.println("Frame Loss: " + lostPackets);
				try {
					testFileWriter.close();
				} catch (IOException e) {
					// 	TODO Auto-generated catch block
					e.printStackTrace();
				}
		}
		System.out.println("Receiver stopped.");

		    
		
	}

	@Override
	public void messageReceived(int dest_addr, Message msg) {

	 if (msg instanceof Video_frame_partMsg){
			Video_frame_partMsg fpMsg = (Video_frame_partMsg)msg;
			//System.out.println("MSG: Part id: "+fpMsg.get_part_id()+" Frame_id: "+fpMsg.get_frame_id());
			//System.out.println("pos : " + pos);
			
			//TEST buffer delay
			if(TEST && fpMsg.get_part_id()==1){
				arrayTest.setArray(System.currentTimeMillis(), pos);
				//System.out.println("########## pos = "+pos);
			}
			
			// part-id check
			if(seqBroken==false &&((lastPartId+1!=fpMsg.get_part_id() && fpMsg.get_part_id()!=0) || (fpMsg.get_part_id()==0 && (lastFrameId+1<fpMsg.get_frame_id() || lastFrameId==254 && fpMsg.get_frame_id()!=0)))){
				System.out.println("BROKEN SEQUENCE: Frame num: "+fpMsg.get_frame_id()+" lastPart: "+lastPartId+" Current id: "+fpMsg.get_part_id()+" Current frame: "+fpMsg.get_frame_id()+" Last frame: "+lastFrameId);
				
				if(TEST){
						reSynchTime=-System.currentTimeMillis();
						noErrorsTime+=System.currentTimeMillis();
				}
				
				seqBroken=true;
				brokenFrame=fpMsg.get_frame_id();
				lastFrameId=254;
				lastPartId=0;
				lostPackets++;
				
				// send reset command to restart DPCM
				cs = 0;
				cs = cs | 0x20;
				smsg = new CmdMsg();
				smsg.set_cmd((short)cs);
				try {
				    mote.send(MoteIF.TOS_BCAST_ADDR, smsg);
				}
				catch (IOException e) {
				    System.out.println("Cannot send message to mote");
				}
				waitReset=true;
				
			}
			else if(seqBroken==true && fpMsg.get_frame_id()%DPCM_SEQ==0 && fpMsg.get_part_id()==1){
				seqBroken=false;
				if(TEST){
					reSynchTime+=System.currentTimeMillis();
					try {
						testFileWriter.write("\n");
						testFileWriter.write("ResynchTime: "+reSynchTime+"\n");
						testFileWriter.write("NoErrorsTime: "+noErrorsTime+"\n");
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					noErrorsTime=-System.currentTimeMillis();
				}
				
				
				if(fpMsg.get_frame_id()==0){
					waitReset=false;
					System.out.println("WaitReset set to false");
				}
				System.out.println("NEW FRAME: "+fpMsg.get_frame_id()+" Broken: "+brokenFrame+" Set null pos: "+pos);
			
				//insert null value in frameList
				lastFrameId=254;
				lastPartId=0;
				data = new ArrayList<short[]>();
				partIdCounter=0;
				if(pos==BUFFER_SIZE) pos=0;
				cameraObj.setFrame(pos, null);
				pos++;
				
				//TEST buffer delay
				if(TEST && fpMsg.get_part_id()==1){
					arrayTest.setArray(System.currentTimeMillis(), pos);
					//System.out.println("########## NEW pos = "+pos);
				}
				
			}
			else if(seqBroken==false && waitReset==true && fpMsg.get_frame_id()==0 && fpMsg.get_part_id()==1){
				System.out.println("Received reset frame after restart has been done.");
				//insert null value in frameList
				lastFrameId=254;
				lastPartId=0;
				data = new ArrayList<short[]>();
				partIdCounter=0;
				if(pos==BUFFER_SIZE) pos=0;
				cameraObj.setFrame(pos, null);
				pos++;
				waitReset=false;
			}
			else if(seqBroken==false && fpMsg.get_part_id()==1 && fpMsg.get_frame_id()==0 && lastFrameId!=254){
				System.out.println("Reset forced at pos: "+pos+". Frame: "+fpMsg.get_frame_id()+" Last frame: "+lastFrameId);
				lastFrameId=254;
				lastPartId=0;
				data = new ArrayList<short[]>();
				partIdCounter=0;
				if(pos==BUFFER_SIZE) pos=0;
				cameraObj.setFrame(pos, null);
				pos++;
			
			}  
			//else if(seqBroken==true)System.out.println("Ignoring "+fpMsg.get_part_id()+" of frame "+fpMsg.get_frame_id());
			
		
			if(seqBroken==false){
			
				lastPartId=fpMsg.get_part_id();
		   
			while (partIdCounter >= data.size())
			data.add(data.size(),new short[0]);
			//System.out.println("Saving part "+fpMsg.get_part_id()+" of frame "+fpMsg.get_frame_id());
			data.set(partIdCounter, getMsgBuf(fpMsg));
			partIdCounter++;
			
		    if(fpMsg.get_part_id()==0){
				try {
					
					countFrame++;
					
					if(TEST) {
					//System.out.println("########## partIdCounter = "+partIdCounter);
					
					//FrameSize: SALVARE SU UN FILE partIdCounter * PAYLOAD_LENGTH
			   		frameSize = partIdCounter*PAYLOAD_LENGTH;
			   		p_frameSize.println("Current FrameSize: "+ frameSize);
			   		avg_frameSize = frameSize + avg_frameSize; 
				    p_frameSize.println("Average FrameSize ( "+countFrame+" samples): "+(avg_frameSize/countFrame));					
					}
					
					partIdCounter=0;
					lastFrameId=fpMsg.get_frame_id();
					
					// copy data buffer to process it and reset 'data'
					dataSaved=new ArrayList<short[]>();
					for(int i=0;i<data.size();i++) dataSaved.add(data.get(i));
					data= new ArrayList<short[]>();
					if(fpMsg.get_frame_id()%DPCM_SEQ==0) System.out.println("# Jpeg frame pos: "+pos+" frameId: "+fpMsg.get_frame_id());
					else System.out.println("Frame "+fpMsg.get_frame_id()+" written at pos: "+pos);
					receivedFrames++;

					
										
					if(TEST){
						delayRX = System.currentTimeMillis() - arrayTest.getArray(pos);
						if(fpMsg.get_frame_id()!=0){
							p_delayRX.println(delayRX);
							//System.out.println("########## delay P = "+delayRX);			
						} //else				
						//System.out.println("########## delay I = "+delayRX);

						//System.out.println("########## pos = "+pos);	
					}
					save();				
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}//if part =0		
		    
		 	//}
		  }// seqBroken=false
			
		 }// videoMsg
		 
	    }// messageReceived
	    
		
		public int getFrameRate() {
			int ret=receivedFrames;
			System.out.println("Ret: "+ret);
			receivedFrames=0;
			return ret;
		}
	    
		//save compressed frame on disk
	    public void save() throws IOException {
	    	    
	    	    String file_name;
	       	    file_name = img_path + "picture_" + System.currentTimeMillis();
	    		String decompressed_file_name;
	    		decompressed_file_name = file_name;
	    
	    		
	    		file_name += ".bytes";
	    	 
	    	    FileOutputStream fostr = null;
	    	    try {
	    		fostr = new FileOutputStream(file_name);
	    	    }
	    	    catch (Exception e){
	    		message("Can't write " + file_name + " file!\nMake sure the dir exists!\n");
	    		e.getStackTrace();
	    		return;
	    	    };		
	    	
	    	    DataOutputStream stream = null;
	    	    	    	    	    	    		
	    	    
	    		stream = new DataOutputStream(fostr);
	    	    
	    	        
	    	        for (int i = 0; i < dataSaved.size(); i++) {
	    		    for (int j = 0; j < PAYLOAD_LENGTH; j++) {
	    			int curr_byte = 0;

	    			if (j < dataSaved.get(i).length)
	    			    curr_byte = (dataSaved.get(i)[j] & 0xFF);
	    			else if (i == dataSaved.size() - 1)
	    			    break;
	    				    	    	
	    			    stream.writeByte(curr_byte);
	    	    	    
	    		    }
	    		}
	    	    	
	    		    stream.flush();
	    		    stream.close();
	    		    		
	    			
	    		//	message("Saved " + file_name + "file and cleared data structures.\nReady for the next img.");
	        	
	        
			
			if(pos>=START_READING&&!threadRunning){
				
				threadRunning=true;
				cameraObj.displayVideo();
			}
			if(pos==BUFFER_SIZE){
				pos=0;
				System.out.println("Buffer in scrittura completo. Frame "+lastFrameId+" saved in: "+pos);
				cameraObj.setFrame(pos, file_name);
				pos++;
			}
			else {
			
				if(!threadRunning){
					mssgArea.setText("");
					mssgArea.setCaretPosition(0);
					perc=(float)pos/START_READING;
					message("Loading buffer "+(int)(perc*100)+"%\n");
				}
									
				cameraObj.setFrame(pos, file_name);
				//System.out.println("Frame "+lastFrameId+" saved in: "+pos);
				pos++;
			}
			
	    }
	    
		    
	    short []getMsgBuf(Video_frame_partMsg msg) {
	    	
	    	int length = msg.dataLength() - Video_frame_partMsg.offset_buf(0);
	    	
	        short[] tmp = new short[length];
	        for (int index0 = 0; index0 < length; index0++)
	            tmp[index0] = msg.getElement_buf(index0);
	        return tmp;
	    }
		
	    
	@Override
	public synchronized void message(String s) {
		mssgArea.append(s + "\n");
		mssgArea.setCaretPosition(mssgArea.getDocument().getLength());
	    }
 //test
	public int getLostPackets(){
		return lostPackets;
	}
	

}
