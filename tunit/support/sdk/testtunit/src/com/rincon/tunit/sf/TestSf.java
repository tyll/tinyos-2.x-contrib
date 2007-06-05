package com.rincon.tunit.sf;

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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import junit.framework.JUnit4TestAdapter;

import net.tinyos.packet.PhoenixError;
import net.tinyos.util.Messenger;

import org.junit.Before;
import org.junit.After;
import org.junit.Test;

/**
 * You'll need to update your COM ports if you have different motes plugged in
 * 
 * @author David Moss
 * 
 */
public class TestSf implements PhoenixError, Messenger {

  /** COM Port a tmote is plugged into */
  public static final String comPort1 = "COM22";

  /** COM Port a tmote is plugged into */
  public static final String comPort2 = "COM51";

  /** A mote that shouldn't be plugged in */
  public static final String badComPort = "COM60";
  
  /** Number of "resynchronising" messages we've received from our SF's */
  private int syncing;

  /** List of serial forwarders we've instantiated so we can shut them down */
  private List forwardersUnderTest;

  /** True if there was an error from one of our sf's */
  private boolean error;

  /** Desciption of the last error message we received */
  private String errorDesc;

  public static junit.framework.Test suite() {
    return new JUnit4TestAdapter(TestSf.class);
  }

  @Before
  public void setUp() {
    System.out.println("Setting up...");
    forwardersUnderTest = new ArrayList();
    syncing = 0;
    error = false;
    errorDesc = "";
  }

  @After
  public void tearDown() {
    System.out.println("Tearing down...");
    syncing = 0;
    for (Iterator it = forwardersUnderTest.iterator(); it.hasNext();) {
      ((Sf) it.next()).disconnect();
    }
    forwardersUnderTest.clear();
  }

  @SuppressWarnings("unchecked")
  @Test
  public void connectOnce() {
    Sf sf1 = new Sf("serial@" + comPort1 + ":tmote", 9000, this, this);
    forwardersUnderTest.add(sf1);

    assertTrue("SF1.a Error: " + errorDesc + ". This requires a mote on "
        + comPort1 + ".", !error);
    assertEquals("SF1.a never logged in. This requires a mote on " + comPort1
        + ".", 1, syncing);

    sf1.disconnect();
  }
  
  
  @SuppressWarnings("unchecked")
  @Test
  public void connectMultipleTimes() {
    System.out.println("\nSTARTING connectMultipleTimes()");

    // Once...
    System.out.println("FIRST");
    Sf sf1 = new Sf("serial@" + comPort1 + ":tmote", 9000, this, this);
    forwardersUnderTest.add(sf1);

    assertTrue("SF1.a Error: " + errorDesc + ". This requires a mote on "
        + comPort1 + ".", !error);
    assertEquals("SF1.a never logged in. This requires a mote on " + comPort1
        + ".", 1, syncing);

    sf1.disconnect();

    // Twice...
    System.out.println("SECOND");
    syncing = 0;
    error = false;
    errorDesc = "";

    sf1.connect();

    assertTrue(
        "SF1.b Error: " + errorDesc + ". This requires a mote on " + comPort1 + ".",
        !error);
    assertEquals("SF1.b never logged in. This requires a mote on " + comPort1
        + ".", 1, syncing);

    sf1.disconnect();

    // Three times...
    System.out.println("THIRD");
    syncing = 0;
    error = false;
    errorDesc = "";

    sf1.connect();

    assertTrue("SF1.c Error: " + errorDesc + ". This requires a mote on "
        + comPort1 + ".", !error);
    assertEquals("SF1.c never logged in. This requires a mote on " + comPort1
        + ".", 1, syncing);

    sf1.disconnect();

  }

  /**
   * We create one new serial forwarder, connect and disconnect it. Then we
   * create a second serial forwarder using the same serial port as the last,
   * connect and disconnect it.
   * 
   */
  @SuppressWarnings("unchecked")
  @Test
  public void connectSeveralNewSfs() {
    System.out.println("\nSTARTING connectSeveralNewSfs()");
    // One new SF...
    Sf sf1 = new Sf("serial@" + comPort1 + ":tmote", 9000, this, this);
    forwardersUnderTest.add(sf1);

    assertTrue("SF1 Error: " + errorDesc + ". This requires a mote on " + comPort1,
        !error);
    assertEquals("SF1 never logged in. This requires a mote on " + comPort1, 1,
        syncing);

    sf1.disconnect();

    // Two new SF's...
    syncing = 0;
    error = false;
    errorDesc = "";
    Sf sf2 = new Sf("serial@" + comPort1 + ":tmote", 9000, this, this);

    assertTrue("SF2 Error: " + errorDesc + ". This requires a mote on "
        + comPort1, !error);
    assertEquals("SF2 never logged in. This requires a mote on " + comPort1, 1,
        syncing);

    sf2.disconnect();
  }

  /**
   * Connect to two different motes, disconnect, then reconnect to both those
   * motes again.
   * 
   */
  @SuppressWarnings("unchecked")
  @Test
  public void connectDifferentSfs() {
    System.out.println("\nSTARTING connectDifferentSfs()");

    // One new SF...
    System.out.println("Creating serial forwarders");
    Sf sf1 = new Sf("serial@" + comPort1 + ":tmote", 9000, this, this);
    Sf sf2 = new Sf("serial@" + comPort2 + ":tmote", 9001, this, this);

    forwardersUnderTest.add(sf1);
    forwardersUnderTest.add(sf2);

    System.out.println("Asserting we have two serial forwarders connected");
    assertTrue(errorDesc + ". This requires a mote on " + comPort1 + " and "
        + comPort2, !error);
    assertEquals("SF1 never logged in. This requires a mote on " + comPort1
        + " and " + comPort2, 2, syncing);

    System.out.println("Disconnecting SF1");
    sf1.disconnect();
    System.out.println("Disconnecting SF2");
    sf2.disconnect();

    // Reconnect again
    System.out.println("Reconnect again");
    syncing = 0;
    error = false;
    errorDesc = "";
    System.out.println("Connect SF1");
    sf1.connect();
    System.out.println("Connect SF2");
    sf2.connect();
    synchronized (this) {
      while (!error && syncing < 2) {
        try {
          wait();
        } catch (InterruptedException e) {
          fail("SF1 Timeout: " + e.getMessage() + ". This requires a mote on "
              + comPort1);
        }
      }

      assertTrue(errorDesc + ". This requires a mote on " + comPort1 + " and "
          + comPort2, !error);
      assertEquals("SF1 never logged in. This requires a mote on " + comPort1
          + " and " + comPort2, 2, syncing);
    }
    System.out.println("Disconnecting");
    sf1.disconnect();
    sf2.disconnect();

  }

  @SuppressWarnings("unchecked")
  @Test
  public void connectToNonExistingMote() {

    // Once...
    error = false;
    Sf sf1 = new Sf("serial@" + badComPort + ":tmote", 9000, this, this);
    forwardersUnderTest.add(sf1);

    assertTrue("Didn't get an error. This mote shouldn't be plugged in, and should have produced an error", error);
    sf1.disconnect();

  }
  
  
  public void error(IOException e) {
    System.err.println("TestSF Error: " + e.getMessage());
    errorDesc = e.getMessage();
    error = true;
    synchronized (this) {
      this.notify();
    }
  }

  public void message(String s) {
    System.out.println("Message: " + s);
    if (s.contains("resynchronising")) {
      synchronized (this) {
        syncing++;
        this.notify();
      }
    }
  }

}
