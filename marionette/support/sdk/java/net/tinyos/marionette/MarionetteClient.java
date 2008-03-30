/* MarionetteClient: Java XML-RPC Test Client
 * author Michael Okola
 */

import java.net.*;
import org.apache.xmlrpc.*;
import org.apache.xmlrpc.client.*;

public class MarionetteClient {
    
    public static void main(String[] argv){
	XmlRpcClientConfigImpl config;
	XmlRpcClient client;
	config = new XmlRpcClientConfigImpl();
	client = new XmlRpcClient();
	try{
	    config.setServerURL(new URL("http://localhost:21777"));
	}
	catch(Exception e){ System.out.println("Cannot configure connection: " + e);}
	client.setConfig(config);

	Integer result;
	try{
	    result = (Integer) client.execute("app.TestMarionetteC.test.peek", new Object[]{});
	    System.out.println(result);
	    result = (Integer) client.execute("app.TestMarionetteC.test.poke", new Object[]{new Integer(2)});
	    System.out.println(result);
	    result = (Integer) client.execute("app.TestMarionetteC.test.peek", new Object[]{});
	    System.out.println(result);

	    System.out.println((String) client.execute("str", new Object[]{new String("app.TestMarionetteC")}));
	}
	catch(Exception e){ System.out.println("RPC Call exception: " + e);}
    }
	
}
