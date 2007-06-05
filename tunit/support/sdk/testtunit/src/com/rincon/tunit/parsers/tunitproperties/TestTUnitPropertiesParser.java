package com.rincon.tunit.parsers.tunitproperties;

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

import com.rincon.tunit.parsers.tunitproperties.TUnitPropertiesParser;
import com.rincon.tunit.properties.TUnitNodeProperties;
import com.rincon.tunit.properties.TUnitTestRunProperties;
import com.rincon.tunit.report.TestResult;

import junit.framework.JUnit4TestAdapter;

public class TestTUnitPropertiesParser {


  /** My tunit.xml file to parse */
  private File tunitFile;
  
  public static junit.framework.Test suite() {
    return new JUnit4TestAdapter(TestTUnitPropertiesParser.class);
  }
  

  @Before public void setUp() {
    tunitFile = new File("tunit.xml");
  }
  
  @Test public void doesTunitPropertiesFileExist() {
    assertTrue("tunit.xml file does not exist to be tested", tunitFile.exists());
  }
  
  @Test public void testBasicParse() {
    TUnitPropertiesParser parser = new TUnitPropertiesParser(tunitFile);
    TestResult result = parser.parse();
    
    assertTrue("Couldn't parse tunit.xml: " + result.getFailMsg(), result.isSuccess());
  }
  

  @Test public void testParseContents() {
    TUnitPropertiesParser parser = new TUnitPropertiesParser(tunitFile);
    TestResult result = parser.parse();
    
    assertTrue("Couldn't parse tunit.xml: " + result.getFailMsg(), result.isSuccess());
    
    assertEquals("getTotalRuns() incorrect" + parser.getTotalRuns(), 3, parser.getTotalRuns());
  }
  
  @Test public void testRunNames() {
    TUnitPropertiesParser parser = new TUnitPropertiesParser(tunitFile);
    TestResult result = parser.parse();
    
    assertTrue("Couldn't parse tunit.xml: " + result.getFailMsg(), result.isSuccess());
    
    assertEquals("getTotalRuns() incorrect" + parser.getTotalRuns(), 3, parser.getTotalRuns());
    
    TUnitTestRunProperties testRun;
    
    testRun = parser.getTestRun(0);
    assertEquals("Wrong test name for testrun 0", "3_telosb", testRun.getName());
    
    testRun = parser.getTestRun(1);
    assertEquals("Wrong test name for testrun 1", "2_micaz", testRun.getName());
    
    testRun = parser.getTestRun(2);
    assertEquals("Wrong test name for testrun 2", "telosb_and_micaz", testRun.getName());
  }
  

  @Test public void testRunNodesAndTargets() {
    TUnitPropertiesParser parser = new TUnitPropertiesParser(tunitFile);
    TestResult result = parser.parse();
    
    assertTrue("Couldn't parse tunit.xml: " + result.getFailMsg(), result.isSuccess());
    
    assertEquals("getTotalRuns() incorrect" + parser.getTotalRuns(), 3, parser.getTotalRuns());
    
    TUnitTestRunProperties testRun;
    testRun = parser.getTestRun(0);
    assertEquals("Wrong number of nodes for testrun 0", 3, testRun.totalNodes());
    assertEquals("Wrong number of targets for testrun 0", 1, testRun.totalTargets());
    
    testRun = parser.getTestRun(1);
    assertEquals("Wrong number of nodes for testrun 1", 2, testRun.totalNodes());
    assertEquals("Wrong number of targets for testrun 1", 1, testRun.totalTargets());
    
    testRun = parser.getTestRun(2);
    assertEquals("Wrong number of nodes for testrun 2", 2, testRun.totalNodes());
    assertEquals("Wrong number of targets for testrun 2", 2, testRun.totalTargets());
  }
  
  @Test public void testNodeProperties() {
    TUnitPropertiesParser parser = new TUnitPropertiesParser(tunitFile);
    TestResult result = parser.parse();
    
    assertTrue("Couldn't parse tunit.xml: " + result.getFailMsg(), result.isSuccess());
    
    assertEquals("Expected 3 total testruns, got " + parser.getTotalRuns(), 3, parser.getTotalRuns());
    
    TUnitTestRunProperties testRun;
    testRun = parser.getTestRun(0);
    TUnitNodeProperties node = testRun.getNode(0);
    assertEquals("Wrong target for node 0", "telosb", node.getTarget());
    assertEquals("Wrong motecom for node 0", "serial@COM15:tmote", node.getMotecom());
    assertEquals("Wrong extras for node 0", "bsl,14", node.getInstallExtras());
  }
}
