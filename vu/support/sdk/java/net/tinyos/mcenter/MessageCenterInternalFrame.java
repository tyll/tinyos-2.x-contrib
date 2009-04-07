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

import javax.swing.event.InternalFrameEvent;

/**
 *	The MessageCenterInternalFrame is the main building block of the 
 *	MessageCenter applications. It provides the functionlaity to
 *	interoperate with the MessageCenter framework.     
 * @author  Andras Nadas
 */
public class MessageCenterInternalFrame extends javax.swing.JInternalFrame{
    
	static final long serialVersionUID = 0;
    protected MessageCenterInternalFrame frameInstance;
    private MessageCenterOuterFrame outerFrame = null;
    protected static int row = 0;
    protected static int column = 0;
    
    protected final static int translateX = 36;
    protected final static int translateY = 24;
    
    
    /**
     * Creates a new instance of messageCenterInternalFrame with a given title.
     * @param title The name of the InternalFrame.
     */
    public MessageCenterInternalFrame(String title) {
        this.title = title;
        initInstance();
    }
    
    
    /**
     * Creates a new instance of messageCenterInternalFrame with a default title.
     */
    public MessageCenterInternalFrame() {
        this.title = "Unnamed InternalFrame";
        initInstance();
    }
    
    public void initFromStr(String initString){
    }
    
    public String getInitStr(){
    	return new String();
    }
    
    private void initInstance(){
        frameInstance = this;
        
        MessageCenter.instance().registerChildFrame(this);
        setIconifiable(true);
        setMaximizable(true);
        setClosable(true);
        setResizable(true);
        this.addInternalFrameListener(new javax.swing.event.InternalFrameAdapter(){
            public void internalFrameClosing(javax.swing.event.InternalFrameEvent e){
                MessageCenter.instance().removeChildFrame(frameInstance);
                SerialConnector.instance().removePacketListener(frameInstance);
            }
            
            /**
             * Invoked when an internal frame is activated.
             */
            public void internalFrameActivated(InternalFrameEvent e) {
            	MessageCenterInternalFrame.this.focusGained();
            }

            /**
             * Invoked when an internal frame is de-activated.
             */
            public void internalFrameDeactivated(InternalFrameEvent e) {
            	MessageCenterInternalFrame.this.focusLost();
            }
            
        });
        synchronized(this){
            if(((row+1)*translateY) > this.getDesktopPane().getSize().height){
                row = 0;
                column++;
            }
            this.setLocation((row+column) * translateX,row * translateY);
            row++;
            
        }
        
        addInternalFrameListener(MessageCenter.instance().getFrameListener());
        
        /*((java.awt.Component)this).addMouseListener(new java.awt.event.MouseAdapter(){
            public void mouseClicked(java.awt.event.MouseEvent e){
                System.out.println(e.getPoint());
            }
            
            
        });*/
        
    }
    
    /**
     * Detaches the content of the internal frame, and puts it into a separate Window.
     * (Experimental function) 
     */
    protected void detach(){
        System.out.println("Detach requested");
        if(outerFrame != null) return;
        MessageCenter.instance().detachChildFrame(frameInstance);
        outerFrame = new MessageCenterOuterFrame(frameInstance);
        outerFrame.show();
        
        //MessageCenter.instance().removeChildFrame(frameInstance);
        
    }
    /**
     * Attaches the content of the internal frame, form a detached separate Window.
     * (Experimental function) 
     */    
    protected void attach(){
        
        if(outerFrame == null) return;
        frameInstance.setRootPane(outerFrame.getRootPane());
        outerFrame.close();
        outerFrame = null;
        MessageCenter.instance().attachChildFrame(frameInstance);
    }
    
    /**
     * Request the current InternalFrame to get the focus.
     * (Experimental function) 
     */
    public void focus(){
        if(outerFrame == null){
            try{
                
                setSelected(true);
                moveToFront();
                if(isIcon())
                    setIcon(false);
            }catch(java.beans.PropertyVetoException pve){}
            fireInternalFrameEvent(javax.swing.event.InternalFrameEvent.INTERNAL_FRAME_ACTIVATED);
        }else{
            outerFrame.toFront();
            outerFrame.requestFocus();
        }
    }
    
    /**
     * Focus gained notification method. To be implemented by the siblings.
     * (Experimental function)
     */
    protected void focusGained(){}
    
    /**
     * Focus lost notification method. To be implemented by the siblings.
     *  (Experimental function)
     */
    protected void focusLost(){}
    
}
