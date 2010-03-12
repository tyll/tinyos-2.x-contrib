package rpc.packet;

import java.io.*;
import java.util.*;
import rpc.util.GetEnv;
import rpc.util.Env;

public class Platform {
    protected static Hashtable idToKind, nameToSpec;

    static class PlatformSpec {
	String name;
	int platformId;
	int baudrate;
	boolean valid = false;

	PlatformSpec(String spec) {
	    try {
		StringTokenizer parser = new StringTokenizer(spec, ",");
		name = parser.nextToken();
		platformId = Integer.parseInt(parser.nextToken());
		baudrate = Integer.parseInt(parser.nextToken());
		valid = true;
	    } catch (Exception e) { }
	}

	public String toString() {
	    return name + "," + platformId + "," + baudrate;
	}
    }

    protected static PlatformSpec getPlatformByName(String name) {
	return (PlatformSpec)nameToSpec.get(name);
    }
    
    public final static int unknown = 0;
    public final static int defaultPlatform = 1;
    
    protected static void parseProperties(Properties p) {
	idToKind = new Hashtable();
	nameToSpec = new Hashtable();
	Enumeration e = p.keys();
	while (e.hasMoreElements()) {
	    String name = (String)e.nextElement();
	    String k = p.getProperty(name);
	    PlatformSpec pspec = new PlatformSpec(k);
	    if (pspec.valid) {
		idToKind.put(new Integer(pspec.platformId), pspec.name); 
		nameToSpec.put(name, pspec); 
	    }
	}
    }

    static {
    
	String propsName = new GetEnv().getEnv("TOS_PLATFORMS");
	boolean propsSpecified = true;
	if ((propsName == null) || (propsName.equals(""))) {
	    propsSpecified = false;
	    propsName = "platforms.properties";
	}
	Properties p = new Properties();
	try{
	    FileInputStream fis= new FileInputStream(propsName);
	    p.load(fis);
	} catch (IOException e) {
	    p.setProperty("mica","avrmote,1,19200");
	    p.setProperty("mica2dot","avrmote,1,19200");
	    p.setProperty("mica2", "avrmote,1,57600");
	    p.setProperty("telos","telos,2,57600");
	    p.setProperty("telosb","telos,2,57600");
	    p.setProperty("telosb2","115200");
	    p.setProperty("tmote","telos,2,57600");
	    p.setProperty("micaz","avrmote,3,57600");
	    p.setProperty("eyes","eyes,4,19200");
		//Andy: Enable imote2 platform
		p.setProperty("imote2","imote,5,115200");
	    if (propsSpecified) {
		System.err.println("Could not locate the platform property file "+
				   propsName);
		System.err.println("Using the default properties");
		try {
		    FileOutputStream fos=new FileOutputStream(propsName);
		    p.store(fos, "#Initial properties for the known platforms\n"+
			    "#This property file is used to associate the platforms specified in the comm\n"+
			    "#ID string (e.g. serial@COM1:mica) with various platform-specific parameters\n"+
			    "#The entry format is as follows: \n"+
			    "#\t<platform>=<platform package>, <integer ID>, <baudrate>\n"+
			    "#\twhere\n"+
			    "#<platform> -- that's the platform we compile for (i.e. valid nesc target\n"+
			    "#<platform package> -- name of the common package family that uses the same AM format (e.g. avrmote)\n"+
			    "#<integer ID> -- unique integer that is used by serial forwarder to identify the platform across the network\n"+
			    "#<baudrate> -- default serial port datarate used to communicate with the mote\n");
 
		} catch (Exception ee) {
		    System.err.println("Failed to save the initial properties");
		}
 	    }
	}
	parseProperties(p);
    }

    public static String getPlatformName(int p) {
	String name = (String)idToKind.get(new Integer(p));
	if (name == null) 
	    return "unknown";
	else
	    return name;
    }
    
    public static int decodeBaudrate(String args) {

	if (args == null)
	    return 19200;
	PlatformSpec pspec = getPlatformByName(args);
	try {
	    if (pspec != null) { // Cool, we know the platform
		return pspec.baudrate;
	    } else {
		return Integer.parseInt(args);
	    } 
	} catch (Exception e) {

	    System.err.println("Failed to parse the baudrate "+args+" (value "+args+"), defaulting to 19200");
	    return 19200;
	}
    }

    public static int decodePlatform(String args) {
	if (args == null)
	    return Platform.defaultPlatform;
	PlatformSpec pspec = getPlatformByName(args);
	if (pspec != null)
	    return pspec.platformId;
	else
	    return Platform.defaultPlatform;
    }

    public static void main(String [] argv) {
	System.out.println("Testing the property class\nCurrent properties:");
	Enumeration e = nameToSpec.keys();
	while (e.hasMoreElements()) {
	    String name = (String)e.nextElement();
	    PlatformSpec pspec = getPlatformByName(name);
	    System.out.println(name + "=" + pspec.toString());
	}

	if (argv.length != 3) {
	    System.err.println("Usage: java "+Platform.class.toString() + "<baudrate> <platform string> <platform id>");
	} else {
	    System.out.println("Baudrate for "+argv[0] + " "+decodeBaudrate(argv[0]));
	    System.out.println("Platform for "+argv[1] + " "+decodePlatform(argv[1]));
	    System.out.println("Platform for "+argv[2] + " "+getPlatformName(Integer.parseInt(argv[2])));
	}
    }

}
