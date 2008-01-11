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

import edu.uci.ics.jung.graph.impl.DirectedSparseVertex;

public class TosNode extends DirectedSparseVertex {
	int nodeId;
	private int parentId, numNeighbours, neighbourId[], neighbourEtx[];
	long lastSeen;
	
	public TosNode(int id) {
		this.nodeId = id;
		this.lastSeen=System.currentTimeMillis();
	}
	
	public int getNodeId() {
		return nodeId;
	}
	
	public long getLastSeen() {
		return lastSeen;
	}
	
	public void touch() {
		lastSeen=System.currentTimeMillis();
	}
	
	public int getParentId() {
		return parentId;
	}
	
	public void setParentId(int id) {
		parentId = id;
	}
	
	public void clearNeighbours() {
		numNeighbours=0;
	}
	
	public void addNeighbour(int id, int etx) {
		neighbourId[numNeighbours]=id;
		neighbourEtx[numNeighbours]=etx;
		numNeighbours++;
	}
	
	public int getNeighbourId(int index) {
		return neighbourId[index];
	}
	
	public int getNeighbourEtx(int index) {
		return neighbourEtx[index];
	}
}
