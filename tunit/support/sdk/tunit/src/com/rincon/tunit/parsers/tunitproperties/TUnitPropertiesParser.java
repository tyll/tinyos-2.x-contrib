package com.rincon.tunit.parsers.tunitproperties;

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
import java.util.List;

import org.apache.xerces.parsers.SAXParser;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

import com.rincon.tunit.properties.TUnitTestRunProperties;
import com.rincon.tunit.report.TestResult;

/**
 * Entry point to parsing a tunit.xml file.  This file is written
 * by the user, and contains configuration information about each type of test 
 * we want to run with tunit.
 * 
 * @author David Moss
 *
 */
public class TUnitPropertiesParser {

  private File myXmlFile;
  
  private XMLReader reader;
  
  private TUnitContentHandler tunitContent;
  
  /**
   * Constructor
   * @param xmlFile
   */
  public TUnitPropertiesParser(File xmlFile) {
    myXmlFile = xmlFile;
    reader = new SAXParser(); 
    tunitContent = new TUnitContentHandler();
    reader.setContentHandler(tunitContent);
  }
  
  public TestResult parse() {
    TestResult result = new TestResult("__ParseTUnitXml");
    try {
      reader.parse(myXmlFile.getAbsolutePath());
    } catch (IOException e) {
      result.error("IOException", "Couldn't parse the TUnit XML: " + e.getMessage());
    } catch (SAXException e) {
      result.error("SAXException", "Couldn't parse the TUnit XML: " + e.getMessage());
    }
    
    return result;
  }
  
  /**
   * 
   * @return the total number of test runs to perform
   */
  public int getTotalRuns() {
    return tunitContent.getTotalRuns();
  }
  
  /**
   * @return an individual test run
   */
  public TUnitTestRunProperties getTestRun(int i) {
    return tunitContent.getTestRun(i);
  }
  
  /**
   * 
   * @return a List of TUnitTestRunProperties
   */
  public List getAllTestRuns() {
    return tunitContent.getAllTestRuns();
  }
}
