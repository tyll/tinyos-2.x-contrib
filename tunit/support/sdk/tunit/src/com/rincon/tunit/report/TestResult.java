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

/**
 * Results of an individual test within a test suite
 * @author David Moss
 *
 */
public class TestResult {

  /** Name of this individual test */
  private String testName;
  
  /** Duration of this test */
  private float duration = 0;
  
  /** Fail message of this result, if any */
  private String failMsg;
  
  /** Type of failure or error. I can't get this to work with junitreport */
  private String problemType;
  
  /** True if this test resulted in a failure */
  private boolean isFailure;
  
  /** True if this test resulted in an error */
  private boolean isError;
  
  /** Assertion identification to translate to an embedded code line number */
  private String lineNumber;
  
  /**
   * Constructor
   * @param myTestName
   * @param myDuration
   */
  public TestResult(String myTestName) {
    testName = myTestName;
    problemType = "";
    failMsg = "";
    lineNumber = "";
  }
  
  public TestResult(String myTestName, String filenameAndLineNumber) {
    testName = myTestName;
    problemType = "";
    failMsg = "";
    lineNumber = filenameAndLineNumber;
  }
  
  /**
   * This test was an error
   * @param type
   * @param message
   */
  public void error(String type, String message) {
    isFailure = false;
    isError = true;
    problemType = type;
    failMsg = message;
  }
  
  /**
   * This test was a failure
   * @param type
   * @param message
   */
  public void failure(String type, String message) {
    isFailure = true;
    isError = false;
    problemType = type;
    failMsg = message;
  }

  /**
   * The TestReport actually keeps track of the duration of the test.
   * Once a TestReport object is created, it is assumed that the parts of the
   * test are running. Each time a TestResult is added to the TestReport,
   * the TestReport fills in details about how long that portion of the test
   * took to execute.
   * @param myDuration
   */
  public void setDuration(float myDuration) {
    duration = myDuration;
  }
  
  /**
   * 
   * @return the duration of the test, if it was set externally.  Default is 0.
   */
  public float getDuration() {
    return duration;
  }

  public String getFailMsg() {
    return failMsg;
  }

  public boolean isError() {
    return isError;
  }

  public boolean isFailure() {
    return isFailure;
  }

  public String getProblemType() {
    return problemType;
  }

  public String getTestName() {
    return testName;
  }

  public boolean isSuccess() {
    return !isError && !isFailure;
  }
  
  public String getSourceCodeLineNumber() {
    return lineNumber;
  }
  
}
