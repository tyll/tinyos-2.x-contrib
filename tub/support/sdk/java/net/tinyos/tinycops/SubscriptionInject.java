/**
 * @author Jan Hauer
 */
package net.tinyos.tinycops;
import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

import java.io.*; 
import java.text.*;
import java.util.*;


public class SubscriptionInject {
  protected static boolean unsubscribe = false;
  protected static boolean nokey = true;
  protected static Constraint constraint[];
  protected static int numConstraints = 0;
  protected static AVPair avpair[];
  protected static int numAvpair = 0;
  protected static short subscriptionDataSize = 0;
  protected static String port = "localhost:9002";
  protected static MoteIF moteIF;
  protected static String attributeFile = "../../../../../../tos/lib/tinycops/attributes/attributes.xml";
  protected static Map xmlAttribMap;

  public static void printHex(byte b)
  {
    String s = Integer.toHexString(0xFF & b).toUpperCase();
    System.out.print("0x" + ((b & 0xF0) > 0 ? "" : "0") + s + " ");
  }

  public static Attribute getAttribute(String name)
  {  
    for (Iterator it=xmlAttribMap.keySet().iterator(); it.hasNext();) {        
      Integer id = (Integer)it.next();
      Attribute attrib = (Attribute)xmlAttribMap.get(id);
      if (attrib.getName().equals(name))
        return attrib;
    }
    System.out.println("Error: attribute '"+name+"' not in "+attributeFile);
    System.exit(1);
    return null;
  }

  public static short getOperationID(TreeMap map, String operation, String attribute)
  {  
    for (Iterator it=map.keySet().iterator(); it.hasNext();) {        
      Integer id = (Integer)it.next();
      Operation op = (Operation)map.get(id);
      if (op.getName().equals(operation))
        return (short) op.getId();
    }
    System.out.println("Error: operation '"+operation+"' for attribute "+attribute+
        " not in "+attributeFile);
    System.exit(1);
    return 0;
  }

  public static short getSize(Attribute a)
  {
    short size = 255;
    if (a.getType().equals("uint8") ||  a.getType().equals("int8"))
      size = 1;
    else if (a.getType().equals("uint16") ||  a.getType().equals("int16"))
      size = 2;
    else if (a.getType().equals("uint32") ||  a.getType().equals("int32"))
      size = 4;
    // TODO: String and arrays
    return size;
  }

  public static void main(String[] args) {
    constraint = new Constraint[20]; 
    avpair = new AVPair[20];         
    //System.out.println("CONTRIBDIR="+System.getProperty("CONTRIBDIR"));
    //System.out.println("PATH="+System.getProperty("PATH"));
    //System.out.println("attributeFile="+attributeFile);

    parseArgs(args);
    nokey = false; 
    if ( nokey || (!unsubscribe && numConstraints == 0) ||  
        (unsubscribe && numConstraints > 0) ||
        (unsubscribe && numAvpair > 0))
      usage();
    if (unsubscribe){
      Attribute a = getAttribute("False");
      String operation = "ANY";
      long value = 1;
      short size = getSize(a);
      constraint[0] = new Constraint(size);
      constraint[0].set_attributeID((short) a.getId());
      constraint[0].set_operationID(
          getOperationID(a.getOperations(), operation, a.getName()));
      constraint[0].set_value(value);
      subscriptionDataSize += constraint[0].getSize();
      numConstraints = 1;
    }
    SubscriptionMsg msg = 
      new SubscriptionMsg(SubscriptionMsg.DEFAULT_MESSAGE_SIZE + subscriptionDataSize);

    short data[] = new short[subscriptionDataSize];
    System.out.println();
    System.out.print("Unsubscribe: ");
    if (unsubscribe)
      System.out.println("true");
    else
      System.out.println("false");

    int dataIndex = 0;
    for (int i=0; i<numConstraints; i++){
      System.out.print("Constraint["+i+"]: "+constraint[i]);
      byte[] d = constraint[i].dataGet();
      for (int k=0; k<d.length; k++)
        data[dataIndex++] = d[k];
    }
    for (int i=0; i<numAvpair; i++){
      System.out.print("AVPair["+i+"]: "+avpair[i]);
      byte[] d = avpair[i].dataGet();
      for (int k=0; k<d.length; k++)
        data[dataIndex++] = d[k];
    }
    msg.set_data(data);

    PacketSource packetSource = BuildSource.makeArgsSF(port);
    PhoenixSource source = BuildSource.makePhoenix(packetSource, null);
    try {
      moteIF = new MoteIF(source);
    } catch (Exception e) {
      System.out.println("Error: Cannot contact serial forwarder.");
      System.exit(1);
    }
    try {
      moteIF.send(0, msg);
    } catch (Exception e) {
      System.out.println("Error: Cannot send message !");
      System.exit(1);
    }
    System.out.print("Content: ");
    byte content[] = msg.dataGet();
    for (int i=0; i<content.length; i++)
      printHex((byte)content[i]);
    System.out.println();
    System.out.println();
    try {
      Thread.sleep(2000);
    } catch (Exception e) {
    }
    System.out.println("Subscription injected successfully.");
    System.out.println();
    System.exit(0);
  }

  public static void parseArgs(String args[]) {
    if (args.length == 0)
      usage();
    for(int i = 0; i < args.length; i++)
      if (args[i].startsWith("-")) {
        // Options
        String opt = args[i].substring(1);
        if (opt.equals("xml")) 
          attributeFile = args[++i];
      }
    try {
      xmlAttribMap = new AttributeWrapper(attributeFile, "ps_attribute").getAttributesMap();
    } catch (Exception e) {
      System.out.println("Error: file "+attributeFile+" not found!");
      System.exit(1);
    }

    for(int i = 0; i < args.length; i++) {
      if (args[i].startsWith("--")) {
        String longopt = args[i].substring(2);
        if (longopt.equals("help")) {
          usage();
        }
      } else if (args[i].startsWith("-")) {
        // Options
        String opt = args[i].substring(1);
        if (opt.equals("sf")) {
          port = args[++i];
        } else if (opt.equals("xml")) {
          attributeFile = args[++i];
        } else if (opt.equals("unsubscribe")) {
          unsubscribe = true;
        } else if (opt.equals("constraint")) {
          Attribute a = getAttribute(args[++i]);
          String operation = args[++i];
          long value = 0;
          try {
            value = Long.parseLong(args[++i]);
          } catch (Exception e) {
            System.out.println("Error: unknown value for for attribute "+a.getName());
            System.exit(1);
          }
          short size = getSize(a);

          if (size == 255){
            System.out.println("Error: unknown size for for attribute "+a.getName());
            System.exit(1);
          }
          constraint[numConstraints] = new Constraint(size);
          constraint[numConstraints].set_attributeID((short) a.getId());
          constraint[numConstraints].set_operationID(
              getOperationID(a.getOperations(), operation, a.getName()));
          constraint[numConstraints].set_value(value);
          subscriptionDataSize += constraint[numConstraints].getSize();
          numConstraints++;
        } else if (opt.equals("metadata")) {
          Attribute a = getAttribute(args[++i]);
          long value = 0;
          try {
            value = Long.parseLong(args[++i]);
          } catch (Exception e) {
            System.out.println("Error: unknown value for for attribute "+a.getName());
            System.exit(1);
          }
          short size = getSize(a);

          if (size == 255){
            System.out.println("Error: unknown size for for attribute "+a.getName());
            System.exit(1);
          }
          avpair[numAvpair] = new AVPair(size);
          avpair[numAvpair].set_attributeID((short) a.getId());
          avpair[numAvpair].set_value(value);
          subscriptionDataSize += avpair[numAvpair].getSize();
          numAvpair++;
        } else {
          System.out.println("Ignoring unknown option "+opt);
        }
      }
    }
  }
  public static void usage() {
    System.out.println("usage: java net.tinyos.tinycops.SubscriptionInject <options>");
    System.out.println();
    System.out.println("Valid options are:");
    System.out.println("  -sf <host:port>");
    System.out.println("    'host:port' of a SerialForwarder (default is localhost:9002).");
    System.out.println("  -constraint <attribute> <operation> <value>");
    System.out.println("    Attribute, operator names and values as defined in attributes.xml");
    System.out.println("  -metadata <attribute> <value>");
    System.out.println("    Attribute names and values as defined in attributes.xml");
    System.out.println("  -unsubscribe");
    System.out.println("    Unsubscribes the subscription identified by 'baseClientID'");
    System.out.println("  -xml <path>");
    System.out.println("    The attributes.xml file containing attribute definitions, default: "+attributeFile);
    System.out.println("  -h or --help display this help");
    System.out.println();
    System.out.println("Example:");
    System.out.println(" 'java net.tinyos.tinycops.SubscriptionInject -constraint Ping ANY 0 -metadata Rate 10'");
    System.exit(0);
  }
}
