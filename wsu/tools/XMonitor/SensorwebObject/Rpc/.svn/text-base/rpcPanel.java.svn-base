package SensorwebObject.Rpc;

import Config.OasisConstants;
import java.io.*;
import java.util.*;
import java.text.*;
import java.io.File;

import java.awt.*;
import java.awt.event.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.*;
import javax.swing.event.*;


import javax.swing.border.TitledBorder;





import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.Component;
import monitor.ControlPanelDialog;
import rpc.message.MessageListener;
import rpc.message.MoteIF;
import xml.Parser.XMLMessageParser;
import xml.RemoteObject.StreamDataObject;
import rpc.message.*;

public class rpcPanel extends JPanel implements ActionListener, MessageListener {

    static public Vector rpcCommandObject;
    //public rpcMessageDriver listener;
    //static public Vector nodeID;
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
    static public Rpc.StructArgs rpccmd = null,  ramcmd = null;
    static public NescDecls.nescStruct rpcstruct = null,  ramstruct = null,  symbolstruct = null;
    static public Vector pvListRpc = new Vector();
    static public Vector pvListRam = new Vector();
    static public String prevCmd = "";
    static public String prevRam = "";
    static public short tempValue = 0;
    int currentTransID = -1;

    //For RpcFrame panel
    //public JButton selectNewMotes = new JButton("Select new motes");
    //public JButton resetBt = new JButton("ResetSeq");

    //For Rpc subpanel
    public JComboBox cmdList;
    public JButton sendcmdBt = new JButton("Run ...");
    /*
    //For RamSymbols subpanel
    public JComboBox ramsList;
    public JComboBox ramcmdList;
    public JButton sendramBt = new JButton("Run ...");
     */
    //For Log subpanel
    static public JTextArea actionLog;
    public ParamEditor editor;
    static public Enumeration e;
    static public JFrame mainFrame;
    public ControlPanelDialog parentDialog;
    private JFrame mainWindow;
    XMLMessageParser xmp;
    MoteIF mote;

    public rpcPanel(XMLMessageParser xmp, MoteIF mote, JTextArea actionLog, JFrame mainWindow) {
        this.mainWindow = mainWindow;
        this.mainFrame = mainFrame;
        this.mote = mote;
        this.mote.registerListener("response", this);
        //this.nodeID = nodeID;
        this.actionLog = actionLog;
        this.xmp = xmp;
        this.rpcCommandObject = xmp.obtaRinRpcCommands();
        //Set up message listener for RpcResponseMsg
        //listener = new rpcMessageDriver(app);
        //app.comm.receiveComm.registerListener(Constants.NW_RPCR, listener);

        //Set layout
        layout = new GridBagLayout();
        setLayout(layout);
        constraints = new GridBagConstraints();
        /*
        resetBt.addActionListener(this);
        resetBt.setSize( new java.awt.Dimension( 2, 30 ) );
        selectNewMotes.addActionListener(this);
        selectNewMotes.setSize( new java.awt.Dimension( 2, 30 ) );
         */


        //Remote Control SubPanel
        JPanel rpc = new JPanel();
        TitledBorder paneEdge1 = BorderFactory.createTitledBorder("Remote Procedure Call :");
        rpc.setBorder(paneEdge1);
        rpc.setLayout(new GridLayout(1, 2, 2, 2));

        //For rpc functions
        Vector rpcList = rpcCommandObject;
        Vector cmds = new Vector();

        //System.out.println(rpcList);

        for (int i = 0; i < rpcList.size(); i++) {
            RpcObject rpcObject = (RpcObject) rpcList.get(i);
            cmds.addElement(rpcObject.name);

        }

        //sort rpccmd vector by position in alphabet
        Collections.sort(cmds, Collator.getInstance());

        cmdList = new JComboBox(cmds);
        rpc.add(cmdList);

        JPanel rpc2 = new JPanel();
        rpc2.setLayout(new GridLayout(1, 1, 2, 2));
        rpc2.add(sendcmdBt);
        sendcmdBt.addActionListener(this);
        rpc.add(rpc2);

        //RamSymbols SubPanel
			/*
        JPanel rams = new JPanel();
        TitledBorder paneEdge2 = BorderFactory.createTitledBorder("Parameter Query/Adjustment :");
        rams.setBorder(paneEdge2);
        rams.setLayout(new GridLayout(1,2,2,2));

        Vector rList = new Vector();
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
         */
        /*
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
         */

        constraints.fill = GridBagConstraints.NONE;
        constraints.anchor = GridBagConstraints.EAST;
        /*
        setConstraints(resetBt, 0, 5, 4, 1);
        add(resetBt);
        setConstraints(selectNewMotes, 0, 4, 4, 1);
        add(selectNewMotes);
         */
        constraints.fill = GridBagConstraints.HORIZONTAL;
        constraints.weightx = 1000;
        setConstraints(rpc, 1, 0, 9, 2);
        add(rpc);
        /*
        setConstraints(rams, 3, 0, 9, 2);
        add(rams);
         */
        /*
        final String sendRamBt = "Send ram";
        sendramBt.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),sendRamBt);
        sendramBt.getActionMap().put(sendRamBt, new AbstractAction() {
        public void actionPerformed(ActionEvent ignored) {
        // sendramBt_Action();
        }
        });
         */

        final String sendCmdBt = "Send cmd";
        sendcmdBt.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"), sendCmdBt);
        sendcmdBt.getActionMap().put(sendCmdBt, new AbstractAction() {

            public void actionPerformed(ActionEvent ignored) {
                //   sendcmdBt_Action();
            }
        });

    /*
    final String reset_Bt = "Reset";
    resetBt.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),reset_Bt);
    resetBt.getActionMap().put(reset_Bt, new AbstractAction() {
    public void actionPerformed(ActionEvent ignored) {
    resetBt_Action();
    }
    });*/

    /*
    final String selectNewMote = "Select New Mote";
    selectNewMotes.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),selectNewMote);
    selectNewMotes.getActionMap().put(selectNewMote, new AbstractAction() {
    public void actionPerformed(ActionEvent ignored) {
    selectNewMotesBt_Action();
    }
    });
     */

    }

    private void setConstraints(Component component,
            int row, int column, int width, int height) {
        constraints.gridx = column;
        constraints.gridy = row;
        constraints.gridwidth = width;
        constraints.gridheight = height;
        layout.setConstraints(component, constraints);
    }

    public void setControlPanelDialog(ControlPanelDialog _parentDialog) {
        parentDialog = _parentDialog;
    }

    /**
     * This method is required by ActionListener
     */
    public void actionPerformed(ActionEvent e) {
        Object src = e.getSource();
        if (src == sendcmdBt) {
            try {
                sendcmdBt_Action();
            } catch (IOException ex) {
                Logger.getLogger(rpcPanel.class.getName()).log(Level.SEVERE, null, ex);
            }
        } /*
    else if (src == sendramBt) {
    //sendramBt_Action();
    }

    else if (src == resetBt) {
    resetBt_Action();
    }
    else if (src == selectNewMotes) {
    selectNewMotesBt_Action();
    } */
    }

    public void resetBt_Action() {
        //rpcCommandObject.clearSeqNo();
    }

    public void selectNewMotesBt_Action() {
        //parentDialog.dispose();
        //((MainFrame)mainFrame).menuItemSendRPC_action();
    }

    /**
     * This method responds to send rpc command button
     * First, it opens a subpanel to accept the parameter setting for selected RPC function
     * from the user, and save them into global variable "values"
     * Then, it gets the rpc function that user selects
     * and call SendRpcCmdMsg() with type = RPC to sent it out
     */
    public void sendcmdBt_Action() throws IOException {
        Enumeration e;
        String pnames = "";

        //Get selected command
		/*
        String command = (String)cmdList.getSelectedItem();

        //Get the corresponding info in Rpc.StructArgs
        rpccmd = app.rpcs.findRpcFunc(command);
         */

        String command = (String) cmdList.getSelectedItem();
        Vector fieldList = null;
        for (int i = 0; i < rpcCommandObject.size(); i++) {
            RpcObject rpcObject = (RpcObject) rpcCommandObject.get(i);
            if (rpcObject.name.equals(command)) {
                //System.out.println("rpcObject.rpcCommandFieldList.size(): " + rpcObject.rpcCommandFieldList.size());
                fieldList = rpcObject.rpcCommandFieldList;
            }
        }


        if (fieldList != null) {


            if (prevCmd != command) {
                pvListRpc.clear();
                prevCmd = command;
            }
            //Open parameter editor,get values and put into rvalues
            Vector ret = new Vector();
            editor = new ParamEditor(mainFrame, command,
                    rpccmd, null,
                    pvListRpc, ret, fieldList);
            editor.show();
            Enumeration r = ret.elements();
            int tv = Integer.parseInt((r.nextElement()).toString());
            switch (tv) {
                case DIALOG_CANCEL:
                    break;
                case DIALOG_RUN:
                    RpcSender_Object_Client rpcObject = new RpcSender_Object_Client();
                    rpcObject.setFieldValue(editor.valuesList);
                    rpcObject.setFunctionName(command);
                    //mainWindow.sendRpcCommand(rpcObject);
                    byte[] packets = xmp.processRPCCommands(fieldList, command);
                    String RPCCommandInfo = new Date()+ ": "
                +"  Call " + command + "(  " + fieldList + " )\n";
                this.actionLog.append(RPCCommandInfo);
                    //Dump.dump("rpcPanel",packets);
                    mote.send(packets);
                    break;
            }
        } else {
            //YFHCheck:
            System.out.println("In rpcPanel.paramBt_Action(): no _Struct for rpc command: " + rpccmd.name);
        }
    }

   
    /**
     * Send RpcCommandMsg through app.comm.sendCommc
     */
    static public void sendRpcCmdMsg(int nodeId,
            Rpc.StructArgs cmd,
            short type,
            boolean screenLog) {

        /*

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

        rpcCmdMsg.set_responseDesired((short)Constants.RPC_RESPONSE_DESIRED);
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

         */
    }


    //--------------------------------------------------------------------------
    /**
     *  Basic functions
     */
    static public void writeLog(String descript) {
        File file;
        BufferedWriter outstream;

        try {
            //Get log file
            String logfile = Constants.LogPath + "/rpc.log";
            logfile.replace('/', '\\');
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
        } catch (java.lang.Exception e) {
        }
    }

    public void destroy() {
        //which panel should be removed
    }

    public void start() {
    }

    public void stop() {
    }

    public void stateChanged(ChangeEvent e) {
    }

    public void makeRPC_Panel(int width, int height) {
        // TODO Auto-generated method stub
    }

   
    public void messageReceived(String typeName, Vector streamEvent) {
        String response = null;
        String returnValue = "Return : Wrong XML";
	int retValue = 0;
        int transactionID = ((Integer) (((StreamDataObject) streamEvent.get(0)).data.get(0))).intValue();
        int commandID = ((Integer) (((StreamDataObject) streamEvent.get(1)).data.get(0))).intValue();
        int sourceAddress = ((Integer) (((StreamDataObject) streamEvent.get(2)).data.get(0))).intValue();
        int errorCode = ((Integer) (((StreamDataObject) streamEvent.get(3)).data.get(0))).intValue();
        int size = ((Integer) (((StreamDataObject) streamEvent.get(4)).data.size()));

        byte[] receivedData = new byte[size];
        int tmp = 0;
        for (int i = 0; i < size; i++) {
            tmp = ((Integer) (((StreamDataObject) streamEvent.get(4)).data.get(i))).intValue();
            receivedData[i] = (byte) (tmp);
        }


        //Discard message with lower transID (older ones)
/*
        if (transactionID >= currentTransID) {
            currentTransID = transactionID;
        } else {
            return;
        }
*/
        //Check for duplication & update recvlist
        //boolean recv = updateRecvList(new RpcResponseMsg(transactionID, commandID, sourceAddress));

        //Display new response msg
        //if ((!recv)) {
        if(true){
            int id = commandID;
            response = "From [ " + sourceAddress + " ] " + new Date() + " CmdID=" + id + ", " + getErrorType(errorCode) + " \n";
            if (errorCode != OasisConstants.RPC_WRONG_XML_FILE) {
                //Interpret Return Value
                returnValue = "Return : 0";
                if (size > 0) {

                    returnValue = "Return : ";
                    for (int i = 0; i < size; i++) {

                        returnValue += "0x"+Integer.toHexString(receivedData[i]) + " ";	//System.out.println(returnValue+" "+receivedData[i] );
			if(OasisConstants.BIG == false)
				retValue = receivedData[i]*(int)(Math.pow(16,i))+retValue;
			else
				retValue = receivedData[i]+retValue*16;
			
                    }
                }
            }
            //Write to Action Panel
            rpcPanel.actionLog.append(response + returnValue +  "\n"+ "Value: " + retValue + "\n");
            //Write into log file
            //rpcPanel.writeLog(response + returnValue + "\n");
        }


    }

    public String getErrorType(int errorCode) {
        String errorType = null;
        switch (errorCode) {
            case OasisConstants.RPC_SUCCESS:
                errorType = "RPC_SUCCESS";
                break;
            case OasisConstants.RPC_GARBAGE_ARGS:
                errorType = "RPC_GARBAGE_ARGS";
                break;
            case OasisConstants.RPC_RESPONSE_TOO_LARGE:
                errorType = "RPC_RESPONSE_TOO_LARGE";
                break;
            case OasisConstants.RPC_PROCEDURE_UNAVAIL:
                errorType = "RPC_PROCEDURE_UNAVAIL";
                break;
            case OasisConstants.RPC_SYSTEM_ERR:
                errorType = "RPC_SYSTEM_ERR";
                break;
            case OasisConstants.RPC_WRONG_XML_FILE:
                errorType = "RPC_WRONG_XML_FILE";
                break;
            default:
                errorType = "UNKNOWN_TYPE_ERR";
                break;
        }
        return errorType;
    }
    Vector recvlist = new Vector();

    public boolean updateRecvList(RpcResponseMsg rMsg) {
        boolean recvd = false;

        //Check duplication first
        Enumeration e;
        for (e = recvlist.elements(); e.hasMoreElements();) {
            RpcResponseMsg inlist = (RpcResponseMsg) e.nextElement();
            if (rMsg.equals(inlist)) {
                recvd = true;
                break;
            }
        }
        if (!recvd) {
            if (recvlist.size() < OasisConstants.RPC_MAX_BUFFER) {
                recvlist.addElement(rMsg);
            } else {
                recvlist.remove(0);
                recvlist.addElement(rMsg);
            }
        }
        return recvd;
    }

    public class RpcResponseMsg {

        int commandID;
        int transactionID;
        int sourceAddress;

        public RpcResponseMsg(int transactionID, int commandID, int sourceAddress) {

            this.setCommandID(commandID);
            this.setTransactionID(transactionID);
            this.setSourceAddress(sourceAddress);
        }

        public void setCommandID(int commandID) {
            this.commandID = commandID;
        }

        public void setSourceAddress(int sourceAddress) {
            this.sourceAddress = sourceAddress;
        }

        public void setTransactionID(int transactionID) {
            this.transactionID = transactionID;
        }

        public int getCommandID() {
            return commandID;
        }

        public int getSourceAddress() {
            return sourceAddress;
        }

        public int getTransactionID() {
            return transactionID;
        }

        @Override
        public boolean equals(Object obj) {
            if (obj == null) {
                return false;
            }
            if (getClass() != obj.getClass()) {
                return false;
            }
            final RpcResponseMsg other = (RpcResponseMsg) obj;
            if (this.commandID != other.commandID) {
                return false;
            }
            if (this.transactionID != other.transactionID) {
                return false;
            }
            if (this.sourceAddress != other.sourceAddress) {
                return false;
            }
            return true;
        }

        @Override
        public int hashCode() {
            int hash = 5;
            hash = 67 * hash + this.commandID;
            hash = 67 * hash + this.transactionID;
            hash = 67 * hash + this.sourceAddress;
            return hash;
        }
    }
}
