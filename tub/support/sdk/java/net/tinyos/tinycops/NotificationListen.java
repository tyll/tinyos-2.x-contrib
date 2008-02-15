/**
 *
 * @author Jan Hauer
 */

package net.tinyos.tinycops;
import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

import java.io.*; 
import java.text.*;
import java.util.*;

public class NotificationListen implements MessageListener {
  private MoteIF moteIF;
  private int messageCount = 0;
  
  public static void printHex(byte b)
  {
    String s = Integer.toHexString(0xFF & b).toUpperCase();
    System.out.print("0x" + ((b & 0xF0) > 0 ? "" : "0") + s + " ");
  }

  public NotificationListen(String port)
  {
    PacketSource packetSource = BuildSource.makeArgsSF(port);
    PhoenixSource source = BuildSource.makePhoenix(packetSource, null);
    try {
      moteIF = new MoteIF(source);
      moteIF.registerListener(new NotificationMsg(), this);
      moteIF.registerListener(new CtpMsg(), this);
      //moteIF.registerListener(new FloodMsg(), this);
    } catch (Exception e) {
      System.out.println("Error: Can't contact serial forwarder.");
      System.exit(1);
    }
  }

  public void messageReceived(int to, Message m) {
    NotificationMsg nMsg = null;
    int amID = m.amType();
    System.out.print("Received notification");
    switch (amID)
    {
      case NotificationMsg.AM_TYPE:
        System.out.print(" (no routing header present)");
        nMsg = (NotificationMsg) m;
        break;
      case CtpMsg.AM_TYPE:
        System.out.print(" (CTP header: ");
        CtpMsg ctp = (CtpMsg) m;
        System.out.print(" node "+ctp.get_header_origin()+")");
        nMsg = new NotificationMsg(ctp, ctp.DEFAULT_MESSAGE_SIZE, m.dataLength() - ctp.DEFAULT_MESSAGE_SIZE);
        break;
//      case FloodMsg.AM_TYPE:
//        System.out.print(" (Flood header)");
//        FloodMsg fmsg = (FloodMsg) m;
//        nMsg = new NotificationMsg(fmsg, fmsg.DEFAULT_MESSAGE_SIZE, m.dataLength() - fmsg.DEFAULT_MESSAGE_SIZE);
//        break;
      default:
        System.out.println("-- cannot parse msg content, unknown amType: "+amID);
        return;
    }
    short data[] = new short[nMsg.dataLength()];
    System.out.print(", notification content: ");
    for (int i = 0; i<nMsg.dataLength(); i++){
      data[i] = nMsg.getElement_data(i);
      System.out.print(" 0x"+Long.toHexString(data[i]));
    }
    System.out.println();
  }

  public static void main(String[] args) {
    String port = "localhost:9002";
    System.out.println("Usage: java NotificationListen [host:port]");
    System.out.println("       where 'host:port' addresses a SerialForwarder (default is localhost:9002).");
    if (args.length == 1)
      port = args[0];
    System.out.println();
    System.out.println("Listening for notifications (press Ctrl-c to exit):");
    System.out.println();
    new NotificationListen(port);
    while(true)
      ;
  }
  
  
}
