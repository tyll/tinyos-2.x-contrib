// $Id$

/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */


/**
 * @author Wei Hong
 */

//**************************************************************************
//**************************************************************************
//This class is used to display data on the StandardDialog or Tabbed Dialog class.   Essentially,
//all node/edgeClickListeners return an object of  type ActivePanel with the function
//GetProprietaryNode/EdgeInfoPanel(), which is called every time a node/edge
//is clicked.  Each of the ActivePanels is successively added to the tabbedPane
//on the TabbedDialog.  That way, we can plug-and-play PacketAnalyzers and not have to worry about
//updating the display code.  Each Packet Analyzer carries its display info
//with him in the form of an Active Panel
//**************************************************************************
//**************************************************************************
//This is how the function GetProprietaryNodeInfoPanel() works:
// 1.  if GetProprietaryNodeInfoPanel() returns null, that PacketAnalyzer 
//	will not have any information displayed on the PropertyDialog
// 2.  if GetProprietaryNodeInfoPanel() returns an ActivePanel with
//	the variable cancelInfoDialog set to TRUE, the PropertyDialog will
//	not be displayed at all, for any packetAnalyzer.
// 3.  If GetProprietaryNodeInfoPanel() returns a valid ActivePanel, it will
//	be displayed as a panel on it's own tab in the JTabbedPane of the 
//	PropertyDialog.  The tab with be set with tabTitle.
//**************************************************************************
//**************************************************************************
//The gist of an active panel is:
// 1.  It has a variable cancelInfoDialog which cancels the displaying of
//	the entire PropertyDialog
// 2.  It has a variable tabTitle, which will be the name on the tab
//	which displays this ActivePanel
// 3.  The Active Panel itself is a JPanel, which will be displayed on a separate
//	tab on the PropertyDialog
// 4.  It has a function UpdateDisplayVariables, which sets the components
//	on the panel to their apropriate values.  This is called to initialize
//	the panel 
// 5.	 It has a function Apply Changes which should take the values on the
//	components and assign them to the variables to which they correspond.
//	This function is called when the "Apply" button is hit on the dialog.
//**************************************************************************
//**************************************************************************
//A good way to create one of these is to create the display using visual cafe
//or some other editor.  Then copy the code into you packet analyzer class,
//write the InitializeDisplayValues and ApplyChanges functions, and you are done.
//You should probably pass the node/edgeInfo class into the active Panel in 
//the constructor to facilitate the InitializeDisplayValues and ApplyChanges functions.
//You also may want to run the Active Panel as a seperate thread to continuously
//update the values in the display as the network runs and the values change.
//**************************************************************************
//**************************************************************************
//If you want actions to be performed immediately when the user changes the value
//of a component on the display, use the ActionPerformed, ItemStateChanged, and
//StateChanged functions to handle events generated from the components
//**************************************************************************
//**************************************************************************

package monitor.Dialog;


import java.awt.event.*;
import javax.swing.event.*;
import java.awt.*;
              
              
public class ActivePanel extends javax.swing.JPanel implements java.awt.event.ActionListener, java.awt.event.ItemListener, javax.swing.event.ChangeListener  
{
	protected boolean modal = true;//use this to decide if the dialog that this active panel will be displayed in will be modal or not (only works for StandardDialog)
	protected boolean cancelInfoDialog = false;//set this variable to true only if you want to intercept the mouse click and don't want a node/edge properties dialog to appear for that mouse click
	protected String tabTitle = "No Title";//set this variable to the name of the tab that this panel will be displayed on
	
   //----------------------------------------------------------------------
   //CONSTRUCTOR
	public ActivePanel()
	{
              //initialize the panel
              
		//{{INIT_CONTROLS
		setLayout(null);
		Insets ins = getInsets();
		setSize(ins.left + ins.right + 430,ins.top + ins.bottom + 270);
		//}}

		//{{REGISTER_LISTENERS
		//}}
	}
              //CONSTRUCTOR
              //----------------------------------------------------------------------


	//{{DECLARE_CONTROLS
	//}}

              //----------------------------------------------------------------------
              //ACITON PERFORMED
              //the following method should be used to act upon actions of the components
    public void actionPerformed(ActionEvent e)
    {
        // This method is derived from interface java.awt.event.ActionListener
        // to do: code goes here
    }
              //ACITON PERFORMED
              //----------------------------------------------------------------------


              //----------------------------------------------------------------------
              //ITEM STATE CHANGED
              //the following method should be used to act upon item changes of the components
    public void itemStateChanged(ItemEvent e)
    {
        // This method is derived from interface java.awt.event.ItemListener
        // to do: code goes here
    }
              //ITEM STATE CHANGED
              //----------------------------------------------------------------------


              //----------------------------------------------------------------------
              //STATE CHANGED
              //the following method should be used to act upon state changes of the components
    public void stateChanged(ChangeEvent e)
    {
        // This method is derived from interface javax.swing.event.ChangeListener
        // to do: code goes here
    }
              //STATE CHANGED
              //----------------------------------------------------------------------

    
              //----------------------------------------------------------------------
              //APPLY CHANGES
              //the following method should be used to apply the values set in the dialog
	public void ApplyChanges()
	{
		      //this function is called when the user clicks the "Apply" button
		      //on the dialog in which this Active Panel is displayed.
		      //It should apply the values of the display components
		      //to the variables they represent
	}
              //APPLY CHANGES
              //----------------------------------------------------------------------

	
              //----------------------------------------------------------------------
              //UPDATE DISPLAY VALUES
              //the following method should be used to initialize the display values 
	public void InitializeDisplayValues()
	{
		      //This function is called by a thread that runs in the background
		      //and updates the values of the Active Panels so they are always
		      //up to date.
	}
              //UPDATE DISPLAY VALUES
              //----------------------------------------------------------------------


              //----------------------------------------------------------------------
              //GET/SET FUNCTIONS
	public boolean GetModal(){return modal;}
	public boolean GetCancelInfoDialog(){return cancelInfoDialog;}
	public String GetTabTitle(){return tabTitle;}
	public void SetCancelInfoDialog(boolean p){cancelInfoDialog = p;}
	public void SetModal(boolean p){modal= p;}
	public void SetTabTitle(String p){tabTitle =p;}
              //GET/SET FUNCTIONS
              //----------------------------------------------------------------------
}
