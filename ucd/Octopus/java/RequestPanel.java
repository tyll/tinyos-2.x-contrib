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
import javax.swing.BorderFactory;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import java.io.*;
import java.util.Iterator;
import java.util.LinkedList;
import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

/*
	This class is a panel containing the requests needed by a user.
	The panel describes the status of the mote selected.

	TODO :
	BUG :
*/

class RequestPanel extends JPanel implements ActionListener, ChangeListener, ItemListener{
	private JLabel moteLabel, batteryLabel;
	private JCheckBox checkBoxBroadcast;
	private JButton autoModeButton, queryModeButton;
	private JButton sleepButton, wakeUpButton;
	private JSlider sleepSlider, awakeSlider, periodSlider, thresholdSlider;
	private JButton readingButton;
	private JLabel readingLabel;

	private ChartPanel chartPanel;
	private JButton toChartButton, allToChartButton, clearChartButton;

	private MsgSender sender;
	private MoteDatabase moteDatabase;
	private LinkedList selectedMotesList;
	private boolean broadcastRequest;

	public RequestPanel(MoteDatabase moteDatabase, ChartPanel chartPanel, MsgSender sender) {
		super(new GridBagLayout());
		new WaitThread(sender,moteDatabase).start();
		// Mote label
		moteLabel = new JLabel("No mote selected");

		// Broadcast requests
		checkBoxBroadcast = new JCheckBox("Broadcast");
		checkBoxBroadcast.addItemListener(this);
		checkBoxBroadcast.setSelected(false);

		// Battery label
		batteryLabel = new JLabel("Battery : 0 %");

		// Request Mode
		autoModeButton = new JButton("Auto");
		autoModeButton.setActionCommand("auto");
		autoModeButton.setVerticalTextPosition(AbstractButton.CENTER);
		autoModeButton.setHorizontalTextPosition(AbstractButton.LEADING);
		autoModeButton.setEnabled(true);
		autoModeButton.addActionListener(this);
		queryModeButton = new JButton("Query");
		queryModeButton.setActionCommand("query");
		queryModeButton.setVerticalTextPosition(AbstractButton.CENTER);
		queryModeButton.setHorizontalTextPosition(AbstractButton.LEADING);
		queryModeButton.setEnabled(true);
		queryModeButton.addActionListener(this);

		// Request layout
		JPanel tmpRequestPanel = new JPanel(new GridBagLayout());
		GridBagConstraints c = new GridBagConstraints();
		c.weighty = 1;	c.weightx = 1;
		c.anchor = GridBagConstraints.PAGE_START;
		c.fill = GridBagConstraints.HORIZONTAL;
		c.insets = new Insets(2,2,2,2);
		c.gridx = 0; c.gridy = 0; c.gridwidth = 1; tmpRequestPanel.add(autoModeButton, c);
		c.gridx = 1; c.gridy = 0; c.gridwidth = 1; tmpRequestPanel.add(queryModeButton, c);
		tmpRequestPanel.setBorder(BorderFactory.createTitledBorder("Request Mode"));

		// Sleep
		sleepButton = new JButton("To Sleep");
		sleepButton.setActionCommand("sleep");
		sleepButton.setVerticalTextPosition(AbstractButton.CENTER);
		sleepButton.setHorizontalTextPosition(AbstractButton.LEADING);
		sleepButton.setEnabled(true);
		sleepButton.addActionListener(this);
		wakeUpButton = new JButton("Wake Up");
		wakeUpButton.setActionCommand("wakeup");
		wakeUpButton.setVerticalTextPosition(AbstractButton.CENTER);
		wakeUpButton.setHorizontalTextPosition(AbstractButton.LEADING);
		wakeUpButton.setEnabled(true);
		wakeUpButton.addActionListener(this);

		// sleep layout
		JPanel tmpSleepPanel = new JPanel(new GridBagLayout());
		c = new GridBagConstraints();
		c.weighty = 1;	c.weightx = 1;
		c.anchor = GridBagConstraints.PAGE_START;
		c.fill = GridBagConstraints.HORIZONTAL;
		c.insets = new Insets(2,2,2,2);
		c.gridx = 0; c.gridy = 0; c.gridwidth = 1; tmpSleepPanel.add(sleepButton, c);
		c.gridx = 1; c.gridy = 0; c.gridwidth = 1; tmpSleepPanel.add(wakeUpButton, c);
		tmpSleepPanel.setBorder(BorderFactory.createTitledBorder("Sleep Mode"));

		sleepSlider = new JSlider(JSlider.HORIZONTAL, 0, 100, Util.dutyCycleToPercent(Constants.DEFAULT_SLEEP_DUTY_CYCLE));
		sleepSlider.addChangeListener(this);
		sleepSlider.setMajorTickSpacing(10);
		sleepSlider.setMinorTickSpacing(2);
		sleepSlider.setPaintTicks(true);
		sleepSlider.setPaintLabels(true);
		sleepSlider.setBorder(BorderFactory.createTitledBorder("Sleep Duty Cycle (in %)"));

		awakeSlider = new JSlider(JSlider.HORIZONTAL, 0, 100, Util.dutyCycleToPercent(Constants.DEFAULT_AWAKE_DUTY_CYCLE));
		awakeSlider.addChangeListener(this);
		awakeSlider.setMajorTickSpacing(10);
		awakeSlider.setMinorTickSpacing(2);
		awakeSlider.setPaintTicks(true);
		awakeSlider.setPaintLabels(true);
		awakeSlider.setBorder(BorderFactory.createTitledBorder("Awake Duty Cycle (in %)"));

		// Sensors
		periodSlider = new JSlider(JSlider.HORIZONTAL, 0, 65535, Constants.DEFAULT_SAMPLING_PERIOD);
		periodSlider.addChangeListener(this);
		periodSlider.setMajorTickSpacing(20000);
		periodSlider.setMinorTickSpacing(2000);
		periodSlider.setPaintTicks(true);
		periodSlider.setPaintLabels(true);
		periodSlider.setBorder(BorderFactory.createTitledBorder("Period Sampling (in ms)"));

		thresholdSlider = new JSlider(JSlider.HORIZONTAL, 0, 100, Util.thresholdToPercent(Constants.DEFAULT_THRESHOLD));
		thresholdSlider.addChangeListener(this);
		thresholdSlider.setMajorTickSpacing(10);
		thresholdSlider.setMinorTickSpacing(2);
		thresholdSlider.setPaintTicks(true);
		thresholdSlider.setPaintLabels(true);
		thresholdSlider.setBorder(BorderFactory.createTitledBorder("Threshold (in %)"));

		// Sensor
		readingButton = new JButton("Read the sensor");
		readingLabel = new JLabel("No reading");
		readingButton.setActionCommand("reading");
		readingButton.setVerticalTextPosition(AbstractButton.CENTER);
		readingButton.setHorizontalTextPosition(AbstractButton.LEADING);
		readingButton.setEnabled(true);
		readingButton.addActionListener(this);

		// Sensor layout
		JPanel tmpSensorPanel = new JPanel(new GridBagLayout());
		c = new GridBagConstraints();
		c.weighty = 1;	c.weightx = 1;
		c.anchor = GridBagConstraints.PAGE_START;
		c.fill = GridBagConstraints.HORIZONTAL;
		c.insets = new Insets(2,2,2,2);
		c.gridx = 0; c.gridy = 0; c.gridwidth = 2; tmpSensorPanel.add(readingLabel, c);
		c.gridx = 2; c.gridy = 0; c.gridwidth = 1; tmpSensorPanel.add(readingButton, c);
		tmpSensorPanel.setBorder(BorderFactory.createTitledBorder("Sensor"));

		// Chart
		toChartButton = new JButton("Add Selected");
		toChartButton.setActionCommand("add");
		toChartButton.setVerticalTextPosition(AbstractButton.CENTER);
		toChartButton.setHorizontalTextPosition(AbstractButton.LEADING);
		toChartButton.setEnabled(true);
		toChartButton.addActionListener(this);
		allToChartButton = new JButton("Add All");
		allToChartButton.setActionCommand("addall");
		allToChartButton.setVerticalTextPosition(AbstractButton.CENTER);
		allToChartButton.setHorizontalTextPosition(AbstractButton.LEADING);
		allToChartButton.setEnabled(true);
		allToChartButton.addActionListener(this);
		clearChartButton = new JButton("Clear");
		clearChartButton.setActionCommand("clear");
		clearChartButton.setVerticalTextPosition(AbstractButton.CENTER);
		clearChartButton.setHorizontalTextPosition(AbstractButton.LEADING);
		clearChartButton.setEnabled(true);
		clearChartButton.addActionListener(this);

		// chart layout
		JPanel tmpChartPanel = new JPanel(new GridBagLayout());
		c = new GridBagConstraints();
		c.weighty = 1;	c.weightx = 1;
		c.anchor = GridBagConstraints.PAGE_START;
		c.fill = GridBagConstraints.HORIZONTAL;
		c.insets = new Insets(2,2,2,2);
		c.gridx = 0; c.gridy = 0; c.gridwidth = 1; tmpChartPanel.add(toChartButton, c);
		c.gridx = 1; c.gridy = 0; c.gridwidth = 1; tmpChartPanel.add(allToChartButton, c);
		c.gridx = 2; c.gridy = 0; c.gridwidth = 1; tmpChartPanel.add(clearChartButton, c);
		tmpChartPanel.setBorder(BorderFactory.createTitledBorder("Choose the motes displayed in the chart"));


		// Boot
		JButton bootButton = new JButton("Boot Network");
		bootButton.setActionCommand("bootNet");
		bootButton.setVerticalTextPosition(AbstractButton.CENTER);
		bootButton.setHorizontalTextPosition(AbstractButton.LEADING);
		bootButton.setEnabled(true);
		bootButton.addActionListener(this);

		// Boot layout
		JPanel bootPanel = new JPanel(new GridBagLayout());
		c = new GridBagConstraints();
		c.weighty = 1;	c.weightx = 1;
		c.anchor = GridBagConstraints.PAGE_START;
		c.fill = GridBagConstraints.HORIZONTAL;
		c.insets = new Insets(2,2,2,2);

		c.gridx = 2; c.gridy = 0; c.gridwidth = 1; bootPanel.add(bootButton, c);
		bootPanel.setBorder(BorderFactory.createTitledBorder("Boot"));

		// layout
		c = new GridBagConstraints();
		c.weighty = 1; c.weightx = 1;
		c.anchor = GridBagConstraints.PAGE_START;
		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0; c.gridy = 0; c.gridwidth = 2; add(moteLabel, c);
		c.gridx = 2; c.gridy = 0; c.gridwidth = 1; add(checkBoxBroadcast, c);
		c.gridx = 0; c.gridy = 1; c.gridwidth = 3; add(batteryLabel, c);
		c.gridx = 0; c.gridy = 2; c.gridwidth = 0; add(tmpRequestPanel, c);
		c.gridx = 0; c.gridy = 3; c.gridwidth = 3; add(tmpSleepPanel, c);
		c.gridx = 0; c.gridy = 4; c.gridwidth = 3; add(sleepSlider, c);
		c.gridx = 0; c.gridy = 5; c.gridwidth = 3; add(awakeSlider, c);
		c.gridx = 0; c.gridy = 6; c.gridwidth = 3; add(periodSlider, c);
		c.gridx = 0; c.gridy = 7; c.gridwidth = 3; add(thresholdSlider, c);
		c.gridx = 0; c.gridy = 8; c.gridwidth = 0; add(tmpSensorPanel, c);
		c.gridx = 0; c.gridy = 9; c.gridwidth = 3; add(tmpChartPanel, c);
		c.gridx = 0; c.gridy = 10; c.gridwidth = 3; add(bootPanel, c);

		// network
		this.sender = sender;
		this.moteDatabase = moteDatabase;
		this.chartPanel = chartPanel;
		broadcastRequest = false;
		selectedMotesList = new LinkedList();

		displayMoteState();
	}

	/*
		Function called when a checkbox is checked
		or unchecked.
	*/

	public void itemStateChanged(ItemEvent e) {
		Object source = e.getItemSelectable();
		// if the checkbox was deselected
		if (e.getStateChange() == ItemEvent.DESELECTED) {
			if (source == checkBoxBroadcast)
				broadcastRequest = false;
		// if the checkbox was selected
		} else if (source == checkBoxBroadcast)
			broadcastRequest = true;
		displayMoteState();
	}

	/*
		Function called when a button is pressed.
		We don't have any acknowledgement so we have to
		assume the request is well executed, so we have
		to update the database.
	*/

	public void actionPerformed(ActionEvent e) {
		Mote localMote;
		// chart
		if ("add".equals(e.getActionCommand())) {
			// the list of motes selected by requestPanel is added to the chartPanel
			for (Iterator it=selectedMotesList.listIterator(0); it.hasNext(); ) {
				localMote = (Mote)it.next();
				chartPanel.addMote(localMote);
			}
		} else if ("addall".equals(e.getActionCommand())) {
			// all the motes are added to the chartPanel
			for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
				localMote = (Mote)it.next();
				chartPanel.addMote(localMote);
			}
		} else if ("clear".equals(e.getActionCommand())) {
			// all the motes are removed from the chartPanel
			chartPanel.deleteMotes();
		}
		// request
		if (selectedMotesList.size()>=0 || broadcastRequest){
			if ("sleep".equals(e.getActionCommand())) {
				if (broadcastRequest) {
					sender.add(MoteIF.TOS_BCAST_ADDR, (int)Constants.SLEEP_REQUEST,
						0, "setSleeping() [Id=broadcast]");
					for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
						localMote = (Mote)it.next();
						localMote.setSleeping();
					}
				} else {
					for (Iterator it=(Iterator)selectedMotesList.listIterator(); it.hasNext(); ) {
						localMote = (Mote)it.next();
						sender.add(localMote.getMoteId(), (int)Constants.SLEEP_REQUEST,
							0, "setSleeping() [Id="+localMote.getMoteId()+"]");
						localMote.setSleeping();
					}
				}
				displayMoteState();
			} else if ("wakeup".equals(e.getActionCommand())) {
				if (broadcastRequest) {
					sender.add(MoteIF.TOS_BCAST_ADDR, (int)Constants.WAKE_UP_REQUEST,
						0, "setAwake() [Id=broadcast]");
					for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
						localMote = (Mote)it.next();
						localMote.setAwake();
					}
				} else {
					for (Iterator it=(Iterator)selectedMotesList.listIterator(); it.hasNext(); ) {
						localMote = (Mote)it.next();
						sender.add(localMote.getMoteId(), (int)Constants.WAKE_UP_REQUEST,
							0, "setAwake() [Id="+localMote.getMoteId()+"]");
						localMote.setAwake();
					}
				}
				displayMoteState();
			} else if ("auto".equals(e.getActionCommand())) {
				if (broadcastRequest) {
					sender.add(MoteIF.TOS_BCAST_ADDR, (int)Constants.SET_MODE_AUTO_REQUEST,
						0, "setModeAuto() [Id=broadcast]");
					for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
						localMote = (Mote)it.next();
						localMote.setModeAuto();
					}
				} else {
					for (Iterator it=(Iterator)selectedMotesList.listIterator(); it.hasNext(); ) {
						localMote = (Mote)it.next();
						sender.add(localMote.getMoteId(), (int)Constants.SET_MODE_AUTO_REQUEST,
							0, "setModeAuto() [Id="+localMote.getMoteId()+"]");
						localMote.setModeAuto();
					}
				}
				displayMoteState();
			} else if ("query".equals(e.getActionCommand())) {
				if (broadcastRequest) {
					sender.add(MoteIF.TOS_BCAST_ADDR, (int)Constants.SET_MODE_QUERY_REQUEST,
						0, "setModeQuery() [Id=broadcast]");
					for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
						localMote = (Mote)it.next();
						localMote.setModeQuery();
					}
				} else {
					for (Iterator it=(Iterator)selectedMotesList.listIterator(); it.hasNext(); ) {
						localMote = (Mote)it.next();
						sender.add(localMote.getMoteId(), (int)Constants.SET_MODE_QUERY_REQUEST,
							0, "setModeQuery() [Id="+localMote.getMoteId()+"]");
						localMote.setModeQuery();
					}
				}
				displayMoteState();
			} else if ("reading".equals(e.getActionCommand())) {
				if (broadcastRequest) {
					sender.add(MoteIF.TOS_BCAST_ADDR, (int)Constants.GET_READING_REQUEST,
						0, "Reading() [Id=broadcast]");
				} else {
					for (Iterator it=(Iterator)selectedMotesList.listIterator(); it.hasNext(); ) {
						localMote = (Mote)it.next();
						sender.add(localMote.getMoteId(), (int)Constants.GET_READING_REQUEST,
							0, "Reading() [Id="+localMote.getMoteId()+"]");
					}
				}
			}else if("bootNet".equals(e.getActionCommand())) {
				sender.add(MoteIF.TOS_BCAST_ADDR,Constants.BOOT_REQUEST,0,"Sending Boot Message");
			}
		}
	}



	/*
		Function called when a slider is moved. The request is sent
		only when the user release the button of the mouse.
	*/

	public void stateChanged(ChangeEvent e) {
        JSlider source = (JSlider)e.getSource();
		Mote localMote;
		if (selectedMotesList.size()>=1 || broadcastRequest){
			if (!source.getValueIsAdjusting()) { 	// we wait a release by the user
				if(source == sleepSlider) {
					if (broadcastRequest) {
						sender.add(MoteIF.TOS_BCAST_ADDR, (int)Constants.SET_SLEEP_DUTY_CYCLE_REQUEST,
							Util.dutyCycleToInt((int)source.getValue()),
							"Set SleepDutyCycle = "+(int)source.getValue()+"% [Id=broadcast]");
						for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
							localMote = (Mote)it.next();
							localMote.setSleepDutyCycle(Util.dutyCycleToInt((int)source.getValue()));
						}
					} else {
						for (Iterator it=(Iterator)selectedMotesList.listIterator(); it.hasNext(); ) {
							localMote = (Mote)it.next();
							sender.add(localMote.getMoteId(), (int)Constants.SET_SLEEP_DUTY_CYCLE_REQUEST,
								Util.dutyCycleToInt((int)source.getValue()),
								"Set SleepDutyCycle = "+(int)source.getValue()+"% [Id="+localMote.getMoteId()+"]");
							localMote.setSleepDutyCycle(Util.dutyCycleToInt((int)source.getValue()));
						}
					}
					displayMoteState();
				} else if(source == awakeSlider) {
					if (broadcastRequest) {
						sender.add(MoteIF.TOS_BCAST_ADDR, (int)Constants.SET_AWAKE_DUTY_CYCLE_REQUEST,
							Util.dutyCycleToInt((int)source.getValue()),
							"Set AwakeDutyCycle = "+(int)source.getValue()+"% [Id=broadcast]");
						for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
							localMote = (Mote)it.next();
							localMote.setAwakeDutyCycle(Util.dutyCycleToInt((int)source.getValue()));
						}
					} else {
						for (Iterator it=(Iterator)selectedMotesList.listIterator(); it.hasNext(); ) {
							localMote = (Mote)it.next();
							sender.add(localMote.getMoteId(), (int)Constants.SET_AWAKE_DUTY_CYCLE_REQUEST,
								Util.dutyCycleToInt((int)source.getValue()),
								"Set AwakeDutyCycle = "+(int)source.getValue()+"% [Id="+localMote.getMoteId()+"]");
							localMote.setAwakeDutyCycle(Util.dutyCycleToInt((int)source.getValue()));
						}
					}
					displayMoteState();
				} else if(source == periodSlider) {
					if ((int)source.getValue() < Constants.MINIMUM_SAMPLING_PERIOD) {
						periodSlider.removeChangeListener(this);
						source.setValue(Constants.MINIMUM_SAMPLING_PERIOD);
						periodSlider.addChangeListener(this);
					}
					if (broadcastRequest) {
						sender.add(MoteIF.TOS_BCAST_ADDR, (int)Constants.SET_PERIOD_REQUEST,
							(int)source.getValue(), "Set PeriodSampling = "+(int)source.getValue()+"ms [Id=broadcast]");
						for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
							localMote = (Mote)it.next();
							localMote.setSamplingPeriod((int)source.getValue());
						}
					} else {
						for (Iterator it=(Iterator)selectedMotesList.listIterator(); it.hasNext(); ) {
							localMote = (Mote)it.next();
							sender.add(localMote.getMoteId(), (int)Constants.SET_PERIOD_REQUEST,
								(int)source.getValue(), "Set PeriodSampling = "+(int)source.getValue()+"ms [Id="+localMote.getMoteId()+"]");
							localMote.setSamplingPeriod((int)source.getValue());
						}
					}
					displayMoteState();
				} else if(source == thresholdSlider) {
					if (broadcastRequest) {
						sender.add(MoteIF.TOS_BCAST_ADDR, (int)Constants.SET_THRESHOLD_REQUEST,
							Util.thresholdToInt((int)source.getValue()),
							"Set Threshold = "+(int)source.getValue()+"% [Id=broadcast]");
						for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
							localMote = (Mote)it.next();
							localMote.setThreshold((int)source.getValue());
						}
					} else {
						for (Iterator it=(Iterator)selectedMotesList.listIterator(); it.hasNext(); ) {
							localMote = (Mote)it.next();
							sender.add(localMote.getMoteId(), (int)Constants.SET_THRESHOLD_REQUEST,
								Util.thresholdToInt((int)source.getValue()),
								"Set Threshold = "+(int)source.getValue()+"% [Id="+localMote.getMoteId()+"]");
							localMote.setThreshold((int)source.getValue());
						}
					}
					displayMoteState();
				}
	        }
		}
    }

	/*
		Function used to display the state of the current
		mote selected. If the checkbox for broadcast is checked,
		all the buttons are enabled. If more than one mote is selected,
		all the buttons are enabled.
	*/

	public void displayMoteState() {
		if (broadcastRequest || selectedMotesList.size() > 1) {
			if (broadcastRequest)
				moteLabel.setText("All Motes selected");
			else
				moteLabel.setText("Many Motes selected");
			//batteryLabel.setText("Battery : 0%"); // to change
			queryModeButton.setEnabled(true);
			autoModeButton.setEnabled(true);
			wakeUpButton.setEnabled(true);
			sleepButton.setEnabled(true);

			sleepSlider.removeChangeListener(this);
			sleepSlider.setValue(Util.dutyCycleToPercent(Constants.DEFAULT_SLEEP_DUTY_CYCLE));
			sleepSlider.setEnabled(true);
			sleepSlider.addChangeListener(this);

			awakeSlider.removeChangeListener(this);
			awakeSlider.setValue(Util.dutyCycleToPercent(Constants.DEFAULT_AWAKE_DUTY_CYCLE));
			awakeSlider.setEnabled(true);
			awakeSlider.addChangeListener(this);

			periodSlider.removeChangeListener(this);
			periodSlider.setValue(Constants.DEFAULT_SAMPLING_PERIOD);
			periodSlider.setEnabled(true);
			periodSlider.addChangeListener(this);

			thresholdSlider.removeChangeListener(this);
			thresholdSlider.setValue(Util.thresholdToPercent(Constants.DEFAULT_THRESHOLD));
			thresholdSlider.setEnabled(true);
			thresholdSlider.addChangeListener(this);

			readingButton.setEnabled(true);
			readingLabel.setText("reading : ");
		} else {
			if (selectedMotesList.size() == 1)
				displayMoteState((Mote)selectedMotesList.getFirst());
			else
				displayMoteState(null);
		}
	}

	/*
		Function used to display the state of the current
		mote selected. If mote equals null, the buttons are
		disabled.
	*/

	public void displayMoteState(Mote mote) {
		if(mote != null) {
			moteLabel.setText("Mote " + mote.getMoteId() + " selected");
			//batteryLabel.setText("Battery : 0%"); // to change
			if (mote.isInModeAuto()) {
				autoModeButton.setEnabled(false);
				queryModeButton.setEnabled(true);
			} else {
				autoModeButton.setEnabled(true);
				queryModeButton.setEnabled(false);
			}
			if (mote.isSleeping()) {
				sleepButton.setEnabled(false);
				wakeUpButton.setEnabled(true);
			} else {
				sleepButton.setEnabled(true);
				wakeUpButton.setEnabled(false);
			}
			sleepSlider.removeChangeListener(this);
			sleepSlider.setValue(mote.getSleepDutyCycle());
			sleepSlider.setEnabled(true);
			sleepSlider.addChangeListener(this);

			awakeSlider.removeChangeListener(this);
			awakeSlider.setValue(mote.getAwakeDutyCycle());
			awakeSlider.setEnabled(true);
			awakeSlider.addChangeListener(this);

			periodSlider.removeChangeListener(this);
			periodSlider.setValue(mote.getSamplingPeriod());
			periodSlider.setEnabled(true);
			periodSlider.addChangeListener(this);

			thresholdSlider.removeChangeListener(this);
			thresholdSlider.setValue(mote.getThreshold());
			thresholdSlider.setEnabled(true);
			thresholdSlider.addChangeListener(this);

			if (!mote.isInModeAuto())
				readingButton.setEnabled(true);
			else
				readingButton.setEnabled(false);
			readingLabel.setText("reading : " + mote.getReading());

		} else {
			moteLabel.setText("No specific mote selected");
			//batteryLabel.setText("Battery : 0%");
			autoModeButton.setEnabled(false);
			queryModeButton.setEnabled(false);
			sleepButton.setEnabled(false);
			wakeUpButton.setEnabled(false);

			sleepSlider.removeChangeListener(this);
			sleepSlider.setValue(0);
			sleepSlider.setEnabled(false);
			sleepSlider.addChangeListener(this);

			awakeSlider.removeChangeListener(this);
			awakeSlider.setEnabled(false);
			awakeSlider.setValue(0);
			awakeSlider.addChangeListener(this);

			periodSlider.removeChangeListener(this);
			periodSlider.setEnabled(false);
			periodSlider.setValue(0);
			periodSlider.addChangeListener(this);

			thresholdSlider.removeChangeListener(this);
			thresholdSlider.setEnabled(false);
			thresholdSlider.setValue(0);
			thresholdSlider.addChangeListener(this);

			readingButton.setEnabled(false);
			readingLabel.setText("no reading");
		}
	}

	/*
		The functions below are used to add or remove a mote to the
		list of selected motes.
	*/

	public void selectMote(Mote mote) {
		if (mote!=null)
			selectedMotesList.add(mote);
		displayMoteState();
	}

	public void unselectMote(Mote mote) {
		if (mote!=null)
			selectedMotesList.remove(mote);
		displayMoteState();
	}

	public void unselectMotes() {
		selectedMotesList.clear();
		displayMoteState();
	}

	public boolean moteIsSelected(Mote mote) {
		//if (broadcastRequest)
		//	return false;
		if (mote!=null)
			return selectedMotesList.contains(mote);
		else
			return false;
	}

	public Iterator getSelectedMotesListIterator() {
		return selectedMotesList.listIterator(0);
	}

	public int getNumberOfSelectedMotes() {
		return selectedMotesList.size();
	}

	/*
		Function called by any process or thread which has updated
		a mote. The RequestPanel checks if the mote was displayed
		and if so, its parameters are updated.
	*/

	public void moteUpdatedEvent(Mote mote) {
		if (moteIsSelected(mote) && !broadcastRequest)
			displayMoteState();
	}
}


