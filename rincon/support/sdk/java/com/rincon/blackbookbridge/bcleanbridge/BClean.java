package com.rincon.blackbookbridge.bcleanbridge;

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
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
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

import com.rincon.blackbookbridge.TinyosError;

import net.tinyos.message.Message;
import net.tinyos.message.MessageListener;
import net.tinyos.message.MoteIF;
import net.tinyos.util.Messenger;

public class BClean extends Thread implements
    BClean_Commands, MessageListener {

  /** Communication with the mote */
  private static MoteIF comm;

  /** List of FileTransferEvents listeners */
  private static List listeners = new ArrayList();

  /** List of received messages */
  private List receivedMessages = new ArrayList();

  /** Message to send */
  private BCleanMsg outMsg = new BCleanMsg();

  /** Reply message received from the mote */
  private BCleanMsg replyMsg = new BCleanMsg();
  
  /** True if we sent a command and are waiting for a reply */
  private boolean waitingForReply;

  /**
   * Constructor
   * 
   */
  public BClean() {
    if (comm == null) {
      comm = new MoteIF((Messenger) null);
      comm.registerListener(new BCleanMsg(), this);
      start();
    }
  }

  /**
   * Thread to handle events
   */
  public void run() {
    while (true) {
      if (!receivedMessages.isEmpty()) {
        BCleanMsg inMsg = (BCleanMsg) receivedMessages.get(0);

        if (inMsg != null) {

          switch(inMsg.get_short0()) {
          case BClean_Constants.EVENT_ERASING:
            for(Iterator it = listeners.iterator(); it.hasNext(); ) {
              ((BClean_Events) it.next()).bClean_erasing();
            }
            break;          case BClean_Constants.EVENT_GCDONE:
            for(Iterator it = listeners.iterator(); it.hasNext(); ) {
              ((BClean_Events) it.next()).bClean_gcDone(inMsg.get_bool0() == 1);
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
   * Send a message
   * 
   * @param dest
   * @param m
   */
  private synchronized void send(int destination) {
    try {
      comm.send(destination, outMsg);
    } catch (IOException e) {
    }
  }

  /**
   * Add a BClean listener
   * 
   * @param listener
   */
  public void addListener(BClean_Events listener) {
    if (!listeners.contains(listener)) {
      listeners.add(listener);
    }
  }

  /**
   * Remove a BClean listener
   * 
   * @param listener
   */
  public void removeListener(BClean_Events listener) {
    listeners.remove(listener);
  }

  /**
   * Message received, handle replies immediately and handle events in a
   * thread
   */
  public synchronized void messageReceived(int to, Message m) {
    replyMsg = (BCleanMsg) m;
    
    switch(replyMsg.get_short0()) {
    case BClean_Constants.REPLY_PERFORMCHECKUP:
      waitingForReply = false;
      notify();
      break;

    case BClean_Constants.REPLY_GC:
      waitingForReply = false;
      notify();
      break;


    default:
        // Events get handled by a separate thread
      receivedMessages.add(m);
    }
  }

  public synchronized TinyosError performCheckup(int destination) {
    waitingForReply = true;
    while(waitingForReply) {
      outMsg.set_short0(BClean_Constants.CMD_PERFORMCHECKUP);
      send(destination);
      try {
        wait(50);
      } catch (InterruptedException e) {
      }
    }
    return new TinyosError(replyMsg.get_short1());
  }

  public synchronized TinyosError gc(int destination) {
    waitingForReply = true;
    while(waitingForReply) {
      outMsg.set_short0(BClean_Constants.CMD_GC);
      send(destination);
      try {
        wait(50);
      } catch (InterruptedException e) {
      }
    }
    return new TinyosError(replyMsg.get_short1());
  }


}
