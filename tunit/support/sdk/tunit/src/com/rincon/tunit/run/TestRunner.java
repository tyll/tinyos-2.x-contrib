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

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
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

  /** App.c assertion ID numbers to source code line numbers map */
  private Map assertionMap;

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
    packageId = createPackageIdentification();

    log.info("PACKAGE " + packageId);

    if (!RerunRegistry.shouldRun(packageId)) {
      log.debug("RerunRegistry: " + packageId + " doesn't need to rerun");
      return;
    }

    createTunitPathFile();

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

    // 1. Build and install the project on all test run nodes
    if (!install()) {
      return;
    }

    // 2. Connect serial forwarders, run the test, disconnect sf's.
    log.debug("Connecting serial forwarders");
    if (!testManager.connectAll()) {
      TestResult result = new TestResult("__ConnectSerialForwarders");
      result.error("SFError", "Could not connect all serial forwarders!");
      report.addResult(result);
      return;
    }

    CmdFlagExecutor.executeCmdFlag("start", suiteProperties.getStartCmd(),
        report);

    log.debug("Running test");
    new ResultCollector(report, runProperties, suiteProperties, testMap,
        statsMap, assertionMap);

    CmdFlagExecutor
        .executeCmdFlag("stop", suiteProperties.getStopCmd(), report);

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
      StatisticsChart.write(StatisticsReport.log(runProperties.getName(),
          buildDirectory, "TestingProgress", "[Total Problems]", report
              .getTotalErrors()
              + report.getTotalFailures(), "[Total Tests]", report
              .getTotalTests()), 500, 325);
    } catch (IOException e) {
      log.error("Error writing XML report: \n" + e.getMessage());
    } catch (ParseException e) {
      log.error(e.getMessage());
    }
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
    String env;

    for (int i = 0; i < runProperties.totalTargets(); i++) {
      focusedTarget = runProperties.getTarget(i);
      if (runProperties.getTarget(i).requiresMultipleBuilds()) {
        log.debug("Build properties differ for nodes using target "
            + focusedTarget.getTargetName());
        for (int nodeIndex = 0; nodeIndex < focusedTarget.totalNodes(); nodeIndex++) {
          
          if(focusedTarget.getTargetName().isEmpty()) {
            // Nothing to compile or install for this node
            continue;
          }
          
          log.debug("Cleaning");
          focusedResult = make.clean(buildDirectory);
          if (!focusedResult.isSuccess()) {
            report.addResult(focusedResult);
            return false;
          }

          focusedNode = focusedTarget.getNode(nodeIndex);
          extras = "install." + focusedNode.getId() + " ";
          extras += focusedNode.getInstallExtras() + " ";
          extras += suiteProperties.getExtras() + " ";
          extras += "tunit ";
          extras += focusedNode.getBuildExtras() + " ";

          env = "TUNITCFLAGS=\"" + "-DTUNIT_TOTAL_NODES="
              + runProperties.totalNodes() + " " + suiteProperties.getCFlags()
              + "\"";

          log.debug("Compiling and installing");
          focusedResult = make.build(buildDirectory, focusedTarget
              .getTargetName(), extras, env);

          if (!focusedResult.isSuccess()) {
            report.addResult(focusedResult);
            return false;
          }
        }

      } else {
        log.debug("Build properties are identical for nodes using target "
            + focusedTarget.getTargetName());

        if (needsCompile(focusedTarget.getTargetName())) {
          log.debug("Cleaning");
          focusedResult = make.clean(buildDirectory);
          if (!focusedResult.isSuccess()) {
            report.addResult(focusedResult);
            return false;
          }

          log.debug("Compiling");

          focusedNode = focusedTarget.getNode(0);

          extras = suiteProperties.getExtras() + " ";
          extras += "tunit ";
          extras += focusedNode.getBuildExtras() + " ";

          env = "TUNITCFLAGS=\"" + "-DTUNIT_TOTAL_NODES="
              + runProperties.totalNodes() + " " + suiteProperties.getCFlags()
              + "\"";

          focusedResult = make.build(buildDirectory, focusedTarget
              .getTargetName(), extras, env);

          report.addResult(focusedResult);
          if (!focusedResult.isSuccess()) {
            return false;
          }
        }

        if (!doesBuildExist(focusedTarget.getTargetName())) {
          log.error("Cannot install or run test! Build doesn't exist.");
          TestResult logResult = new TestResult("__Build");
          logResult
              .error(
                  "No test to install!",
                  "Build doesn't exist, and we can't compile.\n"
                      + "Compile manually, or change the @compile option in suite.properties.");
          report.addResult(logResult);
          return false;
        }

        log.debug("Total nodes to install: " + focusedTarget.totalNodes());
        
        String reinstallExtras;
        for (int nodeIndex = focusedTarget.totalNodes() - 1; nodeIndex >= 0; nodeIndex--) {
          if(focusedTarget.getTargetName().equalsIgnoreCase("")) {
            continue;
          }
          
          focusedNode = focusedTarget.getNode(nodeIndex);
          reinstallExtras = " reinstall." + focusedNode.getId() + " ";
          reinstallExtras += focusedNode.getInstallExtras();

          focusedResult = make.build(buildDirectory, focusedTarget
              .getTargetName(), reinstallExtras, null);

          if (!focusedResult.isSuccess()) {
            report.addResult(focusedResult);
            return false;
          }
          
          // Wait 3 second between each install.
          synchronized(this) {
            try {
              wait(3000);
            } catch (InterruptedException e) {
              // TODO Auto-generated catch block
              e.printStackTrace();
            }
          }
        }
      }
    }

    try {
      if (make.getRomSize() > 0) {
        StatisticsChart.write(StatisticsReport.log(runProperties.getName(),
            buildDirectory, "Footprint", "[RAM Bytes]", make.getRamSize(),
            "[ROM Bytes]", make.getRomSize()), 500, 325);
      }

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

    File appcFile = new File(buildDirectory, "build/"
        + focusedTarget.getTargetName() + "/app.c");
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
      focusedResult.error("App.c Parser", "app.c file not found in "
          + appcFile.getAbsolutePath());
      report.addResult(focusedResult);
    }

    log.info("Parse complete, running test...");
    testMap = appcParser.getTestCaseMap();
    statsMap = appcParser.getStatisticsMap();
    assertionMap = appcParser.getAssertionMap();
    return true;
  }

  /**
   * If the compile option for this test suite says we should only compile once,
   * then we check to see if a build directory exists with the app.c file
   * inside. If this is found, then we don't need to compile.
   * 
   * If the compile option is "never", we don't need to compile.
   * 
   * If the compile option is "always" or "default" then we need to compile.
   * 
   * @param focusedTarget
   * @return true if we need to compile.
   */
  private boolean needsCompile(String focusedTargetName) {
    if(focusedTargetName.isEmpty()) {
      log.debug("The target name is empty; nothing to compile");
      return false;
    }
    
    if (suiteProperties.getCompileOption() == TUnitSuiteProperties.COMPILE_ALWAYS
        || suiteProperties.getCompileOption() == TUnitSuiteProperties.COMPILE_DEFAULT_ALWAYS) {
      log.debug("Compile recommended");
      return true;
 
    } else if (suiteProperties.getCompileOption() == TUnitSuiteProperties.COMPILE_ONCE) {
      if (doesBuildExist(focusedTargetName)) {
        log.debug("Recommend no compile since build already exists.");
        return false;

      } else {
        log.debug("Compile recommended");
        return true;
      }
    }

    log.debug("This test must be compiled manually");
    return false;
  }

  /**
   * 
   * @param focusedTargetName
   * @return true if the test firmware image exists. We look for the app.c file.
   */
  private boolean doesBuildExist(String focusedTargetName) {
    if(focusedTargetName.equalsIgnoreCase("")) {
      return true;
    }
    
    log.debug("Checking "
        + new File(buildDirectory, "build/" + focusedTargetName + "/app.c")
            .getAbsolutePath());

    return new File(buildDirectory, "build/" + focusedTargetName + "/app.c")
        .exists();
  }

  /**
   * This is responsible for creating the package ID that helps us uniquely
   * locate the code for the test and the settings under which it ran.
   * 
   * @return
   */
  private String createPackageIdentification() {
    String returnString = runProperties.getName() + ".";

    String packageDir = buildDirectory.getAbsolutePath().substring(
        TUnit.getBasePackageDirectory().getAbsolutePath().length()).replace(
        File.separatorChar, '.');

    if (packageDir.startsWith(".")) {
      packageDir = packageDir.replaceFirst("\\.", "");
    }

    return returnString + packageDir;
  }

  /**
   * Create a file in the local test directory
   */
  private void createTunitPathFile() {
    PrintWriter out;
    File outFile;
    
    // Step 1: Create a .tunitPath file for the local test directory
    outFile = new File(buildDirectory, ".tunitPath");
    if (outFile.exists()) {
      outFile.delete();
    }

    try {
      out = new PrintWriter(new BufferedWriter(new FileWriter(outFile)));

      String reportDirectory = TUnit.getStatsReportDirectory()
          .getAbsolutePath()
          + File.separatorChar
          + StatisticsReport.generateStatsSubDirectory(runProperties.getName(),
              buildDirectory);
      
      new File(reportDirectory).mkdirs();
      out.write(reportDirectory + "\n");
      out.close();

    } catch (IOException e) {
      e.printStackTrace();
    }
  }
}
