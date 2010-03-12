package Config;

import java.util.*;

//Note: need to be consistent with :
//OASIS_ROOT/system/OasisType.h
public class OasisConstants {
    public static int RPC_MAX_BUFFER = 200;
    public static String DATASTREAM_XML_DIR;


    //Path Constants
    // 2007-08-10 10:13:02 ray-
    // change to unix format for both Cygwin and Linux
    public OasisConstants() {
        try {
            Properties env = getEnvironment();
            String myEnvVar;
            //System.out.println(env);
            //8/29/2008 Andy
            if (env == null) {
                myEnvVar = "/opt/oasis";
                //myEnvVar="E:/YXGDOC/Buz/workspace/svn/oasis";
                myEnvVar = "oasis";
            } else {
                myEnvVar = (String) env.get("OASIS_ROOT");
                //myEnvVar="E:/YXGDOC/Buz/workspace/svn/oasis";
                //myEnvVar = "oasis";
            }
            //8/29/2008 end
            //System.out.println(myEnvVar);
            String cygwinHome = "c:/tinyos/cygwin";
            String read = "";
            StringTokenizer tokenizer = new StringTokenizer(myEnvVar, "/");

            if (myEnvVar.indexOf("cygdrive") != -1) {
                myEnvVar = "";
                while (tokenizer.hasMoreTokens()) {
                    read = tokenizer.nextToken();
                    if (!read.equals("cygdrive")) {
                        myEnvVar += read + "/";
                    }
                }
                OasisConstants.OASIS_HOME = myEnvVar.substring(0, 1) + ":" + myEnvVar.substring(1);
            // System.out.println("a"+OasisConstants.OASIS_HOME );
            } else {
                OasisConstants.OASIS_HOME = cygwinHome + myEnvVar + "/";
                //xiaogang test
                OasisConstants.OASIS_HOME = myEnvVar + "/";
            // System.out.println("b"+OasisConstants.OASIS_HOME );
            }
           // OasisConstants.OASIS_HOME="./";
           // String prefix = "tools/com/oasis";
            //System.out.println(OasisConstants.OASIS_HOME + " " + OASIS_HOME);
            OasisConstants.DefaultPath = OasisConstants.OASIS_HOME + "apps";
            OasisConstants.IconFile = OasisConstants.OASIS_HOME +  "images/wsu.gif";
            OasisConstants.ToolsPath = OasisConstants.OASIS_HOME + "tools";
            OasisConstants.LogPath = OasisConstants.OASIS_HOME +  "Log";
            OasisConstants.ConfigPath = OasisConstants.OASIS_HOME + "Config";
            OasisConstants.XMLPath = OASIS_HOME + "apps/OasisApp/build/imote2";
            OasisConstants.rpcxmlpath = OASIS_HOME + "apps/MyApp/build/telosw";
            OasisConstants.EventLogger = OASIS_HOME + "tools/event.log";
            OasisConstants.RPCLogger = OASIS_HOME + "tools/rpc.log";
            OasisConstants.SFLogger = OASIS_HOME + "tools/sf.log";
            OasisConstants.SimServerEventLogger = OASIS_HOME + "/tools/sim.log";
            OasisConstants.DATASTREAM_XML_PATH = OASIS_HOME + "/DXM_DataStream/dxmstream_data.xml";
            OasisConstants.DATASTREAM_XML_DIR = OASIS_HOME + "/DXM_DataStream";
            OasisConstants.RES = OASIS_HOME + "images";
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public Properties getEnvironment() throws java.io.IOException {

        try {
            Properties env = new Properties();


            String OS = System.getProperty("os.name").toLowerCase();
            // System.out.println(OS);
            if (OS.indexOf("windows 9") > -1) {
                env.load(Runtime.getRuntime().exec("command.com /c set").getInputStream());
            } else if ((OS.indexOf("nt") > -1) || (OS.indexOf("windows 2000") > -1) || (OS.indexOf("windows xp") > -1)) {
                // thanks to JuanFran for the xp fix!
                env.load(Runtime.getRuntime().exec("cmd.exe /c set").getInputStream());

            } else {
                // our last hope, we assume Unix (thanks to H. Ware for the fix)

                env.load(Runtime.getRuntime().exec("env").getInputStream());
            }

            System.out.println(env.getProperty("TOS_PLATFORMS"));
            return env;
        } catch (Exception ex) {
            System.out.println("not get environment");
        }
        return null;
    }
    public static String OASIS_HOME = "";
    public static boolean DEBUG=false;
    // -ray
    public static String EventLogger = OASIS_HOME + "/tools/event.log";
    public static String RPCLogger = OASIS_HOME + "/tools/rpc.log";
    public static String SFLogger = OASIS_HOME + "/tools/sf.log";
    public static String SimServerEventLogger = OASIS_HOME + "/tools/sim.log";
    public static String DefaultPath = OASIS_HOME + "/apps";
    public static String IconFile = OASIS_HOME + "/tools/com/oasis/images/wsu.gif";
    public static String ToolsPath = OASIS_HOME + "/tools/com/oasis";
    public static String LogPath = OASIS_HOME + "/tools/com/oasis/Log";
    public static String ConfigPath = OASIS_HOME + "/tools/com/oasis/Config";
    public static String XMLPath = OASIS_HOME + "/apps/OasisApp/build/imote2";
    public static String rpcxmlpath = OASIS_HOME + "/apps/MyApp/build/telosw";
    public static String DATASTREAM_XML_PATH = OASIS_HOME + "/DXM_DataStream/dxmstream_data.xml";
    public static String RES = OASIS_HOME + "/tools/com/oasis/images";
    //General constants
    public static final short UART_ADDRESS = 0x007e;
    public static final int MAX_SIZE_READING = 100; //size of data in DataMsg
    public static final int ALL_NODES = 0xffff;
    public static final int ROOT_ID = 0;
    public static final int BASE_ID = 0;
    public static int MAX_LOCATION_INFO_SEND = 5;
    public static final int UNKNOWN_ID = 65535;
		
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
    public static int RSSI_TIMEOUT = 5;
    public static int TOSMSG_DATA_OFFSET = 8;
    //Standard OasisType
    public static final int AM_NETWORKMSG = 129;
   
    public static final int AM_TIMESYNCMSG = 0xAA;
    public static final int AM_ROUTEBEACONMSG = 130;
    public static final int AM_NEIGHBORBEACONMSG = 131;
    public static final int AM_CASCTRLMSG = 132;
    public static final int AM_RPCCASTMSG = 133;    //YFH: temp ID for NetworkMsg
    public static final int AM_RDTMSG = 115;
		public static final int AM_UNKNOWN = 65535;
    //Network_Msg types
    public static final int NW_DATA = 1;
    public static final int NW_SNMS = 2;
    public static final int NW_RPCR = 3;   //YFH: temp
    public static final int NW_RPCC = 4;   //YFH: temp
    public static final int NW_RSSI = 10;  //Andy
    public static final int NW_ESCAPE = 11;  //Andy
    public static final int NW_ALERT = 12;  //Andy
     public static final int NW_BEACONMSG = 250; //xiaogang
   public static final int NW_UNKNOWN = 65535;
    // Network layer destination addresses for non-unicast
    public static final int ADDR_SINK = 0xfd;
    public static final int ADDR_MCAST = 0xfe;
    public static final int ADDR_BCAST = 0xff;
    public static final int ADDR_UNKNOWN = 65535;
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
    public static final int TYPE_UNKNOWN = 65535;
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
    public static final int EVENT_TYPE_DATAMANAGE = 6;
    public static final int EVENT_TYPE_SEISMICEVENT = 7;
    //Event Level
    public static final int EVENT_LEVEL_URGENT = 0;    //go through filter guaranteed
    public static final int EVENT_LEVEL_HIGH = 1;
    public static final int EVENT_LEVEL_MEDIUM = 2;
    public static final int EVENT_LEVEL_LOW = 3;
    /** RPC  */
    // RPC response error code
    public static final int RPC_SUCCESS = 0;          /* packet contains return values */

    public static final int RPC_GARBAGE_ARGS = 1;     /* can't decode arguments */

    public static final int RPC_RESPONSE_TOO_LARGE = 2; /* can we check for this at compile time? */

    public static final int RPC_PROCEDURE_UNAVAIL = 3;
    public static final int RPC_SYSTEM_ERR = 4;
    public static final int RPC_WRONG_XML_FILE = 5;
    // RPC constants 
    public static final int RPC_RESPONSE_DESIRED = 1; /* 1: require response; 0: no response needed */

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
    //endian
    public static boolean BIG = false;
}


