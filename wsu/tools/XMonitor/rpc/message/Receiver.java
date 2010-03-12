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
/* Authors:  David Gay  <dgay@intel-research.net>
 *           Intel Research Berkeley Lab
 *
 */
/**
 * @author David Gay <dgay@intel-research.net>
 * @author Intel Research Berkeley Lab
 */
package rpc.message;

import rpc.util.*;
import rpc.packet.*;
import java.util.*;
import xml.Parser.XMLMessageParser;
import xml.RemoteObject.StreamDataObject;
import xml.RemoteObject.StreamDataObject;

/**
 * Receiver class (receive tinyos messages).
 *
 * A receiver class provides a simple interface built on Message for
 * receiving tinyos messages from a SerialForwarder
 *
 * @version	1, 15 Jul 2002
 * @author	David Gay
 *
 * Modifiedy by 
 * @author Fenghua Yuan (yuan@vancouver.wsu.edu)
 *
 *
 */
public class Receiver implements rpc.util.PacketListenerIF,
        rpc.packet.PacketListenerIF {

    public static final boolean DEBUG = false;
    public static final boolean DISPLAY_ERROR_MSGS = true;

    //YFH=======================================================
    //YFH: Define type for unknown message
    public static final int ANY_TYPE = -1;
    public static boolean anytype = false;
    //YFH=======================================================
    int groupId;
    Hashtable templateTbl; // Mapping from AM type to msgTemplate
    PhoenixSource source;
    XMLMessageParser xmp;

    public void setXmp(XMLMessageParser xmp) {
        this.xmp = xmp;
    }

    /**
     * Inner class representing a single MessageListener and its
     * associated Message template.
     */
    class msgTemplate {

       
        MessageListener listener;

        //xiaogang
        String typeName;

      

        msgTemplate(String typeName, MessageListener listener) {
            this.typeName = typeName;
            this.listener = listener;
        }

        public boolean equals(Object o) {
            try {
                msgTemplate mt = (msgTemplate) o;
                //xiaogang take place message template with typeName
                if (mt.typeName.getClass().equals(this.typeName.getClass()) &&
                        mt.listener.equals(this.listener)) {
                    return true;
                }
            } catch (Exception e) {
                return false;
            }
            return false;
        }

        public int hashCode() {
            return listener.hashCode();
        }
    }

    /**
     * Create a receiver for messages from forwarder of group id gid and
     * of active message type m.getType()
     * When such a message is received, a new instance of m's class is
     * created with the received data and send to listener.messageReceived
     * @param forwarder packet source to listen to
     * @param gid accept messages with this group id only. If set to
     *        -1, accept all group ID's.
     */
    public Receiver(PhoenixSource forwarder, int gid) {
        this.groupId = gid;
        this.templateTbl = new Hashtable();
        this.source = forwarder;
        forwarder.registerPacketListener(this);
        
    }

    /**
     * Create a receiver messages from forwarder of any group id and
     * of active message type m.getType()
     * When such a message is received, a new instance of m's class is
     * created with the received data and send to listener.messageReceived
     * @param forwarder packet source to listen to
     */
    public Receiver(PhoenixSource forwarder) {
        this(forwarder, MoteIF.ANY_GROUP_ID);
    }

    /**
     * Register a particular listener for a particular message type.
     * More than one listener can be registered for each message type.
     * @param m specify message type and template we're listening for
     * @param listener destination for received messages
     */
    
    /**
     * Register a particular listener for a particular message type.
     * More than one listener can be registered for each message type.
     * @param m specify message type and template we're listening for
     * @param listener destination for received messages
     */
    public void registerListener(String typeName, MessageListener listener) {

        Vector vec = (Vector) templateTbl.get(typeName);
        if (vec == null) {
            vec = new Vector();
        }
        vec.addElement(new msgTemplate(typeName, listener));
        templateTbl.put(typeName, vec);
        System.out.println("register: " + typeName);
    }

    /**
     * Stop listening for messages of the given type with the given listener.
     * @param m specify message type name and template we're listening for
     * @param listener destination for received messages
     */
    
    /**
     * Stop listening for messages of the given type with the given listener.
     * @param m specify message type name and template we're listening for
     * @param listener destination for received messages
     */
    public void deregisterListener(String typeName, MessageListener listener) {

        Vector vec = (Vector) templateTbl.get(typeName);
        if (vec == null) {
            throw new IllegalArgumentException("No listeners registered for message type " + typeName);
        }
        msgTemplate mt = new msgTemplate(typeName, listener);
        // Remove all occurrences
        while (vec.removeElement(mt));
        if (vec.size() == 0) {
            templateTbl.remove(typeName);
        }
    }

    private void error(msgTemplate temp, String msg) {
        //System.err.println("receive error for " + temp.template.getClass().getName() +
        //		   " (AM type " + temp.template.amType() +
        //		   "): " + msg);
        System.err.println("Dropping "  +
                " (AM type "  +
                "): " + msg);
    }

    /**
     * Called when PhoenixSource receives a message
     * Modified by Fenghua Yuan
     */
    public void packetReceived(byte[] packet) {

        if (xmp == null) {

            
        } else {

            // XXX: hack: with the new packetsource format, packet does not
            // contain a crc field, so numElements_data() will be wrong. But we
            // access the data area via dataSet/dataGet, so we're ok.

            //this is where the source comes in to create the correct packet

		
	/*
            Dump.dump("Received message", packet);
         
            String searchName = "general";
            try {
            Vector streamEvent = null;
            //System.out.println("asdf");
            streamEvent = xmp.getValueByName(packet, searchName);
            Iterator it = streamEvent.iterator();
            //System.out.println("streamEvent: "+streamEvent.size()+" "+it.hasNext());
            int count = 0;
            while (it.hasNext()) {
            //System.out.println("ss ");
            StreamDataObject curS = (StreamDataObject) it.next();
            System.out.print(((count++) % streamEvent.size()) + " name: " + curS.name + " size: " + curS.data.size() + " value: ");
            Iterator resIt = curS.data.iterator();
            while (resIt.hasNext()) {
            System.out.print((Integer) resIt.next() + " ");
            }
            System.out.println();
            }
            System.out.println();

            } catch (Exception ex) {
            }
             
	*/
					//System.out.println(xmp.getValue(packet));
	    		Vector<String> vs = xmp.getValue(packet);
					Iterator iit = vs.iterator();
					while(iit.hasNext()){
						String res =(String) iit.next();
						//System.out.println(res);
					}
					//System.out.println("***");

            Set<String> keys = templateTbl.keySet();
            Iterator<String> it = keys.iterator();
            String typeName = null;
            Vector vec = null;
            //System.out.println("keys:"+keys.size());
						boolean recognized = false;
            while (it.hasNext()) {
                typeName = (String) it.next();
								//System.out.println(typeName+it.hasNext());
								if(!typeName.equalsIgnoreCase("rawdata")){
									vec = (Vector) templateTbl.get(typeName);
									if (vec == null) {
										if (DEBUG) {
											Dump.dump("Received packet with type " + typeName + ", but no listeners registered", packet);
										}
										return;    //Should reject the Unknown Messages
									} else {
										int length = packet.length;
										if (length < 0) {
											System.out.println("YFH: In Receiver.java: Unknown message length < 0");
											return;
										}
										Enumeration en = vec.elements();
										Vector streamEvent = null;
										if (en.hasMoreElements()) {
											try {
												streamEvent = getVec(packet,typeName);
												//streamEvent = xmp.getValueByName(packet, typeName);
											} catch (Exception ex) {
												System.err.println("Receiver, streamEvent getVec io error");
											}
										}
										if (streamEvent != null && streamEvent.size() != 0) {
											while (en.hasMoreElements()) {
												recognized = true;
												msgTemplate temp = (msgTemplate) en.nextElement();
												// if(typeName.equalsIgnoreCase("response"))Dump.dump("response raw data", packet);
												temp.listener.messageReceived(typeName, streamEvent);
												//System.out.println(temp.toString());
											}//end of while
										}
									}
								}
						}
						if(recognized == false){
								typeName = "rawdata";
								//System.out.println(typeName+it.hasNext());
								if(typeName.equalsIgnoreCase("rawdata")){
									vec = (Vector) templateTbl.get(typeName);
									if (vec == null) {
										if (DEBUG) {
											Dump.dump("Received packet with type " + typeName + ", but no listeners registered", packet);
										}
										return;    //Should reject the Unknown Messages
									} else {
										int length = packet.length;
										if (length < 0) {
											System.out.println("YFH: In Receiver.java: Unknown message length < 0");
											return;
										}
										Enumeration en = vec.elements();
										Vector streamEvent = null;
										if (en.hasMoreElements()) {
											try {
												streamEvent = getVec(packet,typeName);
												//streamEvent = xmp.getValueByName(packet, typeName);
											} catch (Exception ex) {
												System.err.println("Receiver, streamEvent getVec io error");
											}
										}
										if (streamEvent != null && streamEvent.size() != 0) {
											while (en.hasMoreElements()) {
												recognized = true;
												msgTemplate temp = (msgTemplate) en.nextElement();
												// if(typeName.equalsIgnoreCase("response"))Dump.dump("response raw data", packet);
												temp.listener.messageReceived(typeName, streamEvent);
												//System.out.println(temp.toString());
											}//end of while
										}
									}
								}

							
						
						}



				}

		}

		Vector getVec(byte[] packet,String typeName){
			if(typeName.equalsIgnoreCase("rawdata")){
				Vector v = new Vector();
				for(int i = 0; i < packet.length; i++){
					v.add(packet[i]);
				}
				v.add(0,packet.length);
				return v;
			}
			else{
				return xmp.getValueByName(packet, typeName);

			}
		}
		////////////////  DEPRECATED ROUTINES /////////////////

		// Note: new packet-source does not contain crc (bad packets dropped
		// early on)
		boolean drop_bad_crc = false;

		/**
		 * Create a receiver for messages from forwarder of group id gid and
		 * of active message type m.getType()
		 * When such a message is received, a new instance of m's class is
		 * created with the received data and send to listener.messageReceived
		 * @param forwarder SerialForwarder to listen to
		 * @param gid accept messages with this group id only. If set to
		 *        -1, accept all group ID's.
		 * @param drop_bad_crc Drop messages with a bad CRC field.
		 * @deprecated Use the version which takes a PhoenixSource instead
		 */
		public Receiver(SerialStub forwarder, int gid, boolean drop_bad_crc) {
			this.groupId = gid;
			this.drop_bad_crc = drop_bad_crc;
			this.templateTbl = new Hashtable();
			forwarder.registerPacketListener(this);
		}
}
