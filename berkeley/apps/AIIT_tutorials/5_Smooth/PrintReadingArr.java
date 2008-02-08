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

public class PrintReadingArr implements MessageListener {

  public static short FLAG_BUFFER = 0x01;
  public static short FLAG_VOLTAGE_READING = 0x02;
  public static short FLAG_TEMPERATURE_READING = 0x04;

  private MoteIF moteIF;
  
  public PrintReadingArr(MoteIF moteIF) {
    this.moteIF = moteIF;
    this.moteIF.registerListener(new PrintReadingArrMsg(), this);
  }

  public void messageReceived(int to, Message message) {
    PrintReadingArrMsg msg = (PrintReadingArrMsg)message;

    System.out.println("Node " + msg.get_nodeid() + " readings: ");

    System.out.print("Raw: ");
    for (int i = 0; i < msg.numElements_raw_reading(); i++) {
      System.out.print(msg.getElement_raw_reading(i) + " ");
    }
    System.out.print("\n");

    System.out.print("Smooth: ");
    for (int i = 0; i < msg.numElements_smooth_reading(); i++) {
      System.out.print(msg.getElement_smooth_reading(i) + " ");
    }
    System.out.print("\n");

    System.out.println("Min: "  + msg.get_min() +
                       " Max: " + msg.get_max() +
                       " Mean: " + msg.get_mean());

    System.out.print("\n");
  }
  
  private static void usage() {
    System.err.println("usage: PrintReadingArr [-comm <source>]");
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
    PrintReadingArr serial = new PrintReadingArr(mif);
    //serial.sendPackets();
  }


}
