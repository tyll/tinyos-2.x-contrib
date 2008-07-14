package com.rincon.tunit.run;

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

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

/**
 * This class writes down the tests that failed to non-volatile memory -
 * (tests-failed.log). If invoked, it reads the file and dictates which 
 * TestRunner's can proceed and which can't.
 * 
 * The constructor must be called once before the system uses
 * the RerunRegistry
 * 
 * @author David Moss
 * 
 */
public class RerunRegistry {

  /** Logging */
  private static Logger log = Logger.getLogger(RerunRegistry.class);

  /** True if we are rerunning only the tests that failed */
  private static boolean rerunEnabled = false;

  /** Array of unique package names to rerun */
  private static String[] rerunPackages = new String[0];

  /** The actual file, created when we know the base directory */
  private static File rerunFile = null;

  /** Writer */
  private static PrintWriter out;

  /**
   * Constructor
   * 
   * @param baseDirectory
   */
  public RerunRegistry(File baseDirectory) {
    rerunFile = new File(baseDirectory, "tests-failed.log");
  }
  
  /**
   * Alternative Constructor
   *
   */
  public RerunRegistry() {
  }
  
  /**
   * Set the base TUnit directory
   * @param baseDirectory
   */
  public void setBaseDirectory(File baseDirectory) {
    rerunFile = new File(baseDirectory, "tests-failed.log");
  }

  /**
   * Enable running only tests that failed by passing in the base directory. The
   * rerunEnabled flag is set to true, which changes the execution of the
   * TestRunner class. The baseDirectory will contain a file that has rerun
   * properties. If that file is found, it is parsed and package id's that need
   * to be rerun will be extracted. If it is not found or there are no package
   * id's, then we don't need to rerun anything. It should be up to the TUnit
   * class to double check if we have anything to run before wasting time
   * traversing through directories.
   * 
   * @param baseDirectory
   */
  @SuppressWarnings({"unchecked"})
  public void enableRerun() {
    if (rerunEnabled) {
      // Only run this once.
      return;
    }

    log.debug("Rerun enabled");
    rerunEnabled = true;
    List packageList = new ArrayList();
    
    if (!rerunFile.exists()) {
      log.debug("No rerun registry log exists");
      return;
    }

    try {
      BufferedReader in = new BufferedReader(new FileReader(rerunFile));
      String line;

      while ((line = in.readLine()) != null) {
        if (!line.trim().matches("")) {
          packageList.add(line);
          log.info("'" + line + "'");
        }
      }

      in.close();
    } catch (IOException e) {
      e.printStackTrace();
    }

    rerunPackages = (String[]) packageList.toArray(new String[0]);
    
    log.info(rerunPackages.length + " tests to rerun");
  }

  /**
   * 
   * @return total number of packages that need to be rerun from last time
   */
  public int getTotalReruns() {
    return rerunPackages.length;
  }
  
  /**
   * Reset the list of failed tests stored in non-volatile memory
   * 
   * @param baseDirectory
   */
  public void clean() {
    log.debug("Cleaning rerun registry");
    if (rerunFile.exists()) {
      rerunFile.delete();
    }

    try {
      rerunFile.createNewFile();

    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  /**
   * 
   * @return true if we're only running the tests that previously failed
   */
  public static boolean isRerunEnabled() {
    return rerunEnabled;
  }

  /**
   * 
   * @param packageId
   * @return true if the test in the given package should be run
   */
  public static boolean shouldRun(String packageId) {
    if(!rerunEnabled) {
      return true;
    }
    
    for (int i = 0; i < rerunPackages.length; i++) {
      if (rerunPackages[i].matches(packageId)) {
        return true;
      }
    }
    return false;
  }

  /**
   * Log a failed test by its package id
   * 
   * @param packageId
   */
  public static void logFailure(String packageId) {
    try {
      if (out == null) {
        out = new PrintWriter(new BufferedWriter(new FileWriter(rerunFile)));
      }

      out.write(packageId + "\n");
      out.flush();
      
      // We never really close the file because we can write to it at any time
      
    } catch (IOException e) {
    }
  }
}
