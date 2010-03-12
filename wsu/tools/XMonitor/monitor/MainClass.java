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
 * It creates MainFrame and all the global variables.
 * It also create the communication interface MoteIF.
 *
 * Original version by:
 *    @author Wei Hong
 * Modified by:
 *    @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package monitor;

import Config.OasisConstants;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Vector;
import monitor.PacketAnalyzer.*;
import rpc.message.MoteIF;
import xml.Parser.XMLMessageParser;
import rpc.util.GetEnv;
//import net.tinyos.message.MoteIF;

import debug.rpc.*;
import com.oasis.message.*;




public class MainClass{
  
  //debug
         public static net.tinyos.message.MoteIF dmote;
         public static NescApp rpcApp = null;
         public static rpcCascadeMsgDriver casCtrllor = null;
         public static String rpcxmlpath = null;


  public static MoteIF mote;
  public static MainFrame mainFrame;

  public static DisplayManager displayManager;
  public static ObjectMaintainer objectMaintainer;
  public static SensorAnalyzer sensorAnalyzer;
  public static LocationAnalyzer locationAnalyzer;
  public static Vector packetAnalyzers;



  //public static DXM_DS_Manager tcpHandler;
  public static XMLMessageParser xmp;




  public static long startTime;
  public static FileWriter eventLogger;
  public static FileWriter rpcLogger;

  //rpc setting
 // public static NescApp rpcApp = null;
  public static String XmlPath = null;



  public static final int OASIS_TOOL = 1;
  public static final int MINENET_TOOL = 2;
	
  public static int tools = OASIS_TOOL;
   //layout setting
  public static Vector layoutInfo;

  public static void main(String args[]) {
    try {
	 //if (args.length == 0)
	 //	usage();
      MainClass mc = new MainClass();
    
    } catch (Exception e) {
      System.err.println("main() got exception: "+e);
      e.printStackTrace();
      System.exit(-1);
    }

  } 
	
  public MainClass() throws Exception {

    //Create OasisContant
    OasisConstants oasisConstants = new OasisConstants();

	System.err.println("moteIF");
    System.err.println("Creating log file...");
    
     try {
	  eventLogger = new FileWriter(OasisConstants.EventLogger, true);
	}
	catch (IOException e) {
		e.printStackTrace();
	}

	  	
     try {
	  rpcLogger = new FileWriter(OasisConstants.RPCLogger, true);
	}
	catch (IOException e) {
		e.printStackTrace();
	}


    startTime = System.currentTimeMillis();

    //Create a MoteIF interface with will handle message in wsn with any groupID
     // System.err.println("asdf");
    System.err.println(new GetEnv().getEnv("XML"));
   	 boolean big = new GetEnv().getEnv("BIG").equalsIgnoreCase("big");
  	xmp = new XMLMessageParser(new GetEnv().getEnv("XML"),big);
    
    mote = new MoteIF(xmp);
    //mote.setXmp(xmp);

/*************DEBUG*****************************************/
         
         
         dmote = new net.tinyos.message.MoteIF();
	//Collect info for Rpc
	rpcxmlpath = rpcConfig();
	if (rpcxmlpath != null){
		rpcApp = new NescApp(rpcxmlpath, dmote);	
		//Start CasCtrlMsg Listener
		casCtrllor = new rpcCascadeMsgDriver(rpcApp);
		rpcApp.comm.receiveComm.registerListener(CasCtrlMsg.AM_TYPE, casCtrllor);
		String lastSeqNo = getInfo(OasisConstants.ConfigPath+"/rpcSeqNo.ini");
		if (lastSeqNo != null){
			rpcApp.setSeqNo(Integer.parseInt(lastSeqNo));
		}
	}

/*************DEBUG**********end*******************************/













    //Collect info for Layout
	layoutInfo = new Vector();
	String layoutPath = getInfo(OasisConstants.ConfigPath+"/layout.ini");
	 System.out.println(layoutPath);
	if (layoutPath != null){
		File layoutfile =new File(layoutPath);
		if(layoutfile.exists()){
			System.out.println("load old layout!");
			loadLayoutFromFile(layoutfile);
		}
	}

  //  System.out.println(layoutPath);
	
    //Create a MoteIF interface with will handle message in wsn with any groupID
    System.err.println("Starting mote listener...");

    System.out.println(mote.getId());
    //System.out.println(rpcApp);
    System.out.println(XmlPath);
	System.err.println("Creating mainFrame...");

    mainFrame = new MainFrame(mote,XmlPath,xmp);
   displayManager = new DisplayManager();
   //System.err.println("Creating ObjectMaintainer...");
    objectMaintainer = new ObjectMaintainer();
    ObjectMaintainer.AddEdgeEventListener(displayManager);
    ObjectMaintainer.AddNodeEventListener(displayManager);
   //ObjectMaintainer.AddNodeEventListener((NodeEventListener)displayManager)
    //ObjectMaintainer.AddNodeEventListener((NodeEventListener)displayManager);
    //ObjectMaintainer.AddEdgeEventListener((EdgeEventListener)displayManager);
    
    System.err.println("Creating LocationAnalyzer...");
   locationAnalyzer = new LocationAnalyzer();
 
	System.err.println("Creating SensorAnalyzer...");
    sensorAnalyzer = new SensorAnalyzer();

    packetAnalyzers = new Vector();
    packetAnalyzers.add(objectMaintainer);
    packetAnalyzers.add(sensorAnalyzer);

    System.err.println("Making MainFrame visible...");
   mainFrame.setVisible(true);
    System.err.println("Ready.");
		mote.start();
     
  }

 public static MoteIF getMoteIF(){
    return mote;
  }

  //YYYCheck
  private static void usage(){
    System.out.println("\n==================================");
    System.out.println("Usage: monitor PLATFORM PORTNo ");
	System.out.println("       PLATFORM: tmote, micaz");
	System.out.println("       PORTNo: n for COMn, ");
	System.out.println("               which is the COM port of the Base node");
	System.out.println("  e.g: monitor tmote 19");
    System.out.println("==================================\n");

    System.exit(-1);
  }


/**************************debug******************************/

/**
	 * Make sure the setting of XmlPath for Rpc
	 * 
	 */
	public String rpcConfig(){
		 boolean exist;
		 String rpcxmlpath = null;
		 String ifile =OasisConstants.ConfigPath+"/rpcxmlpath.ini";
		 try {
			//Check xml file setting
			if (rpcxmlpath == null){
				//check required 2 xml files in current path
				File tmpfile = new File("");
				String curPath = tmpfile.getAbsolutePath();
				exist = ((new File(tmpfile.getAbsolutePath()+"/nescDecls.xml")).exists()
					     && (new File(tmpfile.getAbsolutePath()+"/rpcSchema.xml")).exists());
				
				if (exist) {
					//if xml files exists
					rpcxmlpath = curPath;
					//save to .ini file
					saveInfo(ifile, rpcxmlpath);				
				}
				else{
					//check old setting
					String path = getInfo(ifile);
					exist = ((new File(path+"/nescDecls.xml")).exists()
					&& (new File(path+"/rpcSchema.xml")).exists());
					if (exist){
						rpcxmlpath = path;
					}
				}
			}
		}
		catch (java.lang.Exception e) {
		}
       return rpcxmlpath;

    }



/**************************debug**end****************************/
	
	static public void saveInfo(String fileName, String string)
	{
		File file;
		BufferedWriter outstream;

		try {
			//Get file
			//fileName.replace('/','\\');
			boolean exists = (new File(fileName)).exists();
			if (!exists) {
				//create a new, empty ini file
				try {
					file = new File(fileName);
					boolean success = file.createNewFile();
				} catch (IOException e) {
					System.out.println("Create ini file failed!");
				}
			}

			//Write description into file 
			try {
				outstream = new BufferedWriter(new FileWriter(fileName, false));
				outstream.write(string);
				outstream.close();
			} catch (IOException e) {
			}
		}catch (java.lang.Exception e) {
		}		
	}

	static public String getInfo(String fileName)
	{
		File file;
		BufferedReader instream;
		String ret = null;

		try {
			//Get file
			//fileName.replace('/','\\');
			boolean exists = (new File(fileName)).exists();
			if (exists) {
				//Read from file 
				try {
					instream = new BufferedReader(new FileReader(fileName));
					ret = instream.readLine();
					System.out.println(ret);
					instream.close();
					return ret;
				} catch (IOException e) {
				}
			}
		}catch (java.lang.Exception e) {
		}
		
		return ret;
	}


    static public void loadLayoutFromFile(File layoutFile){
		BufferedReader reader = null;
		String readline = null;
		String patternStr = ",";
		int id;
		double x, y;
        
		//Load new layout from layoutFile
		try {
			reader = new BufferedReader(new FileReader(layoutFile));
		}
		catch (Exception e) {
			System.err.println("Layout file not found");
			return;
		}
		try {
			readline = reader.readLine();
		}
		catch (Exception e) {}

		//delete old layout
		layoutInfo.clear();
		LayoutInfo info = null;
		while (readline != null) {
			try {
				String [] result = readline.split(patternStr);
				id = Integer.parseInt(result[0]);
				x = Double.parseDouble(result[1]);
				y = Double.parseDouble(result[2]);

				//keep new layout
				info = new  LayoutInfo(id, x, y);
				layoutInfo.addElement(info);

				readline = reader.readLine();
			}
			catch (Exception e) {}
		}
		try {
			reader.close();
		}
		catch (Exception e) {}

		layoutFile = null;
	}


	static public class LayoutInfo
	{
		public int id;
		public double x;
		public double y;

		public LayoutInfo()
		{
			id = -1;
			x = 0;
			y = 0;
		}

		public LayoutInfo(int id, double x, double y )
		{
			this.id = id;
			this.x = x;
			this.y = y;
		}
	};



}
