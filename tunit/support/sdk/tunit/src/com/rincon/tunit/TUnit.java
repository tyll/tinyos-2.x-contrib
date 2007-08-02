package com.rincon.tunit;

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
import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;

import com.rincon.tunit.parsers.tunitproperties.TUnitPropertiesParser;
import com.rincon.tunit.properties.TUnitTestRunProperties;
import com.rincon.tunit.report.StatisticsReport;
import com.rincon.tunit.report.TestReport;
import com.rincon.tunit.report.TestResult;
import com.rincon.tunit.report.charts.StatisticsChart;
import com.rincon.tunit.report.charts.StatisticsLogData;
import com.rincon.tunit.run.RerunRegistry;
import com.rincon.tunit.run.TestRunManager;

/**
 * Main entry point to TUnit TinyOS Embedded testing.
 * 
 * @author David Moss
 * 
 */
public class TUnit {

  /** Logging */
  private static Logger log = Logger.getLogger(TUnit.class);

  /** Base directory of TUnit tests */
  private static String tunitBase;

  /** List of TUnitTestRunProperties to execute */
  private List testRuns;

  /** TUNIT_BASE directory */
  private static File tunitDirectory;

  /** Directory to throw reports into */
  private static File baseReportDirectory;

  /** The directory we're running our tests from */
  private static File rootDirectory;

  /** The start time, in milliseconds */
  private static long startTime;

  /** Registry to keep track of rerun failed test information */
  private RerunRegistry rerunRegistry;

  /**
   * Main method
   * 
   * @param args
   */
  public static void main(String[] args) {
    org.apache.log4j.BasicConfigurator.configure();
    Logger.getRootLogger().setLevel((Level) Level.INFO);
    new TUnit().runTunit(args);
  }

  /**
   * Constructor
   * 
   */
  public TUnit() {
    log = Logger.getLogger(getClass());
    startTime = System.currentTimeMillis();
    rootDirectory = new File(System.getProperty("user.dir"));
    establishTunitDir();
    establishReportDir();
  }

  /**
   * Run TUnit tests
   * 
   * @param args
   */
  public void runTunit(String[] args) {
    
    // 1. Locate the tunit.xml file from the TUNIT_BASE directory
    processTunitXml();

    // 2. Now that everything is established, parse arguments and configure
    // rerun settings
    rerunRegistry = new RerunRegistry(tunitDirectory);
    parseArgs(args);
    rerunRegistry.clean();

    // 3. Initialize and run each test run that can be initialized.
    // We create a test report for each test run initialization
    executeTestRuns();

    // 4. Log results
    logResults();

    // 5. Print all results to the screen.
    printResults();

    // 6. If there was a problem anywhere, exit with error code 6 to tell
    // external programs. We could detect this error code outside and
    // do something useful?
    if (TestReport.getAllTunitProblems().size() > 0) {
      System.exit(6);
    }

    System.exit(0);
  }

  /**
   * 
   * @return the directory at the base of tunit, TUNIT_BASE
   */
  public static File getTunitDirectory() {
    return tunitDirectory;
  }

  /**
   * 
   * @return the root directory we're testing from
   */
  public static File getRootDirectory() {
    return rootDirectory;
  }

  /**
   * 
   * @return the directory to throw testcase reports into
   */
  public static File getXmlReportDirectory() {
    return new File(baseReportDirectory, "/xml");
  }

  /**
   * 
   * @return the directory to throw statistics reports into
   */
  public static File getStatsReportDirectory() {
    return new File(baseReportDirectory, "/stats");
  }

  /**
   * 
   * @return the base reports directory
   */
  public static File getBaseReportDirectory() {
    return baseReportDirectory;
  }


  /**
   * Get a friendly string version of the TUNIT_BASE directory, with the 
   * correct slashies.
   * @return
   */
  public static String getTunitBase() {
    return tunitBase;
  }
  
  
  /**
   * Establish the TUNIT Base directory
   * 
   * @return the tunit directory, so external apps can figure it out.
   */
  private void establishTunitDir() {
    tunitBase = ((String) System.getenv().get("TUNIT_BASE")).replace('\\',
        File.separatorChar).replace('/', File.separatorChar);

    if (tunitBase == null) {
      File buildXml = new File("build.xml");
      if (buildXml.exists()) {
        // We must be in the TUnit base directory
        tunitBase = System.getProperty("user.dir");
        log.info("Defining TUNIT_BASE as " + tunitBase);

      } else {
        log.fatal("TUNIT_BASE environment variable not defined.");
        log.fatal("TUNIT_BASE should define the base directory of all tests.");
        log
            .fatal("Place your build.xml and tunit.xml file in the TUNIT_BASE directory.");
        System.exit(1);
      }

    } else {
      log.debug("Found TUNIT_BASE environment variable: " + tunitBase);
    }

    // 2. Verify it is a valid, existing directory
    tunitDirectory = new File(tunitBase);
    if (!tunitDirectory.exists()) {
      log.fatal(tunitBase + " does not exist.");
      log.fatal("Please set your TUNIT_BASE directory properly");
      System.exit(2);
    }

    if (!tunitDirectory.isDirectory()) {
      log.fatal(tunitBase + " is not a directory.");
      log.fatal("Please set your TUNIT_BASE directory properly");
      System.exit(3);
    }
  }

  /**
   * Parse arguments
   * 
   * @param args
   *          command line arguments
   */
  private void parseArgs(String[] args) {
    for (int i = 0; i < args.length; i++) {
      if (args[i].equalsIgnoreCase("-rerun")) {
        rerunRegistry.enableRerun();
      }
    }
  }

  /**
   * Establish that the directory where test reports will go into exists. Setup
   * our static report directory so other classes can access it externally
   * 
   */
  private void establishReportDir() {
    baseReportDirectory = new File(tunitBase, "/reports");
    new File(baseReportDirectory, "/xml").mkdirs();
  }

  /**
   * Locate and parse the tunit.xml file with all the test run properties
   * 
   */
  private void processTunitXml() {
    File tunitPropertiesFile = new File(tunitDirectory, "tunit.xml");
    if (!tunitPropertiesFile.exists()) {
      log.fatal("Cannot locate " + tunitPropertiesFile.getAbsolutePath());
      log.fatal("Is tunit.xml in your TUNIT_BASE directory?");
      System.exit(4);
    }

    // 5. Process the tunit.xml file
    log.debug("Processing " + tunitPropertiesFile);
    TUnitPropertiesParser tunitParser = new TUnitPropertiesParser(
        tunitPropertiesFile);
    TestResult parseResult = tunitParser.parse();
    if (parseResult.isSuccess()) {
      log.debug("tunit.xml processed successfully");
    } else {
      log.fatal(parseResult.getFailMsg());
      System.exit(5);
    }
    testRuns = tunitParser.getAllTestRuns();
    tunitParser = null;
  }

  /**
   * Execute all test runs.
   * 
   */
  @SuppressWarnings("static-access")
  private void executeTestRuns() {
    if (!rerunRegistry.isRerunEnabled() || rerunRegistry.getTotalReruns() > 0) {
      TUnitTestRunProperties focusedTestRun;
      for (Iterator it = testRuns.iterator(); it.hasNext();) {
        focusedTestRun = (TUnitTestRunProperties) it.next();
        log.info("STARTING TEST RUN " + focusedTestRun.getName().toUpperCase());
        new TestRunManager(focusedTestRun);
        System.gc();
      }
    }
  }

  /**
   * Print the results to the screen
   * 
   */
  private void printResults() {
    System.out.println("\n\nT-Unit Results");
    System.out.println("-----------------------------------------------");
    System.out.println("Total runtime: "
        + ((float) (System.currentTimeMillis() - startTime) / (float) 1000)
        + " [s]");
    System.out.println("Total tests recorded: "
        + TestReport.getTotalTunitTests());
    System.out.println("Total errors: " + TestReport.getTotalTunitErrors());
    System.out.println("Total failures: " + TestReport.getTotalTunitFailures()
        + "\n");

    if (TestReport.getAllTunitProblems() != null) {
      TestResult problemResult;
      for (Iterator it = TestReport.getAllTunitProblems().iterator(); it
          .hasNext();) {
        problemResult = (TestResult) it.next();
        System.out.println(problemResult.getTestName() + " ("
            + problemResult.getProblemType() + "): "
            + problemResult.getFailMsg() + "\n");
      }
    }
    
    System.out.println("\n");
  }

  /**
   * Log the results to a log file, so we have the option of keeping track of
   * our testing status - like how many tests have been run each day, how many
   * failures each day. Makes for some nice graphs to get people motivated.
   * 
   */
  private void logResults() {
    try {
      // Write out all our results for our test reports.
      StatisticsLogData dataSet = StatisticsReport.log("", "TotalProgress",
          "[Total Problems]", TestReport.getTotalTunitErrors()
          + TestReport.getTotalTunitFailures(), "[Total Tests]", TestReport
          .getTotalTunitTests());
      StatisticsChart.write(dataSet, 500, 325);
      
      // Write out our results for just the past 5 days.
      Calendar cal = Calendar.getInstance();
      cal.add(Calendar.DATE, -5);
      Date severalDaysAgo = cal.getTime();
      StatisticsLogData truncatedSet = new StatisticsLogData("RecentProgress", getStatsReportDirectory(), "[# Problems]", "[# Tests]");
      for(int i = 0; i < dataSet.size(); i++) {
        if(dataSet.get(i).getDate().after(severalDaysAgo)) {
          truncatedSet.addEntry(dataSet.get(i));
        }
      }
      StatisticsChart.write(truncatedSet, 500, 325);
      
      // And.. write out results for the past 5 days with a different name
      cal = Calendar.getInstance();
      cal.add(Calendar.DATE, -5);
      severalDaysAgo = cal.getTime();
      truncatedSet = new StatisticsLogData("Progress", getStatsReportDirectory().getParentFile(), "[# Problems]", "[# Tests]");
      for(int i = 0; i < dataSet.size(); i++) {
        if(dataSet.get(i).getDate().after(severalDaysAgo)) {
          truncatedSet.addEntry(dataSet.get(i));
        }
      }
      StatisticsChart.write(truncatedSet, 200, 300);

    } catch (IOException e) {
      log.error(e.getMessage());

    } catch (ParseException e) {
      log.error(e.getMessage());
    }
  }
}
