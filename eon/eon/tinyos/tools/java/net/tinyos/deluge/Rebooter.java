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
import net.tinyos.util.*;

import java.io.*;
import java.util.*;

public class Rebooter implements MessageListener {

  private MoteIF moteif;
  private boolean verbose;
  private DelugeAdvMsg pingReply;
  private TOSBootImage newImage;
  private short pcAddr;
  private short newVersion;
  private boolean rebootAcked = false;
  private Pinger pinger;
  private boolean force;
  private int nodeid = MoteIF.TOS_BCAST_ADDR;
  
  private DelugeAdvMsg advMsg = new DelugeAdvMsg();

  public Rebooter(Pinger pinger, int imageNum, MoteIF moteif, boolean verbose, boolean force) {

    if (imageNum < 0 || imageNum >= pinger.getNumImages()) {
      throw new IllegalArgumentException( "invalid image number" );
    }

    this.pinger = pinger;
    this.pingReply = pinger.getPingReply(imageNum);
    this.newImage = pinger.getImage(imageNum);
    this.pcAddr = pinger.getPCAddr();
    this.moteif = moteif;
    this.verbose = verbose;
    this.force = force;
    this.moteif.registerListener(new DelugeAdvMsg(), this);
    
    newVersion = (short)((short)pingReply.get_nodeDesc_vNum() + (short)1);
    if (newVersion == DelugeConsts.DELUGE_INVALID_VNUM)
      newVersion = 0;

  }

  public void reboot() {

    if (pingReply.get_imgDesc_imgNum() != 0) {
      if (pingReply.get_imgDesc_numPgs() != pingReply.get_imgDesc_numPgsComplete()) {
	throw new IllegalArgumentException( "cannot reboot to an incomplete image" );
      }
      else if (pingReply.get_imgDesc_numPgs() == 0) {
	throw new IllegalArgumentException( "cannot reboot to an empty image" );
      }
    }

    System.out.println("  Reboot From Image:");

    System.out.println(pinger.getExecutingIdent());

    TOSBootImage image = newImage;
    System.out.println("  To Image: " + pingReply.get_imgDesc_imgNum());
      
      /*
	if ( pinger.getExecName().compareTo( newImage.getName() ) == 0 &&
	pinger.getExecUnixTime() == newImage.getUnixTime() &&
	pinger.getExecUserHash() == newImage.getUserHash() )
	throw new IllegalArgumentException( "already executing image" );
      */

    if ( pingReply.get_imgDesc_numPgs() != 0 ) {
      System.out.println(image);
    }
    else if ( pingReply.get_imgDesc_imgNum() == 0 ) {
      System.out.println("    Golden Image.");
      System.out.println();
      System.out.println("--------------------------------------------------");
      System.out.println("| WARNING: No info for Golden Image is available |");
      System.out.println("|          but reboot attempts to this image are |");
      System.out.println("|          allowed. If no such image exists,     |");
      System.out.println("|          no reprogramming will occur.          |");
      System.out.println("--------------------------------------------------");
      System.out.println();
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
	    throw new IllegalArgumentException( "operation cancelled" );
	  }
	  if (ans.equals("y") || ans.equals("yes"))
	    break;
	  System.out.print("Please enter yes or no: ");
	}
      } catch (IOException e) {
	e.printStackTrace();
      }
    }

    advMsg.set_sourceAddr(pcAddr);
    advMsg.set_version(DelugeConsts.DELUGE_VERSION);
    advMsg.set_type((short)DelugeConsts.DELUGE_ADV_PC);
    advMsg.set_nodeDesc_vNum(newVersion);
    advMsg.set_nodeDesc_uid(pingReply.get_imgDesc_uid());
    advMsg.set_nodeDesc_imgNum(pingReply.get_imgDesc_imgNum());
    advMsg.set_imgDesc_vNum(DelugeConsts.DELUGE_INVALID_VNUM);
    advMsg.set_imgDesc_imgNum(pingReply.get_imgDesc_imgNum());

    System.out.println("Sending reboot message ...");

    while(!rebootAcked) {
      try {
	advMsg = DelugeCrc.computeAdvCrc(advMsg);
	send(advMsg);
	if (verbose) System.out.print(advMsg);
	if (advMsg.get_type() == DelugeConsts.DELUGE_ADV_PC)
	  advMsg.set_type(DelugeConsts.DELUGE_ADV_PING);
	else
	  advMsg.set_type(DelugeConsts.DELUGE_ADV_PC);
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
      moteif.send(nodeid, m);
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
      
      if (newVersion == rxAdvMsg.get_nodeDesc_vNum()
	  && !rebootAcked) {
	System.out.println("Reboot message sent.");	  
	rebootAcked = true;
      }
      
      break;

    }
    
  }

}
