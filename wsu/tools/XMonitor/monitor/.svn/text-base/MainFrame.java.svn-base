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
 * This class is the MainFrame of Monitor java tool suite
 *  
 * 1. It contains a 3-page tabbed panel: 
 *    Topology page, Message page, and Oscilloscope page; 
 * 2. It provides control button on a toolbar:
 *    perform remote control, remote programming functions
 *
 * Original version by:
 *    @author Wei Hong
 *    @author Matt Welsh
 * Modified by:
 *    @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */
package monitor;

import Config.OasisConstants;
import SensorwebObject.Rpc.NescApp;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Font;
import java.awt.Frame;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.io.File;
import rpc.util.GetEnv;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.AbstractAction;
import javax.swing.BoxLayout;
import javax.swing.DefaultSingleSelectionModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JComponent;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButtonMenuItem;
import javax.swing.JRootPane;
import javax.swing.JScrollPane;
import javax.swing.JSeparator;
import javax.swing.JSpinner;
import javax.swing.JSplitPane;
import javax.swing.JTabbedPane;
import javax.swing.JTextField;
import javax.swing.KeyStroke;
import javax.swing.ScrollPaneConstants;
import javax.swing.SpinnerListModel;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.filechooser.FileFilter;
import monitor.PacketAnalyzer.SensorAnalyzer;
import oscope.*;

import rawdata.MessageDriver;
import rawdata.MessagePanel;
import HE.HEDriver;
import HE.HEPanel;
import rpc.message.MoteIF;
import xml.Parser.XMLMessageParser;


import debug.rpc.*;
import com.oasis.message.*;

public class MainFrame extends javax.swing.JFrame implements ChangeListener, ActionListener, WindowListener {

    public static final int TAB_TOPOLOGY = 0;
    public static final int TAB_RAWDATA = 1;
    public static final int TAB_SENSORREADING = 2;
    public static boolean forceResetPanel = false;
    public static boolean firstSwitch = false;
    public static MoteIF mote;
    //public static NescApp rpcApp;
    public static String xmlPath = null;
     public static String xmpPath = null;
    public static Vector nodeLayout = new Vector();
    public static Font defaultFont = new Font("Helvetica", Font.PLAIN, 10);
    public static Font bigFont = new Font("Helvetica", Font.PLAIN, 12);
    public static Font boldFont = new Font("Helvetica", Font.BOLD, 10);
    public static Color labelColor = new Color(255, 0, 0);
    public static volatile boolean EVENT_LOG_MODE = true;
    public static volatile boolean LAYOUT_MODE = false;
    public static volatile boolean STATUS_MODE = true;
    public static volatile boolean SERVER_MODE = false;
    public static volatile boolean TCP_LOG_MODE = false;
    public static volatile boolean LOG_SENSING_MODE = false;
    //Xiaogang: add email bool value
    public static volatile boolean EMAIL_ENABLE = false;
    //Mingsen: add compression enable bool value
    public static boolean COMPRESSION_ENABLE = false;
    public JFileChooser loadFileChooser = null;
    public JFileChooser saveFileChooser = null;
    public JFileChooser xmlFileChooser = null;
    public static boolean DIALOG_SELECTED = false;
    javax.swing.JPanel MainPanel = new javax.swing.JPanel();
    javax.swing.JToolBar MainToolBar = new javax.swing.JToolBar();
    javax.swing.JScrollPane MainScrollPane = new javax.swing.JScrollPane();
    monitor.GraphDisplayPanel GraphDisplayPanel =
            new monitor.GraphDisplayPanel();
    public ReportPanel reportPanel;
    JSplitPane TopologyPanel;
    JPanel topPanel = new JPanel(new BorderLayout());
    JTabbedPane pane;
    public ControlPanelDialog cPanel;
    String autofit = "Fit to Screen";
    String manualfit = "Manually Deploy";
    JButton fitNetworkNowButton = new JButton();
    JButton setLayoutButton = new JButton("Load Layout ");
    JButton saveLayoutButton = new JButton("Save Layout ");
    JCheckBox toggleLayoutButton = new JCheckBox("Keep Layout");
    JPanel slp;
    //public static DXM_DS_Manager tcpHandler;
    public XMLMessageParser xmp;
    /*
    public static JButton controlPanel = new JButton ("Control Panel ");
    //7/17/2007
    //public static JTextField rpcPathText = new JTextField(40);
    JButton changePathButton = new JButton("Change Xml to ... ");
     */
    private JMenuBar menuBar;
    private JMenu menuControlPanel;
    private JMenuItem menuItemLoadXML,  menuItemLoadRpcXML;
    public static JMenuItem menuItemSendRPC;
    private SymWindow aSymWindow;
    private SymAction lSymAction;
    private GraphPanel channelControl;
    private ScopeDriver driverControl;
    private Hashtable legendEdit = new Hashtable();
    private Hashtable legendActive = new Hashtable();
    private int rpcMoteSelected = -2;
    private boolean allMoteEvent = false;
    private boolean singleMoteEvent = false;
    private JCheckBox allMote;
    private JCheckBox act;
    private JDialog legend;
    private JCheckBox eventLogButton = new JCheckBox("Log Events");
    private JCheckBox statusButton = new JCheckBox("Node Status");
    private JCheckBox logSensingDataButton = new JCheckBox("Log Sensing Data");
    //Xiaogang  add checkbox for email
    private JCheckBox emailButton = new JCheckBox("email enable");
    //Mingsen: add the checkbox for compression enabled
    private JCheckBox compressionButton = new JCheckBox("compression enable");
    private JLabel dataTypeLabel = new JLabel("Sensor type  ");
    private SpinnerListModel typeList;
    private JSpinner spinner;
    private JLabel thresholdValueLabel = new JLabel("Threshold value ");
    private SpinnerListModel valueList;
    private JSpinner valueSpinner;
    //JCheckBox serverButton = new JCheckBox("Run TCPServer");
    //JCheckBox tcpLogButton = new JCheckBox("Log Data");
    private final int ITEM_PLAIN = 0;
    private final int ITEM_CHECK = 1;
    private final int ITEM_RADIO = 2;
    private final int RPC_NO_MOTE = -4;
    private final int RPC_BROADCAST = -3;
    private final int RPC_MANYMOTE = -2;
    private final int RPC_ONE_MOTE = -1;
    //To specify the node which is clicked by user
    public static Integer focusedNode = null;
   

    public MainFrame(MoteIF mif, String XmlPath, XMLMessageParser xmp) {
        setTitle("Sensorweb Monitor and Control");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        //setSize(java.awt.Toolkit.getDefaultToolkit().getScreenSize());
        setLayout(new BorderLayout());
        setSize(800,600);
        //setExtendedState(java.awt.Frame.MAXIMIZED_BOTH);
        //setMaximum(true);
        //pack();
        setVisible(false);
        addWindowListener(this);
	

        try {
            String logOutput = monitor.Util.getDateTime() + " : " + "JAVA: Monitor started";
            MainClass.eventLogger.write(logOutput + "\n");
            MainClass.eventLogger.flush();
            System.out.println(logOutput);
        } catch (Exception ex) {
        }

        mote = mif;
        this.xmp = xmp;
        //System.out.println(mote.toString());
        //Create MainPanel with ToolBar
        MainToolBar.setAlignmentY(0.222222F);
        MainToolBar.setDoubleBuffered(true);
        //MainToolBar.setLayout(new FlowLayout());
        MainToolBar.setLayout(new GridLayout(3,6));
        MainPanel.add(MainToolBar);
        MainPanel.setLayout(new FlowLayout(FlowLayout.LEFT, 0, 0));
        aSymWindow = new SymWindow();
        this.addWindowListener(aSymWindow);
        lSymAction = new SymAction();

        //Andy: Create Menu bar
        menuBar = new JMenuBar();
        menuControlPanel = new JMenu("Control Panel");
        setJMenuBar(menuBar);
        menuControlPanel.setMnemonic('C');
        menuItemLoadXML = CreateMenuItem(menuControlPanel, ITEM_PLAIN,
                "Load XML...", null, 'L', null);
        menuItemLoadXML.setAccelerator(KeyStroke.getKeyStroke("control L"));
        menuItemLoadRpcXML = CreateMenuItem(menuControlPanel, ITEM_PLAIN,
                "Load Rpc XML...", null, 'L', null);
        menuItemLoadRpcXML.setAccelerator(KeyStroke.getKeyStroke("control I"));
        menuItemSendRPC = CreateMenuItem(menuControlPanel, ITEM_PLAIN,
                "RPC Command...", null, 'R', null);
        menuItemSendRPC.setAccelerator(KeyStroke.getKeyStroke("control R"));
        menuItemSendRPC.setEnabled(false);
        menuBar.add(menuControlPanel);

        //Create Main menubar buttons
        fitNetworkNowButton.setFont(defaultFont);
        setLayoutButton.setFont(defaultFont);
        saveLayoutButton.setFont(defaultFont);
        /*
        controlPanel.setFont (defaultFont);
        //7/17/2007
        //rpcPathText.setFont(defaultFont);
        changePathButton.setFont(defaultFont);
         */
        eventLogButton.setFont(defaultFont);
        eventLogButton.setSelected(EVENT_LOG_MODE);

        LAYOUT_MODE = !(MainClass.layoutInfo.isEmpty());
        toggleLayoutButton.setFont(defaultFont);
        toggleLayoutButton.setSelected(LAYOUT_MODE);

        statusButton.setFont(defaultFont);
        statusButton.setSelected(STATUS_MODE);
        logSensingDataButton.setFont(defaultFont);
        logSensingDataButton.setSelected(LOG_SENSING_MODE);

        //Xiaogang: email
        compressionButton.setFont(defaultFont);
        compressionButton.setSelected(COMPRESSION_ENABLE);

        //Mingsen: compression enable button
        emailButton.setFont(defaultFont);
        emailButton.setSelected(EMAIL_ENABLE);

        //serverButton.setFont(defaultFont);
        //serverButton.setSelected(SERVER_MODE);
        //tcpLogButton.setFont(defaultFont);
        //tcpLogButton.setSelected(TCP_LOG_MODE);
        //tcpLogButton.setVisible(false);

        fitNetworkNowButton.setText(manualfit);
        fitNetworkNowButton.addActionListener(lSymAction);
        MainToolBar.add(fitNetworkNowButton);
        setLayoutButton.addActionListener(lSymAction);
        MainToolBar.add(setLayoutButton);
        saveLayoutButton.addActionListener(lSymAction);
        MainToolBar.add(saveLayoutButton);

        //MainToolBar.addSeparator();
        MainToolBar.add(new JSeparator(JSeparator.VERTICAL), BorderLayout.LINE_START);
        //MainToolBar.addSeparator();
	

        //8/11/2008 Andy Add Enter_Key Event for each of the button on the toolbar
        final String setFitNetworkNowButtonMode = "Set Mode";
        fitNetworkNowButton.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"), setFitNetworkNowButtonMode);
        fitNetworkNowButton.getActionMap().put(setFitNetworkNowButtonMode, new AbstractAction() {

            public void actionPerformed(ActionEvent ignored) {
                fitNetworkNowMenuItem_action();
            }
        });


        final String setLoadLayoutButtonMode = "Set Mode";
        setLayoutButton.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"), setLoadLayoutButtonMode);
        setLayoutButton.getActionMap().put(setLoadLayoutButtonMode, new AbstractAction() {

            public void actionPerformed(ActionEvent ignored) {
                setLayoutButton_action(ignored);
            }
        });


        final String setSaveLayoutButtonMode = "Set Mode";
        saveLayoutButton.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"), setSaveLayoutButtonMode);
        saveLayoutButton.getActionMap().put(setSaveLayoutButtonMode, new AbstractAction() {

            public void actionPerformed(ActionEvent ignored) {
                saveLayoutButton_action(ignored);
            }
        });
        //8/11/2008 End

        /*
        MainToolBar.addSeparator();
        controlPanel.addActionListener(lSymAction);
        controlPanel.setToolTipText("View Control Panel");
        controlPanel.setEnabled(false);
        MainToolBar.add(controlPanel);

        //7/17/2007
        //MainToolBar.add(rpcPathText);
        changePathButton.addActionListener(lSymAction);
        MainToolBar.add(changePathButton);
         */

        toggleLayoutButton.addActionListener(lSymAction);
        MainToolBar.add(toggleLayoutButton);
        eventLogButton.addActionListener(lSymAction);
        MainToolBar.add(eventLogButton);
        statusButton.addActionListener(lSymAction);
        MainToolBar.add(statusButton);
        logSensingDataButton.addActionListener(lSymAction);
        MainToolBar.add(logSensingDataButton);
        //Xiaogang: add email checkbox
        emailButton.addActionListener(lSymAction);
        MainToolBar.add(emailButton);
        //Mingsen: add compression checkbox
        compressionButton.addActionListener(lSymAction);
        MainToolBar.add(compressionButton);


        //8/11/2008 Andy Add Enter_Key Event for each of the checkbox on the toolbar

        final String setToggleLayoutButtonMode = "Set Mode";
        toggleLayoutButton.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"), setToggleLayoutButtonMode);
        toggleLayoutButton.getActionMap().put(setToggleLayoutButtonMode, new AbstractAction() {

            public void actionPerformed(ActionEvent ignored) {
                toggleLayoutMenuItem_action(ignored);
                toggleLayoutButton.setSelected(LAYOUT_MODE);
                repaint();
            }
        });



        final String setEventLogButtonMode = "Set Mode";
        eventLogButton.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"), setEventLogButtonMode);
        eventLogButton.getActionMap().put(setEventLogButtonMode, new AbstractAction() {

            public void actionPerformed(ActionEvent ignored) {
                eventLogMenuItem_action(ignored);
                eventLogButton.setSelected(EVENT_LOG_MODE);
                repaint();
            }
        });

        final String setStatusButtonMode = "Set Mode";
        statusButton.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"), setStatusButtonMode);
        statusButton.getActionMap().put(setStatusButtonMode, new AbstractAction() {

            public void actionPerformed(ActionEvent ignored) {
                statusMenuItem_action(ignored);
                statusButton.setSelected(STATUS_MODE);
                repaint();
            }
        });

        final String setLogSensingDataButtonMode = "Set Mode";
        logSensingDataButton.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"), setLogSensingDataButtonMode);
        logSensingDataButton.getActionMap().put(setLogSensingDataButtonMode, new AbstractAction() {

            public void actionPerformed(ActionEvent ignored) {
                logSensingMenuItem_action(ignored);
                logSensingDataButton.setSelected(LOG_SENSING_MODE);
                repaint();
            }
        });

        //8/11/2008 End

        //serverButton.addActionListener(lSymAction);
        //MainToolBar.add(serverButton);
        //tcpLogButton.addActionListener(lSymAction);
        //MainToolBar.add(tcpLogButton);
        String[] dataType = new String[128];
        for (int i = 0; i < 128; i++) {
            dataType[i] = i + "";
        }
        typeList = new SpinnerListModel(dataType);
        spinner = new JSpinner(typeList);
        ((JSpinner.DefaultEditor) spinner.getEditor()).getTextField().setColumns(6);
        dataTypeLabel.setFont(defaultFont);

        String[] valueThreshold = new String[65536];
        for (int i = 0; i < 65536; i++) {
            valueThreshold[i] = i + "";
        }
        valueList = new SpinnerListModel(valueThreshold);
        valueSpinner = new JSpinner(valueList);
        ((JSpinner.DefaultEditor) valueSpinner.getEditor()).getTextField().setColumns(6);
        thresholdValueLabel.setFont(defaultFont);


        MainToolBar.add(new JSeparator(JSeparator.VERTICAL), BorderLayout.LINE_START);
        //MainToolBar.addSeparator();

        MainToolBar.add(dataTypeLabel);
        MainToolBar.add(spinner);
        //MainToolBar.addSeparator();

        MainToolBar.add(thresholdValueLabel);
        MainToolBar.add(valueSpinner);
        spinner.addChangeListener(this);
        valueSpinner.addChangeListener(this);
        
        //MainToolBar.pack();
	//MainToolBar.setVisible(true);
	
	
        //Create MainScrollPane with GraphDisplayPanel
        MainScrollPane.setOpaque(true);
        MainScrollPane.setViewportView(GraphDisplayPanel);
        MainScrollPane.getViewport().add(GraphDisplayPanel);
       // GraphDisplayPanel.setBounds(0, 0, 430, 270);
        //GraphDisplayPanel.setLayout(null);
        
        GraphDisplayPanel.setAutoscrolls(true);
        MainScrollPane.getViewport().add(GraphDisplayPanel);

        //Create Event Panel
        reportPanel = new ReportPanel(mote);
        //reportPanel.setSize(200, 100);
        reportPanel.setVisible(false);

        //Create Topology Panel
        topPanel.add("North", MainPanel);
        topPanel.add("Center", MainScrollPane);
        TopologyPanel = new JSplitPane(JSplitPane.VERTICAL_SPLIT,
                topPanel, reportPanel);
        //TopologyPanel.setResizeWeight(0.9);


        //Add three pages into the MainFrame
        getContentPane().setLayout(new BoxLayout(getContentPane(),
                BoxLayout.LINE_AXIS));
        pane = new JTabbedPane();
        pane.addTab("Sensorweb Topology", TopologyPanel);
       //pane.addTab("Sensorweb Topology", new JPanel());
        pane.setMnemonicAt(0, KeyEvent.VK_1);
        // pane.addTab("Sensorweb Topology", new JPanel());
        pane.addTab("Raw Message", createMessagePanel(mif));
        pane.setMnemonicAt(1, KeyEvent.VK_2);
         //pane.addTab("Sensorweb Topology", new JPanel());
       pane.addTab("Sensor Reading", createOscopePanel(mif));
        pane.setMnemonicAt(2, KeyEvent.VK_3);
        // pane.addTab("Sensorweb Topology", new JPanel());
        pane.addTab("Holistic Evalation", createHEPanel(mif));
        pane.setMnemonicAt(3, KeyEvent.VK_4);
        pane.addChangeListener(this);


        //set custom icon for MainFrame
        setIconImage(new ImageIcon(OasisConstants.IconFile).getImage());

        //7/28/2008 Andy Start
        int v = ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED;
        int h = ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED;
        JScrollPane jsp = new JScrollPane(pane, v, h);

        getContentPane().add(jsp);
        //getContentPane().add(pane);
        //7/28/2008 Andy End

        //rpc initialization
		/*
        if (app != null){
        //rpcApp = app;
        xmlPath = XmlPath;
        //7/17/2007
        //rpcPathText.setText(xmlPath+"\\nescDecls.xml");
        menuItemSendRPC.setEnabled(true);
        }
         */
        menuItemSendRPC.setEnabled(true);
	pack();


    //System.out.println("the end");


    }

    /**
     * Embed Oscope subtool into this tool suite,
     * source code is in ../oscope
     *
     */
    protected JPanel createOscopePanel(MoteIF m) {
        JPanel contentPane = new JPanel(new BorderLayout());
        GraphPanel oscopePanel = new GraphPanel();

        ControlPanel controlPanel = new ControlPanel(oscopePanel);
        if (m != null) {
            ScopeDriver driver = new ScopeDriver(m, oscopePanel);
            controlPanel.setScopeDriver(driver);
            driverControl = driver;
        }
        channelControl = oscopePanel;
        contentPane.add("Center", oscopePanel);
        contentPane.add("South", controlPanel);
        return contentPane;
    }

    /**
     * Embed rawdata subtool into this tool suite,
     * source code is in ../rawdata
     *
     */
    protected JPanel createMessagePanel(MoteIF m) {
        JPanel contentPanel = new JPanel(new BorderLayout());
        MessagePanel msgPanel = new MessagePanel(m);
        if (m != null) {
            MessageDriver driver = new MessageDriver(m, msgPanel,xmp);
        }
        contentPanel.add("Center", msgPanel);
        return contentPanel;
    }
    
     /**
     * Embed Holistic Evalution subtool into this tool suite,
     * source code is in ../HE
     *
     */
    protected JPanel createHEPanel(MoteIF m) {
        JPanel contentPanel = new JPanel(new BorderLayout());
        HEPanel msgPanel = new HEPanel(m);
        if (m != null) {
            HEDriver driver = new HEDriver(m, msgPanel,xmp);
        }
        contentPanel.add("Center", msgPanel);
        return contentPanel;
    }
    
    
    

    /**
     * Notifies this component that it has been added to a container
     * This method should be called by <code>Container.add</code>, and 
     * not by user code directly.
     * Overridden here to adjust the size of the frame if needed.
     * @see java.awt.Container#removeNotify
     */
    //YYYCheck
    public void addNotify() {
        // Record the size of the window prior to calling parents addNotify.
        Dimension size = getSize();
        super.addNotify();

        if (frameSizeAdjusted) {
            return;
        }
        frameSizeAdjusted = true;

        // Adjust size of frame according to the insets and menu bar
        javax.swing.JMenuBar menuBar = getRootPane().getJMenuBar();
        int menuBarHeight = 0;
        if (menuBar != null) {
            menuBarHeight = menuBar.getPreferredSize().height;
        }
        Insets insets = getInsets();
        setSize(insets.left + insets.right + size.width,
                insets.top + insets.bottom + size.height + menuBarHeight);
    }

    // Used by addNotify
    boolean frameSizeAdjusted = false;

    class SymWindow extends java.awt.event.WindowAdapter {

        public void windowClosing(java.awt.event.WindowEvent event) {
            Object object = event.getSource();
            if (object == MainFrame.this) {
                MainFrame_windowClosing(event);
            }
        }
    }

    void MainFrame_windowClosing(java.awt.event.WindowEvent event) {
        MainClass.displayManager.stopDisplayThread();
//		if (rpcApp != null){
//			MainClass.saveInfo(OasisConstants.ConfigPath+"/rpcSeqNo.ini",
//				               Integer.toString(rpcApp.getSeqNo()));
//		}
        System.exit(0);
    }

    public monitor.GraphDisplayPanel GetGraphDisplayPanel() {
        return GraphDisplayPanel;
    }

    public javax.swing.JScrollPane GetMainScrollPane() {
        return MainScrollPane;
    }

    class SymAction implements java.awt.event.ActionListener {

        public void actionPerformed(java.awt.event.ActionEvent event) {
            Object object = event.getSource();

            if (object == fitNetworkNowButton) {
                fitNetworkNowMenuItem_action();
            } else if (object == setLayoutButton) {
                setLayoutButton_action(event);
            } else if (object == saveLayoutButton) {
                saveLayoutButton_action(event);
            } else if (object == toggleLayoutButton) {
                toggleLayoutMenuItem_action(event);
            } else if (object == eventLogButton) {
                eventLogMenuItem_action(event);
            } else if (object == statusButton) {
                statusMenuItem_action(event);
            } else if (object == logSensingDataButton) {
                logSensingMenuItem_action(event);
            } //Xiaogang: email
            else if (object == emailButton) {
                email_action(event);
            } else if (object == compressionButton) {
                compression_action(event);
            } else if (object == menuItemLoadXML) {
                if (OasisConstants.DEBUG) {
                    System.out.println("menuItemLoadXML");
                }
                try {
                    //changePathButton_action(event);
                    changeXmlPaserButton_action(event);
                } catch (FileNotFoundException ex) {
                    Logger.getLogger(MainFrame.class.getName()).log(Level.SEVERE, null, ex);
                } catch (IOException ex) {
                    Logger.getLogger(MainFrame.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else if (object == menuItemLoadRpcXML) {
                if (OasisConstants.DEBUG) {
                    System.out.println("menuItemLoadRpcXML");
                }
                //changePathButtonimote2_action(event);
                changePathButton_action(event);
            } else if (object == menuItemSendRPC) {
                if (OasisConstants.DEBUG) {
                    System.out.println("menuItemSendRPC");
                }
                menuItemSendRPC_action();
            }
        }
    }

    /**
     * Respond to click on FitToScreen Button
     * Adjust Topology showed in GraphDisplayPanel to fit to screen
     *
     */
    void fitNetworkNowMenuItem_action() {
        try {
            if (monitor.MainClass.mainFrame.GetGraphDisplayPanel().GetFitToScreenAutomatically() == true) {
                monitor.MainClass.mainFrame.GetGraphDisplayPanel().SetFitToScreenAutomatically(false);
                fitNetworkNowButton.setText(autofit);
            } else {
                monitor.MainClass.mainFrame.GetGraphDisplayPanel().SetFitToScreenAutomatically(true);
                fitNetworkNowButton.setText(manualfit);
            }

        } catch (java.lang.Exception e) {
        }
    }

    /**
     * Respond to click on loadLayout Button
     * Load user-defined Layout file
     * and adjust Topology showed in GraphDisplayPanel accordingly
     *
     */
    void setLayoutButton_action(java.awt.event.ActionEvent event) {
        //Clear flag
        DIALOG_SELECTED = false;

        //Pop up FileBrowser Dialog and load layout info
        loadFileChooser = getSelectFileChooser(loadFileChooser,
                null,
                ".layout",
                OasisConstants.ToolsPath + "/Config");
        loadFileChooser.setDialogTitle("Browse Layout Files");
        loadFileChooser.showOpenDialog(MainFrame.this);

        //Load layout info into Node Structure
        if (DIALOG_SELECTED) {
            File file = loadFileChooser.getSelectedFile();
            try {
                if (!(file.exists())) {
                    JOptionPane.showMessageDialog(null,
                            "The file does not exist!",
                            "WARNING",
                            JOptionPane.ERROR_MESSAGE);
                } else {
                    //Perform Save Action
                    MainClass.loadLayoutFromFile(file);

                    //Save layout file info
                    MainClass.saveInfo(OasisConstants.ConfigPath + "/layout.ini",
                            loadFileChooser.getCurrentDirectory().getCanonicalPath() + "/" + file.getName());

                }
            } catch (Exception ev) {
                System.err.println(ev.getMessage());
            }

            //Apply layout file to current topology display
            LAYOUT_MODE = true;
            toggleLayoutButton.setSelected(LAYOUT_MODE);
            unfixNodes();  //unfix all nodes first
            fixNodes(); //only fix nodes in layout file
        }
    }

    /**
     * Respond to click on saveLayout Button
     * Save current topology into user selected Layout file
     *
     */
    void saveLayoutButton_action(java.awt.event.ActionEvent event) {
        saveFileChooser = getSaveFileChooser(".layout", OasisConstants.ToolsPath + "\\Config");
        saveFileChooser.setDialogTitle("Choose file position");
        saveFileChooser.showSaveDialog(MainFrame.this);
    }

    /**
     * Respond to change of KeepLayout CheckBox selection
     * Switch between using and not using current Layout file
     *
     */
    void toggleLayoutMenuItem_action(java.awt.event.ActionEvent event) {
        //Check whether there is a layout file to use
        if (!LAYOUT_MODE) {
            if (MainClass.layoutInfo.isEmpty()) {
                JOptionPane.showMessageDialog(null,
                        "No layout file has been loaded right now! \n" + "Please do LoadLayout first. ",
                        "WARNING",
                        JOptionPane.ERROR_MESSAGE);
            } else {
                LAYOUT_MODE = !LAYOUT_MODE;
                unfixNodes();
                fixNodes();
            }
        } else {
            LAYOUT_MODE = !LAYOUT_MODE;
            unfixNodes();
        }
    }

    void fixNodes() {
        MainClass.LayoutInfo info = null;
        for (Enumeration e = MainClass.layoutInfo.elements(); e.hasMoreElements();) {
            info = (MainClass.LayoutInfo) e.nextElement();
            MainClass.locationAnalyzer.SetX(new Integer(info.id), info.x);
            MainClass.locationAnalyzer.SetY(new Integer(info.id), info.y);
            MainClass.locationAnalyzer.SetFixed(new Integer(info.id), true);
        }
    }

    void unfixNodes() {
        //unfix all the nodes
        DisplayManager.NodeInfo nodeDisplayInfo;
        for (Enumeration nodes = MainClass.displayManager.GetNodeInfo();
                nodes.hasMoreElements();) {
            nodeDisplayInfo = (DisplayManager.NodeInfo) nodes.nextElement();
            MainClass.locationAnalyzer.SetFixed(nodeDisplayInfo.GetNodeNumber(), false);
        }
    }

    /**
     * Respond to click on Control Button
     * 1. Make sure the setting of xmlPath for Rpc
     * 2. Pop up ControlPanel Dialog
     *
     */
    void controlPanel_action(java.awt.event.ActionEvent event) {
        //Open Control Panel
//		if (xmlPath != null && rpcApp!= null){
//			Vector moteList = new Vector();
//			moteList.add(new Integer(OasisConstants.ALL_NODES));
//			//cPanel = new ControlPanelDialog(moteList, mote, rpcApp);
//            cPanel = new ControlPanelDialog(this,xmp,mote);
//
//			menuItemSendRPC.setEnabled(false);
//			cPanel.show();
//		}
//		else{
//			System.out.println("Error: XmlPath is null");
//		}
    }

    /**
     * Respond to click on changePath Button
     * 1. Make sure the setting of XmlPath for Rpc
     * 2. Pop up ControlPanel Dialog
     *
     */
    void changePathButtonimote2_action(java.awt.event.ActionEvent event) {
        Vector moteList = new Vector();
        moteList.add(new Integer(OasisConstants.ALL_NODES));
    /*
    DelugePanelDialog dDialog = new DelugePanelDialog(moteList, mote);
    dDialog.show();
     * */
    }

    /**
     * Respond to click on changePath Button
     * 1. Make sure the setting of XmlPath for Rpc
     * 2. Pop up ControlPanel Dialog
     *
     */
    void changePathButton_action(java.awt.event.ActionEvent event) {
        boolean exist = false;
        String rpcxmlpath = "";
        String oldrpcxmlpath = MainClass.rpcxmlpath;
        String defaultPath = null;

        DIALOG_SELECTED = false;
        //set default path
        if (oldrpcxmlpath == null) {
            //defaultPath = OasisConstants.DefaultPath;
            defaultPath = OasisConstants.rpcxmlpath;
        } else {
            defaultPath = oldrpcxmlpath;
        }
         System.out.println("defaultPath: "+defaultPath);
        xmlFileChooser = getSelectFileChooser(xmlFileChooser,
                "nescDecls.xml",
                null,
                defaultPath);
        xmlFileChooser.setDialogTitle("Browse Xml Files");
        xmlFileChooser.showOpenDialog(MainFrame.this);

        if (DIALOG_SELECTED) {
            String fileStr = xmlFileChooser.getSelectedFile().getName();
            File file = xmlFileChooser.getSelectedFile();
            try {
                rpcxmlpath = xmlFileChooser.getCurrentDirectory().getCanonicalPath();
            } catch (Exception ev) {
                System.err.println(ev.getMessage());
            }
                System.out.println(rpcxmlpath+" "+fileStr);
            if (rpcxmlpath != null && (oldrpcxmlpath == null || rpcxmlpath.equalsIgnoreCase(oldrpcxmlpath))) {
                exist = (fileStr.equals("nescDecls.xml") && (new File(rpcxmlpath + "/rpcSchema.xml")).exists());
                if (exist) {
                    	MainClass.rpcApp = null;
                        MainClass.rpcxmlpath = rpcxmlpath;
			MainClass.rpcApp = new debug.rpc.NescApp(rpcxmlpath, MainClass.dmote);
			MainClass.casCtrllor = new rpcCascadeMsgDriver(MainClass.rpcApp);
			MainClass.rpcApp.comm.receiveComm.registerListener(CasCtrlMsg.AM_TYPE, MainClass.casCtrllor);

			//7/17/2007
			//rpcPathText.setText(xmlPath+"\\"+fileStr);			
			//menuItemSendRPC.setEnabled(true);
			MainClass.saveInfo(OasisConstants.ConfigPath+"/rpcxmlpath.ini",MainClass.rpcxmlpath);
			//8/2/2007 Collect info for rpc seqNo
			String lastSeqNo = MainClass.getInfo(OasisConstants.ConfigPath+"/rpcSeqNo.ini");
			if (lastSeqNo != null){
				MainClass.rpcApp.setSeqNo(Integer.parseInt(lastSeqNo));
			}
					
                } else {
                    javax.swing.JOptionPane.showMessageDialog(
                            null,
                            "The selected file is not nescDecls.xml or there is no rpcSchema.xml \n" + "in the directory you just selected.",
                            "Warning",
                            JOptionPane.ERROR_MESSAGE);
                }
            }
        }
    }

             void changeXmlPaserButton_action(java.awt.event.ActionEvent event) throws FileNotFoundException, IOException {
        boolean exist = false;
        String oldXmlPath = xmpPath;
        String defaultPath = null;

        DIALOG_SELECTED = false;
        //set default path
        if (oldXmlPath == null) {
            //defaultPath = OasisConstants.DefaultPath;
            defaultPath = OasisConstants.DATASTREAM_XML_DIR;
        } else {
            defaultPath = oldXmlPath;
        }
        xmlFileChooser = getSelectFileChooser(xmlFileChooser,
                "dxmstream_data.xml",
                null,
                defaultPath);
        xmlFileChooser.setDialogTitle("Browse Xml Files");
        xmlFileChooser.showOpenDialog(MainFrame.this);

        if (DIALOG_SELECTED) {
            String fileStr = xmlFileChooser.getSelectedFile().getName();
            File file = xmlFileChooser.getSelectedFile();
            try {
                xmpPath = xmlFileChooser.getCurrentDirectory().getCanonicalPath();
            } catch (Exception ev) {
                System.err.println(ev.getMessage());
            }
            if (xmpPath != null && (oldXmlPath == null || xmpPath.equalsIgnoreCase(oldXmlPath))) {
                exist = (fileStr.equals("dxmstream_data.xml") && (new File(xmpPath + "/dxmstream_data.xml")).exists());
                if (exist) {
                    menuItemSendRPC.setEnabled(true);
                    boolean big = new GetEnv().getEnv("BIG").equalsIgnoreCase("big");
		    OasisConstants.BIG = big;
                    this.xmp = new XMLMessageParser(xmpPath+"/dxmstream_data.xml",big);
                    MainClass.saveInfo(OasisConstants.ConfigPath + "/xmlPath.ini",
                            xmpPath);
                    //String lastSeqNo = MainClass.getInfo(OasisConstants.ConfigPath + "/rpcSeqNo.ini");
                    //System.out.println(lastSeqNo + "lastSeqNo");
               
                } else {
                    javax.swing.JOptionPane.showMessageDialog(
                            null,
                            "The selected file is not nescDecls.xml or there is no rpcSchema.xml \n" + "in the directory you just selected.",
                            "Warning",
                            JOptionPane.ERROR_MESSAGE);
                }
            }
        }
    }

    /**
     * Respond to change of Report CheckBox selection
     * Turn on/off the Displaying of Report Panel
     * in the lower part of Topology Screen
     *
     */
    void eventLogMenuItem_action(java.awt.event.ActionEvent event) {
        EVENT_LOG_MODE = !EVENT_LOG_MODE;
        reportPanel.setVisible(EVENT_LOG_MODE);
        TopologyPanel.setDividerLocation(0.80);
        if (monitor.MainClass.mainFrame.GetGraphDisplayPanel().GetFitToScreenAutomatically() == false) {
            fitNetworkNowMenuItem_action();
        }
    }

    /**
     * Respond to change of "Node Status" CheckBox selection
     * Turn on/off the Displaying of status items besides each node
     *
     */
    void statusMenuItem_action(java.awt.event.ActionEvent event) {
        SensorAnalyzer.NodeInfo nodeInfo;
        if (STATUS_MODE) {
            STATUS_MODE = false;
            for (Enumeration nodes = SensorAnalyzer.proprietaryNodeInfo.elements();
                    nodes.hasMoreElements();) {
                nodeInfo = (SensorAnalyzer.NodeInfo) nodes.nextElement();
                nodeInfo.STATUS_MODE = false;
            }

        } else {
            STATUS_MODE = true;
            for (Enumeration nodes = SensorAnalyzer.proprietaryNodeInfo.elements();
                    nodes.hasMoreElements();) {
                nodeInfo = (SensorAnalyzer.NodeInfo) nodes.nextElement();
                nodeInfo.STATUS_MODE = true;
            }
        }
    }

    /**
     * Response to log Sensing Data checkbox
     * Turn on/off the Log Mode
     *
     */
    void logSensingMenuItem_action(java.awt.event.ActionEvent event) {
        //System.out.println(LOG_SENSING_MODE);
        LOG_SENSING_MODE = !LOG_SENSING_MODE;
    //Create ADO Connection
		/*
    if (LOG_SENSING_MODE)
    ADOConnection.createConnection();
    else
    ADOConnection.closeConnection();
     */
    }

    /**Xiaogang:
     * Response to email checkbox
     * Turn on/off the Log Mode
     *
     */
    void email_action(java.awt.event.ActionEvent event) {

        EMAIL_ENABLE = !EMAIL_ENABLE;
        if (EMAIL_ENABLE == true) {
            System.out.println("EMAIL_ENABLE");
        } else {
            System.out.println("EMAIL_DISABLE");
        }
    }

    /**Mingsen:
     * Response to compression checkbox
     *
     *
     */
    void compression_action(java.awt.event.ActionEvent event) {

        COMPRESSION_ENABLE = !COMPRESSION_ENABLE;

        System.out.println("COMPRESSION " + COMPRESSION_ENABLE + "\n");
    }

    /**
     * Respond to change of RunTCPServer CheckBox selection
     * Turn on/off reliable transport service
     * En/dis/able log service
     * source code is in ../TCPServer
     *
     * YFH note: commented now,
     *           and needs new version with Standard OasisType Interface
     */
    /*
    void serverMenuItem_action(java.awt.event.ActionEvent event){
    SERVER_MODE = !SERVER_MODE;
    tcpLogButton.setVisible(SERVER_MODE);
    }*/
    /**
     * Respond to change of Log CheckBox selection
     * Turn on/off log service for received data msg
     * source code is in ../TCPServer
     *
     * YFH note: commented now,
     *            and needs new version with Standard OasisType Interface
     */
    /*
    void tcpLogMenuItem_action(java.awt.event.ActionEvent event){
    TCP_LOG_MODE = !TCP_LOG_MODE;
    }*/
    /**
     * A Function to create a SelectFile Dialog
     * @param  name  file filter
     * @param  type  choosable file filter
     * @param  defaultPath  default path when open the dialog
     *
     * Note: related to FileChooser defined outside this function
     *       only do the creation when that FileChooser does not exist
     *
     */
    private JFileChooser getSelectFileChooser(JFileChooser fileChooser,
            String name,
            String type,
            String defaultPath) {
        final String fileName = name;
        final String fileType = type;
        JFileChooser FileChooser = fileChooser;

        if (FileChooser == null) {
            FileChooser = new JFileChooser();
            FileChooser.setFont(new java.awt.Font("Dialog",
                    java.awt.Font.PLAIN, 10));
            FileChooser.setApproveButtonText("Select");
            if (fileName != null) {
                javax.swing.filechooser.FileFilter fileFilter = new javax.swing.filechooser.FileFilter() {

                    public boolean accept(File infile) {
                        if (infile.getAbsolutePath().endsWith(fileName)) {
                            return true;
                        }
                        return infile.isDirectory();
                    }

                    public String getDescription() {
                        return fileName + " File";
                    }
                };
                FileChooser.setFileFilter(fileFilter);



            }

            if (fileType != null) {
                FileFilter fileFilter1 = new FileFilter() {

                    public boolean accept(File infile) {
                        if (infile.getAbsolutePath().endsWith(fileType)) {
                            return true;
                        }
                        return infile.isDirectory();
                    }

                    public String getDescription() {
                        return fileType + " files";
                    }
                };
                FileChooser.addChoosableFileFilter((javax.swing.filechooser.FileFilter) fileFilter1);
            }

            FileChooser.setCurrentDirectory(new File(defaultPath));
            FileChooser.addActionListener(new java.awt.event.ActionListener() {

                public void actionPerformed(java.awt.event.ActionEvent e) {
                    if (e.getActionCommand().equals("ApproveSelection")) {
                        DIALOG_SELECTED = true;
                    } else {
                        if (e.getActionCommand().equals("CancelSelection")) {
                            //Do nothing
                            DIALOG_SELECTED = false;
                            return;
                        }
                    }
                }
            });
        }
        // position of the component
        FileChooser.setLocation(this.getWidth() / 2 - FileChooser.getWidth() / 2, this.getHeight() / 2 - FileChooser.getHeight() / 2);
        return FileChooser;
    }

    /**
     * A Function to create a SaveFile Dialog
     * @param  type  choosable file filter
     * @param  defaultPath  default path when open the dialog
     *
     * Note: related to FileChooser defined outside this function
     *       only do the creation when that FileChooser does not exist
     *
     */
    private JFileChooser getSaveFileChooser(String type,
            String defaultPath) {
        final String fileType = type;
        if (saveFileChooser == null) {
            saveFileChooser = new JFileChooser();
            saveFileChooser.setFont(new java.awt.Font("Dialog",
                    java.awt.Font.PLAIN, 10));
            saveFileChooser.setApproveButtonText("Save");

            FileFilter fileFilter = new FileFilter() {

                public boolean accept(File infile) {
                    if (infile.getAbsolutePath().endsWith(fileType)) {
                        return true;
                    }
                    return infile.isDirectory();
                }

                public String getDescription() {
                    return fileType + " files";
                }
            };
            saveFileChooser.addChoosableFileFilter((javax.swing.filechooser.FileFilter) fileFilter);

            saveFileChooser.setCurrentDirectory(new File(defaultPath));
            saveFileChooser.addActionListener(new java.awt.event.ActionListener() {

                public void actionPerformed(java.awt.event.ActionEvent e) {
                    if (e.getActionCommand().equals("ApproveSelection")) {
                        File file = saveFileChooser.getSelectedFile();
                        try {
                            //Check extention of file name
                            File nFile = null;
                            String newName = null;
                            if (getExtension(file) != "layout") {
                                String fname = file.getName();
                                int i = fname.lastIndexOf('.');
                                if (i == -1) { // no extension name
                                    newName = fname.concat(".layout");
                                } else {
                                    newName = (fname.substring(0, i)).concat(".layout");
                                }
                                nFile = new File(saveFileChooser.getCurrentDirectory().getCanonicalPath() + "\\" + newName);
                            } else {
                                nFile = file;
                            }
                            //System.out.println("file name = "+ nFile.getName());
                            if (nFile.exists()) {
                                int r = JOptionPane.showConfirmDialog(null,
                                        "The file already exists, overwrite?", "WARNING",
                                        JOptionPane.YES_NO_OPTION);
                                if (r == JOptionPane.NO_OPTION) {
                                    return;
                                }
                            }

                            //Perform Save Action
                            saveLayoutToFile(nFile);

                            //Save layout file info
                            MainClass.saveInfo(OasisConstants.ConfigPath + "/layout.ini",
                                    saveFileChooser.getCurrentDirectory().getCanonicalPath() + "\\" + newName);
                        } catch (Exception ev) {
                            System.err.println(ev.getMessage());
                        }
                    }
                }
            });
        }
        // position of the component
        saveFileChooser.setLocation(this.getWidth() / 2 - saveFileChooser.getWidth() / 2, this.getHeight() / 2 - saveFileChooser.getHeight() / 2);
        return saveFileChooser;
    }


    /*
     * Get the extension of a file.
     */
    public static String getExtension(File f) {
        String ext = null;
        String s = f.getName();
        int i = s.lastIndexOf('.');

        if (i > 0 && i < s.length() - 1) {
            ext = s.substring(i + 1).toLowerCase();
        }
        return ext;
    }

    public void saveLayoutToFile(File selectedFile) {
        DisplayManager.NodeInfo nodeDisplayInfo;
        int id;
        double x, y;

        try {
            FileWriter output = new FileWriter(selectedFile);

            //Go through all existed nodes
            for (Enumeration nodes = MainClass.displayManager.GetNodeInfo();
                    nodes.hasMoreElements();) {
                nodeDisplayInfo = (DisplayManager.NodeInfo) nodes.nextElement();
                id = nodeDisplayInfo.GetNodeNumber().intValue();
                x = MainClass.locationAnalyzer.GetX(nodeDisplayInfo.GetNodeNumber());
                y = MainClass.locationAnalyzer.GetY(nodeDisplayInfo.GetNodeNumber());
                output.write(id + "," + x + "," + y + "\n");
                output.flush();
            }
            output.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        selectedFile = null;
    }

    //Andy: Event for autofit
    public void stateChanged(ChangeEvent e) {

        Object src = e.getSource();
        if (src instanceof DefaultSingleSelectionModel) {
            DefaultSingleSelectionModel dSM = (DefaultSingleSelectionModel) src;
            if (dSM.getSelectedIndex() == TAB_SENSORREADING) {
                ScopeDriver.firstMessage = true;
            }
        } else if (src == allMote) {
            allMoteEvent = true;
            if (!singleMoteEvent) {
                Enumeration k = legendActive.keys();
                while (k.hasMoreElements()) {
                    JCheckBox key = (JCheckBox) k.nextElement();
                    key.setSelected(allMote.isSelected());
                }
                rpcMoteSelected = -3;
            }
            allMoteEvent = false;
        } else if (src == pane) {
            int index = pane.getSelectedIndex();
            if (index == TAB_SENSORREADING) {
                forceResetPanel = true;
                firstSwitch = true;
            }
        } else if (src == spinner) {
            try {
                ControlPanel.TYPE = Integer.parseInt(spinner.getValue().toString());
            } catch (java.lang.NumberFormatException ex) {
                javax.swing.JOptionPane.showMessageDialog(
                        null,
                        "Please make sure that your input is a number",
                        "Warning",
                        JOptionPane.ERROR_MESSAGE);
            }
        } else if (src == valueSpinner) {
            try {
                ControlPanel.THRESHOLD = Integer.parseInt(valueSpinner.getValue().toString());
            } catch (java.lang.NumberFormatException ex) {
            }
        } else {
            Object c = legendActive.get(src);
            if ((c != null) &&
                    (c instanceof Channel)) {
                if (!allMoteEvent) {
                    singleMoteEvent = true;
                    rpcMoteSelectedCalculation();
                    singleMoteEvent = false;
                }
            }

        }
    }

    public void rpcMoteSelectedCalculation() {
        boolean allmoteSelected = true;
        Enumeration checkBoxList = legendActive.keys();
        while (checkBoxList.hasMoreElements()) {
            JCheckBox key = (JCheckBox) checkBoxList.nextElement();
            if (!key.isSelected()) {
                allmoteSelected = false;
                break;
            }
        }

        if (allmoteSelected) {
            allMote.setSelected(true);
            rpcMoteSelected = -3;
        } else {
            allMote.setSelected(false);
            rpcMoteSelected = -2;
        }
    }

    public void actionPerformed(ActionEvent e) {
        boolean checkAnyMoteSelected = false;
        Enumeration checkBoxList = legendActive.keys();
        while (checkBoxList.hasMoreElements()) {
            JCheckBox key = (JCheckBox) checkBoxList.nextElement();
            if (key.isSelected()) {
                checkAnyMoteSelected = true;
                break;
            }
        }
        if (!checkAnyMoteSelected) {
            JOptionPane.showMessageDialog(null, "Please select at least one mote", "Error", JOptionPane.WARNING_MESSAGE);
            return;
        }

        legend.dispose();

        //Object src = e.getSource();
        if (OasisConstants.DEBUG == true) {
            System.err.println(" rpc sending");
        }
        //  nj = new NewJPanel(this);
        //nn = new NewJFrame();
        //nn.setVisible(true);
        /*legend = new EscapeDialog(this);
        legend.setTitle("Mote list");
        legend.setModal(true);
        legend.setSize(new Dimension(200,500));
        slp = new JPanel();
        createChannelList(slp);
        legend.getContentPane().add(new JScrollPane(slp));
        legend.setDefaultCloseOperation(javax.swing.JFrame.DISPOSE_ON_CLOSE);
        legend.setResizable(false);
        legend.setLocationRelativeTo(null);
        legend.pack();
        legend.setVisible(true);
        legend.repaint();
         * */
        ControlPanelDialog CDialog = new ControlPanelDialog(xmp, mote);
        CDialog.setSize(new Dimension(300, 600));

        CDialog.setVisible(true);
        CDialog.setDefaultCloseOperation(javax.swing.JFrame.DISPOSE_ON_CLOSE);
        CDialog.setResizable(false);
        CDialog.setLocationRelativeTo(null);
        CDialog.pack();
        CDialog.repaint();
    //CDialog.show();
		/*
    if (xmlPath != null && rpcApp!= null){
    if (rpcMoteSelected == -4)
    return;
    else if (rpcMoteSelected == -3){
    Vector moteList = new Vector();
    moteList.add(new Integer(OasisConstants.ALL_NODES));
    //ControlPanelDialog CDialog = new ControlPanelDialog(moteList, mote, rpcApp);
    ControlPanelDialog CDialog = new ControlPanelDialog(this,xmp,mote);
    menuItemSendRPC.setEnabled(false);
    rpcMoteSelected = -4;
    CDialog.show();
    }
    else if (rpcMoteSelected == -2 || rpcMoteSelected == -1){
    Vector moteList = new Vector();
    Enumeration k = legendActive.keys();
    while (k.hasMoreElements()) {
    JCheckBox key = (JCheckBox) k.nextElement();
    Channel c = (Channel)legendActive.get(key);
    if ( key.isSelected())
    moteList.add(new Integer(Integer.parseInt(c.getDataLegend().substring(5,c.getDataLegend().length()))));
    }

    ControlPanelDialog CDialog = new ControlPanelDialog(this,xmp,mote);
    menuItemSendRPC.setEnabled(false);
    rpcMoteSelected = -4;
    CDialog.show();

    }
    }*/
    }

    public JMenuItem CreateMenuItem(JMenu menu, int iType, String sText,
            ImageIcon image, int acceleratorKey,
            String sToolTip) {
        // Create the item
        JMenuItem menuItem;

        switch (iType) {
            case ITEM_RADIO:
                menuItem = new JRadioButtonMenuItem();
                break;

            case ITEM_CHECK:
                menuItem = new JCheckBoxMenuItem();
                break;

            default:
                menuItem = new JMenuItem();
                break;
        }

        // Add the item test
        menuItem.setText(sText);

        // Add the optional icon
        if (image != null) {
            menuItem.setIcon(image);
        }

        // Add the accelerator key
        if (acceleratorKey > 0) {
            menuItem.setMnemonic(acceleratorKey);
        }

        // Add the optional tool tip text
        if (sToolTip != null) {
            menuItem.setToolTipText(sToolTip);
        }

        // Add an action handler to this menu item
        //menuItem.addActionListener( this );
        menuItem.addActionListener(lSymAction);

        menu.add(menuItem);

        return menuItem;
    }

    protected void createChannelList(JPanel p) {


        JTextField leg;
        GridBagLayout g = new GridBagLayout();
        JButton startRpcPanel = new JButton("Start RPC");
        JButton startXMLRpcPanel = new JButton("Start RPC XML");
        GridBagConstraints constraints = new GridBagConstraints();
        JButton inputMoteIDManually = new JButton("                    Click here to add mote manually                   ");

        p.setLayout(g);

        if (channelControl == null) {
            return;
        }
        Vector channels = channelControl.getChannels();
        legendActive.clear();
        legendEdit.clear();

        leg = new JTextField(30);
        leg.setText("All mote");
        leg.setEditable(false);
        allMote = new JCheckBox(" ");
        allMote.setSelected(false);
        constraints.gridwidth = GridBagConstraints.RELATIVE;
        g.setConstraints(allMote, constraints);
        constraints.gridwidth = GridBagConstraints.REMAINDER;
        g.setConstraints(leg, constraints);
        allMote.addChangeListener(this);
        p.add(allMote);
        p.add(leg);

        final String setAllMoteSelectedStatus = "All mote selected";
        allMote.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"), setAllMoteSelectedStatus);
        allMote.getActionMap().put(setAllMoteSelectedStatus, new AbstractAction() {

            public void actionPerformed(ActionEvent ignored) {
                allMoteEvent = true;
                if (!singleMoteEvent) {
                    Enumeration k = legendActive.keys();
                    while (k.hasMoreElements()) {
                        JCheckBox key = (JCheckBox) k.nextElement();
                        key.setSelected(allMote.isSelected());
                    }
                    rpcMoteSelected = -3;
                }
                allMoteEvent = false;
                allMote.setSelected(!allMote.isSelected());
            }
        });



        for (int i = 0; i < channels.size(); i++) {
            Channel c = (Channel) channels.elementAt(i);
            leg = new JTextField(30);
            leg.setText(c.getDataLegend());
            leg.setEditable(false);
            legendEdit.put(leg, c);
            act = new JCheckBox(" ");
            act.setSelected(false);
            legendActive.put(act, c);
            act.addChangeListener(this);
            constraints.gridwidth = GridBagConstraints.RELATIVE;
            g.setConstraints(act, constraints);
            p.add(act);
            constraints.gridwidth = GridBagConstraints.REMAINDER;
            g.setConstraints(leg, constraints);
            p.add(leg);

            final String setMoteSelectedStatus = "Mote selected";
            act.getInputMap(JComponent.WHEN_FOCUSED).put(KeyStroke.getKeyStroke("ENTER"), setMoteSelectedStatus);
            act.getActionMap().put(setMoteSelectedStatus, new AbstractAction() {

                public void actionPerformed(ActionEvent ignored) {
                    setSingleMoteSelected(act);
                }
            });
        }

        constraints.gridwidth = GridBagConstraints.RELATIVE;
        g.setConstraints(startRpcPanel, constraints);
        p.add(startRpcPanel);
        constraints.gridwidth = GridBagConstraints.REMAINDER;
        g.setConstraints(inputMoteIDManually, constraints);
        p.add(inputMoteIDManually);

        startRpcPanel.addActionListener(this);

        g.setConstraints(startXMLRpcPanel, constraints);
        p.add(startXMLRpcPanel);
        constraints.gridwidth = GridBagConstraints.REMAINDER;
        g.setConstraints(inputMoteIDManually, constraints);
        p.add(inputMoteIDManually);

        startXMLRpcPanel.addActionListener(new java.awt.event.ActionListener() {

         public void actionPerformed(ActionEvent e) {
		boolean checkAnyMoteSelected = false;
		Enumeration checkBoxList = legendActive.keys();
				while (checkBoxList.hasMoreElements()) {
					JCheckBox key = (JCheckBox) checkBoxList.nextElement();
					if (key.isSelected()){
						checkAnyMoteSelected = true;
						break;
					}
		}
		if (!checkAnyMoteSelected){
			JOptionPane.showMessageDialog(null,"Please select at least one mote","Error",JOptionPane.WARNING_MESSAGE);
			return;
		}
		legend.dispose();
		System.out.println("xml rpc start"+MainClass.rpcxmlpath+" "+MainClass.rpcApp);
		if (MainClass.rpcxmlpath != null && MainClass.rpcApp!= null){
			
			if (rpcMoteSelected == -4)
				return;
			else if (rpcMoteSelected == -3){
				Vector moteList = new Vector();
				moteList.add(new Integer(OasisConstants.ALL_NODES));
				TControlPanelDialog TCDialog = new TControlPanelDialog(moteList, MainClass.dmote,  MainClass.rpcApp);
				menuItemSendRPC.setEnabled(false);
				rpcMoteSelected = -4;
				TCDialog.show();
			}
			else if (rpcMoteSelected == -2 || rpcMoteSelected == -1){
				 Vector moteList = new Vector();
				 Enumeration k = legendActive.keys();
					 while (k.hasMoreElements()) {
					 	JCheckBox key = (JCheckBox) k.nextElement();
						Channel c = (Channel)legendActive.get(key);
						if ( key.isSelected())
							moteList.add(new Integer(Integer.parseInt(c.getDataLegend().substring(5,c.getDataLegend().length()))));
					 }
				TControlPanelDialog TCDialog = new TControlPanelDialog(moteList, MainClass.dmote,  MainClass.rpcApp );
				menuItemSendRPC.setEnabled(false);
				rpcMoteSelected = -4;
				TCDialog.show();
				
			}
		}
        }
	});



        inputMoteIDManually.addActionListener(new java.awt.event.ActionListener() {

            public synchronized void actionPerformed(ActionEvent e) {
                if (OasisConstants.DEBUG == true) {
                    System.err.println("click sendrpc");
                }
                String moteID = (String) JOptionPane.showInputDialog(null, "Please enter the mote number \n", "Add MoteID Manually", JOptionPane.PLAIN_MESSAGE);
                int moteNo = -1;
                if (moteID == null) {
                    JOptionPane.showMessageDialog(null, "Invalid Input", "Warning Message", JOptionPane.WARNING_MESSAGE);
                    return;
                }
                if ((moteID != null) && (moteID.length() > 0)) {

                    try {
                        moteNo = Integer.parseInt(moteID);
                    } catch (NumberFormatException ex1) {
                        JOptionPane.showMessageDialog(null, "Invalid Input", "Warning Message", JOptionPane.WARNING_MESSAGE);
                        return;
                    }
                }



                if (moteNo >= 0) {
                    legend.dispose();
                    driverControl.findChannel(moteNo);
                    legend = new EscapeDialog(MainFrame.this);
                    legend.setTitle("Mote list");
                    legend.setModal(true);
                    legend.setSize(new Dimension(200, 500));
                    slp = new JPanel();
                    createChannelList(slp);
                    legend.getContentPane().add(new JScrollPane(slp));
                    legend.setDefaultCloseOperation(javax.swing.JFrame.DISPOSE_ON_CLOSE);
                    legend.setResizable(false);
                    legend.setLocationRelativeTo(null);
                    legend.pack();
                    legend.setVisible(true);
                    legend.repaint();
                }

            }
        });
    }

    public void setSingleMoteSelected(JCheckBox act) {
        Object c = legendActive.get(act);
        if ((c != null) &&
                (c instanceof Channel)) {
            if (!allMoteEvent) {
                singleMoteEvent = true;
                rpcMoteSelectedCalculation();
                singleMoteEvent = false;
            }
        }
    }

    public void menuItemSendRPC_action() {
        legend = new EscapeDialog(this);
        legend.setTitle("Mote list");
        legend.setModal(true);
        legend.setSize(new Dimension(200, 500));
        slp = new JPanel();
        createChannelList(slp);
        legend.getContentPane().add(new JScrollPane(slp));
        legend.setDefaultCloseOperation(javax.swing.JFrame.DISPOSE_ON_CLOSE);
        legend.setResizable(false);
        legend.setLocationRelativeTo(null);
        legend.pack();
        legend.setVisible(true);
        legend.repaint();

    }

    public class EscapeDialog extends JDialog {

        public EscapeDialog(Frame owner) {
            this(owner, false);
        }

        public EscapeDialog(Frame owner, boolean modal) {
            this(owner, null, modal);
        }

        public EscapeDialog(Frame owner, String title, boolean modal) {
            super(owner, title, modal);
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

    //Window Event
    public void windowDeactivated(WindowEvent e) {
    }

    public void windowActivated(WindowEvent e) {
    }

    public void windowDeiconified(WindowEvent e) {
    }

    public void windowIconified(WindowEvent e) {
    }

    public void windowClosed(WindowEvent e) {
    }

    public void windowOpened(WindowEvent e) {
    }

    public void windowClosing(WindowEvent e) {
        try {
            String logOutput = monitor.Util.getDateTime() + " : " + "JAVA: Monitor closed";
            MainClass.eventLogger.write(logOutput + "\n");
            MainClass.eventLogger.write("\n");
            MainClass.eventLogger.write("\n");
            MainClass.eventLogger.flush();
            System.out.println(logOutput);
        } catch (Exception ex) {
        }

    }
}
