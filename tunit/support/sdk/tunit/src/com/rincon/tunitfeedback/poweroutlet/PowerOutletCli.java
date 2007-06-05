package com.rincon.tunitfeedback.poweroutlet;

/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

import net.tinyos.message.MoteIF;
import net.tinyos.packet.BuildSource;
import net.tinyos.util.PrintStreamMessenger;

/**
 * Control the outlets through your command line
 * @author David Moss
 *
 */
public class PowerOutletCli {

  /**
   * Constructor
   * 
   */
  public PowerOutletCli(String[] args) {
    MoteIF mif = new MoteIF(BuildSource.makePhoenix(PrintStreamMessenger.err));
    PowerOutletFeedback feedback = new PowerOutletFeedback(mif);
    
    if(args.length == 0) {
      reportError("Not enough arguments");
    }
    
    if(args[0].equalsIgnoreCase("-green")) {
      System.out.println("Setting green");
      feedback.setPower(true, false);
      
    } else if(args[0].equalsIgnoreCase("-red")) {
      System.out.println("Setting red");
      feedback.setPower(false, true);
      
    } else if(args[0].equalsIgnoreCase("-both")) {
      System.out.println("Setting both");
      feedback.setPower(true, true);
      
    } else if(args[0].equalsIgnoreCase("-off")) {
      System.out.println("Turning off");
      feedback.setPower(false, false);
      
    } else {
      reportError("Incorrect argument");
    }
    
    System.exit(0);
  }

  private void reportError(String error) {
    System.err.println(error);
    System.err.println(getUsage());
    System.exit(1);
  }
  
  public static String getUsage() {
    String usage = "";
    usage += "  PowerOutletCli <command>\n";
    usage += "\t-green\n";
    usage += "\t-red\n";
    usage += "\t-both\n";
    usage += "\t-off\n";
    return usage;
  }
  
  /**
   * @param args
   */
  public static void main(String[] args) {
    new PowerOutletCli(args);
  }

}
