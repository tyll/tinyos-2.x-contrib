package com.rincon.tunit.link;

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

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;

import com.rincon.tunit.run.ResultCollector;
import com.rincon.util.Util;

import net.tinyos.message.Message;
import net.tinyos.message.MessageListener;
import net.tinyos.message.MoteIF;

/**
 * Automatically Generated
 * 
 * @author David Moss
 * @author Till Maas
 * 
 */
public class TUnitProcessing extends Thread implements
    TUnitProcessing_Commands, MessageListener {

  /** Logging */
  private static Logger log = Logger.getLogger(TUnitProcessing.class);
  
  /** MoteIF's that we're registered with */
  private List listeningComms;

  /** List of FileTransferEvents listeners */
  private List listeners = new ArrayList();

  /** List of received messages */
  @SuppressWarnings("unchecked")
  private List receivedMessages = java.util.Collections
      .synchronizedList(new ArrayList());

  /** Message to send */
  private TUnitProcessingMsg outMsg = new TUnitProcessingMsg();

  /** Reply message received from the mote */
  private TUnitProcessingMsg replyMsg = new TUnitProcessingMsg();

  /** The current fail message being constructed */
  private String currentFailMsg = "";

  /** True if this thread is running */
  private boolean running;

  /**
   * Constructor
   * 
   */
  @SuppressWarnings("unchecked")
  public TUnitProcessing(MoteIF originalComm) {
    log = Logger.getLogger(getClass());
    listeningComms = new ArrayList();
    listeningComms.add(originalComm);
    originalComm.registerListener(new TUnitProcessingMsg(), this);
    running = true;
    start();
  }

  /**
   * Listen to another MoteIF communicator
   * 
   * @param
   */
  @SuppressWarnings("unchecked")
  public void addMoteIf(MoteIF comm) {
    listeningComms.add(comm);
    comm.registerListener(new TUnitProcessingMsg(), this);
  }

  /**
   * Append some data to our current fail message
   * 
   * @param inMsg
   */
  private void appendFailMsg(TUnitProcessingMsg inMsg) {
    currentFailMsg += inMsg.getString_failMsg();
  }

  /**
   * Thread to handle events
   */
  public void run() {
    TUnitProcessingMsg inMsg;
    List currentListeners;
    while (running) {
      synchronized (receivedMessages) {
        while (receivedMessages.isEmpty()) {
          try {
            receivedMessages.wait();
          } catch (InterruptedException ie) {
          }
        }

        currentListeners = new ArrayList();
        currentListeners.addAll(listeners);
        
        inMsg = (TUnitProcessingMsg) receivedMessages.get(0);

        if (inMsg != null) {
          switch (inMsg.get_cmd()) {
          case TUnitProcessing_Constants.TUNITPROCESSING_EVENT_PONG:
            for (Iterator it = currentListeners.iterator(); it.hasNext();) {
              ((TUnitProcessing_Events) it.next()).tUnitProcessing_pong();
            }
            break;

          case TUnitProcessing_Constants.TUNITPROCESSING_EVENT_TESTRESULT_SUCCESS:
            for (Iterator it = currentListeners.iterator(); it.hasNext();) {
              ((TUnitProcessing_Events) it.next())
                  .tUnitProcessing_testSuccess(inMsg.get_id(), inMsg.get_assertionId());
            }
            currentFailMsg = "";
            break;

          case TUnitProcessing_Constants.TUNITPROCESSING_EVENT_TESTRESULT_FAILED:
            appendFailMsg(inMsg);

            if (inMsg.get_lastMsg() == 1) {
              for (Iterator it = currentListeners.iterator(); it.hasNext();) {
                ((TUnitProcessing_Events) it.next())
                    .tUnitProcessing_testFailed(inMsg.get_id(), inMsg.get_assertionId(), currentFailMsg);
              }
              currentFailMsg = "";
            }
            break;

          case TUnitProcessing_Constants.TUNITPROCESSING_EVENT_TESTRESULT_EQUALS_FAILED:
            appendFailMsg(inMsg);

            if (inMsg.get_lastMsg() == 1) {
              for (Iterator it = currentListeners.iterator(); it.hasNext();) {
                ((TUnitProcessing_Events) it.next())
                    .tUnitProcessing_testFailed(inMsg.get_id(), inMsg.get_assertionId(), currentFailMsg
                        + "; Expected [" + inMsg.get_expected() + " / 0x" + Long.toHexString(inMsg.get_expected()) + "] but got ["
                        + inMsg.get_actual() + " / 0x" + Long.toHexString(inMsg.get_actual()) + "] (unsigned 32-bit form)");
              }
              currentFailMsg = "";
            }
            break;

          case TUnitProcessing_Constants.TUNITPROCESSING_EVENT_TESTRESULT_NOTEQUALS_FAILED:
            appendFailMsg(inMsg);

            if (inMsg.get_lastMsg() == 1) {
              for (Iterator it = currentListeners.iterator(); it.hasNext();) {
                ((TUnitProcessing_Events) it.next())
                    .tUnitProcessing_testFailed(inMsg.get_id(), inMsg.get_assertionId(), currentFailMsg
                        + "; Shouldn't have gotten [" + inMsg.get_actual()
                        + "] (unsigned 32-bit form)");
              }
              currentFailMsg = "";
            }
            break;

          case TUnitProcessing_Constants.TUNITPROCESSING_EVENT_TESTRESULT_BELOW_FAILED:
            appendFailMsg(inMsg);

            if (inMsg.get_lastMsg() == 1) {
              for (Iterator it = currentListeners.iterator(); it.hasNext();) {
                ((TUnitProcessing_Events) it.next())
                    .tUnitProcessing_testFailed(inMsg.get_id(), inMsg.get_assertionId(), currentFailMsg
                        + "; Actual result [" + inMsg.get_actual()
                        + "] was not below [" + inMsg.get_expected()
                        + "] (unsigned 32-bit form)");
              }
              currentFailMsg = "";
            }
            break;

          case TUnitProcessing_Constants.TUNITPROCESSING_EVENT_TESTRESULT_ABOVE_FAILED:
            appendFailMsg(inMsg);

            if (inMsg.get_lastMsg() == 1) {
              for (Iterator it = currentListeners.iterator(); it.hasNext();) {
                ((TUnitProcessing_Events) it.next())
                    .tUnitProcessing_testFailed(inMsg.get_id(), inMsg.get_assertionId(), currentFailMsg
                        + "; Actual result [" + inMsg.get_actual()
                        + "] was not above [" + inMsg.get_expected()
                        + "] (unsigned 32-bit form)");
              }
              currentFailMsg = "";
            }
            break;

          case TUnitProcessing_Constants.TUNITPROCESSING_EVENT_ALLDONE:
            for (Iterator it = currentListeners.iterator(); it.hasNext();) {
              ((TUnitProcessing_Events) it.next()).tUnitProcessing_allDone();
            }
            break;

          default:
          }

          receivedMessages.remove(inMsg);
        }
      }
    }
  }

  /**
   * Send a message to the given destination. For TUnit, it is assumed that the
   * destination addresses start at 0 (base node) and go on up to however many
   * nodes are connected for the given test run
   * 
   * @param dest
   * @param m
   */
  private synchronized void send(int destination) {
    try {
      if (listeningComms.size() > destination) {
        ((MoteIF) listeningComms.get(destination)).send(destination, outMsg);
      }
    } catch (IOException e) {
    }
  }

  /**
   * Add a TUnitProcessing listener
   * 
   * @param listener
   */
  @SuppressWarnings("unchecked")
  public void addListener(TUnitProcessing_Events listener) {
    if (!listeners.contains(listener)) {
      listeners.add(listener);
    }
  }

  /**
   * Remove a TUnitProcessing listener
   * 
   * @param listener
   */
  public void removeListener(TUnitProcessing_Events listener) {
    listeners.remove(listener);
  }

  /**
   * Message received, handle replies immediately and handle events in a thread
   */
  @SuppressWarnings("unchecked")
  public synchronized void messageReceived(int to, Message m) {
    replyMsg = (TUnitProcessingMsg) m;

    switch (replyMsg.get_cmd()) {
    case TUnitProcessing_Constants.TUNITPROCESSING_REPLY_PING:
      notify();
      break;

    case TUnitProcessing_Constants.TUNITPROCESSING_REPLY_RUN:
      notify();
      break;

    default:
      // Events get handled by a separate thread
      synchronized (receivedMessages) {
        receivedMessages.add(m);
        receivedMessages.notify();
      }
    }
  }

  public synchronized void runTest() {
    outMsg.set_cmd(TUnitProcessing_Constants.TUNITPROCESSING_CMD_RUN);
    send(0);
  }

  public void ping() {
    outMsg.set_cmd(TUnitProcessing_Constants.TUNITPROCESSING_CMD_PING);
    send(0);
  }

  /**
   * Tell all motes we're connected with to tear down one time
   */
  public void tearDownOneTime() {
    outMsg.set_cmd(TUnitProcessing_Constants.TUNITPROCESSING_CMD_TEARDOWNONETIME);
    for (int i = 0; i < listeningComms.size(); i++) {
      send(i);
    }
  }

  /**
   * Shutdown this TUnitProcessing listener
   * 
   */
  public void shutdown() {
    running = false;
    log.debug("Shutting down TUnit listeners");
    for (Iterator it = listeningComms.iterator(); it.hasNext();) {
      ((MoteIF) it.next()).deregisterListener(new TUnitProcessingMsg(), this);
    }
    log.debug("Clearing TUnit comms");
    listeningComms.clear();
    log.debug("Clearing TUnit listeners");
    listeners.clear();
    log.debug("TUnit communications shutdown complete");
  }
}
