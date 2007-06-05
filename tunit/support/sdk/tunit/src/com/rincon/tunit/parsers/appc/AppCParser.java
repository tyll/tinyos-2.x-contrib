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
import java.util.StringTokenizer;

import org.apache.log4j.Logger;

import com.rincon.tunit.report.TestResult;

/**
 * Parse an app.c file to extract test name information
 * 
 * @author David Moss
 * 
 */
public class AppCParser {

  /** Logging */
  private static Logger log = Logger.getLogger(AppCParser.class);
  
  /** App.c file to parse */
  private File myAppFile;

  /** Map of tests and their id's */
  private Map testMap;
  
  /** Map of the statistics and their id's */
  private Map statsMap;

  /** Result of parsing the app.c file */
  private TestResult result;
  
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
  }

  /**
   * Get a map of the test ID's and their names
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
   * There are a few specific lines in nesC's app.c we're looking for. They are
   * of the form:
   * 
   * enum \\*[TestName]*\\TestCaseC$[ID]$__nesc_unnamedWXYZ {
   * 
   * Where \\'s are actually /'s. Anyway, we can map a test ID number from a
   * parameterized interface to the test's name. Automatically, but externally.
   * At least it doesn't impact footprint size.
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
        extractTestCaseName(line);
        extractStatisticsName(line);
        
      }
      
      in.close();
      
    } catch (IOException e) {
      result.error("IOException", "IOException in app.c parser");
    }
    
    return result;
  }
  
  
  @SuppressWarnings("unchecked")
  private void extractTestCaseName(String line) {
    if (line.contains("enum") && line.contains("/TestCaseC$")
        && line.contains("$__nesc_unnamed")) {

      // This is probably a line we're looking for. Let's parse it.
      // Right now it looks like 
      // enum /*TestStateC.Test1C*/TestCaseC$0$__nesc_unnamed4286 {
      
      line = line.replace("$", " ");
      line = line.replace("enum", " ");
      line = line.replace("/*", " ");
      line = line.replace("*/", " ");
      line = line.replace("{", " ");

      // Now our line looks like:
      // [TestName] TestCaseC [ID] __nesc_unnamedWXYZ
      // TestStateC.Test1C TestCaseC 0 __nesc_unnamed4286  
      
      StringTokenizer tokenizer = new StringTokenizer(line);
      String testName = tokenizer.nextToken();
      int testId;

      try {
        tokenizer.nextToken();
        testId = Integer.decode(tokenizer.nextToken()).intValue();
        log.debug("Test ID " + testId + " is associated with test " + testName);
        testMap.put(new Integer(testId), testName);
        
      } catch (NumberFormatException e) {
        result.error("NumberFormatException", "NumberFormatException in TestCase app.c parser");
      }
    }
  }
  
  
  @SuppressWarnings("unchecked")
  private void extractStatisticsName(String line) {
    if (line.contains("enum") && line.contains("/StatisticsC$")
        && line.contains("$__nesc_unnamed")) {

      // This is probably a line we're looking for. Let's parse it.
      // Right now it looks like 
      // enum /*TestTunitC.AckSuccessStatsC*/StatisticsC$0$__nesc_unnamed4302 {
      
      line = line.replace("$", " ");
      line = line.replace("enum", " ");
      line = line.replace("/*", " ");
      line = line.replace("*/", " ");
      line = line.replace("{", " ");

      // Now our line looks like:
      // TestTunitC.AckSuccessStatsC StatisticsC 0 __nesc_unnamed4302  
      
      StringTokenizer tokenizer = new StringTokenizer(line);
      String testName = tokenizer.nextToken();
      int statsId;

      try {
        tokenizer.nextToken();
        statsId = Integer.decode(tokenizer.nextToken()).intValue();
        log.debug("Statistics ID " + statsId + " is associated with test " + testName);
        statsMap.put(new Integer(statsId), testName);
        
      } catch (NumberFormatException e) {
        result.error("NumberFormatException", "NumberFormatException in Statistics app.c parser");
      }
    }
  }
}
