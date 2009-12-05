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
 * This class simulates the Control Panel of a Oscilloscope,
 * and respond to user's controls.
 *
 * Original version by:
 *    @author Jason Hill and Eric Heien
 * Modified by:
 *    @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */

package oscope;



import Config.OasisConstants;
import java.util.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;
import javax.swing.border.TitledBorder;
import monitor.MainClass;

public class ControlPanel extends JPanel implements ActionListener, 
	                                                ItemListener, ChangeListener
{
    //JButton wave_lookup = new JButton("Wave Lookup");  ->Use reset button
  //  JButton submit = new JButton("Submit");
    JButton move_up = new JButton("^");
    JButton move_down = new JButton("v");
    JButton move_right = new JButton(">");
    JButton move_left = new JButton("<");
    JButton zoom_out_x = new JButton("Zoom Out X");
    JButton zoom_in_x = new JButton("Zoom In X");
    JButton zoom_out_y = new JButton("Zoom Out Y");
    JButton zoom_in_y = new JButton("Zoom In Y");
    JButton zoom_in_screen = new JButton("Zoom In Screen");
    JButton zoom_out_screen = new JButton("Zoom Out Screen");
    JButton reset = new JButton("Reset");
    JButton save_data = new JButton("Save Data");
    JButton load_data = new JButton("Load Data");
    JButton editLegend = new JButton("Edit Legend");
    JButton clear_data = new JButton("Clear Dataset");
    JCheckBox showLegend = new JCheckBox("Show Legend", true);
    JCheckBox connect_points = new JCheckBox("Connect Datapoints", true);
    JCheckBox YAxisHex = new JCheckBox("hex Y Axis", false);
    JCheckBox scrolling = new JCheckBox("Scrolling", true);
    JSlider time_location = new JSlider(0, 100, 100);
    JComboBox moteList;

	//Andy: Remove type choice 
	//add for displaying different type of data
	/*
       JRadioButton seismic_bt = new JRadioButton("Seismic          ");
	JRadioButton infrasonic_bt = new JRadioButton("Infrasonic                 ");
	JRadioButton lightning_bt = new JRadioButton("Lightning         ");
	*/

	SpinnerListModel typeList ;
	JSpinner spinner ;
	
	JCheckBox checktype = new JCheckBox("",false);
	public static Hashtable checkTypeTable = new Hashtable();
	public static Hashtable selectedDataType = new Hashtable(); 
	public static final int TYPE_CHECK = 1;
	public static final int TYPE_UNCHECK = 0;
	
	JRadioButton RTCtime_bt = new JRadioButton("RTC time                 ");
	JRadioButton PCtime_bt = new JRadioButton("PC time         ");

	public Hashtable legendEdit = new Hashtable();
	public Hashtable legendActive = new Hashtable(); 
	private boolean allMoteEvent = false;
	private boolean singleMoteEvent = false;
	private JCheckBox allMote;

	ScopeDriver scopeDriver = null;
	public static int TYPE = 0;
	public static int THRESHOLD = 100;
	public static int UPPERTHRESHOLD = 500;
	public static int LOWERTHRESHOLD = 70;
	public static int TIMETYPE = OasisConstants.PC_TIME;
	//public static int count = 0;
	

    /**
     * Get the ScopeDriver value.
     * @return the ScopeDriver value.
     */
    public ScopeDriver getScopeDriver() {
	return scopeDriver;
    }

    /**
     * Set the ScopeDriver value.
     * @param newScopeDriver The new ScopeDriver value.
     */
    public void setScopeDriver(ScopeDriver newScopeDriver) {
	this.scopeDriver = newScopeDriver;
	this.scopeDriver.setControlPanel(this);
    }

    
    GraphPanel panel;

    public ControlPanel(GraphPanel _panel) { 
	panel = _panel; 
	legendEdit = new Hashtable();
	legendActive = new Hashtable(); 

	// Compared with the previous implementation, we are replacing the
	// heavyweight components (java.awt.Panel) with the lightweight Swing
	// equivalent.  This should hopefully allow for more flexible use of
	// this control panel 
    time_location.addChangeListener(this);
	JPanel x_pan = new JPanel();
	x_pan.setLayout(new GridLayout(6,1));
	x_pan.add(zoom_in_x);
	x_pan.add(zoom_out_x); 
	x_pan.add(save_data); 
	x_pan.add(editLegend); 
	x_pan.add(clear_data); 
	zoom_out_x.addActionListener(this);
	zoom_in_x.addActionListener(this);
	save_data.addActionListener(this);
	editLegend.addActionListener(this);
	clear_data.addActionListener(this);
	add(x_pan);

	
	JPanel y_pan = new JPanel();
	y_pan.setLayout(new GridLayout(6,1));
	y_pan.add(zoom_in_y);
	y_pan.add(zoom_out_y); 
	y_pan.add(load_data); 
	showLegend.setSelected(panel.isLegendEnabled());
	y_pan.add(showLegend);
	connect_points.setSelected(panel.isConnectPoints());
	y_pan.add(connect_points); 
	zoom_out_y.addActionListener(this);
	zoom_in_y.addActionListener(this);
	load_data.addActionListener(this);
	showLegend.addItemListener(this);
	connect_points.addItemListener(this);
	add(y_pan);
	
	JPanel scroll_pan = new JPanel();
	move_up.addActionListener(this);
	move_down.addActionListener(this);
	move_right.addActionListener(this);
	move_left.addActionListener(this);
	reset.addActionListener(this);
	move_up.setMnemonic(KeyEvent.VK_UP);
	move_down.setMnemonic(KeyEvent.VK_DOWN);
	move_right.setMnemonic(KeyEvent.VK_RIGHT);
	move_left.setMnemonic(KeyEvent.VK_LEFT);
	reset.setMnemonic(KeyEvent.VK_ENTER);
	
	GridBagLayout		g = new GridBagLayout();
	GridBagConstraints	c = new GridBagConstraints();
	scroll_pan.setLayout(g);
	
	c.gridx = 1;
	c.gridy = 0;
	g.setConstraints( move_up, c );
	scroll_pan.add(move_up);
	c.gridx = 0;
	c.gridy = 1;
	g.setConstraints( move_left, c );
	scroll_pan.add(move_left);
	c.gridx = 1;
	c.gridy = 1;
	g.setConstraints( reset, c );
	scroll_pan.add(reset);
	c.gridx = 2;
	c.gridy = 1;
	g.setConstraints( move_right, c );
	scroll_pan.add(move_right);
	c.gridx = 1;
	c.gridy = 2;
	g.setConstraints( move_down, c );
	scroll_pan.add(move_down);
	add(scroll_pan);

	JPanel p = new JPanel();
	p.setLayout(new GridLayout(4, 1));
	YAxisHex.setSelected(panel.isHexAxis());
	p.add(YAxisHex); YAxisHex.addItemListener(this);
	p.add(scrolling); scrolling.addItemListener(this);
	p.add(time_location);
	add(p);

	//Andy: Remove type choice 
	//Add data type choices:
	/*
	JPanel t = new JPanel();
	TitledBorder paneEdge = BorderFactory.createTitledBorder("Displayed Data Type :");
       t.setBorder(paneEdge);
	t.setLayout(new GridLayout(3,1));
	t.add(seismic_bt);
	t.add(infrasonic_bt);
	t.add(lightning_bt);
	seismic_bt.setSelected(true);
	*/
	JPanel t = new JPanel();
	TitledBorder paneEdge = BorderFactory.createTitledBorder("Displayed Data Type :");
       t.setBorder(paneEdge);
	t.setLayout(new BorderLayout());
	String[] dataType = new String[128];
	for (int i = 0 ; i < 128 ; i++)
		dataType[i] = i+"";
	typeList = new SpinnerListModel(dataType);
	spinner = new JSpinner(typeList);
	t.add(spinner,BorderLayout.CENTER);
	t.add(checktype,BorderLayout.EAST);
	spinner.addChangeListener(this);
	checktype.addItemListener(this);
	checktype.setSelected(true);
	checkTypeTable.put(new Integer(0),new Integer(TYPE_CHECK));
	for (int i = 1 ; i < 128 ; i++)
		checkTypeTable.put(new Integer(i),new Integer(TYPE_UNCHECK));

	
	//Add time type choices:
	JPanel t1 = new JPanel();
	TitledBorder paneEdge1 = BorderFactory.createTitledBorder("Time Type :");
  	t1.setBorder(paneEdge1);
	t1.setLayout(new GridLayout(3,1));
	t1.add(PCtime_bt);
	t1.add(RTCtime_bt);
	PCtime_bt.setSelected(true);
	ButtonGroup timeGroup = new ButtonGroup();
	timeGroup.add(RTCtime_bt);
	timeGroup.add(PCtime_bt);
	RTCtime_bt.addItemListener(this);
	PCtime_bt.addItemListener(this);
       JPanel t3 = new JPanel();
       t3.setLayout(new BorderLayout());
       t3.add(t,BorderLayout.NORTH); 
	t3.add(t1,BorderLayout.CENTER);
	add(t3);

	/*
	JPanel t4 = new JPanel();
       t4.setLayout(new BorderLayout());
       t4.add(submit,BorderLayout.CENTER); 
	submit.addActionListener(this);
	add(t4);
	*/
	
	//Andy: Remove type choice 
	//Group the radio buttons.
	/*
    ButtonGroup group = new ButtonGroup();
    group.add(seismic_bt);
    group.add(infrasonic_bt);
    group.add(lightning_bt);
	
	 //Register a listener for the radio buttons.
    seismic_bt.addItemListener(this);
    infrasonic_bt.addItemListener(this);
    lightning_bt.addItemListener(this);
  */

	 final String zoomInScreen = "ZoomIn"; 
        panel.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW)
            .put(KeyStroke.getKeyStroke(new Character('='),0),zoomInScreen);
        panel.getActionMap().put(zoomInScreen, new AbstractAction() {
            public void actionPerformed(ActionEvent ignored) {
                	panel.zoom_in_x();
			panel.zoom_in_y();
			panel.repaint();
            }
        });
        
        final String zoomOutScreen = "ZoomOut"; 
        panel.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW)
            .put(KeyStroke.getKeyStroke(new Character('-'),0),zoomOutScreen);
        panel.getActionMap().put(zoomOutScreen, new AbstractAction() {
            public void actionPerformed(ActionEvent ignored) {
                    	panel.zoom_out_x();
			panel.zoom_out_y();
			panel.repaint();
            }
        });



	//8/12/2008 Allow buttons in the Control Panel to run when buttons have focus and Enter Key is pressed
	final String setZoomInX = "Zoom in X"; 
	       zoom_in_x.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setZoomInX);
	        zoom_in_x.getActionMap().put(setZoomInX, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
	            		    panel.zoom_in_x();
				    panel.repaint();
	           }
	      });


	final String setZoomOutX = "Zoom out X"; 
	       zoom_out_x.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setZoomOutX);
	        zoom_out_x.getActionMap().put(setZoomOutX, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
	                         panel.zoom_out_x();
				    panel.repaint();
	           }
	      });
	
	
	final String setZoomInY = "Zoom in Y"; 
	       zoom_in_y.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setZoomInY);
	        zoom_in_y.getActionMap().put(setZoomInY, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
	            		    panel.zoom_in_x();
				    panel.repaint();
	           }
	      });


	final String setZoomOutY = "Zoom out Y"; 
	       zoom_out_y.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setZoomOutY);
	        zoom_out_y.getActionMap().put(setZoomOutY, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
	                         panel.zoom_out_y();
				    panel.repaint();
	           }
	      });

	//8/12/2008 Allow buttons in the Control Panel to run when buttons have focus and Enter Key is pressed
	final String setLoadData = "Load Data"; 
	       load_data.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setLoadData);
	        load_data.getActionMap().put(setLoadData, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
	            		   if (scopeDriver != null) 
				    	scopeDriver.load_data();
				    panel.repaint();
	           }
	      });


	final String setSaveData = "Zoom out Y"; 
	       save_data.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setSaveData);
	        save_data.getActionMap().put(setSaveData, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
			    panel.save_data();
			    panel.repaint();
	           }
	      });


	final String setEditLegend = "Edit Legend"; 
	       editLegend .getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setEditLegend);
	        editLegend.getActionMap().put(setEditLegend, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
			    EscapeFrame legend = new EscapeFrame("Edit Legend");
			    legend.setSize(new Dimension(200,500));
			    legend.setVisible(true);
			    JPanel slp = new JPanel();
			    createLegendEdit(slp);
			    legend.getContentPane().add(new JScrollPane(slp));
			    legend.pack();
			    legend.show();
			    legend.repaint();
	           }
	      });


	final String setClearData = "Clear Data"; 
	       clear_data.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setClearData);
	        clear_data.getActionMap().put(setClearData, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
			     /*panel.clear_data();
			     panel.repaint();*/
			     if (PCtime_bt.isSelected()) {
					TIMETYPE = OasisConstants.PC_TIME;
					ScopeDriver.startTime = System.currentTimeMillis();
					scopeDriver.resetChannel();
					scopeDriver.resetFirstMessage();
					panel.clear_data();
					panel.repaint();
					scopeDriver.calculateLookupValue();
		    			panel.reset(scopeDriver.getX_lookupValueTail(),scopeDriver.getX_lookupValueHead(),scopeDriver.getY_lookupValueMin(),scopeDriver.getY_lookupValueMax());
		    			panel.repaint();
				}
				 else {
				 	TIMETYPE = OasisConstants.RTC_TIME;
					scopeDriver.resetChannel();
					panel.clear_data();
					panel.repaint();
					scopeDriver.calculateLookupValue();
		 			//panel.reset(scopeDriver.getX_lookupValueTail(),scopeDriver.getX_lookupValueHead(),scopeDriver.getY_lookupValueMin(),scopeDriver.getY_lookupValueMax());
					panel.repaint();
				 }
	           }
	      });


	final String setShowLegend = "Show Legend"; 
	       showLegend.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setShowLegend);
	        showLegend.getActionMap().put(setShowLegend, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
				showLegend.setSelected(!showLegend.isSelected());
				panel.setLegendEnabled(showLegend.isSelected());
	           }
	      });

	final String setConnectDatapoint = "Connect Points"; 
	       connect_points.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setConnectDatapoint);
	        connect_points.getActionMap().put(setConnectDatapoint, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
				connect_points.setSelected(!connect_points.isSelected());
				panel.setConnectPoints(connect_points.isSelected());
	           }
	      });

	final String setMoveUp = "Move Up"; 
	       move_up.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setMoveUp);
	        move_up.getActionMap().put(setMoveUp, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
				panel.move_up();
	    			panel.repaint();
	           }
	      });

	final String setMoveDown = "Move Down"; 
	       move_down.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setMoveDown);
	        move_down.getActionMap().put(setMoveDown, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
				panel.move_down();
	    			panel.repaint();
	           }
	      });

	final String setMoveRight = "Move Right"; 
	       move_right.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setMoveRight);
	        move_right.getActionMap().put(setMoveRight, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
				panel.move_right();
	    			panel.repaint();
	           }
	      });

	final String setMoveLeft = "Move Left"; 
	       move_left.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setMoveLeft);
	        move_left.getActionMap().put(setMoveLeft, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
				panel.move_left();
	    			panel.repaint();
	           }
	      });

	final String setReset = "Reset"; 
	       reset.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setReset);
	        reset.getActionMap().put(setReset, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
			    scopeDriver.calculateLookupValue();
			    panel.reset(scopeDriver.getX_lookupValueTail(),scopeDriver.getX_lookupValueHead(),scopeDriver.getY_lookupValueMin(),scopeDriver.getY_lookupValueMax());
			    panel.repaint();
	           }
	      });

	final String setYAxisHex = "Hex Y Axis"; 
	       YAxisHex.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setYAxisHex);
	        YAxisHex.getActionMap().put(setYAxisHex, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
				YAxisHex.setSelected(!YAxisHex.isSelected());
				panel.setHexAxis(YAxisHex.isSelected());
	           }
	      });

	final String setScrolling = "Scrolling"; 
	       scrolling.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setScrolling);
	        scrolling.getActionMap().put(setScrolling, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
				scrolling.setSelected(!scrolling.isSelected());
				panel.setSliding(scrolling.isSelected());
	           }
	      });

      final String setPCtime = "Set PC Time"; 
	       PCtime_bt.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setPCtime);
	        PCtime_bt.getActionMap().put(setPCtime, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
				boolean on = !PCtime_bt.isSelected();
				System.out.println("PC " + on);
				RTCtime_bt.setSelected(false);
				PCtime_bt.setSelected(true);
				if (on) {
					TIMETYPE = OasisConstants.PC_TIME;
					ScopeDriver.startTime = System.currentTimeMillis();
					scopeDriver.resetChannel();
					scopeDriver.resetFirstMessage();
					panel.clear_data();
					panel.repaint();
					scopeDriver.calculateLookupValue();
		    			panel.reset(scopeDriver.getX_lookupValueTail(),scopeDriver.getX_lookupValueHead(),scopeDriver.getY_lookupValueMin(),scopeDriver.getY_lookupValueMax());
		    			panel.repaint();
				}
	           }
	      });

	 final String setRTCtime = "Set RTC Time"; 
	       RTCtime_bt.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setRTCtime);
	        RTCtime_bt.getActionMap().put(setRTCtime, new AbstractAction() {
	            public void actionPerformed(ActionEvent ignored) {
				boolean on = !RTCtime_bt.isSelected();
				System.out.println("RTC " + on);
				PCtime_bt.setSelected(false);
				RTCtime_bt.setSelected(true);
				if (on) {
					TIMETYPE = OasisConstants.RTC_TIME;
					scopeDriver.resetChannel();
					panel.clear_data();
					panel.repaint();
					scopeDriver.calculateLookupValue();
		 			//panel.reset(scopeDriver.getX_lookupValueTail(),scopeDriver.getX_lookupValueHead(),scopeDriver.getY_lookupValueMin(),scopeDriver.getY_lookupValueMax());
					panel.repaint();
				}
	           }
	      });


	//8/12/2008 End
		
    }

	/*
    protected void createLegendEdit(JPanel p) {
	JCheckBox act;
	JTextField leg; 
	GridBagLayout g = new GridBagLayout();  
	GridBagConstraints constraints = new GridBagConstraints();
	p.setLayout(g);
	if (panel == null) { 
	    return; 
	}
	Vector channels = panel.getChannels(); 
	legendActive.clear();
	legendEdit.clear();
	for ( int i= 0; i< channels.size(); i++) { 
	    Channel c = (Channel) channels.elementAt(i); 
	    leg = new JTextField(30); 
	    leg.setText(c.getDataLegend());
	    legendEdit.put(leg, c); 
	    leg.addActionListener(this);
	    act = new JCheckBox("Channel "+(i+1)); 
	    act.setSelected(c.isActive());
	    legendActive.put(act, c); 
	    act.addChangeListener(this);
	    constraints.gridwidth = GridBagConstraints.RELATIVE;
	    g.setConstraints(act, constraints);
	    p.add(act);
	    constraints.gridwidth = GridBagConstraints.REMAINDER;
	    g.setConstraints(leg, constraints);
	    p.add(leg); 
	}
    }*/

  protected void predefineLegendEdit(){
  	JCheckBox act;
	JTextField leg; 

	if (panel == null) { 
	    return; 
	}
	Vector channels = panel.getChannels(); 
	legendActive.clear();
	legendEdit.clear();

	leg = new JTextField(30); 
	leg.setText("All mote");
	allMote = new JCheckBox(); 
	allMote.setSelected(false);
	allMote.addChangeListener(this);

	
	for ( int i= 0; i< channels.size(); i++) { 
	    Channel c = (Channel) channels.elementAt(i); 
	    Hashtable dataChannel = c.getDataChannel();
	    Enumeration k = dataChannel.keys();
	    while (k.hasMoreElements()) {
			Integer key = (Integer) k.nextElement();
			DataChannel channelType = (DataChannel)dataChannel.get(key);
			leg = new JTextField(30); 
			leg.setText(c.getDataLegend() + "   Type " + channelType.getType());
			legendEdit.put(leg, channelType); 
			leg.addActionListener(this);
			act = new JCheckBox(); 
			act.setSelected(channelType.getEnable());
			legendActive.put(act, channelType); 
			act.addChangeListener(this);
		}
	}
}

   protected void createLegendEdit(JPanel p) {
   	boolean allMoteSelected = true;
	JCheckBox act;
	JTextField leg; 
	GridBagLayout g = new GridBagLayout();  
	GridBagConstraints constraints = new GridBagConstraints();
	p.setLayout(g);
	if (panel == null) { 
	    return; 
	}
	Vector channels = panel.getChannels(); 
	legendActive.clear();
	legendEdit.clear();

	  leg = new JTextField(30); 
	  leg.setText("All mote");
	  allMote = new JCheckBox(); 
	  constraints.gridwidth = GridBagConstraints.RELATIVE;
	  g.setConstraints(allMote, constraints);
	  constraints.gridwidth = GridBagConstraints.REMAINDER;
	  g.setConstraints(leg, constraints);
	  //allMote.addChangeListener(this);
	  allMote.addItemListener(this);
	  p.add(allMote);
	  p.add(leg); 

	
	for ( int i= 0; i< channels.size(); i++) { 
	    Channel c = (Channel) channels.elementAt(i); 
	    Hashtable dataChannel = c.getDataChannel();
	    Enumeration k = dataChannel.keys();
	    while (k.hasMoreElements()) {
			Integer key = (Integer) k.nextElement();
			DataChannel channelType = (DataChannel)dataChannel.get(key);
			leg = new JTextField(30); 
			leg.setText(c.getDataLegend() + "   Type " + channelType.getType());
			legendEdit.put(leg, channelType); 
			leg.addActionListener(this);
			act = new JCheckBox(); 
			//System.out.println("???"+channelType.getEnable());
			act.setSelected(channelType.getEnable());
			if (!channelType.getEnable()){
				allMoteSelected = false;
			}
			legendActive.put(act, channelType); 
			//act.addChangeListener(this);
			act.addItemListener(this);
			constraints.gridwidth = GridBagConstraints.RELATIVE;
			g.setConstraints(act, constraints);
			p.add(act);
			constraints.gridwidth = GridBagConstraints.REMAINDER;
			g.setConstraints(leg, constraints);
			p.add(leg); 	
		}
	}

	 allMote.setSelected(allMoteSelected);
    }

    public void actionPerformed(ActionEvent e) {
	Object src = e.getSource();
	Object c = legendEdit.get(src);
	if (c != null) { 
	    if (c instanceof Channel) { 
		((Channel)c).setDataLegend(((JTextField)src).getText());
		panel.repaint(100); 
	    }
	}
	if (src == zoom_out_x) {
	    panel.zoom_out_x();
	    panel.repaint();
	} else if (src == zoom_in_x) {
	    panel.zoom_in_x();
	    panel.repaint();
	} else if (src == zoom_out_y) {
	    panel.zoom_out_y();
	    panel.repaint();
	} else if (src == zoom_in_y) {
	    panel.zoom_in_y();
	    panel.repaint();
	}else if (src == zoom_in_screen) {
	    panel.zoom_in_x();
           panel.zoom_in_y();
	    panel.repaint();
	} else if (src == zoom_out_screen) {
	    panel.zoom_out_x();
           panel.zoom_out_y();
	    panel.repaint();
	} else if (src == move_up) {
	    panel.move_up();
	    panel.repaint();
	} else if (src == move_down) {
	    panel.move_down();
	    panel.repaint();
	} else if (src == move_right) {
	    panel.move_right();
	    panel.repaint();
	} else if (src == move_left) {
	    panel.move_left();
	    panel.repaint();
	} else if (src == reset) {
		
		scopeDriver.resetChannel();
					panel.clear_data();
					panel.repaint();
					
	    scopeDriver.calculateLookupValue();
		//System.out.println(scopeDriver.getX_lookupValueTail()+" "+scopeDriver.getX_lookupValueHead()+" "+scopeDriver.getY_lookupValueMin()+" "+scopeDriver.getY_lookupValueMax());
	    
	    panel.reset(scopeDriver.getX_lookupValueTail(),scopeDriver.getX_lookupValueHead(),scopeDriver.getY_lookupValueMin(),scopeDriver.getY_lookupValueMax());
	    panel.repaint();
	} else if (src == clear_data) {
			 if (PCtime_bt.isSelected()) {
					TIMETYPE = OasisConstants.PC_TIME;
					ScopeDriver.startTime = System.currentTimeMillis();
					scopeDriver.resetChannel();
					scopeDriver.resetFirstMessage();
					panel.clear_data();
					panel.repaint();
					scopeDriver.calculateLookupValue();
		    			panel.reset(scopeDriver.getX_lookupValueTail(),scopeDriver.getX_lookupValueHead(),scopeDriver.getY_lookupValueMin(),scopeDriver.getY_lookupValueMax());
		    			panel.repaint();
				}
				 else {
				 	TIMETYPE = OasisConstants.RTC_TIME;
					scopeDriver.resetChannel();
					panel.clear_data();
					panel.repaint();
					scopeDriver.calculateLookupValue();
		 			//panel.reset(scopeDriver.getX_lookupValueTail(),scopeDriver.getX_lookupValueHead(),scopeDriver.getY_lookupValueMin(),scopeDriver.getY_lookupValueMax());
					panel.repaint();
				 }
	   /* panel.clear_data();
	    panel.repaint();*/
	} /*else if (src == submit) {
	    popupWindow();
    //YFH: not implement yet, leave the interface here for later use----
	} */else if (src == load_data) {
	    if (scopeDriver != null) 
	    	scopeDriver.load_data();
	    panel.repaint();
	} else if (src == save_data) {
	    panel.save_data();
	    panel.repaint();
    //-------------------------------------------------------------------

	} else if (src == editLegend) {
	    EscapeFrame legend = new EscapeFrame("Edit Legend");
	    legend.setSize(new Dimension(200,500));
	    legend.setVisible(true);
	    JPanel slp = new JPanel();
	    createLegendEdit(slp);
	    legend.getContentPane().add(new JScrollPane(slp));
	    legend.pack();
	    legend.show();
	    legend.repaint();
	}
    }


	// 1/8/2008 Andy Allow the EditLegend Frame to close on Escape Key by customizing the JFrame to Escape Frame
	public class EscapeFrame extends JFrame {

		  public EscapeFrame(String title) {
		    super(title);
		  }

		  protected JRootPane createRootPane() {
		    ActionListener actionListener = new ActionListener() {
		      public void actionPerformed(ActionEvent actionEvent) {
			  	dispose();
		      }
		    };
		    JRootPane rootPane = new JRootPane();
		    KeyStroke stroke = KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0);
		    rootPane.registerKeyboardAction(actionListener, stroke, JComponent.WHEN_IN_FOCUSED_WINDOW);
		    return rootPane;
		  }
		}
	// 1/8/2008 End
	

    public void itemStateChanged(ItemEvent e) {
		Object src = e.getSource();
		boolean on = e.getStateChange() == ItemEvent.SELECTED;
		if (src == scrolling) {
			panel.setSliding(on);
		}
		else if (src == showLegend) {
			panel.setLegendEnabled(on);
		}
		else if (src == connect_points) {
			panel.setConnectPoints(on);
		}
		else if (src == YAxisHex) {
			panel.setHexAxis(on);
		}
		else if (src == RTCtime_bt){
			if (on) {
				TIMETYPE = OasisConstants.RTC_TIME;
				scopeDriver.resetChannel();
				panel.clear_data();
				panel.repaint();
				scopeDriver.calculateLookupValue();
	 			//panel.reset(scopeDriver.getX_lookupValueTail(),scopeDriver.getX_lookupValueHead(),scopeDriver.getY_lookupValueMin(),scopeDriver.getY_lookupValueMax());
				panel.repaint();
			}
		}
		else if (src == PCtime_bt){
			if (on) {
				TIMETYPE = OasisConstants.PC_TIME;
				ScopeDriver.startTime = System.currentTimeMillis();
				scopeDriver.resetChannel();
				scopeDriver.resetFirstMessage();
				panel.clear_data();
				panel.repaint();
				scopeDriver.calculateLookupValue();
	    			panel.reset(scopeDriver.getX_lookupValueTail(),scopeDriver.getX_lookupValueHead(),scopeDriver.getY_lookupValueMin(),scopeDriver.getY_lookupValueMax());
	    			panel.repaint();
			}
		} 
		else if (src == checktype){
			
			int dataType = Integer.parseInt(spinner.getValue().toString()) ;
			if (dataType > 127 || dataType < 0)
			  	javax.swing.JOptionPane.showMessageDialog(null,"Input is a number range 0 - 127","Warning",JOptionPane.ERROR_MESSAGE);
			else {
				checkTypeTable.remove(new Integer(dataType));
				if (on){
					Integer selectedType = (Integer)selectedDataType.get(new Integer(dataType));
					if (selectedType == null){
						selectedDataType.put(new Integer(dataType),new Integer(TYPE_CHECK));
					}
					else {
						selectedDataType.remove(new Integer(dataType));
						selectedDataType.put(new Integer(dataType),new Integer(TYPE_CHECK));
					}
					checkTypeTable.put(new Integer(dataType), new Integer(TYPE_CHECK));
				}
				else {
					Integer selectedType = (Integer)selectedDataType.get(new Integer(dataType));
					if (selectedType == null){
						selectedDataType.put(new Integer(dataType),new Integer(TYPE_UNCHECK));
					}
					else {
						selectedDataType.remove(new Integer(dataType));
						selectedDataType.put(new Integer(dataType),new Integer(TYPE_UNCHECK));
					}
					checkTypeTable.put(new Integer(dataType), new Integer(TYPE_UNCHECK));
				}

				Enumeration k = legendActive.keys();
				while (k.hasMoreElements()) {
					JCheckBox key = (JCheckBox) k.nextElement();
					DataChannel datachannel = (DataChannel)legendActive.get(key);
					if (datachannel.type == dataType){
						datachannel.setEnable(on);
						key.setSelected(on);
					}	
				}
				
			}
			
		}else if(src == allMote) {
			//System.out.println("all mote change item");
			allMoteEvent = true;
		if (!singleMoteEvent){
			Enumeration k = legendActive.keys();
			while (k.hasMoreElements()) {
				JCheckBox key = (JCheckBox) k.nextElement();
				DataChannel dataChannel = (DataChannel)legendActive.get(key); 
				key.setSelected(allMote.isSelected());
				
				//System.out.println("legend all set");
				dataChannel.setEnable(allMote.isSelected());
			}
			//updateAllTypeSpinner();
		}
		allMoteEvent = false;
		
		
		
		}
		
		
		Object c = legendActive.get(src); 
	
	if ((c != null) && (c instanceof DataChannel)) {
	//System.out.println("mote changes item");
		 if (!allMoteEvent){
			singleMoteEvent = true;
			//System.out.println("legend set");
			((DataChannel)c).setEnable(((JCheckBox)src).isSelected());
			
			boolean allmoteSelected = true;
			Enumeration checkBoxList = legendActive.keys();
			while (checkBoxList.hasMoreElements()) {
				JCheckBox key = (JCheckBox) checkBoxList.nextElement();
				if (!key.isSelected()){
					allmoteSelected = false;
					break;
				}
			}		
			if (allmoteSelected){allMote.setSelected(true);} else {allMote.setSelected(false);}
			//updateDataTypeSpinner();
			scopeDriver.calculateLookupValue();
			panel.reset(scopeDriver.getX_lookupValueTail(),scopeDriver.getX_lookupValueHead(),scopeDriver.getY_lookupValueMin(),scopeDriver.getY_lookupValueMax());  
			singleMoteEvent = false;
	     }	
	
	}
    }

    public void stateChanged(ChangeEvent e){
	Object src = e.getSource();
	

	if(src == time_location) {
	  double percent = (time_location.getValue() / 100.0);
	  int diff = panel.end - panel.start;
	  panel.end = panel.minimum_x + (int)((panel.maximum_x - panel.minimum_x) * percent);
	  panel.start = panel.end - diff;
	}
	AbstractButton abstractButton = (AbstractButton)src;
	
	System.out.println(src+"   "+abstractButton.isSelected());
	if (src == allMote){
	 	allMoteEvent = true;
		if (!singleMoteEvent){
			Enumeration k = legendActive.keys();
			while (k.hasMoreElements()) {
				JCheckBox key = (JCheckBox) k.nextElement();
				DataChannel dataChannel = (DataChannel)legendActive.get(key); 
				key.setSelected(allMote.isSelected());
				
				System.out.println("legend all set");
				dataChannel.setEnable(allMote.isSelected());
			}
			//updateAllTypeSpinner();
		}
		allMoteEvent = false;
	}  

	
	Object c = legendActive.get(src); 
	
	if ((c != null) && (c instanceof DataChannel)) {
	    if (!allMoteEvent){
			singleMoteEvent = true;
			System.out.println("legend set");
			((DataChannel)c).setEnable(((JCheckBox)src).isSelected());
			
			boolean allmoteSelected = true;
			Enumeration checkBoxList = legendActive.keys();
			while (checkBoxList.hasMoreElements()) {
				JCheckBox key = (JCheckBox) checkBoxList.nextElement();
				if (!key.isSelected()){
					allmoteSelected = false;
					break;
				}
			}		
			//if (allmoteSelected){allMote.setSelected(true);} else {allMote.setSelected(false);}
			//updateDataTypeSpinner();
			scopeDriver.calculateLookupValue();
			panel.reset(scopeDriver.getX_lookupValueTail(),scopeDriver.getX_lookupValueHead(),scopeDriver.getY_lookupValueMin(),scopeDriver.getY_lookupValueMax());  
			singleMoteEvent = false;
	     }	
	}
	
	if (src == spinner){
	try{
		int dataType = Integer.parseInt(spinner.getValue().toString()) ;
		if (dataType > 127 || dataType < 0)
		  	javax.swing.JOptionPane.showMessageDialog(null,"Input is a number range 0 - 127","Warning",JOptionPane.ERROR_MESSAGE);
		else {
			Integer dataChecked = (Integer)checkTypeTable.get(new Integer(dataType));
			if (dataChecked.intValue() == TYPE_CHECK){
				Integer selectedType = (Integer)selectedDataType.get(new Integer(dataType));
				if (selectedType == null){
					selectedDataType.put(new Integer(dataType),new Integer(TYPE_CHECK));
				}
				else {
					selectedDataType.remove(new Integer(dataType));
					selectedDataType.put(new Integer(dataType),new Integer(TYPE_CHECK));
				}
				checktype.setSelected(true);
			}
			else {
				Integer selectedType = (Integer)selectedDataType.get(new Integer(dataType));
				if (selectedType == null){
					selectedDataType.put(new Integer(dataType),new Integer(TYPE_UNCHECK));
				}
				else {
					selectedDataType.remove(new Integer(dataType));
					selectedDataType.put(new Integer(dataType),new Integer(TYPE_UNCHECK));
				}
				checktype.setSelected(false);
			}
		}
	    }
     catch (java.lang.NumberFormatException ex){
		javax.swing.JOptionPane.showMessageDialog(null,"Input is a number range 0 - 127","Warning",JOptionPane.ERROR_MESSAGE);
		}
	}
	
	panel.repaint( 100 );
    }


	public void updateDataTypeSpinner(){

		Enumeration k = selectedDataType.keys();
		while (k.hasMoreElements()) {
			Integer key = (Integer) k.nextElement();	
			selectedDataType.remove(key);
			selectedDataType.put(key, new Integer(TYPE_UNCHECK));		
		}

		
		Enumeration k1 = legendActive.keys();
		while (k1.hasMoreElements()) {
			JCheckBox key1 = (JCheckBox) k1.nextElement();
			DataChannel dataChannel = (DataChannel)legendActive.get(key1); 
			Enumeration k2 = selectedDataType.keys();
			while (k2.hasMoreElements()) {
				Integer key2 = (Integer) k2.nextElement();	
				if (key1.isSelected() && dataChannel.type == key2.intValue()){
					selectedDataType.remove(key2);
					if (allMote.isSelected())
						selectedDataType.put(key2,new Integer(TYPE_CHECK));
					else 
						selectedDataType.put(key2,new Integer(TYPE_UNCHECK));
					break;
				}
			}
		}	
		

		k = selectedDataType.keys();
		int dataType = Integer.parseInt(spinner.getValue().toString()) ;
		while (k.hasMoreElements()) {
			Integer key = (Integer) k.nextElement();	
			Integer type = (Integer)selectedDataType.get(key); 
			//System.out.println(key + " " + type);
			if (type.intValue() == TYPE_UNCHECK){
				checkTypeTable.remove(key);
				checkTypeTable.put(key, new Integer(TYPE_UNCHECK));
				if (dataType == key.intValue())
					checktype.setSelected(false);
			}		
		}
	}


	public void updateAllTypeSpinner(){

		Enumeration k = selectedDataType.keys();
		while (k.hasMoreElements()) {
			Integer key = (Integer) k.nextElement();	
			selectedDataType.remove(key);
			selectedDataType.put(key, new Integer(TYPE_UNCHECK));		
		}
		

		k = selectedDataType.keys();
		int dataType = Integer.parseInt(spinner.getValue().toString()) ;
		while (k.hasMoreElements()) {
			Integer key = (Integer) k.nextElement();	
			Integer type = (Integer)selectedDataType.get(key); 
			if (type.intValue() == TYPE_UNCHECK){
				checkTypeTable.remove(key);
				checkTypeTable.put(key, new Integer(TYPE_UNCHECK));
				if (dataType == key.intValue())
					checktype.setSelected(false);
			}	
			else {
				checkTypeTable.remove(key);
				checkTypeTable.put(key, new Integer(TYPE_CHECK));
				if (dataType == key.intValue())
					checktype.setSelected(true);
			}
		}
	}

	/*
	public void popupWindow(){
		SensingPanel popup = new SensingPanel();
		popup.show();
		popup.repaint();
	}
	*/


	private class SensingPanel extends  javax.swing.JDialog{

             SensingDisplayPanel displayPanel = null ;
		  
				
		public SensingPanel(){
			super (MainClass.mainFrame);
			setDefaultCloseOperation(javax.swing.JFrame.DISPOSE_ON_CLOSE);

			setModal(true);  
			setSize(700,300);
		 	setResizable(false); 
			setLocationRelativeTo(null);
			displayPanel = new SensingDisplayPanel();
			getContentPane().setLayout(new BorderLayout());
			getContentPane().add(displayPanel, BorderLayout.CENTER);
		}	

		protected class SensingDisplayPanel extends JPanel{

		    Image offscreen;
		    Dimension offscreensize;
		    Graphics offgraphics;
		    boolean connectPoints = true;
		    double bottom, top;
  		    int start, end;


			public SensingDisplayPanel(){
				
				setDefaultCloseOperation(javax.swing.JFrame.DISPOSE_ON_CLOSE);
				setModal(true);  
				setSize(700,300);
			 	setResizable(false); 
				setLocationRelativeTo(null);
				//ADOConnection.getPointForDisplaying("4-9-2008",44154860,44155400,8,0);
			}	
			
			public synchronized void paintComponent(Graphics g) {
		  
		  	Dimension d = getSize();
				//get the end value of the window.
				//int end = this.end;
		  		if ((offscreen == null) || (d.width != offscreensize.width) || (d.height != offscreensize.height)) {
				    offscreen = createImage(d.width, d.height);
				    offscreensize = d;
				    if (offgraphics != null) {
					offgraphics.dispose();
				    }
				    offgraphics = offscreen.getGraphics();
				    offgraphics.setFont(getFont());
				}
				//blank the screen.
				offgraphics.setColor(Color.black);
				offgraphics.fillRect(0, 0, d.width, d.height);
		  	offgraphics.setColor(Color.red);
			Vector temp = new Vector();
		  	draw_data(offgraphics, temp, 0,0, 0);
			g.drawImage(offscreen, 0, 0, null); 
		  }
		
		void draw_data(Graphics g, Vector data, int start, int end, int scale){
			
			/*
		      ResultSet rs = ADOConnection.getPointForDisplaying("4-9-2008",44154860,44155400,8,0);
			int count = 0;
		      Point2D screen = null, screen2 = null;
		      boolean noplot=true;  // Used for line plotting
			try {
				while (rs.next()) {
					System.out.println(count++);
					Point2D virt;
					
					if(rs.getString("Value") != null) {
					  virt = new Point2D(Integer.parseInt(rs.getString("TimeStamp")), Integer.parseInt(rs.getString("Value")));
					  screen = virtualToScreen(virt);
					  if (screen.getX() >= 0 && screen.getX() < getSize().width) {
					    if(connectPoints && !noplot)
					      g.drawLine((int)screen2.getX(), (int)screen2.getY(), (int)screen.getX(), (int)screen.getY());
					    else if( !connectPoints )
					      g.drawRect((int)screen.getX(), (int)screen.getY(), 1, 1);
					    if (noplot) noplot = false;
					  } else {
					    noplot = true;
					  }
					}
					screen2 = screen;
				}
			}
			catch (Exception ex){}

	
			try{
				rs.close();
			}
			catch (Exception ex){}
			*/
			
			/*
		      ResultSet rs = ADOConnection.getPointForDisplaying("4-9-2008",44154860,44155400,8,0);
			
		      Point2D screen = null, screen2 = null;
		      boolean noplot=true;  // Used for line plotting

		      for(int i = 0; i < data.size(); i ++){
			Point2D virt;

			if((data.get(i)) != null) {
			  virt = new Point2D(((java.awt.geom.Point2D)data.get(i)).getX(), ((java.awt.geom.Point2D)data.get(i)).getY());
			  screen = virtualToScreen(virt);
			  if (screen.getX() >= 0 && screen.getX() < getSize().width) {
			    if(connectPoints && !noplot)
			      g.drawLine((int)screen2.getX(), (int)screen2.getY(), (int)screen.getX(), (int)screen.getY());
			    else if( !connectPoints )
			      g.drawRect((int)screen.getX(), (int)screen.getY(), 1, 1);
			    if (noplot) noplot = false;
			  } else {
			    noplot = true;
			  }
			}
			screen2 = screen;
		      }
			 */
		    }

		Point2D virtualToScreen(Point2D virt) {
			double xoff = virt.getX() - start;
			double xpos = xoff / (end*1.0 - start*1.0);
			double screen_xpos = xpos * getSize().width;

			double yoff = virt.getY() - bottom;
			double ypos = yoff / (top*1.0 - bottom*1.0);
			double screen_ypos = getSize().height - (ypos * getSize().height);
			
			return new Point2D(screen_xpos, screen_ypos);
		    }
		 }

		
		protected class Point2D {
		      double x, y;

		      Point2D(double newX, double newY) {
			x = newX;
			y = newY;
		      }

		      double getX() {
			return x;
		      }

		      double getY() {
			return y;
		      }

		      public String toString() {
			return x+","+y;
		      }
		    }

	}
}

