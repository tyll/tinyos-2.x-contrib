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


import java.io.File;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertEquals;

import org.junit.Before;
import org.junit.Test;

import com.rincon.tunit.report.TestResult;

import junit.framework.JUnit4TestAdapter;

/** 
 * 
 * @author David Moss
 *
 */
public class TestAppCParser {
  
  /** My App.c file */
  private File myAppFile;
  
  public static junit.framework.Test suite() {
    return new JUnit4TestAdapter(TestAppCParser.class);
  }
  
  @Before public void setUp() {
    myAppFile = new File("app.c");
  }
  
  @Test public void appCExists() {
    assertTrue("app.c file doesn't exist", myAppFile.exists());
  }
  
  @Test public void basicParse() {
    AppCParser parser = new AppCParser(new File("app.c"));
    
    TestResult result = parser.parse();
    assertTrue(result.getFailMsg(), result.isSuccess());    
  }
  
  @Test public void testParseResults() {
    AppCParser parser = new AppCParser(new File("app.c"));
    
    TestResult result = parser.parse();
    assertTrue(result.getFailMsg(), result.isSuccess());
    
    assertEquals("Wrong number of tests extracted", 3, parser.getTestCaseMap().size());
    assertEquals("Wrong test name: " + parser.getTestCaseMap().get(new Integer(0)), parser.getTestCaseMap().get(new Integer(0)), "TestStateC.TestForceC");
    assertEquals("Wrong test name: " + parser.getTestCaseMap().get(new Integer(1)), parser.getTestCaseMap().get(new Integer(1)), "TestStateC.TestToIdleC");
    assertEquals("Wrong test name: " + parser.getTestCaseMap().get(new Integer(2)), parser.getTestCaseMap().get(new Integer(2)), "TestStateC.TestRequestC");
  }
  
  
}
