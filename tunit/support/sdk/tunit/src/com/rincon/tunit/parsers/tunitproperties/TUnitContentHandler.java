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

import java.util.ArrayList;
import java.util.List;

import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;

import com.rincon.tunit.properties.TUnitNodeProperties;
import com.rincon.tunit.properties.TUnitTestRunProperties;

/**
 * Process the input from the tunit.xml file given by the SAX
 * parser
 * 
 * @author David Moss
 *
 */
public class TUnitContentHandler implements ContentHandler {

  /** List of TUnitTestRunProperties for each test discovered */
  private List testRuns;
  
  /** Current test run properties to add to the testRuns List */
  private TUnitTestRunProperties testRunProperties;
  
  /** Current node properties to add to the current testRun */
  private TUnitNodeProperties nodeProperties;
  
  /**
   * Constructor
   *
   */
  public TUnitContentHandler() {
    testRuns = new ArrayList();
  }
  
  /**
   * 
   * @return the total number of test runs to perform
   */
  public int getTotalRuns() {
    return testRuns.size();
  }
  
  /**
   * @return an individual test run
   */
  public TUnitTestRunProperties getTestRun(int i) {
    return (TUnitTestRunProperties) testRuns.get(i);
  }
  
  public List getAllTestRuns() {
    return testRuns;
  }
  
  public void setDocumentLocator(Locator arg0) {
  }

  public void startDocument() throws SAXException {
  }

  public void endDocument() throws SAXException {
  }

  public void startPrefixMapping(String arg0, String arg1) throws SAXException {
  }

  public void endPrefixMapping(String arg0) throws SAXException {
  }

  public void startElement(String namespaceURI, String localName, String rawName,
      Attributes atts) throws SAXException {
    
    if(localName.equalsIgnoreCase("testrun")) {      
      for(int i = 0; i < atts.getLength(); i++) {
        if(atts.getLocalName(i).equalsIgnoreCase("name")) {
          testRunProperties = new TUnitTestRunProperties(atts.getValue(i));
        }
      }
      
      if(testRunProperties == null) {
        testRunProperties = new TUnitTestRunProperties();
      }
    }
    
    if(localName.equalsIgnoreCase("mote")) {
      nodeProperties = new TUnitNodeProperties();
      
      for(int i = 0; i < atts.getLength(); i++) {
        if(atts.getLocalName(i).equalsIgnoreCase("target")) {
          nodeProperties.setTarget(atts.getValue(i));
        } else if(atts.getLocalName(i).equalsIgnoreCase("motecom")) {
          nodeProperties.setMotecom(atts.getValue(i));
        } else if(atts.getLocalName(i).equalsIgnoreCase("buildextras")) {
          nodeProperties.setBuildExtras(atts.getValue(i));
        } else if(atts.getLocalName(i).equalsIgnoreCase("installextras")) {
          nodeProperties.setInstallExtras(atts.getValue(i));
        }
      }
    }
  }

  @SuppressWarnings("unchecked")
  public void endElement(String namespaceURI, String localName, String rawName)
      throws SAXException {
    if(localName.matches("mote")) {
      if(testRunProperties != null) {
        testRunProperties.addNodeToTestRun(nodeProperties);
      }
      nodeProperties = null;
      
    } else if(localName.matches("testrun")) {
      if(testRuns != null && testRunProperties != null) {
        testRuns.add(testRunProperties);
      }
    }
    
  }

  public void characters(char[] arg0, int start, int end) throws SAXException {
  }

  public void ignorableWhitespace(char[] arg0, int arg1, int arg2)
      throws SAXException {
  }

  public void processingInstruction(String arg0, String arg1)
      throws SAXException {

  }

  public void skippedEntity(String arg0) throws SAXException {

  }

}
