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
import java.text.ParseException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.rincon.tunit.TUnit;
import com.rincon.tunit.build.BuildInterface;
import com.rincon.tunit.build.Make;
import com.rincon.tunit.parsers.appc.AppCParser;
import com.rincon.tunit.properties.TUnitNodeProperties;
import com.rincon.tunit.properties.TUnitSuiteProperties;
import com.rincon.tunit.properties.TUnitTargetProperties;
import com.rincon.tunit.properties.TUnitTestRunProperties;
import com.rincon.tunit.report.StatisticsReport;
import com.rincon.tunit.report.TestReport;
import com.rincon.tunit.report.TestResult;
import com.rincon.tunit.report.WriteXmlReport;
import com.rincon.tunit.report.charts.StatisticsChart;

/**
 * Run the test in the current directory. This portion of it simply cleans and
 * installs the build, connects the serial forwarders, then lets the
 * ResultCollector take over. After the ResultsCollector finishes, the serial
 * forwarders are disconnected and the report is written.
 * 
 * WARN: The architecture of the build system may need to be redone a bit to
 * support test beds and other methods of compiling/installing.
 * 
 * @author David Moss
 * 
 */
public class TestRunner {

  /** Logging */
  private static Logger log = Logger.getLogger(TestRunner.class);

  /** The directory to build, install, and run */
  private File buildDirectory;

  /** Manager for this test */
  private TestRunManager testManager;

  /** Properties of the test run we're running */
  private TUnitTestRunProperties runProperties;

  /** Properties of the suite we're in */
  private TUnitSuiteProperties suiteProperties;

  /** TestReport to log results into */
  private TestReport report;

  /** Build System system */
  private BuildInterface make;

  /** App.c parser results */
  private Map testMap;

  /** App.c statistics parse results */
  private Map statsMap;

  /** Package we're currently working in */
  private String packageId;

  /**
   * Constructor. Initialize and execute the test. Upon return, the test should
   * be complete and the XML report should be written.
   * 
   */
  public TestRunner(File myBuildDirectory,
      TUnitSuiteProperties aggregatedSuiteProperties,
      TUnitTestRunProperties testRunProperties, TestRunManager myManager) {

    log = Logger.getLogger(getClass());
    log.trace("TestRunner.constructor()");
    buildDirectory = myBuildDirectory;
    testManager = myManager;
    runProperties = testRunProperties;
    suiteProperties = aggregatedSuiteProperties;

    /*
     * The packageId is the absolute unique name for this test. It is generated
     * here because it really doesn't belong with the traverser functionality,
     * it belongs in the actual test run functionality. If we're running only
     * tests that failed, we can match up this packageId to find out if this
     * test is still applicable. If not, we abort it here, before we run the
     * test or write an XML file for it.
     * 
     * The package id is name of the test run followed by the name of the test
     * directory, relative to the tunit base directory. Being a package, all /'s
     * are replaced with .'s.
     */
    packageId = testRunProperties.getName()
        + "."
        + myBuildDirectory.getAbsolutePath().substring(
            TUnit.getTunitDirectory().getAbsolutePath().length()).replace(
            File.separatorChar, '.').replaceFirst(".", "");

    log.info("PACKAGE " + packageId);

    if (!RerunRegistry.shouldRun(packageId)) {
      log.debug("RerunRegistry: " + packageId + " doesn't need to rerun");
      return;
    }

    report = new TestReport(testRunProperties, aggregatedSuiteProperties,
        packageId);

    make = new Make();

    runTest();
    writeReport();
  }

  /**
   * Run the test, wait until everything's finished
   * 
   */
  public void runTest() {
    log.trace("TestRunner.runTest()");

    // 1. Clean the existing compiled projects
    if (!clean()) {
      return;
    }

    // 2. Build and install the project on all test run nodes
    if (!install()) {
      return;
    }

    // 3. Connect serial forwarders, run the test, disconnect sf's.
    log.debug("Connecting serial forwarders");
    if (!testManager.connectAll()) {
      TestResult result = new TestResult("__ConnectSerialForwarders");
      result.error("SFError", "Could not connect all serial forwarders!");
      report.addResult(result);
      return;
    }

    log.debug("Running test");
    new ResultCollector(report, runProperties, suiteProperties, testMap,
        statsMap);
    log.debug("Disconnecting serial forwarders");
    testManager.disconnectAll();
  }

  /**
   * Write the XML report to the report directory We also keep a log of how well
   * these tests are doing over time in the stats
   */
  private void writeReport() {
    WriteXmlReport xmlWrite = new WriteXmlReport(report, TUnit
        .getXmlReportDirectory());
    try {
      xmlWrite.write();
      StatisticsChart.write(StatisticsReport.log(packageId,
          "TestingProgress", "[Total Problems]", report.getTotalErrors()
              + report.getTotalFailures(), "[Total Tests]", report
              .getTotalTests()), 500, 325);
    } catch (IOException e) {
      log.error("Error writing XML report: \n" + e.getMessage());
    } catch (ParseException e) {
      log.error(e.getMessage());
    }

  }

  /**
   * Clean the build directory
   * 
   * @return true if the clean was successful
   */
  private boolean clean() {
    log.trace("TestRunner.clean()");
    log.debug("Clean");
    TestResult focusedResult = make.clean(buildDirectory);
    if (!focusedResult.isSuccess()) {
      report.addResult(focusedResult);
    }
    return focusedResult.isSuccess();
  }

  /**
   * Build and install all targets. We evaluate all the build extras for each
   * target to determine if that target only has to be created once. If not, we
   * have to build and install the project for each individual node. Otherwise,
   * we can build each target once and reinstall it a bunch of times on each
   * node.
   * 
   * This may need a little re-architecture based on how test beds operate
   * 
   * @return true if the build and install was successful
   */
  private boolean install() {
    log.trace("TestRunner.install()");
    TestResult focusedResult;

    TUnitTargetProperties focusedTarget = null;
    TUnitNodeProperties focusedNode;
    String extras;
    for (int i = 0; i < runProperties.totalTargets(); i++) {
      focusedTarget = runProperties.getTarget(i);
      if (runProperties.getTarget(i).requiresMultipleBuilds()) {
        log.debug("Build properties differ for nodes using target "
            + focusedTarget.getTargetName());
        for (int nodeIndex = 0; nodeIndex < focusedTarget.totalNodes(); nodeIndex++) {
          focusedNode = focusedTarget.getNode(nodeIndex);
          extras = "install." + focusedNode.getId() + " ";
          extras += focusedNode.getInstallExtras() + " ";
          extras += suiteProperties.getExtras() + " ";
          extras += ""
            + "CFLAGS+=-I" + TUnit.getTunitBase().replace("\\","/") + "/tos/lib/tunit "
            + "CFLAGS+=-I" + TUnit.getTunitBase().replace("\\","/") + "/tos/lib/tunitstats "
            + "CFLAGS+=-I" + TUnit.getTunitBase().replace("\\","/") + "/tos/system "
            + "CFLAGS+=-I" + TUnit.getTunitBase().replace("\\","/") + "/tos/interfaces "
            + "CFLAGS+=-I" + TUnit.getTunitBase().replace("\\","/") + "/tos/lib/directserial "
            + "CFLAGS+=-DTUNIT_TOTAL_NODES=" + runProperties.totalNodes() + " "
            + "";
          
          focusedResult = make.build(buildDirectory, focusedTarget
              .getTargetName(), extras);
          report.addResult(focusedResult);
          if (!focusedResult.isSuccess()) {
            return false;
          }
        }

      } else {
        log.debug("Build properties are identical for nodes using target "
            + focusedTarget.getTargetName());
        extras = suiteProperties.getExtras() + " ";
        extras += ""
          + "CFLAGS+=-I" + TUnit.getTunitBase().replace("\\","/") + "/tos/lib/tunit "
          + "CFLAGS+=-I" + TUnit.getTunitBase().replace("\\","/") + "/tos/lib/tunitstats "
          + "CFLAGS+=-I" + TUnit.getTunitBase().replace("\\","/") + "/tos/system "
          + "CFLAGS+=-I" + TUnit.getTunitBase().replace("\\","/") + "/tos/interfaces "
          + "CFLAGS+=-I" + TUnit.getTunitBase().replace("\\","/") + "/tos/lib/directserial "
          + "CFLAGS+=-DTUNIT_TOTAL_NODES=" + runProperties.totalNodes() + " "
          + "";

        focusedResult = make.build(buildDirectory, focusedTarget
            .getTargetName(), extras);
        report.addResult(focusedResult);
        if (!focusedResult.isSuccess()) {
          return false;
        }

        log.debug("Total nodes to install: " + focusedTarget.totalNodes());
        String reinstallExtras;
        for (int nodeIndex = 0; nodeIndex < focusedTarget.totalNodes(); nodeIndex++) {
          focusedNode = focusedTarget.getNode(nodeIndex);
          reinstallExtras = " reinstall." + focusedNode.getId() + " ";
          reinstallExtras += focusedNode.getInstallExtras();

          focusedResult = make.build(buildDirectory, focusedTarget
              .getTargetName(), reinstallExtras);

          report.addResult(focusedResult);
          if (!focusedResult.isSuccess()) {
            return false;
          }
        }
      }
    }

    try {
      StatisticsChart.write(StatisticsReport.log(packageId, "Footprint",
          "[RAM Bytes]", make.getRamSize(), "[ROM Bytes]", make.getRomSize()), 
           500, 325);
      
    } catch (IOException e) {
      TestResult logResult = new TestResult("__LogFootprintStats");
      logResult.error("IOException", e.getMessage());
      report.addResult(logResult);

    } catch (ParseException e) {
      TestResult logResult = new TestResult("__ParseFootprintHistory");
      logResult.error("ParseException", e.getMessage());
      report.addResult(logResult);
    }

    // Next we process any app.c file we can get our hands on to extract
    // test name information vs. parameterized interface id
    if (focusedTarget == null) {
      return false;
    }
    
    File appcFile = new File(buildDirectory, "/" + make.getAppcLocation());
    log.info("Parsing app.c file " + appcFile.getAbsolutePath());
    
    // Attempt to find and parse the app.c file
    AppCParser appcParser = new AppCParser(appcFile);
    if (appcFile.exists()) {
      focusedResult = appcParser.parse();
      if (!focusedResult.isSuccess()) {
        report.addResult(focusedResult);
        return false;
      }
      
    } else {
      log.warn("Cannot find app.c file " + appcFile.getAbsolutePath());
      focusedResult = new TestResult("__ParseAppC");
      focusedResult.error("App.c Parser", "app.c file not found in " + appcFile.getAbsolutePath());
      report.addResult(focusedResult);
    }

    log.info("Parse complete, running test...");
    testMap = appcParser.getTestCaseMap();
    statsMap = appcParser.getStatisticsMap();
    return true;
  }

}
