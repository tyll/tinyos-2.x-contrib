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

public class Eraser implements MessageListener {

  private Pinger pinger;
  private DelugeAdvMsg advMsg;
  private DelugeAdvMsg pingReply;
  private MoteIF  moteif;
  private TOSBootImage oldTOSBootImage;
  private boolean verbose;
  private boolean force = false;
  private boolean injectAcked = false;
  private int nodeid;
  
  public Eraser(Pinger pinger, int imageNum, 
		MoteIF moteif, boolean verbose, boolean force) {

    if (imageNum < 0 || imageNum >= pinger.getNumImages()) {
      throw new IllegalArgumentException( "invalid image number" );
    }

    if (imageNum == DelugeConsts.DELUGE_GOLDEN_IMAGE_NUM
	&& pinger.getPCAddr() != Pinger.TOS_UART_ADDR) {
      throw new IllegalArgumentException( "must have direct connection to erase Golden Image" );
    }

    this.pinger = pinger;
    this.pingReply = pinger.getPingReply(imageNum);
    this.oldTOSBootImage = pinger.getImage(imageNum);
    this.moteif = moteif;
    this.verbose = verbose;
    this.force = force;

    advMsg = (DelugeAdvMsg)pingReply.clone();
    advMsg.set_sourceAddr(pinger.getPCAddr());
    advMsg.set_type(DelugeConsts.DELUGE_ADV_PC);
    advMsg.set_imgDesc_vNum(DelugeConsts.DELUGE_INVALID_VNUM);
    advMsg.set_imgDesc_numPgs((short)0);
    advMsg.set_imgDesc_numPgsComplete((short)0);

  }

  public void reset() {

    if ( advMsg.get_sourceAddr() == MoteIF.TOS_BCAST_ADDR ) {
      throw new IllegalArgumentException(
	"This operation requires a direct connection to the node." );
    }

    System.out.println("Reset image:");
    System.out.println("  Image: " + pingReply.get_imgDesc_imgNum());
    if (oldTOSBootImage != null) {
      System.out.println(oldTOSBootImage);
    }
    else {
      System.out.println("    No metadata associated with this image.");
    }

    if( !force )
    {
      System.out.println();
      System.out.println("--------------------------------------------------");
      System.out.println("| WARNING: This operation resets the versioning  |");
      System.out.println("|          info for this image. This operation   |");
      System.out.println("|          is not epidemic and only affects the  |");
      System.out.println("|          currently connected node.             |");
      System.out.println("--------------------------------------------------");
      System.out.println();

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

    advMsg.set_type(DelugeConsts.DELUGE_ADV_RESET);
    advMsg.set_imgDesc_vNum(DelugeConsts.DELUGE_INVALID_VNUM);

    moteif.registerListener(new DelugeAdvMsg(), this);

    while(!injectAcked) {
      try {
	advMsg = DelugeCrc.computeAdvCrc(advMsg);
	send(advMsg);
	if (verbose) System.out.print(advMsg);
	Thread.currentThread().sleep(1000);
      } catch (Exception e) {
	e.printStackTrace();
      }
    }    
  }

  public void erase() {

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
      System.out.println("ERROR: Image already erased.");
      return;
    }
    else {
      System.out.println("Erase image:");
      System.out.println("  Image: " + pingReply.get_imgDesc_imgNum());
      if (oldTOSBootImage != null) {
	System.out.println(oldTOSBootImage);
      }
      else {
	System.out.println("    No metadata associated with this image.");
      }
      newVersion = (short)((short)pingReply.get_imgDesc_vNum() + (short)1);
      if (newVersion == DelugeConsts.DELUGE_INVALID_VNUM)
	newVersion = 0;

      if (pingReply.get_imgDesc_imgNum() == DelugeConsts.DELUGE_GOLDEN_IMAGE_NUM
	  && !force ) {
	System.out.println();
	System.out.println("--------------------------------------------------");
	System.out.println("| WARNING: Erasing Golden Image. This operation  |");
	System.out.println("|          is not epidemic and only affects the  |");
	System.out.println("|          directly connected node.              |");
	System.out.println("--------------------------------------------------");
	System.out.println();
      }

    }

    if( !force )
    {
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

    advMsg.set_imgDesc_vNum(newVersion);

    moteif.registerListener(new DelugeAdvMsg(), this);

    while(!injectAcked) {
      try {
	advMsg = DelugeCrc.computeAdvCrc(advMsg);
	send(advMsg);
	if (verbose) System.out.print(advMsg);
	Thread.currentThread().sleep(1000);
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

      if (advMsg.get_imgDesc_vNum() == rxAdvMsg.get_imgDesc_vNum()
	  && advMsg.get_imgDesc_numPgs() == rxAdvMsg.get_imgDesc_numPgsComplete()) {
	// ALL DONE, QUIT!
	injectAcked = true;
      }

      break;
      
    }

  }

}
