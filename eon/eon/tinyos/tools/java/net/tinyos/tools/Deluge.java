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

package net.tinyos.tools;

import net.tinyos.deluge.*;
import net.tinyos.message.*;
import net.tinyos.util.*;

import java.io.*; 
import java.util.*;
import java.text.*;

public class Deluge {

  private static final int S_NONE = 0;
  private static final int S_PING = 1;
  private static final int S_INJECT = 2;
  private static final int S_REBOOT = 3;
  private static final int S_ERASE = 4;
  private static final int S_RESET = 5;
  private static final int S_DUMP = 6;

  private int mode = S_NONE;
  private int imageNum = -1;
  private int nodeid = MoteIF.TOS_BCAST_ADDR;
  private boolean verbose = false;
  private String infile = "";
  private String outfile = "";
  private boolean force = false;

  private MoteIF moteif;

  private void usage() {
    throw new IllegalArgumentException( getUsage() );
  }

  public String getUsage() {
    return
      "usage: java net.tinyos.tools.Deluge <action> [options]\n"
    + "  actions are:\n"
    + "   -p,  --ping            : ping status of node\n"
    + "   -i,  --inject          : inject a binary\n"
    + "   -r,  --reboot          : send reboot command\n"
    + "   -e,  --erase           : erase a binary\n"
    + "   -x,  --reset           : reset image\n"
    + "   -d,  --dump            : dumps data injected to node\n"
    + "  options are:\n"
    + "   -id, --nodeid=<num>    : node id\n"
    + "   -ti, --tosimage=<xml>  : tos_image.xml file (program images)\n"
    + "   -in, --imgnum=<num>    : image num\n"
    + "   -o,  --outfile=<xml>   : output file for dump\n"
    + "   -f,  --force           : force the operation, do not ask y/n\n"
    + "   -v,  --verbose         : print all sent/received msgs\n"
    + "   -h,  --help            : print this message\n"
    ;
  }

  private void init( String args[] ) {

    int modeCount = 0;

    if (args.length == 0)
      usage();
    
    for ( int i = 0; i < args.length; i++ ) {
      if (args[i].equals("-p") || args[i].equals("--ping")) {
	mode = S_PING;
	modeCount++;
      }
      else if (args[i].equals("-i") || args[i].equals("--inject")) {
	mode = S_INJECT;
	modeCount++;
      }
      else if (args[i].equals("-r") || args[i].equals("--reboot")) {
	mode = S_REBOOT;
	modeCount++;
      }
      else if (args[i].equals("-e") || args[i].equals("--erase")) {
	mode = S_ERASE;
	modeCount++;
      }
      else if (args[i].equals("-x") || args[i].equals("--reset")) {
	mode = S_RESET;
	modeCount++;
      }
      else if (args[i].equals("-d") || args[i].equals("--dump")) {
	mode = S_DUMP;
	modeCount++;
      }
      else if (args[i].length() > 3 && args[i].substring(0,4).equals("-id=")) {
	nodeid = Integer.parseInt( args[i].substring(4,args[i].length()) );
      }
      else if (args[i].length() > 8 && args[i].substring(0,9).equals("--nodeid=")) {
	nodeid = Integer.parseInt( args[i].substring(9,args[i].length()) );
      }      
      else if (args[i].length() > 3 && args[i].substring(0,4).equals("-ti=")) {
	infile = args[i].substring(4,args[i].length());	
      }
      else if (args[i].length() > 10 && args[i].substring(0,11).equals("--tosimage=")) {
	infile = args[i].substring(11,args[i].length());
      }
      else if (args[i].length() > 3 && args[i].substring(0,4).equals("-in=")) {
	imageNum = Short.parseShort(args[i].substring(4,args[i].length()));
      }
      else if (args[i].length() > 8 && args[i].substring(0,9).equals("--imgnum=")) {
	imageNum = Short.parseShort(args[i].substring(9,args[i].length()));
      }
      else if (args[i].length() > 2 && args[i].substring(0,3).equals("-o=")) {
	outfile = args[i].substring(3,args[i].length());
      }
      else if (args[i].length() > 9 && args[i].substring(0,10).equals("--outfile=")) {
	outfile = args[i].substring(10,args[i].length());
      }
      else if (args[i].equals("-f") || args[i].equals("--force")) {
	force = true;
      }
      else if (args[i].equals("-v") || args[i].equals("--verbose")) {
	verbose = true;
      }
      else if (args[i].equals("-h") || args[i].equals("--help"))
	usage();
      else {
	usage();
      }
    }

    if (modeCount > 1) {
      throw new IllegalArgumentException( "only one action may be specified" );
    }
  }

  public Deluge( String[] args ) {
    init( args );

    try {
      moteif = new MoteIF((Messenger)null);
    } catch (Exception e) {
      e.printStackTrace();
    }

    moteif.start();
  }

  public Deluge( MoteIF moteif, String[] args ) {
    try {
      init( args );
      this.moteif = moteif;
      execute();
    } catch( IllegalArgumentException e ) {
      System.err.println("Error: "+e.getMessage());
    }
  }

  private void execute() {

    Pinger pinger = null;
    
    pinger = new Pinger(moteif, verbose, nodeid);
    pinger.ping();

    System.out.println("--------------------------------------------------");

    switch(mode) {

    case S_PING:

      if (pinger.existsError())
	System.out.println( "Warning: Deluge is not running on one or more nodes." );

      System.out.println("  Currently Executing:");
      System.out.println(pinger.getExecutingIdent());

      for ( int i = 0; i < pinger.getNumImages(); i++ ) {

	if ( imageNum != -1 && imageNum != i )
	  continue;

	if (i == 0)
	  System.out.println("  Stored Image 0 - (Golden Image)");
	else
	  System.out.println("  Stored Image " + i);

	TOSBootImage image = pinger.getImage(i);

	if (pinger.getPingReply(i).get_imgDesc_numPgsComplete() > 0
	    && ( pinger.getPingReply(i).get_imgDesc_vNum() != DelugeConsts.DELUGE_INVALID_VNUM) ) {
	  System.out.println(image);
	  System.out.println("    Num Pages:   " +
			     pinger.getPingReply(i).get_imgDesc_numPgsComplete() +
			     "/" +
			     pinger.getPingReply(i).get_imgDesc_numPgs());
	}
	else if (pinger.getPingReply(i).get_imgDesc_numPgsComplete() == 0
		 && pinger.getPingReply(i).get_imgDesc_numPgs() > 0) {
	  System.out.println("    Prog Name:   <unavailable>");
	  System.out.println("    Compiled On: <unavailable>");
	  System.out.println("    Platform:    <unavailable>");
	  System.out.println("    User ID:     <unavailable>");
	  System.out.println("    Hostname:    <unavailable>");
	  System.out.println("    User Hash:   <unavailable>");
	  System.out.println("    Num Pages:   " +
			     pinger.getPingReply(i).get_imgDesc_numPgsComplete() +
			     "/" +
			     pinger.getPingReply(i).get_imgDesc_numPgs());
	}
	else {
	  System.out.println("    Prog Name:   N/A");
	  System.out.println("    Compiled On: N/A");
	  System.out.println("    Platform:    N/A");
	  System.out.println("    User ID:     N/A");
	  System.out.println("    Hostname:    N/A");
	  System.out.println("    User Hash:   N/A");
	  System.out.println("    Num Pages:   N/A");
	}
      }

      break;

    case S_DUMP:

      if (pinger.existsError())
	System.out.println( "Warning: Deluge is not running on one or more nodes." );

      Downloader downloader = new Downloader(pinger, imageNum, moteif, verbose, outfile);
      
      downloader.extract();

      break;

    case S_INJECT:

      if (pinger.existsError())
	System.out.println( "Warning: Deluge is not running on one or more nodes." );

      TOSBootImage newImage = new TOSBootImage(infile);

      System.out.println("--------------------------------------------------");

      ImageInjector injector = new ImageInjector(pinger, imageNum, newImage,
						 moteif, verbose, force);
	  injector.setNodeId(nodeid);
      injector.inject();
      
      break;
      
    case S_ERASE:

      if (pinger.existsError())
	System.out.println( "Warning: Deluge is not running on one or more nodes." );

      
	  Eraser eraser = new Eraser(pinger, imageNum, moteif, verbose, force);
	  eraser.setNodeId(nodeid);
      eraser.erase();

      break;

    case S_RESET:

      if (pinger.existsError())
	System.out.println( "Warning: Deluge is not running on one or more nodes." );

      Eraser resetter = new Eraser(pinger, imageNum, moteif, verbose, force);

      resetter.reset();

      break;

    case S_REBOOT:

      if (pinger.existsError())
	System.out.println( "Warning: Deluge is not running on one or more nodes." ); 

      Rebooter rebooter = new Rebooter(pinger, imageNum, moteif, verbose, force);
	  rebooter.setNodeId(nodeid);	
      rebooter.reboot();

      break;

    default:
      throw new IllegalArgumentException( "unknown mode" );

    }

    System.out.println("--------------------------------------------------");

    System.out.println("DONE!");

  }

  public static void main(String[] args) {
    Deluge deluge = null;
    try {
      deluge = new Deluge(args);
      deluge.execute();
    } catch( IllegalArgumentException e ) {
      if( e.getMessage().startsWith("usage:") ) {
	System.out.println( e.getMessage() );
      } else {
	System.err.println( "Error: "+e.getMessage() );
	System.exit(1);
      }
    }
    System.exit(0);
  }
}

