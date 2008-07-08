package com.rincon.tunit.properties;

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
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;


/**
 * Properties extracted from the configuration file of an individual test suite
 * To add another suite property:
 *   > Add the property in here, update the constructor to initialize it,
 *     get/set methods, whatever
 *   > Add the proper logic to the apply() method if it affects test execution
 *   > Add the proper logic to the clone() method to let it propagate
 *     across sub-suites
 *   > Edit the SuitePropertiesParser to parse it from the suite.properties file
 *   > Write JUnit tests for it!
 *   
 * @author David Moss
 *
 */
public class TUnitSuiteProperties {

  /** Logging */
  private static Logger log = Logger.getLogger(TUnitSuiteProperties.class);
  
  /** @author <author> */
  private String author;
  
  /** @testname <testname> */
  private String testName;
  
  /** @description <desc> */
  private String description;
  
  /** @extra <extra> */
  private String extras;
  
  /** CFLAGS+=<> */
  private String cflags;
  
  /** @ignore <target> */
  private List ignore;
  
  /** @only <target> */
  private List only;
  
  /** @minnodes <#> */
  private Integer minNodeCount;
  
  /** @maxnodes <#> */
  private Integer maxNodeCount;
  
  /** @exactnodes <#> */
  private Integer exactNodeCount;
  
  /** @mintargets <#> */
  private Integer minTargetCount;
  
  /** @timeout <#> */
  private Integer timeout;
  
  /** @skip */
  private boolean skip;
  
  /** @cmd start <blah> */
  private String startCmd;
  
  /** @cmd run <blah> */
  private String runCmd;
  
  /** @cmd stop <blah> */
  private String stopCmd;
  
  /** @compile [always|once|never] */
  private Integer compileOption;
  
  /** Default amount of minutes before the current test times out */
  public static final int DEFAULT_TIMEOUT_MINUTES = 1;
  
  /** Default compile option. This differentiates from user defined settings */
  public static final int COMPILE_DEFAULT_ALWAYS = 0;
  
  /** Compile the test always on each test run */
  public static final int COMPILE_ALWAYS = 1;
  
  /** Compile the test once.  Don't compile if a build already exists */
  public static final int COMPILE_ONCE = 2;
  
  /** Never compile the test. Always compile it manually */
  public static final int COMPILE_NEVER = 3;
  
  
  /**
   * Constructor
   *
   */
  public TUnitSuiteProperties() {
    author = "";
    testName = "";
    description = "";
    extras = "";
    cflags = "";
    ignore = new ArrayList();
    only = new ArrayList();
    minNodeCount = null;
    maxNodeCount = null;
    exactNodeCount = null;
    minTargetCount = null;
    timeout = null;
    skip = false;
    startCmd = "";
    runCmd = "";
    stopCmd = "";
    compileOption = COMPILE_DEFAULT_ALWAYS;
    log = Logger.getLogger(getClass());
  }

  public String getAuthor() {
    return author;
  }

  public void addAuthor(String myAuthor) {
    if(author.matches("")) {
      author = myAuthor;
    } else {
      author += ", " + myAuthor;
    }
  }

  public String getDescription() {
    return description;
  }

  public void addDescription(String myDescription) {
    if(description.matches("")) {
      description = myDescription;
    } else {
      description += " " + myDescription;
    }
  }
  
  @SuppressWarnings("unchecked")
  public void addIgnore(String target) {
    ignore.add(target);
  }

  @SuppressWarnings("unchecked")
  public void addOnlyTarget(String target) {
    only.add(target);
  }
  
  public void addExtras(String myExtras) {
    if(extras.matches("")) {
      extras = myExtras;
    } else {
      extras += " " + myExtras;
    }
  }

  public void addCFlags(String myCFlags) {
    // Java and regular expressions don't work in eclipse.
    // I just want to get rid of "CFLAGS+=" and "PFLAGS+=" if they exist.
    if(myCFlags.contains("+=")) {
      myCFlags = myCFlags.substring(myCFlags.indexOf("+=") + 2);
    }
    
    cflags += myCFlags + " ";
  }

  public int getExactNodeCount() {
    if(exactNodeCount != null) {
      return exactNodeCount.intValue();
    } else {
      return -1; 
    }
  }

  public void setExactNodeCount(int exactNodeCount) {
    this.exactNodeCount = new Integer(exactNodeCount);
  }
  
  public int getTimeout() {
    if(timeout != null) {
      return timeout.intValue();
    } else {
      return DEFAULT_TIMEOUT_MINUTES;
    }
  }
  public void setTimeout(int timeoutMin) {
    timeout = new Integer(timeoutMin);
  }

  public String getExtras() {
    return extras;
  }

  public String getCFlags() {
    return cflags;
  }

  public int getMaxNodeCount() {
    if(maxNodeCount != null) {
      return maxNodeCount.intValue();
    } else {
      return -1;
    }
  }

  public void setMaxNodeCount(int maxNodeCount) {
    this.maxNodeCount = new Integer(maxNodeCount);
  }

  public int getMinNodeCount() {
    if(minNodeCount != null) {
      return minNodeCount.intValue();
    } else {
      return -1;
    }
  }

  public void setMinNodeCount(int minNodeCount) {
    this.minNodeCount = new Integer(minNodeCount);
  }

  public String getTestName() {
    return testName;
  }

  public void setTestName(String testName) {
    this.testName = testName;
  }
  

  public int getMinTargetCount() {
    if(minTargetCount != null) {
      return minTargetCount.intValue();
    } else {
      return -1;
    }
  }

  public void setMinTargetCount(int minTargetCount) {
    this.minTargetCount = new Integer(minTargetCount);
  }
  

  public boolean getSkip() {
    return skip;
  }

  public void setSkip(boolean skip) {
    this.skip = skip;
  }

  
  public void setCompileOption(String string) {
    if(string.equalsIgnoreCase("always")) {
      compileOption = COMPILE_ALWAYS;
    } else if(string.equalsIgnoreCase("once")) {
      compileOption = COMPILE_ONCE;
    } else if(string.equalsIgnoreCase("never")) {
      compileOption = COMPILE_NEVER;
    } else {
      log.error("Invalid @compile option: " + string);
    }
  }
  
  public void setCompileOption(int option) {
    if(option > COMPILE_NEVER || option < 0) {
      log.error("Attempting to set an invalid compile option: " + option);
      
    } else {
      compileOption = option;
    }
  }
  
  /**
   * @return an integer of a static id defined in TUnitSuiteProperties that
   *     translates to always, once, and never.
   */
  public int getCompileOption() {
    return compileOption;
  }
  
  public void setStartCmd(String command) {
    startCmd = command;
  }

  public void setRunCmd(String command) {
    runCmd = command;
  }

  public void setStopCommand(String command) {
    stopCmd = command;
  }

  public String getStartCmd() {
    return startCmd;
  }
  
  public String getRunCmd() {
    return runCmd;
  }
  
  public String getStopCmd() {
    return stopCmd;
  }

  
  
  /**
   * 
   * @param testRun the test run to evaluate if this test is applicable for
   * @return true if this test is compatible with the test run
   */
  public boolean shouldRun(TUnitTestRunProperties testRun) {
    // 0. Should we skip this build?
    if(skip) {
      return false;
    }
    
    // 1. Does our test run contain targets that we should ignore?
    for(Iterator it = ignore.iterator(); it.hasNext(); ) {
      
      String target = (String) it.next(); 
      if(testRun.containsTarget(target)) {
        log.debug("This test is invalid for the given test run targets");
        return false;
      }
    }
    
    // 2. Does our test run contain targets outside of our "only" list?
    String focusedTarget;
    boolean targetOk;
    Iterator it;
    
    for(int i = 0; i < testRun.totalTargets(); i++) {
      // If our "only" array is greater than 0, the target might not be ok
      targetOk = (only.size() == 0);
      for(it = only.iterator(); it.hasNext(); ) {
        focusedTarget = (String) it.next();
        if(testRun.getTarget(i).getTargetName().matches(focusedTarget)) {
          targetOk = true;
          break; // into outer for-loop
        }
      }
      
      if(!targetOk) {
        log.debug("This test run contains targets outside of our valid targets list");
        return false;
      }
    }
    
    // 2. Exact node count takes priority over min and max
    if(exactNodeCount != null) {
      if(testRun.totalNodes() != exactNodeCount.intValue()) {
        log.debug("This test run does not have the exact number of nodes required");
        return false;
      }
    }
    
    // 3. Make sure we meet the minimum node criteria 
    if(minNodeCount != null) {
      if(testRun.totalNodes() < minNodeCount.intValue()) {
        log.debug("This test run has too few nodes for this test");
        return false;
      }
    }
    
    // 4. Make sure we meet the maximum node criteria
    if(maxNodeCount != null) {
      if(testRun.totalNodes() > maxNodeCount.intValue()) {
        log.debug("This test run has too many nodes for this test");
        return false;
      }
    }
    
    // 5. Make sure we meet the minimum target criteria
    if(minTargetCount != null) {
      if(testRun.totalTargets() < minTargetCount.intValue()) {
        log.debug("This test run has too few targets for this test");
        return false;
      }
    }
    
    // 6. This test is applicable to the run of tests
    log.debug("This test applies to the given test run");
    return true;
  }

  /**
   * Apply some subset of suite properties to these suite properties and
   * return a new TUnitSuiteProperties with the aggregated results. All
   * properties of the subset should override or add to this suite's properties.
   * 
   * @param subset
   * @return a new TUnitSuiteProperties with the aggregated results
   */
  @SuppressWarnings("unchecked")
  public TUnitSuiteProperties apply(TUnitSuiteProperties subset) {
    TUnitSuiteProperties aggregate = clone();
    
    if(subset == null) {
      return aggregate;
    }
    
    aggregate.addAuthor(subset.getAuthor());
    aggregate.addExtras(subset.getExtras());
    aggregate.addCFlags(subset.getCFlags());
    
    if(!subset.getDescription().matches("")) {
      if(!getDescription().matches("")) {
        aggregate.addDescription("; ");
      }
      aggregate.addDescription(subset.getDescription());
    }
    
    if(!subset.getTestName().matches("")) {
      aggregate.setTestName(subset.getTestName());
    }
    
    if(subset.getMaxNodeCount() != -1) {
      aggregate.setMaxNodeCount(subset.getMaxNodeCount());
    }
    
    if(subset.getMinNodeCount() != -1) {
      aggregate.setMinNodeCount(subset.getMinNodeCount());
    }
    
    if(subset.getExactNodeCount() != -1) {
      aggregate.setExactNodeCount(subset.getExactNodeCount());
    }
    
    if(subset.getMinTargetCount() != -1) {
      aggregate.setMinTargetCount(subset.getMinTargetCount());
    }
    
    // Choose the largest timeout value
    if(subset.getTimeout() > getTimeout()) {
      aggregate.setTimeout(subset.getTimeout());
    }
    
    if(subset.getSkip()) {
      aggregate.setSkip(true);
    }
    
    if(!subset.getStartCmd().matches("")) {
      aggregate.setStartCmd(subset.getStartCmd());
    }
    
    if(!subset.getRunCmd().matches("")) {
      aggregate.setRunCmd(subset.getRunCmd());
    }
    
    if(!subset.getStopCmd().matches("")) {
      aggregate.setStopCommand(subset.getStopCmd());
    }
    
    aggregate.ignore.addAll(subset.ignore);
    
    if(subset.getCompileOption() > COMPILE_DEFAULT_ALWAYS) {
      aggregate.setCompileOption(subset.getCompileOption());
    }
    
    // If the subset defines less @only's than the aggregate, only include
    // the subset's @only's.
    if(subset.only.size() > 0) {
      aggregate.only = subset.only;
    }
    
    
    return aggregate;
  }
  
  /**
   * Make a clone of this TUnitSuiteProperties
   */
  @SuppressWarnings("unchecked")
  public TUnitSuiteProperties clone() {
    TUnitSuiteProperties clone = new TUnitSuiteProperties();
    clone.addAuthor(new String(getAuthor()));
    clone.addDescription(new String(getDescription()));
    clone.addExtras(new String(getExtras()));
    clone.addCFlags(new String(getCFlags()));
    clone.setTestName(new String(getTestName()));
    clone.setSkip(skip);
    
    if(minNodeCount != null) {
      clone.setMinNodeCount(minNodeCount.intValue());
    }
    
    if(maxNodeCount != null) {
      clone.setMaxNodeCount(maxNodeCount.intValue());
    }
    
    if(exactNodeCount != null) {
      clone.setExactNodeCount(exactNodeCount.intValue());
    }
    
    if(minTargetCount != null) {
      clone.setMinTargetCount(minTargetCount.intValue());
    }
    
    if(timeout != null) {
      clone.setTimeout(timeout);
    }
    
    clone.setCompileOption(compileOption);
    clone.setStartCmd(startCmd);
    clone.setRunCmd(runCmd);
    clone.setStopCommand(stopCmd);
    clone.ignore.addAll(ignore);
    clone.only.addAll(only);
    
    return clone;
  }


}
