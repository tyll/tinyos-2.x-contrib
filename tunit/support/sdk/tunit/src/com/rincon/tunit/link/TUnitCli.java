package com.rincon.tunit.link;

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
import net.tinyos.util.Messenger;

/**
 * Run a single TUnit test from the command line. 
 * This is not the preferred way to run TUnit, it just makes sure our 
 * communication is working properly.
 * 
 * @author David Moss
 *
 */
public class TUnitCli implements TUnitProcessing_Events {

  /** TUnit Processing */
  private TUnitProcessing tUnit;
  
  /**
   * Constructor
   * @param args
   */
  public TUnitCli(String[] args) {
    tUnit = new TUnitProcessing(new MoteIF((Messenger) null));
    tUnit.addListener(this);
    
    if (args.length < 1) {
      reportError("Not enough arguments");
    }
    
    // Get the arguments
    for (int i = 0; i < args.length; i++) {
      if (args[i].equalsIgnoreCase("-ping")) {
        System.out.println("Pinging node...");
        tUnit.ping();
        
      } else if (args[i].equalsIgnoreCase("-run")) {
        System.out.println("Running tests...");
        tUnit.runTest();
        
      } else {
        reportError("Unknown command");
      }
    }
  }
  
  private void reportError(String error) {
    System.err.println(error);
    System.err.println(getUsage());
    System.exit(1);
  }
  
  public static String getUsage() {
    String usage = "";
    usage += "  TUnitCli <command>\n";
    usage += "\t-ping\n";
    usage += "\t-run\n";
    return usage;
  }
  
  
  /**
   * Main method
   * @param args
   */
  public static void main(String[] args) {
    new TUnitCli(args);
  }

  public void tUnitProcessing_pong() {
    System.out.println("Pong!");
    System.exit(0);
  }

  public void tUnitProcessing_testSuccess(short testId, short assertionId) {
    System.out.println(testId + ": PASSED\n\t");
    // Don't exit until allDone()
  }
  
  public void tUnitProcessing_testFailed(short testId, short assertionId, String failMsg) {
    System.out.println(testId + ": FAILED\n\t" + failMsg);
    // Don't exit until allDone()
  }

  public void tUnitProcessing_allDone() {
    System.out.println("Done!");
    System.exit(0);
  }

}
