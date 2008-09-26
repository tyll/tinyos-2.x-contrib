// $Id$

/*									tab:2
 *
 *
 * "Copyright (c) 2000-2005 The Regents of the University  of California.  
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
 */

/**
 * @author Jonathan Hui <jwhui@cs.berkeley.edu>
 */

package net.tinyos.deluge;

import net.tinyos.message.*;
import java.io.*;

public class ImageInjector implements MessageListener {

  private Pinger pinger;
  private DelugeAdvMsg advMsg;
  private DelugeAdvMsg pingReply;
  private MoteIF  moteif;
  private TOSBootImage oldTOSBootImage, newTOSBootImage;
  private DelugeImage delugeImage;
  private short[] imageBytes;
  private Thread pageInjectorThread;
  private PageInjector pageInjector;
  private boolean verbose;
  private boolean force = false;
  private boolean injectAcked = false;

  private int nodeid = MoteIF.TOS_BCAST_ADDR;
  
  public ImageInjector(Pinger pinger, int imageNum,
		       TOSBootImage newTOSBootImage, 
		       MoteIF moteif, boolean verbose, boolean force) {

    if (imageNum < 0 || imageNum >= pinger.getNumImages()) {
      throw new IllegalArgumentException( "invalid image number " + imageNum );
    }

    if (imageNum == DelugeConsts.DELUGE_GOLDEN_IMAGE_NUM
	&& pinger.getPCAddr() != Pinger.TOS_UART_ADDR) {
      throw new IllegalArgumentException( "must have direct connection to overwrite Golden Image" );
    }

    byte[] tbimageBytes = newTOSBootImage.getBytes();

    this.pinger = pinger;
    this.pingReply = pinger.getPingReply(imageNum);
    this.oldTOSBootImage = pinger.getImage(imageNum);
    this.newTOSBootImage = newTOSBootImage;
    this.delugeImage = new DelugeImage(tbimageBytes, tbimageBytes.length);
    this.moteif = moteif;
    this.verbose = verbose;
    this.force = force;
    
//    if (delugeImage.getNumPages() > 58) {
	if (delugeImage.getNumPages() > 120) {
      //throw new IllegalArgumentException( "tos image is too large" );
	  throw new IllegalArgumentException( "tos image is too large:" + delugeImage.getNumPages() );
    }

    advMsg = (DelugeAdvMsg)pingReply.clone();
    advMsg.set_sourceAddr(pinger.getPCAddr());
    advMsg.set_type(DelugeConsts.DELUGE_ADV_PC);
    advMsg.set_imgDesc_uid(newTOSBootImage.getUIDHash());
    advMsg.set_imgDesc_numPgs(delugeImage.getNumPages());
    advMsg.set_imgDesc_numPgsComplete(delugeImage.getNumPages());

    imageBytes = delugeImage.getBytes();

  }

  public void inject() {

    short newVersion;

    for ( int i = 0; i < pinger.getNumImages() && i < pingReply.get_imgDesc_imgNum(); i++ ) {
      DelugeAdvMsg tmpAdvMsg = pinger.getPingReply(i);
      if (tmpAdvMsg.get_imgDesc_numPgs() != tmpAdvMsg.get_imgDesc_numPgsComplete()) {
	throw new IllegalArgumentException(
          "Image " + i + " is incomplete.\nPlease complete or erase image " + i
	  + " before modifying image " + pingReply.get_imgDesc_imgNum() );
      }
    }

    if (pingReply.get_imgDesc_numPgs() == 0) {
      System.out.println("Replace empty image with:");
      System.out.println("  Image: " + pingReply.get_imgDesc_imgNum());
      System.out.println(newTOSBootImage);
      newVersion = (short)((short)pingReply.get_imgDesc_vNum() + (short)1);
      if (newVersion == DelugeConsts.DELUGE_INVALID_VNUM)
	newVersion = 0;
    }
    else if (pingReply.get_imgDesc_uid() == newTOSBootImage.getUIDHash()) {

      if (pingReply.get_imgDesc_numPgsComplete() == pingReply.get_imgDesc_numPgs()) {
	System.out.println("ERROR: Image already injected:");
	System.out.println("  Image: " + pingReply.get_imgDesc_imgNum());
	System.out.println(oldTOSBootImage);
	return;
      }
      else {
	System.out.println("Resume injection of image:");
	System.out.println("  Image: " + pingReply.get_imgDesc_imgNum());
	System.out.println(newTOSBootImage);
	newVersion = pingReply.get_imgDesc_vNum();
      }

    }
    else {
      System.out.println("Replace image:");
      System.out.println("  Image: " + pingReply.get_imgDesc_imgNum());
      if (oldTOSBootImage != null)
	System.out.println(oldTOSBootImage);
      else
	System.out.println("    No metadata associated with this image.");
      System.out.println("With image:");
      System.out.println("  Image: " + pingReply.get_imgDesc_imgNum());
      System.out.println(newTOSBootImage);
      newVersion = (short)((short)pingReply.get_imgDesc_vNum() + (short)1);
      if (newVersion == DelugeConsts.DELUGE_INVALID_VNUM)
	newVersion = 0;
    }

    if (!newTOSBootImage.getDelugeSupport()) {
      System.out.println();
      System.out.println("--------------------------------------------------");
      System.out.println("| WARNING: New image does not include Deluge.    |");
      System.out.println("|          Network programming will not be       |");
      System.out.println("|          possible when running this app.       |");
      System.out.println("--------------------------------------------------");
      System.out.println();
    }

    if (pingReply.get_imgDesc_imgNum() == DelugeConsts.DELUGE_GOLDEN_IMAGE_NUM
	&& !force ) {
      System.out.println();
      System.out.println("--------------------------------------------------");
      System.out.println("| WARNING: Writing to Golden Image. This         |");
      System.out.println("|          operation is not epidemic and only    |");
      System.out.println("|          affects the directly connected node.  |");
      System.out.println("--------------------------------------------------");
      System.out.println();
    }

    advMsg.set_imgDesc_vNum(newVersion);

    if( !force ) {
      System.out.print("Continue operation? (y/[n]) " );
      BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
      try {
	for (;;) {
	  String ans = in.readLine();
	  ans = ans.toLowerCase();
	  if (ans.equals("") || ans.equals("n") || ans.equals("no")) {
	    throw new IllegalArgumentException("operation cancelled");
	  }
	  if (ans.equals("y") || ans.equals("yes"))
	    break;
	  System.out.print("Please enter yes or no: ");
	}
      } catch (IOException e) {
	e.printStackTrace();
      }
    }

    moteif.registerListener(new DelugeAdvMsg(), this);
    moteif.registerListener(new DelugeReqMsg(), this);
    pageInjector = new PageInjector();
	pageInjector.setNodeId(nodeid);
    pageInjectorThread = new Thread(pageInjector);
    pageInjectorThread.start();

    while(!injectAcked) {
      try {
	advMsg = DelugeCrc.computeAdvCrc(advMsg);
	send(advMsg);
	if (verbose) System.out.print(advMsg);
	Thread.currentThread().sleep(500);
      } catch (Exception e) {
	e.printStackTrace();
      }
    }

  }

  public void setNodeId(int nodeid)
  {
	  this.nodeid = nodeid;
  }
  
  private void send(Message m) {
    try {
      //moteif.send(MoteIF.TOS_BCAST_ADDR, m);
		moteif.send(this.nodeid, m);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  public void messageReceived(int to, Message m) {

    switch(m.amType()) {

    case DelugeAdvMsg.AM_TYPE:

      DelugeAdvMsg rxAdvMsg = (DelugeAdvMsg)m;

      if (verbose) System.out.print(rxAdvMsg);

      if ( rxAdvMsg.get_type() != DelugeConsts.DELUGE_ADV_NORMAL )
	return;

      if (advMsg.get_imgDesc_imgNum() == rxAdvMsg.get_imgDesc_imgNum()
	  && advMsg.get_imgDesc_vNum() == rxAdvMsg.get_imgDesc_vNum()
	  && advMsg.get_imgDesc_numPgs() == rxAdvMsg.get_imgDesc_numPgsComplete()) {
	// ALL DONE, QUIT!
	System.out.println();
	injectAcked = true;
      }

      break;
      
    case DelugeReqMsg.AM_TYPE:

      DelugeReqMsg req = (DelugeReqMsg)m;
      boolean  pktsToSend[] = new boolean[DelugeConsts.DELUGE_PKTS_PER_PAGE];

      if (verbose) System.out.print(req);

      if (advMsg.get_imgDesc_vNum() != req.get_vNum()
	  || advMsg.get_imgDesc_imgNum() != req.get_imgNum())
	return;
      
		int dropcount = 0;
      for ( int i = 0; i < DelugeConsts.DELUGE_PKTS_PER_PAGE; i++ ) 
	  {
		short[] tmp = req.get_requestedPkts();
		if ((tmp[i/8]&(1 << (i%8))) != 0)
	  	{
			pktsToSend[i] = true;
			dropcount++;
			System.out.print("x");	
		} else {
			System.out.print(".");
		}
      }
      System.out.println("Dropped Packets = "+dropcount);
      pageInjector.transmitPage(req.get_pgNum(), pktsToSend);

      break;

    }

  }

  private class PageInjector implements Runnable {

    private boolean pktsToSend[] = new boolean[DelugeConsts.DELUGE_PKTS_PER_PAGE];
    private int     pageToSend = DelugeConsts.DELUGE_INVALID_PGNUM;
    private boolean transmittingPage = false;
    private int     curPkt = 0;
	
	private int nodeid = MoteIF.TOS_BCAST_ADDR;
	
	
    public PageInjector() {

    }

    public boolean isTransmitting() {
      return transmittingPage;
    }

	public void setNodeId(int nodeid)
	{
		this.nodeid = nodeid;
	}
	
    synchronized public void transmitPage(int pgNum, boolean pktsToSend[]) {
      
      if (pgNum > pageToSend)
	return;
      
      if (pgNum < pageToSend) {
	for ( int i = 0; i < this.pktsToSend.length; i++ )
	  this.pktsToSend[i] = false;
	this.pageToSend = pgNum;
	curPkt = 0;
      }
      for ( int i = 0; i < this.pktsToSend.length; i++ )
	this.pktsToSend[i] |= pktsToSend[i];
      
      notifyAll();
      
    }

    private boolean arePacketsToSend() {
      for ( int i = 0; i < DelugeConsts.DELUGE_PKTS_PER_PAGE; i++ ) {
	if (pktsToSend[i])
	  return true;
      }
      return false;
    }
    
    synchronized private void transmitPacket() {
      
      DelugeDataMsg dataMsg = new DelugeDataMsg();
      short packet[] = new short[DelugeConsts.DELUGE_PKT_PAYLOAD_SIZE];
      
      while ( !arePacketsToSend() ) {
	pageToSend = DelugeConsts.DELUGE_INVALID_PGNUM;
	try {
	  transmittingPage = false;
	  wait();
	  transmittingPage = true;
	  System.out.print("\rInjecting page [" + (pageToSend+1) + "] of [" + delugeImage.getNumPages() + "] ...");
	} catch (Exception e) {
	  e.printStackTrace();
	}
      }
      
      dataMsg.set_vNum(advMsg.get_imgDesc_vNum());
      dataMsg.set_imgNum(advMsg.get_imgDesc_imgNum());
      dataMsg.set_pgNum((short)pageToSend);
      
      while (!pktsToSend[curPkt])
	curPkt = (curPkt+1) % DelugeConsts.DELUGE_PKTS_PER_PAGE;
      
      System.arraycopy(imageBytes, pageToSend*(DelugeConsts.DELUGE_PKTS_PER_PAGE*DelugeConsts.DELUGE_PKT_PAYLOAD_SIZE)
		       + curPkt*DelugeConsts.DELUGE_PKT_PAYLOAD_SIZE, 
		       packet, 0,
		       DelugeConsts.DELUGE_PKT_PAYLOAD_SIZE);
      
      dataMsg.set_pktNum((short)curPkt);
      dataMsg.set_data(packet);
      if (verbose) System.out.print(dataMsg);
      send(dataMsg);
      pktsToSend[curPkt] = false;
      curPkt = (curPkt + 1) % DelugeConsts.DELUGE_PKTS_PER_PAGE;
      
    }
    
    synchronized private void send(Message m) {
      try {
		//moteif.send(MoteIF.TOS_BCAST_ADDR, m);
		  moteif.send(this.nodeid, m);
      } catch (Exception e) {
	e.printStackTrace();
      }
    }
    
    public void run() {
      for(;;) {
	try {
	  transmitPacket();
	  Thread.sleep(50);
	  //System.out.print(".");
	} catch (Exception e) {
	  e.printStackTrace();
	}
      }
    }
  }

}
