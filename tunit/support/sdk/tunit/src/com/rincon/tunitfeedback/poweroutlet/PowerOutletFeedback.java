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

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.rincon.tunitfeedback.FeedbackHandler;

import net.tinyos.message.Message;
import net.tinyos.message.MessageListener;
import net.tinyos.message.MoteIF;

/**
 * Automatically Generated w/modifications
 */
public class PowerOutletFeedback implements PowerOutletFeedback_Commands,
    MessageListener, FeedbackHandler {

  /** Communication with the mote */
  private static MoteIF comm;

  /** List of received messages */
  private List receivedMessages = new ArrayList();

  /** Message to send */
  private PowerOutletFeedbackMsg outMsg = new PowerOutletFeedbackMsg();

  /** Reply message received from the mote */
  private PowerOutletFeedbackMsg replyMsg = new PowerOutletFeedbackMsg();

  /** Address of our power outlet. */
  public static final int OUTLET_ADDRESS = 0xFFFF;

  /**
   * Constructor with manual connect method
   * @param moteIf the connection already established
   */
  public PowerOutletFeedback(MoteIF moteIf) {
    comm = moteIf;
  }
  
  /**
   * Autoconnect method
   *
   */
  public PowerOutletFeedback() {
    comm = new PowerConnector().getComm();
  }

  /**
   * Send a message, assumes exactly 1 outlet to talk to 
   * 
   * @param dest
   * @param m
   */
  private synchronized void send() {
    if (comm != null) {
      try {
        comm.send(OUTLET_ADDRESS, outMsg);
      } catch (IOException e) {
      }
    }
  }

  /**
   * Message received, handle replies immediately and handle events in a thread
   */
  @SuppressWarnings("unchecked")
  public synchronized void messageReceived(int to, Message m) {
    replyMsg = (PowerOutletFeedbackMsg) m;

    switch (replyMsg.get_short0()) {
    case PowerOutletFeedback_Constants.POWEROUTLETFEEDBACK_REPLY_SETPOWER:
      synchronized (this) {
        this.notify();
      }
      break;

    default:
      // Events get handled by a separate thread
      receivedMessages.add(m);
    }
  }

  public synchronized void setPower(boolean outlet1, boolean outlet2) {
    outMsg.set_short0(PowerOutletFeedback_Constants.POWEROUTLETFEEDBACK_CMD_SETPOWER);
    outMsg.set_bool0((short) (outlet1 ? 1 : 0));
    outMsg.set_bool1((short) (outlet2 ? 1 : 0));
    send();

    synchronized (this) {
      try {
        wait(100);
      } catch (InterruptedException e) {
      }
    }
  }


  public void testsPassed() {
    System.out.println("GREEN LAVA LAMP ON");
    // hackish retries
    setPower(true, false);
  }

  public void testsFailed() {
    System.out.println("RED LAVA LAMP ON");
    // hackish retries
    setPower(false, true);
  }


}
