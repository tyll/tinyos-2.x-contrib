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
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;

import net.tinyos.packet.PhoenixError;
import net.tinyos.util.Messenger;

import com.rincon.tunit.TUnit;
import com.rincon.tunit.properties.TUnitSuiteProperties;
import com.rincon.tunit.properties.TUnitTestRunProperties;
import com.rincon.tunit.report.TestReport;
import com.rincon.tunit.report.TestResult;
import com.rincon.tunit.report.WriteXmlReport;
import com.rincon.tunit.sf.SerialForwarder;
import com.rincon.tunit.sf.Sf;

/**
 * This class is responsible for initializing all serial forwarder connnections,
 * and then executing the traverser while maintaining test run properties to
 * apply to each individual test.
 * 
 * @author David Moss
 * 
 */
public class TestRunManager implements PhoenixError, Messenger {

  /** The base socket port for external applications to connect with */
  public static final int BASE_PORT = 9100;

  /** Logging */
  private static Logger log = Logger.getLogger(TestRunManager.class);

  /** Report directory to throw .xml report files into */
  private File reportDirectory;

  /** Test run properties */
  private TUnitTestRunProperties runProperties;

  /** Serial forwarders */
  private List serialForwarders;

  /** Local test report in case something goes wrong with the actual test run */
  private TestReport report;

  /** Number of motes our serial forwarders are synchronizing */
  private short syncing;

  /** True if there was an error connecting with a serial forwarder */
  private boolean sfError;

  /**
   * Constructor Start all serial forwarders and verify connections before
   * continuing
   * 
   * @param myBaseDirectory
   * @param myTestRun
   */
  @SuppressWarnings("unchecked")
  public TestRunManager(TUnitTestRunProperties myTestRun) {
    log = Logger.getLogger(getClass());

    reportDirectory = TUnit.getXmlReportDirectory();
    runProperties = myTestRun;
    serialForwarders = new ArrayList();

    syncing = 0;
    sfError = false;
    
    for (int i = 0; i < runProperties.totalNodes(); i++) {
      // If the motecom isn't defined for this node and the node isn't the
      // drive node #0, then it might be intentional that we don't connect
      // to the node with the serial forwarder.  Driving nodes (node 0) must
      // always have a serial forwarder connection, or else there's no way
      // to collect test results.
      if(runProperties.getNode(i).getMotecom().isEmpty() && i > 0) {
        log.debug("Skipping the serial connection to node " + i + " (target " 
            + runProperties.getNode(i).getTarget() + ") because its motecom isn't defined");
        
      } else {
        log.debug("Creating serial forwarder " + runProperties.getNode(i).getMotecom());
        serialForwarders.add(new Sf(runProperties.getNode(i).getMotecom(),
            BASE_PORT + i, this, this));
      }
    }

    /*
     * Verify all serial forwarders are connected at this time
     */
    for(Iterator it = serialForwarders.iterator(); it.hasNext(); ) {
      if(!((SerialForwarder) it.next()).isConnected()) {
        sfError = true;
      }
    }
    
    disconnectAll();

    if (sfError) {
      log.debug("Serial forwarder error on boot, cleaning up...");
      cleanUp();
      return;

    } else {
      log.debug("Serial forwarders initialized successfully");
      execute();
    }
  }

  /**
   * Run all tests
   * 
   */
  private void execute() {
    log.trace("TestRunManager.execute(): " + runProperties.getName());

    if (sfError) {
      return;
    }

    new Traverser(TUnit.getRootDirectory(), null, runProperties, this);
  }

  /**
   * Error handler for serial forwarders via PhoenixError interface
   */
  public void error(IOException e) {
    String msg = e.getMessage();
    log.error("Serial Forwarder error: " + msg);
    if (msg.contains("Could not") || msg.contains("Invalid source")) {
      log.error("Test run " + runProperties.getName() + " cannot continue");
      log.error("Ensure the motes plugged in match tunit.xml definitions");
      reportError(msg);      
      cleanUp();
      
      synchronized (this) {
        sfError = true;
        this.notify();
      }
    }
  }

  /**
   * Record a test run error to our XML reports
   * 
   * @param message
   */
  public void reportError(String message) {
    log.trace("TestRunManager.reportError()");
    if (report == null) {
      report = new TestReport(runProperties, new TUnitSuiteProperties(),
          runProperties.getName() + ".__TestRunManager");
    }

    TestResult result = new TestResult("__ExecuteTestRun");
    result.error("__TestRunManagerError", message);
    report.addResult(result);
  }

  /**
   * Clean up and destroy all available serial forwarders
   * 
   */
  private void cleanUp() {
    log.trace("TestRunManager.cleanUp()");
    log.debug("TestRunManager.cleanUp(): Disconnecting all serial forwarders");
    disconnectAll();

    if (report != null) {
      WriteXmlReport xmlWrite = new WriteXmlReport(report, reportDirectory);
      try {
        xmlWrite.write();
      } catch (IOException e) {
        log.error(e);
      }
    }
  }

  /**
   * Disconnect all serial forwarder connections
   * 
   */
  protected void disconnectAll() {
    log.debug("Disconnecting all serial forwarders");
    for (Iterator it = serialForwarders.iterator(); it.hasNext();) {
      ((Sf) it.next()).disconnect();
    }
  }
  
  /**
   * Connect all serial forwarder connections
   * 
   */
  protected boolean connectAll() {
    log.debug("Connecting all serial forwarders");
    syncing = 0;
    sfError = false;

    for (Iterator it = serialForwarders.iterator(); it.hasNext();) {
      log.debug("Connecting...");
      ((Sf) it.next()).connect();
    }    

    /*
     * Verify all serial forwarders are connected at this time
     */
    for(Iterator it = serialForwarders.iterator(); it.hasNext(); ) {
      if(!((Sf) it.next()).isConnected()) {
        log.debug("Not all serial forwarders connected properly.");
        sfError = true;
        return false;
      }
    }
    
    log.debug("All serial forwarders connected properly.");
    return true;
  }
  
  /**
   * SF Messenger handler via Messenger interface
   */
  public void message(String s) {
    log.debug(s);
    if (s.contains("resynchronising")) {
      synchronized (this) {
        syncing++;
        this.notify();
      }
    }
  }
}
