/*
 * "Copyright (c) 2001 and The Regents of the University
 * of California.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice and the following
 * two paragraphs appear in all copies of this software.
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
 * $\Id$
 */

import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
import java.sql.Time;
import java.sql.Date;
import java.sql.Timestamp;

public class ClientWindow extends JPanel implements WindowListener
{
  JFrame        myFrame       = null;
  final short DEFAULT_NODE_ID = 0;
  RequestReading listener  = null;

  JScrollPane   msgPanel      = new JScrollPane();
  JTextArea     msgWndw       = new JTextArea();

  JPanel        panelButton   = new JPanel();
  JCheckBox     cbCounter     = new JCheckBox();
  JCheckBox     cbVoltage     = new JCheckBox();
  JCheckBox     cbTemperature = new JCheckBox();
  JLabel        labelNodeid   = new JLabel();
  JTextField    fieldNodeid   = new JTextField();
  JButton       bSendRequest  = new JButton();

  ActionListener cbal = new ActionListener() {
    public void actionPerformed(ActionEvent e) {
      updateGlobals();
    }
  };

  void updateGlobals() {
    RequestReading.bCounter = cbCounter.isSelected();
    RequestReading.bVoltage = cbVoltage.isSelected();
    RequestReading.bTemperature = cbTemperature.isSelected();
  }

  public ClientWindow(JFrame frame) {
    try {
      myFrame = frame;
      jbInit();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  private void jbInit() throws Exception {

    this.setLayout(new BorderLayout());
    this.setMinimumSize(new Dimension(200, 400));
    this.setPreferredSize(new Dimension(600, 400));

    msgPanel.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
    msgPanel.setAutoscrolls(true);
    msgWndw.setFont(new java.awt.Font("Courier", 0, 12));
    msgPanel.getViewport().add(msgWndw, null);

    panelButton.setLayout(new GridLayout(7, 1) );
    panelButton.setMinimumSize(new Dimension(100, 170));
    panelButton.setPreferredSize(new Dimension(160, 170));

    cbCounter.setSelected(RequestReading.bCounter);
    cbCounter.setText("Read Counter");
    cbCounter.setFont(new java.awt.Font("Dialog", 1, 10));
    cbCounter.addActionListener(cbal);

    cbVoltage.setSelected(RequestReading.bVoltage);
    cbVoltage.setText("Read Voltage");
    cbVoltage.setFont(new java.awt.Font("Dialog", 1, 10));
    cbVoltage.addActionListener(cbal);

    cbTemperature.setSelected(RequestReading.bTemperature);
    cbTemperature.setText("Read Temperature");
    cbTemperature.setFont(new java.awt.Font("Dialog", 1, 10));
    cbTemperature.addActionListener(cbal);

    labelNodeid.setFont(new java.awt.Font("Dialog", 1, 10));
    labelNodeid.setText("node id:");
    fieldNodeid.setFont(new java.awt.Font("Dialog", 1, 10));
    fieldNodeid.setText(" ");

    panelButton.add(cbCounter, null);
    panelButton.add(cbVoltage, null);
    panelButton.add(cbTemperature, null);

    panelButton.add(labelNodeid, null);
    panelButton.add(fieldNodeid, null);
    fieldNodeid.setText(Short.toString(DEFAULT_NODE_ID));
    panelButton.add(bSendRequest, null);
    bSendRequest.addActionListener(new java.awt.event.ActionListener()
    {
       public void actionPerformed(ActionEvent e)
       {
           bSendRequest_actionPerformed(e);
       }
    });
    bSendRequest.setText("Send Request");
    bSendRequest.setFont(new java.awt.Font("Dialog", 1, 10));

    this.add(msgPanel, BorderLayout.CENTER);
    this.add(panelButton, BorderLayout.EAST);
  }

  public synchronized void windowClosing ( WindowEvent e )
  {
    System.exit(1);
  }

  public void windowClosed      ( WindowEvent e ) { }
  public void windowActivated   ( WindowEvent e ) { }
  public void windowIconified   ( WindowEvent e ) { }
  public void windowDeactivated ( WindowEvent e ) { }
  public void windowDeiconified ( WindowEvent e ) { }
  public void windowOpened      ( WindowEvent e ) { }

  public short getNodeid()
  {
    short n;
    try {
      n = Short.parseShort( fieldNodeid.getText() );
    }
    catch (NumberFormatException exception) {
      fieldNodeid.setText("0");
      n = 0;
    }
    return n;
  }

  void bSendRequest_actionPerformed(ActionEvent e)
  {
    // send a request packet
    RequestReading.sendRequest(getNodeid());
  }

  public void printMessage(String str) 
  {
    msgWndw.append(str);
  }

}
