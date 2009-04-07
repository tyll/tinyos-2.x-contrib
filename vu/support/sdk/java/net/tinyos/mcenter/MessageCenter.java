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


import javax.swing.plaf.metal.*;
import javax.swing.text.*;
import javax.swing.*;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter;

import java.awt.Point;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;

/**
 *	The Main application of the MessageCenter Framework. It provides a background for all
 * the applications. It provides means to save and load workspace configurations. It can run
 * the DataBaseConfigDialog, whch is capable to save and load configuration of the applictions.     
 * @author  Andras Nadas
 */
public class MessageCenter extends javax.swing.JFrame {
    
	static final long serialVersionUID = 0;
    static private java.util.Hashtable childWindowList = new java.util.Hashtable();
    
    static private MessageCenter _instance = null;
    
    private ArrayList latestWorkspaces= new ArrayList();
    
    private FrameMenuItem serialConnectorMenuItem;
    private MessageCenterInternalFrame appLoader;
    
    private boolean visualizerLoaded = false;
    private Object visualizerInstance = null;
    
    private boolean logPanelMin = true;
    
    private DefaultStyledDocument logDocument = new DefaultStyledDocument();
    private javax.swing.JScrollBar vScrollBar = null;
    
    private CommentFocusListener commentFocusListener = new CommentFocusListener();
    
    private java.util.prefs.Preferences prefs = java.util.prefs.Preferences.userNodeForPackage(this.getClass());
    private java.util.prefs.Preferences commentStorage ;
    
    /** Creates new form centerFrame */
    private MessageCenter(String[] args) {
        _instance = this;
        
        initComponents();
        vScrollBar = logScrollPane.getVerticalScrollBar();
        
        //UIManager.addPropertyChangeListener(new UISwitchListener((JComponent)getRootPane())); 
        
        redirectStreams();
        
        initVisualizer();
        //initLookAndFeels();
        desktopPane.add(SerialConnector.instance());
        SerialConnector.instance().setVisible(true);
        serialConnectorMenuItem = new MessageCenter.FrameMenuItem(SerialConnector.instance());
        windowMenu.add(serialConnectorMenuItem);
        childWindowList.put(SerialConnector.instance(),serialConnectorMenuItem);
        
        appLoader = new AppLoader(args);
        Point scLoc = SerialConnector.instance().getLocation(null);
        scLoc.x += SerialConnector.instance().getSize().width;  //put apploader right next to Serial Connector
        //scLoc.y += SerialConnector.instance().getSize().height;
        appLoader.setLocation(scLoc);
        loadLatestWorspaceNames();
    }
    
    private void initLookAndFeels(){
    	 
    	JMenu lafMenu = new LAFMenu("Look And Feels",MessageCenterThemes.generateThemeArray());
    	
    	
    	centerMenuBar.add(lafMenu,centerMenuBar.getMenuCount()-1);
    	
    }
    
    /**
     * Initializes the Visualiser Plugin. If the plugin doesn't exist the
     * message center will run norlmally.
     * (Experimental)
     */
    private void initVisualizer(){
        //Determine if Visualizer plugin exists
        Class visualizer;
        
        Method getVisualizerMenu;
        JMenu visualizerMenu;
        try{visualizer = Class.forName("net.tinyos.mcenter.vslr.Visualizer");
            visualizerInstance = visualizer.newInstance();
            getVisualizerMenu = visualizer.getMethod("getMenu", null);    
            visualizerMenu = (JMenu)getVisualizerMenu.invoke(visualizerInstance,null);
            if(visualizerMenu == null){
                System.err.println("Visualizer not available!" );
                return; // some probelem with Visualizer
            }
            
            //System.out.println("Visualizer has been Succefully loaded!" );
        }catch(LinkageError le){
            System.err.println("Visualizer not available!" );
            //System.err.println("Could not Link module: " + le.toString());
            return;
        }catch(ClassNotFoundException cnfe){
            System.err.println("Visualizer not available!" );
            //System.err.println("Could not Found module: " + cnfe.toString());
            return;
        }catch(IllegalAccessException iae){
            System.err.println("Visualizer not available!" );
            //System.err.println("Illegal Access in module: " + iae.toString());
            return;
        }catch(InstantiationException ie){
            System.err.println("Visualizer not available!" );
            //System.err.println("Could not Instatiate module: " + ie.toString());
            return;
        }catch(SecurityException se){
            System.err.println("Visualizer not available!" );
            //System.err.println("Security error in module: " + se.toString());
            return;
        }catch(NoSuchMethodException nsme){
            System.err.println("Visualizer not available!" );
            System.err.println("No such method: " + nsme.toString());
            return;

        }catch(IllegalArgumentException iae){
            System.err.println("Visualizer not available!" );
            System.err.println("Illegal Argument: " + iae.toString());
            return;
        }catch(java.lang.reflect.InvocationTargetException ite){
            System.err.println("Visualizer not available!" );
            System.err.println("Invocation Target Exception: " + ite.toString());
            return;
        }
        visualizerLoaded = true;
        
        //Format the menu to display Visualizer Options
        centerMenuBar.add(visualizerMenu,2);
        

    }
    
    private void redirectStreams(){
        Style def = StyleContext.getDefaultStyleContext().getStyle(StyleContext.DEFAULT_STYLE);
        Style err = logDocument.addStyle("Error", def);
        StyleConstants.setFontFamily(err, "SansSerif");
        StyleConstants.setItalic(err, true);
        StyleConstants.setForeground(err, java.awt.Color.RED);
        
        System.setErr(new java.io.PrintStream(new DocumentLogger(err)));
        System.setOut(new java.io.PrintStream(new DocumentLogger(def)));
    }
    
    private void loadLatestWorspaceNames(){
    	for(int i = 0; i < 4;i++){
    	
    		String value = prefs.get("LastWorkspace"+i,"");
    		if(value == ""){
    			return;
    		}else{
    			WorkspaceMenuItem item = new WorkspaceMenuItem(new File(value));
    			latestWorkspaces.add(item);
    			fileMenu.add(item,i+5);
    		}
    	}
    }
    
    private void updateLatestWorspaceNames(File latest){
    	if(latestWorkspaces.contains(new WorkspaceMenuItem(latest))){
    		latestWorkspaces.remove(new WorkspaceMenuItem(latest)); 
    		
    	}
    	
    	if(latestWorkspaces.size()>5){
    		for(int i = latestWorkspaces.size(); i > 5;i--){
    			latestWorkspaces.remove(i-1);
    		}
    	}
    	
    	for(int i = fileMenu.getItemCount()-2; 5 < i ; i--){
    		
    		fileMenu.remove(i-1);
    	}
    	
    	latestWorkspaces.add(0,new WorkspaceMenuItem(latest));
    	for(int i = 0; i < latestWorkspaces.size();i++){
    		prefs.put("LastWorkspace"+i, ((WorkspaceMenuItem)latestWorkspaces.get(i)).workspaceFile.getPath());
    		fileMenu.add((WorkspaceMenuItem)latestWorkspaces.get(i),i+5);
    	}
    	
    	
    	
    }

    
    /*-*************************Singleton Pattern "constructor"**********************/
    /**
     * Returns the sinlgeton instance of the MessageCenter.
     * @return The insatnce of the MessageCenter
     */
    static public MessageCenter instance() {
        if(null == _instance) {
            _instance = new MessageCenter(new String[]{});
        }
        return _instance;
    }
    
    /**
     * Gets the InternalFrameListener that can be used if a commponent wants to notify the
     * MessageCenter of an event.
     * @return The Framelistener to be notified.
     */
    public javax.swing.event.InternalFrameListener getFrameListener(){
        return commentFocusListener;
    }
    
    /**
     * Queries if the Visualiser plugin is available. 
     * @return True if the Visualiser plugin is available
     */
    public boolean isVisualizerAvailable(){
        return visualizerLoaded;
    }
    
    /**
     * Gets the instance of the Visualiser plugin.
     * @return The instance of the Visualiser, or null if it is not available.
     */
    public Object getVisualizerInstance(){
        if(visualizerLoaded)
            return visualizerInstance;
        else
            return null;
    }
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    private void initComponents() {//GEN-BEGIN:initComponents
        java.awt.GridBagConstraints gridBagConstraints;

        logPopupMenu = new javax.swing.JPopupMenu();
        clearSelectedMenuItem = new javax.swing.JMenuItem();
        clearLogMenuItem = new javax.swing.JMenuItem();
        jPanel2 = new javax.swing.JPanel();
        helpPanel = new javax.swing.JPanel();
        commentsPanelTitle = new javax.swing.JLabel();
        commentsCloseButton = new javax.swing.JButton();
        commentsTitleSeparator = new javax.swing.JSeparator();
        commentsClassLabel = new javax.swing.JLabel();
        usageCommentPanel = new javax.swing.JPanel();
        commentsScrollPane = new javax.swing.JScrollPane();
        usageCommentTextArea = new javax.swing.JTextArea();
        loaderCommentPanel = new javax.swing.JPanel();
        loaderCommentTextField = new javax.swing.JTextField();
        commentsSaveButton = new javax.swing.JButton();
        jSplitPane1 = new javax.swing.JSplitPane();
        desktopPane = new javax.swing.JDesktopPane();
        logPanel = new javax.swing.JPanel();
        logScrollPane = new javax.swing.JScrollPane();
        logTextArea = new javax.swing.JTextPane();
        centerMenuBar = new javax.swing.JMenuBar();
        fileMenu = new javax.swing.JMenu();
        dataBaseMenuItem = new javax.swing.JMenuItem();
        jSeparator1 = new javax.swing.JSeparator();
        loadWorkspaceMenuItem = new javax.swing.JMenuItem();
        saveWorkspaceMenuItem = new javax.swing.JMenuItem();
        jSeparator3 = new javax.swing.JSeparator();
        jSeparator4 = new javax.swing.JSeparator();
        quitMenuItem = new javax.swing.JMenuItem();
        toolsMenu = new javax.swing.JMenu();
        gcMenuItem = new javax.swing.JMenuItem();
        windowMenu = new javax.swing.JMenu();
        helpMenu = new javax.swing.JMenu();
        helpMenuItem = new javax.swing.JMenuItem();
        commentsCheckBoxMenuItem = new javax.swing.JCheckBoxMenuItem();
        jSeparator2 = new javax.swing.JSeparator();
        aboutMenuItem = new javax.swing.JMenuItem();

        clearSelectedMenuItem.setText("Clear Selected");
        clearSelectedMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                clearSelectedMenuItemActionPerformed(evt);
            }
        });

        logPopupMenu.add(clearSelectedMenuItem);

        clearLogMenuItem.setText("Clear All");
        clearLogMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                clearLogMenuItemActionPerformed(evt);
            }
        });

        logPopupMenu.add(clearLogMenuItem);

        helpPanel.setLayout(new java.awt.GridBagLayout());

        helpPanel.setMinimumSize(new java.awt.Dimension(100, 10));
        helpPanel.setPreferredSize(new java.awt.Dimension(200, 10));
        commentsPanelTitle.setBackground(javax.swing.UIManager.getDefaults().getColor("InternalFrame.activeTitleBackground"));
        commentsPanelTitle.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        commentsPanelTitle.setText("Comments");
        commentsPanelTitle.setToolTipText("Help and Usage Comments");
        commentsPanelTitle.setOpaque(true);
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        gridBagConstraints.ipady = 4;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        gridBagConstraints.weightx = 1.0;
        helpPanel.add(commentsPanelTitle, gridBagConstraints);

        commentsCloseButton.setText("X");
        commentsCloseButton.setToolTipText("Close Comments");
        commentsCloseButton.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(0, 0, 0)));
        commentsCloseButton.setMargin(new java.awt.Insets(2, 6, 2, 6));
        commentsCloseButton.setMaximumSize(new java.awt.Dimension(30, 20));
        commentsCloseButton.setMinimumSize(new java.awt.Dimension(30, 20));
        commentsCloseButton.setPreferredSize(new java.awt.Dimension(30, 20));
        commentsCloseButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                commentsCloseButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHEAST;
        helpPanel.add(commentsCloseButton, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        helpPanel.add(commentsTitleSeparator, gridBagConstraints);

        commentsClassLabel.setFont(new java.awt.Font("Dialog", 3, 12));
        commentsClassLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        commentsClassLabel.setText("No Class Selected");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        gridBagConstraints.insets = new java.awt.Insets(2, 0, 4, 0);
        helpPanel.add(commentsClassLabel, gridBagConstraints);

        usageCommentPanel.setLayout(new java.awt.BorderLayout(2, 2));

        usageCommentPanel.setBorder(new javax.swing.border.TitledBorder(null, "Usage Comment", javax.swing.border.TitledBorder.LEFT, javax.swing.border.TitledBorder.DEFAULT_POSITION));
        commentsScrollPane.setViewportView(usageCommentTextArea);

        usageCommentPanel.add(commentsScrollPane, java.awt.BorderLayout.CENTER);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.weightx = 1.0;
        gridBagConstraints.weighty = 1.0;
        helpPanel.add(usageCommentPanel, gridBagConstraints);

        loaderCommentPanel.setLayout(new java.awt.GridBagLayout());

        loaderCommentPanel.setBorder(new javax.swing.border.TitledBorder(null, "Loader Comment", javax.swing.border.TitledBorder.LEFT, javax.swing.border.TitledBorder.DEFAULT_POSITION));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        gridBagConstraints.weightx = 1.0;
        gridBagConstraints.insets = new java.awt.Insets(4, 4, 4, 4);
        loaderCommentPanel.add(loaderCommentTextField, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.gridheight = java.awt.GridBagConstraints.RELATIVE;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        helpPanel.add(loaderCommentPanel, gridBagConstraints);

        commentsSaveButton.setText("Save Comments");
        commentsSaveButton.setMargin(new java.awt.Insets(0, 4, 0, 4));
        commentsSaveButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                commentsSaveButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridwidth = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.gridheight = java.awt.GridBagConstraints.REMAINDER;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        gridBagConstraints.insets = new java.awt.Insets(0, 0, 0, 4);
        helpPanel.add(commentsSaveButton, gridBagConstraints);

        setTitle("messageCenter");
        setName("centerFrame");
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });

        jSplitPane1.setDividerLocation(this.getHeight()-24);
        jSplitPane1.setDividerSize(7);
        jSplitPane1.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);
        jSplitPane1.setResizeWeight(1.0);
        jSplitPane1.setContinuousLayout(true);
        jSplitPane1.setOneTouchExpandable(true);
        jSplitPane1.setPreferredSize(new java.awt.Dimension(800, 600));
        jSplitPane1.setTopComponent(desktopPane);

        logPanel.setLayout(new java.awt.GridBagLayout());

        logPanel.setBorder(new javax.swing.border.EtchedBorder(javax.swing.border.EtchedBorder.RAISED));
        logPanel.setMinimumSize(new java.awt.Dimension(10, 48));
        logPanel.setPreferredSize(new java.awt.Dimension(10, 48));
        logScrollPane.setMinimumSize(new java.awt.Dimension(26, 48));
        logScrollPane.setPreferredSize(new java.awt.Dimension(26, 48));
        logTextArea.setDocument(logDocument);
        logTextArea.setEditable(false);
        logTextArea.setPreferredSize(new java.awt.Dimension(7, 48));
        logTextArea.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                logTextAreaMouseClicked(evt);
            }
        });

        logScrollPane.setViewportView(logTextArea);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.weightx = 1.0;
        gridBagConstraints.weighty = 1.0;
        logPanel.add(logScrollPane, gridBagConstraints);

        jSplitPane1.setBottomComponent(logPanel);

        getContentPane().add(jSplitPane1, java.awt.BorderLayout.CENTER);

        fileMenu.setText("File");
        dataBaseMenuItem.setText("Preferences...");
        dataBaseMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                dataBaseMenuItemActionPerformed(evt);
            }
        });

        fileMenu.add(dataBaseMenuItem);

        fileMenu.add(jSeparator1);

        loadWorkspaceMenuItem.setText("Load Workspace");
        loadWorkspaceMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                loadWorkspaceMenuItemActionPerformed(evt);
            }
        });

        fileMenu.add(loadWorkspaceMenuItem);

        saveWorkspaceMenuItem.setText("Save Workspace as...");
        saveWorkspaceMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                saveWorkspaceMenuItemActionPerformed(evt);
            }
        });

        fileMenu.add(saveWorkspaceMenuItem);

        fileMenu.add(jSeparator3);

        fileMenu.add(jSeparator4);

        quitMenuItem.setText("Quit");
        quitMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                quitMenuItemActionPerformed(evt);
            }
        });

        fileMenu.add(quitMenuItem);

        centerMenuBar.add(fileMenu);

        toolsMenu.setText("Tools");
        gcMenuItem.setText("Garbage Collect");
        gcMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                gcMenuItemActionPerformed(evt);
            }
        });

        toolsMenu.add(gcMenuItem);

        centerMenuBar.add(toolsMenu);

        windowMenu.setText("Window");
        windowMenu.addMenuListener(new javax.swing.event.MenuListener() {
            public void menuCanceled(javax.swing.event.MenuEvent evt) {
            }
            public void menuDeselected(javax.swing.event.MenuEvent evt) {
            }
            public void menuSelected(javax.swing.event.MenuEvent evt) {
                windowMenuMenuSelected(evt);
            }
        });

        centerMenuBar.add(windowMenu);

        helpMenu.setText("Help");
        helpMenu.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                helpMenuActionPerformed(evt);
            }
        });

        helpMenuItem.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_F1, 0));
        helpMenuItem.setText("Help");
        helpMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                helpMenuItemActionPerformed(evt);
            }
        });

        helpMenu.add(helpMenuItem);

        commentsCheckBoxMenuItem.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_F1, java.awt.event.InputEvent.ALT_MASK));
        commentsCheckBoxMenuItem.setText("CheckBox");
        commentsCheckBoxMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                commentsCheckBoxMenuItemActionPerformed(evt);
            }
        });

        helpMenu.add(commentsCheckBoxMenuItem);

        helpMenu.add(jSeparator2);

        aboutMenuItem.setText("About");
        aboutMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                aboutMenuItemActionPerformed(evt);
            }
        });

        helpMenu.add(aboutMenuItem);

        centerMenuBar.add(helpMenu);

        setJMenuBar(centerMenuBar);

        pack();
    }//GEN-END:initComponents

    private void gcMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_gcMenuItemActionPerformed
        Runtime.getRuntime().gc();
    }//GEN-LAST:event_gcMenuItemActionPerformed

    private void saveWorkspaceMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_saveWorkspaceMenuItemActionPerformed

        javax.swing.JFileChooser chooser =
            new javax.swing.JFileChooser(prefs.get("LastDirectory", null));
            chooser.setDialogTitle("Save Workspace");
            javax.swing.filechooser.FileFilter filter =
            new javax.swing.filechooser.FileFilter() {
                public boolean accept(java.io.File f) {
                    if (f.isDirectory())
                        return true;
                    String ext = getExtension(f);
                    if (ext != null)
                        return ext.equalsIgnoreCase("wsp");
                    else
                        return false;
                }
                
                public String getDescription() {
                    return "Workspace";
                }
                
            };
            
            chooser.setFileFilter(filter);
            java.io.File selectedFile = null;
            int returnVal = chooser.showSaveDialog(this);
            if (returnVal == javax.swing.JFileChooser.APPROVE_OPTION) {
                
                selectedFile = chooser.getSelectedFile();
                if (selectedFile == null)
                    return;
                
                if (!getExtension(selectedFile).equalsIgnoreCase("wsp"))
                    selectedFile =
                    new java.io.File(
                    selectedFile.getParent(),
                    selectedFile.getName() + ".wsp");
                
                System.out.println("You chose to save into this file: " + selectedFile.getName());
                prefs.put("LastDirectory", selectedFile.getPath());
                updateLatestWorspaceNames(selectedFile);
                
                Document document = new Document();
                Element root = new Element("Workspace");
            	document.setRootElement(root);
            	
                Iterator keyIt = childWindowList.keySet().iterator();
                while(keyIt.hasNext()){
                	FrameMenuItem item = (FrameMenuItem)childWindowList.get(keyIt.next());

                	Element elem = new Element("Frame");
                    System.out.println(item.childFrame.getClass().getName());
                	elem.setAttribute("name",item.childFrame.getClass().getName());
                    elem.setAttribute("Position_X",Integer.toString(item.childFrame.getLocation().x));
                    elem.setAttribute("Position_Y",Integer.toString(item.childFrame.getLocation().y));
                    elem.setAttribute("Width",Integer.toString(item.childFrame.getSize().width));
                    elem.setAttribute("Height",Integer.toString(item.childFrame.getSize().height));
                    try{
                        elem.setAttribute("InitStr",((MessageCenterInternalFrame)(item.childFrame)).getInitStr());
                    }
                    catch(Exception e){
                    	elem.setAttribute("InitStr",new String());
                    }
                    root.addContent(elem);
                    
                        
                }
                XMLOutputter outputter = new XMLOutputter();
                outputter.setIndent("  "); // use two space indent
                outputter.setNewlines(true);
                
                try {
                    outputter.output(document,new java.io.FileOutputStream(selectedFile));
                }
                catch (IOException e) {
                    System.err.println(e);
                }

            }
    	
    }//GEN-LAST:event_saveWorkspaceMenuItemActionPerformed

    private void loadWorkspaceMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_loadWorkspaceMenuItemActionPerformed
        javax.swing.JFileChooser chooser = new javax.swing.JFileChooser();
        chooser.setDialogTitle("Open Workspace");
        javax.swing.filechooser.FileFilter filter = new javax.swing.filechooser.FileFilter(){
            public boolean accept(java.io.File f){
                if(f.isDirectory())
                    return true;
                String ext = getExtension(f);
                if(ext != null)
                    return ext.equalsIgnoreCase("wsp");
                else
                    return false;
            }
            
            public String getDescription(){
                return "Workspace files(.wsp)";
            }
            
        };
        
        chooser.setFileFilter(filter);
        java.io.File selectedFile = null;
        int returnVal = chooser.showOpenDialog(this);
        if(returnVal == javax.swing.JFileChooser.APPROVE_OPTION) {
            
            selectedFile = chooser.getSelectedFile();
            if (selectedFile ==null)
                return;
            
            if(!getExtension(selectedFile).equalsIgnoreCase("wsp")){
                System.out.println("Cannot import choosen file: " +selectedFile.getName());
                return;
            }
            prefs.put("LastDirectory", selectedFile.getPath());
            
            updateLatestWorspaceNames(selectedFile);
			
            loadWorkspaceFile(selectedFile);
            
        }
    }//GEN-LAST:event_loadWorkspaceMenuItemActionPerformed
    
	private synchronized void loadWorkspaceFile(java.io.File selectedFile) {
		//Clear Old Frames
		HashSet windowsOpen = new HashSet(childWindowList.keySet());
		Iterator keyIt = windowsOpen.iterator();
		while(keyIt.hasNext()){
			FrameMenuItem item = (FrameMenuItem)childWindowList.get(keyIt.next());
			if(item.childFrame.equals(appLoader) || item.equals(serialConnectorMenuItem))
				continue;
			try{
				item.childFrame.setClosed(true);
			}catch(java.beans.PropertyVetoException pve){}
		}
		
		//Load frames from the workspace file
		try{
		    
		    SAXBuilder builder = new SAXBuilder();
		    Document xmlDoc = builder.build(selectedFile);
		    // If there are no well-formedness errors,
		    // then no exception is thrown
		    Element elementRoot =  xmlDoc.getRootElement();
		    
		    List childElements = elementRoot.getChildren("Frame");
		    Iterator childIt = childElements.iterator();
		    while (childIt.hasNext()){
		        Element childElement = (Element) childIt.next();
		     
		        
		        String name = childElement.getAttribute("name").getValue();

		        JInternalFrame internalFrame = null;
		        
		        if(name.equalsIgnoreCase(AppLoader.class.getName())){
		        	internalFrame = this.appLoader;
		        }else if(name.equalsIgnoreCase(SerialConnector.class.getName())){
		        	internalFrame = SerialConnector.instance();
		        }else{
		        	internalFrame = (JInternalFrame)(((AppLoader)appLoader).startModule(name)); 
		        	System.out.println(name);
		        }
		        
		        if(internalFrame == null) continue;
		        
		    	int x =Integer.parseInt(childElement.getAttribute("Position_X").getValue());
		    	int y =Integer.parseInt(childElement.getAttribute("Position_Y").getValue());
		    	internalFrame.setLocation(x,y);
		    	int width = Integer.parseInt(childElement.getAttribute("Width").getValue());
		    	int height = Integer.parseInt(childElement.getAttribute("Height").getValue());
		    	internalFrame.setSize(width,height);
		    	try{
		    		String initSequence = childElement.getAttribute("InitStr").getValue();
		    		((MessageCenterInternalFrame)internalFrame).initFromStr(initSequence);
		    	}
		    	catch(Exception e){
		    		System.out.println("Old workspace file!");
		    	}
		    }
		    
		    
		}
		// indicates a well-formedness error
		catch (JDOMException e) {
		    System.out.println(selectedFile + " is not well-formed.");
		    System.out.println(e.getMessage());
		}catch( java.io.FileNotFoundException fnfe){
		    System.err.println("Cannot open file: "+selectedFile.getAbsolutePath());
		    
		}catch( java.io.IOException ioe){
		    System.err.println("Cannot read file: "+selectedFile.getAbsolutePath());
		    System.out.println("Could not check " + selectedFile+ " because " + ioe.getMessage());
		}
	}

	private void commentsSaveButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_commentsSaveButtonActionPerformed
        
        commentStorage = prefs.node(prefs.absolutePath()+"/Comments/"+commentsClassLabel.getText());
        commentStorage.put("loaderComment",loaderCommentTextField.getText());
        commentStorage.put("usageComment",usageCommentTextArea.getText());
        
    }//GEN-LAST:event_commentsSaveButtonActionPerformed
    
    private void commentsCloseButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_commentsCloseButtonActionPerformed
        if(commentsCheckBoxMenuItem.isSelected()){
            commentsCheckBoxMenuItem.setSelected(false);
            getContentPane().remove(helpPanel);
            
        }else{
            commentsCheckBoxMenuItem.setSelected(true);
            getContentPane().add(helpPanel, java.awt.BorderLayout.EAST);
        }
        validate();
    }//GEN-LAST:event_commentsCloseButtonActionPerformed
    
    private void commentsCheckBoxMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_commentsCheckBoxMenuItemActionPerformed
        if(commentsCheckBoxMenuItem.isSelected()){
            getContentPane().add(helpPanel, java.awt.BorderLayout.EAST);
            
        }else{
            getContentPane().remove(helpPanel);
        }
        
        validate();
    }//GEN-LAST:event_commentsCheckBoxMenuItemActionPerformed
    
    private void helpMenuActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_helpMenuActionPerformed
        // Add your handling code here:
    }//GEN-LAST:event_helpMenuActionPerformed
    
    private void clearSelectedMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_clearSelectedMenuItemActionPerformed
        
        int selectionStart = logTextArea.getSelectionStart();
        int selectionLength =  logTextArea.getSelectionEnd() - selectionStart;
        try{
            logDocument.remove(selectionStart, selectionLength);
        }catch (javax.swing.text.BadLocationException be){
        }
    }//GEN-LAST:event_clearSelectedMenuItemActionPerformed
    
    private void logTextAreaMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_logTextAreaMouseClicked
        if(evt.getButton() == java.awt.event.MouseEvent.BUTTON3)
            logPopupMenu.show(evt.getComponent(), evt.getX(), evt.getY());
        
        
    }//GEN-LAST:event_logTextAreaMouseClicked
    
    private void clearLogMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_clearLogMenuItemActionPerformed
        try{
            logDocument.remove(0, logDocument.getLength());
        }catch (javax.swing.text.BadLocationException be){}
        
    }//GEN-LAST:event_clearLogMenuItemActionPerformed
    
    private void aboutMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_aboutMenuItemActionPerformed
        JOptionPane.showMessageDialog(this,"                The Message Center\nInstitute of Software Integrated Systems\n           Vanderbilt University 2003,2004","About",JOptionPane.INFORMATION_MESSAGE);
    }//GEN-LAST:event_aboutMenuItemActionPerformed
    
    private void helpMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_helpMenuItemActionPerformed
        javax.swing.JOptionPane.showMessageDialog(this,    "The answers are comming!");
        
    }//GEN-LAST:event_helpMenuItemActionPerformed
    
    private void quitMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_quitMenuItemActionPerformed
        System.exit(0);
    }//GEN-LAST:event_quitMenuItemActionPerformed
    
    private void dataBaseMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_dataBaseMenuItemActionPerformed
        DatabaseConfigDialog configDialog = new DatabaseConfigDialog(this,true);
        configDialog.setLocationRelativeTo(this);
        configDialog.show();
    }//GEN-LAST:event_dataBaseMenuItemActionPerformed
    
	private void windowMenuMenuSelected(javax.swing.event.MenuEvent evt) {//GEN-FIRST:event_windowMenuMenuSelected
            java.util.Enumeration internalFrames = childWindowList.keys();
            while (internalFrames.hasMoreElements()){
                javax.swing.JInternalFrame internalFrame = (javax.swing.JInternalFrame)internalFrames.nextElement();
                FrameMenuItem menuItem = (FrameMenuItem)childWindowList.get(internalFrame);
                menuItem.setText(internalFrame.getTitle());
            }
	}//GEN-LAST:event_windowMenuMenuSelected
        
        /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_exitForm
        System.exit(0);
    }//GEN-LAST:event_exitForm
    
    /**
     * main
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /*JDialog.setDefaultLookAndFeelDecorated(true);
        JFrame.setDefaultLookAndFeelDecorated(true);
        
        Toolkit.getDefaultToolkit().setDynamicLayout(true);
        System.setProperty("sun.awt.noerasebackground","true"); 
        try {
            javax.swing.plaf.metal.MetalLookAndFeel.setCurrentTheme( new javax.swing.plaf.metal.DefaultMetalTheme());
            UIManager.setLookAndFeel("javax.swing.plaf.metal.MetalLookAndFeel");
        }  
        catch ( UnsupportedLookAndFeelException e ) {
            System.out.println ("Metal Look & Feel not supported on this platform. \nProgram Terminated");
            System.exit(0);
        }
        catch ( IllegalAccessException e ) {
            System.out.println ("Metal Look & Feel could not be accessed. \nProgram Terminated");
            System.exit(0);
        }
        catch ( ClassNotFoundException e ) {
            System.out.println ("Metal Look & Feel could not found. \nProgram Terminated");
            System.exit(0);
        }   
        catch ( InstantiationException e ) {
            System.out.println ("Metal Look & Feel could not be instantiated. \nProgram Terminated");
            System.exit(0);
        }
        catch ( Exception e ) {
            System.out.println ("Unexpected error. \nProgram Terminated");
            e.printStackTrace();
            System.exit(0);
        } */
        new MessageCenter(args).show();
         
        
    }
    
    protected void appendToLog(String str,Style s){
        try{
            logDocument.insertString(logDocument.getLength(),str,s) ;
            if( str.endsWith("\n")){
                int height = logTextArea.getHeight();
                if(!vScrollBar.getValueIsAdjusting()){
                    vScrollBar.setValue(vScrollBar.getMaximum());
                }
            }
        }catch( javax.swing.text.BadLocationException ble){
            //System.out.println(ble.getMessage());
        }
    }
    
    private String getExtension(java.io.File f) {
        String ext = null;
        String s = f.getName();
        int i = s.lastIndexOf('.');
        
        if (i == -1)
            return "";
        
        if (i > 0 && i < s.length() - 1) {
            ext = s.substring(i + 1).toLowerCase();
        }
        return ext;
    }
    
    protected SerialConnector serialConnector;
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JMenuItem aboutMenuItem;
    private javax.swing.JMenuBar centerMenuBar;
    private javax.swing.JMenuItem clearLogMenuItem;
    private javax.swing.JMenuItem clearSelectedMenuItem;
    private javax.swing.JCheckBoxMenuItem commentsCheckBoxMenuItem;
    private javax.swing.JLabel commentsClassLabel;
    private javax.swing.JButton commentsCloseButton;
    private javax.swing.JLabel commentsPanelTitle;
    private javax.swing.JButton commentsSaveButton;
    private javax.swing.JScrollPane commentsScrollPane;
    private javax.swing.JSeparator commentsTitleSeparator;
    private javax.swing.JMenuItem dataBaseMenuItem;
    private javax.swing.JDesktopPane desktopPane;
    private javax.swing.JMenu fileMenu;
    private javax.swing.JMenuItem gcMenuItem;
    private javax.swing.JMenu helpMenu;
    private javax.swing.JMenuItem helpMenuItem;
    private javax.swing.JPanel helpPanel;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JSeparator jSeparator1;
    private javax.swing.JSeparator jSeparator2;
    private javax.swing.JSeparator jSeparator3;
    private javax.swing.JSeparator jSeparator4;
    private javax.swing.JSplitPane jSplitPane1;
    private javax.swing.JMenuItem loadWorkspaceMenuItem;
    private javax.swing.JPanel loaderCommentPanel;
    private javax.swing.JTextField loaderCommentTextField;
    private javax.swing.JPanel logPanel;
    private javax.swing.JPopupMenu logPopupMenu;
    private javax.swing.JScrollPane logScrollPane;
    private javax.swing.JTextPane logTextArea;
    private javax.swing.JMenuItem quitMenuItem;
    private javax.swing.JMenuItem saveWorkspaceMenuItem;
    private javax.swing.JMenu toolsMenu;
    private javax.swing.JPanel usageCommentPanel;
    private javax.swing.JTextArea usageCommentTextArea;
    private javax.swing.JMenu windowMenu;
    // End of variables declaration//GEN-END:variables
    
    /*-****************************Add Child Window IF *************************/
    
    /**
     * Adds a new InternalFrame based application to the MessageCenter.
     * @param newChildFrame The new InternalFrame to be added.
     */
    public void registerChildFrame(javax.swing.JInternalFrame newChildFrame){
        FrameMenuItem menuItem = new FrameMenuItem(newChildFrame);
        childWindowList.put(newChildFrame,menuItem);
        this.windowMenu.add(menuItem);
        desktopPane.add(newChildFrame);
        newChildFrame.setVisible(true);
        
        
    }
    
    /**
     * Removes an InternalFrame based application from the MessageCenter.
     * @param oldChildFrame The InternalFrame to be removed.
     */    
    public void removeChildFrame(javax.swing.JInternalFrame oldChildFrame){
        oldChildFrame.setVisible(false);
        this.windowMenu.remove((FrameMenuItem)childWindowList.get(oldChildFrame));
        desktopPane.remove(oldChildFrame);
        childWindowList.remove(oldChildFrame);
        
        
    }
    /**
     * Detaches an InternalFrame based application from the main viewing area
     *  of the MessageCenter and displays it in a separate window.
     * @param childFrame The  InternalFrame to be detached.
     */    
    public void detachChildFrame(javax.swing.JInternalFrame childFrame){
        this.windowMenu.remove((FrameMenuItem)childWindowList.get(childFrame));
        FrameMenuItem menuItem = new FrameMenuItem(childFrame);
        childWindowList.put(childFrame,menuItem);
        this.windowMenu.add(menuItem);
        childFrame.setVisible(false);
        desktopPane.remove(childFrame);
    }
    
    /**
     * Attaches an InternalFrame based application back to the main viewing area
     *  of the MessageCenter from a separate window.
     * @param childFrame The  InternalFrame to be attached back to the main area.
     */ 
    public void attachChildFrame(javax.swing.JInternalFrame childFrame){
        this.windowMenu.remove((FrameMenuItem)childWindowList.get(childFrame));
        FrameMenuItem menuItem = new FrameMenuItem(childFrame);
        childWindowList.put(childFrame,menuItem);
        this.windowMenu.add(menuItem);
        desktopPane.add(childFrame);
        childFrame.setVisible(true);
    }
    
    private class CommentFocusListener extends javax.swing.event.InternalFrameAdapter{
        
        
        /* (non-Javadoc)
         * @see javax.swing.event.InternalFrameListener#internalFrameActivated(javax.swing.event.InternalFrameEvent)
         */
        public void internalFrameActivated(javax.swing.event.InternalFrameEvent e){
            String className = e.getSource().getClass().getName();
            commentsClassLabel.setText(className);
            commentStorage = prefs.node(prefs.absolutePath()+"/Comments/"+className);
            loaderCommentTextField.setText(commentStorage.get("loaderComment",""));
            usageCommentTextArea.setText(commentStorage.get("usageComment",""));
        }
    }
    
    private class AppendFunction implements Runnable{
        
        String toAppend;
        Style withStyle;
        
        public AppendFunction(String str,Style s){
            toAppend = str;
            withStyle = s;
        }
        
        /* (non-Javadoc)
         * @see java.lang.Runnable#run()
         */
        public void run() {
            appendToLog(toAppend,withStyle);
        }
    }
    
    
    private class DocumentLogger extends java.io.OutputStream{
        Style s = null;
        String line = "";
        
        public DocumentLogger(Style s){
            this.s = s;
        }
        
        /* (non-Javadoc)
         * @see java.io.OutputStream#write(int)
         */
        public void write(int b) throws java.io.IOException {
            line += String.valueOf((char)b);
            if( ((char)b) == '\n'){
                if(SwingUtilities.isEventDispatchThread()){
                    appendToLog(line,s);
                }else{
                    SwingUtilities.invokeLater(new AppendFunction(line,s));
                }
                line = new String("");
            }
        }
    }
    
    
    private class SynchronizedScrollBar extends javax.swing.JScrollBar{
        
        /* (non-Javadoc)
         * @see java.awt.Adjustable#setValue(int)
         */
        public void setValue(int value){
            synchronized(this) {
                System.err.println("sync-start " + System.identityHashCode(Thread.currentThread()));
                super.setValue(value);
                System.err.println("sync-end " + System.identityHashCode(Thread.currentThread()));
            }
        }
    }
    
    
    /********************************* Inner Classes **************************/
    
    private class FrameMenuItem extends javax.swing.JMenuItem{
        
        public javax.swing.JInternalFrame childFrame;
        
        public FrameMenuItem(javax.swing.JInternalFrame newChildFrame){
            super(newChildFrame.getTitle());
            this.childFrame = newChildFrame;
            
            this.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    
                    ((MessageCenterInternalFrame)childFrame).focus();
                    
                }
            });
        }
    }
    
    private class WorkspaceMenuItem extends javax.swing.JMenuItem{
    	public File workspaceFile;
    	
    	public WorkspaceMenuItem(File workspaceFile){
    		super(workspaceFile.getName());
    		this.workspaceFile = workspaceFile;
    		this.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                	loadWorkspaceFile(WorkspaceMenuItem.this.workspaceFile);
                }
            });
    	}
    	
    
		/* (non-Javadoc)
		 * @see java.lang.Object#equals(java.lang.Object)
		 */
		public boolean equals(Object obj) {
			if(obj instanceof WorkspaceMenuItem){
				return workspaceFile.equals(((WorkspaceMenuItem)obj).workspaceFile);
			}
			return false;
		}
    }
    
    /**
     * This class listens for UISwitches, and updates a given component.
     *
     * @version 1.8 01/23/03
     * @author Steve Wilson
     */
   public class UISwitchListener implements PropertyChangeListener {
       JComponent componentToSwitch;

       public UISwitchListener(JComponent c) {
           componentToSwitch = c;
       }

       public void propertyChange(PropertyChangeEvent e) {
           String name = e.getPropertyName();
   	if (name.equals("lookAndFeel")) {
   	    SwingUtilities.updateComponentTreeUI(componentToSwitch);
   	    componentToSwitch.invalidate();
   	    componentToSwitch.validate();
   	    componentToSwitch.repaint();
   	}
       }
   } 
    
   /**
    * This class describes a theme using "green" colors.
    *
    * @version 1.9 01/23/03
    * @author Steve Wilson
    */
   public class LAFMenu extends JMenu implements ActionListener{

     MetalTheme[] themes;
     public LAFMenu(String name, MetalTheme[] themeArray) {
       super(name);
       themes = themeArray;
       ButtonGroup group = new ButtonGroup();
       for (int i = 0; i < themes.length; i++) {
           JRadioButtonMenuItem item = new JRadioButtonMenuItem( themes[i].getName() );
   	group.add(item);
           add( item );
   	item.setActionCommand(i+"");
   	item.addActionListener(LAFMenu.this);
   	if ( i == 0)
   	    item.setSelected(true);
       }

     }

     public void actionPerformed(ActionEvent e) {
       String numStr = e.getActionCommand();
       MetalTheme selectedTheme = themes[ Integer.parseInt(numStr) ];
       MetalLookAndFeel.setCurrentTheme(selectedTheme);
       try {
   	UIManager.setLookAndFeel("javax.swing.plaf.metal.MetalLookAndFeel");
       } catch (Exception ex) {
           System.out.println("Failed loading Metal");
   	System.out.println(ex);
       }

     }

   } 
    
}
