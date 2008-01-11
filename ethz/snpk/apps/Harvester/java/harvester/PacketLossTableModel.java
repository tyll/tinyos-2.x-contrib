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

import java.util.ArrayList;
import javax.swing.table.AbstractTableModel;

public class PacketLossTableModel extends AbstractTableModel{

	private static final long serialVersionUID = 1L;
	private ArrayList<Integer> motes = new ArrayList<Integer>();
	private ArrayList<Integer> packets = new ArrayList<Integer>();
	private ArrayList<Float> prr = new ArrayList<Float>();
	
	public PacketLossTableModel() {
	}
		
	public String getColumnName(int col) {
		switch(col) {
		case 0:
			return "Mote";
		case 1:
			return "lost";
		case 2:
		default:
			return "PRR";
		}
	}
	
	public int getColumnCount() { return 3; }
	public synchronized int getRowCount() { return motes.size(); }
	
	public synchronized Object getValueAt(int row, int col) {
		switch(col) {
		case 0:
			return motes.get(row);
		case 1:
			return packets.get(row);
		case 2:
		default:
			return prr.get(row);
		}
	}
	
	public void updateMote(int mote, int losts, float prr) {
		int index=motes.indexOf(mote);
		if (index < 0) {
			// add node
			motes.add(mote);
			packets.add(losts);
			this.prr.add(prr);
		}
		else {
			packets.set(index, losts);
			this.prr.set(index, prr);
		}
		fireTableDataChanged();
	}
}
