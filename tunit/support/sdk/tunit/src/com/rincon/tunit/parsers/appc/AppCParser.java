package com.rincon.tunit.parsers.appc;

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
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

import org.apache.log4j.Logger;

import com.rincon.tunit.report.TestResult;

/**
 * Parse an app.c file to extract test name information
 * 
 * @author David Moss
 * @author Till Maas
 */
public class AppCParser {
  
  static final String MODULE_NAME_TEST = "TestCaseC";
  static final String MODULE_NAME_STATS = "StatisticsC";

  /** Logging */
  private static Logger log = Logger.getLogger(AppCParser.class);
  
  /** App.c file to parse */
  private File myAppFile;

  /** Map of tests and their id's */
  private Map testMap;
  
  /** Map of the statistics and their id's */
  private Map statsMap;
  
  /** Map of which assertion number aligns with a Filename + line number */
  private Map assertionMap;

  /** Result of parsing the app.c file */
  private TestResult result;
  
  /** Original source code file name extracted from the app.c file */ 
  private String currentSourceCodeFilename;
  
  /** Line number in the current source code file that app.c maps to */
  private String currentSourceCodeLineNumber;
  
  /**
   * Constructor
   * 
   * @param appcFile
   */
  public AppCParser(File appcFile) {
    log = Logger.getLogger(getClass());
    myAppFile = appcFile;
    testMap = new HashMap();
    statsMap = new HashMap();
    assertionMap = new HashMap();
  }

  /**
   * Get a map of the test ID's and their names
   * 
   * @return
   */
  public Map getTestCaseMap() {
    return testMap;
  }
  
  /**
   * 
   * @return a map of the statistics parameterized ID's and their names
   */
  public Map getStatisticsMap() {
    return statsMap;
  }
  
  /**
   * 
   * @return a map of the assertion ID's to source code line numbers
   */
  public Map getAssertionMap() {
    return assertionMap;
  }
  
  /**
   * There are a few specific lines in nesC's app.c we're looking for. They are
   * of the form:
   * 
   * enum \\*[TestName]*\\TestCaseC$[ID]$__nesc_unnamedWXYZ {
   * 
   * Where \\'s are actually /'s and the $ are the nesc-separator, which is
   * currently "__". Anyway, we can map a test ID number from a parameterized
   * interface to the test's name. Automatically, but externally.  At least it
   * doesn't impact footprint size.
   */
  @SuppressWarnings("unchecked")
  public TestResult parse() {
    log.trace("AppCParser.parse()");
    result = new TestResult("__ParseAppC");
    if (!myAppFile.exists()) {
      log.warn("app.c file not found in " + myAppFile.getAbsolutePath());
      result.error("App.c Parser", "app.c file not found in " + myAppFile.getAbsolutePath());
      return result;
    }

    try {
      BufferedReader in = new BufferedReader(new FileReader(myAppFile));
      String line;

      while ((line = in.readLine()) != null) {
        extractOriginalFileAndLineNumber(line);
        extractAssertionId(line);
        extractModuleName(line, MODULE_NAME_TEST);
        extractModuleName(line, MODULE_NAME_STATS);
      }
      
      in.close();
      
    } catch (IOException e) {
      result.error("IOException", "IOException in app.c parser");
    }
    
    return result;
  }
  
  
  private void extractOriginalFileAndLineNumber(String line) {
    // Filenames and line numbers are stored on lines beginning with #'s:
    //
    // # 17 "/opt_svn/tinyos-2.x/tos/platforms/telosa/TelosSerialP.nc"
    // #line 17
    // [code]
    // #line 18
    // [code]
    //
    // Notice that the line with the filename starts with "# " while the line
    // with the line number starts with "#line". We'll use that to tell the
    // difference.
    
    if(line.startsWith("# ")) {
      // This line contains a filename. Get rid of the quotes and line number
      // # 17 "/opt_svn/tinyos-2.x/tos/platforms/telosa/TelosSerialP.nc"
      String lineSplit[] = line.split("\"");
      
      // The line is now split in two:
      // {"# 17 ", "/opt_svn/tinyos-2.x/tos/platforms/telosa/TelosSerialP.nc"}
      
      if(lineSplit.length > 1) {
        currentSourceCodeFilename = lineSplit[1];
      } else {
        currentSourceCodeFilename = "(unknown file)";
      }
      
    } else if(line.startsWith("#line")) {
      // This line contains a line number mapping. Simply remove the #.
      // #line 17 ==> "line 17"
      currentSourceCodeLineNumber = line.replace("#","");
    } 
    
  }
  
  @SuppressWarnings("unchecked")
  private void extractAssertionId(String line) {
    line = line.trim();
    
    // Catch these:
    // assertEqualsFailed("uint8_t", (uint32_t )(uint8_t )0xFF, (uint32_t
    // )(uint8_t )0xFF, 0U);
    //
    // assertTunitSuccess(1U);

    if(line.startsWith("assert") && line.endsWith("U);")) {
      
      line = line.replace("assertTunitSuccess(", "");
      
      // We've found a valid assertion! Figure out which assertId it is.
      String lineSplit[] = line.split(",");
      
      for(int i = 0; i < lineSplit.length; i++) {
        if(lineSplit[i].contains("U);")) {
          // This is the last argument containing " 0U);". Trim it, remove U);.
          assertionMap.put(Integer.decode(lineSplit[i].trim().replace("U);","")), 
              "\tat " + currentSourceCodeFilename + ", " + currentSourceCodeLineNumber + ":\n");
        }
      }
    }
  }
  
  
  @SuppressWarnings("unchecked")
  private void extractModuleName(String line, String moduleName) {
    Pattern moduleNamePattern = Pattern.compile("enum /\\*(.*)\\*/" + moduleName + "[^0-9]*([0-9]+)[^0-9]*__nesc_unnamed[0-9]*");
    Matcher moduleNameMatcher  = moduleNamePattern.matcher(line);
    if (moduleNameMatcher.find()) {
      String testName = moduleNameMatcher.group(1);
      int testId;
  
      try {
        testId = Integer.decode(moduleNameMatcher.group(2)).intValue();
        log.debug(moduleName + " ID " + testId + " is associated with test " + testName);
        
        if( moduleName.equals(MODULE_NAME_STATS) ) {
          statsMap.put(new Integer(testId), testName);
        } else {
          testMap.put(new Integer(testId), testName);
        }
        
      } catch (NumberFormatException e) {
    	result.error("NumberFormatException", "NumberFormatException in " + moduleName + "app.c parser");
      }
    }
  }
}
