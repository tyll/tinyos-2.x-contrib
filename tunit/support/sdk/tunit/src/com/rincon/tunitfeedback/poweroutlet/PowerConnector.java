package com.rincon.tunitfeedback.poweroutlet;

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
import java.util.Iterator;

import net.tinyos.message.MoteIF;
import net.tinyos.packet.BuildSource;
import net.tinyos.packet.PhoenixError;
import net.tinyos.packet.PhoenixSource;
import net.tinyos.util.Messenger;

import com.rincon.tunit.TUnit;
import com.rincon.tunit.build.Make;
import com.rincon.tunit.parsers.tunitproperties.TUnitPropertiesParser;
import com.rincon.tunit.properties.TUnitNodeProperties;
import com.rincon.tunit.properties.TUnitTargetProperties;
import com.rincon.tunit.properties.TUnitTestRunProperties;
import com.rincon.tunit.report.TestResult;
import com.rincon.tunit.sf.Sf;

/**
 * Find, (install), and connect to the mote that is providing the power outlet
 * controlling functionality - either an apps/PowerOutletController/base or an
 * apps/PowerOutletController/outlet
 * @author David Moss
 *
 */
public class PowerConnector implements Messenger, PhoenixError {


  /** The port to use on our serial forwarder */
  private static final int DEFAULT_PORT = 9002;
  
  /** Serial forwarder to use */
  private Sf serialForwarder;

  /** Node we will program to talk to the power outlet */
  private TUnitNodeProperties connectedNode;

  /** Communication with the mote */
  private MoteIF comm;
  
  
  /**
   * Constructor
   * 
   */
  public PowerConnector() {
    if (comm == null) {
      if (!findSf()) {
        System.err.println("Could not find a lava lamp controller to connect.");
        System.err.println("Is your lava.xml file setup correctly?");
        System.err.println("Is your lava lamp controller node plugged in?");
        System.exit(1);
      }

      /*
      if (!reinstall()) {
        System.err.println("Could not install the controller binary");
        System.exit(2);
      }
      */
      
      serialForwarder.connect();
      
      String source = "sf@localhost:" + DEFAULT_PORT;
      PhoenixSource focusedSource = BuildSource.makePhoenix(source, this);
      focusedSource.setPacketErrorHandler(this);
      comm = new MoteIF(focusedSource);
    }
  }

  /**
   * 
   * @return the MoteIF connection
   */
  public MoteIF getComm() {
    return comm;
  }
  
  /**
   * Find a serial connection with the right mote type
   * 
   * @return true if we found a connection. The connection will not be connected
   */
  private boolean findSf() {
    // Find out which nodes we have attached to our computer that we can
    // take advantage of
    File lavaXmlFile = new File(TUnit.getTunitDirectory(), "lava.xml");
    if(lavaXmlFile.exists()) {
      System.out.println("Found " + lavaXmlFile.getAbsolutePath());
    } else {
      System.out.println("Could not locate " + lavaXmlFile.getAbsolutePath());
      return false;
    }
    
    TUnitPropertiesParser xmlParser = new TUnitPropertiesParser(lavaXmlFile);
    xmlParser.parse();

    TUnitTestRunProperties focusedRun;
    TUnitTargetProperties focusedTarget;
    TUnitNodeProperties focusedNode;

    // 1. Loop through each test run
    for (Iterator it = xmlParser.getAllTestRuns().iterator(); it.hasNext();) {
      focusedRun = ((TUnitTestRunProperties) it.next());
      if (focusedRun.containsTarget("telosb")) {

        // 2. Loop through each target, find the one we want
        for (int i = 0; i < focusedRun.totalTargets(); i++) {
          focusedTarget = focusedRun.getTarget(i);
          if (focusedTarget.getTargetName().matches("telosb")) {

            // 3. Loop through each node in that target, find one we can connect
            for (int nodeId = 0; nodeId < focusedTarget.totalNodes(); nodeId++) {
              focusedNode = focusedTarget.getNode(i);
              System.out.println("Attempting connection");
              serialForwarder = new Sf(focusedNode.getMotecom(), DEFAULT_PORT,
                  this);

              if (!serialForwarder.isConnected()) {
                System.out.println("SF attempt not connected");
                serialForwarder.disconnect();
              } else {
                // This is the node we want. Disconnect so we can program it.
                System.out.println("SF attempt connected");
                connectedNode = focusedNode;
                serialForwarder.disconnect();
                return true;
              }
            }
          }
        }
      }
    }
    return false;
  }

  /**
   * Only recompile the binary if we absolutely have to. We don't want the radio
   * stack to break at some point under test, and not be able to report it
   * wirelessly to our lava lamps.
   * 
   * @return true if the binary is installed
   */
  @SuppressWarnings("unused")
  private boolean reinstall() {
    Make make = new Make();
    TestResult focusedResult;

    // We do another tunit here because we don't know that something else took
    // care of it.
    TUnit tunit = new TUnit(new String[]{});
    File buildDirectory = new File(TUnit.getTunitDirectory(),
        "/apps/PowerOutletFeedback/base");

    if (!(new File(buildDirectory, "/build/telosb/main.ihex").exists())) {
      System.out.println(new File(buildDirectory, "/build/telosb/main.ihex")
          .getAbsolutePath()
          + " does not exist");
      focusedResult = make.build(buildDirectory, "telosb", " install "
          + connectedNode.getInstallExtras(), null);
    } else {
      focusedResult = make.build(buildDirectory, "telosb", " reinstall "
          + connectedNode.getInstallExtras(), null);
    }

    return focusedResult.isSuccess();
  }

  public void message(String s) {
    // TODO Auto-generated method stub
    
  }

  public void error(IOException e) {
    // TODO Auto-generated method stub
    
  }
}
