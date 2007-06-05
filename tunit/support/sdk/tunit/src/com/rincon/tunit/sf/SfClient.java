// $Id$

/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/**
 * File: ServerReceivingThread.java
 *
 * Description:
 * The ServerReceivingThread listens for requests
 * from a connected Aggregator Server.  If a data
 * packet is received, it is sent on to the serial
 * port.
 *
 * @author <a href="mailto:bwhull@sourceforge.net">Bret Hull</a>
 * @author <a href="mailto:dgay@intel-research.net">David Gay</a>
 *
 */

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

import java.io.IOException;
import java.net.InetAddress;
import java.net.Socket;

import net.tinyos.packet.PacketListenerIF;
import net.tinyos.packet.SFProtocol;
import net.tinyos.util.Messenger;

/**
 * Serial forwarder socket client - modified version of SFClient.java
 * @author David Moss
 *
 */
public class SfClient extends SFProtocol implements Runnable, PacketListenerIF {
  
  private Thread thread;

  private Socket socket = null;

  private SerialForwarder sf;

  private SfProvider listenServer;

  private Messenger messenger;

  public SfClient(Socket mySocket, SerialForwarder serialForward,
      SfProvider listenSvr, Messenger myMessenger) {
    super("");
    thread = new Thread(this);
    sf = serialForward;
    listenServer = listenSvr;
    messenger = myMessenger;
    socket = mySocket;
    InetAddress addr = socket.getInetAddress();
    name = "client at " + addr.getHostName() + " (" + addr.getHostAddress()
        + ")";
  }

  protected void openSource() throws IOException {
    is = socket.getInputStream();
    os = socket.getOutputStream();
    super.openSource();
  }

  protected void closeSource() throws IOException {
    socket.close();
  }

  private void init() throws IOException {
    sf.incrementClients();
    open(messenger);
    listenServer.registerPacketListener(this);
  }

  public void shutdown() {
    try {
      close();
    } catch (IOException e) {
    }
  }

  public void start() {
    thread.start();
  }

  public final void join(long millis) throws InterruptedException {
    thread.join(millis);
  }

  public void run() {
    try {
      init();
      readPackets();
    } catch (IOException e) {
    } finally {
      listenServer.deregisterPacketListener(this);
      listenServer.removeSFClient(this);
      sf.decrementClients();
      shutdown();
    }
  }

  private void readPackets() throws IOException {
    for (;;) {
      byte[] packet = readPacket();

      sf.incrementPacketsWritten();
      if (!listenServer.writePacket(packet)) {
        listenServer.error(new IOException("write failed"));
      }
    }
  }

  public void packetReceived(byte[] packet) {
    try {
      writePacket(packet);
    } catch (IOException e) {
      shutdown();
    }
  }
}
