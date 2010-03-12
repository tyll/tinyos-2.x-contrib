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
 * This is the class that displays a Dialog to get
 * the configuration of event report from user.
 * It needs the support from Rpc.
 *
 *
 * @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */



package monitor;



import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.Dimension;

import java.awt.event.*;


import java.util.Vector;

import javax.swing.border.TitledBorder;
import javax.swing.*;



public class ReportConfigDialog extends javax.swing.JDialog { 

	public static final int		CANCEL      = 200;
	public static final int		SET			= 201;

	private JPanel			jContentPane	= null;
	
	private JPanel			jConfigPane		= null;
	private JRadioButton    jtALL			= new JRadioButton("All");
	private JRadioButton    jtSNMS			= new JRadioButton("SNMS");
	private JRadioButton    jtSENSING		= new JRadioButton("SENSING");
	private JRadioButton    jtMIDDLEWARE	= new JRadioButton("MIDDLEWARE       ");
	private JRadioButton    jtROUTING		= new JRadioButton("ROUTING");
	private JRadioButton    jtMAC			= new JRadioButton("MAC");
	public ButtonGroup      tgroup          = null;

	private JRadioButton    jlURGENT		= new JRadioButton("URGENT         ");
	private JRadioButton    jlHIGH			= new JRadioButton("HIGH");
	private JRadioButton    jlMEDIUM		= new JRadioButton("MEDIUM");
	private JRadioButton    jlLOW			= new JRadioButton("LOW");
	public ButtonGroup      lgroup          = null;

	private JPanel			JCtlPanel		= null;
	private JButton			jCmdCancel		= null;
	private JButton			jCmdSet 		= null;

	static public Vector    values          = null;
	public Vector			ret             = null;


	/**
	 * This is the default constructor for the setting dialog
	 */
   
	public ReportConfigDialog(Vector values, Vector ret) {
		super (MainClass.mainFrame);
		this.setTitle("Event Log Configuration");
		this.values = values;
		this.ret = ret;

		this.setSize(400,200);
		this.setContentPane(getJContentPane());
		this.setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
		this.setLocationRelativeTo(null);
		this.setModal(true);  //YFH
	}


	/**
	 * This method initializes jContentPane
	 * 
	 * @return javax.swing.JPanel
	 */
	private JPanel getJContentPane() {
		if (jContentPane == null) {
			jContentPane = new JPanel();
			jContentPane.setPreferredSize(new java.awt.Dimension(350, 200));
			jContentPane.setLayout(new BorderLayout());
			jContentPane.add(getJConfigPane(),java.awt.BorderLayout.CENTER);
			jContentPane.add(getJCtlPanel(),java.awt.BorderLayout.SOUTH);
		}
		return jContentPane;
	}


	/**
	 * This method initializes jConfigPane
	 * 
	 * @return javax.swing.JPanel
	 */
	private JPanel getJConfigPane() {
		if (jConfigPane == null) {
			jConfigPane = new JPanel();
			jConfigPane.setPreferredSize(new Dimension(350, 170));
			jConfigPane.setSize(new Dimension(350, 170));
			jConfigPane.setLayout(new GridLayout(1,2,5,5));

			//Add choices for event types
			JPanel type = new JPanel();
			TitledBorder tEdge = BorderFactory.createTitledBorder("Event Type :");
			type.setBorder(tEdge);
			type.setLayout(new GridLayout(6,1,5,5));
			type.add(jtALL); jtALL.setActionCommand("0");
			type.add(jtSNMS);jtSNMS.setActionCommand("1");
			type.add(jtSENSING);jtSENSING.setActionCommand("2");
			type.add(jtMIDDLEWARE);jtMIDDLEWARE.setActionCommand("3");
			type.add(jtROUTING);jtROUTING.setActionCommand("4");
			type.add(jtMAC);jtMAC.setActionCommand("5");
			jtALL.setSelected(true);

			tgroup = new ButtonGroup();
			tgroup.add(jtALL);
			tgroup.add(jtSNMS);
			tgroup.add(jtSENSING);
			tgroup.add(jtMIDDLEWARE);
			tgroup.add(jtROUTING);
			tgroup.add(jtMAC);

			//Add choices for event level for selected types
			JPanel level = new JPanel();
			TitledBorder lEdge = BorderFactory.createTitledBorder("Event Level :");
			level.setBorder(lEdge);
			level.setLayout(new GridLayout(4,1,5,5));
			level.add(jlURGENT);  jlURGENT.setActionCommand("0");
			level.add(jlHIGH);  jlHIGH.setActionCommand("1");
			level.add(jlMEDIUM);  jlMEDIUM.setActionCommand("2");
			level.add(jlLOW);  jlLOW.setActionCommand("3");
			jlURGENT.setSelected(true);

			lgroup = new ButtonGroup();
			lgroup.add(jlURGENT);
			lgroup.add(jlHIGH);
			lgroup.add(jlMEDIUM);
			lgroup.add(jlLOW);

			jConfigPane.add(type);
			jConfigPane.add(level);

			
			//8/11/2008 Andy Add Enter_Key Event for each of the Event Type Radio Button

			 final String setJTALLMode = "Set Mode"; 
			        jtALL.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setJTALLMode);
			        jtALL.getActionMap().put(setJTALLMode, new AbstractAction() {
			            public void actionPerformed(ActionEvent ignored) {
			                  jtALL.setSelected(true);
					    repaint();
			            }
			        });

			 final String setJTSNMSMode = "Set Mode"; 
			        jtSNMS.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setJTSNMSMode);
			        jtSNMS.getActionMap().put(setJTSNMSMode, new AbstractAction() {
			            public void actionPerformed(ActionEvent ignored) {
			                  jtSNMS.setSelected(true);
					    repaint();
			            }
			        });

			 final String setJTSensingMode = "Set Mode"; 
			        jtSENSING.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setJTSensingMode);
			        jtSENSING.getActionMap().put(setJTSensingMode, new AbstractAction() {
			            public void actionPerformed(ActionEvent ignored) {
			                  jtSENSING.setSelected(true);
					    repaint();
			            }
			        });


			 final String setJTMiddleWareMode = "Set Mode"; 
			        jtMIDDLEWARE.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setJTMiddleWareMode);
			        jtMIDDLEWARE.getActionMap().put(setJTMiddleWareMode, new AbstractAction() {
			            public void actionPerformed(ActionEvent ignored) {
			                  jtMIDDLEWARE.setSelected(true);
					    repaint();
			            }
			        });

			
			 final String setJTRoutingMode = "Set Mode"; 
			        jtROUTING.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setJTRoutingMode);
			        jtROUTING.getActionMap().put(setJTRoutingMode, new AbstractAction() {
			            public void actionPerformed(ActionEvent ignored) {
			                  jtROUTING.setSelected(true);
					    repaint();
			            }
			        });

			 final String setJTMACMode = "Set Mode"; 
			        jtMAC.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setJTMACMode);
			        jtMAC.getActionMap().put(setJTMACMode, new AbstractAction() {
			            public void actionPerformed(ActionEvent ignored) {
			                  jtMAC.setSelected(true);
					    repaint();
			            }
			        });

					
			//8/11/2008 End

			//8/11/2008 Andy Add Enter_Key Event for each of the Report Level Radio Button

			 final String setJLURGENTMode = "Set Mode"; 
			        jlURGENT.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setJLURGENTMode);
			        jlURGENT.getActionMap().put(setJLURGENTMode, new AbstractAction() {
			            public void actionPerformed(ActionEvent ignored) {
			                  jlURGENT.setSelected(true);
					    repaint();
			            }
			        });

			final String setJLHIGHMode = "Set Mode"; 
			        jlHIGH.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setJLHIGHMode);
			        jlHIGH.getActionMap().put(setJLHIGHMode, new AbstractAction() {
			            public void actionPerformed(ActionEvent ignored) {
			                  jlHIGH.setSelected(true);
					    repaint();
			            }
			        });

			final String setJLMEDIUMMode = "Set Mode"; 
			        jlMEDIUM.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setJLMEDIUMMode);
			        jlMEDIUM.getActionMap().put(setJLMEDIUMMode, new AbstractAction() {
			            public void actionPerformed(ActionEvent ignored) {
			                  jlMEDIUM.setSelected(true);
					    repaint();
			            }
			        });

			final String setJLLOWMode = "Set Mode"; 
			        jlLOW.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),setJLLOWMode);
			        jlLOW.getActionMap().put(setJLLOWMode, new AbstractAction() {
			            public void actionPerformed(ActionEvent ignored) {
			                  jlLOW.setSelected(true);
					    repaint();
			            }
			        });
					
			//8/11/2008 End


			
		}
		return jConfigPane;
	}


	/**
	 * This method initializes JCtlPanel
	 * 
	 * @return javax.swing.JPanel
	 */
	private JPanel getJCtlPanel() {
		if (JCtlPanel == null) {
			JCtlPanel = new JPanel();
			JCtlPanel.setLayout(new GridLayout(1,2,5,5));
			JCtlPanel.setPreferredSize(new Dimension(500, 40));
			JCtlPanel.add(getJCmdSet());
			JCtlPanel.add(getJCmdCancel());

			//Group buttons.
			ButtonGroup group = new ButtonGroup();
			group.add(jCmdSet);
			group.add(jCmdCancel);
		}
		return JCtlPanel;
	}


	/**
	 * This method initializes jCmdSet
	 * 
	 * @return javax.swing.JButton
	 */
	private JButton getJCmdSet() {
		if (jCmdSet == null) {
			jCmdSet = new JButton();
			//jCmdRun.setPreferredSize(new Dimension(150, 30));
			jCmdSet.setText("Set");
			jCmdSet.setName("jCmdSet");
			jCmdSet.addActionListener(new java.awt.event.ActionListener() {
				public void actionPerformed(java.awt.event.ActionEvent e) {
					int i;
					//Get selections
					String typeStr = tgroup.getSelection().getActionCommand(); 
					String levelStr = lgroup.getSelection().getActionCommand(); 
					values.addElement(typeStr);
					values.addElement(levelStr);
			
					//set return value for calling panel
					ret.addElement(new Integer(1));
					ReportConfigDialog.this.dispose();
				}
			});

			
			//8/11/2008 Andy Add Enter_Key Event to Run the SetReportLevel Command when jCmdSet have focus

			  final String runJCmdSet = "Set Mode"; 
			        jCmdSet.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"),runJCmdSet);
			        jCmdSet.getActionMap().put(runJCmdSet, new AbstractAction() {
			            public void actionPerformed(ActionEvent ignored) {
				              int i;
						//Get selections
						String typeStr = tgroup.getSelection().getActionCommand(); 
						String levelStr = lgroup.getSelection().getActionCommand(); 
						values.addElement(typeStr);
						values.addElement(levelStr);
				
						//set return value for calling panel
						ret.addElement(new Integer(1));
						ReportConfigDialog.this.dispose();
			            }
			        });
					
			//8/11/2008 End
			
		}
		return jCmdSet;
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
					//set return value for calling panel
					ret.addElement(new Integer(0));

					/*int i;
					WindowListener[] listeners = ReportConfigDialog.this.getWindowListeners();
					for (i = 0; i< listeners.length; i++){
							listeners[i].windowClosed(new WindowEvent(ReportConfigDialog.this, CANCEL));
					}*/
					ReportConfigDialog.this.dispose();
				}
			});
		}
		return jCmdCancel;
	}


	//Andy 8/11/2008
	protected JRootPane createRootPane() {
		    ActionListener actionListener = new ActionListener() {
		      public void actionPerformed(ActionEvent actionEvent) {
		          ret.addElement(new Integer(0));
 			   ReportConfigDialog.this.dispose();
		      }
		    };
		    JRootPane rootPane = new JRootPane();
		    KeyStroke stroke = KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0);
		    rootPane.registerKeyboardAction(actionListener, stroke, JComponent.WHEN_IN_FOCUSED_WINDOW);
		    return rootPane;
		  }
	//8/11/2008 End    

}

