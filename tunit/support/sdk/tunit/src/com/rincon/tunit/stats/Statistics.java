package com.rincon.tunit.stats;

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
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;

import com.rincon.tunit.link.TUnitProcessing;
import com.rincon.util.Util;

import net.tinyos.message.Message;
import net.tinyos.message.MessageListener;
import net.tinyos.message.MoteIF;

/**
 * Connection to the mote, listening for statistics messages and passing them to
 * whatever object that cares.
 * 
 * @author David Moss
 * 
 */
public class Statistics extends Thread implements MessageListener {

  /** Logging */
  private static Logger log = Logger.getLogger(TUnitProcessing.class);

  /** MoteIF's that we're registered with */
  private List listeningComms;

  /** List of StatisticsEvents listeners */
  @SuppressWarnings("unchecked")
  private List listeners = Collections.synchronizedList(new ArrayList());

  /** List of received messages */
  @SuppressWarnings("unchecked")
  private List receivedMessages = Collections.synchronizedList(new ArrayList());

  /** Reply message received from the mote */
  @SuppressWarnings("unused")
  private StatisticsMsg inMsg;

  /** True if this thread is running */
  private boolean running;

  /**
   * Constructor
   * 
   */
  @SuppressWarnings("unchecked")
  public Statistics(MoteIF originalComm) {
    log = Logger.getLogger(getClass());
    inMsg = new StatisticsMsg();
    listeningComms = new ArrayList();
    listeningComms.add(originalComm);
    originalComm.registerListener(new StatisticsMsg(), this);
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
    comm.registerListener(new StatisticsMsg(), this);
  }

  /**
   * @param inMsg
   */
  private String extractUnits(StatisticsMsg inMsg) {
    return inMsg.getString_units();
    
    /*
    if (inMsg.get_unitLength() > 0) {
      short[] message = new short[inMsg.get_unitLength()];
      for (int i = 0; i < message.length && i < inMsg.get_units().length; i++) {
        message[i] = inMsg.get_units()[i];
      }
      return Util.dataToString(message);
    }

    return "";
    */
  }

  /**
   * Thread to handle events
   */
  public void run() {
    StatisticsMsg inMsg;
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

        inMsg = (StatisticsMsg) receivedMessages.get(0);

        if (inMsg != null) {
          extractUnits(inMsg);

          for (Iterator it = currentListeners.iterator(); it.hasNext();) {
            ((StatisticsEvents) it.next()).statistics_log(inMsg.get_statsId(),
                extractUnits(inMsg), inMsg.get_value());
          }

          receivedMessages.remove(inMsg);
        }
      }
    }
  }

  /**
   * Add a TUnitProcessing listener
   * 
   * @param listener
   */
  @SuppressWarnings("unchecked")
  public void addListener(StatisticsEvents listener) {
    if (!listeners.contains(listener)) {
      listeners.add(listener);
    }
  }

  /**
   * Remove a TUnitProcessing listener
   * 
   * @param listener
   */
  public void removeListener(StatisticsEvents listener) {
    listeners.remove(listener);
  }

  /**
   * Message received, handle replies immediately and handle events in a thread
   */
  @SuppressWarnings("unchecked")
  public synchronized void messageReceived(int to, Message m) {
    inMsg = (StatisticsMsg) m;

    log.info("RECEIVED A STATISTICS MESSAGE");
    log.debug("StatsMsg: id=" + inMsg.get_statsId() + "; units=" + extractUnits(inMsg) + "; value=" + inMsg.get_value());
    
    synchronized (receivedMessages) {
      receivedMessages.add(m);
      receivedMessages.notify();
    }
  }

  /**
   * Shutdown this TUnitProcessing listener
   * 
   */
  public void shutdown() {
    log.debug("Shutting down statistics listeners");
    running = false;
    for (Iterator it = listeningComms.iterator(); it.hasNext();) {
      ((MoteIF) it.next()).deregisterListener(new StatisticsMsg(), this);
    }
    log.debug("Clearing statistics communications");
    listeningComms.clear();
    log.debug("Clearing statistics listeners");
    listeners.clear();
    log.debug("Statistics communications shutdown complete");
  }
}
