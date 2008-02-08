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

public class PrintReading implements MessageListener {

  public static short FLAG_BUFFER = 0x01;
  public static short FLAG_VOLTAGE_READING = 0x02;
  public static short FLAG_TEMPERATURE_READING = 0x04;

  private MoteIF moteIF;
  
  public PrintReading(MoteIF moteIF) {
    this.moteIF = moteIF;
    this.moteIF.registerListener(new PrintReadingMsg(), this);
  }

  public void messageReceived(int to, Message message) {
    PrintReadingMsg msg = (PrintReadingMsg)message;

    if ((msg.get_flag() & FLAG_VOLTAGE_READING) != 0) {
      System.out.print("Voltage: " + msg.get_voltage_reading() + " "); 
    }

    if ((msg.get_flag() & FLAG_TEMPERATURE_READING) != 0) {
      System.out.print("Temperature: " + msg.get_temperature_reading() + " "); 
    }

    if ((msg.get_flag() & FLAG_BUFFER) != 0) {
      for (int i = 0; i < msg.DEFAULT_MESSAGE_SIZE; i++) {
        char character = (char) msg.getElement_buffer(i);
        if (character == 0) {
          break;
        }
        System.out.print(character);
      }
    }

    System.out.print("\n");


  }
  
  private static void usage() {
    System.err.println("usage: PrintReading [-comm <source>]");
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
    PrintReading serial = new PrintReading(mif);
    //serial.sendPackets();
  }


}
