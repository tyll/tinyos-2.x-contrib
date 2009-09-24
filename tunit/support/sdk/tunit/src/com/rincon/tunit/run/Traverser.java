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

import java.io.File;
import java.io.FilenameFilter;

import org.apache.log4j.Logger;

import com.rincon.tunit.parsers.makefileparser.MakefileParser;
import com.rincon.tunit.parsers.suiteproperties.SuitePropertiesParser;
import com.rincon.tunit.properties.TUnitSuiteProperties;
import com.rincon.tunit.properties.TUnitTestRunProperties;
import com.rincon.tunit.report.TestResult;

/**
 * Recursively traverse through directories, compiling and installing suites 
 * while gathering suite configurations along the way.
 * 
 * @author David Moss
 * 
 */
public class Traverser {

  /** Logging */
  private static Logger log = Logger.getLogger(Traverser.class);

  /** Base directory I'm responsible for */
  private File baseDirectory;

  /** Properties of this and all previous suites configurations above */
  private TUnitSuiteProperties suiteProperties;

  /** Properties of the current test run */
  private TUnitTestRunProperties runProperties;
  
  /** The Manager for this test run, controlling all sf connections */
  private TestRunManager testManager;
  
  /**
   * Constructor, which also begins traversing the given directory
   * 
   * @param myDirectory
   * @param aggregatedSuiteProperties
   */
  public Traverser(File myDirectory, 
      TUnitSuiteProperties aggregatedSuiteProperties, 
      TUnitTestRunProperties testRunProperties,
      TestRunManager myManager) {
    
    log = Logger.getLogger(getClass());
    baseDirectory = myDirectory;
    runProperties = testRunProperties;
    suiteProperties = aggregatedSuiteProperties;
    testManager = myManager;
    
    traverse();
  }

  /**
   * Traverse the directory we're in charge of:
   * 1. Locate and apply any suite.properties files found here
   * 2. Determine if the current test run is applicable
   * 3. Locate any valid Makefiles, determine if they represent a test
   * 4. Pass all test information to the test processor
   * 5. After the test is complete, continue traversing.
   * 6. When we're out of sub-directories to traverse, exit back up to the
   *    higher level. 
   *
   */
  private void traverse() {
    log.debug("Traverser.traverse(" + baseDirectory.getAbsolutePath() + ")");
    
    /*
     * 1. Locate and parse any suite.properties files for this test suite
     */
    File[] matchingFiles = baseDirectory.listFiles(new FilenameFilter() {
      public boolean accept(File dir, String name) {
        return name.matches("suite.properties");
      }
    });
    
    if(matchingFiles.length == 1) {
      //log.debug("Found a suite.properties file");
      SuitePropertiesParser parser = new SuitePropertiesParser(matchingFiles[0]);
      TestResult parseResult = parser.parse();
      if(!parseResult.isSuccess()) {
        testManager.reportError("Traverser could not parse " + matchingFiles[0].getAbsolutePath());
      }
      
      if(suiteProperties != null) {
        suiteProperties = suiteProperties.apply(parser.getSuiteProperties());
      } else {
        suiteProperties = parser.getSuiteProperties();
      }
    }

    /*
     * 2. Determine if our test suite is applicable to this test run. If not,
     * exit back out of this directory completely.
     */
    if(suiteProperties != null) {
      if(!suiteProperties.shouldRun(runProperties)) {
        return;
      }
      
    } else {
      suiteProperties = new TUnitSuiteProperties();
    }
    
    /*
     * 3. Locate any Makefiles.  Are they valid?  If so, compile and run the
     * project 
     */
    matchingFiles = baseDirectory.listFiles(new FilenameFilter() {
      public boolean accept(File dir, String name) {
        return name.matches("Makefile");
      }
    });
    
    if(matchingFiles.length == 1) {
      MakefileParser makefile = new MakefileParser(matchingFiles[0]);
      if(makefile.canCompile()) {
        log.debug("Found a compilable project");
        new TestRunner(baseDirectory, 
            suiteProperties,
            runProperties,
            testManager);
      }
    }
    
    /*
     * 4. After running this test, continue traversing sub-directories, then
     * complete
     */
    File[] matchingDirs = baseDirectory.listFiles(new FilenameFilter() {
      public boolean accept(File dir, String name) {
        return new File(dir, name).isDirectory();
      }
    });
    
    for(int i = 0; i < matchingDirs.length; i++) {
      new Traverser(matchingDirs[i], suiteProperties, runProperties, testManager);
    }
  }
}
