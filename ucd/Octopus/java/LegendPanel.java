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
import javax.swing.event.*;
import java.awt.*;
import java.awt.event.*;
/*
	This JPanel lets the user choose the way the map is drawn, and 
	what kind of data is printed on the map. LegendChooserPanel
	is a little panel containing a JLabel and a JChooser.
	
	TODO :
	BUG :
*/
class LegendPanel extends JPanel implements ActionListener, ChangeListener, ItemListener {
	private MapPanel mapPanel;
	private JSlider timeoutSlider;
	
	public LegendChooserPanel moteChooser, moteIdChooser, samplingPeriodChooser, parentIdChooser,
		countChooser, readingChooser, qualityChooser, lastTimeSeenChooser, routeChooser;
	
	private JCheckBox logCheckBox;
	private JCheckBox [] logFieldsCheckBoxArray;
	private boolean logging;
	private Logger logger;
	
	public LegendPanel(MapPanel mapPanel, Logger logger) {
		super(new GridBagLayout());
		
		timeoutSlider = new JSlider(JSlider.HORIZONTAL, 0, 65535, 10000);
		timeoutSlider.addChangeListener(this);
		timeoutSlider.setMajorTickSpacing(20000);
		timeoutSlider.setMinorTickSpacing(2000);
		timeoutSlider.setPaintTicks(true);
		timeoutSlider.setPaintLabels(true);
		timeoutSlider.setBorder(BorderFactory.createTitledBorder("Timeout for display of routes (in ms)"));
		
		String [] list2 = new String [2]; 
		String [] list3 = new String [3];
		String [] list4 = new String [4];
		list2[0] = "none"; list2[1] = "circle";
		moteChooser = new LegendChooserPanel("Mote : ", list2);
		list2[0] = "none"; list2[1] = "text";
		moteIdChooser = new LegendChooserPanel("Mote Id : ", list2);
		list4[0] = "none"; list4[1] = "text"; list4[2] = "gradient"; list4[3] = "text + gradient";
		samplingPeriodChooser = new LegendChooserPanel("Sampling Period : ", list4);
		parentIdChooser = new LegendChooserPanel("Parent Id : ", list2);
		countChooser = new LegendChooserPanel("Count : ", list4);
		readingChooser = new LegendChooserPanel("Reading : ", list4);
		qualityChooser = new LegendChooserPanel("Quality : ", list2);
		lastTimeSeenChooser = new LegendChooserPanel("Last Time Seen : ", list4);
		list3[0] = "none"; list3[1] = "line"; list3[2] = "line + label"; 
		routeChooser = new LegendChooserPanel("Route : ", list3);
		
		moteChooser.addActionListener(this);
		moteIdChooser.addActionListener(this);
		samplingPeriodChooser.addActionListener(this);
		parentIdChooser.addActionListener(this);
		countChooser.addActionListener(this);
		readingChooser.addActionListener(this);
		qualityChooser.addActionListener(this);
		lastTimeSeenChooser.addActionListener(this);
		routeChooser.addActionListener(this);
		
		// log
		logCheckBox = new JCheckBox("Log in a file (Mote Id and Time put by default)");
		logCheckBox.setSelected(false);
		logCheckBox.addItemListener(this);
		logFieldsCheckBoxArray = new JCheckBox[11];
		logFieldsCheckBoxArray[0] = new JCheckBox("Mode Auto or Query");
		logFieldsCheckBoxArray[1] = new JCheckBox("Sleeping or Awake");
		logFieldsCheckBoxArray[2] = new JCheckBox("Sampling Period");
		logFieldsCheckBoxArray[3] = new JCheckBox("Threshold");
		logFieldsCheckBoxArray[4] = new JCheckBox("Sleep Duty Cycle");
		logFieldsCheckBoxArray[5] = new JCheckBox("Awake Duty Cycle");
		logFieldsCheckBoxArray[6] = new JCheckBox("Reading");
		logFieldsCheckBoxArray[7] = new JCheckBox("Count");
		logFieldsCheckBoxArray[8] = new JCheckBox("Quality");
		logFieldsCheckBoxArray[9] = new JCheckBox("ParentId");
		logFieldsCheckBoxArray[10] = new JCheckBox("Last Time Seen");
		
		logFieldsCheckBoxArray[6].setSelected(true); // reading activated by default
		for (int i=0; i<11; i++)
			logFieldsCheckBoxArray[i].addItemListener(this);
		// layout for the logFieldsPanel
		JPanel logFieldsPanel = new JPanel(new GridBagLayout());
		GridBagConstraints c = new GridBagConstraints();
		c.insets = new Insets(2,5,2,5);
		c.weighty = 1; c.weightx = 1;
		c.anchor = GridBagConstraints.FIRST_LINE_START;
		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridy = 0; c.gridwidth = 2;
		logFieldsPanel.add(logCheckBox, c);
		c.gridy = 1; c.gridwidth = 1;
		for (int i=0; i<10; i++) {
			c.gridx=0;
			logFieldsPanel.add(logFieldsCheckBoxArray[i++], c);
			c.gridx=1;
			logFieldsPanel.add(logFieldsCheckBoxArray[i], c);
			c.gridy++;
		}
		logFieldsPanel.setBorder(BorderFactory.createTitledBorder("Choose the fields logged"));
		
		// layout
		c = new GridBagConstraints();
		c.insets = new Insets(2,10,2,10);
		c.weighty = 1; c.weightx = 1;
		c.anchor = GridBagConstraints.FIRST_LINE_START;
		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridy = 0; 			add(moteChooser, c);
		c.gridy = 1;			add(moteIdChooser, c);
		c.gridy = 2;			add(parentIdChooser, c);
		c.gridy = 3;			add(samplingPeriodChooser, c);
		c.gridy = 4;			add(countChooser, c);
		c.gridy = 5;			add(readingChooser, c);
		c.gridy = 6;			add(qualityChooser, c);
		c.gridy = 7;			add(lastTimeSeenChooser, c);
		c.gridy = 8;			add(routeChooser, c);
		c.gridy = 9;			add(timeoutSlider, c);
		c.gridy = 10;			add(logFieldsPanel, c);
		
		logging = false;
		this.mapPanel = mapPanel;
		this.logger = logger;
		moteChooser.setSelectedIndex(1);
		routeChooser.setSelectedIndex(1);
	}

	/*
		Function called when a checkBox is selected or unselected
	*/
	
	public void itemStateChanged(ItemEvent e) {
	    JCheckBox source = (JCheckBox)e.getItemSelectable();
		if (source == logCheckBox) {
			if (e.getStateChange() == ItemEvent.DESELECTED) {
				logger.stopLogging();
				logging = false;
				for (int i=0; i<11; i++)
					logFieldsCheckBoxArray[i].setEnabled(true);
			} else {
				logger.startLogging();
				logging = true;
				for (int i=0; i<11; i++)
					logFieldsCheckBoxArray[i].setEnabled(false);
			}
		} else if (source == logFieldsCheckBoxArray[0])
			if (e.getStateChange() == ItemEvent.DESELECTED) logger.setModeAutoRecorded(false);
			else 											logger.setModeAutoRecorded(true);
		else if (source == logFieldsCheckBoxArray[1])
			if (e.getStateChange() == ItemEvent.DESELECTED) logger.setModeSleepingRecorded(false);
			else 											logger.setModeSleepingRecorded(true);
		else if (source == logFieldsCheckBoxArray[2])
			if (e.getStateChange() == ItemEvent.DESELECTED) logger.setSamplingPeriodRecorded(false);
			else 											logger.setSamplingPeriodRecorded(true);
		else if (source == logFieldsCheckBoxArray[3])
			if (e.getStateChange() == ItemEvent.DESELECTED) logger.setThresholdRecorded(false);
			else 											logger.setThresholdRecorded(true);
		else if (source == logFieldsCheckBoxArray[4])
			if (e.getStateChange() == ItemEvent.DESELECTED) logger.setSleepDutyCycleRecorded(false);
			else 											logger.setSleepDutyCycleRecorded(true);
		else if (source == logFieldsCheckBoxArray[5])
			if (e.getStateChange() == ItemEvent.DESELECTED) logger.setAwakeDutyCycleRecorded(false);
			else 											logger.setAwakeDutyCycleRecorded(true);
		else if (source == logFieldsCheckBoxArray[6])
			if (e.getStateChange() == ItemEvent.DESELECTED) logger.setReadingRecorded(false);
			else 											logger.setReadingRecorded(true);
		else if (source == logFieldsCheckBoxArray[7])
			if (e.getStateChange() == ItemEvent.DESELECTED) logger.setCountRecorded(false);
			else 											logger.setCountRecorded(true);
		else if (source == logFieldsCheckBoxArray[8])
			if (e.getStateChange() == ItemEvent.DESELECTED) logger.setQualityRecorded(false);
			else 											logger.setQualityRecorded(true);
		else if (source == logFieldsCheckBoxArray[9])
			if (e.getStateChange() == ItemEvent.DESELECTED) logger.setParentIdRecorded(false);
			else 											logger.setParentIdRecorded(true);
		else if (source == logFieldsCheckBoxArray[10])
			if (e.getStateChange() == ItemEvent.DESELECTED) logger.setLastTimeSeenRecorded(false);
			else 											logger.setLastTimeSeenRecorded(true);
	}
	
	public void actionPerformed(ActionEvent e) {
		JComboBox comboBox = (JComboBox)e.getSource();
		if (getNumberOfChoosersEqualTo("gradient") + getNumberOfChoosersEqualTo("text + gradient") > 1 ) {
			Util.debug("Only one parameter can be displayed with gradient in the same time"); // to change by a popup after maybe
			comboBox.setSelectedIndex(0);
		}
		if (comboBox == moteChooser.comboBox)
			mapPanel.setMoteLegend((String)comboBox.getSelectedItem());
		else if (comboBox == moteIdChooser.comboBox)
			mapPanel.setMoteIdLegend((String)comboBox.getSelectedItem());
		if (comboBox == samplingPeriodChooser.comboBox)
			mapPanel.setSamplingPeriodLegend((String)comboBox.getSelectedItem());
		else if (comboBox == parentIdChooser.comboBox)
			mapPanel.setParentIdLegend((String)comboBox.getSelectedItem());
		else if (comboBox == countChooser.comboBox)
			mapPanel.setCountLegend((String)comboBox.getSelectedItem());
		else if (comboBox == readingChooser.comboBox)
			mapPanel.setReadingLegend((String)comboBox.getSelectedItem());
		else if (comboBox == qualityChooser.comboBox)
			mapPanel.setQualityLegend((String)comboBox.getSelectedItem());
		else if (comboBox == lastTimeSeenChooser.comboBox)
			mapPanel.setLastTimeSeenLegend((String)comboBox.getSelectedItem());
		else if (comboBox == routeChooser.comboBox)
			mapPanel.setRouteLegend((String)comboBox.getSelectedItem());
	}
	
	/*
		Function called when a slider is moved.
	*/
	
	public void stateChanged(ChangeEvent e) {
        JSlider source = (JSlider)e.getSource();
		if (!source.getValueIsAdjusting()) 		// we wait a release by the user
			mapPanel.setTimeout((int)source.getValue());
	}
	
	private int getNumberOfChoosersEqualTo(String str) {
		int ret=0;
		LegendChooserPanel lcp;
		if (str.equals(moteChooser.getSelectedItem())) ret++;
		if (str.equals(moteIdChooser.getSelectedItem())) ret++;
		if (str.equals(samplingPeriodChooser.getSelectedItem())) ret++;
		if (str.equals(parentIdChooser.getSelectedItem())) ret++;
		if (str.equals(countChooser.getSelectedItem())) ret++;
		if (str.equals(readingChooser.getSelectedItem()))	ret++;
		if (str.equals(qualityChooser.getSelectedItem()))	ret++;
		if (str.equals(lastTimeSeenChooser.getSelectedItem())) ret++;
		if (str.equals(routeChooser.getSelectedItem())) ret++;
		return ret;
	}
	
}

class LegendChooserPanel extends JPanel {
	private JLabel title;
	public JComboBox comboBox;
	
	public LegendChooserPanel(String title, String[] list) {
		super(new GridLayout(1,2));
		this.title = new JLabel(title);
		comboBox = new JComboBox(list);
		comboBox.setSelectedIndex(0);
		add(this.title);
		add(this.comboBox);
	}
	public void addActionListener(ActionListener a) { comboBox.addActionListener(a);}
	public void setSelectedIndex(int i) {comboBox.setSelectedIndex(i);}
	public String getSelectedItem() { return (String)comboBox.getSelectedItem();}
}