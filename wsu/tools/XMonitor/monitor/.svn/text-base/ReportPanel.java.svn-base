//$Id$

/**
 * Copyright (C) 2006 WSU All Rights Reserved
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE WASHINGTON STATE UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE WASHINGTON
 * STATE UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE WASHINGTON STATE UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE WASHINGTON STATE UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */


/**
 * Function Description:
 *
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package monitor;


import Config.OasisConstants;
import java.io.*;
import java.util.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;



import javax.swing.JTable;



import javax.swing.table.*;

import javax.swing.event.*;
import rpc.message.MessageListener;
import rpc.message.MoteIF;
import xml.RemoteObject.StreamDataObject;


public class ReportPanel extends JPanel implements ActionListener,
                                                   ItemListener,
												   MessageListener
{
    MoteIF mote;
	//static public NescApp rpcApp = null;
	static public  Vector values = new Vector();

	static final public short DIALOG_CANCEL = 0;
	static final public short DIALOG_RUN = 1;


	//Max number of event msg kept in buffer
	public final int MSG_BUFFER_SIZE = 50;
	int lastrow = 0;

	public DefaultListModel eventListModel;
	public JList eventList;
    public DefaultTableModel tableModel;
	public JTable eventTable;
	public TableCellRenderer tableRenderer;
	public JTableHeader header;

	//ToolTips used by createDefaultTableHeader()
    protected String[] columnToolTips = {null,
                                         null,
                                         "The name of the module where the event comes from",
                                         "Click here to set report level remotely",
                                         null};

	public ReportPanel(MoteIF m)
	//public ReportPanel()
	{

		//Register Message Type for this panel
		mote = m;
		//mote.registerListener(new NetworkMsg(), this);
        mote.registerListener("report", this);
		//rpcApp = app;

		//Create title panel
		JPanel titlePanel = new JPanel();
		//JLabel title = new JLabel("Sensorweb Report Listening");
		//titlePanel.add(title);

    	//Create event table panel
		JPanel eventPanel = new JPanel();
		eventPanel.setLayout(new BorderLayout());

		//Create event table
		eventListModel = new DefaultListModel(); //used as event buffer
		tableModel= new DefaultTableModel();
		eventTable = new JTable(tableModel){
            //Implement table header tool tips.
            protected JTableHeader createDefaultTableHeader() {
                return new JTableHeader(columnModel) {
                    public String getToolTipText(MouseEvent e) {
                        String tip = null;
                        java.awt.Point p = e.getPoint();
                        int index = columnModel.getColumnIndexAtX(p.x);
                        int realIndex = columnModel.getColumn(index).getModelIndex();
                        return columnToolTips[realIndex];
                    }
                };
            }
		};

		//Add listening for Clicks on a Column Header of eventTable
		header = eventTable.getTableHeader();
   	       header.addMouseListener(new MouseAdapter(){
			public void mouseClicked(MouseEvent evt) {
				JTable table = ((JTableHeader)evt.getSource()).getTable();
				TableColumnModel colModel = table.getColumnModel();

				// The index of the column whose header was clicked
				int vColIndex = colModel.getColumnIndexAtX(evt.getX());
				int mColIndex = table.convertColumnIndexToModel(vColIndex);

				// Return if not clicked on any column header
				if (vColIndex == -1) {
					return;
				}

				// Click on "Level" column
				//if (vColIndex == 3 && MainFrame.rpcApp != null){
				if (vColIndex == 3){
                popSetLevelDialog();
				}/*Andy: I don't know what Fenghua means here but this will give bad impression that config is not set up properly
				else{
					JOptionPane.showMessageDialog(null,
							"Please specify xml file to enable Remote Control first!",
							"WARNING",
							JOptionPane.INFORMATION_MESSAGE);
				}*/
			}
		});

		//Create a couple of columns
		tableModel.addColumn("Time");
		tableModel.addColumn("Sender");
		tableModel.addColumn("Type");
		tableModel.addColumn("Level");
		tableModel.addColumn("Report Contents");

		//Customerize Table Renderer
		tableRenderer = new CustomTableCellRenderer();
        try{
            eventTable.setDefaultRenderer( Class.forName("java.lang.Object"), tableRenderer );
        }catch( ClassNotFoundException ex ){
            System.exit( 0 );
        }

		//Disable auto resizing
		eventTable.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		TableColumn col;
		col = eventTable.getColumnModel().getColumn(0);
		col.setPreferredWidth(200);
		col = eventTable.getColumnModel().getColumn(1);
		col.setPreferredWidth(100);
		col = eventTable.getColumnModel().getColumn(2);
		col.setPreferredWidth(100);
		col = eventTable.getColumnModel().getColumn(3);
		col.setPreferredWidth(100);
		col = eventTable.getColumnModel().getColumn(4);
		col.setPreferredWidth(1000);

		eventTable.setPreferredScrollableViewportSize(new Dimension(50, 100));

		JScrollPane scrollPane1 = new JScrollPane(eventTable);
		scrollPane1.setHorizontalScrollBarPolicy(
			              ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);
		scrollPane1.setAutoscrolls(true);
		eventPanel.add("Center", scrollPane1);

		// Set up Layout of Event Panel
		setLayout(new BorderLayout());
		add("North", titlePanel);
		add("Center", eventPanel);
    }


	public void popSetLevelDialog()
	{
		values.clear();
		Vector ret = new Vector();

		//Open a config dialog to set report level remotely
		ReportConfigDialog config = new ReportConfigDialog(values, ret);
		config.show();

		Enumeration r = ret.elements();
		Object v = r.nextElement();
		int tv = Integer.parseInt(v.toString());
		switch (tv)
		{
		case DIALOG_CANCEL:
			break;
		case DIALOG_RUN:
	    	sendSetLevelRpc();
			break;
		}

		/*config.addWindowListener(new WindowAdapter(){
			public void windowClosed(WindowEvent event){
				switch (event.getID()) {
				case ReportConfigDialog.SET:
					 sendSetLevelRpc();
					 break;
				case ReportConfigDialog.CANCEL:
					 //System.out.println("Click CANCEL button!!!");
					break;
				}
			}
		});*/

	}

	static public void sendSetLevelRpc() {

		//Fixed for this function
		int nodeId = OasisConstants.ALL_NODES;
		String cmdName = "EventReportM.EventConfig.setReportLevel";

		//Get the corresponding info in Rpc.StructArgs
		//Rpc.StructArgs rpccmd = rpcApp.rpcs.findRpcFunc(cmdName);

		//Get param list
		//NescDecls.nescStruct rpcstruct = new NescDecls.nescStruct();
		//rpcApp.getStruct(rpccmd.name, rpcstruct);

		//Send out rpc command msg through rpcPanel's function
		//rpcPanel.sendRpcCmdMsg(nodeId, rpccmd, rpcPanel.RPC, false);
	}


    //public void messageReceived(int dest_addr, Message msg)
    public void messageReceived(String typeName, Vector streamEvent) {
	
		
		String typename = null;
		String levelname = null;
        String contents = " ";
        
        
        int sender = ((Integer) (((StreamDataObject) streamEvent.get(0)).data.get(0))).intValue();
        int tosTypeId =  ((Integer) (((StreamDataObject) streamEvent.get(1)).data.get(0))).intValue();
        int netTypeId =  ((Integer) (((StreamDataObject) streamEvent.get(2)).data.get(0))).intValue();
        int appTypeId =((Integer) (((StreamDataObject) streamEvent.get(3)).data.get(0))).intValue();
        int eventTypeId = ((Integer) (((StreamDataObject) streamEvent.get(4)).data.get(0))).intValue();
		int level = ((Integer) (((StreamDataObject) streamEvent.get(5)).data.get(0))).intValue();
         int size = ((Integer) (((StreamDataObject) streamEvent.get(6)).data.size()));
            byte[] msgdata = new byte[size];

            int tmp = 0;
            for (int i = 0; i < size; i++) {
                tmp = ((Integer) (((StreamDataObject) streamEvent.get(6)).data.get(i))).intValue();
                msgdata[i] = (byte) (tmp);
                
            //System.out.print(receivedData[i] +" ");
            }
		


	
    //    if (tosTypeId !=OasisConstants.AM_NETWORKMSG)
	//		return;

		
		//Filt non-event msgs
		//if (netTypeId!= OasisConstants.NW_SNMS ||
		//	appTypeId!= OasisConstants.TYPE_SNMS_EVENT)
		//	return;

        //Create display contents
		
		levelname = getEventLevelName(level);
		typename = getEventTypeName(eventTypeId);
            int start = 0;
            int end = size;
            String data = "", current = "";
		for ( int tt=start; tt<end; tt++)
		{
			contents+=(char)(msgdata[tt]);
		}
      	



		Object [] newRow = { new Date(), " "+sender,
			                 typename, levelname, contents};

		//Write into Event Log file
		String newEvent = new Date() + " "+sender+ " "+typename
			              + " "+levelname+ " "+contents+ "\n";
		if(eventTypeId == OasisConstants.EVENT_TYPE_SEISMICEVENT){
     		    writeSeismicEventLog(newEvent);
	       }
		else{
		    writeEventLog(newEvent);
	       }

		//7/30/2008 Andy: log event report
		try {
			String eventContent = Util.getDateTime()   + " : "  + "EVENT: "+sender+ " "+typename
			              + " "+levelname+ " "+contents;
			MainClass.eventLogger.write(eventContent + "\n");
			MainClass.eventLogger.flush();
			//System.out.println(eventContent);
			}
		catch (Exception ex){
		}
		//End 7/30/2008

		//Manage tableModel & event buffer
		if (lastrow == MSG_BUFFER_SIZE)
		{
			//remove msg from table
			tableModel.removeRow(0);//remove(0);
			//remove msg type from buffer
			eventListModel.removeElementAt(0);
		}

		//Save new event
		int pos = eventListModel.getSize();
		eventListModel.add(pos, new Integer((int)level));
		tableModel.addRow(newRow);
		lastrow = tableModel.getRowCount();
	}


	/**
	 * Interperate Event Type Name according to
	 * the definitions in OasisConstants.java
	 */
	public String getEventTypeName(int type)
	{
		String name = null;
		switch (type)
		{
		case OasisConstants.EVENT_TYPE_SNMS:
			name = "SNMS";
			break;
		case OasisConstants.EVENT_TYPE_SENSING:
			name = "SENSING";
		    break;
		case OasisConstants.EVENT_TYPE_MIDDLEWARE:
			name = "MIDDLEWARE";
		    break;
		case OasisConstants.EVENT_TYPE_ROUTING:
			name = "ROUTING";
			break;
		case OasisConstants.EVENT_TYPE_MAC:
			name = "MAC";
		    break;
        case OasisConstants.EVENT_TYPE_DATAMANAGE:
			name = "DATAM";
		    break;
		case OasisConstants.EVENT_TYPE_SEISMICEVENT:
			name = "Seismic Event";
		    break;
		default:
			name ="UNKNOWN";
		    break;
		}
		return name;
	}


   /**
	* Interperate Event Type Name according to
	*the definitions in OasisConstants.java
	*/
	public String getEventLevelName(int level)
	{
		String name = null;
		switch (level)
		{
		case OasisConstants.EVENT_LEVEL_URGENT:
			name = "URGENT";
			break;
		case OasisConstants.EVENT_LEVEL_HIGH:
			name = "HIGH";
		    break;
		case OasisConstants.EVENT_LEVEL_MEDIUM:
			name = "MEDIUM";
		    break;
		case OasisConstants.EVENT_LEVEL_LOW:
			name = "LOW";
			break;
		default:
			name ="UNDIFINED";
		    break;
		}
		return name;
	}


    static public void writeEventLog(String descript)
	{
		File file;
		BufferedWriter outstream;
		Date time = new Date();
		String t = time.getYear()+1900+"-"+time.getMonth()+"-"+time.getDate();
		long bytes = 30000000;
		try {
			//Get log file
			String logfile = OasisConstants.LogPath+"/" + t + "-Event.log";
			boolean exists = (new File(logfile)).exists();
			if (!exists || (new File(logfile)).length()>=bytes) {
				if (exists){
					file = new File(logfile);
					file.delete();
				}
				//create a new, empty node file
				try {
					file = new File(logfile);
					boolean success = file.createNewFile();
				} catch (IOException e) {
					System.out.println("Create Event Log file failed!");
				}
			}

			//Write description into log file
			try {
				outstream = new BufferedWriter(new FileWriter(logfile, true));
				outstream.write(descript);
				outstream.close();
			} catch (IOException e) {
			}
		}catch (java.lang.Exception e) {
		}
	}

// Added by Renjie to log seismic event
   static public void writeSeismicEventLog(String descript)
	{
		File file;
		BufferedWriter outstream;
		Date time = new Date();
		String t = time.getYear()+1900+"-"+time.getMonth()+"-"+time.getDate();
		long bytes = 30000000;
		try {
			//Get log file
			String logfile = OasisConstants.LogPath+"/" + t + "-SeismicEvent.log";
			boolean exists = (new File(logfile)).exists();
			if (!exists || (new File(logfile)).length()>=bytes) {
				if (exists){
					file = new File(logfile);
					file.delete();
				}
				//create a new, empty node file
				try {
					file = new File(logfile);
					boolean success = file.createNewFile();
				} catch (IOException e) {
					System.out.println("Create Event Log file failed!");
				}
			}

			//Write description into log file
			try {
				outstream = new BufferedWriter(new FileWriter(logfile, true));
				outstream.write(descript);
				outstream.close();
			} catch (IOException e) {
			}
		}catch (java.lang.Exception e) {
		}
	}

  

   

   
	public class CustomTableCellRenderer extends DefaultTableCellRenderer
	{
		public Component getTableCellRendererComponent
		   (JTable table, Object value, boolean isSelected,
		   boolean hasFocus, int row, int column)
		{
			Component cell = super.getTableCellRendererComponent
			   (table, value, isSelected, hasFocus, row, column);

			//set different color for different type of msg
			Color msgcolor = getCellColor(row);
			cell.setForeground(msgcolor);

			/*if( value instanceof Integer )
			{
				Integer amount = (Integer) value;
				if( amount.intValue() < 0 )
				{
					cell.setBackground( Color.red );
					// You can also customize the Font and Foreground this way
					cell.setForeground();
					 cell.setFont();
				}
				else
				{
					cell.setBackground( Color.white );
				}
			}*/

			return cell;

		}
	}

	public Color getCellColor(int row)
	{
		//int tableIndex = sorter.modelIndex(row);  //0919:map viewIndex to tableIndex
		Integer Ilevel = (Integer)eventListModel.elementAt(row);
		int level = Ilevel.intValue();

		switch (level)
		{
			case OasisConstants.EVENT_LEVEL_URGENT:
				return (Color.red);
			/*case DUP:
				return (Color.blue);*/
			default:
				return (Color.black);

		}

	}


	//This method is required by ActionListener
	public void actionPerformed(ActionEvent e)
	{
		Object src = e.getSource();
	}

    //This method is required by  ItemListener
    public void itemStateChanged(ItemEvent e)
	{
    }

	public void destroy()
	{
		//which panel should be removed
    }

    public void start()
	{
    }

    public void stop()
	{
    }

    public void stateChanged(ChangeEvent e)
	{
    }





}

