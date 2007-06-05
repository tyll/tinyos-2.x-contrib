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

/**
 * This class stores information about a complete run of T-Unit tests and
 * which motes they should be installed to.
 * 
 * A test run is composed of one or more motes, and can be heterogeneous.
 * For example, we may want to run a test using a single tmote, or two micaz's,
 * or one mote being a tmote and the other a micaz.  The tunit.xml
 * file contains information on all the motes used in a particular test run.
 * Individual test config information files can be used to determine if the 
 * run is applicable for the particular test.  
 * 
 * For example, if this test run was to be built on a tmote platform,
 * then any individual test that says "@ignore tmote" will be ignored by
 * this test.  Each individual test must be compiled and installed for each 
 * target in the test run.
 * 
 * @author David Moss
 *
 */
public class TUnitTestRunProperties {

  /** List of TUnitTargetProperties of unique targets */
  private List targetProperties;
  
  /** List of TUnitNodeProperties */
  private List nodeProperties;
  
  /** Name of this test run to identify it in the html reports */
  private String testRunName;
  
  /** testrun[id]; this is id, so we can make unique default test names */
  private static int defaultTestRunId = 0;
  
  /**
   * Constructor
   *
   */
  public TUnitTestRunProperties(String name) {
    testRunName = name.replace(" ", "_");
    targetProperties = new ArrayList();
    nodeProperties = new ArrayList();
  }
  
  /**
   * Constructor
   *
   */
  public TUnitTestRunProperties() {
    testRunName = "testrun" + defaultTestRunId;
    defaultTestRunId++;
    targetProperties = new ArrayList();
    nodeProperties = new ArrayList();
  }
  
  
  /**
   * Add a node to the test run.  If its target hasn't been seen before,
   * create a new target and add it to the test run.  Otherwise, add the
   * node to an existing target.
   * @param node
   */
  @SuppressWarnings("unchecked")
  public void addNodeToTestRun(TUnitNodeProperties node) {
    boolean newTarget = true;
    TUnitTargetProperties target = null;
    for(Iterator it = targetProperties.iterator(); it.hasNext(); ) {
      target = (TUnitTargetProperties) it.next();
      if(target.getTargetName().matches(node.getTarget())) {
        target.addNode(node);
        newTarget = false;
        break;
      }
    }
    
    if(newTarget) {
      target = new TUnitTargetProperties(node.getTarget());
      target.addNode(node);
      targetProperties.add(target);
    }
    
    node.setId(nodeProperties.size());
    nodeProperties.add(node);
  }
  
  /**
   * 
   * @return the total number of targets we're compiling for in this test run
   */
  public int totalTargets() {
    return targetProperties.size();
  }
  
  /**
   * Get the name of an individual target to compile for in this test run
   * @param i
   * @return the name of the unique target
   */
  public TUnitTargetProperties getTarget(int i) {
    return (TUnitTargetProperties) targetProperties.get(i);
  }
  
  /**
   * Get the name of this test run
   * @return
   */
  public String getName() {
    return testRunName;
  }
  
  /**
   * 
   * @return the total number of nodes involved with this test
   */
  public int totalNodes() {
    return nodeProperties.size();
  }
  
  /**
   * 
   * @param i 
   * @return info about an individual node used in this test run
   */
  public TUnitNodeProperties getNode(int i) {
    return (TUnitNodeProperties) nodeProperties.get(i);
  }
  
  /**
   * 
   * @param target
   * @return true if the given target is part of this test run
   */
  public boolean containsTarget(String target) {
    for(Iterator it = targetProperties.iterator(); it.hasNext(); ) {
      if(((TUnitTargetProperties) it.next()).getTargetName().matches(target)) {
        return true;
      }
    }
    return false;
  }
}
