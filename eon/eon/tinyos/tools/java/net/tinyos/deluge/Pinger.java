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

import java.util.*;

public class Pinger implements MessageListener {

	public  static final short TOS_UART_ADDR = 0x007e;
	private static final int STRING_SIZE = 16;
	private static final int MAX_ATTEMPTS = 3;
	
	private static final int START_PKT = DelugeConsts.DELUGE_CRC_BLOCK_SIZE/DelugeConsts.DELUGE_PKT_PAYLOAD_SIZE;
	// ONE PACKET WORTH OF DATA ARE RESERVED BUT UNUSED
	// IF MORE IDENT DATA IS REQUIRED, REMOVE SUBTRACTION ON END POINT
	private static final int END_PKT = DelugeConsts.DELUGE_IDENT_SIZE/DelugeConsts.DELUGE_PKT_PAYLOAD_SIZE - 1;
	
	private MoteIF moteif;
	private boolean verbose;
	private short curImage = -1;
	
	private DelugeAdvMsg advMsg = new DelugeAdvMsg();
	private NetProgMsg netProgMsg = new NetProgMsg();
	
	private Hashtable pingReplies = new Hashtable();
	private Hashtable images = new Hashtable();
	
	private short pcAddr = 0x7e;
	
	private short pktsToReceive[] = new short[DelugeReqMsg.totalSize_requestedPkts()];
	private short imageData[] = new short[DelugeConsts.DELUGE_PKTS_PER_PAGE*DelugeConsts.DELUGE_PKT_PAYLOAD_SIZE];
	private int pktsReceived = 0;
	
	private boolean resolvedNodeType = false;
	private int numImages = -1;
	
	private boolean pingComplete = false;
	private boolean receivedExecutingIdent = false;
	private boolean requesting = false;
	private int dest = MoteIF.TOS_BCAST_ADDR;
	private boolean skipNextAdv = false;
	private int attempts = 0;
	
	private String execProgName = "";
	private long execUnixTime = 0;
	private long execUserHash = 0;
	
	private String identString = "";
	private boolean error = false;
	
	private int unicast = MoteIF.TOS_BCAST_ADDR;

	public Pinger(MoteIF moteif, boolean verbose, int dest) {
		this.moteif = moteif;
		this.verbose = verbose;
		this.dest = dest;
		this.unicast = dest;
		this.moteif.registerListener(new DelugeAdvMsg(), this);
		this.moteif.registerListener(new DelugeDataMsg(), this);
		this.moteif.registerListener(new NetProgMsg(), this);
	}

	public void ping() {

		advMsg.set_sourceAddr(pcAddr);
		advMsg.set_version(DelugeConsts.DELUGE_VERSION);
		advMsg.set_type((short)DelugeConsts.DELUGE_ADV_PING);
		advMsg.set_nodeDesc_vNum((short)DelugeConsts.DELUGE_INVALID_VNUM);
		advMsg.set_imgDesc_vNum(DelugeConsts.DELUGE_INVALID_VNUM);

		if ( dest == MoteIF.TOS_BCAST_ADDR )
			System.out.println("Pinging node ...");
		else
			System.out.println("Pinging node " + dest + " ...");

    // get executing image
		for (;;) 
		{
			try 
			{
				if (receivedExecutingIdent)
					break;

				netProgMsg.set_sourceAddr(pcAddr);
				send(netProgMsg);
				if (verbose) System.out.print(netProgMsg);
	
				if (!resolvedNodeType) 
				{
					if (pcAddr == (short)MoteIF.TOS_BCAST_ADDR)
						pcAddr = TOS_UART_ADDR;
					else
					{
	    //pcAddr = (short)MoteIF.TOS_BCAST_ADDR;
						pcAddr = (short)0x01;
					}
				}

				Thread.currentThread().sleep(500);
			} 
			catch (Exception e) 
			{	
				e.printStackTrace();
			}
		}

		setupNewImage();

    // get deluge image info
		for (;;) {
			try {
				attempts++;
				if ( attempts > MAX_ATTEMPTS ) {
					attempts = 0;
					dest = MoteIF.TOS_BCAST_ADDR;
				}

				if ( ( curImage >= numImages && numImages != -1) )
					break;

				advMsg.set_sourceAddr(pcAddr);
				advMsg.set_imgDesc_imgNum(curImage);
				advMsg = DelugeCrc.computeAdvCrc(advMsg);
				requesting = false;
				if (!skipNextAdv) send(advMsg);

				skipNextAdv = false;

				if (verbose) System.out.print(advMsg);

				if (!resolvedNodeType) {
					if (pcAddr == (short)MoteIF.TOS_BCAST_ADDR)
						pcAddr = TOS_UART_ADDR;
					else
					{
						pcAddr = (short)0x01;
						//pcAddr = (short)MoteIF.TOS_BCAST_ADDR;
					}
				}

				Thread.currentThread().sleep(500);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		moteif.deregisterListener(new DelugeAdvMsg(), this);
		moteif.deregisterListener(new DelugeDataMsg(), this);
		moteif.deregisterListener(new NetProgMsg(), this);

	}

	public boolean existsError() {
		return error;
	}

	public DelugeAdvMsg getPingReply(int imageNum) {
		return (DelugeAdvMsg)pingReplies.get(new Integer(imageNum));
	}

	public TOSBootImage getImage(int imageNum) {
		return (TOSBootImage)images.get(new Integer(imageNum));
	}

	public short getPCAddr() {
		return pcAddr;
	}

	public int getNumImages() { 
		return numImages; 
	}

	private void send(Message m) {
    
		int addr;

		try {
			addr = ( unicast != MoteIF.TOS_BCAST_ADDR ) ? unicast : dest;
			moteif.send(addr, m);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private void setupNewImage() {
		for ( int i = START_PKT; i < START_PKT+END_PKT; i++ )
			pktsToReceive[i/8] |= (0x1 << (i%8));
		pktsReceived = 0;
		curImage++;
		System.out.print( "\r                                                      ");
		System.out.print( "\rGetting data for image [" + curImage + "] " );
		skipNextAdv = true;
		if ( curImage < numImages || numImages == -1 ) {
			advMsg.set_sourceAddr(pcAddr);
			advMsg.set_imgDesc_imgNum(curImage);
			advMsg = DelugeCrc.computeAdvCrc(advMsg);
			send(advMsg);
		}
		if (verbose) System.out.print(advMsg);
	}

	public String getExecName() {
		return execProgName;
	}

	public long getExecUnixTime() {
		return execUnixTime;
	}
  
	public long getExecUserHash() {
		return execUserHash;
	}

	public String getExecutingIdent() {
		Date date = new Date(netProgMsg.get_ident_unix_time()*1000);
		return "    Prog Name:   " + execProgName + "\n" +
				"    Compiled On: " + date + "\n" +
				"    User Hash:   0x" + Long.toHexString(execUserHash);
	}

	public void messageReceived(int toAddr, Message m) {

    // figure out what type of node we're connected to
		if (!resolvedNodeType) {
			if (toAddr != TOS_UART_ADDR) {
				//pcAddr = (short)MoteIF.TOS_BCAST_ADDR;
				pcAddr = (short)0x01;
				resolvedNodeType = true;
				System.out.println("Connected to TOSBase node.");
			}
			else if (toAddr == TOS_UART_ADDR) {
				pcAddr = TOS_UART_ADDR;
				resolvedNodeType = true;
				System.out.println("Connected to Deluge node.");
			}
		}

		switch(m.amType()) {

			case NetProgMsg.AM_TYPE:

				netProgMsg = (NetProgMsg)m;

				if (verbose) System.out.print(netProgMsg);

				if ( netProgMsg.get_sourceAddr() == MoteIF.TOS_BCAST_ADDR ||
								 netProgMsg.get_sourceAddr() == TOS_UART_ADDR )
					return;

      // extract ident information
				{
					byte tmpBytes[] = new byte[STRING_SIZE];
					for ( int i = 0; i < STRING_SIZE; i++ )
						tmpBytes[i] = (byte)(netProgMsg.getElement_ident_program_name(i) & 0xff);

					String name = new String(tmpBytes);
					if (name.indexOf('\0') != -1)
						name = name.substring(0, name.indexOf('\0'));

					execProgName = name;
					execUnixTime = netProgMsg.get_ident_unix_time();
					execUserHash = netProgMsg.get_ident_user_hash();

					receivedExecutingIdent = true;
				}

				break;

			case DelugeAdvMsg.AM_TYPE:

				DelugeAdvMsg pingReply = (DelugeAdvMsg)m;
				int imgNum = pingReply.get_imgDesc_imgNum();

				if (verbose) System.out.print(pingReply);

				if ( pingReply.get_type() == DelugeConsts.DELUGE_ADV_ERROR )
					error = true;

				if (dest == MoteIF.TOS_BCAST_ADDR)
					dest = pingReply.get_sourceAddr();

				if ( pingReply.get_type() != DelugeConsts.DELUGE_ADV_NORMAL )
					return;

				if (numImages == -1 || pingReply.get_numImages() > numImages) {
					numImages = pingReply.get_numImages();
					dest = pingReply.get_sourceAddr();
				}

				if (dest != pingReply.get_sourceAddr())
					return;

				if (pingReplies.get(new Integer(imgNum)) == null) {
					pingReplies.put(new Integer(imgNum), pingReply);
				}
				if (curImage == imgNum) {
					if (pingReply.get_imgDesc_numPgsComplete() == 0) {
						setupNewImage();
						return;
					}

					DelugeReqMsg reqMsg = new DelugeReqMsg();
					reqMsg.set_sourceAddr(pcAddr);
					reqMsg.set_dest(pingReply.get_sourceAddr());
					reqMsg.set_vNum(pingReply.get_imgDesc_vNum());
					reqMsg.set_imgNum(pingReply.get_imgDesc_imgNum());
					reqMsg.set_pgNum((short)0);
					reqMsg.set_requestedPkts(pktsToReceive);
					if (verbose) System.out.print(reqMsg);
					send(reqMsg);
				}

				break;

			case DelugeDataMsg.AM_TYPE:

				DelugeDataMsg dataMsg = (DelugeDataMsg)m;
				short pktNum = dataMsg.get_pktNum();

				if (verbose) System.out.print(dataMsg);

				pingReply = (DelugeAdvMsg)pingReplies.get(new Integer(curImage));

				if (pingReply == null
								|| dataMsg.get_vNum() != pingReply.get_imgDesc_vNum()
								|| dataMsg.get_imgNum() != curImage
								|| dataMsg.get_pgNum() != 0
								|| dataMsg.get_pktNum() >= DelugeConsts.DELUGE_PKTS_PER_PAGE)
					return;

				if ((pktsToReceive[pktNum/8] & (0x1 << (pktNum%8))) != 0) {

					pktsToReceive[pktNum/8] &= ~(0x1 << (pktNum%8));
					System.arraycopy(dataMsg.get_data(), 0, imageData, 
									 pktNum*DelugeConsts.DELUGE_PKT_PAYLOAD_SIZE, 
									 DelugeConsts.DELUGE_PKT_PAYLOAD_SIZE);
					System.out.print( "." );
					pktsReceived++;

					if (pktsReceived >= END_PKT) {
						byte[] bytes = new byte[TOSBootImage.METADATA_SIZE];
						for ( int i = 0; i < bytes.length; i++ )
							bytes[i] = (byte)(imageData[i+256] & 0xff);

						images.put(new Integer(curImage), new TOSBootImage(bytes));

						setupNewImage();
					}

				}

				break;

		}


	}

}
