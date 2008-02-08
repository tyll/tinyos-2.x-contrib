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

public class PrintCounterReading implements MessageListener {

  public static short FLAG_COUNTER = 0x01;
  public static short FLAG_VOLTAGE_READING = 0x02;

  private MoteIF moteIF;
  
  public PrintCounterReading(MoteIF moteIF) {
    this.moteIF = moteIF;
    this.moteIF.registerListener(new PrintCounterReadingMsg(), this);
  }

  public void messageReceived(int to, Message message) {
    PrintCounterReadingMsg msg = (PrintCounterReadingMsg)message;

    System.out.print("Node ID: " + msg.get_nodeid() + " "); 

    if ((msg.get_flag() & FLAG_COUNTER) != 0) {
      System.out.print("Counter: " + msg.get_counter() + " "); 
    }

    if ((msg.get_flag() & FLAG_VOLTAGE_READING) != 0) {
      System.out.print("Voltage: " + msg.get_voltage_reading() + " "); 
    }

    System.out.print("\n");


  }
  
  private static void usage() {
    System.err.println("usage: PrintCounterReading [-comm <source>]");
  }
  
  public static void main(String[] args) throws Exception {
    String source = null;
    if (args.length == 2) {
      if (!args[0].equals("-comm")) {
	usage();
	System.exit(1);
      }
      source = args[1];
    }
    else if (args.length != 0) {
      usage();
      System.exit(1);
    }
    
    PhoenixSource phoenix;
    
    if (source == null) {
      phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
    }
    else {
      phoenix = BuildSource.makePhoenix(source, PrintStreamMessenger.err);
    }

    MoteIF mif = new MoteIF(phoenix);
    PrintCounterReading serial = new PrintCounterReading(mif);
    //serial.sendPackets();
  }


}
