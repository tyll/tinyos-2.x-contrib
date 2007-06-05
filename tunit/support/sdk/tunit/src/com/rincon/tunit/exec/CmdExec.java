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

import org.apache.log4j.Logger;


/**
 * Execute commands outside of Java.  Execute the commmand and it returns the
 * output.  Access 'lastExitVal' to determine what the exit status was.
 * @author David Moss
 *
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
	 * Run a command on the command line
	 * @param cmd
	 * @return
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
  static public String[] runCommand(String cmd) throws IOException {
    log.info(cmd);
    
		Process proc = Runtime.getRuntime().exec(cmd);
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
		return (outputCapture.getCaptured() + errorCapture.getCaptured()).split("\n");
	}
}
