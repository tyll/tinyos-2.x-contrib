package com.rincon.tunit.report;

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

import org.apache.log4j.Logger;


/**
 * Write information about an individual suite of tests to XML so it can
 * be parsed and turned into HTML by ant's junitreport task.
 * 
 * We don't do anything fancy with writing the XML here, because it would
 * be kind of overkill.
 * 
 * @author David Moss
 *
 */
public class WriteXmlReport {

  /** The current report we're writing */
  private TestReport report;
  
  /** The file we'll write the XML test report to */
  private File outFile;
  
  /** Logging */
  private static Logger log = Logger.getLogger(WriteXmlReport.class);
  
  /**
   * Constructor
   * @param myReport
   * @param outDirectory
   */
  public WriteXmlReport(TestReport myReport, File outDirectory) {
    log = Logger.getLogger(getClass());
    report = myReport;
    if(!outDirectory.exists()) {
      log.debug("Creating directory " + outDirectory.getAbsolutePath());
      outDirectory.mkdirs();
    }
    
    File myFile = new File(outDirectory.getAbsolutePath() 
        + "/TEST-" 
        + report.getPackage()
        + ".xml");
    
    log.debug("Writing report " + myFile.getAbsolutePath());
    
    if(myFile.exists()) {
      log.debug("Deleting previous " + myFile.getAbsoluteFile());
      myFile.delete();
    }
    
    outFile = myFile;
  }
  
  /**
   * Write the XML file.
   * @throws IOException if the file can't be created for writing
   */
  public void write() throws IOException {
    PrintWriter out = new PrintWriter(
        new BufferedWriter(new FileWriter(outFile)));
    log.debug("Logging results to " + outFile.getAbsoluteFile());
    out.write(beginHeader());
    out.write(getTests());
    out.write(endHeader());
    out.close();
  }
  
  /**
   * Start the XML report header
   * @return
   */
  private String beginHeader() {
    //<testsuite name="<package>" tests="1" failures="1" errors="0" time="0.789">
    String header = "<testsuite name=\"";
    header += report.getPackage() + "\" tests=\"";
    header += report.getTotalTests() + "\" failures=\"";
    header += report.getTotalFailures() + "\" errors=\"";
    header += report.getTotalErrors() + "\" time=\"";
    header += report.getTotalDuration() + "\">\n";
    return header;
  }
  
  /**
   * Create the XML data for all the test results
   * @return
   */
  private String getTests() {
    String xml = "";
    for(int i = 0; i < report.getTotalTests(); i++) {
      xml += toXml(report.getTestResult(i));
    }
    
    return xml;
  }
  
  /**
   * Close off the XML report header
   * @return
   */
  private String endHeader() {
    return "</testsuite>";
  }
  
  private String toXml(TestResult result) {
    String xml = "";
    xml += "  <testcase classname=\"";
    xml += report.getPackage() + "\" "; // doesn't matter
    xml += "name=\"" + makeXmlFriendly(result.getTestName()) + "\n" + result.getSourceCodeLineNumber() + "\" ";
    xml += "time=\"" + result.getDuration() + "\"";
    
    if(!result.isError() && !result.isFailure()) {
      // Success.
      xml += "/>";
      xml += "\n\n";
      return xml;
    }
    
    // Failure or error.. go into detail.
    xml += ">\n";
    xml += "    <";
    if(result.isError()) {
      xml += "error";
    } else {
      xml += "failure";
    }
    
    xml += " type=\"" + makeXmlFriendly(result.getProblemType()) + "\">";  // doesn't matter
    xml += makeXmlFriendly(result.getFailMsg()) + "</";
    
    if(result.isError()) {
      xml += "error";
    } else {
      xml += "failure";
    }
    
    xml += ">\n";
    xml += "  </testcase>";
    xml += "\n\n";
    return xml;
    
  }
  
  /**
   * XML hates things like quotes and < >'s embedded in tags.
   * @param xml
   * @return
   */
  private String makeXmlFriendly(String xml) {
    xml = xml.replaceAll("\"","&quot;");
    xml = xml.replaceAll("<", "&lt;");
    xml = xml.replaceAll(">", "&gt;");
    return xml;
  }
}
