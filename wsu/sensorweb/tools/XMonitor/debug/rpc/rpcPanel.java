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
 * It creates the Control Panel for remote control
 * and takes care of all user's interactive actions.
 *
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package debug.rpc;


import com.oasis.message.*;
import Config.*;
import monitor.*;

import net.tinyos.message.*;
import net.tinyos.util.*;

import java.util.Vector;
import java.util.Enumeration;

import java.io.*; 
import java.util.*;
import java.text.*;
import java.io.File;

import java.awt.*;
import java.applet.Applet;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;

import javax.swing.ImageIcon;
import javax.swing.AbstractButton;
import javax.swing.Icon;

import javax.swing.border.TitledBorder;
import javax.swing.text.*;
 
import javax.swing.JTable;
import javax.swing.table.AbstractTableModel;
import javax.swing.event.TableModelEvent;
import javax.swing.event.TableModelListener;
import javax.swing.table.DefaultTableModel;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.Component;


public class rpcPanel extends JPanel implements ActionListener
{
	static public NescApp app;
	public rpcMessageDriver listener;
	static public Vector nodeID;
	
	private GridBagLayout layout;
	private GridBagConstraints constraints;

	//enum for RPC function call
	static final public short RPC = 0;
	static final public short PEEK = 1;
	static final public short POKE = 2;

	static final public short DIALOG_CANCEL = 0;
	static final public short DIALOG_RUN = 1;

	static public short transactionID = 0;
	static public Vector rvalues = new Vector();  //store input parameter values for Rpc function
	static public Vector svalues = new Vector();  //store symbol value for Poke function
	static public Vector srvalues = new Vector();  //store input parameter values for Poke function
	static public RamSymbols.RamArgs symbol = null;  //store info for selected ramSymbol
	static public Rpc.StructArgs rpccmd = null, ramcmd = null;
	
	static public NescDecls.nescStruct rpcstruct=null, ramstruct=null, symbolstruct=null;
	static public Vector pvListRpc = new Vector();
	static public Vector pvListRam = new Vector();

	static public String prevCmd = "";
	static public String prevRam = "";
	static public short tempValue = 0;

	//For RpcFrame panel
	public JButton selectNewMotes = new JButton("Select new motes");
	public JButton resetBt = new JButton("ResetSeq");
	
	//For Rpc subpanel
	public JComboBox cmdList;
	public JButton sendcmdBt = new JButton("Run ...");

	//For RamSymbols subpanel
	public JComboBox ramsList;
    	public JComboBox ramcmdList;
	public JButton sendramBt = new JButton("Run ...");

    //For Log subpanel
	static public JTextArea actionLog;
	public ParamEditor editor;
	static public Enumeration e;
	static public JFrame mainFrame;
	public TControlPanelDialog parentDialog;


	/**
	 * This Routine sets up the app and
	 * the GUI panel
	 * 
	 */
	//public rpcPanel(MoteIF moteif, int nodeID, String XmlPath)
	public rpcPanel(JFrame mainFrame, NescApp app, Vector nodeID, JTextArea actionLog)
	{
		this.mainFrame = mainFrame;
		this.app = app;
		this.nodeID = nodeID;
		this.actionLog = actionLog;
	
		//Set up message listener for RpcResponseMsg
		listener = new rpcMessageDriver(app);
		app.comm.receiveComm.registerListener(OasisConstants.NW_RPCR, listener);

		//Set layout
		layout = new GridBagLayout();
		setLayout(layout);
		constraints = new GridBagConstraints();

		resetBt.addActionListener(this);
		resetBt.setSize( new java.awt.Dimension( 2, 30 ) );
		selectNewMotes.addActionListener(this);
		selectNewMotes.setSize( new java.awt.Dimension( 2, 30 ) );

	
		//Remote Control SubPanel
		JPanel rpc = new JPanel();
		TitledBorder paneEdge1 = BorderFactory.createTitledBorder("Remote Procedure Call :");
        rpc.setBorder(paneEdge1);
		rpc.setLayout(new GridLayout(1,2,2,2));

			//For rpc functions
			Vector rpcList = app.rpcs.getRpcList();
			Vector cmds = new Vector();
			for (Enumeration e = rpcList.elements(); e.hasMoreElements(); )
			{
				Rpc.StructArgs r = (Rpc.StructArgs)e.nextElement();
				if (r.name.equals("RamSymbolsM.peek") || r.name.equals("RamSymbolsM.poke"))
					continue;
				cmds.addElement(r.name);
			}
			
			//sort rpccmd vector by position in alphabet
			Collections.sort(cmds, Collator.getInstance()); 

			cmdList = new JComboBox(cmds);
			rpc.add(cmdList);

		    JPanel rpc2 = new JPanel();
		    rpc2.setLayout(new GridLayout(1,1,2,2));
			rpc2.add(sendcmdBt);
			sendcmdBt.addActionListener(this);
			rpc.add(rpc2);

		//RamSymbols SubPanel
		JPanel rams = new JPanel();
		TitledBorder paneEdge2 = BorderFactory.createTitledBorder("Parameter Query/Adjustment :");
        	rams.setBorder(paneEdge2);
		rams.setLayout(new GridLayout(1,2,2,2));

			Vector rList = app.ramsymbols.getRamList();
			Vector list = new Vector();
			for (Enumeration e = rList.elements(); e.hasMoreElements(); )
			{
				RamSymbols.RamArgs r = (RamSymbols.RamArgs)e.nextElement();
				//Not allow control for ramSymbol of Pointer Type
				if (!r.isPointer) {
					list.addElement(r.name);
				}
			}
			//sort ramSymbol vector by position in alphabet
			Collections.sort(list, Collator.getInstance()); 
			ramsList = new JComboBox(list);
			rams.add(ramsList);

			JPanel rams2 = new JPanel();
		    	rams2.setLayout(new GridLayout(1,2,2,2));
			Vector ramcmds = new Vector();
			ramcmds.addElement("Get");
			ramcmds.addElement("Set");
			ramcmdList = new JComboBox(ramcmds);
			rams2.add(ramcmdList);

			rams2.add(sendramBt);
			sendramBt.addActionListener(this);
			rams.add(rams2);

		constraints.fill = GridBagConstraints.NONE;
		constraints.anchor = GridBagConstraints.EAST;
		setConstraints(resetBt, 0, 5, 4, 1);
		add(resetBt);
		setConstraints(selectNewMotes, 0, 4, 4, 1);
		add(selectNewMotes);
		constraints.fill = GridBagConstraints.HORIZONTAL;
		constraints.weightx = 1000;
		setConstraints(rpc, 1, 0, 9, 2);
		add(rpc);
		setConstraints(rams, 3, 0, 9, 2);
		add(rams);

		final String sendRamBt = "Send ram"; 
	       sendramBt.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),sendRamBt);
	        sendramBt.getActionMap().put(sendRamBt, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
	                        sendramBt_Action();
	           }
	      });

		final String sendCmdBt = "Send cmd"; 
	       sendcmdBt.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),sendCmdBt);
	        sendcmdBt.getActionMap().put(sendCmdBt, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
	                        sendcmdBt_Action();
	           }
	      });

		final String reset_Bt = "Reset"; 
	       resetBt.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),reset_Bt);
	        resetBt.getActionMap().put(reset_Bt, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
	                        resetBt_Action();
	           }
	      });

		final String selectNewMote = "Select New Mote"; 
	       selectNewMotes.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),selectNewMote);
	        selectNewMotes.getActionMap().put(selectNewMote, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
	                        selectNewMotesBt_Action();
	           }
	      });

    }

	
	private void setConstraints(Component component, 
		                        int row, int column, int width, int height)
	{
		constraints.gridx = column;
		constraints.gridy = row;
		constraints.gridwidth = width;
		constraints.gridheight = height;
		layout.setConstraints(component, constraints);
	}


	public void setTControlPanelDialog(TControlPanelDialog _parentDialog){
		parentDialog = _parentDialog;
	}

	

    /**
	 * This method is required by ActionListener
	 */
	public void actionPerformed(ActionEvent e) 
	{
		Object src = e.getSource();
		if (src == sendcmdBt) {
			sendcmdBt_Action();
		} 
		else if (src == sendramBt) {
			sendramBt_Action();
		} 
		else if (src == resetBt) {
			resetBt_Action();
		} 
		else if (src == selectNewMotes) {
			selectNewMotesBt_Action();
		} 
	}


	public void resetBt_Action()
	{
		app.clearSeqNo();
	}

	public void selectNewMotesBt_Action()
	{
		parentDialog.dispose();
		((MainFrame)mainFrame).menuItemSendRPC_action();
	}


    /**
	 * This method responds to send rpc command button
	 * First, it opens a subpanel to accept the parameter setting for selected RPC function
	 * from the user, and save them into global variable "values"
	 * Then, it gets the rpc function that user selects
	 * and call SendRpcCmdMsg() with type = RPC to sent it out 
	 */
	public void sendcmdBt_Action()
	{
		Enumeration e;
		String pnames = "";

		//Get selected command
		String command = (String)cmdList.getSelectedItem();

		//Get the corresponding info in Rpc.StructArgs
		rpccmd = app.rpcs.findRpcFunc(command);

		if (rpccmd != null){
			//Get param values and put them into vector "values" 
			rpcstruct = new NescDecls.nescStruct();
			app.getStruct(rpccmd.name, rpcstruct);
			if (rpcstruct != null){
				if (prevCmd != command){
					pvListRpc.clear();
					prevCmd = command;
				}
				//Open parameter editor,get values and put into rvalues 
				Vector ret = new Vector();
				editor = new ParamEditor(mainFrame, command, 
					                     rpccmd, null, 
					                     pvListRpc, ret);
				editor.show();
			    Enumeration r = ret.elements();
				int tv = Integer.parseInt((r.nextElement()).toString());
				switch (tv)
				{
				case DIALOG_CANCEL:
					break;
				case DIALOG_RUN:
					for (int i = 0 ; i <nodeID.size(); i++){
						int moteNo = Integer.parseInt(nodeID.get(i).toString());
						sendRpcCmdMsg(moteNo, rpccmd, RPC, true);
					}
					break;				
				}
			}
			else{
				//YFHCheck:
				System.out.println("In rpcPanel.paramBt_Action(): no _Struct for rpc command: "+ rpccmd.name);
			}
		}
		else{
			//YFHCheck: 
			System.out.println("In rpcPanel.paramBt_Action(): no _Struct for rpc command: "+ rpccmd.name);
		}
	}



    /**
	 * This method responds to send set/get button
	 * It gets the peek/poke function that user selects
	 * and call SendRpcCmdMsg() with type = PEEK/POKE to send it out 
	 */
	public void sendramBt_Action()
	{
		Enumeration e;
		String pnames = "";

		//Get selected ramSymbol
		String symbolName = (String)ramsList.getSelectedItem();	
		
		//Get RamArgs info of selected symbolName from ramSymbols
		
		symbol = app.ramsymbols.findRamSymbol(symbolName);
	
		
		if (symbol!=null) {
			symbolstruct = new NescDecls.nescStruct();
			app.getStruct(symbolName, symbolstruct);
			if (symbolstruct != null){
				//Prepare param values for Poke
				if (ramcmdList.getSelectedIndex() == 1){  //Set/Poke
					if (prevRam != symbolName){
						pvListRam.clear();
						prevRam = symbolName;
					}
					//Open a parameter editor, get values and put into svalues 
					Vector ret = new Vector();
					editor = new ParamEditor(mainFrame, symbolName, 
						                     null, symbol, 
						                     pvListRam, ret);									
					editor.show();
					Enumeration r = ret.elements();
					int tv = Integer.parseInt((r.nextElement()).toString());
					switch (tv)
					{
					case DIALOG_CANCEL:
						break;
					case DIALOG_RUN:
						sendRamMsg();
						break;				
					}
				}
				else{
					//check ramsymbol size
					if (symbol.length > RamSymbols.ramSymbol_t.MAX_RAM_SYMBOL_SIZE) {
						System.out.println("Warning: The length of selected RamSymbol is too long!");
						JOptionPane.showMessageDialog(null,
							"The selected symbol is too large to Get.",
							"WARNING",
							JOptionPane.ERROR_MESSAGE);
						return;
					}
					else{
						//directly send out msg
						sendRamMsg();
					}
				}			
			}
			else{
				//YFHCheck:
				System.out.println("In rpcPanel.configBt_Action(): no _Struct for ramSymbol: "+ symbolName);
				//System.exit(0);
			}
		}
	}


	/**
	 * Send RpcCommandMsg through app.comm.sendComm
	 */
	public void sendRamMsg()
	{
		//Get selected command (Set or Get)
		String command = (String)ramcmdList.getSelectedItem();
		String cmd = null;
		short type;
		if (command == "Get"){
			type = PEEK;
			cmd = "RamSymbolsM.peek";
		}
		else{
			type = POKE;
			cmd = "RamSymbolsM.poke";
		}

		//Set values for Msg header
		srvalues.clear();
		RamSymbols.setHeadParams(symbol, srvalues);

		//Get the corresponding info in Rpc.StructArgs [use peek for both peek/poke]
		ramcmd = app.rpcs.findRpcFunc(cmd);

		//Send RpcCommandMsg
		for (int i = 0 ; i <nodeID.size(); i++){
			  int moteNo = Integer.parseInt(nodeID.get(i).toString());
			  sendRpcCmdMsg(moteNo, ramcmd, type, true);          
		}
	}



	/**
	 * Send RpcCommandMsg through app.comm.sendCommc
	 */
	static public int sendRpcCmdMsg(int nodeId, 
		                             Rpc.StructArgs cmd, 
									 short type,
									 boolean screenLog)
	{
		String description = null;

		//Provide infos to fill in RpcHeader
		transactionID = (short)((int)(transactionID + 1) % 256);

		//For ALL_NODES, equals to set MoteIF.TOS_BCAST_ADDR
		int address = nodeId;
		int returnAddress = app.comm.returnAddress; //OasisConstants.ROOT_ID; 

		//Create RpcCommandMsg
		int rpcMsgSize = RpcCommandMsg.DEFAULT_MESSAGE_SIZE+cmd.dataLength;
		RpcCommandMsg rpcCmdMsg = new RpcCommandMsg(rpcMsgSize);

		//Fill the header of RpcCommandMsg
		rpcCmdMsg.set_transactionID(transactionID);
		rpcCmdMsg.set_commandID((short)cmd.commandID);
		rpcCmdMsg.set_address(address);
		rpcCmdMsg.set_returnAddress(returnAddress);

		//7/12/2007 YFH
		rpcCmdMsg.set_unix_time(app.unix_time);
		rpcCmdMsg.set_user_hash(app.user_hash);	
		
		rpcCmdMsg.set_responseDesired((short)OasisConstants.RPC_RESPONSE_DESIRED);
		rpcCmdMsg.set_dataLength((short)cmd.dataLength);
		
		//Fill data in RpcCommandMsg's payload
		description = fillData(rpcCmdMsg, cmd, type);

		//System.out.println(rpcCmdMsg.get_commandID());
	
		//Register rpcCmdMsg into waitList
		//listener.appendWaitList(nodeID, cmd.name, rpcCmdMsg);

		//Send out message
		int seqNo = app.getSeqNo();
		//8/2/2007
	
		app.comm.sendComm.sendRpc(seqNo, rpcCmdMsg, rpcMsgSize);
		seqNo++;
		app.setSeqNo(seqNo);

		if (screenLog){
			//Display action description on rpcPanel
			actionLog.append(description);
		}
		
		//Write into log file
		writeLog(description);
		
		return transactionID;
	}


    /**
	 * Fill data in RpcCommandMsg's payload
	 * Be careful for data type of each parameter listed in Rpc.StructArgs.params
	 */
	static public String fillData(RpcCommandMsg rpcCmdMsg, 
		                          Rpc.StructArgs cmd, 
		                          short type)
	{
		String ID=null, paramlist="";
		Enumeration e, ev;
        byte [] subdata;
		short [] data = null;
		NescDecls._ParamField field = null;
		int start=0, len=0, i=0, j=0, k=0;
		long tempValue;
		int y = 0;

		//Fill in the payload of rpcCmdMsg 
		if (type == RPC){
			if (cmd.dataLength > 0){
				data = new short[cmd.dataLength];
				paramlist = fillDataRpc(data, pvListRpc, start, y);
			}
		}
		else{
			if (cmd.dataLength > 0 ) {
			    //fill in the common part for PEEK and POKE
				data = new short[cmd.dataLength];

				ev = srvalues.elements();
				//Get nescStruct of ramcmd
				NescDecls.nescStruct ramstruct = new NescDecls.nescStruct();
				NescApp.getStruct("RamSymbolsM.peek", ramstruct);  
			
				for (e = ramstruct.fields.elements(); e.hasMoreElements(); ) {
					 //for print only
					if (y!=0) paramlist +=", "; y++; 

					field = (NescDecls._ParamField)e.nextElement();
					start = field.bitOffset/8;
					len = field.bitSize/8;
					Object v = ev.nextElement();
					tempValue = Long.parseLong(v.toString());
					subdata = Util.value2mBytes(tempValue, len);
					for (i=start; i<start+len; i++) {
						data[i] = (short)subdata[i-start];
					}
					paramlist += tempValue;	
				}
			
				//Continue for POKE: add symbol values
				if (type == POKE){
					String paramlist2 = fillDataParam(data, pvListRam, start+len, y);
					paramlist +=paramlist2;
				}
			}
		}

		//Set data in rpcCmdMsg
		if (data != null)
			rpcCmdMsg.set_data(data);

		
		if (nodeID == null){
			nodeID = new Vector();
			nodeID.add(new Integer(OasisConstants.ALL_NODES));
		}
		//Record action in log panel
		if (nodeID.size() == 1){
			int moteNo = Integer.parseInt(nodeID.get(0).toString());
			if (moteNo ==  OasisConstants.ALL_NODES){
				ID = "ALL";
			}
			else ID = Integer.toString(moteNo);
		}
		else {
			String listOfmote = "";
			for (int index = 0 ; index <nodeID.size(); index++){
				int moteNo = Integer.parseInt(nodeID.get(index).toString());
				listOfmote += listOfmote + moteNo + ", ";	
			}
		}

		String RPCCommandInfo = "To [ "+ID+" ]  "+ new Date()+ ": CmdID="+rpcCmdMsg.get_commandID()
			                    +"  Call " + cmd.name + "(  " + paramlist + " )\n";
		
		String actionDescript = RPCCommandInfo;
		//7/30/2008 Andy	Log RPC Command to event log file
		String logOutput = monitor.Util.getDateTime()   + " : " + "COMMAND: " + RPCCommandInfo;
		try {
					MainClass.eventLogger.write( logOutput +"\n");
					MainClass.eventLogger.flush();			
					System.out.println(logOutput);
			}
		catch (Exception ex){}
		//7/30/2008 End 

		return actionDescript;
	}


	static public String fillDataRpc(short [] data, Vector list, int start, int y)
	{
		String paramlist = "";
		ParamEditor._TableParam field;
		int len = 0;
		long tempValue;
        byte [] subdata;
		int i;

		for (Enumeration e = list.elements(); e.hasMoreElements(); ) {
			//for screenlog only
			if (y!=0) paramlist +=", "; y++; 

			field = (ParamEditor._TableParam)e.nextElement();
			start += len;
			len = NescApp.getsize(field.Ttype);
			tempValue = Long.parseLong((String)(field.Tvalue));
			subdata = Util.value2mBytes(tempValue, len);
			for (i=start; i<start+len; i++) {
				data[i] = (short)subdata[i-start];
			
			}
			paramlist += tempValue;	
		}
		
		return paramlist;

	}


   static public String fillDataParam(short [] data, Vector list, int start, int y)
	{
		String paramlist = "";
		ParamEditor._TableParam field;
		int len = 0;
		long tempValue;
       	byte [] subdata;
		int i;
		int at;
		
		for (Enumeration e = list.elements(); e.hasMoreElements(); ) {
			//for screenlog only
			if (y!=0) paramlist +=", "; y++; 

			field = (ParamEditor._TableParam)e.nextElement();

			at = start + field.byteOffset/8;
			len = app.getsize(field.Ttype);
						
			try {
				tempValue = Long.parseLong((String)(field.Tvalue));
			}
			catch (Exception ex) {
				JOptionPane.showMessageDialog(null,
							"Input data is not correct",
							"WARNING",
							JOptionPane.ERROR_MESSAGE);
				return "";
			}
			subdata = Util.value2mBytes(tempValue, len);
			/*
			System.out.println(field.Tname + " : " + field.Ttype + " : " + field.byteOffset);
			System.out.println(data.length + "   " + start + "    " + (start+len) );
			*/
			
			for (i=at; i<at+len; i++) {
				data[i] = (short)subdata[i-at];
			}
			paramlist += tempValue;	
		}
		return paramlist;

	}

		
	//--------------------------------------------------------------------------
	/**
	 *  Basic functions
	 */
	static public void writeLog(String descript)
	{
		File file;
		BufferedWriter outstream;

		try {
			//Get log file
			String logfile =OasisConstants.LogPath+"/rpc.log";
			//logfile.replace('/','\\');
			boolean exists = (new File(logfile)).exists();
			if (!exists) {
				//create a new, empty log file
				try {
					file = new File(logfile);
					boolean success = file.createNewFile();
				} catch (IOException e) {
					System.out.println("Create log file failed!");
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

	//--------------------------------------------------------------------------


static public void sendRpcCmdMsgLocation(int nodeId, 
		                             Rpc.StructArgs cmd, 
									 short type,
									 boolean screenLog, Vector pvListRpc)
	{
		String description = null;
		
		//Provide infos to fill in RpcHeader
		transactionID = (short)((int)(transactionID + 1) % 256);

		//For ALL_NODES, equals to set MoteIF.TOS_BCAST_ADDR
		int address = nodeId;
		int returnAddress = app.comm.returnAddress; //OasisConstants.ROOT_ID; 

		//Create RpcCommandMsg
		int rpcMsgSize = RpcCommandMsg.DEFAULT_MESSAGE_SIZE+cmd.dataLength;
		RpcCommandMsg rpcCmdMsg = new RpcCommandMsg(rpcMsgSize);

		//Fill the header of RpcCommandMsg
		rpcCmdMsg.set_transactionID(transactionID);
		rpcCmdMsg.set_commandID((short)cmd.commandID);
		rpcCmdMsg.set_address(address);
		rpcCmdMsg.set_returnAddress(returnAddress);

		//7/12/2007 YFH
		rpcCmdMsg.set_unix_time(app.unix_time);
		rpcCmdMsg.set_user_hash(app.user_hash);	
		
		rpcCmdMsg.set_responseDesired((short)OasisConstants.RPC_RESPONSE_DESIRED);
		rpcCmdMsg.set_dataLength((short)cmd.dataLength);
		
		//Fill data in RpcCommandMsg's payload
		description = fillDataLocation(rpcCmdMsg, cmd, type,pvListRpc);

		//System.out.println(rpcCmdMsg.get_commandID());
	
		//Register rpcCmdMsg into waitList
		//listener.appendWaitList(nodeID, cmd.name, rpcCmdMsg);

		//Send out message
		int seqNo = app.getSeqNo();
		//8/2/2007
	
		app.comm.sendComm.sendRpc(seqNo, rpcCmdMsg, rpcMsgSize);
		seqNo++;
		app.setSeqNo(seqNo);

		if (screenLog){
			//Display action description on rpcPanel
			actionLog.append(description);
		}
		
		//Write into log file
		writeLog(description);
		

	}


    /**
	 * Fill data in RpcCommandMsg's payload
	 * Be careful for data type of each parameter listed in Rpc.StructArgs.params
	 */
	static public String fillDataLocation(RpcCommandMsg rpcCmdMsg, 
		                          Rpc.StructArgs cmd, 
		                          short type, Vector pvListRpc)
	{
			

		String ID=null, paramlist="";
		Enumeration e, ev;
        byte [] subdata;
		short [] data = null;
		NescDecls._ParamField field = null;
		int start=0, len=0, i=0, j=0, k=0;
		long tempValue;
		int y = 0;

		//Fill in the payload of rpcCmdMsg 
		if (type == RPC){
			if (cmd.dataLength > 0){
				
				data = new short[cmd.dataLength];
				paramlist = fillDataRpc(data, pvListRpc, start, y);
			}
		}
		else{
			if (cmd.dataLength > 0 ) {
			    //fill in the common part for PEEK and POKE
				data = new short[cmd.dataLength];

				ev = srvalues.elements();
				//Get nescStruct of ramcmd
				NescDecls.nescStruct ramstruct = new NescDecls.nescStruct();
				NescApp.getStruct("RamSymbolsM.peek", ramstruct);  
			
				for (e = ramstruct.fields.elements(); e.hasMoreElements(); ) {
					 //for print only
					if (y!=0) paramlist +=", "; y++; 

					field = (NescDecls._ParamField)e.nextElement();
					start = field.bitOffset/8;
					len = field.bitSize/8;
					Object v = ev.nextElement();
					tempValue = Long.parseLong(v.toString());
					subdata = Util.value2mBytes(tempValue, len);
					for (i=start; i<start+len; i++) {
						data[i] = (short)subdata[i-start];
					}
					paramlist += tempValue;	
				}
			
				//Continue for POKE: add symbol values
				if (type == POKE){
					String paramlist2 = fillDataParam(data, pvListRam, start+len, y);
					paramlist +=paramlist2;
				}
			}
		}

		//Set data in rpcCmdMsg
		if (data != null)
			rpcCmdMsg.set_data(data);

		
		if (nodeID == null){
			nodeID = new Vector();
			nodeID.add(new Integer(OasisConstants.ALL_NODES));
		}
		//Record action in log panel
		if (nodeID.size() == 1){
			int moteNo = Integer.parseInt(nodeID.get(0).toString());
			if (moteNo ==  OasisConstants.ALL_NODES){
				ID = "ALL";
			}
			else ID = Integer.toString(moteNo);
		}
		else {
			String listOfmote = "";
			for (int index = 0 ; index <nodeID.size(); index++){
				int moteNo = Integer.parseInt(nodeID.get(index).toString());
				listOfmote += listOfmote + moteNo + ", ";	
			}
		}
		
	

		String actionDescript = "To [ "+ID+" ]  "+ new Date()+ ": CmdID="+rpcCmdMsg.get_commandID()
			                    +"  Call " + cmd.name + "(  " + paramlist + " )\n";
		
		return actionDescript;
	}


}


