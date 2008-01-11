/* Copyright (c) 2007 ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  For additional information see http://www.btnode.ethz.ch/
*
*  $Id$
*  
*/

/**
 * @author Roman Lim
 */

import java.util.Vector;


public class HistoryNode extends TosNode{
	private Vector<Integer> history;
	private int lost=0, total=0, duplicates=0;
	boolean validContent=false;
	private final static int historysize=15;
	
	public HistoryNode(int id) {
		super(id);
		history = new Vector<Integer>(historysize);
	}	
	public void addPacketNr(int sn) {
		if (!validContent) {
			for (int i=0;i<historysize;i++) {
				history.add((sn-i+256) % 256);
			}
			validContent=true;
			total++;
		}
		else {
			int head = history.get(0);
			if ( (head - sn + 256) % 256 < historysize)  {// behind head
				if (history.get((head-sn+256)%256)==sn) {
					//System.out.println("received duplicate from "+super.getNodeId());
					duplicates++;
				}
				else
					total++;
				history.set((head-sn+256)%256, sn);
			}
			else { // before head
				for (int i=0;i<(sn-head+256)%256-1;i++) {
					if (history.get(historysize-1)<0) 
						lost++;
					history.remove(historysize-1);
					history.add(0, -1);
				}
				if (history.get(historysize-1)<0) 
					lost++;
				history.remove(historysize-1);
				history.add(0, sn);
				total++;
			}
			/*// print out history
			Iterator j=history.iterator();
			System.out.print("History");
			while (j.hasNext())
				System.out.print(j.next() + " ");
			System.out.println();
			*/
		}
	}
	
	public int getLostPackets() {
		return lost;		
	}
	
	public float getPRR() {
		return (float)total / (total + lost);		
	}
	
	public int getDuplicateCount() {
		return duplicates;		
	}
	
	public String toString() {
		StringBuffer tmpString = new StringBuffer(30);
		tmpString.append("History: ");
		for (int i=0;i<historysize;i++)
			tmpString.append(history.get(i)+" ");
		return tmpString.toString();
	}
	
	
}
