/*
 * Copyright (c) 2003, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 */

package net.tinyos.mcenter;

import net.tinyos.message.SerialPacket;
import net.tinyos.packet.*;
import java.util.*;
import java.util.prefs.*;
import javax.swing.table.*;
import java.awt.event.*;

/**
 * @author  Miklos Maroti (miklos.maroti@vanderbilt.edu)
 */
public class MessageTable extends MessageCenterInternalFrame implements PacketListenerIF
{

	private static final long serialVersionUID = 1L;
	static final int TYPE_INT8 = 1;
	static final int TYPE_UINT8 = 2;
	static final int TYPE_HEX8 = 3;
	static final int TYPE_INT16 = 4;
	static final int TYPE_UINT16 = 5;
	static final int TYPE_HEX16 = 6;
	static final int TYPE_INT32 = 7;
	static final int TYPE_UINT32 = 8;
	static final int TYPE_HEX32 = 9;
	static final int TYPE_FLOAT = 10;
	static final int TYPE_CHAR = 11;
	static final int TYPE_UINT24 = 16;
	static final int TYPE_INT24 = 17;
	static final int TYPE_HEX24 = 18;
	static final int TYPE_BIT = 19;
	static final int TYPE_INT4 = 20;
	static final int TYPE_HEX4 = 21;

	static final int TYPE_NONE = 0;			// invalid type
	static final int TYPE_TIME = 101;		// current time
	static final int TYPE_COUNTER = 102;		// increasing counter

	static final int MODIFIER_OMIT = 0x01;		// do not display this idtem
	static final int MODIFIER_UNIQUE = 0x02;	// must be unique
	static final int MODIFIER_CONST = 0x04;		// value must match title
	static final int MODIFIER_BITWISE = 0x08;		// value must match title

	//Not Static anymore...
	//static final int PACKET_TYPE = 2;
	//static final int PACKET_LENGTH = 4;
	//static final int PACKET_DATA = 5;
	//static final int PACKET_TOTAL = 36;

	public void initFromStr(String initString){
		int idx = Integer.parseInt(initString);
		if (idx > configNameText.getItemCount())
			idx = 0;
		configNameText.setSelectedIndex(idx);
		configNameTextActionPerformed(new java.awt.event.ActionEvent(this, 0, new String()));
	}

	public String getInitStr(){
		return new String( new Integer(configNameText.getSelectedIndex()).toString() );
	}

	private class MyTableModel extends DefaultTableModel
	{

		private static final long serialVersionUID = 1L;

		java.text.SimpleDateFormat timestamp = new java.text.SimpleDateFormat("HH:mm:ss.SSS");

		class Entry
		{
			String title;
			int type;
			int modifier;
			int column;
			String value;
			String defValue;
		};

		ArrayList entries = new ArrayList();
		int[] uniqueEntries = new int[0];		// the index of unique entries
		int packetLength;

		byte[] packet;
		int packetIndex;
		int bitIndex;
		int baseAddress;

		int getBit(){
			return (((int)( packet[baseAddress] & 0xFF)) >> (7-bitIndex++)) & 0x01;
		}

		int getInt4(){
			int ret = (((int)( packet[baseAddress] & 0xFF)) >> (4-bitIndex)) & 0x0F;
			bitIndex += 4;
			return ret;
		}

		byte getByte()
		{
			return (byte)(packet[packetIndex++] & 0xFF);
		}

		short getShort()
		{
			if (bigEndianBox.isSelected())
				return getShortBE();
			else
				return getShortLE();
		}
		short getShortLE()
		{
			return (short)((packet[packetIndex++] & 0xFF)
					+ ((packet[packetIndex++] & 0xFF) << 8));
		}
		short getShortBE()
		{
			return (short)(((packet[packetIndex++] & 0xFF) << 8)
					+ ((packet[packetIndex++] & 0xFF)));
		}

		int getInt24()
		{
			if (bigEndianBox.isSelected())
				return getInt24BE();
			else
				return getInt24LE();
		}

		int getInt24LE()
		{
			return (packet[packetIndex++] & 0xFF)
				+ ((packet[packetIndex++] & 0xFF) << 8)
				+ ((packet[packetIndex++] & 0xFF) << 16);
		}
		int getInt24BE()
		{
			return((packet[packetIndex++] & 0xFF) << 16)
				+ ((packet[packetIndex++] & 0xFF) << 8)
				+ ((packet[packetIndex++] & 0xFF));
		}

		int getInt()
		{
			if (bigEndianBox.isSelected())
				return getIntBE();
			else
				return getIntLE();
		}
		int getIntLE()
		{
			return (packet[packetIndex++] & 0xFF)
				+ ((packet[packetIndex++] & 0xFF) << 8)
				+ ((packet[packetIndex++] & 0xFF) << 16)
				+ ((packet[packetIndex++] & 0xFF) << 24);
		}
		int getIntBE()
		{
			return((packet[packetIndex++] & 0xFF) << 24)
				+ ((packet[packetIndex++] & 0xFF) << 16)
				+ ((packet[packetIndex++] & 0xFF) << 8)
				+ ((packet[packetIndex++] & 0xFF));
		}

		String toHex(int value, int len)
		{
			String a = Integer.toHexString(value);
			String b = "0x";

			for(int i = a.length(); i < len; ++i)
				b += '0';

			b += a;
			return b;
		}

		String decodeField(int type)
		{
			switch(type)
			{
			case TYPE_UINT8:
				return Integer.toString(getByte() & 0xFF);

			case TYPE_INT8:
				return Byte.toString(getByte());

			case TYPE_HEX8:
				return toHex(getByte() & 0xFF, 2);

			case TYPE_UINT16:
				return Integer.toString(getShort() & 0xFFFF);

			case TYPE_INT16:
				return Short.toString(getShort());

			case TYPE_HEX16:
				return toHex(getShort() & 0xFFFF, 4);

			case TYPE_UINT24:
				return Integer.toString(getInt24());

			case TYPE_INT24:
				int a = getInt24();
				return Integer.toString(a < 0x800000 ? a : a - 0x1000000);

			case TYPE_HEX24:
				return toHex(getInt24(), 6);

			case TYPE_UINT32:
				return Long.toString(getInt() & 0xFFFFFFFFL);

			case TYPE_INT32:
				return Integer.toString(getInt());

			case TYPE_HEX32:
				return toHex(getInt(), 8);

			case TYPE_FLOAT:
				return Float.toString(Float.intBitsToFloat(getInt()));

			case TYPE_CHAR:
				return "'" + (char)getByte() + "'";

			case TYPE_TIME:
				return timestamp.format(new java.util.Date());

			case TYPE_COUNTER:
				return "1";

			case TYPE_BIT:
				return Integer.toString(getBit());

			case TYPE_INT4:
				return Integer.toString(getInt4());

			case TYPE_HEX4:
				return toHex(getInt4(), 1);
			}

			return null;
		}

		// returns true if the packet is valid
		boolean decodePacket(byte[] packet)
		{
			SerialPacket sp = new SerialPacket(packet,1);
			if( sp.get_header_length() != packetLength )
				return false;

			this.packet = packet;
			packetIndex = sp.baseOffset()+SerialPacket.offset_data(0);

			Iterator iter = entries.iterator();
			while( iter.hasNext() )
			{
				Entry entry = (Entry)iter.next();
				if( (entry.modifier & MODIFIER_BITWISE) !=0){
					bitIndex = 0;
					baseAddress = packetIndex;
				}
				entry.value = decodeField(entry.type);


				// const value does not match
				if( (entry.modifier & MODIFIER_CONST) != 0 && ! entry.value.equalsIgnoreCase(entry.defValue) )
					return false;
			}

			return true;
		}

		int findReplaceIndex()
		{
			if( uniqueEntries.length == 0 )
				return -1;

			outer: for(int i = 0; i < getRowCount(); ++i)
			{
				for(int j = 0; j < uniqueEntries.length; ++j)
				{
					Entry entry = (Entry)entries.get(uniqueEntries[j]);
					if( ! entry.value.equals(getValueAt(i,entry.column)) )
						continue outer;
				}

				return i;
			}

			return -1;
		}

		void writeRow(int index, boolean updateCounterOnly)
		{
			for(int i = 0; i < entries.size(); ++i)
			{
				Entry entry = (Entry)entries.get(i);
				if( entry.column >= 0 )
				{
					if( entry.type == TYPE_COUNTER )
						entry.value = Integer.toString(parseInt((String)getValueAt(index, entry.column)) + 1);

					if (!updateCounterOnly || entry.type == TYPE_COUNTER)
						setValueAt(entry.value, index, entry.column);
				}
			}
		}

		void addPacket(byte[] packet)
		{
			if( ! decodePacket(packet) )
				return;

			int index = findReplaceIndex();
			if( index < 0 )
			{
				int c = getRowCount();
				setRowCount(c+1);
				rowCount.setText("row count: " + getRowCount());
				writeRow(c, false);
				fireTableRowsInserted(c, c);
			}
			else
			{
				writeRow(index, firstUniqueBox.isSelected());
				fireTableRowsUpdated(index, index);
			}
		}

		void addEntry(Entry entry)
		{
			if( entry.title == null )
				entry.title = "unnamed";

			if( entry.type == TYPE_NONE )
			{
				errorText.setText("missing type");
				return;
			}

			if( (entry.modifier & MODIFIER_OMIT) == 0 )
			{
				entry.column = getColumnCount();
				addColumn(entry.title);
			}
			else
				entry.column = -1;

			entries.add(entry);
		}

		void addEntry(String line)
		{
			int i = line.indexOf(';');
			if( i >= 0 )
				line = line.substring(0, i);

			Entry entry = new Entry();
			entry.type = TYPE_NONE;

			StringTokenizer tokens = new StringTokenizer(line, " \t,");

			while( tokens.hasMoreTokens() )
			{
				String token = tokens.nextToken();
				String ltoken = token.toLowerCase();

				if( ltoken.endsWith("_t") )
					ltoken = ltoken.substring(0, ltoken.length()-2);

				if( entry.type == TYPE_NONE )
				{
					if( ltoken.equals("uint8") )
					{
						entry.type = TYPE_UINT8;
						packetLength += 1;
					}
					else if( ltoken.equals("int8") )
					{
						entry.type = TYPE_INT8;
						packetLength += 1;
					}
					else if( ltoken.equals("hex8") )
					{
						entry.type = TYPE_HEX8;
						packetLength += 1;
					}
					else if( ltoken.equals("uint16") )
					{
						entry.type = TYPE_UINT16;
						packetLength += 2;
					}
					else if( ltoken.equals("int16") )
					{
						entry.type = TYPE_INT16;
						packetLength += 2;
					}
					else if( ltoken.equals("hex16") )
					{
						entry.type = TYPE_HEX16;
						packetLength += 2;
					}
					else if( ltoken.equals("uint24") )
					{
						entry.type = TYPE_UINT24;
						packetLength += 3;
					}
					else if( ltoken.equals("int24") )
					{
						entry.type = TYPE_INT24;
						packetLength += 3;
					}
					else if( ltoken.equals("hex24") )
					{
						entry.type = TYPE_HEX24;
						packetLength += 3;
					}
					else if( ltoken.equals("uint32") )
					{
						entry.type = TYPE_UINT32;
						packetLength += 4;
					}
					else if( ltoken.equals("int32") )
					{
						entry.type = TYPE_INT32;
						packetLength += 4;
					}
					else if( ltoken.equals("hex32") )
					{
						entry.type = TYPE_HEX32;
						packetLength += 4;
					}
					else if( ltoken.equals("float") )
					{
						entry.type = TYPE_FLOAT;
						packetLength += 4;
					}
					else if( ltoken.equals("char") )
					{
						entry.type = TYPE_CHAR;
						packetLength += 1;
					}
					else if( ltoken.equals("bit") )
					{
						entry.type = TYPE_BIT;
						packetLength += 0;
					}
					else if( ltoken.equals("int4") )
					{
						entry.type = TYPE_INT4;
						packetLength += 0;
					}
					else if( ltoken.equals("hex4") )
					{
						entry.type = TYPE_HEX4;
						packetLength += 0;
					}
					else if( ltoken.equals("time") )
						entry.type = TYPE_TIME;
					else if( ltoken.equals("counter") )
						entry.type = TYPE_COUNTER;
					else if( ltoken.equals("omit") )
						entry.modifier |= MODIFIER_OMIT;
					else if( ltoken.equals("unique") )
						entry.modifier |= MODIFIER_UNIQUE;
					else if( ltoken.equals("const") )
						entry.modifier |= MODIFIER_OMIT | MODIFIER_CONST;
					else if( ltoken.equals("bitwise") )
						entry.modifier |= MODIFIER_OMIT |MODIFIER_BITWISE;
					else
					{
						errorText.setText("unknown type or modifier: " + token);
						break;
					}
				}
				else if( ltoken.equals("=") && tokens.hasMoreTokens() )
					entry.defValue = tokens.nextToken();
				else if( entry.title == null )
					entry.title = token;
				else
				{
					errorText.setText("extra token found: " + token);
					break;
				}
			}

			addEntry(entry);
		}

		void updateUniqueEntries()
		{
			int size = 0;
			for(int i = 0; i < entries.size(); ++i)
			{
				Entry entry = (Entry)entries.get(i);
				if( (entry.modifier & MODIFIER_UNIQUE) != 0 )
					++size;
			}

			uniqueEntries = new int[size];
			size = 0;

			for(int i = 0; i < entries.size(); ++i)
			{
				Entry entry = (Entry)entries.get(i);
				if( (entry.modifier & MODIFIER_UNIQUE) != 0 )
					uniqueEntries[size++] = i;
			}
		}

		void resetEntries(String text)
		{
			setColumnCount(0);
			setRowCount(0);
			rowCount.setText("row count:");
			entries.clear();
			packetLength = 0;

			StringTokenizer lines = new StringTokenizer(text, "\n\r\f");
			while( lines.hasMoreTokens() )
				addEntry(lines.nextToken());

			updateUniqueEntries();

			lenText.setText(Integer.toString(packetLength));

			fireTableStructureChanged();
		}

		void removeRows(int[] rows)
		{
			int i = rows.length;
			while( --i >= 0 )
				removeRow(rows[i]);

			fireTableDataChanged();
		}

		void sendByte(int a)
		{
			packet[packetIndex++] = (byte)a;
		}

		void sendShort(int a)
		{
			packet[packetIndex++] = (byte)a;
			packet[packetIndex++] = (byte)(a >> 8);
		}

		void sendInt24(int a)
		{
			packet[packetIndex++] = (byte)a;
			packet[packetIndex++] = (byte)(a >> 8);
			packet[packetIndex++] = (byte)(a >> 16);
		}

		void sendInt(int a)
		{
			packet[packetIndex++] = (byte)a;
			packet[packetIndex++] = (byte)(a >> 8);
			packet[packetIndex++] = (byte)(a >> 16);
			packet[packetIndex++] = (byte)(a >> 24);
		}

		void sendEntry(Entry entry)
		{
			if( (entry.modifier & MODIFIER_OMIT) != 0 )
				entry.value = entry.defValue;

			switch(entry.type)
			{
			case TYPE_UINT8:
			case TYPE_INT8:
			case TYPE_HEX8:
				sendByte(parseInt(entry.value));
				break;

			case TYPE_UINT16:
			case TYPE_INT16:
			case TYPE_HEX16:
				sendShort(parseInt(entry.value));
				break;

			case TYPE_UINT24:
			case TYPE_INT24:
			case TYPE_HEX24:
				sendInt24(parseInt(entry.value));
				break;

			case TYPE_UINT32:
			case TYPE_INT32:
			case TYPE_HEX32:
				sendInt(parseInt(entry.value));
				break;

			case TYPE_FLOAT:
				sendInt(Float.floatToIntBits(parseFloat(entry.value)));
				break;
			}
		}

		void sendRow(int index)
		{
			packet = new byte[packetLength];
			packetIndex = 0;

			String text = "sending message " + index;
			errorText.setText(text);

			for(int i = 0; i < entries.size(); ++i)
			{
				Entry entry = (Entry)entries.get(i);
				if( entry.column >= 0 )
					entry.value = (String)getValueAt(index, entry.column);

				sendEntry(entry);
			}

			if( text.equals(errorText.getText()) )	// if no error
			{
				// broadcast it now
				SerialConnector.instance().sendMessage(0xFFFF, (short)amType, packet);
			}
		}

		void sendRows(int[] rows)
		{
			for(int i = 0; i < rows.length; ++i)
				sendRow(rows[i]);
		}

		class RowComparator implements Comparator
		{
			int column = 0;

			public RowComparator(int column)
			{
				this.column = column;
			}

			public int compare(Object o1, Object o2)
			{
				if( o1 == null )
					return -1;
				if( o2 == null )
					return 1;

				Comparable c1 = (Comparable)((Vector)o1).get(column);
				Comparable c2 = (Comparable)((Vector)o2).get(column);

				return c1.compareTo(c2);
			}
		};

		void sort(int column)
		{
			Collections.sort(dataVector, new RowComparator(column));
		}
	};

	int amType;
	private MyTableModel tableModel = new MyTableModel();

	int parseInt(String value)
	{
		try
		{
			if(value == null)
				return 0;
			else if(value.trim().toUpperCase().startsWith("0X"))
				return Integer.parseInt(value.trim().substring(2),16);
			else
				return Integer.parseInt(value.trim());
		}
		catch(RuntimeException e)
		{
			errorText.setText("invalid integer format: " + value);
			return 0;
		}
	}

	float parseFloat(String value)
	{
		try
		{
			if( value == null )
				return 0;
			else
				return Float.parseFloat(value);
		}
		catch(RuntimeException e)
		{
			errorText.setText("invalid float format: " + value);
			return 0;
		}
	}

	public class MyColumnListener extends MouseAdapter
	{
		public void mouseClicked(MouseEvent event)
		{
			if( event.getClickCount() != 2 )
				return;

			int index = table.getColumnModel().getColumnIndexAtX(event.getX());
			index = table.convertColumnIndexToModel(index);
			if( index < 0 )
				return;

			tableModel.sort(index);
		}
	};

	Preferences prefs = null;

	/** Creates new form MessageTable */
	public MessageTable()
	{
		super("MessageTable");
		initComponents();

		table.getTableHeader().addMouseListener(new MyColumnListener());

		prefs = Preferences.userNodeForPackage(this.getClass());
		prefs = prefs.node(prefs.absolutePath()+"/MessageTable");
		loadComboBox();

		SerialConnector.instance().registerPacketListener(this,
			SerialConnector.GET_ALL_MESSAGES);
	}

	public void sliceFloodRoutingMsg(byte[] packet)
	{
		int dfrfHeaderLength = 3;
		int dfrfDataLength = tableModel.packetLength - dfrfHeaderLength;
		SerialPacket sp = new SerialPacket(packet,1);
		int packetDataLength = sp.get_header_length();
		int packetDataOffset = sp.baseOffset() + SerialPacket.offset_data(0);

		byte[] slice = new byte[packetDataOffset + dfrfHeaderLength + dfrfDataLength];
		long baseTimeStamp = Marshaller.getUIntBEElement(packet, (packetDataOffset + packetDataLength - 4) * 8, 32);

		System.out.println("baseTimeStamp = " + baseTimeStamp);
		
		if ((packetDataLength-dfrfHeaderLength - 4) % dfrfDataLength != 0)
			return; // not a well-formed dfrf message

		for(int i = dfrfHeaderLength; i < packetDataLength - 4; i += dfrfDataLength)
		{
			slice[0] = 0; // the first byte is zero
			slice[sp.baseOffset() + SerialPacket.offset_header_length()] = (byte)(dfrfHeaderLength + dfrfDataLength);
			System.arraycopy(packet, packetDataOffset, slice, packetDataOffset, dfrfHeaderLength);
			System.arraycopy(packet, packetDataOffset + i, slice, packetDataOffset + dfrfHeaderLength, dfrfDataLength);

			long packetTimeStamp = Marshaller.getUIntBEElement(slice, (packetDataOffset + dfrfHeaderLength) * 8, 32);
			packetTimeStamp = baseTimeStamp - packetTimeStamp;
			Marshaller.setUIntBEElement(slice, (packetDataOffset + dfrfHeaderLength) * 8, 32, packetTimeStamp);
			tableModel.addPacket(slice);
		}
	}

	public void packetReceived(byte[] packet)
	{
		SerialPacket sp = new SerialPacket(packet,1);		
		if( sp.get_header_type() == amType )
		{
			if( amType == 0x82 )
				sliceFloodRoutingMsg(packet);
			else
				tableModel.addPacket(packet);
		}
	}

	/** This method is called from within the constructor to
	 * initialize the form.
	 * WARNING: Do NOT modify this code. The content of this method is
	 * always regenerated by the Form Editor.
	 */
        private void initComponents() {//GEN-BEGIN:initComponents
                java.awt.GridBagConstraints gridBagConstraints;

                tabbedPane = new javax.swing.JTabbedPane();
                jPanel2 = new javax.swing.JPanel();
                configNameText = new javax.swing.JComboBox();
                jButton2 = new javax.swing.JButton();
                jButton3 = new javax.swing.JButton();
                errorText = new javax.swing.JTextField();
                jPanel3 = new javax.swing.JPanel();
                jLabel1 = new javax.swing.JLabel();
                amTypeText = new javax.swing.JTextField();
                timeStampBox = new javax.swing.JCheckBox();
                counterBox = new javax.swing.JCheckBox();
                bigEndianBox = new javax.swing.JCheckBox();
                jScrollPane2 = new javax.swing.JScrollPane();
                formatText = new javax.swing.JTextArea();
                jLabel2 = new javax.swing.JLabel();
                lenText = new javax.swing.JTextField();
                firstUniqueBox = new javax.swing.JCheckBox();
                jPanel4 = new javax.swing.JPanel();
                jPanel1 = new javax.swing.JPanel();
                jButton41 = new javax.swing.JButton();
                jButton5 = new javax.swing.JButton();
                jButton4 = new javax.swing.JButton();
                jButton1 = new javax.swing.JButton();
                jScrollPane1 = new javax.swing.JScrollPane();
                table = new javax.swing.JTable();
                rowCount = new javax.swing.JTextField();

                getContentPane().setLayout(new java.awt.GridBagLayout());

                setTitle("Message Table");
                setMinimumSize(new java.awt.Dimension(180, 100));
                jPanel2.setLayout(new java.awt.GridBagLayout());

                jPanel2.setBorder(new javax.swing.border.TitledBorder("Configuration"));
                configNameText.setEditable(true);
                configNameText.setMaximumRowCount(100);
                configNameText.setToolTipText("the name of the configuration");
                configNameText.addActionListener(new java.awt.event.ActionListener() {
                        public void actionPerformed(java.awt.event.ActionEvent evt) {
                                configNameTextActionPerformed(evt);
                        }
                });

                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
                gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTH;
                gridBagConstraints.weightx = 0.7;
                gridBagConstraints.insets = new java.awt.Insets(0, 3, 0, 3);
                jPanel2.add(configNameText, gridBagConstraints);

                jButton2.setText("Save");
                jButton2.setToolTipText("save the current configuration in the preferences");
                jButton2.setMaximumSize(new java.awt.Dimension(80, 26));
                jButton2.setMinimumSize(new java.awt.Dimension(80, 20));
                jButton2.setPreferredSize(new java.awt.Dimension(80, 26));
                jButton2.addActionListener(new java.awt.event.ActionListener() {
                        public void actionPerformed(java.awt.event.ActionEvent evt) {
                                jButton2ActionPerformed(evt);
                        }
                });

                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTH;
                gridBagConstraints.insets = new java.awt.Insets(0, 3, 0, 3);
                gridBagConstraints.weightx = 0.1;
                jPanel2.add(jButton2, gridBagConstraints);

                jButton3.setText("Delete");
                jButton3.setToolTipText("delete the current configuration from the preferences");
                jButton3.setMaximumSize(new java.awt.Dimension(80, 26));
                jButton3.setMinimumSize(new java.awt.Dimension(80, 20));
                jButton3.setPreferredSize(new java.awt.Dimension(80, 26));
                jButton3.addActionListener(new java.awt.event.ActionListener() {
                        public void actionPerformed(java.awt.event.ActionEvent evt) {
                                jButton3ActionPerformed(evt);
                        }
                });

                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTH;
                gridBagConstraints.insets = new java.awt.Insets(0, 3, 0, 3);
                gridBagConstraints.weightx = 0.1;
                jPanel2.add(jButton3, gridBagConstraints);

                jButton1.setText("Reset");
                jButton1.setToolTipText("reparse the message format and clear the table");
                jButton1.setMaximumSize(new java.awt.Dimension(80, 26));
                jButton1.setMinimumSize(new java.awt.Dimension(80, 20));
                jButton1.setPreferredSize(new java.awt.Dimension(80, 26));

                jButton1.addActionListener(new java.awt.event.ActionListener() {
                        public void actionPerformed(java.awt.event.ActionEvent evt) {
                                jButton1ActionPerformed(evt);
                        }
                });

                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTH;
                gridBagConstraints.insets = new java.awt.Insets(0, 3, 3, 3);
                gridBagConstraints.weightx = 0.1;
                jPanel2.add(jButton1, gridBagConstraints);

                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 0;
                gridBagConstraints.gridy = 0;
                gridBagConstraints.gridwidth = 2;
                gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
                getContentPane().add(jPanel2, gridBagConstraints);

                jPanel4.setLayout(new java.awt.GridBagLayout());

                jPanel4.setBorder(new javax.swing.border.TitledBorder("Table"));
                jPanel1.setLayout(new java.awt.GridBagLayout());

                jButton41.setText("Add Row");
                jButton41.setToolTipText("adds an empty row in the table");
                jButton41.addActionListener(new java.awt.event.ActionListener() {
                        public void actionPerformed(java.awt.event.ActionEvent evt) {
                                jButton41ActionPerformed(evt);
                        }
                });

                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridy = 0;
                gridBagConstraints.insets = new java.awt.Insets(0, 3, 0, 3);
                gridBagConstraints.weightx = 1.0;
                jPanel1.add(jButton41, gridBagConstraints);

                jButton5.setText("Send Msg(s)");
                jButton5.setToolTipText("broadcasts  the selected rows");
                jButton5.addActionListener(new java.awt.event.ActionListener() {
                        public void actionPerformed(java.awt.event.ActionEvent evt) {
                                jButton5ActionPerformed(evt);
                        }
                });

                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridy = 0;
                gridBagConstraints.insets = new java.awt.Insets(0, 3, 0, 3);
                gridBagConstraints.weightx = 1.0;
                jPanel1.add(jButton5, gridBagConstraints);

                jButton4.setText("Delete Row(s)");
                jButton4.setToolTipText("removes the selected rows from the table");
                jButton4.addActionListener(new java.awt.event.ActionListener() {
                        public void actionPerformed(java.awt.event.ActionEvent evt) {
                                jButton4ActionPerformed(evt);
                        }
                });

                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridy = 0;
                gridBagConstraints.insets = new java.awt.Insets(0, 3, 0, 3);
                gridBagConstraints.weightx = 1.0;
                jPanel1.add(jButton4, gridBagConstraints);


                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 0;
                gridBagConstraints.gridy = 0;
                gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
                gridBagConstraints.insets = new java.awt.Insets(0, 0, 5, 0);
                jPanel4.add(jPanel1, gridBagConstraints);

                jScrollPane1.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(1, 1, 1, 1)));
                jScrollPane1.setMinimumSize(new java.awt.Dimension(200, 100));
                jScrollPane1.setPreferredSize(new java.awt.Dimension(400, 403));
                table.setModel(tableModel);
                table.setToolTipText("double click on a column to sort the rows");
                jScrollPane1.setViewportView(table);

                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 0;
                gridBagConstraints.gridy = 1;
                gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
                gridBagConstraints.weightx = 2.0;
                gridBagConstraints.weighty = 1.0;
                jPanel4.add(jScrollPane1, gridBagConstraints);

//                gridBagConstraints = new java.awt.GridBagConstraints();
//                gridBagConstraints.gridx = 0;
//                gridBagConstraints.gridy = 1;
//                gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
//                gridBagConstraints.weightx = 1.0;
//                gridBagConstraints.weighty = 1.0;
                //getContentPane().add(jPanel4, gridBagConstraints);
                //getContentPane().add(jPanel3, gridBagConstraints);
                tabbedPane.addTab("RcvdData", jPanel4);

                jPanel3.setLayout(new java.awt.GridBagLayout());

                jPanel3.setBorder(new javax.swing.border.TitledBorder("Message Format"));
                jLabel1.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
                jLabel1.setText("msg type:");
                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 0;
                gridBagConstraints.gridy = 0;
                gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
                gridBagConstraints.insets = new java.awt.Insets(0, 4, 0, 3);
                jPanel3.add(jLabel1, gridBagConstraints);

                amTypeText.setText("0x00");
                amTypeText.setToolTipText("the active message type");
                amTypeText.setMinimumSize(new java.awt.Dimension(35, 20));
                amTypeText.setPreferredSize(new java.awt.Dimension(35, 20));
                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 1;
                gridBagConstraints.gridy = 0;
                gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
                jPanel3.add(amTypeText, gridBagConstraints);

                timeStampBox.setText("time stamp");
                timeStampBox.setToolTipText("put a timestamp on each incoming message");
                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 0;
                gridBagConstraints.gridy = 2;
                gridBagConstraints.gridwidth = 2;
                gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
                gridBagConstraints.weightx = 1.0;
                jPanel3.add(timeStampBox, gridBagConstraints);

                counterBox.setText("counter");
                counterBox.setToolTipText("show the count of received messages with the same unique fields");
                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 0;
                gridBagConstraints.gridy = 3;
                gridBagConstraints.gridwidth = 2;
                gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
                gridBagConstraints.weightx = 1.0;
                jPanel3.add(counterBox, gridBagConstraints);

                firstUniqueBox.setText("first unique only");
                firstUniqueBox.setToolTipText("display only the first unique message");
                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 0;
                gridBagConstraints.gridy = 4;
                gridBagConstraints.gridwidth = 2;
                gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
                gridBagConstraints.weightx = 1.0;
                jPanel3.add(firstUniqueBox, gridBagConstraints);

                bigEndianBox.setText("big endian");
                bigEndianBox.setToolTipText("parsed data are in big endian");
                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 0;
                gridBagConstraints.gridy = 5;
                gridBagConstraints.gridwidth = 2;
                gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
                gridBagConstraints.weightx = 1.0;
                jPanel3.add(bigEndianBox, gridBagConstraints);

                jScrollPane2.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
                jScrollPane2.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
                jScrollPane2.setMinimumSize(new java.awt.Dimension(150, 100));
                //formatText.setColumns(12);
                formatText.setToolTipText("format of each line: [unique, omit, const] <type> <name> [ = <value>]");
                //formatText.setMinimumSize(new java.awt.Dimension(100, 100));
                //formatText.setPreferredSize(new java.awt.Dimension(132, 100));
                jScrollPane2.setViewportView(formatText);

                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 0;
                gridBagConstraints.gridy = 6;
                gridBagConstraints.gridwidth = 2;
                gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
                gridBagConstraints.weighty = 1.0;
                jPanel3.add(jScrollPane2, gridBagConstraints);

                jLabel2.setText("length:");
                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 0;
                gridBagConstraints.gridy = 1;
                gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
                gridBagConstraints.insets = new java.awt.Insets(0, 4, 0, 3);
                jPanel3.add(jLabel2, gridBagConstraints);

                lenText.setEditable(false);
                lenText.setToolTipText("the expected length of the packets");
                lenText.setPreferredSize(new java.awt.Dimension(35, 20));
                lenText.setMinimumSize(new java.awt.Dimension(35, 20));
                lenText.setMaximumSize(new java.awt.Dimension(35, 20));
                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 1;
                gridBagConstraints.gridy = 1;
                gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
                jPanel3.add(lenText, gridBagConstraints);

                /*gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 1;
                gridBagConstraints.gridy = 1;
                gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;*/
                //getContentPane().add(jPanel3, gridBagConstraints);
                tabbedPane.addTab("MsgFormat", jPanel3);

                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 0;
                gridBagConstraints.gridy = 1;
                gridBagConstraints.gridwidth = 2;
                gridBagConstraints.weightx = 1.0;
                gridBagConstraints.weighty = 1.0;
                gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
                getContentPane().add(tabbedPane, gridBagConstraints);

                errorText.setEditable(false);
                errorText.setText("no error");
                errorText.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(1, 1, 1, 1)));
                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 0;
                gridBagConstraints.gridy = 2;
                gridBagConstraints.weightx = 0.4;
                gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
                gridBagConstraints.insets = new java.awt.Insets(0, 4, 0, 0);
                getContentPane().add(errorText, gridBagConstraints);

                rowCount.setEditable(false);
                rowCount.setText("row count:");
                rowCount.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(1, 1, 1, 1)));
                gridBagConstraints = new java.awt.GridBagConstraints();
                gridBagConstraints.gridx = 1;
                gridBagConstraints.gridy = 2;
                gridBagConstraints.weightx = 0.5;
                gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
                gridBagConstraints.insets = new java.awt.Insets(0, 4, 0, 0);
                getContentPane().add(rowCount, gridBagConstraints);

                pack();
        }//GEN-END:initComponents

	private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
		int[] rows = table.getSelectedRows();
		tableModel.sendRows(rows);
	}//GEN-LAST:event_jButton5ActionPerformed

	private void jButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton4ActionPerformed
		int[] rows = table.getSelectedRows();
		tableModel.removeRows(rows);
	}//GEN-LAST:event_jButton4ActionPerformed

	private void jButton41ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton41ActionPerformed
			int packetDataOffset = SerialPacket.offset_data(0) + 1;
			tableModel.packet = new byte[packetDataOffset + tableModel.packetLength];
			tableModel.packetIndex = packetDataOffset;

			for(int i = 0; i < tableModel.entries.size(); ++i)
			{
				MyTableModel.Entry entry = (MyTableModel.Entry)tableModel.entries.get(i);
				entry.value = null;
				tableModel.sendEntry(entry);
			}

			tableModel.packet[SerialPacket.offset_header_length() + 1] = (byte)tableModel.packetLength;
			tableModel.addPacket(tableModel.packet);
	}//GEN-LAST:event_jButton41ActionPerformed

	private void configNameTextActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_configNameTextActionPerformed
		if( configNameText.getSelectedIndex() < 0 )
			return;
		String name = (String)configNameText.getSelectedItem();
		Preferences p = prefs.node(prefs.absolutePath() + "/config/" + name);
		amTypeText.setText(new String(p.get("amType", "0x00")));
		counterBox.setSelected(p.getBoolean("counter", false));
		bigEndianBox.setSelected(p.getBoolean("bigEndian", false));
		timeStampBox.setSelected(p.getBoolean("timeStamp", false));
		firstUniqueBox.setSelected(p.getBoolean("firstUnique", false));
		formatText.setText(new String(p.get("format", "")).replaceAll(";","\n"));
		jButton1ActionPerformed(null);

		setTitle("Message Table - "+name);
		super.setTitle(getTitle());
	}//GEN-LAST:event_configNameTextActionPerformed

	private void saveComboBox()
	{
		/*String items = "";
		for(int i = 0; i < configNameText.getItemCount(); ++i)
			items = items + (String)configNameText.getItemAt(i) + "\n";

		prefs.put("configs", items);*/
	}

	private void loadComboBox()
	{
		configNameText.removeAllItems();
		//StringTokenizer tokenizer = new StringTokenizer(prefs.get("configs", ""), "\n");

                try{
                    Preferences p = prefs.node(prefs.absolutePath() + "/config");
                    String[] configNames = p.childrenNames();
                    for(int i=0; i< configNames.length; i++)
                        configNameText.addItem(configNames[i]);
                }catch (java.util.prefs.BackingStoreException bse){
                    System.err.println("Cannot Load Configurations:"+ bse.getMessage());
                }
	}

	private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
		String name = (String)configNameText.getSelectedItem();
		errorText.setText("configuration " + name + " removed");
		configNameText.removeItem(name);
		try {
			saveComboBox();
			Preferences p = prefs.node(prefs.absolutePath() + "/config/" + name);
			p.removeNode();
			prefs.flush();
		} catch(BackingStoreException e) {
			errorText.setText("could not write preferences");
		};
	}//GEN-LAST:event_jButton3ActionPerformed

	private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
		String name = (String)configNameText.getSelectedItem();
		errorText.setText("configuration " + name + " saved");

		if( configNameText.getSelectedIndex() < 0 )
			configNameText.addItem(name);
		try {
			setTitle("Message Table - "+name);
			super.setTitle(getTitle());
			saveComboBox();
			Preferences p = prefs.node(prefs.absolutePath() + "/config/" + name);
			p.put("amType", amTypeText.getText());
			p.putBoolean("bigEndian", bigEndianBox.isSelected());
			p.putBoolean("counter", counterBox.isSelected());
			p.putBoolean("timeStamp", timeStampBox.isSelected());
			p.putBoolean("firstUnique", firstUniqueBox.isSelected());
			String formatString = formatText.getText();
                        String newFormatString = formatString.replaceAll("\n",";");
                        //System.out.println(newFormatString.replaceAll(";","\n"));

                        p.put("format",newFormatString );
			prefs.flush();
		} catch(BackingStoreException e) {
			errorText.setText("could not write preferences");
		};
	}//GEN-LAST:event_jButton2ActionPerformed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
	errorText.setText("format parsed for AM type " + amTypeText.getText());
	amType = parseInt(amTypeText.getText()) & 0xFF;
	String format = formatText.getText();
	if( bigEndianBox.isSelected() )
		format = "bigEndian bigEndian\n" + format;
	if( counterBox.isSelected() )
		format = "counter counter\n" + format;
	if( timeStampBox.isSelected() )
		format = "time timestamp\n" + format;
	tableModel.resetEntries(format);
    }//GEN-LAST:event_jButton1ActionPerformed

        // Variables declaration - do not modify//GEN-BEGIN:variables
        private javax.swing.JTable table;
        private javax.swing.JTabbedPane tabbedPane;
        private javax.swing.JButton jButton2;
        private javax.swing.JScrollPane jScrollPane1;
        private javax.swing.JPanel jPanel4;
        private javax.swing.JCheckBox firstUniqueBox;
        private javax.swing.JLabel jLabel1;
        private javax.swing.JComboBox configNameText;
        private javax.swing.JPanel jPanel3;
        private javax.swing.JTextField lenText;
        private javax.swing.JLabel jLabel2;
        private javax.swing.JButton jButton1;
        private javax.swing.JCheckBox counterBox;
        private javax.swing.JCheckBox bigEndianBox;
        private javax.swing.JPanel jPanel2;
        private javax.swing.JButton jButton3;
        private javax.swing.JScrollPane jScrollPane2;
        private javax.swing.JCheckBox timeStampBox;
        private javax.swing.JTextArea formatText;
        private javax.swing.JButton jButton5;
        private javax.swing.JButton jButton41;
        private javax.swing.JTextField errorText;
        private javax.swing.JPanel jPanel1;
        private javax.swing.JTextField amTypeText;
        private javax.swing.JButton jButton4;
        private javax.swing.JTextField rowCount;
        // End of variables declaration//GEN-END:variables

}
