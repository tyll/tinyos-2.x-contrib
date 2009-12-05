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
 * It create the MessagePanel to display received messages 
 * and takes care of all user's interactive actions
 *
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package rawdata;



import Config.OasisConstants;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

import javax.swing.ImageIcon;

import javax.swing.border.TitledBorder;
import javax.swing.plaf.basic.*;

import javax.swing.table.*;

import javax.swing.event.*;
import java.beans.*;
import rpc.message.MoteIF;


public class MessagePanel extends JPanel implements ActionListener, 
                                                    ItemListener, 
													ListSelectionListener
{
    public MoteIF mote; 

	public DefaultListModel rawDataList;
	public DefaultListModel msgtypeListModel;
	public JList cmdlist;
	public JTextArea rawdata;
	public JTextArea cmdText;
	public JTable msgtable;
       public DefaultTableModel tablemodel; 
	public TableCellRenderer tablerenderer;
       public JButton sendbt;
	public JButton ctlbt;
	public ImageIcon playIcon;
	public ImageIcon pauseIcon;
	public JTextField nodeSelect;
	public JTextField typeSelect;
	public JButton filtbt;
	public JButton nofiltbt;
	public JButton clearAllMsg;
	public TitledBorder paneEdge;
	public JLabel nodeID_filter = new JLabel("  Filt NodeID");
	public JLabel type_filter = new JLabel("  Filt Type");
	 public static final int NO_FILTER = -10;    


    //To keep status of user's setting
	public boolean FILTMSG = false;
	public boolean LOGDATA = false;
	public int [] filtNode = new int[OasisConstants.MAX_FILTER_NODE_NUM];
	public int [] filtType = new int[OasisConstants.MAX_FILTER_TYPE_NUM];
	

	//set PAUSE at the beginning
	public boolean ctlbt_status = false;  
	public TableSorter sorter;

	public GridBagLayout layout;
	public GridBagConstraints constraints;

	public GridBagLayout secondlayout;
	public GridBagConstraints secondconstraints;

	public MessagePanel(MoteIF m)
	{
		mote = m;
		setLayout(new BorderLayout());
		filtNode[0] = NO_FILTER;
		filtType[0] = NO_FILTER;

		//-------------send panel--------------------------
		//send raw message inputted by user
		JPanel send = new JPanel();
		paneEdge = BorderFactory.createTitledBorder("Send Raw Message");
		send.setBorder(paneEdge);
		send.setLayout(new FlowLayout(FlowLayout.LEFT, 0, 0));

		cmdText = new JTextArea(1,50);
		cmdText.setLineWrap(true);
		cmdText.setCaretPosition(cmdText.getDocument().getLength());
		send.add(new JScrollPane(cmdText));

		sendbt = new JButton("SendCmd");
		sendbt.addActionListener(this);
		JPanel sendleft = new JPanel();
		sendleft.setLayout(new BorderLayout());
		sendleft.add("East", sendbt);
		send.add("East", sendleft);

		//-------------message panel-----------------------
		JPanel second = new JPanel();
		second.setLayout(new BorderLayout());
		
		//display interperated msg in JTable
		JPanel receive = new JPanel();
		paneEdge = BorderFactory.createTitledBorder("Received Message");
		receive.setBorder(paneEdge);
		receive.setLayout(new BorderLayout());
		
		JPanel rec_title = new JPanel();
		rec_title.setLayout(new GridLayout(2,3,5,5));
		playIcon = new ImageIcon(rawdata.class.getResource("images/play2.gif"));
		pauseIcon = new ImageIcon(rawdata.class.getResource("images/pause2.gif"));
		//ctlbt = new JButton(pauseIcon);   
		ctlbt = new JButton(playIcon);   
		ctlbt.addActionListener(this);
		JLabel nodeIDlb = new JLabel("Only Recv Message From: ");
		nodeSelect = new JTextField("");
		nodeSelect.addActionListener(this);
		typeSelect = new JTextField("");
		typeSelect.addActionListener(this);

		//8/12/2008 Andy Add Type and Node filter
		//ButtonGroup filterGroup = new ButtonGroup();
		//filterGroup.add(nodeID_filter);
		//filterGroup.add(type_filter);
		
		JPanel fltPanel = new JPanel();
		fltPanel.setLayout(new GridLayout(2,2));
		fltPanel.add(nodeSelect);
	       fltPanel.add(nodeID_filter);
		fltPanel.add(typeSelect);
		fltPanel.add(type_filter);
		//8/12/2008 End

		filtbt = new JButton("Filt Message");
		filtbt.addActionListener(this);
		nofiltbt = new JButton("Display All Message");
		clearAllMsg =  new JButton("Clear All Message");
		clearAllMsg.addActionListener(this);
		
		//nofiltbt.setEnabled(true);
		nofiltbt.addActionListener(this);
		rec_title.add(nodeIDlb);
		rec_title.add(fltPanel);
		rec_title.add(filtbt);
		rec_title.add(nofiltbt);
		rec_title.add(clearAllMsg);
		rec_title.add(ctlbt);
		receive.add("North", rec_title);

		msgtypeListModel = new DefaultListModel(); //used as rawdata buffer
		tablemodel= new DefaultTableModel();
  		sorter = new TableSorter(tablemodel); 
		msgtable = new JTable(sorter);            
		//Create a couple of columns
		tablemodel.addColumn("RcvTime");
		tablemodel.addColumn("Sender");	
		tablemodel.addColumn("Type");
		tablemodel.addColumn("Message Content");		
        //Create Table Sorter
		sorter.setTableHeader(msgtable.getTableHeader());
		//Customerize Table Renderer
		tablerenderer = new CustomTableCellRenderer();
        try{
            msgtable.setDefaultRenderer( Class.forName("java.lang.Object"), tablerenderer );
        }catch( ClassNotFoundException ex ){
            System.exit( 0 );
        }
		 // Disable auto resizing
		msgtable.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		TableColumn col;
		col = msgtable.getColumnModel().getColumn(0);
		col.setPreferredWidth(100);
		col = msgtable.getColumnModel().getColumn(1);
		col.setPreferredWidth(100);
		col = msgtable.getColumnModel().getColumn(2);
		col.setPreferredWidth(100);
		col = msgtable.getColumnModel().getColumn(3);
		col.setPreferredWidth(1600);

		//msgtable.setPreferredScrollableViewportSize(new Dimension(200, 300));

		//Ask to be notified of selection changes.
		msgtable.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		msgtable.getRowSelectionAllowed();    
   		ListSelectionModel rowSM = msgtable.getSelectionModel();
		rowSM.addListSelectionListener(new ListSelectionListener() {
			public void valueChanged(ListSelectionEvent e) 
			{

				try{
					//Ignore extra messages.
					if (e.getValueIsAdjusting()) return;

					ListSelectionModel lsm =(ListSelectionModel)e.getSource();
					if (lsm.isSelectionEmpty()) {
						//no rows are selected
					} else {
						//selectedRow is selected
						int selectedViewIndex = lsm.getMinSelectionIndex();
						int tableIndex = sorter.modelIndex(selectedViewIndex);  //0919:map viewIndex to tableIndex 
						//display raw data in TextArea
						String data0=" |0\t|1\t|2\t|3\t|4\t|5\t|6\t|7\t|8\t|9\t|A\t|B\t|C\t|D\t|E\t|F|\n\n";
						String data = (String)(rawDataList.elementAt(tableIndex));
						rawdata.setText(data0+data);
					}
				}
				catch (Exception ex){}
			}
		});
		JScrollPane scrollPane1 = new JScrollPane(msgtable);
		scrollPane1.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS); 
		scrollPane1.setAutoscrolls(true);
		receive.add("Center", scrollPane1);


		//-------------raw data panel-----------------------
		//display raw data in JTextField for selected msg in Table
		JPanel raw = new JPanel();
		paneEdge = BorderFactory.createTitledBorder("Raw Data of Received Message");
		raw.setBorder(paneEdge);
		raw.setLayout(new BorderLayout());


		rawDataList = new DefaultListModel(); //used as rawdata buffer
		rawdata = new JTextArea(" ",3,3);
		rawdata.setEditable(false);
       	rawdata.setUI(new TabFixTextAreaUI());
		rawdata.setTabSize(3);

		raw.add(new JScrollPane(rawdata), BorderLayout.CENTER);

		JSplitPane splitPane2 = new JSplitPane(JSplitPane.VERTICAL_SPLIT,
                           receive, raw);
		splitPane2.setResizeWeight(1.0);
			//setDividerLocation(20.0);
		Dimension minimumSize = new Dimension(50, 20);
		raw.setMinimumSize(minimumSize);


		JSplitPane splitPane1 = new JSplitPane(JSplitPane.VERTICAL_SPLIT,
                           send, splitPane2);
                    
		add("Center", splitPane1);
	   //--------------------------------------------------
		//9/30/2008 Andy
	filtbt.setMnemonic(KeyEvent.VK_F);
	nofiltbt.setMnemonic(KeyEvent.VK_D);
	clearAllMsg.setMnemonic(KeyEvent.VK_E);
	ctlbt.setMnemonic(KeyEvent.VK_R);
	//9/30/2008
		//repaint();
    }


	public class TabFixTextAreaUI extends BasicTextAreaUI
	{
		protected void propertyChange(PropertyChangeEvent evt)
		{
			// In the BasicTextAreaUI.class, no change event 
			// is fired when the tab size changes. We make up
			// for that here.
			if ( evt.getPropertyName().equals("tabSize"))
			{
				// rebuild the view
				modelChanged();
			}
			else
			{
				// delegate remaining property change notifications.
				super.propertyChange(evt);
			}
		}
	}


	public void addComponent(Component component, int row, int column, int width, int height)
	{
		constraints.gridx = column;
		constraints.gridy = row;
		constraints.gridwidth = width;
		constraints.gridheight = height;

		layout.setConstraints(component, constraints);
		add(component);
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
			Color msgcolor = getCellColor(row);  //FFF
			cell.setForeground(msgcolor);  //FFF

			/*if( value instanceof Integer )
			{
				Integer amount = (Integer) value;
				if( amount.intValue() < 0 )
				{
					cell.setBackground( Color.red );
					// You can also customize the Font and Foreground this way
					// cell.setForeground();
					// cell.setFont();
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
		int tableIndex = sorter.modelIndex(row);  //0919:map viewIndex to tableIndex 
		Integer Itype = (Integer)msgtypeListModel.elementAt(tableIndex);
		int type = Itype.intValue();
		switch (type)
		{
			case OasisConstants.MISS:
				return (Color.red);
			case OasisConstants.DUP:
				return (Color.blue);
			default:
				return (Color.black);
		}					

	}


    //This method is required by ActionListener
	public void actionPerformed(ActionEvent e) 
	{
		Object src = e.getSource();
		if (src == sendbt) {
			//get the text from JTextArea
			String cmdStr = new String(cmdText.getText());

			//convert String to Message 
			//Message msg = CreateCmdMessage(cmdStr);

			//send cmd 
			int moteId = OasisConstants.BCAST_ID; //0xffff;
			//SendCmd(moteId, msg);
		} 
		else if (src == ctlbt) {
			ctlbt_status = !ctlbt_status;
			if (ctlbt_status == false){
				ctlbt.setIcon(playIcon);
			}
			else{
				ctlbt.setIcon(pauseIcon);
			} 
		}
		//12/8/2008 Andy
		else if (src == nodeSelect){
			try{
				FILTMSG = true;

				//get node list from user's input
				Integer type;
				Integer node;
				String patternStr = "\\s|\\t|\\n|,";
				String nodelist = new String(nodeSelect.getText());
				String typelist = new String(typeSelect.getText());
				
				if (nodelist.length() == 0) {
					javax.swing.JOptionPane.showMessageDialog(
							null,
							"Please provide the list of expected nodes in the blank first!",
							"Error Message",
							JOptionPane.INFORMATION_MESSAGE);
					FILTMSG = false;
					return;
				}
				
				String [] resultNode = nodelist.split(patternStr);
				int x=0;
				while (x<resultNode.length) {
					if(resultNode[x].length() != 0 ) {
						node = new Integer(resultNode[x]);
						filtNode[x] = node.intValue();			
					} else filtNode[x] = NO_FILTER;  //dummy filter!
					x++;
				}
				filtNode[x] = -1;

				String [] resultType = typelist.split(patternStr);
				int y=0;
				while (y<resultType.length) {
					if(resultType[y].length() != 0 ) {
						type = new Integer(resultType[y]);
						filtType[y] = type.intValue();			
					} else filtType[y] = NO_FILTER;  //dummy filter!
					y++;
				}
				filtType[y] = -1;
			}
			catch (Exception ex){
				javax.swing.JOptionPane.showMessageDialog(
							null,
							"Please provide the list of expected nodes in the blank first!",
							"Error Message",
							JOptionPane.INFORMATION_MESSAGE);
				FILTMSG = false;
			}
		}
		else if (src == typeSelect){
			try{
				FILTMSG = true;

				//get node list from user's input
				Integer type;
				Integer node;
				String patternStr = "\\s|\\t|\\n|,";
				String nodelist = new String(nodeSelect.getText());
				String typelist = new String(typeSelect.getText());
				
				if (typelist.length() == 0) {
					javax.swing.JOptionPane.showMessageDialog(
							null,
							"Please provide the list of expected types in the blank first!",
							"Error Message",
							JOptionPane.INFORMATION_MESSAGE);
					FILTMSG = false;
					return;
				}
				
				String [] resultNode = nodelist.split(patternStr);
				int x=0;
				while (x<resultNode.length) {
					if(resultNode[x].length() != 0 ) {
						node = new Integer(resultNode[x]);
						filtNode[x] = node.intValue();			
					} else filtNode[x] = NO_FILTER;  //dummy filter!
					x++;
				}
				filtNode[x] = -1;

				String [] resultType = typelist.split(patternStr);
				int y=0;
				while (y<resultType.length) {
					if(resultType[y].length() != 0 ) {
						type = new Integer(resultType[y]);
						filtType[y] = type.intValue();			
					} else filtType[y] = NO_FILTER;  //dummy filter!
					y++;
				}
				filtType[y] = -1;
			}
			catch (Exception ex){
				javax.swing.JOptionPane.showMessageDialog(
							null,
							"Please provide the list of expected nodes in the blank first!",
							"Error Message",
							JOptionPane.INFORMATION_MESSAGE);
				FILTMSG = false;
			}
		}
		else if ((src == filtbt)){
			try{
				FILTMSG = true;

				//get node list from user's input
				Integer type;
				Integer node;
				String patternStr = "\\s|\\t|\\n|,";
				String nodelist = new String(nodeSelect.getText());
				String typelist = new String(typeSelect.getText());
				
				if (nodelist.length() == 0 && typelist.length() == 0) {
					javax.swing.JOptionPane.showMessageDialog(
							null,
							"Please provide the list of expected nodes/types in the blank first!",
							"Error Message",
							JOptionPane.INFORMATION_MESSAGE);
					FILTMSG = false;
					return;
				}
				
				String [] resultNode = nodelist.split(patternStr);
				int x=0;
				while (x<resultNode.length) {
					if(resultNode[x].length() != 0 ) {
						node = new Integer(resultNode[x]);
						filtNode[x] = node.intValue();			
					} else filtNode[x] = NO_FILTER;  //dummy filter!
					x++;
				}
				filtNode[x] = -1;

				String [] resultType = typelist.split(patternStr);
				int y=0;
				while (y<resultType.length) {
					if(resultType[y].length() != 0 ) {
						type = new Integer(resultType[y]);
						filtType[y] = type.intValue();			
					} else filtType[y] = NO_FILTER;  //dummy filter!
					y++;
				}
				filtType[y] = -1;
			}
			catch (Exception ex){
				javax.swing.JOptionPane.showMessageDialog(
							null,
							"Please provide the list of expected nodes in the blank first!",
							"Error Message",
							JOptionPane.INFORMATION_MESSAGE);
				FILTMSG = false;
			}
		}
		//8/12/2008 End
		else if (src == nofiltbt) {
			FILTMSG = false;
			filtNode[0] = NO_FILTER;
			filtType[0] = NO_FILTER;
		}
		else if (src == clearAllMsg) {
			int numRows = tablemodel.getRowCount();
			for (int i=numRows - 1;i>=0;i--) {
			  tablemodel.removeRow(i);
			  msgtable.revalidate();
			}
		}
	}

	/*public String getcmdString()
	{
		String ret= new String(" ");
		// Get the text area's document
		Document doc = cmdText.getDocument();
    
		// Create an iterator using the root element
		ElementIterator it = new ElementIterator(doc.getDefaultRootElement());
    
		// Iterate all content elements (which are leaves)
		Element e;
		while ((e=it.next()) != null) {
			if (e.isLeaf()) {
				int rangeStart = e.getStartOffset();
				int rangeEnd = e.getEndOffset();
				try {
					String line = cmdText.getText(rangeStart, rangeEnd-rangeStart);
					ret +=line;
				} catch (BadLocationException ex) {
				}
			}
		}

		return ret;
	}*/

	
	
	byte StringToInt(String s)   //s.length() should be 2 
	{
		char [] chars = new char[s.length()];
		s.getChars(0, s.length(), chars, 0);
		byte ret; 

		//convert String to Byte []
		int i=0;
		int tempint = (charToInt(chars[i])*16+charToInt(chars[i+1]));
		ret = intToByte(tempint);

		return ret;
	}


	public static int charToInt(char ch)
	{
		int ret;
		switch (ch)
		{
			case '0': ret = 0; break;
			case '1': ret = 1; break;
			case '2': ret = 2; break;
			case '3': ret = 3; break;
			case '4': ret = 4; break;
			case '5': ret = 5; break;
			case '6': ret = 6; break;
			case '7': ret = 7; break;
			case '8': ret = 8; break;
			case '9': ret = 9; break;
			case 'A':
			case 'a':
					ret = 10; break;
			case 'B':
			case 'b':
					ret = 11; break;
			case 'C':
			case 'c':
					ret = 12; break;
			case 'D':
			case 'd':
					ret = 13; break;
			case 'E':
			case 'e':
					ret = 14; break;
			case 'F':
			case 'f':
					ret = 15; break;
			default: ret=-1;
		}
		return ret;		
	}


	public static byte intToByte(int number) {
		int temp = number;
		byte[] b=new byte[4];
		for (int i=b.length-1;i>-1;i--){
		  b[i] = new Integer(temp&0xff).byteValue();     
		  temp = temp >> 8;     
		}
		return b[b.length-1];
	}


    //This method is required by ListSelectionListener.(for JList)
	public void valueChanged(ListSelectionEvent e) 
	{
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

    public Dimension getSize()
	{
		return new Dimension(700, 500);
    }
	//--------------------------------------------------------------------------

}

