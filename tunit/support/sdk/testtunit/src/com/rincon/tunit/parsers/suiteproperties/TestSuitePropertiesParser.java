package com.rincon.tunit.parsers.suiteproperties;

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
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertEquals;

import org.junit.Before;
import org.junit.Test;

import com.rincon.tunit.properties.TUnitNodeProperties;
import com.rincon.tunit.properties.TUnitSuiteProperties;
import com.rincon.tunit.properties.TUnitTestRunProperties;
import com.rincon.tunit.report.TestResult;

import junit.framework.JUnit4TestAdapter;

public class TestSuitePropertiesParser {

  private File suite0File;
  
  private File suite1File;
  
  private File suite2File;

  private File suite3File;
  
  private File suiteOnly0File;
  
  private File suiteOnly1File;
  
  private File suiteOnly2File;
  
  public static junit.framework.Test suite() {
    return new JUnit4TestAdapter(TestSuitePropertiesParser.class);
  }
  
  @Before public void setUp() {
    suite0File = new File("suite0.properties");
    suite1File = new File("suite1.properties");
    suite2File = new File("suite2.properties");
    suite3File = new File("suite3.properties");
    suiteOnly0File = new File("suite_only0.properties");
    suiteOnly1File = new File("suite_only1.properties");
    suiteOnly2File = new File("suite_only2.properties");
  }
  

  @Test public void doPropertiesFilesExist() {
    assertTrue("suite0.properties does not exist", suite0File.exists());
    assertTrue("suite1.properties does not exist", suite1File.exists());
    assertTrue("suite2.properties does not exist", suite2File.exists());
    assertTrue("suite3.properties does not exist", suite3File.exists());
    assertTrue("suite_only0.properties does not exist", suiteOnly0File.exists());
    assertTrue("suite_only1.properties does not exist", suiteOnly1File.exists());
    assertTrue("suite_only2.properties does not exist", suiteOnly2File.exists());
     
  }
  
  @Test public void suite0BasicParse() {
    SuitePropertiesParser parser = new SuitePropertiesParser(suite0File);
    TestResult result = parser.parse();
    assertTrue("Suite0: " + result.getFailMsg(), result.isSuccess());
    
    parser = new SuitePropertiesParser(suite1File);
    result = parser.parse();
    assertTrue("Suite1: " + result.getFailMsg(), result.isSuccess());
    
    parser = new SuitePropertiesParser(suite2File);
    result = parser.parse();
    assertTrue("Suite2: " + result.getFailMsg(), result.isSuccess());
  }
  
  @Test public void suite0ParseContents() {
    SuitePropertiesParser parser = new SuitePropertiesParser(suite0File);
    TestResult result = parser.parse();
    assertTrue(result.getFailMsg(), result.isSuccess());
    
    TUnitSuiteProperties suite = parser.getSuiteProperties();
    assertEquals("suite0 getMinNodeCount() failed", 0, suite.getMinNodeCount());
    assertEquals("suite0 getMaxNodeCount() failed", 5, suite.getMaxNodeCount());
    assertEquals("suite0 getExactNodeCount() failed", -1, suite.getExactNodeCount());
    assertEquals("suite0 getMinTargetCount() failed", 1, suite.getMinTargetCount());
    assertEquals("suite0 getAuthor() failed", "David Moss", suite.getAuthor());
    assertEquals("suite0 getFailMsg() failed", "", suite.getDescription());
    assertEquals("suite0 getExtras() failed", "", suite.getExtras());
    assertEquals("suite0 getTestName() failed", "Suite0 Test", suite.getTestName());
    assertFalse("suite0 shouldn't be skipped", suite.getSkip());
  }
  
  @Test public void suite1ParseContents() {
    SuitePropertiesParser parser = new SuitePropertiesParser(suite1File);
    TestResult result = parser.parse();
    assertTrue(result.getFailMsg(), result.isSuccess());
    
    TUnitSuiteProperties suite = parser.getSuiteProperties();
    assertEquals("suite1 getMinNodeCount() failed", 2, suite.getMinNodeCount());
    assertEquals("suite1 getMaxNodeCount() failed", 4, suite.getMaxNodeCount());
    assertEquals("suite1 getExactNodeCount() failed", -1, suite.getExactNodeCount());
    assertEquals("suite1 getMinTargetCount() failed", 2, suite.getMinTargetCount());
    assertEquals("suite1 getAuthor() failed", "Jared Hill", suite.getAuthor());
    assertEquals("suite1 getFailMsg() failed", "This description spans multiple lines ", suite.getDescription());
    assertEquals("suite1 getExtras() failed", "lpl", suite.getExtras());
    assertEquals("suite1 getTestName() failed", "Suite1 Test", suite.getTestName());
    assertTrue("suite1 should be skipped", suite.getSkip());
  }
  
  @Test public void suite2ParseContents() {
    SuitePropertiesParser parser = new SuitePropertiesParser(suite2File);
    TestResult result = parser.parse();
    assertTrue(result.getFailMsg(), result.isSuccess());
    
    TUnitSuiteProperties suite = parser.getSuiteProperties();
    assertEquals("suite2 getMinNodeCount() failed", -1, suite.getMinNodeCount());
    assertEquals("suite2 getMaxNodeCount() failed", -1, suite.getMaxNodeCount());
    assertEquals("suite2 getExactNodeCount() failed", 2, suite.getExactNodeCount());
    assertEquals("suite2 getMinTargetCount() failed", 1, suite.getMinTargetCount());
    assertEquals("suite2 getAuthor() failed", "Mark Hays", suite.getAuthor());
    assertEquals("suite2 getFailMsg() failed", "This is Suite2", suite.getDescription());
    assertEquals("suite2 getExtras() failed", "security ecc", suite.getExtras());
    assertEquals("suite2 getTestName() failed", "Suite2 Test", suite.getTestName());
    assertFalse("suite2 shouldn't be skipped", suite.getSkip());
  }
  
  @Test public void applySuite1ToSuite0() {
    // 1. Parse Suite0
    SuitePropertiesParser parser = new SuitePropertiesParser(suite0File);
    TestResult result = parser.parse();
    assertTrue(result.getFailMsg(), result.isSuccess());
    TUnitSuiteProperties suite0 = parser.getSuiteProperties();
    
    // 2. Parse Suite1
    parser = new SuitePropertiesParser(suite1File);
    result = parser.parse();
    assertTrue(result.getFailMsg(), result.isSuccess());
    TUnitSuiteProperties suite1 = parser.getSuiteProperties();
    
    // 3. Apply Suite1 to Suite0
    TUnitSuiteProperties suite01 = suite0.apply(suite1);
    
    // 4. Verify Results
    assertEquals("suite01 getMinNodeCount() failed", 2, suite01.getMinNodeCount());
    assertEquals("suite01 getMaxNodeCount() failed", 4, suite01.getMaxNodeCount());
    assertEquals("suite01 getExactNodeCount() failed", -1, suite01.getExactNodeCount());
    assertEquals("suite01 getMinTargetCount() failed", 2, suite01.getMinTargetCount());
    assertEquals("suite01 getAuthor() failed", "David Moss, Jared Hill", suite01.getAuthor());
    assertEquals("suite01 getFailMsg() failed", "This description spans multiple lines ", suite01.getDescription());
    assertEquals("suite01 getExtras() failed", "lpl", suite01.getExtras());
    assertEquals("suite01 getTestName() failed", "Suite1 Test", suite01.getTestName());
    assertEquals("suite01 getTimeout() failed", 3, suite01.getTimeout());
    assertTrue("suite01 should be skipped", suite01.getSkip());
  }
  
  
  @Test public void applySuite2ToSuite1ToSuite0() {
    // 1. Parse Suite0
    SuitePropertiesParser parser = new SuitePropertiesParser(suite0File);
    TestResult result = parser.parse();
    assertTrue(result.getFailMsg(), result.isSuccess());
    TUnitSuiteProperties suite0 = parser.getSuiteProperties();
    
    // 2. Parse Suite1
    parser = new SuitePropertiesParser(suite1File);
    result = parser.parse();
    assertTrue(result.getFailMsg(), result.isSuccess());
    TUnitSuiteProperties suite1 = parser.getSuiteProperties();
    
    // 3. Parse Suite2
    parser = new SuitePropertiesParser(suite2File);
    result = parser.parse();
    assertTrue(result.getFailMsg(), result.isSuccess());
    TUnitSuiteProperties suite2 = parser.getSuiteProperties();
    
    // 4. Apply Suite1 to Suite0
    TUnitSuiteProperties suite01 = suite0.apply(suite1);
    
    // 5. Apply Suite2 to Suite01
    TUnitSuiteProperties suite012 = suite01.apply(suite2);
    
    // 4. Verify Results
    assertEquals("suite012 getMinNodeCount() failed", 2, suite012.getMinNodeCount());
    assertEquals("suite012 getMaxNodeCount() failed", 4, suite012.getMaxNodeCount());
    assertEquals("suite012 getExactNodeCount() failed", 2, suite012.getExactNodeCount());
    assertEquals("suite012 getMinTargetCount() failed", 1, suite012.getMinTargetCount());
    assertEquals("suite012 getAuthor() failed", "David Moss, Jared Hill, Mark Hays", suite012.getAuthor());
    assertEquals("suite012 getFailMsg() failed", "This description spans multiple lines  ;  This is Suite2", suite012.getDescription());
    assertEquals("suite012 getExtras() failed", "lpl security ecc", suite012.getExtras());
    assertEquals("suite012 getTestName() failed", "Suite2 Test", suite012.getTestName());
    assertEquals("suite012 getTimeout() failed", 3, suite012.getTimeout());
    assertTrue("suite012 should be skipped", suite012.getSkip());
  }
  
  
  @Test public void suite3Skip() {
    SuitePropertiesParser parser = new SuitePropertiesParser(suite3File);
    TestResult result = parser.parse();
    assertTrue(result.getFailMsg(), result.isSuccess());
    TUnitSuiteProperties suite3 = parser.getSuiteProperties();
    
    assertTrue("suite3 didn't skip", suite3.getSkip());
    
    TUnitTestRunProperties run = new TUnitTestRunProperties();
    assertFalse("Should have skipped this test run", suite3.shouldRun(run));
  }
  
  @Test public void testOnly0() {
	  SuitePropertiesParser parser = new SuitePropertiesParser(suiteOnly0File);
	  TestResult result = parser.parse();
	  assertTrue(result.getFailMsg(), result.isSuccess());
	  TUnitSuiteProperties only0 = parser.getSuiteProperties();
	  
	  TUnitTestRunProperties runMicaz = new TUnitTestRunProperties();
	  TUnitNodeProperties micazNodeProperties = new TUnitNodeProperties();
	  micazNodeProperties.setTarget("micaz");
	  runMicaz.addNodeToTestRun(micazNodeProperties);
	  assertTrue("Should have run micaz", only0.shouldRun(runMicaz));
	  
	  TUnitTestRunProperties runTelosb = new TUnitTestRunProperties();
	  TUnitNodeProperties telosbNodeProperties = new TUnitNodeProperties();
	  telosbNodeProperties.setTarget("telosb");
	  runTelosb.addNodeToTestRun(telosbNodeProperties);
	  assertTrue("Should have run telosb", only0.shouldRun(runTelosb));
	  
	  TUnitTestRunProperties runMica2 = new TUnitTestRunProperties();
	  TUnitNodeProperties mica2NodeProperties = new TUnitNodeProperties();
	  mica2NodeProperties.setTarget("mica2");
	  runMica2.addNodeToTestRun(mica2NodeProperties);
	  assertFalse("Shouldn't have run mica2", only0.shouldRun(runMica2));
  }
  
  @Test public void applyOnly1ToOnly0() {
	  // Parse the suite_only0 file
	  SuitePropertiesParser parser = new SuitePropertiesParser(suiteOnly0File);
	  TestResult result = parser.parse();
	  assertTrue(result.getFailMsg(), result.isSuccess());
	  TUnitSuiteProperties only0 = parser.getSuiteProperties();
	  
	  // Parse the suite_only1 file
	  parser = new SuitePropertiesParser(suiteOnly1File);
	  result = parser.parse();
	  assertTrue(result.getFailMsg(), result.isSuccess());
	  TUnitSuiteProperties only1 = parser.getSuiteProperties();
	  
	  // Apply suite_only1 to suite_only0
	  TUnitSuiteProperties only01 = only0.apply(only1);
	  
	  TUnitTestRunProperties runMicaz = new TUnitTestRunProperties();
	  TUnitNodeProperties micazNodeProperties = new TUnitNodeProperties();
	  micazNodeProperties.setTarget("micaz");
	  runMicaz.addNodeToTestRun(micazNodeProperties);
	  assertFalse("Shouldn't have run micaz", only01.shouldRun(runMicaz));
	  
	  TUnitTestRunProperties runTelosb = new TUnitTestRunProperties();
	  TUnitNodeProperties telosbNodeProperties = new TUnitNodeProperties();
	  telosbNodeProperties.setTarget("telosb");
	  runTelosb.addNodeToTestRun(telosbNodeProperties);
	  assertTrue("Should have run telosb", only01.shouldRun(runTelosb));
	  
	  TUnitTestRunProperties runMica2 = new TUnitTestRunProperties();
	  TUnitNodeProperties mica2NodeProperties = new TUnitNodeProperties();
	  mica2NodeProperties.setTarget("mica2");
	  runMica2.addNodeToTestRun(mica2NodeProperties);
	  assertFalse("Shouldn't have run mica2", only01.shouldRun(runMica2));
  }
  

  @Test public void applyOnly2ToOnly0() {
	  // Parse the suite_only0 file
	  SuitePropertiesParser parser = new SuitePropertiesParser(suiteOnly0File);
	  TestResult result = parser.parse();
	  assertTrue(result.getFailMsg(), result.isSuccess());
	  TUnitSuiteProperties only0 = parser.getSuiteProperties();
	  
	  // Parse the suite_only2 file
	  parser = new SuitePropertiesParser(suiteOnly2File);
	  result = parser.parse();
	  assertTrue(result.getFailMsg(), result.isSuccess());
	  TUnitSuiteProperties only2 = parser.getSuiteProperties();
	  
	  // Apply suite_only2 to suite_only0
	  TUnitSuiteProperties only01 = only0.apply(only2);
	  
	  TUnitTestRunProperties runMicaz = new TUnitTestRunProperties();
	  TUnitNodeProperties micazNodeProperties = new TUnitNodeProperties();
	  micazNodeProperties.setTarget("micaz");
	  runMicaz.addNodeToTestRun(micazNodeProperties);
	  assertTrue("Should have run micaz", only01.shouldRun(runMicaz));
	  
	  TUnitTestRunProperties runTelosb = new TUnitTestRunProperties();
	  TUnitNodeProperties telosbNodeProperties = new TUnitNodeProperties();
	  telosbNodeProperties.setTarget("telosb");
	  runTelosb.addNodeToTestRun(telosbNodeProperties);
	  assertTrue("Should have run telosb", only01.shouldRun(runTelosb));
	  
	  TUnitTestRunProperties runMica2 = new TUnitTestRunProperties();
	  TUnitNodeProperties mica2NodeProperties = new TUnitNodeProperties();
	  mica2NodeProperties.setTarget("mica2");
	  runMica2.addNodeToTestRun(mica2NodeProperties);
	  assertFalse("Shouldn't have run mica2", only01.shouldRun(runMica2));
  }
  
  
}
