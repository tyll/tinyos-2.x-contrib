// $Id$

/*									tab:4
 * Copyright (c) 2007 University College Dublin.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice and the following
 * two paragraphs appear in all copies of this software.
 *
 * IN NO EVENT SHALL UNIVERSITY COLLEGE DUBLIN BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF
 * UNIVERSITY COLLEGE DUBLIN HAS BEEN ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * UNIVERSITY COLLEGE DUBLIN SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND UNIVERSITY COLLEGE DUBLIN HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS.
 *
 * Authors:	Raja Jurdak, Antonio Ruzzelli, and Samuel Boivineau
 * Date created: 2007/09/07
 *
 */

/**
 * @author Raja Jurdak, Antonio Ruzzelli, and Samuel Boivineau
 */


import java.util.ArrayList;
import java.util.Iterator;
import net.tinyos.message.MoteIF;

/*
	This class is a Database that stores all the motes
	from which we have received a message.

	TODO :
			support of the delete feature
*/

public class MoteDatabase {
	private ArrayList moteNetwork;
	private boolean mutexFree;
	private ConsolePanel consolePanel;
	boolean active;
	int maxID;
	int newNode;
	int indNew;
	ArrayList<Integer>ids;
	

	public MoteDatabase(ConsolePanel consolePanel) {
		this.consolePanel = consolePanel;
		moteNetwork = new ArrayList();
		ids=new ArrayList<Integer>();
		mutexFree = true;
		active =false;
	}

	/*
		This method adds a mote to the database.
	*/
	public synchronized void addMote(Mote m,MsgSender ms) {
		if(moteNetwork.contains(m)) {
			Util.debug("[addMote] mote " + m.toString() + " ever in the DB");
			return;
		}
		moteNetwork.ensureCapacity(moteNetwork.size()+1);
		moteNetwork.add(m);
		consolePanel.append("Mote Id=["+m.getMoteId()+"]", Util.MSG_MOTE_ADDED);
		int id=m.getMoteId();
		if(id>maxID){
			maxID=id;
			maxVal=true;
			if(active&&!maxWait){
				maxWait=true;
				new MaxThread(this,ms).start();
			}
		}
		else if(active){
			if(!ids.contains(id)){
			ids.add(id);
			newNode++;
			indNew=id;
			if(!maxWait){
				maxWait=true;
				new MaxThread(this,ms).start();
				
			}
			}
		}else{
			
			if(!ids.contains(id))ids.add(id);
		}
		

	}
	boolean maxVal,maxWait;
	
	public void send(MsgSender ms){
		maxWait=false;
		if(maxVal){
			maxVal=false;
			newNode=0;
			sendM(ms);
		}else{
			if(newNode>1){
				sendM(ms);
			}else if(newNode==1){
				// Unicast send
				ms.add(indNew,Constants.MAX_ID,maxID,"Sending Maximum ID");
				
			}
			newNode=0;
		}
	}
	private void sendM(MsgSender ms){
		
		ms.add(MoteIF.TOS_BCAST_ADDR,Constants.MAX_ID,maxID,"Sending Maximum ID");
	}
	public synchronized void sendMax(MsgSender ms){
		active=true;
		sendM(ms);
	}

	/*
		This method deletes a mote from the database.
	*/
	public synchronized void deleteMote(Mote m) {
		if(moteNetwork.contains(m)) {
			moteNetwork.remove(m);
			moteNetwork.trimToSize();
		} else
			Util.debug("[deleteMote] Mote to delete not found");
	}

	/*
		This method returns a mote, by taking in argument
		the ID of this mote, or null if the mote is not found.
	*/

	public synchronized Mote getMote(int moteId) {
		Mote tmp;
		for (Iterator it=moteNetwork.iterator(); it.hasNext(); ) {
			tmp = (Mote)it.next();
			if(tmp.getMoteId() == moteId)
				return tmp;
		}
		return null;
	}

	public Iterator getIterator() {
		return moteNetwork.iterator();
	}

	/*
		These both functions lets someone ask for a mutex
		on the database. If no mutex is available, getMutex()
		returns false, without waiting.
	*/

	public void releaseMutex() {
		mutexFree = true;
	}

	public boolean getMutex() {
		if(mutexFree) {
			mutexFree = false;
			return true;
		} else
			return false;
	}
}
