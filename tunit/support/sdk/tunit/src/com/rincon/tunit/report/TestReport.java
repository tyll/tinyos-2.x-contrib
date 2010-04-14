package com.rincon.tunit.report;

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

import java.util.ArrayList;
import java.util.List;

import com.rincon.tunit.properties.TUnitSuiteProperties;
import com.rincon.tunit.properties.TUnitTestRunProperties;
import com.rincon.tunit.run.RerunRegistry;

/**
 * Gathers all the test result information about a single test suite
 * 
 * @author David Moss
 * 
 */
public class TestReport {

  /** T-Unit test run information that produced these results */
  private TUnitTestRunProperties myTestRun;

  /** Suite information for the test being executed */
  private TUnitSuiteProperties mySuite;

  /** Name of the "package" - i.e. the directory structure where this test is */
  private String myPackage;

  /** Total amount of time spent on this test */
  private float totalDuration;

  /** Total number of failures */
  private int totalFailures;

  /** Total number of errors */
  private int totalErrors;

  /** List of results */
  private List results;

  /** Total T-Unit tests run by this entire system */
  private static int totalTunitTests = 0;

  /** Total duration of all tests run by this entire system */
  private static float totalTunitDurations = 0;

  /** Total failures encountered by this entire system */
  private static int totalTunitFailures = 0;

  /** Total errors encountered by this entire system */
  private static int totalTunitErrors = 0;

  /** TestResult's of all problems encountered by this entire system */
  private static List allTunitProblems = new ArrayList();

  /** Creation time of this object in milliseconds */
  private long lastTime;
  
  /** True if we've previously logged this suite as needing to rerun */
  private boolean rerunLogged;
  
  /** System output to be logged in addition to test results */
  private String systemOut;
  
  /** System errors to be logged in addition to test results */
  private String systemErr;
  
  /**
   * Constructor
   * 
   * @param tunitProperties
   * @param suiteProperties
   * @param packageId
   *          the name of the directory the test is found in, minus all the
   *          stuff leading up to the base tunit directory
   */
  public TestReport(TUnitTestRunProperties tunitProperties,
      TUnitSuiteProperties suiteProperties, String packageId) {
    myTestRun = tunitProperties;
    mySuite = suiteProperties;
    myPackage = packageId;
    totalDuration = 0;
    totalFailures = 0;
    totalErrors = 0;
    rerunLogged = false;
    systemOut = "";
    systemErr = "";
    results = new ArrayList();
    allTunitProblems = new ArrayList();
    lastTime = System.currentTimeMillis();
  }
  
  public static void clear() {
    totalTunitTests = 0;
    totalTunitDurations = 0;
    totalTunitFailures = 0;
    totalTunitErrors = 0;
  }

  @SuppressWarnings("unchecked")
  public void addResult(TestResult result) {
    incrementDuration(result);
    
    totalTunitTests++;
    if (result.isError()) {
      incrementErrors();
      addGlobalProblem(result);
      
    } else if (result.isFailure()) {
      incrementFailures();
      addGlobalProblem(result);
    }

    results.add(result);
  }

  public void addSystemOut(String out) {
    systemOut += out + "\n\n"; 
  }

  public void addSystemErr(String err) {
    systemErr += err + "\n\n";
  }
  
  public TestResult getTestResult(int i) {
    return (TestResult) results.get(i);
  }

  public String getPackage() {
    return myPackage;
  }

  public TUnitSuiteProperties getSuite() {
    return mySuite;
  }

  public TUnitTestRunProperties getTestRun() {
    return myTestRun;
  }

  public float getTotalDuration() {
    return totalDuration;
  }

  public int getTotalErrors() {
    return totalErrors;
  }

  public int getTotalFailures() {
    return totalFailures;
  }

  public int getTotalTests() {
    return results.size();
  }

  public String getSystemOut() {
    return systemOut;
  }
  
  public String getSystemErr() {
    return systemErr;
  }
  
  /**
   * 
   * @return List of TestResult errors and failures encountered by the entire
   *   T-Unit system run
   */
  public static List getAllTunitProblems() {
    return allTunitProblems;
  }

  /**
   * 
   * @return the total duration for the entire T-Unit system run
   */
  public static float getTotalTunitDurations() {
    return totalTunitDurations;
  }

  /**
   * 
   * @return the total errors for the entire T-Unit system run
   */
  public static int getTotalTunitErrors() {
    return totalTunitErrors;
  }

  /**
   * 
   * @return the total failures for the entire T-Unit system run
   */
  public static int getTotalTunitFailures() {
    return totalTunitFailures;
  }

  
  /**
   * 
   * @return the total tests executed during the entire T-Unit system run 
   */
  public static int getTotalTunitTests() {
    return totalTunitTests;
  }


  /**
   * Increment the number of errors we've encountered
   */
  private void incrementErrors() {
    totalErrors++;
    totalTunitErrors++;
  }

  /**
   * Increment the total duration, in milliseconds
   * @param result
   */
  private void incrementDuration(TestResult result) {
    long currentTime = System.currentTimeMillis();
    result.setDuration((float) (currentTime - lastTime) / (float) 1000);
    lastTime = currentTime;
    totalDuration += result.getDuration();
    totalTunitDurations += result.getDuration();
  }

  /**
   * Increment the number of failures we've encountered
   *
   */
  private void incrementFailures() {
    totalFailures++;
    totalTunitFailures++;
  }

  /**
   * Add a problem that we can see later, at the end of a TUnit test run or
   * during the next tunit test run.
   * @param result the TestResult that failed
   */
  @SuppressWarnings("unchecked")
  private void addGlobalProblem(TestResult result) {
    if(!rerunLogged) {
      rerunLogged = true;
      RerunRegistry.logFailure(myPackage);
    }
    allTunitProblems.add(result);
  }
  
  
}
