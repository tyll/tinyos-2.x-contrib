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

import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.tinyos.message.MoteIF;
import net.tinyos.packet.BuildSource;
import net.tinyos.packet.PhoenixError;
import net.tinyos.packet.PhoenixSource;
import net.tinyos.util.Messenger;

import org.apache.log4j.Logger;

import com.rincon.tunit.TUnit;
import com.rincon.tunit.link.TUnitProcessing;
import com.rincon.tunit.link.TUnitProcessing_Events;
import com.rincon.tunit.properties.TUnitSuiteProperties;
import com.rincon.tunit.properties.TUnitTestRunProperties;
import com.rincon.tunit.report.StatisticsReport;
import com.rincon.tunit.report.TestReport;
import com.rincon.tunit.report.TestResult;
import com.rincon.tunit.report.charts.StatisticsChart;
import com.rincon.tunit.stats.Statistics;
import com.rincon.tunit.stats.StatisticsEvents;

/**
 * After the program is running on the mote and we are connected to the motes
 * with serial forwarders, we use the ResultCollector class to contact mote 0,
 * tell it to start, collect all the results from everywhere, and wait for the
 * allDone() signal before returning
 * 
 * @author David Moss
 * 
 */
public class ResultCollector extends Thread implements Messenger,
    TUnitProcessing_Events, PhoenixError, StatisticsEvents {

  /** Logging */
  private static Logger log = Logger.getLogger(ResultCollector.class);

  /** The report to record TestResult's into */
  private TestReport report;

  /** The test run properties for this test */
  private TUnitTestRunProperties runProperties;

  /** The suite properties for this test */
  private TUnitSuiteProperties suiteProperties;

  /** True if this test got an all done signal */
  private boolean allDone;

  /** True if we're waiting for a ping to complete initialization */
  private boolean initializing;

  /** Link with all the motes */
  private TUnitProcessing link;

  /** Link to the statistics collected from the motes */
  private Statistics stats;

  /** Map of parameterized interface ID's to their test names */
  private Map testMap;

  /** Map of parameterized interface ID's to their statistics name */
  private Map statsMap;

  /** Map of assertion ID's to their source code line numbers */
  private Map assertionMap;

  /** The last test result to check in */
  private int lastTestResult;

  /** List of PhoenixSource's */
  private List phoenixSources;

  /** List of Integers representing test ID's that responded with pass/fail */
  private List testIdResponses;

  /**
   * Constructor
   * 
   * @param report
   * @param testRunProperties
   * @param testRunManager
   */
  @SuppressWarnings("unchecked")
  public ResultCollector(TestReport myReport,
      TUnitTestRunProperties myRunProperties,
      TUnitSuiteProperties mySuiteProperties, Map myTestMap, Map myStatsMap,
      Map myAssertionMap) {

    // 1. Initialize all our local variables
    log = Logger.getLogger(getClass());
    log.trace("ResultCollector.constructor()");
    report = myReport;
    runProperties = myRunProperties;
    suiteProperties = mySuiteProperties;
    testMap = myTestMap;
    statsMap = myStatsMap;
    assertionMap = myAssertionMap;
    allDone = false;
    initializing = true;
    lastTestResult = -1;
    phoenixSources = new ArrayList();
    testIdResponses = new ArrayList();

    // 2. Connect to each mote with our TUnitProcessing link
    log.debug("Connecting to MoteIF's");
    MoteIF focusedMoteIf;
    PhoenixSource focusedSource;
    for (int i = 0; i < runProperties.totalNodes(); i++) {
      if(runProperties.getNode(i).getMotecom().isEmpty()) {
        log.debug("Node " + i + "'s motecom is empty; skipping connection.");
        continue;
      }
      
      String source = "sf@localhost:" + (TestRunManager.BASE_PORT + i);
      focusedSource = BuildSource.makePhoenix(source, this);
      focusedSource.setPacketErrorHandler(this);
      phoenixSources.add(focusedSource);
      focusedMoteIf = new MoteIF(focusedSource);
      if (link == null) {
        link = new TUnitProcessing(focusedMoteIf);
      } else {
        link.addMoteIf(focusedMoteIf);
      }

      if (stats == null) {
        stats = new Statistics(focusedMoteIf);
      } else {
        stats.addMoteIf(focusedMoteIf);
      }
    }

    // 3. Sign up as a listener to this link
    link.addListener(this);
    stats.addListener(this);

    // 4. Begin the test, wait for it to complete
    this.start();
    
    synchronized (this) {
      while (!allDone) {
        try {
          wait();
        } catch (InterruptedException e) {
          log.fatal(e.getMessage());
        }
      }
    }

    link.tearDownOneTime();

    // 5. Disconnect our TUnitProcessing link
    log.debug("Shutting down sf socket sources");
    link.shutdown();
    log.debug("Shutting down statistics sources");
    stats.shutdown();

    // 6. Shut down all sources before exiting
    log.debug("Shutting down phoenix sources");
    for (Iterator it = phoenixSources.iterator(); it.hasNext();) {
      ((PhoenixSource) it.next()).shutdown();
    }
    log.debug("All sources shut down, test wrapped up");
  }

  /**
   * Run the test. This is the meat of test result collection. It first attempts
   * to ping mote 0, and waits for a reply. If it doesn't get a reply after 3
   * attempts (1.5 seconds), it fails.
   * 
   * After a reply, it runs the test. Each time it gets a response, it restarts
   * its timeout wait period. It waits in this loop until it gets the allDone()
   * signal.
   */
  public void run() {

    // 1. Ping the node and get a response.
    synchronized (this) {
      log.trace("ResultCollector.run()::initialize");
      
      for (int retries = 0; retries < 20 && initializing; retries++) {
        log.info("Ping...");
        link.ping();

        try {
          wait(500);
        } catch (InterruptedException e) {
          log.fatal(e.getMessage());
          TestResult result = new TestResult(
              "__ResultCollector.run()::initializing");
          result.error("InterruptedException", e.getMessage());
          report.addResult(result);
        }

        if (initializing) {
          // Someone needs to fix the horrendous serial comms problems
          log.info("No pong yet.");
        }
      }
      
      if (initializing) {
        // Still initializing? We failed.
        log.error("Did not get a pong from the node, initialization failed");
        TestResult result = new TestResult(
            "__ResultCollector.run()::initializing");
        result.error("Ping Failed",
            "Did not get a pong from the node, initialization failed");
        report.addResult(result);

        // Get out of our wait state in the constructor
        allDone = true;
        synchronized (this) {
          this.notify();
        }
        return;
      }
    }

    // 2. Run the test
    log.debug("Calling link.runTest()");
    link.runTest();

    CmdFlagExecutor.executeCmdFlag("run", suiteProperties.getRunCmd(), report);
    
    log.trace("ResultCollector.run()::runtest");
    while (!allDone) {
      try {
        synchronized (this) {
          wait(suiteProperties.getTimeout() * 60 * 1000); // minutes to millis
        }

        if (allDone) {
          continue;

        } else {
          log.error("Timeout occured in " + runProperties.getName() + " "
              + suiteProperties.getTestName());
          TestResult result;

          if (testMap.get(new Integer(lastTestResult + 1)) != null) {
            result = new TestResult((String) testMap.get(new Integer(
                lastTestResult + 1)));
          } else {
            result = new TestResult("Test " + lastTestResult + 1
                + "; (couldn't extract test name)");
          }

          result.error("Timeout",
                  "Timeout occured!\nIf this is incorrect, add a \"@timeout [minutes]\" definition to your suite.properties file for this test.");
          report.addResult(result);
          allDone = true;
          synchronized (this) {
            this.notify();
          }
          log.trace("ResultCollector.run()::timeout, exiting");
          return;
        }

      } catch (Exception e) {
        log.fatal(e.getMessage());
        TestResult result = new TestResult("__ResultCollector.run()::running");
        result.error("InterruptedException", e.getMessage());
        report.addResult(result);
      }

    }

    log.trace("ResultCollector.run()::exiting");
  }

  /**
   * A message from one of our serial sources
   */
  public void message(String s) {
    log.debug(s);
  }

  /**
   * An error from one of our serial sources. We don't care too much about
   * errors, because they're usually a result of the serial connection
   * intentionally getting severed elsewhere.
   */
  public void error(IOException e) {
    log.warn("Lost serial connection in the test? " + e.getMessage());
  }

  /**
   * A pong received from the mote after we sent it a ping
   */
  public void tUnitProcessing_pong() {
    log.debug("tUnitProcessing_pong()");
    if (initializing) {
      synchronized (this) {
        initializing = false;
        this.notify();
      }
    }
  }

  /**
   * A test result from an individual test
   */
  @SuppressWarnings("unchecked")
  public void tUnitProcessing_testFailed(short testId, short assertionId,
      String failMsg) {
    failMsg = failMsg.replace('&', ' '); // XML doesn't like &'s.
    failMsg = failMsg.replace('<', '[');
    failMsg = failMsg.replace('>', ']');

    TestResult result;

    if (testMap.get(new Integer(testId)) != null) {
      log.warn("\nTest " + testId + " ("
          + (String) testMap.get(new Integer(testId)) + ") "
          + (String) assertionMap.get(new Integer(assertionId))
          + "\n FAILED\n" + failMsg + "\n");

      result = new TestResult((String) testMap.get(new Integer(testId)),
          (String) assertionMap.get(new Integer(assertionId)));

    } else {
      log.warn("\nTest " + testId + " FAILED \n"
          + (String) assertionMap.get(new Integer(assertionId)) + failMsg
          + "; (couldn't extract test name)");
      result = new TestResult("Test " + testId
          + " (couldn't extract test name)", (String) assertionMap
          .get(new Integer(assertionId)));
    }

    testIdResponses.add(new Integer(testId));
    lastTestResult = testId;
    result.failure("EmbeddedTest", failMsg);
    report.addResult(result);
  }

  @SuppressWarnings("unchecked")
  public void tUnitProcessing_testSuccess(short testId, short assertionId) {
    TestResult result;

    if (testMap.get(new Integer(testId)) != null) {
      log.info("\nTest " + testId + " ("
          + (String) testMap.get(new Integer(testId)) + ") \n"
          + (String) assertionMap.get(new Integer(assertionId)) + " PASSED\n");

      result = new TestResult((String) testMap.get(new Integer(testId)),
          (String) assertionMap.get(new Integer(assertionId)));

    } else {
      log.info("\nTest " + testId + " \n"
          + (String) assertionMap.get(new Integer(assertionId))
          + " PASSED; (couldn't extract test name)");

      result = new TestResult("Test " + testId
          + "; (couldn't extract test name)", (String) assertionMap
          .get(new Integer(assertionId)));
    }

    testIdResponses.add(new Integer(testId));
    lastTestResult = testId;
    report.addResult(result);
  }

  /**
   * A signal notifying the mote is all done running its test
   */
  public void tUnitProcessing_allDone() {
    TestResult result;
    for (int i = 0; i < testMap.size(); i++) {
      boolean found = false;
      for (Iterator it = testIdResponses.iterator(); it.hasNext();) {
        if (((Integer) it.next()).intValue() == i) {
          // Then this test case logged a result, we can go on..
          found = true;
          continue;
        }
      }

      if (!found) {
        // This test case didn't log a result. Maybe it failed? We don't know.
        if (testMap.get(new Integer(i)) != null) {
          result = new TestResult((String) testMap.get(new Integer(i)));
        } else {
          result = new TestResult("Test " + i
              + "; (couldn't extract test name)");
        }

        result
            .failure(
                "NoAssertionError",
                "This test did not report any result.\nExplicitly assert some condition in the test to make it pass or fail correctly.");
        report.addResult(result);
      }
    }

    log.debug("tUnitProcessing_allDone()");
    synchronized (this) {
      allDone = true;
      this.notify();
    }
  }

  /**
   * Signal from the mote to log some statistics
   */
  public void statistics_log(short id, String units, long value) {
    log.trace("statistics_log");
    log.debug("Stats Logging: id=" + id + "; units=" + units + "; value="
        + value);

    try {
      StatisticsChart.write(StatisticsReport.log(report.getPackage(), TUnit.getBasePackageDirectory(),
          (String) statsMap.get(new Integer(id)), units, value), 500, 325);

    } catch (IOException e) {
      TestResult result = new TestResult("__ResultCollector.statistics_log()");
      result.error("IOException", "Could not log statistics for "
          + (String) statsMap.get(new Integer(id)) + ": " + units + " = "
          + value);
      report.addResult(result);

    } catch (ParseException e) {
      TestResult result = new TestResult("__ResultCollector.statistics_chart()");
      result.error("ParseException", "Could parse chart statistics for "
          + (String) statsMap.get(new Integer(id)) + ": " + units + " = "
          + value);
      report.addResult(result);
    }
  }

}