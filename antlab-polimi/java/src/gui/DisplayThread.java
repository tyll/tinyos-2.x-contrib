/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * NewJFrame.java
 *
 * Created on 7-lug-2010, 12.41.11
 */

package gui;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.awt.image.MemoryImageSource;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.io.Writer;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;


public class DisplayThread implements Runnable {
	
	//control variables
	static int WIDTH=160; //320; //size of the decoded frame
    static int HEIGHT=120; //240;
    static int RESCALED_WIDTH=320; // size of the recontructed frame
    static int RESCALED_HEIGHT=240;
    int DPCM_SEQ;
    int REP_TIME;
    int BUFFER_SIZE;
    int FULL_FRAME_PERIOD;
    boolean TEST=false;
    String testFilePath = "";
	
    Image image;
    Image originalImg;
    Graphics2D bufImageGraphics;
    BufferedImage bufferedImage=null;
    FileInputStream is=null;
    int[] imageData=null;
    JFrame jFrame=null;
    Toolkit toolkit=null;
    ImageIcon icon=null;
    JLabel label=null;
    String[] buffer=null;
    int idx=0;
    CameraGUI cameraObj=null;
    String framePath=null;
    int frameNum=0;
    String frameName=null;
    int bufferCounter=0;
    BufferedReader input=null;
    String line=null;
    Process p=null;
    Thread rcvThread=null;
    boolean bufferReady=true;
    String[] frameBuffer=null;
    ImagePanel panel=null;
    Dimension dim=null;
    boolean skipDisplay=false;
    long decompressionTime=0;
    Writer testFileWriter=null;
    String videoTestFile=null;
    String videoTestTimestamp=null;
    long bufferRefillingTime=0;
    long bufferEmptyingTime=0;
    //buffer refilling control
    int motionCounter=0;
    int deltaMotion=0;
    int oldRepTime=1000;
    double PERC=0.1; // percentage to control directly the display rate 
    
	//file di log
	static PrintStream p_fps;
	static PrintStream p_delay;
	//FPS
	double fps=0;
	double avg_fps=0;
	int count=0;
	
    ArrayDelayAndFrameLoss arrayTest;
    //DELAY
    long delay=0;
    long avg_delay=0;
    int countFrame=0;
    
    public DisplayThread(CameraGUI cameraObj,Thread rcvThread,int buffer_size,int full_frame_period,
    						String[] frameBuffer,String videoTestFile,int dpcm_seq,int rep_time, 
    							ArrayDelayAndFrameLoss arrayTest, 
								boolean TEST, String testFilePath){
    	
    	jFrame = new JFrame("Video");
    	jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    	jFrame.setLocationRelativeTo(null);
    	dim=new Dimension();
    	dim.width=RESCALED_WIDTH;
    	dim.height=RESCALED_HEIGHT;
	this.testFilePath = testFilePath;
    	jFrame.setPreferredSize(dim);
    	this.cameraObj=cameraObj;
    	frameNum=0;
    	bufferCounter=0;
    	this.rcvThread=rcvThread;
    	BUFFER_SIZE=buffer_size;
    	FULL_FRAME_PERIOD=full_frame_period;
    	DPCM_SEQ=dpcm_seq;
    	REP_TIME=rep_time;
    	panel=panel;
    	this.frameBuffer=frameBuffer;
    	
    	this.TEST=TEST;
    	
    	if(TEST){
    		this.videoTestTimestamp=videoTestFile.substring(16, videoTestFile.length()-4);
    		this.videoTestFile= testFilePath+"video_"+videoTestTimestamp+"_dcmp.txt";
    		FileOutputStream fos_fps = null;
        	FileOutputStream fos_delay = null;
        	try {
        		fos_fps = new FileOutputStream(testFilePath+"fps.txt",true);	
        		fos_delay = new FileOutputStream(testFilePath+"delay.txt",true);	
        	} catch (FileNotFoundException e2) {
        		e2.printStackTrace();
        	}
        	p_fps = new PrintStream(fos_fps);
        	p_delay = new PrintStream(fos_delay);
        	
        	this.arrayTest = arrayTest;
    	}
    	
    	
    	
    }
   

   
    public void setBufferReady(boolean value){
    	bufferReady=value;
    }
    
    public void setPercentage(double val){
    	PERC=val;
    	System.out.println("Percentage changed: "+val);
    }

   public void setFrameRate(int rate){
	   if(rate!=0) {
		   		REP_TIME= (5000/rate);
		   		REP_TIME=(int) (REP_TIME-PERC*REP_TIME);
		   		if(TEST){
		   			fps = ((double)rate)/5;
		   			p_fps.println("Current FPS: "+ fps);
		   			count++;
		   			avg_fps = fps + avg_fps; 
		   			p_fps.println("Average FPS ( "+count+" samples): "+(avg_fps/count));
		   		}
	   
	   }
	   //if frame rate is decreasing increment motion counter
	   if(oldRepTime<REP_TIME){
		    motionCounter++;
		    System.out.println("Motion counter: "+motionCounter);
	   }
	   else {
		    System.out.println("Decrement refilling");
		    // if frame rate is not increasing decrement buffer refilling
		   	motionCounter=0;
		   	oldRepTime=REP_TIME;
		   	deltaMotion=-1;
		   	cameraObj.setBufferRefilling(deltaMotion);
	   }
	   // if for 15 seconds the frame rate is increasing increment buffer refilling
	   if(motionCounter>=3){
		   deltaMotion=1;
		   oldRepTime=REP_TIME;
		   cameraObj.setBufferRefilling(deltaMotion);
		   motionCounter=0;
	   }
	   //limit the rep time
	   if(REP_TIME>1000) REP_TIME=800;
	      
	   System.out.println("Rep_time: "+REP_TIME);
   }
    
	@Override
	public void run() {
    	
		int idx=0;
		int k=0;
		int j=0;
		boolean first=true;
		imageData=new int[WIDTH*HEIGHT];
		

		panel= new ImagePanel(bufferedImage);
	 	jFrame.getContentPane().add(panel, BorderLayout.CENTER);
		panel.setVisible(true);
		jFrame.setVisible(true);
		jFrame.pack();
		
		if(TEST){
			try {
				System.out.println(videoTestFile);
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
			bufferEmptyingTime=-System.currentTimeMillis();
		}//test
		
	 	while(!cameraObj.getThreadStop()){
			
	 			
				while((framePath=cameraObj.getFrame(idx))==null){
					if(bufferReady){	
						System.out.println("Found null path: idx= "+idx);
						frameNum=0;
						idx++;
						if(idx>=BUFFER_SIZE) idx=0;
						System.out.println("Reset frameNum.");
					}
					else break;
				}
	 
	
			//decompress binary file
		if(bufferReady){
			
		    if(frameNum==FULL_FRAME_PERIOD)	frameNum=0;
	 
		    if(TEST)	decompressionTime=-System.currentTimeMillis();
	    
		    if(frameNum%DPCM_SEQ==0){
	    			skipDisplay=false;
	    			System.out.println("#Processing jpeg frame: "+idx);
		    }
		    else if(TEST){
		    	//System.out.println("Reading frame: "+idx);
	    		delay = System.currentTimeMillis() - arrayTest.getArray(idx);
	    		p_delay.println(delay);	    	
		    }
	    		try {
	    			p = Runtime.getRuntime().exec("src/dpcmDecodeApp.exe " +framePath+ " " + frameNum%DPCM_SEQ);
	    		} catch (IOException e) {
	    			e.printStackTrace();
	    		}

	    		//delay = System.currentTimeMillis() - arrayTest.getArray(idx);
//	    		p_delay.println("Current FrameDelay :" +delay);//+ " "+idx);
//	    		countFrame++;
//	    		
//	    		avg_delay=avg_delay+delay;    		
//			    p_delay.println("Average FrameDelay ( "+countFrame+" samples): "+(avg_delay/countFrame));
	    		
	    		//la media la faccio dopo...
	    		//p_delay.println(delay);
	    		
	    		
	    		
	    	//increment counters
	    		frameNum++;
	    		idx++;
	    		if(idx>=BUFFER_SIZE) idx=0;  
	    
	    		//read decompression output
	       		input = new BufferedReader(new InputStreamReader(p.getInputStream()));
	       		
	    		if(TEST){
	    			try {
	    				testFileWriter.write("FrameType: "+frameNum%DPCM_SEQ+"\n");
	    			} catch (IOException e4) {
	    				// 	TODO Auto-generated catch block
	    				e4.printStackTrace();
	    			}
	    			try {
	    				while((line=input.readLine()) != null) {
	    									   	System.out.println(line);
	    					//				testFileWriter.write("FrameSize: "+line+"\n");
	    				}
	    			} catch (IOException e) {
	    				// TODO Auto-generated catch block
	    				e.printStackTrace();
	    			}
	    		}//test
	    	
	    		//recreating name of the output image
	    		frameName= framePath.substring(0, framePath.length()-6);
	    		frameName=frameName+"_rec.pgm";
		
	    		int exitVal=0;
	    		try {
	    			exitVal = p.waitFor();
	    		} catch (InterruptedException e) {
	    			// 	TODO Auto-generated catch block
	    			e.printStackTrace();
	    		}
	    		
	    		if(TEST){
	    			decompressionTime+=System.currentTimeMillis();
	    			if(exitVal!=0){
	    				System.out.println("<<<<<<< Exited with error code "+exitVal+">>>>>>>>>>>");
	    				//jFrame.dispose();
	    				//return;
	    			}
	    			try {
	    				testFileWriter.write("DecompressionTime: "+decompressionTime+"\n");
	    			} catch (IOException e3) {
	    				// 	TODO Auto-generated catch block
	    				e3.printStackTrace();
	    			}
	    		}//test	
		

	    		// 	build the reconstructed image and plot it
		
	    		try {
	    				is= new FileInputStream(new File(frameName));
	    		} catch (FileNotFoundException e2) {
	    			System.out.println("File not found: "+frameName);
	    			skipDisplay=true;
	    			//idx++;
	    			//if(idx>=BUFFER_SIZE) idx=0;
	    		}
		}// buffer ready
		
   		j=0;
   		if(!skipDisplay && bufferReady){
    		
    	  	while(j<WIDTH*HEIGHT){
    	  		try {
    	  			imageData[j]=is.read();
    	  			
    	  		} catch (IOException e) {
				// 	TODO Auto-generated catch block
    	  			//e.printStackTrace();
    	  		}	
    	  		j++;
    	  	}
    	  	try {
    	  		is.close();
    	  	} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
    	  	}
    	
    	
    	  	for(k=0; k<WIDTH*HEIGHT; k++){
    	  			imageData[k]=((imageData[k] & 255) *0x00010101)|0xff000000;
    	  	}
    	  	
    	  	
    	  	toolkit = Toolkit.getDefaultToolkit ();
    	  	originalImg = toolkit.createImage (new MemoryImageSource(WIDTH,HEIGHT, imageData, 0, WIDTH));
    	  	
    	  	// Convert Image to BufferedImage
    	  	bufferedImage=new BufferedImage(RESCALED_WIDTH,RESCALED_HEIGHT,BufferedImage.TYPE_BYTE_GRAY);
    	  	bufImageGraphics = bufferedImage.createGraphics();
    	  	bufImageGraphics.drawImage(originalImg, 0, 0,RESCALED_WIDTH,RESCALED_HEIGHT,null);
    	  	bufImageGraphics.dispose();
    	  	panel.resetImage(bufferedImage);
    		
       	
    	  	//idx++;
    	  	if(idx==BUFFER_SIZE){
    	  		System.out.println("Buffer completely read.");
    	  		idx=0;
    	  	}
    	  	//if(idx%DPCM_SEQ==0) System.out.println("Read buf idx: "+idx);
    	  	
   		}// skip display
    	
   		if(!bufferReady){
   			if(TEST){
   				bufferRefillingTime=-System.currentTimeMillis();
   				bufferEmptyingTime+= System.currentTimeMillis();
   				try {
   					testFileWriter.write("BufferEmptyingTime: "+bufferEmptyingTime+"\n");
   				} catch (IOException e) {
   					// 	TODO Auto-generated catch block
   					e.printStackTrace();
   				}
   			}	
   			synchronized(frameBuffer){
   				try {
   					frameBuffer.wait();
   				} catch (InterruptedException e) {
   					// 	TODO Auto-generated catch block
   					e.printStackTrace();
   				}
   				if(TEST){	//test
   					bufferRefillingTime+=System.currentTimeMillis();
   					bufferEmptyingTime=- System.currentTimeMillis();
   					if(testFileWriter!=null){
   						try {
   							testFileWriter.write("BufferRefillingTime: "+bufferRefillingTime+"\n");
   						} catch (IOException e) {
   							// 	TODO Auto-generated catch block
   							e.printStackTrace();
   						}
   					}	
   				}//test
   			}
   		}


   		//skipDisplay=false;

   		try {
   			Thread.sleep(REP_TIME);

   		} catch (InterruptedException e) {
   			// TODO Auto-generated catch block
   			e.printStackTrace();
   		}	


	 	}// while
	 	System.out.println("Display stopped.");
	 	jFrame.dispose();
	 	if(TEST){
	 		try {
	 			testFileWriter.close();
	 		} catch (IOException e) {
	 			// TODO Auto-generated catch block
	 			e.printStackTrace();
	 		}
	 	}	

	} //run

}

class ImagePanel extends JPanel{
	
	private BufferedImage image;
	private Dimension dim=null;
	private int RESCALED_WIDTH=DisplayThread.RESCALED_WIDTH;
	private int RESCALED_HEIGHT=DisplayThread.RESCALED_HEIGHT;
	int imgCounter=0;
	
	public ImagePanel(BufferedImage image){
		this.image=image;
		dim=new Dimension();
		dim.width=RESCALED_WIDTH;
		dim.height=RESCALED_HEIGHT;
		setPreferredSize(dim);  	
	}
	
	public void resetImage(BufferedImage image){
		
		this.image=image;
		repaint();
	}

    
    public void paintComponent(Graphics g)
    {
    	if(image!=null){
    		    super.paintComponent(g);
    		    Graphics2D g2=(Graphics2D) g;
    		    g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC); 
    		    g2.drawImage(image, 0, 0,RESCALED_WIDTH,RESCALED_HEIGHT, null); 
    		    g2.dispose(); 
    		    /* Saves the displayed frame in human readable format
    		    File outputImg= new File("src/pictures/picture_"+imgCounter+".png");
    		    try {
					ImageIO.write(image, "png", outputImg);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
    		    imgCounter++;
    		   */
    	}
    	
    }
 
}
