package com.rincon.blackbookbridge.bfilereadbridge;

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

public class BFileRead extends Thread implements
    BFileRead_Commands, MessageListener {

  /** Communication with the mote */
  private static MoteIF comm;

  /** List of FileTransferEvents listeners */
  private static List listeners = new ArrayList();

  /** List of received messages */
  private List receivedMessages = new ArrayList();

  /** Message to send */
  private BFileReadMsg outMsg = new BFileReadMsg();

  /** Reply message received from the mote */
  private BFileReadMsg replyMsg = new BFileReadMsg();
  
  /** True if we sent a command and are waiting for a reply */
  private boolean waitingForReply;

  /**
   * Constructor
   * 
   */
  public BFileRead() {
    if (comm == null) {
      comm = new MoteIF((Messenger) null);
      comm.registerListener(new BFileReadMsg(), this);
      start();
    }
  }

  /**
   * Thread to handle events
   */
  public void run() {
    while (true) {
      if (!receivedMessages.isEmpty()) {
        BFileReadMsg inMsg = (BFileReadMsg) receivedMessages.get(0);

        if (inMsg != null) {

          switch(inMsg.get_short0()) {
          case BFileRead_Constants.EVENT_OPENED:
            for(Iterator it = listeners.iterator(); it.hasNext(); ) {
              ((BFileRead_Events) it.next()).bFileRead_opened(inMsg.get_long0(), new TinyosError(inMsg.get_short1()));
            }
            break;          
            
          case BFileRead_Constants.EVENT_CLOSED:
            for(Iterator it = listeners.iterator(); it.hasNext(); ) {
              ((BFileRead_Events) it.next()).bFileRead_closed(new TinyosError(inMsg.get_short1()));
            }
            break;          
            
          case BFileRead_Constants.EVENT_READDONE:
            for(Iterator it = listeners.iterator(); it.hasNext(); ) {
              ((BFileRead_Events) it.next()).bFileRead_readDone(Util.truncate(inMsg.get_byteArray(), inMsg.get_int0()), inMsg.get_int0(), new TinyosError(inMsg.get_short1()));
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
   * Add a BFileRead listener
   * 
   * @param listener
   */
  public void addListener(BFileRead_Events listener) {
    if (!listeners.contains(listener)) {
      listeners.add(listener);
    }
  }

  /**
   * Remove a BFileRead listener
   * 
   * @param listener
   */
  public void removeListener(BFileRead_Events listener) {
    listeners.remove(listener);
  }

  /**
   * Message received, handle replies immediately and handle events in a
   * thread
   */
  public synchronized void messageReceived(int to, Message m) {
    replyMsg = (BFileReadMsg) m;
    
    switch(replyMsg.get_short0()) {
    case BFileRead_Constants.REPLY_OPEN:
      waitingForReply = false;
      notify();
      break;

    case BFileRead_Constants.REPLY_ISOPEN:
      waitingForReply = false;
      notify();
      break;

    case BFileRead_Constants.REPLY_CLOSE:
      waitingForReply = false;
      notify();
      break;

    case BFileRead_Constants.REPLY_READ:
      waitingForReply = false;
      notify();
      break;

    case BFileRead_Constants.REPLY_SEEK:
      waitingForReply = false;
      notify();
      break;

    case BFileRead_Constants.REPLY_SKIP:
      waitingForReply = false;
      notify();
      break;

    case BFileRead_Constants.REPLY_GETREMAINING:
      waitingForReply = false;
      notify();
      break;


    default:
        // Events get handled by a separate thread
      receivedMessages.add(m);
    }
  }

  public synchronized TinyosError open(int destination, String fileName) {
    waitingForReply = true;
    while(waitingForReply) {
      outMsg.set_short0(BFileRead_Constants.CMD_OPEN);
      outMsg.set_byteArray(Util.filenameToData(fileName, 8));  // TODO FILENAME_LENGTH
      send(destination);
      try {
        wait(50);
      } catch (InterruptedException e) {
      }
    }
    return new TinyosError(replyMsg.get_short1());
  }

  public synchronized boolean isOpen(int destination) {
    waitingForReply = true;
    while(waitingForReply) {
      outMsg.set_short0(BFileRead_Constants.CMD_ISOPEN);
      send(destination);
      try {
        wait(50);
      } catch (InterruptedException e) {
      }
    }
    return replyMsg.get_bool0() == 1;
  }

  public synchronized TinyosError close(int destination) {
    waitingForReply = true;
    while(waitingForReply) {
      outMsg.set_short0(BFileRead_Constants.CMD_CLOSE);
      send(destination);
      try {
        wait(50);
      } catch (InterruptedException e) {
      }
    }
    return new TinyosError(replyMsg.get_short1());
  }

  public synchronized TinyosError read(int destination, int amount) {
    waitingForReply = true;

      if(amount > outMsg.get_byteArray().length) {
    	  amount = outMsg.get_byteArray().length;
      }
      outMsg.set_short0(BFileRead_Constants.CMD_READ);
      outMsg.set_int0(amount);
      send(destination);
      try {
        wait(1000);
      } catch (InterruptedException e) {
      }

    return new TinyosError(replyMsg.get_short1());
  }

  public synchronized TinyosError seek(int destination, long fileAddress) {
    waitingForReply = true;
      outMsg.set_short0(BFileRead_Constants.CMD_SEEK);
      outMsg.set_long0(fileAddress);
      send(destination);
      try {
        wait(500);
      } catch (InterruptedException e) {
      }
    return new TinyosError(replyMsg.get_short1());
  }

  public synchronized TinyosError skip(int destination, int skipLength) {
    waitingForReply = true;
      outMsg.set_short0(BFileRead_Constants.CMD_SKIP);
      outMsg.set_int0(skipLength);
      send(destination);
      try {
        wait(500);
      } catch (InterruptedException e) {
      }
    return new TinyosError(replyMsg.get_short1());
  }

  public synchronized long getRemaining(int destination) {
    waitingForReply = true;
    while(waitingForReply) {
      outMsg.set_short0(BFileRead_Constants.CMD_GETREMAINING);
      send(destination);
      try {
        wait(50);
      } catch (InterruptedException e) {
      }
    }
    return (long) replyMsg.get_long0();
  }


}
