/**
 * File: ListenServer.java
 *
 * Description:
 * The Listen Server is the heart of the serial forwarder.  Upon
 * instantiation, this class spawns the SerialPortReader and the
 * Multicast threads.  As clients connect, this class spawns
 * ServerReceivingThreads as wells as registers the new connection
 * SerialPortReader.  This class also provides the central
 * point of contact for the GUI, allowing the server to easily
 * be shut down
 *
 * @author <a href="mailto:bwhull@sourceforge.net">Bret Hull</a>
 * @author <a href="mailto:dgay@intel-research.net">David Gay</a>
 */
package com.rincon.tunit.sf;

/*
 * Copyright (c) 2005-2006 Rincon Research Corporation All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: -
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer. - Redistributions in binary
 * form must reproduce the above copyright notice, this list of conditions and
 * the following disclaimer in the documentation and/or other materials provided
 * with the distribution. - Neither the name of the Rincon Research Corporation
 * nor the names of its contributors may be used to endorse or promote products
 * derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE RINCON RESEARCH OR ITS CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE
 */

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;

import net.tinyos.packet.BuildSource;
import net.tinyos.packet.PacketListenerIF;
import net.tinyos.packet.PhoenixError;
import net.tinyos.packet.PhoenixSource;
import net.tinyos.util.Messenger;

/**
 * Generic Serial forwarder. This is a heavily modified SFListen class
 * 
 * @author David Moss
 * 
 */
public class SfProvider extends Thread implements PacketListenerIF,
    PhoenixError {

  /** Logging */
  private static Logger log = Logger.getLogger(SfProvider.class);

  /** Source of our packets */
  private PhoenixSource source;

  /** Socket for other clients to connect with */
  private ServerSocket serverSocket;

  /** Clients using this connection */
  private List clients = new ArrayList();

  /** Object that is listening for error messages */
  private PhoenixError errorListener;

  /** Objects that is listening for general messages */
  private Messenger commentListener;

  /** Motecom to connect with */
  private String motecom;

  /** ServerSocket port to use for other clients to connect with */
  private int port;

  /** Serial forwarder implementation */
  private SerialForwarder serialForwarder;

  /**
   * Constructor
   * 
   * @param myMotecom
   */
  public SfProvider(String myMotecom, int externalPort,
      SerialForwarder mySerialForwarder, Messenger myCommentListener,
      PhoenixError myErrorListener) {
    
    log = Logger.getLogger(getClass());
    log.trace("constructor()");
    motecom = myMotecom;
    port = externalPort;
    commentListener = myCommentListener;
    serialForwarder = mySerialForwarder;
    errorListener = myErrorListener;
  }

  /**
   * Register a packet listener with our source
   * 
   * @param listener
   */
  public void registerPacketListener(PacketListenerIF listener) {
    log.trace("registerPacketListener()");
    source.registerPacketListener(listener);
  }

  /**
   * De-register a packet listener from our source
   * 
   * @param listener
   */
  public void deregisterPacketListener(PacketListenerIF listener) {
    log.trace("deregisterPacketListener()");
    source.deregisterPacketListener(listener);
  }

  /**
   * Write a packet to our source
   * 
   * @param packet
   * @return true if the packet was sent and ack'd successfully
   * @throws IOException
   */
  public boolean writePacket(byte[] packet) throws IOException {
    return source.writePacket(packet);
  }

  /**
   * An error occured. Pass it up to the error listeners.
   */
  public void error(IOException e) {
    log.trace("error()");
    errorListener.error(e);
  }

  @SuppressWarnings("unchecked")
  public void run() {
    try {
      source = BuildSource.makePhoenix(motecom, commentListener);
      if (source == null) {
        error(new IOException("Invalid source " + motecom));
        return;
      }

      source.setPacketErrorHandler(this);
      source.registerPacketListener(this);
      source.start();

      // open up our server socket
      try {
        serverSocket = new ServerSocket(port);
      } catch (Exception e) {
        error(new IOException("Could not listen on port: " + port));
        source.shutdown();
        return;
      }

      try {
        for (;;) {
          log.debug("Accepting socket");
          Socket currentSocket = serverSocket.accept();
          log.debug("Socket accepted, creating new SFClient");
          SfClient newServicer = new SfClient(currentSocket, serialForwarder,
              this, commentListener);
          clients.add(newServicer);
          newServicer.start();
        }
      } catch (IOException e) {
      }
    } finally {
      cleanup();
    }
  }

  private void cleanup() {
    log.trace("cleanup()");
    shutdownAllSFClients();
    
    if (source != null) {
      source.shutdown();
    }
    
    if (serverSocket != null) {
      try {
        serverSocket.close();
      } catch (IOException e) {
      }
    }
    
    serialForwarder.serverStopped();
  }

  private void shutdownAllSFClients() {
    SfClient crrntServicer;
    List myClients = new ArrayList();
    myClients.addAll(clients);
    
    log.trace("shutdownAllSFClients()");
    
    for(Iterator it = myClients.iterator(); it.hasNext(); ) {
      crrntServicer = (SfClient) it.next();
      crrntServicer.shutdown();
        
      try {
        crrntServicer.join(1000);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
    
    clients.clear();
  }

  public void removeSFClient(SfClient clientS) {
    log.trace("removeSFClient()");
    clients.remove(clientS);
  }

  public void packetReceived(byte[] packet) {
    serialForwarder.incrementPacketsRead();
  }

  public void shutdown() {
    log.trace("shutdown()");
    try {

      if (serverSocket != null) {
        // This causes our for(;;) loop inside of run() to throw an exception,
        // which kills the rest of the thread, cleans up, and shuts down
        serverSocket.close();
      }
      
    } catch (IOException e) {
      error(new IOException("shutdown error " + e));
    }
  }
}
