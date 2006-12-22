package com.rincon.blackbookbridge.bfiledeletebridge;

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
import com.rincon.util.Util;

import net.tinyos.message.Message;
import net.tinyos.message.MessageListener;
import net.tinyos.message.MoteIF;
import net.tinyos.util.Messenger;

public class BFileDelete extends Thread implements
    BFileDelete_Commands, MessageListener {

  /** Communication with the mote */
  private static MoteIF comm;

  /** List of FileTransferEvents listeners */
  private static List listeners = new ArrayList();

  /** List of received messages */
  private List receivedMessages = new ArrayList();

  /** Message to send */
  private BFileDeleteMsg outMsg = new BFileDeleteMsg();

  /** Reply message received from the mote */
  private BFileDeleteMsg replyMsg = new BFileDeleteMsg();
  
  /** True if we sent a command and are waiting for a reply */
  private boolean waitingForReply;

  /**
   * Constructor
   * 
   */
  public BFileDelete() {
    if (comm == null) {
      comm = new MoteIF((Messenger) null);
      comm.registerListener(new BFileDeleteMsg(), this);
      start();
    }
  }

  /**
   * Thread to handle events
   */
  public void run() {
    while (true) {
      if (!receivedMessages.isEmpty()) {
        BFileDeleteMsg inMsg = (BFileDeleteMsg) receivedMessages.get(0);

        if (inMsg != null) {

          switch(inMsg.get_short0()) {
          case BFileDelete_Constants.EVENT_DELETED:
            for(Iterator it = listeners.iterator(); it.hasNext(); ) {
              ((BFileDelete_Events) it.next()).bFileDelete_deleted(new TinyosError(inMsg.get_short1()));
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
   * Add a BFileDelete listener
   * 
   * @param listener
   */
  public void addListener(BFileDelete_Events listener) {
    if (!listeners.contains(listener)) {
      listeners.add(listener);
    }
  }

  /**
   * Remove a BFileDelete listener
   * 
   * @param listener
   */
  public void removeListener(BFileDelete_Events listener) {
    listeners.remove(listener);
  }

  /**
   * Message received, handle replies immediately and handle events in a
   * thread
   */
  public synchronized void messageReceived(int to, Message m) {
    replyMsg = (BFileDeleteMsg) m;
    
    switch(replyMsg.get_short0()) {
    case BFileDelete_Constants.REPLY_DELETE:
      waitingForReply = false;
      notify();
      break;


    default:
        // Events get handled by a separate thread
      receivedMessages.add(m);
    }
  }

  public synchronized TinyosError delete(int destination, String fileName) {
    waitingForReply = true;
    while(waitingForReply) {
      outMsg.set_short0(BFileDelete_Constants.CMD_DELETE);
      outMsg.set_fileName(Util.filenameToData(fileName, outMsg.get_fileName().length));
      send(destination);
      try {
        wait(50);
      } catch (InterruptedException e) {
      }
    }
    return new TinyosError(replyMsg.get_short1());
  }


}
