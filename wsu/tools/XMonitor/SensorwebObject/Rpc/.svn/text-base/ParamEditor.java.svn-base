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
 * This Class provides a Input editor, with only the 
 * ``Run'' and ``Cancel'' functions
 * 
 * When the window signals a WindowClosed event the user can 
 * check the ID of the WindowEvent to discriminate before the 
 * RUN or the CANCEL action.
 *
 */


package SensorwebObject.Rpc;


import SensorwebObject.Rpc.Rpc.StructArgs;
import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import java.awt.event.*;

import javax.swing.JTable;
import javax.swing.table.TableColumn;

import javax.swing.table.AbstractTableModel;
import javax.swing.event.TableModelEvent;
import javax.swing.event.TableModelListener;
import javax.swing.table.DefaultTableModel;

import java.util.Vector;
import java.util.Enumeration;
import org.w3c.dom.Element;

import javax.swing.JOptionPane;
import javax.swing.ButtonGroup;

public class ParamEditor extends javax.swing.JDialog implements KeyListener{ 
	
	public static final int		CANCEL      = 100;
	public static final int		RUN			= 101;

	private JPanel			jContentPane	= null;
	private JScrollPane		jScrollPane		= null;
	public JTable   		jParamTable		= null;
    public DefaultTableModel tm             = null; 

	private JButton			jCmdCancel		= null;
	private JButton			jCmdRun 		= null;
	private JPanel			jPanel			= null;

	public static Vector    values          = null; 
	public Vector			ret             = null;
	public Rpc.StructArgs	rpcArgs			= null;
	public RamSymbols.RamArgs ramArgs       = null;
	public Vector			pvList		  	= null;
	public Vector			plist			= new Vector();
	public boolean			allowToSend		= true;
	public static int 		byteOffset 		= 0;	
	//public static NescApp 			app				= null;
	public Vector fieldList;
	public static Vector valuesList = new Vector();
	
	/**
	 * This is the default constructor for the editor
	 * @param title    The dialog title
	 * @param content  The content to show in the editor
	 */
	public ParamEditor(JFrame frame,
		               String title, 
					   Rpc.StructArgs rpcArgs,
		               RamSymbols.RamArgs ramArgs,		 
					   Vector pvList,
		               Vector ret,
		               Vector fieldList) {// throws
  		super(frame);
  		valuesList = new Vector();
		this.rpcArgs = rpcArgs;
		this.ramArgs = ramArgs;
		this.pvList = pvList;
		this.ret = ret;
		this.fieldList = fieldList;
		ret.addElement(new Integer(0));

		this.setTitle("Set Parameters for "+title);

		this.setSize(500,300);
		this.setContentPane(getJContentPane());
		this.setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
		this.setLocationRelativeTo(null);


		this.setModal(true); 

	}

    


	/**
	 * This method initializes jContentPane
	 * 
	 * @return javax.swing.JPanel
	 */
	private JPanel getJContentPane() {
		if (jContentPane == null) {
			jContentPane = new JPanel();
			jContentPane.setPreferredSize(new java.awt.Dimension(450, 300));
			jContentPane.setLayout(new BorderLayout());
			jContentPane.add(getJScrollPane(),java.awt.BorderLayout.CENTER);
			jContentPane.add(getJPanel(),java.awt.BorderLayout.SOUTH);
		}
		return jContentPane;
	}


	/**
	 * This method initializes jScrollPane
	 * 
	 * @return javax.swing.JScrollPane
	 */
	private JScrollPane getJScrollPane() {
		if (jScrollPane == null) {
			jParamTable = getJParamTable();
			jScrollPane = new JScrollPane(jParamTable);
			jScrollPane.setPreferredSize(new Dimension(450, 270));
			jScrollPane.setSize(new Dimension(350, 170));
			jScrollPane.setName("jScrollPane");
		}
		return jScrollPane;
	}


	private JTable getJParamTable() {
		if (jParamTable == null) {
			Enumeration e, te;
			tm= new tModel();
			jParamTable = new JTable(tm);
			jParamTable.addKeyListener(this);
			jParamTable.putClientProperty("terminateEditOnFocusLost", Boolean.TRUE); 
			
			tm.addColumn("Parameter Name");
			tm.addColumn("Type");		
			tm.addColumn("Value");
			TableColumn column = null;
			for (int i = 0; i < 2; i++) {
				column = jParamTable.getColumnModel().getColumn(i);
				if (i == 0) {
					column.setPreferredWidth(150); //first column is bigger
				} else {
					column.setPreferredWidth(50);
				}
			}

			for (int j = 0;  j < fieldList.size(); j++){
					RpcField field = (RpcField) fieldList.get(j);
					Object [] newrow3 = {field.name,field.size, ""};
					tm.addRow(newrow3);
					plist.addElement(field);
			}
		
			


			Font font = new Font("font", Font.PLAIN, 12);
			jParamTable.setFont(font);

			jParamTable.getModel().addTableModelListener(new TableModelListener() {
				public void tableChanged(TableModelEvent e) {
						//System.out.println("Event = "+ e.getType());
						//System.out.println("cell value = "+ tm.getValueAt(e.getFirstRow(), e.getColumn()));
				}
			});
		}
		return jParamTable;
	}

	/*
	static public Vector getParamList(NescDecls._ParamTuple fieldInfo) {
		int i;
		String arrayStr;
		String structName;
		Enumeration e, fe, ffe;
		_TableParam tp;
		NescDecls._ParamTuple fInfo;
		Vector temp;
		Vector ret = new Vector();
		
		//Base case: a simple type
		if (fieldInfo.type.fieldtype == null && fieldInfo.type.typename != null) {
			tp = new _TableParam(fieldInfo.name, fieldInfo.type.typename, "");
			byteOffset = fieldInfo.type.offset;
			tp.byteOffset = byteOffset;
			tp.hadByteOffset = true;
			ret.addElement(tp);	
		
			return ret;
		}

		//Embedded type: array
		if (fieldInfo.type.isArray) {
			fInfo = new NescDecls._ParamTuple(fieldInfo.name, fieldInfo.type.fieldtype);
			temp = getParamList(fInfo);
			int fieldSize = 0;


			while (fInfo.type.fieldtype!= null){
				fInfo.type = fInfo.type.fieldtype;
			}
			fieldSize = app.getsize(fInfo.type.typename) * 8;
		
			//add str "[]" for each param
			for (i=0; i<fieldInfo.type.arraySize; i++) {
				arrayStr = "["+i+"] ";
				for (e = temp.elements(); e.hasMoreElements(); ) {
					tp = (_TableParam)e.nextElement();
					_TableParam tpp = new _TableParam(tp.Tname+arrayStr, tp.Ttype, tp.Tvalue);
					byteOffset = fieldInfo.type.offset;
					//System.out.println("Print out in ParamEditor " + fieldSize + " : " + fInfo.type.typename);
					if (!tp.hadByteOffset){
						tpp.byteOffset = byteOffset + i * fieldSize ; 
					}
					else {
						//System.out.println(tpp.Tname);
						tpp.byteOffset  = byteOffset +  tp.byteOffset + i * fieldSize ;
						tpp.hadByteOffset = true;
					}
					ret.addElement(tpp);
				}
			}
			
			return ret;
		}

		//Embedded type: struct
		if (fieldInfo.type.isStruct) {
			fInfo = new NescDecls._ParamTuple(fieldInfo.name, fieldInfo.type.fieldtype);
			temp = getParamList(fInfo);
			
			//get the name of the struct
			e = temp.elements(); 
			tp = (_TableParam)e.nextElement();

			//get the struct
			NescDecls.nescStruct fstruct = new NescDecls.nescStruct();
			app.getStruct(tp.Ttype, fstruct);

			//go through each field
			for (fe = fstruct.values.elements(); fe.hasMoreElements(); ) {
				NescDecls._ParamTuple fp = (NescDecls._ParamTuple)fe.nextElement();
				temp = getParamList(fp);

				//add struct name to each field
				for (ffe = temp.elements(); ffe.hasMoreElements(); ) {
					_TableParam fpp = (_TableParam)ffe.nextElement();
					_TableParam fppp = new _TableParam(tp.Ttype+"."+fpp.Tname, fpp.Ttype, fpp.Tvalue);
						if (!fpp.hadByteOffset){
							fppp.byteOffset = byteOffset;
						}
						else {
							fppp.byteOffset  =  fpp.byteOffset;
							fppp.hadByteOffset= true;
						}
					ret.addElement(fppp);
				}
			}
			return ret;
		}

		return ret;
	}
	*/


	static public class _TableParam
	{
		public String Tname;
		public String Ttype;
		public String Tvalue;
		public int byteOffset;
		public boolean hadByteOffset = false;
			
		public _TableParam()
		{
			Tname = null;
			Ttype = null;
			Tvalue = null;
		}
	
		public _TableParam(String Tname, String Ttype, String Tvalue)
		{
			this.Tname = Tname;
			this.Ttype = Ttype;
			this.Tvalue = Tvalue;
		}
	};



	public class tModel extends DefaultTableModel{
		
		public tModel() {}
		
		public boolean isCellEditable(int row, int column)
		{
			if (column == 0 || column == 1)
					return false;					
			return true;
		}
	}



	/**
	 * This method initializes jPanel
	 * 
	 * @return javax.swing.JPanel
	 */
	private JPanel getJPanel() {
		if (jPanel == null) {
			jPanel = new JPanel();
			jPanel.setLayout(new GridLayout(1,2,5,5));
			jPanel.setPreferredSize(new Dimension(500, 40));
			jPanel.add(getJCmdRun());
			jPanel.add(getJCmdCancel());

			//Group buttons.
			ButtonGroup group = new ButtonGroup();
			group.add(jCmdRun);
			group.add(jCmdCancel);
			//jCmdRun.setSelected(true);
			//jCmdRun.requestFocusInWindow();
			//jCmdRun.getFocus();
		}
		return jPanel;
	}


	/**
	 * This method initializes jCmdCancel
	 * 
	 * @return javax.swing.JButton
	 */
	private JButton getJCmdCancel() {
		if (jCmdCancel == null) {
			jCmdCancel = new JButton();
			//jCmdCancel.setPreferredSize(new Dimension(150, 30));
			jCmdCancel.setText("Cancel");
			jCmdCancel.setName("jCmdCancel");
			jCmdCancel.addActionListener(new java.awt.event.ActionListener() {
				public void actionPerformed(java.awt.event.ActionEvent e) {
					CancelButtonEvent();
				}
			});
		}
		return jCmdCancel;
	}


	/**
	 * This method initializes jCmdRun
	 * 
	 * @return javax.swing.JButton
	 */
	private JButton getJCmdRun() {
		if (jCmdRun == null) {
			jCmdRun = new JButton();
			//jCmdRun.setPreferredSize(new Dimension(150, 30));
			jCmdRun.setText("Run");
			jCmdRun.setName("jCmdRun");
			jCmdRun.addActionListener(new java.awt.event.ActionListener() {
				public void actionPerformed(java.awt.event.ActionEvent ee) {
					RunButtonEvent();
				}
			});
		}
		return jCmdRun;
	}


		public void keyTyped(KeyEvent e) {}
		
		public void keyReleased(KeyEvent e) {}

		public void keyPressed(KeyEvent e) {
			int keyCode = e.getKeyCode();
			if (KeyEvent.getKeyText(keyCode).equals("Enter")){
				//System.out.println(KeyEvent.getKeyText(keyCode) + "" );
				RunButtonEvent();
			}
			else if (KeyEvent.getKeyText(keyCode).equals("Escape")){
				//System.out.println(KeyEvent.getKeyText(keyCode) + "" );
				CancelButtonEvent();
			}
				
			
		}
		 

		private void RunButtonEvent(){
			//jParamTable.revalidate();
			//jParamTable.updateUI();
			
			//check ramsymbol size
					if (!allowToSend) {
						JOptionPane.showMessageDialog(null,
							"The selected symbol is too large to Set.",
							"WARNING",
							JOptionPane.ERROR_MESSAGE);
						//set return value for calling panel
						ret.clear();
						ret.addElement(new Integer(0));
						return;
					};

					int i;
					//YFHCheck: value is valid or not
					for (i= 0; i<tm.getRowCount(); i++) {
						//tm.fireTableCellUpdated(i, 2);
						Object value = tm.getValueAt(i, 2);
						//Test whether any input is missing
						if(value == null || ((value instanceof String)&&((String)value).length() == 0)){
							javax.swing.JOptionPane.showMessageDialog(
								null,
								"The value for "+ (tm.getValueAt(i, 0)).toString()
								+ " is invalid! \n",								
								"Warning",
								JOptionPane.WARNING_MESSAGE);
							//set return value for calling panel
							ret.clear();
							ret.addElement(new Integer(0));
							return;
						}
					}

					//Put valid values into pvList
					//values.clear();
					RpcField field;
					Enumeration e = plist.elements(); 		
					for (i= 0; i<tm.getRowCount(); i++) {
						field = (RpcField)(e.nextElement());
						field.value = (tm.getValueAt(i, 2)).toString();
						System.out.println(field.value );
						for (int j = 0 ; j < fieldList.size(); j++){
							RpcField rpcField = (RpcField) fieldList.get(j);
							if (rpcField.name.equals(tm.getValueAt(i, 0))){
								rpcField.value = field.value;
								valuesList.add(rpcField);
							}
						}
					}
					
				

					//set return value for calling panel
					pvList.clear();
					for (Enumeration eee = plist.elements(); eee.hasMoreElements(); ) {
						pvList.addElement(eee.nextElement());
					}

					//pvList = plist;
					ret.clear();
					ret.addElement(new Integer(1));
			        
					//All values are valid, notify the listeners
					/*WindowListener[] listeners = ParamEditor.this.getWindowListeners();
					for (i = 0; i< listeners.length; i++){
							listeners[i].windowClosed(new WindowEvent(ParamEditor.this, RUN));
					}*/
					ParamEditor.this.dispose();
				
		}

		private void CancelButtonEvent(){
				ret.clear();
				ret.addElement(new Integer(0));
				ParamEditor.this.dispose();
		}

}
