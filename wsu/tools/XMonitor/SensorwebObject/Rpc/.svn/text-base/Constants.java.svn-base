package SensorwebObject.Rpc;

import java.util.*;

//Note: need to be consistent with :
//OASIS_ROOT/system/OasisType.h


public class Constants
{

	//Path Constants
	// 2007-08-10 10:13:02 ray-
	// change to unix format for both Cygwin and Linux

	public Constants(){
		try {
		Properties env = getEnvironment();
		String myEnvVar;
		
		//8/29/2008 Andy
		if (env == null)
			myEnvVar = "/opt/oasis";
		else myEnvVar = (String)env.get("HOME");
		//8/29/2008 end

		String cygwinHome= "c:/tinyos/cygwin";
		String read = "";
		StringTokenizer tokenizer = new StringTokenizer(myEnvVar,"/");
	
		if (myEnvVar.indexOf("cygdrive") != -1){
			myEnvVar = "";
			while (tokenizer.hasMoreTokens()){
				read = tokenizer.nextToken();
				if (!read.equals("cygdrive"))
				{
					myEnvVar += read + "/";
				}
			}
			Constants.OASIS_HOME = myEnvVar.substring(0,1) + ":" + myEnvVar.substring(1);
		}
		else {
			Constants.OASIS_HOME = cygwinHome + myEnvVar + "/";
		}

		Constants.DefaultPath = Constants.OASIS_HOME + "apps";
		Constants.IconFile = Constants.OASIS_HOME + "tools/com/oasis/images/wsu.gif";
		Constants.ToolsPath = Constants.OASIS_HOME + "tools/com/oasis";
		Constants.LogPath  = Constants.OASIS_HOME + "tools/com/oasis/Log";
		Constants.ConfigPath  = Constants.OASIS_HOME + "tools/com/oasis/Config";
		Constants.XMLPath = OASIS_HOME + "/apps/OasisApp/build/imote2";
		Constants.EventLogger = OASIS_HOME + "/tools/event.log";
		Constants.RPCLogger = OASIS_HOME + "/tools/rpc.log";
		Constants.SFLogger = OASIS_HOME + "/tools/sf.log";
		Constants.SimServerEventLogger = OASIS_HOME + "/tools/sim.log";
		
		
	}
	catch (Exception ex){ex.printStackTrace();}
	}

	public Properties getEnvironment() throws java.io.IOException {
  	    try {
	   	  Properties env = new Properties();
	  	  //env.load(Runtime.getRuntime().exec("env").getInputStream());
          env.load(Runtime.getRuntime().exec("set").getInputStream());
          System.out.println(env.getProperty("HOME"));
	 	  return env;
  	    }
	    catch (Exception ex){}
	    return null;
   }
	
	public static String OASIS_HOME = "";
	// -ray
	public static String EventLogger = OASIS_HOME + "/tools/event.log";
	public static String RPCLogger = OASIS_HOME + "/tools/rpc.log";
	public static String SFLogger = OASIS_HOME + "/tools/sf.log";
	public static String SimServerEventLogger = OASIS_HOME + "/tools/sim.log";
	public static String DefaultPath = OASIS_HOME + "/apps";
	public static String IconFile = OASIS_HOME + "/tools/com/oasis/images/wsu.gif";
	public static String ToolsPath = OASIS_HOME + "/tools/com/oasis";
	public static String LogPath  = OASIS_HOME + "/tools/com/oasis/Log";
	public static String ConfigPath  = OASIS_HOME + "/tools/com/oasis/Config";
	public static String XMLPath  = OASIS_HOME + "/apps/OasisApp/build/imote2";
	
	
	//General constants
   	public static final short UART_ADDRESS = 0x007e;
	public static final int MAX_SIZE_READING = 100; //size of data in DataMsg
	public static final int ALL_NODES = 0xffff;

	public static final int ROOT_ID = 10;   
	public static final int BASE_ID = 0;   
	public static int MAX_LOCATION_INFO_SEND = 5;

	/*Andy use interval to calculate rate
    //Data gathering rate (ms)
       public static final int SEISMIC_DATA_RATE = 9*50;
	public static final int INFRASONIC_DATA_RATE = 17*50;
	public static final int LIGHTNING_DATA_RATE = 141*50;
	public static final int GPS_DATA_RATE = 1001*50;
	*/


//Drain:
 // public static int TOS_UART_ADDR = 0x7e;
 // public static int DEFAULT_MOTE_ID = 0xfffe;
 	public static int BCAST_ID = 0xffff;
	public static int MAX_VALUE_DATA = 0xffff;
	public static int MIN_VALUE_DATA = 0;
	public static int RSSI_TIMEOUT =  5;
    
	//Standard OasisType
	public static final int AM_NETWORKMSG = 129;
	public static final int AM_ROUTEBEACONMSG = 130;
	public static final int AM_NEIGHBORBEACONMSG = 131;
	public static final int AM_CASCTRLMSG = 132;
	public static final int AM_RPCCASTMSG  = 133;    //YFH: temp ID for NetworkMsg
       public static final int AM_RDTMSG = 115;

	//Network_Msg types
	public static final int NW_DATA = 1;
	public static final int NW_SNMS = 2;
	public static final int NW_RPCR = 3;   //YFH: temp
	public static final int NW_RPCC = 4;   //YFH: temp
	public static final int NW_RSSI = 10;  //Andy
	public static final int NW_ESCAPE = 11;  //Andy
	public static final int NW_ALERT = 12;  //Andy

    // Network layer destination addresses for non-unicast
    public static final int ADDR_SINK = 0xfd;
    public static final int ADDR_MCAST = 0xfe;
    public static final int ADDR_BCAST = 0xff;

	//App Type
	public static final int TYPE_DATA_UNKNOWN = -1;
	public static final int TYPE_LIGHTNING = 0;
	public static final int TYPE_LIGHTNING_EXTRA = 2;
	public static final int TYPE_RSSI = 20;
	public static final int TYPE_ESCAPEGUIDE = 21;
	public static final int TYPE_ALERT = 22;
	public static final int TYPE_OTHER = 30;
	public static final int EDGE_MULTIHOP = 1;
	public static final int EDGE_ESCAPE = 2;

    //public static final int TYPE_DATA_SEISMIC = 0;
    //public static final int TYPE_DATA_INFRASONIC = 1;
    //public static final int TYPE_DATA_LIGHTNING = 2;
    //public static final int TYPE_DATA_RSAM = 3;
    //public static final int TYPE_DATA_GPS = 8;

    public static final int TYPE_SNMS_EVENT = 11;
    public static final int TYPE_SNMS_RPCCOMMAND = 12;
    public static final int TYPE_SNMS_RPCRESPONSE = 13;
    public static final int TYPE_SNMS_CODE = 14;

   //Timer Type
    public static final int RTC_TIME = 0;
    public static final int PC_TIME = 1;

    //Event Type
	public static final int EVENT_TYPE_ALL = 0;   // used to set filter for all event types
    public static final int EVENT_TYPE_SNMS = 1;    
    public static final int EVENT_TYPE_SENSING = 2;    
    public static final int EVENT_TYPE_MIDDLEWARE = 3;    
    public static final int EVENT_TYPE_ROUTING = 4;
    public static final int EVENT_TYPE_MAC = 5;
    
	//Event Level
	public static final int EVENT_LEVEL_URGENT = 0;    //go through filter guaranteed
    public static final int EVENT_LEVEL_HIGH = 1; 
    public static final int EVENT_LEVEL_MEDIUM = 2;
    public static final int EVENT_LEVEL_LOW = 3;

	
    /** RPC  */
	// RPC response error code 
	public static final int  RPC_SUCCESS   = 0;          /* packet contains return values */
    public static final int  RPC_GARBAGE_ARGS   = 1;     /* can't decode arguments */
    public static final int  RPC_RESPONSE_TOO_LARGE = 2; /* can we check for this at compile time? */
    public static final int  RPC_PROCEDURE_UNAVAIL  = 3;
    public static final int  RPC_SYSTEM_ERR         = 4; 
	public static final int  RPC_WRONG_XML_FILE     = 5;
    // RPC constants 
    public static final int  RPC_RESPONSE_DESIRED   = 1; /* 1: require response; 0: no response needed */

	//8/5/2007 For Cascade
	public static final int MAX_CMD_RECORD_NUM = 10;
	public static final int TYPE_CASCADES_NODATA = 17;
	public static final int TYPE_CASCADES_ACK = 18;
	public static final int TYPE_CASCADES_REQ = 19;


	/** Rawdata */
	public static final int TOS_MSG_HEADER_LEN = 10;
	public static final int MAX_FILTER_NODE_NUM = 100;
	public static final int MAX_FILTER_TYPE_NUM = 10;
	public static final int MSG_BUFFER_SIZE = 256;
	public static final int ANY_TYPE_MSG = -1;
	
	//Define the type of received message
	public static final int NORM = 0;
	public static final int MISS = 1;
	public static final int DUP = 2;
    public static final int MAX_NODE_NUM = 1000;  
	public static final int RESET_PERIOD = 200;  //max seqNo = 256

	/** Oscope */
	public static final int OSCOPE_REFRESH_RATE = 3;  //num of recvd msgs


	//YYY:8/24/2007
	/** Debugging Flags */
	public static final boolean RPC_DEBUG = false;  



}


