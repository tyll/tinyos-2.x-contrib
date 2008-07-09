package com.rincon.tunit.exec;

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

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map.Entry;

import org.apache.log4j.Logger;

/**
 * Execute commands outside of Java. Execute the commmand and it returns the
 * output. Access 'lastExitVal' to determine what the exit status was.
 * 
 * @author David Moss
 * @author Miklos Maroti
 * @author Matthias Woehrle
 */
public class CmdExec {

  /** Logging */
  private static Logger log = Logger.getLogger(CmdExec.class);

  /** The exit value from the last command executed */
  public static int lastExitVal = 0;

  /** Capture the output stream from the running process */
  private static StreamCapture outputCapture = null;

  /** Capture the error stream from the running process */
  private static StreamCapture errorCapture = null;

  
  /**
   * Execute a command using the default environment.
   * This command will block until finished.
   * 
   * @param cmd
   * @return
   * @throws IOException
   */
  @SuppressWarnings("unchecked")
  static public String[] runBlockingCommand(String cmd) throws IOException {
    log.info(cmd);

    List tokenList = new ArrayList();
    String token = "";
    boolean inQuote = false;

    for (int i = 0; i < cmd.length(); i++) {
      if (token.length() > 0
          && (i == cmd.length() || (cmd.charAt(i) == ' ' && !inQuote))) {
        tokenList.add(token);
        token = "";
      } else {
        if (token.length() != 0 || cmd.charAt(i) != ' ')
          token += cmd.charAt(i);

        if (cmd.charAt(i) == '"')
          inQuote = !inQuote;
      }
    }

    String[] tokens = (String[]) tokenList.toArray(new String[0]);

    Process proc = Runtime.getRuntime().exec(tokens);

    outputCapture = new StreamCapture(proc.getInputStream(), "Output");
    errorCapture = new StreamCapture(proc.getErrorStream(), "Error");

    try {
      // Wait for process to terminate and catch any Exceptions.
      lastExitVal = proc.waitFor();
      log.debug("Exit Value: " + lastExitVal);
    } catch (InterruptedException e) {
      log.error("Command was interrupted");
    }

    log.debug("Done executing " + cmd);
    return (outputCapture.getCaptured() + errorCapture.getCaptured())
        .split("\n");
  }

  
  /**
   * Execute a command given the environment variables to work with as well.
   * This command will block until finished.
   * 
   * @param cmd
   * @param env
   * @return
   * @throws IOException
   */
  @SuppressWarnings("unchecked")
  static public String[] runBlockingCommand(String cmd, String env)
      throws IOException {
    log.info(cmd);

    String[] tokens = properlyTokenize(cmd);
    String[] envarray = createEnvironment(env);
    
    Process proc = Runtime.getRuntime().exec(tokens, envarray);

    outputCapture = new StreamCapture(proc.getInputStream(), "Output");
    errorCapture = new StreamCapture(proc.getErrorStream(), "Error");

    try {
      // Wait for process to terminate and catch any Exceptions.
      lastExitVal = proc.waitFor();
      log.debug("Exit Value: " + lastExitVal);
    } catch (InterruptedException e) {
      log.error("Command was interrupted");
    }

    log.debug("Done executing " + cmd);
    return (outputCapture.getCaptured() + errorCapture.getCaptured())
        .split("\n");
  }

  
  
  /**
   * Convert the output and error String[] to a String you can print to the
   * screen.
   * 
   * @param output
   * @return
   */
  static public String outputToString(String[] output) {
    String str = "";
    for (int i = 0; i < output.length; i++) {
      str += output[i] + "\n";
    }

    return str;
  }

  
  /**
   * The StringTokenizer will cut everything up, even text between quotes.
   * We need to make sure that text within a quote stays intact as one single
   * token to be passed as a complete argument.  So we setup this method
   * to properly tokenize a string that possibly contains quotes.
   * 
   * This helps stuff work on linux.
   * 
   * @param cmd The string to tokenize
   * @return A string[] of each element, properly tokenized
   */
  @SuppressWarnings("unchecked")
  static private String[] properlyTokenize(String cmd) {
    boolean inQuote = false;
    List tokenList = new ArrayList();
    String quoteToken = "";
    
    String[] rawCmdArray = cmd.split(" ");
    for (int i = 0; i < rawCmdArray.length; i++) {
      if(rawCmdArray[i].length() == 0) {
        // Get rid of array elements that were spaces to begin with
        continue;
      }
      
      if (!inQuote && !rawCmdArray[i].startsWith("\"")) {
        tokenList.add(rawCmdArray[i]);

      } else {
        inQuote = true;
        // Remove all quotes, add a space, and add it to our quoteToken 
        quoteToken += rawCmdArray[i].replaceAll("\"","") + " ";
        if (rawCmdArray[i].endsWith("\"")) {
          inQuote = false;
          tokenList.add(quoteToken);
          quoteToken = "";
        }
      }
    }
    
    return (String[]) tokenList.toArray(new String[0]);
  }
  
  
  /**
   * Create the environment variable from the existing environment plus
   * whatever is passed in manually.  This is to work on other OS's like
   * mac's or ubunto
   * 
   * @param env
   * @return
   */
  @SuppressWarnings("unchecked")
  static private String[] createEnvironment(String env) {
    List envList = new ArrayList();
    Entry entry;
    for(Iterator it = System.getenv().entrySet().iterator(); it.hasNext(); ) {
      entry = (Entry) it.next();
      
      envList.add((String) entry.getKey() + "=" + (String) entry.getValue());
    }
    
    if (env != null) {
      envList.add(env.replaceAll("\"",""));
    }
    
    return (String[]) envList.toArray(new String[0]);
  }
}
