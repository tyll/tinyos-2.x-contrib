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

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.log4j.Logger;

import com.rincon.tunit.properties.TUnitSuiteProperties;
import com.rincon.tunit.report.TestResult;

/**
 * Parse test suite configuration files. These files can be located
 * throughout the test directory structure, modifying information about
 * each individual suite or groups of test suites
 * 
 * @author David Moss
 *
 */
public class SuitePropertiesParser {

  /** Logging */
  private static Logger log = Logger.getLogger(SuitePropertiesParser.class);
  
  /** File containing the properties to parse */
  private File myPropertiesFile;
  
  /** Current test properties we're putting together */
  private TUnitSuiteProperties suiteProperties;
  
  
  /**
   * Constructor
   * @param configFile
   */
  public SuitePropertiesParser(File propertiesFile) {
    suiteProperties = new TUnitSuiteProperties();
    myPropertiesFile = propertiesFile;
    log = Logger.getLogger(getClass());
  }
  
  public TestResult parse() {
    TestResult result = new TestResult("Suite Properties Parser");
    
    if (!myPropertiesFile.exists()) {
      log.warn("Test suite .properties file not found");
      result.error("Suite.properties Parser", "Suite .properties file not found in " + myPropertiesFile.getAbsolutePath());
      return result;
    }

    try {
      BufferedReader in = new BufferedReader(new FileReader(myPropertiesFile));
      String line;
      boolean parsingDescription = false;
      
      while ((line = in.readLine()) != null) {
        
        if(line.toLowerCase().startsWith("@") && !line.toLowerCase().startsWith("@description")) {
          parsingDescription = false;
        }
        
        if(line.toLowerCase().startsWith("@author")) {
          suiteProperties.addAuthor(line.replace("@author", "").trim());
          
        } else if(line.toLowerCase().startsWith("@testname")) {
          suiteProperties.setTestName(line.replace("@testname","").trim());
          
        } else if(line.toLowerCase().startsWith("@description")) {
          parsingDescription = true;
          suiteProperties.addDescription(line.replace("@description","").trim());
          
        } else if(line.toLowerCase().startsWith("@extras")) {
          String extraLine = line.replace("@extras","").trim();
          if(extraLine.toLowerCase().contains("cflag") || extraLine.toLowerCase().contains("pflag")) {
            suiteProperties.addCFlags(extraLine);
          } else {
            suiteProperties.addExtras(extraLine);
          }
          
        } else if(line.toLowerCase().startsWith("@extra")) {
          String extraLine = line.replace("@extra","").trim();
          
          if(extraLine.toLowerCase().contains("cflag") || extraLine.toLowerCase().contains("pflag")) {
            suiteProperties.addCFlags(extraLine);
          } else {
            suiteProperties.addExtras(extraLine);
          }

        } else if(line.toLowerCase().startsWith("@cflags")) {
          String cflagLine = line.replace("@cflags","").trim();
          suiteProperties.addCFlags(cflagLine);
          
        } else if(line.toLowerCase().startsWith("@cflag")) {
          String cflagLine = line.replace("@cflag","").trim();
          suiteProperties.addCFlags(cflagLine);
          
        } else if(line.toLowerCase().startsWith("@assertions")) {
          int numAssertions;
          try {
            numAssertions = Integer.decode(line.replace("@assertions","").trim()).intValue();
            
          } catch (NumberFormatException e) {
            log.error("Unable to extract assertions, use a valid number: " + line);
            numAssertions = 5;  // The default
          }
          
          suiteProperties.addCFlags("-DMAX_TUNIT_QUEUE=" + numAssertions);

        } else if(line.toLowerCase().startsWith("@ignore")) {
          suiteProperties.addIgnore(line.replace("@ignore","").trim());
          
        } else if(line.toLowerCase().startsWith("@only")) {
          suiteProperties.addOnlyTarget(line.replace("@only","").trim());
          
        } else if(line.toLowerCase().startsWith("@skip")) {
          suiteProperties.setSkip(true);
          
        } else if(line.toLowerCase().startsWith("@timeout")) {
          try {
            suiteProperties.setTimeout(Integer.decode(line.replace("@timeout","").trim()).intValue());
          } catch(NumberFormatException e) {
            log.error("Unable to decode " + line);
          }
          
        } else if(line.toLowerCase().startsWith("@minnodes")) {
          try {
            suiteProperties.setMinNodeCount(Integer.decode(line.replace("@minnodes","").trim()).intValue());
          } catch(NumberFormatException e) {
            log.error("Unable to decode " + line);
          }
          
        } else if(line.toLowerCase().startsWith("@maxnodes")) { 
          try {
            suiteProperties.setMaxNodeCount(Integer.decode(line.replace("@maxnodes","").trim()).intValue());
          } catch(NumberFormatException e) {
            log.error("Unable to decode " + line);
          }
          
        } else if(line.toLowerCase().startsWith("@exactnodes")) {
          try {
            suiteProperties.setExactNodeCount(Integer.decode(line.replace("@exactnodes","").trim()).intValue());
          } catch(NumberFormatException e) {
            log.error("Unable to decode " + line);
          }
          
        } else if(line.toLowerCase().startsWith("@mintargets")) {
          try {
            suiteProperties.setMinTargetCount(Integer.decode(line.replace("@mintargets","").trim()).intValue());
          } catch(NumberFormatException e) {
            log.error("Unable to decode " + line);
          }
          
        } else if(line.toLowerCase().startsWith("@compile")) {
          suiteProperties.setCompileOption(line.replace("@compile","").trim());
          
        } else if(line.toLowerCase().startsWith("@cmd")) {
          StringTokenizer tokens = new StringTokenizer(line.replace("@cmd",""));
          
          if(tokens.countTokens() < 2) {
            log.error("Too few arguments to suite.properties flag: " + line);
            continue;
          }
          
          String type = tokens.nextToken();
          String command = "";
          
          while(tokens.hasMoreTokens()) {
            command += tokens.nextToken() + " ";
          }
          
          if(type.equalsIgnoreCase("start")) {
            suiteProperties.setStartCmd(command);
            
          } else if(type.equalsIgnoreCase("run")) {
            suiteProperties.setRunCmd(command);
            
          } else if(type.equalsIgnoreCase("stop")) {
            suiteProperties.setStopCommand(command);
            
          } else {
            log.error("Illegal @cmd type: " + line);
          }
          
        } else if(parsingDescription) {
          suiteProperties.addDescription(line.replace("@description","").trim());
        }
      }
      
      in.close();
    } catch (IOException e) {
      result.error("IOException", "IOException in test suite properties parser " + myPropertiesFile.getAbsolutePath());
    }
    
    return result;
  }
  
  /**
   * 
   * @return the properties of the suite that was parsed
   */
  public TUnitSuiteProperties getSuiteProperties() {
    return suiteProperties;
  }
}
