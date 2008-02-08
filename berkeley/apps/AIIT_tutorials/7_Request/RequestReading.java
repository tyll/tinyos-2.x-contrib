/*									tab:4
 * "Copyright (c) 2005 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
 * DOCUMENTATION, EVEN IF THE UNIVERSITY OF CALIFORNIA HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/**
 * Java-side application for testing serial port communication.
 * 
 *
 * @author Phil Levis <pal@cs.berkeley.edu>
 * @date August 12 2005
 */

import java.io.IOException;

import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;
import java.util.*;
import java.io.*;
import java.net.*;
import javax.swing.*;


public class RequestReading implements MessageListener {

  public static final short FLAG_COUNTER = 0x01;
  public static final short FLAG_VOLTAGE_READING = 0x02;
  public static final short FLAG_TEMPERATURE_READING = 0x04;
  public static final short FLAG_TEXT = 0x08;

  public static boolean bCounter = true;
  public static boolean bVoltage = false;
  public static boolean bTemperature = false;

  private static MoteIF moteIF;

  private static ClientWindow clntWindow = null;

  public RequestReading(MoteIF moteIF, String nodeid, short flag) {
    this.moteIF = moteIF;
    this.moteIF.registerListener(new RequestReadingMsg(), this);
  }

  public static void sendRequest(short nodeid) {
    RequestReadingMsg payload = new RequestReadingMsg();

    try {
      System.out.println("Sending packet to " + nodeid);

      payload.set_nodeid( nodeid );

      short flag = 0;
      if (bCounter) flag |= FLAG_COUNTER;
      if (bVoltage) flag |= FLAG_VOLTAGE_READING;
      if (bTemperature) flag |= FLAG_TEMPERATURE_READING;
      payload.set_flag( flag );

      //moteIF.send(moteIF.TOS_BCAST_ADDR, payload);
      moteIF.send(nodeid, payload);
    }
    catch (IOException exception) {
      System.err.println("Exception thrown when sending packets. Exiting.");
      System.err.println(exception);
    }
  }

  public void messageReceived(int to, Message message) {
    RequestReadingMsg msg = (RequestReadingMsg)message;

    String strOut = "Node ID: " + msg.get_nodeid() + " ";

    if ((msg.get_flag() & FLAG_COUNTER) != 0) {
      strOut += "Counter: " + msg.get_counter() + " "; 
    }

    if ((msg.get_flag() & FLAG_VOLTAGE_READING) != 0) {
      strOut += "Voltage: " + msg.get_voltage_reading() + " "; 
    }

    if ((msg.get_flag() & FLAG_TEMPERATURE_READING) != 0) {
      strOut += "Temperature: " + msg.get_voltage_reading() + " "; 
    }

    strOut += "\n";

    clntWindow.printMessage(strOut);
  }
  
  private static void usage() {
    System.err.println("usage: RequestReading [-comm <source>] [-v] [-t] [-c <counter_value>] [-m <text_message>] [-n <node_id>]");
    System.err.println("-v: get voltage reading");
    System.err.println("-t: get temperature reading");
    System.err.println("-n: set nodeid. Set to broadcast address if not specified.");
  }
  
  public static void main(String[] args) throws Exception {
    String source = null;
    String nodeid = null;
    short flag = 0;

    int i = 0;
    while (i < args.length) {
      if (args[i].equals("-comm")) {
        source = args[i+1];
        i += 2;
      }
      else if (args[i].equals("-v")) {
        flag |= FLAG_VOLTAGE_READING;    
        i++;
      }
      else if (args[i].equals("-t")) {
        flag |= FLAG_TEMPERATURE_READING;
        i++;
      }
      else if (args[i].equals("-n")) {
        nodeid = args[i+1];
        i += 2;
      }
      else {
        usage();
        System.exit(1);
      }
    }

    PhoenixSource phoenix;
    
    if (source == null) {
      phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
    }
    else {
      phoenix = BuildSource.makePhoenix(source, PrintStreamMessenger.err);
    }

    MoteIF mif = new MoteIF(phoenix);
    RequestReading serial = new RequestReading(mif, nodeid, flag );

    CreateGui();

    //serial.sendPackets(nodeid, flag);
  }

  private static void CreateGui ( )
  {
    // create frame
    JFrame clientFrame = new JFrame("RequestReading");
    // create client gui
    clntWindow = new ClientWindow ( clientFrame );
    // create comm processing thread
    clientFrame.addWindowListener( clntWindow );
    clientFrame.setSize( clntWindow.getPreferredSize() );
    clientFrame.getContentPane().add("Center", clntWindow);

    clientFrame.show();
  }


}
