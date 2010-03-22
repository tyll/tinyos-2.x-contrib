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
import java.io.FilenameFilter;
import java.io.IOException;
import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;
import org.w3c.dom.Element;

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

  /** TUNIT_BASE directory - tinyos-2.x-contrib/tunit */
  private static File tunitDirectory;

  /** Directory to throw reports into */
  private static File baseReportDirectory;

  /** The directory we're running our tests from */
  private static File rootDirectory;
  
  /** The tunit.xml file location */
  private static File tunitXmlFile; 

  /** True if we want to enable the @cmd flags in suite.properties files */
  private static boolean cmdFlagEnabled = false;
  
  /** True if this was run from the command line and can exit when finished */
  private static boolean runFromCommandLine = false;
  
  /**
   * The directory from which all other packages are relative Also the directory
   * where build.xml is located, or the root of the file system
   */
  private static File basePackageDirectory;

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
    runFromCommandLine = true;
    org.apache.log4j.BasicConfigurator.configure();
    Logger.getRootLogger().setLevel((Level) Level.DEBUG);
    new TUnit(args).runTunit();
  }

  private void exit(int errorCode) {
    if(runFromCommandLine) {
      System.exit(errorCode);
    }
  }
  
  
  /**
   * Constructor
   * 
   */
  public TUnit(String[] args) {
    rootDirectory = new File(System.getProperty("user.dir"));
    File packageDirectoryAttempt = null;
    TestReport.clear();
    
    rerunRegistry = new RerunRegistry();
    
    for (int i = 0; i < args.length; i++) {
      if (args[i].equalsIgnoreCase("-tunitbase") && args.length > i + 1) {
        i++;
        
        if(i > args.length) {
          log.error("Not enough arguments");
          syntax();
          System.exit(1);
        }
        
        tunitBase = args[i];
        
        File tunitBaseAttempt = new File(tunitBase);
        if (!tunitBaseAttempt.exists()) {
          System.out.println("Invalid TUnit Base Directory: "
              + tunitBaseAttempt.getAbsolutePath());
          syntax();
          System.exit(1);
        }
        
        log.debug("Using TUnit at: " + tunitBase);

      } else if (args[i].equalsIgnoreCase("-testdir") && args.length > i + 1) {
        i++;
        
        if(i > args.length) {
          log.error("Not enough arguments");
          syntax();
          System.exit(1);
        }
        
        File rootDirectoryAttempt = new File(args[i]);

        if (!rootDirectoryAttempt.exists()) {
          System.err.println("Invalid Test Directory: "
              + rootDirectoryAttempt.getAbsolutePath());
          syntax();
          System.exit(1);

        } else {
          rootDirectory = rootDirectoryAttempt;
          log.debug("Testing at directory: " + rootDirectory.getAbsolutePath());
        }

      } else if (args[i].equalsIgnoreCase("-packagedir") && args.length > i + 1) {
        i++;
        
        if(i > args.length) {
          log.error("Not enough arguments");
          syntax();
          System.exit(1);
        }
        
        packageDirectoryAttempt = new File(args[i]);

      } else if (args[i].equalsIgnoreCase("-reportdir") && args.length > i + 1) {
        i++;
        
        if(i > args.length) {
          log.error("Not enough arguments");
          syntax();
          System.exit(1);
        }
        
        baseReportDirectory = new File(args[i]);

        // We'll create the report directory if it doesn't exist.

        log.debug("Saving TUnit reports in: "
            + baseReportDirectory.getAbsolutePath());

      } else if (args[i].equalsIgnoreCase("-debug")) {
        // Set the logger all the way down to the lowest level
        log.info("Running TUnit in debug mode");
        Logger.getRootLogger().setLevel((Level) Level.TRACE);

      } else if (args[i].equalsIgnoreCase("-tunitxml")) {
        i++;
        
        if(i > args.length) {
          log.error("Not enough arguments");
          syntax();
          System.exit(1);
        }
        
        tunitXmlFile = new File(args[i]);
        if(!tunitXmlFile.exists()) {
          log.error("The given tunit.xml file does not exist:");
          log.error(tunitXmlFile.getAbsoluteFile());
          tunitXmlFile = null;
          
        } else {
          log.info("Using tunit.xml file located at " + tunitXmlFile.getAbsolutePath());
        }
        
        
      } else if (args[i].equalsIgnoreCase("-enablecmd")) {
        log.info("External @cmd flags enabled");
        cmdFlagEnabled = true;
      
      } else if (args[i].equalsIgnoreCase("-rerun")) {
          rerunRegistry.enableRerun();
        
      } else if (args[i].contains("?")) {
        syntax();
        System.exit(1);
      }
    }

    // Process this after we've absolutely set our root directory
    if (packageDirectoryAttempt != null) {
      if (!packageDirectoryAttempt.exists()) {
        System.err.println("Invalid Package Directory: "
            + packageDirectoryAttempt.getAbsolutePath());
        syntax();
        System.exit(2);

      } else if (!rootDirectory.getAbsolutePath().toLowerCase().startsWith(
          packageDirectoryAttempt.getAbsolutePath().toLowerCase())) {
        
        
        /*
         * The package identifier is outside of our root directory. This causes
         * problems because when we move into our root directory's tree, we
         * cannot remove the base package directory identifier from the current
         * test directory's absolute path
         */
        System.err.println("\n" + packageDirectoryAttempt.getAbsolutePath().toLowerCase());
        System.err.println("    is not inside of ");
        System.err.println(rootDirectory.getAbsolutePath().toLowerCase() + "\n\n");
        
        System.err
            .println("Package directory mismatch! The base package directory MUST be");
        System.err
            .println("below the directory structure you're testing within.");
        System.err
            .println("For example, if you're testing within /opt/tunit/tests,");
        System.err
            .println("your base package directory may be /opt, /opt/tunit, or /opt/tunit/tests,");
        System.err
            .println("but cannot be something outside of that like /yap/mypackage.");
        System.err
            .println("By default, the base package directory is the current or parent");
        System.err
            .println("directory containing the build.xml file. If no directory above contains");
        System.err
            .println("a build.xml file, the base package directory is your root directory");
        syntax();
        System.exit(2);

      } else {
        basePackageDirectory = packageDirectoryAttempt;
        log.debug("Base package directory set to: "
            + basePackageDirectory.getAbsolutePath());
      }
    }

    log = Logger.getLogger(getClass());

    // Run this in case the base package wasn't defined above
    getBasePackageDirectory();

    establishTunitDir();
    establishReportDir();
  }

  /**
   * Run TUnit tests
   * 
   * @param args
   */
  public int runTunit() {
    startTime = System.currentTimeMillis();
    System.out.println("Running TUnit from " + rootDirectory.getAbsolutePath());
    
    // 0. You should have already instantiated TUnit and passed in arguments.
    
    // 1. Locate the tunit.xml file from the TUNIT_BASE directory
    processTunitXml();

    // 2. Now that everything is established, configure rerun settings
    rerunRegistry.setBaseDirectory(tunitDirectory);
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
      if(runFromCommandLine) {
        exit(127);
      }
    }

    if(runFromCommandLine) {
      exit(0);
    }
    
    return TestReport.getTotalTunitErrors();
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
   * Get a friendly string version of the TUNIT_BASE directory, with the correct
   * slashies.
   * 
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
    if (tunitBase == null) {
      // We're flexible. Pick one. Or don't, we're still flexible.

      if(((String) System.getenv().get("TUNIT_BASE") != null)) {
          log.info("Found a TUNIT_BASE environment variable");
          tunitBase = ((String) System.getenv().get("TUNIT_BASE")).replace('\\',
              File.separatorChar).replace('/', File.separatorChar);
          
      } else if((String) System.getenv().get("TUNIT_HOME") != null) {
        log.info("Found a TUNIT_HOME environment variable");
        ((String) System.getenv().get("TUNIT_HOME")).replace('\\',
            File.separatorChar).replace('/', File.separatorChar);
        
      } else if((String) System.getenv().get("TOSCONTRIB") != null) {
        log.info("Found a TOSCONTRIB environment variable");
        tunitBase = ((String) System.getenv().get("TOSCONTRIB")).replace('\\',
            File.separatorChar).replace('/', File.separatorChar)
                + File.separatorChar + "tunit";
      }
        
    }

    if (tunitBase == null) {
      File buildXml = new File("build.xml");
      if (buildXml.exists()) {
        // We must be in the TUnit base directory
        tunitBase = System.getProperty("user.dir");
        log.info("Defining the base TUnit directory as " + tunitBase);

        
      } else if(basePackageDirectory != null) {
        if(new File(basePackageDirectory, "/tos/lib/tunit").exists()) {
          // This is a good guess at what TUNIT_BASE is... let's go with it.
          tunitBase = basePackageDirectory.getAbsolutePath();
          log.info(
              "\nTaking a guess at where tinyos-2.x-contrib/tunit is from the base package directory" +
              "\nNext time please set your TOSCONTRIB environment variable to point to the" +
              "\ntinyos-2.x-contrib directory");
          log.info("Defining the base TUnit directory as " + tunitBase);
          
        }
        
      }
    }
    
    // Still undefined?
    if(tunitBase == null) {
      log.fatal("" +
          "\nTOSCONTRIB environment variable not defined." +
          "\nTOSCONTRIB should define where the tinyos-2.x-contrib directory exists." +
          "\nPlace your tunit.xml file in the tinyos-2.x-contrib/tunit directory." +
          "\nThere are four different methods for setting this directory: " +
          "\n  1) Don't define any environment variable and run TUnit from" +
          "\n     tinyos-2.x-contrib/tunit containing build.xml" +
          "\n       -OR-" +
          "\n  2) export TUNIT_BASE=/path/to/tinyos-2.x-contrib/tunit" +
          "\n       -OR-" +
          "\n  3) export TUNIT_HOME=/path/to/tinyos-2.x-contrib/tunit" +
          "\n       -OR-" +
          "\n  4) export TOSCONTRIB=/path/to/tinyos-2.x-contrib" +
          "\nAlso ensure you are using absolute paths. For windows/cygwin," +
          "\nthis means \"export TOSCONTRIB=c:/cygwin/opt/tinyos-2.x-contrib\"");
      exit(2);
    }

    // 2. Verify it is a valid, existing directory
    tunitDirectory = new File(tunitBase);
    if (!tunitDirectory.exists()) {
      log.fatal(tunitBase + " does not exist.");
      log.fatal("Please set your TOSCONTRIB directory properly.\n"
          + "Make sure it's an absolute path. If you're in cygwin, this\n"
          + "means it must start with something like C:/cygwin/...\n");
      exit(2);
    }

    if (!tunitDirectory.isDirectory()) {
      log.fatal(tunitBase + " is not a directory.");
      log.fatal("Please set your TOSCONTRIB directory properly");
      exit(3);
    }
    
    log.debug("Found TUnit! " + tunitDirectory);
  }

  /**
   * If the private basePackageDirectory variable is null, this locates the base
   * package directory by looking at all parent directories until a directory is
   * found containing the build.xml file. The location functionality is a
   * one-time thing, and every other time this function is called it will simply
   * return that package directory.
   * 
   * The package directory is mainly used for test reporting. Say you're running
   * tests from C:/opt/tinyos-2.x-contrib/tests/blah, and your base package
   * directory is found to be C:/opt/tinyos-2.x-contrib/tests. All tests run
   * below .../blah will be in the package "tests.blah.whatever" which is
   * helpful when we want to track down where the test is from the html reports.
   * 
   * @return the base package directory from which all other tests are run and
   *         referenced.
   */
  public static File getBasePackageDirectory() {
    if (basePackageDirectory != null) {
      return basePackageDirectory;
    }
    
    File currentDirectory;
    
    for(currentDirectory = rootDirectory; currentDirectory.list(
        new FilenameFilter() {
          public boolean accept(File dir, String name) {
            return name.compareToIgnoreCase("build.xml") == 0;
          }
        }).length == 0 ; ) {
          
      if(currentDirectory.getParentFile() != null) {
        currentDirectory = currentDirectory.getParentFile();
        
      } else {
        break;
      }
    }
    
    basePackageDirectory = currentDirectory;
    
    log.info("Base package directory located: " + basePackageDirectory.getAbsolutePath());
    return basePackageDirectory;
  }

  /**
   * Establish that the directory where test reports will go into exists. Setup
   * our static report directory so other classes can access it externally
   * 
   */
  private void establishReportDir() {
    if (baseReportDirectory == null) {
      baseReportDirectory = new File(tunitBase, "/reports");
    }

    new File(baseReportDirectory, "/xml").mkdirs();
  }

  /**
   * Locate and parse the tunit.xml file with all the test run properties
   * 
   */
  private void processTunitXml() {
    if(tunitXmlFile == null) {
      tunitXmlFile = new File(tunitDirectory, "tunit.xml");
    }
    
    if (!tunitXmlFile.exists()) {
      log.fatal("Cannot locate " + tunitXmlFile.getAbsolutePath());
      log.fatal("Does " + tunitXmlFile.getAbsolutePath() + " exist?");
      exit(4);
    }

    // 5. Process the tunit.xml file
    log.debug("Processing " + tunitXmlFile);
    TUnitPropertiesParser tunitParser = new TUnitPropertiesParser(
        tunitXmlFile);
    TestResult parseResult = tunitParser.parse();
    if (parseResult.isSuccess()) {
      log.debug(tunitXmlFile.getAbsoluteFile() + " processed successfully");
    } else {
      log.fatal(parseResult.getFailMsg());
      exit(5);
    }
    
    
    System.out.println("Looking for log4j.xml in " + tunitXmlFile.getAbsolutePath() + "...");
    
    if(new File(tunitXmlFile.getParent(), "log4j.xml").exists()) {
      System.out.println("Applying your log4j.xml file now");
      DOMConfigurator.configure(new File(tunitXmlFile.getParent(), "log4j.xml").getAbsolutePath());
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
    System.out.println("Total tests recorded: " + TestReport.getTotalTunitTests());
    System.out.println("Total errors: " + TestReport.getTotalTunitErrors());
    System.out.println("Total failures: " + TestReport.getTotalTunitFailures()
        + "\n");

    if (TestReport.getAllTunitProblems() != null) {
      TestResult problemResult;
      for (Iterator it = TestReport.getAllTunitProblems().iterator(); it
          .hasNext();) {
        problemResult = (TestResult) it.next();
        System.out.println(problemResult.getTestName() + "\n"
            + problemResult.getSourceCodeLineNumber() 
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
      StatisticsLogData dataSet = StatisticsReport.log("", null, "TotalProgress",
          "[Total Problems]", TestReport.getTotalTunitErrors()
              + TestReport.getTotalTunitFailures(), "[Total Tests]", TestReport
              .getTotalTunitTests());
      StatisticsChart.write(dataSet, 500, 325);

      // Write out our results for just the past 5 days.
      Calendar cal = Calendar.getInstance();
      cal.add(Calendar.DATE, -5);
      Date severalDaysAgo = cal.getTime();
      StatisticsLogData truncatedSet = new StatisticsLogData("RecentProgress",
          getStatsReportDirectory(), "[# Problems]", "[# Tests]");
      for (int i = 0; i < dataSet.size(); i++) {
        if (dataSet.get(i).getDate().after(severalDaysAgo)) {
          truncatedSet.addEntry(dataSet.get(i));
        }
      }
      StatisticsChart.write(truncatedSet, 500, 325);

      // And.. write out results for the past 5 days with a different name
      cal = Calendar.getInstance();
      cal.add(Calendar.DATE, -5);
      severalDaysAgo = cal.getTime();
      truncatedSet = new StatisticsLogData("Progress",
          getStatsReportDirectory().getParentFile(), "[# Problems]",
          "[# Tests]");
      for (int i = 0; i < dataSet.size(); i++) {
        if (dataSet.get(i).getDate().after(severalDaysAgo)) {
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


  private void syntax() {
    System.out.println("TUnit Syntax: java com.rincon.tunit.TUnit (options)");
    System.out.println("\nOptions are:");
    System.out.println("\t-tunitbase [absolute path to the equivalent of");
    System.out.println("\t\ttinyos-2.x-contrib/tunit]");
    System.out.println("\t\tThe tinyos-2.x-contrib/tunit directory contains");
    System.out.println("\t\tTUnit's embedded libraries");
    System.out.println();
    System.out.println("\t-testdir [absolute test directory]");
    System.out.println("\t\tThis lets you start testing in a specific directory");
    System.out.println();
    System.out.println("\t-reportdir [absolute report directory]");
    System.out.println("\t\tThis directory is where your reports will be stored.");
    System.out.println();
    System.out.println("\t-packagedir [absolute package directory]");
    System.out.println("\t\tThis directory is where your tests will be reference from in");
    System.out.println("\t\treports. By default, this is the parent directory containing");
    System.out.println("\t\ta build.xml");
    System.out.println();
    System.out.println("\t-tunitxml [absolute path to tunit.xml]");
    System.out.println("\t\tThis lets you specify a tunit.xml file outside of your");
    System.out.println("\t\ttinyos-2.x-contrib/tunit directory.");
    System.out.println();
    System.out.println("\t-enablecmd");
    System.out.println("\t\tEnables the @cmd suite.properties command.");
    System.out.println("\t\tThis will allow command line arguments to run during");
    System.out.println("\t\ta test, providing a hook to run external scripts and");
    System.out.println("\t\tapplications that may be useful to the test, such as");
    System.out.println("\t\taccessing external test and measurement equipment.");
    System.out.println();
    System.out.println("\t-debug");
    System.out.println("\t\tDisplay all TUnit Java framework debug statements");
    System.out.println("\n\t-? for help");
  }

  public static boolean isCmdFlagEnabled() {
    return cmdFlagEnabled;
  }
}
