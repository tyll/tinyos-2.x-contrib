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

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.TimeZone;
import java.util.Vector;

import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.Timer;

import net.tinyos.message.Message;
import net.tinyos.message.MessageListener;
import net.tinyos.message.MoteIF;
import net.tinyos.packet.BuildSource;
import net.tinyos.packet.PhoenixSource;
import net.tinyos.util.PrintStreamMessenger;
import edu.uci.ics.jung.graph.DirectedEdge;
import edu.uci.ics.jung.graph.Graph;
import edu.uci.ics.jung.graph.decorators.StringLabeller;
import edu.uci.ics.jung.graph.decorators.StringLabeller.UniqueLabelException;
import edu.uci.ics.jung.graph.impl.DirectedSparseEdge;
import edu.uci.ics.jung.graph.impl.DirectedSparseVertex;
import edu.uci.ics.jung.graph.impl.SparseGraph;
import edu.uci.ics.jung.visualization.FRLayout;
import edu.uci.ics.jung.visualization.Layout;
import edu.uci.ics.jung.visualization.LayoutMutable;
import edu.uci.ics.jung.visualization.PluggableRenderer;
import edu.uci.ics.jung.visualization.VisualizationViewer;

public class HarvesterMonitor implements MessageListener, ActionListener, WindowListener
{
	
	public static void main(String[] args) {
    	if (args.length==0) {
    		System.err.println("specify at least one basestation, e.g. serial@/dev/ttyUSB6:tmote");
    		System.exit(1);
    	}
    	HarvesterMonitor me = new HarvesterMonitor();
    	for (int i=0;i<args.length;i++) {
    		System.out.println("add basestation "+args[i]);
    		me.addBasestation(args[i]);
    	}
    	me.run();
    }
	
	Vector<String> basestations;
	Vector<MoteIF> motes;
    
    JFrame graphFrame = new JFrame();
    Vector<HistoryNode> nodes = new Vector<HistoryNode>(20);
    Graph networkGraph;
    PluggableRenderer r;
    VisualizationViewer vv;
    Layout l;
    int moveLayoutCount=0;
    Timer t;
    
    PacketLossTableModel moteListModel;
    JTable moteList;
    JScrollPane motePanel;
    
    TreeInfoMsg timsg;
    HarvesterMsg hmsg;
    StatusMsg smsg;
    
    BufferedWriter logfileStream;
    FileWriter file;
    
    private final static int NO_ADDR=0xffff;
    
    public HarvesterMonitor() {
    	basestations=new Vector<String>(4);
    }
    
    /* Main entry point */
    void run() {
    	// graph
    	networkGraph = new SparseGraph();
    	
    	l = new FRLayout( networkGraph );
    	r = new PluggableRenderer();
    	r.setEdgePaintFunction(new TreeInfoEdgePaintFunction(30000));
    	r.setVertexPaintFunction(new TreeInfoVertexPaintFunction(1000, 300000));
    	r.setVertexStringer(StringLabeller.getLabeller( networkGraph ));
    	vv = new VisualizationViewer( l, r );
    	
    	graphFrame = new JFrame("Network Graph");
    	graphFrame.setSize(800,800);
    	graphFrame.setLayout(new BorderLayout());
	    
    	moteListModel = new  PacketLossTableModel();
    	moteList = new JTable(moteListModel);
    	moteList.setPreferredScrollableViewportSize(new Dimension(100, 400));
    	motePanel = new JScrollPane();
    	motePanel.getViewport().add(moteList, null);
    	graphFrame.getContentPane().add(motePanel, BorderLayout.EAST);
    	graphFrame.getContentPane().add(vv);
    	graphFrame.addWindowListener(this);
    	
    	t = new Timer(100, this);
    	t.start();
    	// end graph
    	
    	// create log file
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm");
    	String logfilename = "HarvesterMonitor."+ sdf.format(System.currentTimeMillis())+".log";
    	System.out.println("logging packets to "+logfilename);
    	try {
			file = new FileWriter(logfilename);
			logfileStream =  new BufferedWriter(file);
			logfileStream.write("# Harvester Monitor Logfile");
			logfileStream.newLine();
			logfileStream.write("# <timestamp> <am-type> <data 0>..<data n>");
			logfileStream.newLine();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    
		// setup connections to basestations
    	timsg=new TreeInfoMsg();
    	hmsg=new HarvesterMsg();
    	smsg=new StatusMsg();
    	motes = new Vector<MoteIF>(basestations.size());
    	Iterator<String> i = basestations.iterator();
    	while (i.hasNext()) {
    		PhoenixSource source = BuildSource.makePhoenix(i.next() , PrintStreamMessenger.err);
    		source.setResurrection();
    		source.start();
    		MoteIF mif=new MoteIF(source);
    		mif.registerListener(timsg, this);
    		mif.registerListener(hmsg, this);
    		mif.registerListener(smsg, this);
    		motes.add(mif);
    	}
    	graphFrame.setVisible(true);
    }
    
    synchronized public void messageReceived(int dest_addr, Message msg) {
    	long timestamp = System.currentTimeMillis();
    	// log packet
		try {
			logfileStream.write(Long.toString(timestamp));
			logfileStream.write(" "+msg.amType());
			for (int i=0; i<msg.dataLength(); i++) {
				logfileStream.write(" ");
				logfileStream.write(Integer.toString(0xff & msg.dataGet()[i]));
			}
			logfileStream.newLine();
			logfileStream.flush();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    	// process
    	if (msg instanceof TreeInfoMsg) {
    		TreeInfoMsg tmsg = (TreeInfoMsg) msg;
    		// add node if not already part of the graph
    		LayoutMutable layoutMut = (LayoutMutable) vv.getGraphLayout();
    		vv.suspend();
    		// make your changes to the graph here
    		try {
    			if (nodeFromId(tmsg.get_id())==null) {
    				nodes.add(new HistoryNode(tmsg.get_id()));
    				networkGraph.addVertex(nodeFromId(tmsg.get_id()));
    				StringLabeller.getLabeller(networkGraph).setLabel((DirectedSparseVertex)nodeFromId(tmsg.get_id()), ((Integer)tmsg.get_id()).toString());
    			}
    			else
    				nodeFromId(tmsg.get_id()).touch();
    			if (tmsg.get_parent()!=NO_ADDR && nodeFromId(tmsg.get_parent())==null) {
    				nodes.add(new HistoryNode(tmsg.get_parent()));
    				networkGraph.addVertex(nodeFromId(tmsg.get_parent()));
    				StringLabeller.getLabeller(networkGraph).setLabel((DirectedSparseVertex)nodeFromId(tmsg.get_parent()), ((Integer)tmsg.get_parent()).toString());
    			}
    		} catch (UniqueLabelException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    		// check parent
    		HistoryNode thisNode=nodeFromId(tmsg.get_id());
    		HistoryNode parentNode=nodeFromId(tmsg.get_parent());
    		int oldLost=thisNode.getLostPackets();
    		thisNode.addPacketNr(tmsg.get_dsn());
    		moteListModel.updateMote(tmsg.get_id(),thisNode.getLostPackets(), thisNode.getPRR()*100);
			moteList.repaint();
    		if (thisNode.getLostPackets()!=oldLost) {
    			System.out.println(timestamp+":"+nodeWithTwoDigits(tmsg.get_id())+": Lost packets:"+thisNode.getLostPackets()+" PRR:"+thisNode.getPRR());
    		}
    		if (thisNode.findEdge(parentNode)==null && tmsg.get_parent()!=NO_ADDR) {
    			// remove all egdes from this vertex
    			Iterator<DirectedEdge> edges= thisNode.getOutEdges().iterator(); 
    			while (edges.hasNext()) {
    				networkGraph.removeEdge(edges.next());
    			}
    			// add edge
    			networkGraph.addEdge(new DirectedSparseEdge(thisNode, parentNode));
    			// let layout run for 10 iterations
    			moveLayoutCount+=10;
    		}
  		  	// make your changes to the graph here
    		layoutMut.update();
			vv.unsuspend();
			vv.repaint();   		
    	}
    	else if (msg instanceof HarvesterMsg) {
    		HarvesterMsg hmsg = (HarvesterMsg) msg;
    		System.out.print("Received packet for "+dest_addr+" from "+hmsg.get_id()+"("+hmsg.get_dsn()+")");
    		String intTemp, intHum, extTemp, extHum, Voltage, L1, L2;
    		if (hmsg.get_temp_internal()==0xffff) 
    			intTemp = "-";
    		else 
    			intTemp = (new Float((float)(hmsg.get_temp_internal()-3960)/100)).toString();
    		if (hmsg.get_hum_internal()==0xffff) 
    			intHum = "-";
    		else 
    			intHum = (new Float(-4 + 0.0405*(float)hmsg.get_hum_internal() -2.8*Math.pow(10,-6)*(float)hmsg.get_hum_internal())).toString();
    		if (hmsg.get_temp_external()==0xffff) 
    			extTemp = "-";
    		else 
    			extTemp = (new Float((float)(hmsg.get_temp_external()-3960)/100)).toString();
    		if (hmsg.get_hum_external()==0xffff) 
    			extHum = "-";
    		else 
    			extHum = (new Float(-4 + 0.0405*(float)hmsg.get_hum_external() -2.8*Math.pow(10,-6)*(float)hmsg.get_hum_external())).toString();
    		if (hmsg.get_voltage()==0xffff) 
    			Voltage = "-";
    		else 
    			Voltage = (new Float((float)hmsg.get_voltage()/4096 * 3)).toString();
    		if (hmsg.get_light1()==0xffff) 
    			L1 = "-";
    		else 
    			L1 = new Integer(hmsg.get_light1()).toString();
    		if (hmsg.get_light2()==0xffff) 
    			L2 = "-";
    		else 
    			L2 = new Integer(hmsg.get_light2()).toString();
    		System.out.println(": Temperature: internal "+intTemp + ", external " + extTemp +
					", Humidity: internal "+intHum + ", external " + extHum +
					", Voltage: "+Voltage+
					", Light: "+L1+", "+L2);
    	}
	}

    /* private functions */
	private void addBasestation(String string) {
		basestations.add(string);
	}

	public void actionPerformed(ActionEvent e) {
		LayoutMutable layoutMut = (LayoutMutable) vv.getGraphLayout();
		vv.suspend();
		if (moveLayoutCount>0) {
			moveLayoutCount--;
			l.advancePositions();
		}
    	layoutMut.update();
		vv.unsuspend();
		vv.repaint();   
	}

	private String nodeWithTwoDigits(int node) {
    	if (node<10)
    		return "0"+((Integer)node).toString();
    	else
    		return ((Integer)node).toString();
    }
	
	private HistoryNode nodeFromId(int id) {
    	HistoryNode n;
    	Iterator<HistoryNode> i = nodes.iterator();
    	while (i.hasNext()) {
    		n=i.next();
    		if (n.nodeId==id)
    			return n;
    	}
    	return null;
    }
	
	/* Window handler */
	public void windowActivated(WindowEvent e) {
		// TODO Auto-generated method stub
	}

	public void windowClosed(WindowEvent e) {
		// TODO Auto-generated method stub		
		System.exit(0);
	}

	public void windowClosing(WindowEvent e) {
		// TODO Auto-generated method stub
		 t.stop();
		 try {
			file.close();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		 Iterator<MoteIF> i = motes.iterator();
		 while (i.hasNext()) {
			 MoteIF mote=(MoteIF) i.next();
		 	 mote.deregisterListener(timsg, this);
		 	 mote.deregisterListener(hmsg, this);
		 	 mote.deregisterListener(smsg, this);
		 	 mote.getSource().shutdown();
		 }
		 graphFrame.dispose();
	}

	public void windowDeactivated(WindowEvent e) {
		// TODO Auto-generated method stub
	}

	public void windowDeiconified(WindowEvent e) {
		// TODO Auto-generated method stub
	}

	public void windowIconified(WindowEvent e) {
		// TODO Auto-generated method stub
	}

	public void windowOpened(WindowEvent e) {
		// TODO Auto-generated method stub
	}
}
