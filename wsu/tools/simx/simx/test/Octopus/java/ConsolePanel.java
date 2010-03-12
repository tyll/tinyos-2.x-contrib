// $Id$

/*									tab:4
 * Copyright (c) 2007 University College Dublin.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice and the following
 * two paragraphs appear in all copies of this software.
 *
 * IN NO EVENT SHALL UNIVERSITY COLLEGE DUBLIN BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF 
 * UNIVERSITY COLLEGE DUBLIN HAS BEEN ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * UNIVERSITY COLLEGE DUBLIN SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND UNIVERSITY COLLEGE DUBLIN HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS.
 *
 * Authors:	Raja Jurdak, Antonio Ruzzelli, and Samuel Boivineau
 * Date created: 2007/09/07
 *
 */

/**
 * @author Raja Jurdak, Antonio Ruzzelli, and Samuel Boivineau
 */


import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;
import javax.swing.BorderFactory;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
	
/*
	This JPanel lets the user know events happening and filter them.
*/

class ConsolePanel extends JPanel implements ItemListener{
	private JTextArea textArea;
	private JPanel consoleFilterPanel;
	private boolean filterArray[];
	private String msgArray[];
	private JCheckBox checkBoxArray[];
	private int i;
	
	public ConsolePanel() {
		super(new GridBagLayout());
		textArea = new JTextArea();
		textArea.setColumns(30);
		textArea.setRows(6);
		textArea.setEnabled(false);
		JScrollPane scrollPane = new JScrollPane(textArea);
		
		consoleFilterPanel = new JPanel();
		consoleFilterPanel.setLayout(new BoxLayout(consoleFilterPanel, BoxLayout.PAGE_AXIS));
		checkBoxArray = new JCheckBox [Util.NB_MSG_TYPE];
		checkBoxArray[Util.MSG_MESSAGE_RECEIVED] = new JCheckBox("Message Received");
		checkBoxArray[Util.MSG_MESSAGE_SENT] = new JCheckBox("Message Sent");
		checkBoxArray[Util.MSG_MOTE_ADDED] = new JCheckBox("Mote Added");
		checkBoxArray[Util.MSG_MOTE_UPDATED] = new JCheckBox("Mote Updated");
		for(i=0; i<Util.NB_MSG_TYPE; i++)
			consoleFilterPanel.add(checkBoxArray[i]);
		for(i=0; i<Util.NB_MSG_TYPE; i++)
			checkBoxArray[i].addItemListener(this);
		
		consoleFilterPanel.setBorder(BorderFactory.createTitledBorder("Filters"));
		
		// layout
		GridBagConstraints c = new GridBagConstraints();
		c.anchor = GridBagConstraints.LINE_START;
		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0; c.gridy = 0; c.gridwidth = 1; c.weightx = 1; add(scrollPane, c);
		
		c.anchor = GridBagConstraints.LINE_END;
		c.fill = GridBagConstraints.NONE;
		c.insets = new Insets(0,5,0,0);
		c.gridx = 1; c.gridy = 0; c.gridwidth = 1; c.weightx = 0;add(consoleFilterPanel, c);
		
		filterArray = new boolean [Util.NB_MSG_TYPE];
		msgArray = new String [Util.NB_MSG_TYPE];
		filterArray[Util.MSG_MESSAGE_RECEIVED] = false;
		msgArray[Util.MSG_MESSAGE_RECEIVED] = "[Msg Received] ";
		filterArray[Util.MSG_MESSAGE_SENT] = false;
		msgArray[Util.MSG_MESSAGE_SENT] = "[Msg Sent] ";
		filterArray[Util.MSG_MOTE_ADDED] = true;
		msgArray[Util.MSG_MOTE_ADDED] = "[Mote Added] ";
		filterArray[Util.MSG_MOTE_UPDATED] = false;
		msgArray[Util.MSG_MOTE_UPDATED] = "[Mote Updated] ";
		
		for(i=0; i<Util.NB_MSG_TYPE; i++)
			checkBoxArray[i].setSelected(filterArray[i]);
	}
	
	public void append(String s, int type) {
		if(filterArray[type]) {
			textArea.append(msgArray[type] + s + "\n");
			textArea.setCaretPosition(textArea.getDocument().getLength());
		}
	}
	
	public void itemStateChanged(ItemEvent e) {
		Object source = e.getItemSelectable();
		// if the checkbox was deselected
		if (e.getStateChange() == ItemEvent.DESELECTED) {
			for(i=0; i<Util.NB_MSG_TYPE; i++)
				if (source == checkBoxArray[i])
					filterArray[i] = false;
		// if the checkbox was selected
		} else {
			for(i=0; i<Util.NB_MSG_TYPE; i++)
				if (source == checkBoxArray[i])
					filterArray[i] = true;
		}
	}
}
